//------------------------------------------------------------------------
//  QUAKE 1 : DOORS and LIFTS
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#include "g_lua.h"

#include "q_common.h"
#include "q1_main.h"
#include "q1_structs.h"


extern qLump_c *q1_nodes;
extern qLump_c *q1_leafs;
extern qLump_c *q1_faces;

extern int q1_total_nodes;
extern int q1_total_mark_surfs;
extern int q1_total_surf_edges;

extern int Grab_Properties(lua_State *L, int stack_pos,
                           csg_property_set_c *props, bool skip_xybt = false);

extern void Q1_AddEdge(double x1, double y1, double z1,
                       double x2, double y2, double z2,
                       dface_t *face, dleaf_t *raw_lf = NULL);

extern void Q1_AddSurf(u16_t index, dleaf_t *raw_lf);


static void MapModel_Face(q1MapModel_c *model, int face, s16_t plane, bool flipped)
{
  dface_t raw_fc;

  raw_fc.planenum = plane;
  raw_fc.side = flipped ? 1 : 0;
 

  const char *texture = "error";

  double s[4] = { 0.0, 0.0, 0.0, 0.0 };
  double t[4] = { 0.0, 0.0, 0.0, 0.0 };

  if (face < 2)  // PLANE_X
  {
    s[1] = 1.0; t[2] = 1.0;

    texture = model->x_face.getStr("tex", "missing");
  }
  else if (face < 4)  // PLANE_Y
  {
    s[0] = 1.0; t[2] = 1.0;

    texture = model->y_face.getStr("tex", "missing");
  }
  else // PLANE_Z
  {
    s[0] = 1.0; t[1] = 1.0;

    texture = model->z_face.getStr("tex", "missing");
  }

  raw_fc.texinfo = Q1_AddTexInfo(texture, 0, s, t);

  raw_fc.styles[0] = 0xFF;  // no lightmap
  raw_fc.styles[1] = 0xFF;
  raw_fc.styles[2] = 0xFF;
  raw_fc.styles[3] = 0xFF;

  raw_fc.lightofs = -1;  // no lightmap

  // add the edges

  raw_fc.firstedge = q1_total_surf_edges;
  raw_fc.numedges  = 0;

  if (face < 2)  // PLANE_X
  {
    double x = (face==0) ? model->x1 : model->x2;
    double y1 = flipped  ? model->y2 : model->y1;
    double y2 = flipped  ? model->y1 : model->y2;

    // Note: this assumes the plane is positive
    Q1_AddEdge(x, y1, model->z1, x, y1, model->z2, &raw_fc);
    Q1_AddEdge(x, y1, model->z2, x, y2, model->z2, &raw_fc);
    Q1_AddEdge(x, y2, model->z2, x, y2, model->z1, &raw_fc);
    Q1_AddEdge(x, y2, model->z1, x, y1, model->z1, &raw_fc);
  }
  else if (face < 4)  // PLANE_Y
  {
    double y = (face==2) ? model->y1 : model->y2;
    double x1 = flipped  ? model->x1 : model->x2;
    double x2 = flipped  ? model->x2 : model->x1;

    Q1_AddEdge(x1, y, model->z1, x1, y, model->z2, &raw_fc);
    Q1_AddEdge(x1, y, model->z2, x2, y, model->z2, &raw_fc);
    Q1_AddEdge(x2, y, model->z2, x2, y, model->z1, &raw_fc);
    Q1_AddEdge(x2, y, model->z1, x1, y, model->z1, &raw_fc);
  }
  else // PLANE_Z
  {
    double z = (face==5) ? model->z1 : model->z2;
    double x1 = flipped  ? model->x2 : model->x1;
    double x2 = flipped  ? model->x1 : model->x2;

    Q1_AddEdge(x1, model->y1, z, x1, model->y2, z, &raw_fc);
    Q1_AddEdge(x1, model->y2, z, x2, model->y2, z, &raw_fc);
    Q1_AddEdge(x2, model->y2, z, x2, model->y1, z, &raw_fc);
    Q1_AddEdge(x2, model->y1, z, x1, model->y1, z, &raw_fc);
  }

  // lighting
  if (true)
  {
    static int foo = 0; foo++;
    raw_fc.styles[0] = (foo & 3);
    raw_fc.lightofs  = 100;  //!!! flat lighting index
  }

  q1_faces->Append(&raw_fc, sizeof(raw_fc));
}

static void MapModel_Nodes(q1MapModel_c *model, int face_base, int leaf_base)
{
  model->nodes[0] = q1_total_nodes;

  int mins[3], maxs[3];

  mins[0] = I_ROUND(model->x1)-32;
  mins[1] = I_ROUND(model->y1)-32;
  mins[2] = I_ROUND(model->z1)-64;

  maxs[0] = I_ROUND(model->x2)+32;
  maxs[1] = I_ROUND(model->y2)+32;
  maxs[2] = I_ROUND(model->z2)+64;

  for (int face = 0; face < 6; face++)
  {
    dnode_t raw_nd;
    dleaf_t raw_lf;

    double v;
    double dir;
    bool flipped;

    if (face < 2)  // PLANE_X
    {
      v = (face==0) ? model->x1 : model->x2;
      dir = (face==0) ? -1 : 1;
      raw_nd.planenum = BSP_AddPlane(v,0,0, dir,0,0, &flipped);
    }
    else if (face < 4)  // PLANE_Y
    {
      v = (face==2) ? model->y1 : model->y2;
      dir = (face==2) ? -1 : 1;
      raw_nd.planenum = BSP_AddPlane(0,v,0, 0,dir,0, &flipped);
    }
    else  // PLANE_Z
    {
      v = (face==5) ? model->z1 : model->z2;
      dir = (face==5) ? -1 : 1;
      raw_nd.planenum = BSP_AddPlane(0,0,v, 0,0,dir, &flipped);
    }

    raw_nd.children[0] = -(leaf_base + face + 2);
    raw_nd.children[1] = (face == 5) ? -1 : (model->nodes[0] + face + 1);

    if (flipped)
    {
      u16_t tmp = raw_nd.children[0];
      raw_nd.children[0] = raw_nd.children[1];
      raw_nd.children[1] = tmp;
    }

    raw_nd.firstface = face_base + face;
    raw_nd.numfaces  = 1;

    for (int i = 0; i < 3; i++)
    {
      raw_lf.mins[i] = raw_nd.mins[i] = mins[i];
      raw_lf.maxs[i] = raw_nd.maxs[i] = maxs[i];
    }

    raw_lf.contents = CONTENTS_EMPTY;
    raw_lf.visofs = -1;

    raw_lf.first_marksurf = q1_total_mark_surfs;
    raw_lf.num_marksurf   = 0;

    memset(raw_lf.ambient_level, 0, sizeof(raw_lf.ambient_level));

    MapModel_Face(model, face, raw_nd.planenum, flipped);

    Q1_AddSurf(raw_lf.first_marksurf, &raw_lf);

    // TODO: fix endianness

    q1_nodes->Append(&raw_nd, sizeof(raw_nd));
    q1_leafs->Append(&raw_lf, sizeof(raw_lf));
  }
}


void Q1_CreateSubModels(qLump_c *L, int first_face, int first_leaf)
{
  for (unsigned int mm=0; mm < q1_all_mapmodels.size(); mm++)
  {
    q1MapModel_c *model = q1_all_mapmodels[mm];

    dmodel_t smod;

    memset(&smod, 0, sizeof(smod));

    smod.mins[0] = model->x1;  smod.maxs[0] = model->x2;
    smod.mins[1] = model->y1;  smod.maxs[1] = model->y2;
    smod.mins[2] = model->z1;  smod.maxs[2] = model->z2;

    smod.origin[0] = 0;
    smod.origin[1] = 0;
    smod.origin[2] = 0;

    smod.visleafs  = 6;
    smod.firstface = first_face;
    smod.numfaces  = 6;

    MapModel_Nodes(model, first_face, first_leaf);

    first_face += 6;
    first_leaf += 6;

    q1_total_nodes += 6;

    for (int h = 0; h < 4; h++)
    {
      smod.headnode[h] = model->nodes[h];
    }

    // TODO: fix endianness in model
    L->Append(&smod, sizeof(smod));
  }
}


void Q1_MapModel_Clip(qLump_c *lump, s32_t base,
                      q1MapModel_c *model, int which,
                      double pad_w, double pad_t, double pad_b)
{
  model->nodes[which] = base;

  for (int face = 0; face < 6; face++)
  {
    dclipnode_t clip;

    double v;
    double dir;
    bool flipped;

    if (face < 2)  // PLANE_X
    {
      v = (face==0) ? (model->x1 - pad_w) : (model->x2 + pad_w);
      dir = (face==0) ? -1 : 1;
      clip.planenum = BSP_AddPlane(v,0,0, dir,0,0, &flipped);
    }
    else if (face < 4)  // PLANE_Y
    {
      v = (face==2) ? (model->y1 - pad_w) : (model->y2 + pad_w);
      dir = (face==2) ? -1 : 1;
      clip.planenum = BSP_AddPlane(0,v,0, 0,dir,0, &flipped);
    }
    else  // PLANE_Z
    {
      v = (face==5) ? (model->z1 - pad_b) : (model->z2 + pad_t);
      dir = (face==5) ? -1 : 1;
      clip.planenum = BSP_AddPlane(0,0,v, 0,0,dir, &flipped);
    }

    clip.children[0] = (u16_t) CONTENTS_EMPTY;
    clip.children[1] = (face == 5) ? CONTENTS_SOLID : base + face + 1;

    if (flipped)
    {
      std::swap(clip.children[0], clip.children[1]);
    }

    // fix endianness
    clip.planenum    = LE_S32(clip.planenum);
    clip.children[0] = LE_U16(clip.children[0]);
    clip.children[1] = LE_U16(clip.children[1]);

    lump->Append(&clip, sizeof(clip));
  }
}


//------------------------------------------------------------------------

int Q1_add_mapmodel(lua_State *L)
{
  // LUA: q1_add_mapmodel(info, x1,y1,z1, x2,y2,z2)
  //
  // info is a table containing:
  //   x_face  : face table for X sides
  //   y_face  : face table for Y sides
  //   z_face  : face table for top and bottom

  q1MapModel_c *model = new q1MapModel_c();

  model->x1 = luaL_checknumber(L, 2);
  model->y1 = luaL_checknumber(L, 3);
  model->z1 = luaL_checknumber(L, 4);

  model->x2 = luaL_checknumber(L, 5);
  model->y2 = luaL_checknumber(L, 6);
  model->z2 = luaL_checknumber(L, 7);

  if (lua_type(L, 1) != LUA_TTABLE)
  {
    return luaL_argerror(L, 1, "missing table: mapmodel info");
  }

  lua_getfield(L, 1, "x_face");
  lua_getfield(L, 1, "y_face");
  lua_getfield(L, 1, "z_face");

  Grab_Properties(L, -3, &model->x_face);
  Grab_Properties(L, -2, &model->y_face);
  Grab_Properties(L, -1, &model->z_face);

  lua_pop(L, 3);

  q1_all_mapmodels.push_back(model);

  // create model reference (for entity)
  char ref_name[32];
  sprintf(ref_name, "*%u", q1_all_mapmodels.size());

  lua_pushstring(L, ref_name);
  return 1;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
