//------------------------------------------------------------------------
//  LEVEL building - QUAKE II format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_pak.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"
#include "q2_structs.h"

#include "csg_main.h"
#include "csg_quake.h"

#include "ui_chooser.h"


#define LEAF_PADDING   4
#define NODE_PADDING   16
#define MODEL_PADDING  24.0


static char *level_name;
static char *description;


// IMPORTANT!! Quake II assumes axis-aligned node planes are positive
//  if (raw_nd.planenum & 1)
//  {
//    node->Flip();
//    raw_nd.planenum ^= 1;
//  }


static void Q2_GetExtents(double min_s, double min_t,
                          double max_s, double max_t,
                          int *ext_W, int *ext_H)
{
  // -AJA- this matches the logic in the QuakeII engine.

  int bmin_s = (int)floor(min_s / 16.0);
  int bmin_t = (int)floor(min_t / 16.0);

  int bmax_s = (int)ceil(max_s / 16.0);
  int bmax_t = (int)ceil(max_t / 16.0);

  *ext_W = MIN(2, bmax_s - bmin_s + 1);
  *ext_H = MIN(2, bmax_t - bmin_t + 1);
}


//------------------------------------------------------------------------

static std::vector<dbrush_t> q2_brushes;
static std::vector<dbrushside_t> q2_brush_sides;

static std::map<const csg_brush_c *, u16_t> brush_map;


static void Q2_ClearBrushes()
{
  q2_brushes.clear();
  q2_brush_sides.clear();

  brush_map.clear();
}


static u16_t Q2_AddBrush(const csg_brush_c *A)
{
  // find existing brush
  if (brush_map.find(A) != brush_map.end())
    return brush_map[A];


  dbrush_t brush;
  dbrushside_t side;

  brush.firstside = q2_brush_sides.size();
  brush.numsides  = 0;
  brush.contents  = CONTENTS_SOLID;

  side.texinfo = 1; // FIXME !!!!!


  // top
  side.planenum = BSP_AddPlane(0, 0, A->t.z,  0, 0, +1);
  
  q2_brush_sides.push_back(side);
  brush.numsides++;
  

  // bottom
  side.planenum = BSP_AddPlane(0, 0, A->b.z,  0, 0, -1);
  
  q2_brush_sides.push_back(side);
  brush.numsides++;


  for (unsigned int k = 0; k < A->verts.size(); k++)
  {
    brush_vert_c *v1 = A->verts[k];
    brush_vert_c *v2 = A->verts[(k+1) % A->verts.size()];

    side.planenum = BSP_AddPlane(v1->x, v1->y, 0,
                                (v2->y - v1->y), (v1->x - v2->x), 0);

    q2_brush_sides.push_back(side);
    brush.numsides++;
  }

  int index = (int)q2_brushes.size();

fprintf(stderr, "BRUSH %d ---> SIDES %d\n", index, brush.numsides);

  q2_brushes.push_back(brush);

  brush_map[A] = (u16_t)index;

  return (u16_t) index;
}


static void Q2_WriteBrushes()
{
  qLump_c *lump  = BSP_NewLump(LUMP_BRUSHES);

  // FIXME: write separately, fix endianness as we go

  lump->Append(&q2_brushes[0], q2_brushes.size() * sizeof(dbrush_t));

  qLump_c *sides = BSP_NewLump(LUMP_BRUSHSIDES);

  sides->Append(&q2_brush_sides[0], q2_brush_sides.size() * sizeof(dbrushside_t));
}


//------------------------------------------------------------------------

static std::vector<texinfo2_t> q2_texinfos;

#define NUM_TEXINFO_HASH  64
static std::vector<u16_t> * texinfo_hashtab[NUM_TEXINFO_HASH];


static void Q2_ClearTexInfo(void)
{
  q2_texinfos.clear();

  for (int h = 0; h < NUM_TEXINFO_HASH; h++)
  {
    delete texinfo_hashtab[h];
    texinfo_hashtab[h] = NULL;
  }
}


static bool MatchTexInfo(const texinfo2_t *A, const texinfo2_t *B)
{
  if (strcmp(A->texture, B->texture) != 0)
    return false;

  if (A->flags != B->flags)
    return false;

  for (int k = 0; k < 4; k++)
  {
    if (fabs(A->s[k] - B->s[k]) > 0.01)
      return false;

    if (fabs(A->t[k] - B->t[k]) > 0.01)
      return false;
  }

  return true; // yay!
}


u16_t Q2_AddTexInfo(const char *texture, int flags, int value,
                    float *s4, float *t4)
{
  // create texinfo structure
  texinfo2_t tin;

  for (int k = 0; k < 4; k++)
  {
    tin.s[k] = s4[k];
    tin.t[k] = t4[k];
  }

  if (strlen(texture)+1 >= sizeof(tin.texture))
    Main_FatalError("TEXTURE NAME TOO LONG: '%s'\n", texture);

  strcpy(tin.texture, texture);

  tin.flags  = flags;
  tin.value  = value;
  tin.anim_next = -1;

  // find an existing texinfo.
  // For speed we use a hash-table.
  int hash = (int)StringHash(texture);
  hash = hash & (NUM_TEXINFO_HASH-1);

  SYS_ASSERT(hash >= 0);

  if (! texinfo_hashtab[hash])
    texinfo_hashtab[hash] = new std::vector<u16_t>;

  std::vector<u16_t> *hashtab = texinfo_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t tin_idx = (*hashtab)[i];

    SYS_ASSERT(tin_idx < q2_texinfos.size());

    if (MatchTexInfo(&tin, &q2_texinfos[tin_idx]))
    {
      return tin_idx;  // found it
    }
  }


  // not found, so add new one
  u16_t tin_idx = q2_texinfos.size();

DebugPrintf("TexInfo %d --> %d '%s' (%1.1f %1.1f %1.1f %1.1f) "
        "(%1.1f %1.1f %1.1f %1.1f)\n",
        tin_idx, flags, texture,
        s4[0], s4[1], s4[2], s4[3],
        t4[0], t4[1], t4[2], t4[3]);


  if (tin_idx >= MAX_MAP_TEXINFO)
    Main_FatalError("Quake2 build failure: exceeded limit of %d TEXINFOS\n",
                    MAX_MAP_TEXINFO);

  q2_texinfos.push_back(tin);

  hashtab->push_back(tin_idx);

  return tin_idx;
}


static void Q2_WriteTexInfo(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  lump->Append(&q2_texinfos[0], q2_texinfos.size() * sizeof(texinfo2_t));
}


//------------------------------------------------------------------------

static void Q2_DummyArea(void)
{
  /* TEMP DUMMY STUFF */

  qLump_c *lump = BSP_NewLump(LUMP_AREAS);

  darea_t area;

  area.num_portals  = LE_U32(0);
  area.first_portal = LE_U32(0);

  lump->Append(&area, sizeof(area));
}


static void Q2_DummyVis(void)
{
  /* TEMP DUMMY STUFF */

  qLump_c *lump = BSP_NewLump(LUMP_VISIBILITY);

  dvis_t vis;

  vis.numclusters = LE_U32(1);

  vis.offsets[0][0] = LE_U32(sizeof(vis));
  vis.offsets[0][1] = LE_U32(sizeof(vis));

  lump->Append(&vis, sizeof(vis));

  byte dummy_v = 255;

  lump->Append(&dummy_v, 1);
  lump->Append(&dummy_v, 1);
  lump->Append(&dummy_v, 1);
  lump->Append(&dummy_v, 1);
}


#if 0
static void DummyLeafBrush(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_LEAFBRUSHES);

  dbrush_t brush;

  brush.firstside = 0;
  brush.numsides  = 0;

  brush.contents  = 0;

  lump->Append(&brush, sizeof(brush));
}
#endif


const byte oblige_pop[256] =
{
  175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175,
  175, 175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175,  62,  59,  58,  57, 221, 221,  59,  62, 175, 175, 175, 175,
  175, 175,  63,  59,  57,  57,  57, 221, 221,  57,  57,  57,  59,  63, 175, 175,
  175, 172,  58,  57,  57,  57,  57, 221, 221,  57,  57,  57,  57,  58, 172, 175,
  175,  59,  57,  57,  57,  61, 221, 221, 174,  63,  61,  57,  57,  57,  59, 175,
  175,  57,  57,  57, 171, 175, 221, 221, 221, 221, 221, 221,  57,  57,  57, 175,
  175,  57,  57,  57, 171, 221, 221, 221, 221, 221, 221, 171,  57,  57,  57, 175,
  175,  59,  57,  57,  57,  61,  63, 175, 174, 221, 221,  57,  57,  57,  59, 175,
  175, 172,  58,  57,  57,  57,  57,  57,  57,  57,  57,  57,  57,  58, 172, 175,
  175, 175,  63,  59,  57,  57,  57,  57,  57,  57,  57,  57,  59,  63, 175, 175,
  175, 175, 175, 175,  62,  59,  58,  57,  57,  58,  59,  62, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 221, 175, 175, 175, 175, 175, 175, 175, 175
};


//------------------------------------------------------------------------

static qLump_c *q2_surf_edges;
static qLump_c *q2_mark_surfs;

static qLump_c *q2_faces;
static qLump_c *q2_leafs;
static qLump_c *q2_nodes;

static qLump_c *q2_models;

static int q2_total_surf_edges;
static int q2_total_mark_surfs;

static int q2_total_faces;
static int q2_total_leafs;
static int q2_total_nodes;


static void Q2_WriteEdge(const quake_vertex_c & A, const quake_vertex_c & B)
{
  u16_t v1 = BSP_AddVertex(A.x, A.y, A.z);
  u16_t v2 = BSP_AddVertex(B.x, B.y, B.z);

  if (v1 == v2)
  {
    Main_FatalError("INTERNAL ERROR: Q2 WriteEdge is zero length!\n");
  }

  s32_t index = BSP_AddEdge(v1, v2);

  // fix endianness
  index = LE_S32(index);

  q2_surf_edges->Append(&index, sizeof(index));

  q2_total_surf_edges += 1;
}


static void Q2_WriteBSP()
{
  // FIXME: Q2_WriteBSP
}


//------------------------------------------------------------------------

static void Q2_Model_Edge(float x1, float y1, float z1,
                          float x2, float y2, float z2)
{
  quake_vertex_c A(x1, y1, z1);
  quake_vertex_c B(x2, y2, z2);

  Q2_WriteEdge(A, B);
}


static void Q2_Model_Face(quake_mapmodel_c *model, int face, s16_t plane, bool flipped)
{
  dface2_t raw_face;

  raw_face.planenum = plane;
  raw_face.side = flipped ? 1 : 0;
 

  const char *texture = "error";

  float s[3] = { 0.0, 0.0, 0.0 };
  float t[3] = { 0.0, 0.0, 0.0 };


  // add the edges

  raw_face.firstedge = q2_total_surf_edges;
  raw_face.numedges  = 4;

  if (face < 2)  // PLANE_X
  {
    s[1] = 1;  // PLANE_X
    t[2] = 1;

    texture = model->x_face.getStr("tex", "missing");

    double x = (face==0) ? model->x1 : model->x2;
    double y1 = flipped  ? model->y2 : model->y1;
    double y2 = flipped  ? model->y1 : model->y2;

    // Note: this assumes the plane is positive
    Q2_Model_Edge(x, y1, model->z1, x, y1, model->z2);
    Q2_Model_Edge(x, y1, model->z2, x, y2, model->z2);
    Q2_Model_Edge(x, y2, model->z2, x, y2, model->z1);
    Q2_Model_Edge(x, y2, model->z1, x, y1, model->z1);
  }
  else if (face < 4)
  {
    s[0] = 1;  // PLANE_Y
    t[2] = 1;

    texture = model->y_face.getStr("tex", "missing");

    double y = (face==2) ? model->y1 : model->y2;
    double x1 = flipped  ? model->x1 : model->x2;
    double x2 = flipped  ? model->x2 : model->x1;

    Q2_Model_Edge(x1, y, model->z1, x1, y, model->z2);
    Q2_Model_Edge(x1, y, model->z2, x2, y, model->z2);
    Q2_Model_Edge(x2, y, model->z2, x2, y, model->z1);
    Q2_Model_Edge(x2, y, model->z1, x1, y, model->z1);
  }
  else
  {
    s[0] = 1;  // PLANE_Z
    t[1] = 1;

    texture = model->z_face.getStr("tex", "missing");

    double z = (face==5) ? model->z1 : model->z2;
    double x1 = flipped  ? model->x2 : model->x1;
    double x2 = flipped  ? model->x1 : model->x2;

    Q2_Model_Edge(x1, model->y1, z, x1, model->y2, z);
    Q2_Model_Edge(x1, model->y2, z, x2, model->y2, z);
    Q2_Model_Edge(x2, model->y2, z, x2, model->y1, z);
    Q2_Model_Edge(x2, model->y1, z, x1, model->y1, z);
  }


  // texture and lighting

  raw_face.texinfo = Q2_AddTexInfo(texture, 0, 0, s, t);

  raw_face.styles[0] = 0;
  raw_face.styles[1] = 0xFF;
  raw_face.styles[2] = 0xFF;
  raw_face.styles[3] = 0xFF;

  raw_face.lightofs = 72*17*17;  // FIXME


  DoWriteFace(raw_face);
}


static void Q2_Model_Nodes(quake_mapmodel_c *model, float *mins, float *maxs)
{
  int face_base = q2_total_faces;
  int leaf_base = q2_total_leafs;

  model->nodes[0] = q2_total_nodes;

  for (int face = 0 ; face < 6 ; face++)
  {
    dnode2_t raw_node;
    dleaf2_t raw_leaf;

    memset(&raw_leaf, 0, sizeof(raw_leaf));

    double v;
    double dir;

    bool flipped;

    if (face < 2)  // PLANE_X
    {
      v = (face==0) ? model->x1 : model->x2;
      dir = (face==0) ? -1 : 1;
      raw_node.planenum = BSP_AddPlane(v,0,0, dir,0,0, &flipped);
    }
    else if (face < 4)  // PLANE_Y
    {
      v = (face==2) ? model->y1 : model->y2;
      dir = (face==2) ? -1 : 1;
      raw_node.planenum = BSP_AddPlane(0,v,0, 0,dir,0, &flipped);
    }
    else  // PLANE_Z
    {
      v = (face==5) ? model->z1 : model->z2;
      dir = (face==5) ? -1 : 1;
      raw_node.planenum = BSP_AddPlane(0,0,v, 0,0,dir, &flipped);
    }

    raw_node.children[0] = -(leaf_base + face + 2);
    raw_node.children[1] = (face == 5) ? -1 : (model->nodes[0] + face + 1);

    if (flipped)
    {
      std::swap(raw_node.children[0], raw_node.children[1]);
    }

    raw_node.firstface = face_base + face;
    raw_node.numfaces  = 1;

    for (int b = 0 ; b < 3 ; b++)
    {
      raw_leaf.mins[b] = raw_node.mins[b] = mins[b];
      raw_leaf.maxs[b] = raw_node.maxs[b] = maxs[b];
    }

    raw_leaf.contents = 0;  // EMPTY

    raw_leaf.first_leafface = q2_total_mark_surfs;
    raw_leaf.num_leaffaces  = 1;

    // FIXME raw_leaf.first_leafbrush = XXX
    // FIXME raw_leaf.num_leafbrush   = XXX

    Q2_Model_Face(model, face, raw_node.planenum, flipped);

    Q2_WriteMarkSurf(q2_total_mark_surfs);

    DoWriteNode(raw_node);
    DoWriteLeaf(raw_leaf);
  }
}


static void Q2_WriteModel(quake_mapmodel_c *model)
{
  dmodel2_t raw_model;

  memset(&raw_model, 0, sizeof(raw_model));

  raw_model.mins[0] = LE_Float32(model->x1 - MODEL_PADDING);
  raw_model.mins[1] = LE_Float32(model->y1 - MODEL_PADDING);
  raw_model.mins[2] = LE_Float32(model->z1 - MODEL_PADDING);

  raw_model.maxs[0] = LE_Float32(model->x2 + MODEL_PADDING);
  raw_model.maxs[1] = LE_Float32(model->y2 + MODEL_PADDING);
  raw_model.maxs[2] = LE_Float32(model->z2 + MODEL_PADDING);

  // raw_model.origin stays zero

  raw_model.headnode  = LE_S32(model->nodes[0]);

  raw_model.firstface = LE_S32(model->firstface);
  raw_model.numfaces  = LE_S32(model->numfaces);

  q2_models->Append(&raw_model, sizeof(raw_model));
}


static void Q2_WriteModels()
{
  // create the world model
  qk_world_model = new quake_mapmodel_c();

  qk_world_model->firstface = 0;
  qk_world_model->numfaces  = q2_total_faces;
  qk_world_model->numleafs  = q2_total_leafs;

  // bounds of map
  qk_world_model->x1 = qk_bsp_root->bbox.mins[0];
  qk_world_model->y1 = qk_bsp_root->bbox.mins[1];
  qk_world_model->y1 = qk_bsp_root->bbox.mins[2];

  qk_world_model->x2 = qk_bsp_root->bbox.maxs[0];
  qk_world_model->y2 = qk_bsp_root->bbox.maxs[1];
  qk_world_model->y2 = qk_bsp_root->bbox.maxs[2];

  Q2_WriteModel(qk_world_model);

  // handle the sub-models (doors etc)

  for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
  {
    quake_mapmodel_c *model = qk_all_mapmodels[i];

    model->firstface = q2_total_faces;
    model->numfaces  = 6;
    model->numleafs  = 6;

    float mins[3], maxs[3];

    mins[0] = model->x1;
    mins[1] = model->y1;
    mins[2] = model->z1;

    maxs[0] = model->x2;
    maxs[1] = model->y2;
    maxs[2] = model->z2;

    Q2_Model_Nodes(model, mins, maxs);

    Q2_WriteModel(model);
  }
}


//------------------------------------------------------------------------

static void Q2_CreateBSPFile(const char *name)
{
  BSP_OpenLevel(name, 2);

  Q2_ClearBrushes();
  Q2_ClearTexInfo();

  Q2_DummyArea();
  Q2_DummyVis();

  CSG_QUAKE_Build(2);

  /// Q2_Lighting();

  /// QCOM_Visibility();

  Q2_WriteBSP();

  Q2_WriteModels();

  BSP_WritePlanes  (LUMP_PLANES,   MAX_MAP_PLANES);
  BSP_WriteVertices(LUMP_VERTEXES, MAX_MAP_VERTS );
  BSP_WriteEdges   (LUMP_EDGES,    MAX_MAP_EDGES );

  Q2_WriteBrushes();
  Q2_WriteTexInfo();

  BSP_WriteEntities(LUMP_ENTITIES, description);

  BSP_CloseLevel();
}


//------------------------------------------------------------------------

class quake2_game_interface_c : public game_interface_c
{
private:
  const char *filename;

public:
  quake2_game_interface_c() : filename(NULL)
  { }

  ~quake2_game_interface_c()
  { }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);
};


bool quake2_game_interface_c::Start()
{
  filename = Select_Output_File("pak");

  if (! filename)
  {
    Main_ProgStatus("Cancelled");
    return false;
  }

  if (create_backups)
    Main_BackupFile(filename, "old");

  if (! PAK_OpenWrite(filename))
  {
    Main_ProgStatus("Error (create file)");
    return false;
  }

  BSP_AddInfoFile();

  if (main_win)
    main_win->build_box->Prog_Init(0, "CSG,BSP,Light,Vis");

  return true;
}


bool quake2_game_interface_c::Finish(bool build_ok)
{
  PAK_CloseWrite();

  // remove the file if an error occurred
  if (! build_ok)
    FileDelete(filename);

  return build_ok;
}


void quake2_game_interface_c::BeginLevel()
{
  level_name  = NULL;
  description = NULL;
}


void quake2_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else if (StringCaseCmp(key, "description") == 0)
  {
    description = StringDup(value);
  }
  else
  {
    LogPrintf("WARNING: QUAKE2: unknown level prop: %s=%s\n", key, value);
  }
}


void quake2_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  if (strlen(level_name) >= 32)
    Main_FatalError("Script problem: level name too long: %s\n", level_name);

  char entry_in_pak[64];
  sprintf(entry_in_pak, "maps/%s.bsp", level_name);

  Q2_CreateBSPFile(entry_in_pak);

  StringFree(level_name);

  if (description)
    StringFree(description);
}


game_interface_c * Quake2_GameObject(void)
{
  return new quake2_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
