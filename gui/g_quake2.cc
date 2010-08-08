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


static char *level_name;


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



void Q2_CreateEntities(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_ENTITIES);

  /* add the worldspawn entity */

  lump->Printf("{\n");

  lump->KeyPair("_generated_by", "OBLIGE " OBLIGE_VERSION " (c) Andrew Apted");
  lump->KeyPair("_homepage", "http://oblige.sourceforge.net");

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


static std::vector<dbrush_t> q2_brushes;
static std::vector<dbrushside_t> q2_brush_sides;

static std::map<const csg_brush_c *, u16_t> brush_map;


static void ClearBrushes()
{
  q2_brushes.clear();
  q2_brush_sides.clear();

  brush_map.clear();
}

u16_t Q2_AddBrush(const csg_brush_c *A)
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
  side.planenum = BSP_AddPlane(0, 0, A->z2,  0, 0, +1);
  
  q2_brush_sides.push_back(side);
  brush.numsides++;
  

  // bottom
  side.planenum = BSP_AddPlane(0, 0, A->z1,  0, 0, -1);
  
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

static void WriteBrushes()
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


static void ClearTexInfo(void)
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
                    double *s4, double *t4)
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

static void Q2_CreateTexInfo(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  // FIXME: write separately, fix endianness as we go
 
  lump->Append(&q2_texinfos[0], q2_texinfos.size() * sizeof(texinfo2_t));
}


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
  // nothing needed
}


void quake2_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
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

  BSP_OpenLevel("maps/base1.bsp", 2);

  ClearBrushes();
  ClearTexInfo();

  CSG_QUAKE_Build();

  // this builds the bsp tree
  Q2_CreateModel();

  Q2_CreateTexInfo();
  Q2_CreateEntities();

  DummyArea();
  DummyVis();
  WriteBrushes();

  BSP_BuildLightmap(LUMP_LIGHTING, MAX_MAP_LIGHTING, true);

  BSP_WritePlanes  (LUMP_PLANES,   MAX_MAP_PLANES);
  BSP_WriteVertices(LUMP_VERTEXES, MAX_MAP_VERTS );
  BSP_WriteEdges   (LUMP_EDGES,    MAX_MAP_EDGES );

  BSP_CloseLevel();

  // FREE STUFF !!!!

}


game_interface_c * Quake2_GameObject(void)
{
  return new quake2_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
