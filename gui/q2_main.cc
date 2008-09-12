//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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
#include "main.h"

#include "csg_main.h"

#include "g_image.h"
#include "ui_chooser.h"

#include "q_bsp.h"
#include "q_pakfile.h"
#include "q2_main.h"
#include "q2_structs.h"


#define TEMP_FILENAME    "temp/out.pak"

static char *level_name;


void Q2_CreateEntities(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_ENTITIES);

  /* add the worldspawn entity */

  lump->Printf("{\n");

  lump->KeyPair("_generated_by", OBLIGE_TITLE " (c) Andrew Apted");
  lump->KeyPair("_oblige_version", OBLIGE_VERSION);
  lump->KeyPair("_oblige_home",  "http://oblige.sourceforge.net");
  lump->KeyPair("_random_seed",  main_win->game_box->get_Seed());

  lump->KeyPair("message",   "level created by Oblige");
  lump->KeyPair("worldtype", "0");
//lump->KeyPair("origin",    "0 0 0");
  lump->KeyPair("classname", "worldspawn");

  lump->Printf("}\n");

  // add everything else

  for (unsigned int j = 0; j < all_entities.size(); j++)
  {
    entity_info_c *E = all_entities[j];

    lump->Printf("{\n");

    // TODO: other models (doors etc) --> "model" "*45"

    // FIXME: other entity properties

    lump->KeyPair("origin", "%1.1f %1.1f %1.1f", E->x, E->y, E->z);
    lump->KeyPair("classname", E->name.c_str());

    lump->Printf("}\n");
  }

  // add a trailing nul
  u8_t zero = 0;

  lump->Append(&zero, 1);
}


//------------------------------------------------------------------------

std::vector<dplane_t> q1_planes;

#define NUM_PLANE_HASH  128
static std::vector<u16_t> * plane_hashtab[NUM_PLANE_HASH];


static void ClearPlanes(void)
{
  q1_planes.clear();

  for (int h = 0; h < NUM_PLANE_HASH; h++)
  {
    delete plane_hashtab[h];
    plane_hashtab[h] = NULL;
  }
}

u16_t Q2_AddPlane(double x, double y, double z,
                  double dx, double dy, double dz)
{
  bool flipped = false;

  double len = sqrt(dx*dx + dy*dy + dz*dz);

  SYS_ASSERT(len > 0);

  dx /= len;
  dy /= len;
  dz /= len;

  double ax = fabs(dx);
  double ay = fabs(dy);
  double az = fabs(dz);

  // flip plane to make major axis positive
  if ( (-dx >= MAX(ay, az)) ||
       (-dy >= MAX(ax, az)) ||
       (-dz >= MAX(ax, ay)) )
  {
    flipped = true;

    dx = -dx;
    dy = -dy;
    dz = -dz;
  }

  SYS_ASSERT(! (dx < -1.0 + EPSILON));
  SYS_ASSERT(! (dy < -1.0 + EPSILON));
  SYS_ASSERT(! (dz < -1.0 + EPSILON));

  // distance to the origin (0,0,0)
  double dist = (x*dx + y*dy + z*dz);


  // create plane structures
  // Quake II stores them in pairs
  dplane_t dp[2];

  dp[0].normal[0] = dx; dp[1].normal[0] = -dx;
  dp[0].normal[1] = dy; dp[1].normal[1] = -dy;
  dp[0].normal[2] = dz; dp[1].normal[2] = -dz;

  dp[0].dist =  dist;
  dp[1].dist = -dist;

  if (ax > 1.0 - EPSILON)
    dp[0].type = PLANE_X;
  else if (ay > 1.0 - EPSILON)
    dp[0].type = PLANE_Y;
  else if (az > 1.0 - EPSILON)
    dp[0].type = PLANE_Z;
  else if (ax >= MAX(ay, az))
    dp[0].type = PLANE_ANYX;
  else if (ay >= MAX(ax, az))
    dp[0].type = PLANE_ANYY;
  else
    dp[0].type = PLANE_ANYZ;

  dp[1].type = dp[0].type;


  // find an existing matching plane.
  // For speed we use a hash-table based on dx/dy/dz/dist
  int hash = I_ROUND(dist / 8.0);
  hash = IntHash(hash ^ I_ROUND((dx+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((dy+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((dz+1.0) * 8));

  hash = hash & (NUM_PLANE_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! plane_hashtab[hash])
    plane_hashtab[hash] = new std::vector<u16_t>;
    
  std::vector<u16_t> *hashtab = plane_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t plane_idx = (*hashtab)[i];

    SYS_ASSERT(plane_idx < q1_planes.size());

    dplane_t *test_p = &q1_planes[plane_idx];

    // Note: ignore the 'type' field because it was generated
    //       from (and completely depends on) the plane normal.
    if (fabs(test_p->dist - dist) > Q_EPSILON ||
        fabs(test_p->normal[0] - dx) > EPSILON ||
        fabs(test_p->normal[1] - dy) > EPSILON ||
        fabs(test_p->normal[2] - dz) > EPSILON)
    {
      continue;
    }

    // found it
    return plane_idx | (flipped ? 1 : 0);
  }


  // not found, so add new one  [We only store dp[0] in the hash-tab]
  u16_t plane_idx = q1_planes.size();

  if (plane_idx >= MAX_MAP_PLANES-2)
    Main_FatalError("Quake2 build failure: exceeded limit of %d PLANES\n",
                    MAX_MAP_PLANES);

  q1_planes.push_back(dp[0]);
  q1_planes.push_back(dp[1]);

fprintf(stderr, "ADDED PLANE (idx %d), count %d\n",
                 (int)plane_idx, (int)q1_planes.size());

  hashtab->push_back(plane_idx);


  return plane_idx | (flipped ? 1 : 0);
}


static void Q2_CreatePlanes(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_PLANES);

  // FIXME: write separately, fix endianness as we go

  lump->Append(&q1_planes[0], q1_planes.size() * sizeof(dplane_t));
}


//------------------------------------------------------------------------

std::vector<dvertex_t> q1_vertices;

#define NUM_VERTEX_HASH  512
static std::vector<u16_t> * vert_hashtab[NUM_VERTEX_HASH];


static void ClearVertices(void)
{
  q1_vertices.clear();

  for (int h = 0; h < NUM_VERTEX_HASH; h++)
  {
    delete vert_hashtab[h];
    vert_hashtab[h] = NULL;
  }

  // insert dummy vertex #0
  dvertex_t dummy;
  memset(&dummy, 0, sizeof(dummy));

  q1_vertices.push_back(dummy);
}

u16_t Q2_AddVertex(double x, double y, double z)
{
  dvertex_t vert;

  vert.x = x;
  vert.y = y;
  vert.z = z;


  // find existing vertex.
  // For speed we use a hash-table
  int hash;
  hash = IntHash(       I_ROUND((x+1.4) / 128.0));
  hash = IntHash(hash ^ I_ROUND((y+1.4) / 128.0));

  hash = hash & (NUM_VERTEX_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! vert_hashtab[hash])
    vert_hashtab[hash] = new std::vector<u16_t>;

  std::vector<u16_t> *hashtab = vert_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t vert_idx = (*hashtab)[i];
 
    dvertex_t *test = &q1_vertices[vert_idx];

    if (fabs(test->x - x) < Q_EPSILON &&
        fabs(test->y - y) < Q_EPSILON &&
        fabs(test->z - z) < Q_EPSILON)
    {
      return vert_idx; // found it
    }
  }


  // not found, so add new one
  u16_t vert_idx = q1_vertices.size();

  if (vert_idx == MAX_MAP_VERTS-1)
    Main_FatalError("Quake2 build failure: exceeded limit of %d VERTEXES\n",
                    MAX_MAP_VERTS);

  q1_vertices.push_back(vert);

  hashtab->push_back(vert_idx);

  return vert_idx;
}

static void Q2_CreateVertexes(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_VERTEXES);

  lump->Append(&q1_vertices[0], q1_vertices.size() * sizeof(dvertex_t));
}


//------------------------------------------------------------------------

std::vector<dedge_t> q1_edges;

std::map<u32_t, s32_t> q1_edge_map;


static void ClearEdges(void)
{
  q1_edges.clear();
  q1_edge_map.clear();

  // insert dummy edge #0
  dedge_t dummy;

  dummy.v[0] = dummy.v[1] = 0;

  q1_edges.push_back(dummy);
}


s32_t Q2_AddEdge(u16_t start, u16_t end)
{
  bool flipped = false;

  if (start > end)
  {
    flipped = true;
    u16_t tmp = start; start = end; end = tmp;
  }

  dedge_t edge;

  edge.v[0] = start;
  edge.v[1] = end;

  u32_t key = (u32_t)start + (u32_t)(end << 16);


  // find existing edge
  if (q1_edge_map.find(key) != q1_edge_map.end())
    return q1_edge_map[key] * (flipped ? -1 : 1);


  // not found, so add new one
  int edge_idx = q1_edges.size();

  if (edge_idx >= MAX_MAP_EDGES)
    Main_FatalError("Quake2 build failure: exceeded limit of %d EDGES\n",
                    MAX_MAP_EDGES);

  q1_edges.push_back(edge);

  q1_edge_map[key] = edge_idx;

  return flipped ? -edge_idx : edge_idx;
}

static void Q2_CreateEdges(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_EDGES);

  lump->Append(&q1_edges[0], q1_edges.size() * sizeof(dedge_t));
}


//------------------------------------------------------------------------

std::vector<texinfo_t> q1_texinfos;

#define NUM_TEXINFO_HASH  64
static std::vector<u16_t> * texinfo_hashtab[NUM_TEXINFO_HASH];


static void ClearTexInfo(void)
{
  q1_texinfos.clear();

  for (int h = 0; h < NUM_TEXINFO_HASH; h++)
  {
    delete texinfo_hashtab[h];
    texinfo_hashtab[h] = NULL;
  }
}

static bool MatchTexInfo(const texinfo_t *A, const texinfo_t *B)
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

u16_t Q2_AddTexInfo(const char *texture, int flags, double *s4, double *t4)
{
  // create texinfo structure
  texinfo_t tin;

  for (int k = 0; k < 4; k++)
  {
    tin.s[k] = s4[k];
    tin.t[k] = t4[k];
  }

  if (strlen(texture) >= sizeof(tin.texture))
    Main_FatalError("TEXTURE NAME TOO LONG: '%s'\n", texture);

  strcpy(tin.texture, texture);

  tin.flags  = flags;
  tin.value  = 0;
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

    SYS_ASSERT(tin_idx < q1_texinfos.size());

    if (MatchTexInfo(&tin, &q1_texinfos[tin_idx]))
      return tin_idx;  // found it
  }


  // not found, so add new one
  u16_t tin_idx = q1_texinfos.size();

  if (tin_idx >= MAX_MAP_TEXINFO)
    Main_FatalError("Quake2 build failure: exceeded limit of %d TEXINFOS\n",
                    MAX_MAP_TEXINFO);

  q1_texinfos.push_back(tin);

  hashtab->push_back(tin_idx);

  return tin_idx;
}

static void Q2_CreateTexInfo(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  // FIXME: write separately, fix endianness as we go
 
  lump->Append(&q1_texinfos[0], q1_texinfos.size() * sizeof(texinfo_t));
}


///---static void DummyTexInfo(void)
///---{
///---  /* TEMP DUMMY STUFF */
///---
///---  // 0 = "error" on PLANE_X / PLANE_ANYX
///---  // 1 = "error" on PLANE_Y / PLANE_ANYY
///---  // 2 = "error" on PLANE_Z / PLANE_ANYZ
///---  //
///---  // 3 = "gray"  on PLANE_X / PLANE_ANYX
///---  // 4 = "gray"  on PLANE_Y / PLANE_ANYY
///---  // 5 = "gray"  on PLANE_Z / PLANE_ANYZ
///---
///---  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);
///---
///---  float scale = 8.0;
///---
///---  for (int T = 0; T < 6; T++)
///---  {
///---    int P = T % 3;
///---
///---    texinfo_t tex;
///---
///---    tex.s[0] = (P == PLANE_X) ? 0 : 1;
///---    tex.s[1] = (P == PLANE_X) ? 1 : 0;
///---    tex.s[2] = 0;
///---    tex.s[3] = 0;
///---
///---    tex.t[0] = 0;
///---    tex.t[1] = (P == PLANE_Z) ? 1 : 0;
///---    tex.t[2] = (P == PLANE_Z) ? 0 : 1;
///---    tex.t[3] = 0;
///---
///---    for (int k = 0; k < 3; k++)
///---    {
///---      tex.s[k] /= scale;
///---      tex.t[k] /= scale;
///---
///---      // FIXME: endianness swap!
///---    }
///---
///---    int flags = 0;
///---
///---    tex.miptex = LE_S32(T / 3);
///---    tex.flags  = LE_S32(flags);
///---
///---    lump->Append(&tex, sizeof(tex));
///---  }
///---}


//------------------------------------------------------------------------

static void DummyArea(void)
{
  /* TEMP DUMMY STUFF */

  qLump_c *lump = BSP_NewLump(LUMP_AREAS);

  darea_t area;

  area.num_portals  = LE_U32(0);
  area.first_portal = LE_U32(0);

  lump->Append(&area, sizeof(area));
}

static void DummyVis(void)
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

static void DummyLeafBrush(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_LEAFBRUSHES);

  dbrush_t brush;

  brush.firstside = 0;
  brush.numsides  = 0;

  brush.contents  = 0;

  lump->Append(&brush, sizeof(brush));
}


//------------------------------------------------------------------------

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


class quake2_game_interface_c : public game_interface_c
{
private:


public:
  quake2_game_interface_c()
  { }

  ~quake2_game_interface_c()
  { }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void LevelProp(const char *key, const char *value);
  void EndLevel();
};


bool quake2_game_interface_c::Start()
{
  const char *filename = Select_Output_File();

  if (! filename)  // cancelled
    return false;

  if (! PAK_OpenWrite(TEMP_FILENAME))
    return false;

  main_win->build_box->ProgInit(1);

  main_win->build_box->ProgBegin(1, 100, BUILD_PROGRESS_FG);
  main_win->build_box->ProgStatus("Making levels");

  return true;
}


bool quake2_game_interface_c::Finish(bool build_ok)
{
  PAK_CloseWrite();

  // tidy up
/////  FileDelete(TEMP_FILENAME);

  return build_ok;
}


void quake2_game_interface_c::BeginLevel()
{
  // nothing needed
}


void quake2_game_interface_c::LevelProp(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else
  {
    LogPrintf("WARNING: QUAKE1: unknown level prop: %s=%s\n", key, value);
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

  if (! BSP_OpenLevel("maps/base1.bsp", 2))
    return; //!!!!!! FUCK

  ClearPlanes();
  ClearVertices();
  ClearEdges();
  ClearTexInfo();

  CSG2_MergeAreas();
  CSG2_MakeMiniMap();

  Quake2_BuildBSP();
  Quake1_BeginLightmap();

  Q2_CreateEntities();
  Q2_CreateModel();
  Q2_CreatePlanes();
  Q2_CreateVertexes();
  Q2_CreateEdges();
  Q2_CreateTexInfo();

  DummyArea();
  DummyVis();
  DummyLeafBrush();

  BSP_CloseLevel();

  // FREE STUFF !!!!
}


game_interface_c * Quake2_GameObject(void)
{
  return new quake2_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
