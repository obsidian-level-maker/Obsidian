//------------------------------------------------------------------------
//  QUAKE 1/2 LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010  Andrew Apted
//  Copyright (C) 1996-1997  Id Software, Inc.
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

#include "q_common.h"
#include "q_light.h"
#include "q1_structs.h"

#include "csg_main.h"
#include "csg_quake.h"


qLightmap_c::qLightmap_c(int w, int h, float value) : width(w), height(h), offset(-1)
{
  if (width > 1 || height > 1)
    samples = new float[width * height];
  else
    samples = &flat;

  if (value >= 0)
    Fill(value);
}

qLightmap_c::~qLightmap_c()
{
  if (width > 1 || height > 1)
    delete[] samples;
}

void qLightmap_c::Fill(float value)
{
  for (int i = 0 ; i < width*height ; i++)
    samples[i] = value;
}


void qLightmap_c::Clamp()
{
  for (int i = 0 ; i < width*height ; i++)
  {
    if (samples[i] < 0)   samples[i] = 0;
    if (samples[i] > 255) samples[i] = 255;
  }
}


void qLightmap_c::GetRange(float *low, float *high, float *avg)
{
  *low  = +9e9;
  *high = -9e9;
  *avg  = 0;

  for (int i = 0 ; i < width*height ; i++)
  {
    if (samples[i] < *low)  *low  = samples[i];
    if (samples[i] > *high) *high = samples[i];

    *avg += samples[i];
  }

  *avg /= (float)(width * height);
}


void qLightmap_c::Add(double x, double y, float value)
{
  if (0 <= x && x < width && 0 <= y && y < height)
  {
    int i = (int)x + (int)y * width;

    samples[i] += value;
  }
}


void qLightmap_c::Flatten(float avg)
{
  if (isFlat())
    return;

  if (avg < 0)
  {
    float low, high;

    GetRange(&low, &high, &avg);
  }

  flat = avg;

  width = height = 1;

  delete[] samples; samples = NULL;
}


void qLightmap_c::Write(qLump_c *lump, bool colored)
{
  if (isFlat())
  {
    offset = colored ? 1 : 0;
    return;
  }

  offset = lump->GetSize();

  int total = width * height;

  Clamp();

  for (int i = 0 ; i < total ; i++)
  {
    byte datum = (byte) samples[i];

    lump->Append(&datum, 1);

    if (colored)
    {
      lump->Append(&datum, 1);
      lump->Append(&datum, 1);
    }
  }
}


int qLightmap_c::CalcOffset() const
{
  if (! isFlat())
    return offset;

  // compute offset of a flat lightmap
  int result = (int) samples[0];

  if (result > 128)
  {
    result = 64 + result / 2;
  }

  // for flat maps, 'offset' field remembers colored vs mono
  return result * (offset ? 3 : 1);
}


//------------------------------------------------------------------------

static std::vector<qLightmap_c *> qk_all_lightmaps;

static qLump_c *lightmap_lump;


void BSP_InitLightmaps()
{
  qk_all_lightmaps.clear();
}


void BSP_FreeLightmaps()
{
  for (unsigned int i = 0 ; i < qk_all_lightmaps.size() ; i++)
    delete qk_all_lightmaps[i];

  qk_all_lightmaps.clear();
}


qLightmap_c * BSP_NewLightmap(int w, int h, float value)
{
  qLightmap_c *lmap = new qLightmap_c(w, h, value);

  qk_all_lightmaps.push_back(lmap);

  return lmap;
}


static void WriteFlatBlock(int level, int count)
{
  byte datum = (byte)level;

  for ( ; count > 0 ; count--)
    lightmap_lump->Append(&datum, 1);
}


void BSP_BuildLightmap(int lump, int max_size, bool colored)
{
  lightmap_lump = BSP_NewLump(lump);

  // at the start are a bunch of completely flat lightmaps.
  // for the overbright range (129-255) there are half as many.

  int i;
  int flat_size = FLAT_LIGHTMAP_SIZE * (colored ? 3 : 1);

  for (i = 0 ; i < 128 ; i++)
  {
    WriteFlatBlock(i, flat_size);
    max_size -= flat_size;
  }

  for (i = 128 ; i < 256 ; i += 2)
  {
    WriteFlatBlock(i, flat_size);
    max_size -= flat_size;
  }


  // from here on 'max_size' is in PIXELS (not bytes)
  if (colored)
    max_size /= 3;


  // FIXME !!!! : check if lump would overflow, if yes then flatten some maps


  for (unsigned int k = 0 ; k < qk_all_lightmaps.size() ; k++)
  {
    qLightmap_c *L = qk_all_lightmaps[k];

    L->Write(lightmap_lump, colored);
  }
}


//------------------------------------------------------------------------

// Lighting variables

static quake_face_c *lt_face;

static double lt_plane_normal[3];
static double lt_plane_dist;

static double lt_texorg[3];
static double lt_worldtotex[2][3];
static double lt_textoworld[2][3];


static void CalcFaceVectors(quake_face_c *F)
{
  const quake_plane_c * plane = &F->node->plane;

  lt_plane_normal[0] = plane->nx;
  lt_plane_normal[1] = plane->ny;
  lt_plane_normal[2] = plane->nz;

  lt_plane_dist = plane->CalcDist();

  if (F->node_side == 1)
    lt_plane_dist = -lt_plane_dist;


  lt_worldtotex[0][0] = F->s[0];
  lt_worldtotex[0][1] = F->s[1];
  lt_worldtotex[0][2] = F->s[2];

  lt_worldtotex[1][0] = F->t[0];
  lt_worldtotex[1][1] = F->t[1];
  lt_worldtotex[1][2] = F->t[2];


  // calculate a normal to the texture axis.  points can be moved
  // along this without changing their S/T
  static quake_plane_c texnormal;

  texnormal.nx = F->s[2] * F->t[1] - F->s[1] * F->t[2];
  texnormal.ny = F->s[0] * F->t[2] - F->s[2] * F->t[0];
  texnormal.nz = F->s[1] * F->t[0] - F->s[0] * F->t[1];

  texnormal.Normalize();

  // flip it towards plane normal
  double distscale = texnormal.nx * lt_plane_normal[0] +
                     texnormal.ny * lt_plane_normal[1] +
                     texnormal.nz * lt_plane_normal[2];

  if (distscale < 0)
  {
    distscale = -distscale;
    texnormal.Flip();
  }

  // distscale is the ratio of the distance along the texture normal
  // to the distance along the plane normal
  distscale = 1.0 / distscale;


  for (int i = 0 ; i < 2 ; i++)
  {
    double len_sq = lt_worldtotex[i][0] * lt_worldtotex[i][0] +
                    lt_worldtotex[i][1] * lt_worldtotex[i][1] +
                    lt_worldtotex[i][2] * lt_worldtotex[i][2];

    double dist = lt_worldtotex[i][0] * lt_plane_normal[0] +
                  lt_worldtotex[i][1] * lt_plane_normal[1] +
                  lt_worldtotex[i][2] * lt_plane_normal[2];

    dist *= distscale;
    dist /= len_sq;

    lt_textoworld[i][0] = lt_worldtotex[i][0] - texnormal.nx * dist;
    lt_textoworld[i][1] = lt_worldtotex[i][1] - texnormal.ny * dist;
    lt_textoworld[i][2] = lt_worldtotex[i][2] - texnormal.nz * dist;
  }


  // calculate texorg on the texture plane
  lt_texorg[0] = - F->s[3] * lt_textoworld[0][0] - F->t[3] * lt_textoworld[0][0];
  lt_texorg[1] = - F->s[3] * lt_textoworld[0][1] - F->t[3] * lt_textoworld[0][1];
  lt_texorg[2] = - F->s[3] * lt_textoworld[0][2] - F->t[3] * lt_textoworld[0][2];

  // project back to the face plane

  // AJA: I assume the "- 1.0" here means 1 unit away from the face
  double o_dist = lt_texorg[0] * lt_plane_normal[0] +
                  lt_texorg[1] * lt_plane_normal[1] +
                  lt_texorg[2] * lt_plane_normal[2] -
                  lt_plane_dist - 1.0;

  o_dist *= distscale;

  texorg[0] -= texnormal.nx * o_dist;
  texorg[1] -= texnormal.ny * o_dist;
  texorg[2] -= texnormal.nz * o_dist;
}


static void CalcFaceExtents(quake_face_c *F)
{
  double min_s, min_t;
  double max_s, max_t;

  F->ST_Bounds(&min_s, &min_t, &max_s, &max_t);

  // -AJA- this matches the logic in the Quake engine.

  int bmin_s = (int)floor(min_s / 16.0);
  int bmin_t = (int)floor(min_t / 16.0);

  int bmax_s = (int)ceil(max_s / 16.0);
  int bmax_t = (int)ceil(max_t / 16.0);

  *ext_W = bmax_s - bmin_s + 1;
  *ext_H = bmax_t - bmin_t + 1;
}


void QCOM_LightFace(quake_face_c *F)
{
  lt_face = F;

  CalcFaceVectors(F);
  CalcFaceExtents(F);
    
/// fprintf(stderr, "FACE %p  EXTENTS %d %d\n", F, ext_W, ext_H);

  F->lmap = BSP_NewLightmap(ext_W, ext_H, 25);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
