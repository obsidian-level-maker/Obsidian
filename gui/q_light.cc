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
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"

#include "csg_main.h"
#include "csg_quake.h"


#define DEFAULT_LIGHTLEVEL  300  // as per the Quake 'light' tool
#define DEFAULT_SUNLEVEL    30

#define LOW_LIGHT  20


// 0 = super fast, 1 = fast, 2 = normal, 3 = best
int qk_lighting_quality = 0;

bool qk_color_lighting;


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


#if 0
void qLightmap_c::AddSafe(int s, int t, float value)
{
  if (0 <= s && s < width && 0 <= t && t < height)
  {
    Add(s, t, value);
  }
}
#endif


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


void qLightmap_c::Write(qLump_c *lump)
{
  if (isFlat())
    return;

  offset = lump->GetSize();

  int total = width * height;

  Clamp();

  for (int i = 0 ; i < total ; i++)
  {
    byte datum = (byte) samples[i];

    lump->Append(&datum, 1);

    if (qk_color_lighting)
    {
      lump->Append(&datum, 1);
      lump->Append(&datum, 1);
    }
  }
}


int qLightmap_c::CalcOffset() const
{
  if (isFlat())
  {
    int value = (int)samples[0];

    return QCOM_FlatLightOffset(CLAMP(0, value, 255));
  }
  else
  {
    return offset;
  }
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


int QCOM_FlatLightOffset(int value)
{
  SYS_ASSERT(0 <= value && value <= 255);

  if (value > 128)
  {
    value = 64 + value / 2;
  }

  if (qk_color_lighting)
    value *= 3;

  return value * FLAT_LIGHTMAP_SIZE;
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


void QCOM_BuildLightmap(int lump, int max_size)
{
  lightmap_lump = BSP_NewLump(lump);

  // at the start are a bunch of completely flat lightmaps.
  // for the overbright range (129-255) there are half as many.

  int i;
  int flat_size = FLAT_LIGHTMAP_SIZE * (qk_color_lighting ? 3 : 1);

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
  if (qk_color_lighting)
    max_size /= 3;


  // FIXME !!!! : check if lump would overflow, if yes then flatten some maps


  for (unsigned int k = 0 ; k < qk_all_lightmaps.size() ; k++)
  {
    qLightmap_c *L = qk_all_lightmaps[k];

    L->Write(lightmap_lump);
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

static int lt_tex_mins[2];
static int lt_tex_size[2];

static double lt_face_mid_s;
static double lt_face_mid_t;

static quake_vertex_c lt_points[18*18];

static int blocklights[18*18*4];  // * 4 for oversampling


static void CalcFaceVectors(quake_face_c *F)
{
  const quake_plane_c * plane = &F->node->plane;

  lt_plane_normal[0] = plane->nx;
  lt_plane_normal[1] = plane->ny;
  lt_plane_normal[2] = plane->nz;

  lt_plane_dist = plane->CalcDist();

  if (F->node_side == 1)
  {
    lt_plane_dist = -lt_plane_dist;

    for (int k = 0 ; k < 3 ; k++)
      lt_plane_normal[k] = -lt_plane_normal[k];
  }


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

    dist = dist * distscale / len_sq;

    lt_textoworld[i][0] = lt_worldtotex[i][0] - texnormal.nx * dist;
    lt_textoworld[i][1] = lt_worldtotex[i][1] - texnormal.ny * dist;
    lt_textoworld[i][2] = lt_worldtotex[i][2] - texnormal.nz * dist;
  }


  // calculate texorg on the texture plane
  lt_texorg[0] = - F->s[3] * lt_textoworld[0][0] - F->t[3] * lt_textoworld[0][0];
  lt_texorg[1] = - F->s[3] * lt_textoworld[0][1] - F->t[3] * lt_textoworld[0][1];
  lt_texorg[2] = - F->s[3] * lt_textoworld[0][2] - F->t[3] * lt_textoworld[0][2];

  // project back to the face plane

  // AJA: I assume the "- 1" here means the sampling points are 1 unit
  //      away from the face.
  double o_dist = lt_texorg[0] * lt_plane_normal[0] +
                  lt_texorg[1] * lt_plane_normal[1] +
                  lt_texorg[2] * lt_plane_normal[2] -
                  lt_plane_dist - 1.0;

  o_dist *= distscale;

  lt_texorg[0] -= texnormal.nx * o_dist;
  lt_texorg[1] -= texnormal.ny * o_dist;
  lt_texorg[2] -= texnormal.nz * o_dist;
}


static void CalcFaceExtents(quake_face_c *F)
{
  double min_s, min_t;
  double max_s, max_t;

  F->ST_Bounds(&min_s, &min_t, &max_s, &max_t);

  lt_face_mid_s = (min_s + max_s) / 2.0;
  lt_face_mid_t = (min_t + max_t) / 2.0;

  // -AJA- this matches the logic in the Quake engine.

  int bmin_s = (int)floor(min_s / 16.0);
  int bmin_t = (int)floor(min_t / 16.0);

  int bmax_s = (int)ceil(max_s / 16.0);
  int bmax_t = (int)ceil(max_t / 16.0);

  lt_tex_mins[0] = bmin_s;
  lt_tex_mins[1] = bmin_t;

  lt_tex_size[0] = bmax_s - bmin_s + 1;
  lt_tex_size[1] = bmax_t - bmin_t + 1;

/// fprintf(stderr, "FACE %p  EXTENTS %d %d\n", F, lt_tex_size[0], lt_tex_size[1]);
}


static void CalcPoints(int W, int H)
{
  for (int t = 0 ; t < H ; t++)
  for (int s = 0 ; s < W ; s++)
  {
    float us = (lt_tex_mins[0] + s) << 4;
    float ut = (lt_tex_mins[1] + t) << 4;

    quake_vertex_c & V = lt_points[t*W + s];

    V.x = lt_texorg[0] + lt_textoworld[0][0]*us + lt_textoworld[1][0]*ut;
    V.y = lt_texorg[1] + lt_textoworld[0][1]*us + lt_textoworld[1][1]*ut;
    V.z = lt_texorg[2] + lt_textoworld[0][2]*us + lt_textoworld[1][2]*ut;

    // FIXME: adjust points which are inside walls
  }
}


void qLightmap_c::Store_Normal()
{
  const int *src   = &blocklights[0];
  const int *s_end = src + (width * height);

  byte *dest = &samples[0];

  while (src < s_end)
  {
    int raw = *src++ >> 8;

    if (raw < 0)   raw = 0;
    if (raw > 255) raw = 255;

    *dest++ = raw;
  }
}


void qLightmap_c::Store_Flat()
{
  Set(0, 0, blocklights[0]);
}


void qLightmap_c::Store_Smooth()
{
  int W = width;
  int H = height;

  for (int t = 0 ; t < H ; t++)
  for (int s = 0 ; s < W ; s++)
  {
    int value = blocklights[(t*2 + 0) * W + (s*2 + 0)] +
                blocklights[(t*2 + 0) * W + (s*2 + 1)] +
                blocklights[(t*2 + 1) * W + (s*2 + 0)] +
                blocklights[(t*2 + 1) * W + (s*2 + 1)];

    Set(s, t, value >>= 2);
  }
}


void qLightmap_c::Store_Interp()
{
  int iw = width  / 2;  // interpolate #
  int ih = height / 2;

  int bw = 1 + iw;
  int bh = 1 + ih;

  // separate loops for each four cases

  for (int t = 0 ; t < bh ; t++)
  for (int s = 0 ; s < bw ; s++)
  {
    // this logic handles the far edge when size is even
    int s2 = MIN(s * 2, width-1);
    int t2 = MIN(t * 2, height-1);

    Set(s2, t2, blocklights[t * bw + s]);
  }

  for (int t = 0 ; t < bh ; t++)
  for (int s = 0 ; s < iw ; s++)
  {
    int t2 = MIN(t * 2, height-1);

    int A = blocklights[t * bw + s];
    int B = blocklights[t * bw + s + 1];

    Set(s*2+1, t2, (A + B) >> 1);
  }

  for (int t = 0 ; t < ih ; t++)
  for (int s = 0 ; s < bw ; s++)
  {
    int s2 = MIN(s * 2, width-1);

    int A = blocklights[t * bw + s];
    int C = blocklights[t * bw + bw + s];

    Set(s2, t*2+1, (A + C) >> 1);
  }

  for (int t = 0 ; t < ih ; t++)
  for (int s = 0 ; s < iw ; s++)
  {
    int A = blocklights[t * bw + s];
    int B = blocklights[t * bw + s + 1];
    int C = blocklights[t * bw + bw + s];
    int D = blocklights[t * bw + bw + s + 1];

    Set(s*2+1, t*2+1, (A + B + C + D) >> 2);
  }
}


void qLightmap_c::Store()
{
  switch (qk_lighting_quality)
  {
    case 0: Store_Flat();   break;
    case 1: Store_Interp(); break;
    case 2: Store_Normal(); break;
    case 3: Store_Smooth(); break;

    default:
      Main_FatalError("INTERNAL ERROR: qk_lighting_quality = %d\n", qk_lighting_quality);
      break;  /* NOT REACHED */
  }
}


void QLIT_TestingStuff(qLightmap_c *lmap)
{
  int W = lmap->width;
  int H = lmap->height;

  for (int t = 0 ; t < H ; t++)
  for (int s = 0 ; s < W ; s++)
  {
    const quake_vertex_c & V = lt_points[t*W + s];

    lmap->samples[t*W + s] = 80 + 40 * sin(V.z / 40.0);

//  lmap->samples[t*W + s] = QCOM_TraceRay(V.x,V.y,V.z, 2e5,4e5,3e5) ? 80 : 40;
  }
}


//------------------------------------------------------------------------

typedef enum
{
  LTK_Normal = 0,
  LTK_Sun,
}
quake_light_kind_e;


typedef struct
{
  int kind;

  float x, y, z;
  float level;
  float radius;
}
quake_light_t;


static std::vector<quake_light_t> qk_all_lights;


static void QCOM_FindLights()
{
  qk_all_lights.clear();

  for (unsigned int i = 0 ; i < all_entities.size() ; i++)
  {
    csg_entity_c *E = all_entities[i];

    quake_light_t light;

    if (E->Match("light"))
      light.kind = LTK_Normal;
    else if (E->Match("oblige_sun"))
      light.kind = LTK_Sun;
    else
      continue;

    light.x = E->x;
    light.y = E->y;
    light.z = E->z;

    float default_level = (light.kind == LTK_Sun) ? DEFAULT_SUNLEVEL : DEFAULT_LIGHTLEVEL;

    light.level  = E->props.getDouble("light", default_level);
    light.radius = E->props.getDouble("_radius", light.level);

    if (light.level < 1 || light.radius < 1)
      continue;

    qk_all_lights.push_back(light);
  }
}


static void QCOM_FreeLights()
{
  qk_all_lights.clear();
}


static void QCOM_ProcessLight(qLightmap_c *lmap, quake_light_t & light)
{
  // skip lights which are behind the face
  float perp = lt_plane_normal[0] * light.x +
               lt_plane_normal[1] * light.y +
               lt_plane_normal[2] * light.z - lt_plane_dist;
   
  if (perp <= 0)
    return;

  // skip lights which are too far away
  if (light.kind != LTK_Sun && perp > light.radius)
    return;

  int W = lmap->width;
  int H = lmap->height;

  for (int t = 0 ; t < H ; t++)
  for (int s = 0 ; s < W ; s++)
  {
    const quake_vertex_c & V = lt_points[t*W + s];

    if (! QCOM_TraceRay(V.x, V.y, V.z, light.x, light.y, light.z))
      continue;

    if (light.kind == LTK_Sun)
    {
      lmap->Add(s, t, light.level);
    }
    else
    {
      float dist = ComputeDist(V.x, V.y, V.z, light.x, light.y, light.z);

      if (dist < light.radius)
      {
        lmap->Add(s, t, light.level * (1.0 - dist / light.radius));
      }
    }
  }

  lmap->Store();
}


void QCOM_LightFace(quake_face_c *F)
{
  lt_face = F;

  CalcFaceVectors(F);
  CalcFaceExtents(F);

  int W = lt_tex_size[0];
  int H = lt_tex_size[1];

  CalcPoints(W, H);

  F->lmap = BSP_NewLightmap(W, H, LOW_LIGHT);

  for (unsigned int i = 0 ; i < qk_all_lights.size() ; i++)
  {
    QCOM_ProcessLight(F->lmap, qk_all_lights[i]);
  }
}


void QCOM_LightMapModel(quake_mapmodel_c *model)
{
  float value = LOW_LIGHT;

  float mx = (model->x1 + model->x2) / 2.0;
  float my = (model->y1 + model->y2) / 2.0;
  float mz = (model->z1 + model->z2) / 2.0;

  for (unsigned int i = 0 ; i < qk_all_lights.size() ; i++)
  {
    quake_light_t & light = qk_all_lights[i];

    if (! QCOM_TraceRay(mx, my, mz, light.x, light.y, light.z))
      continue;

    if (light.kind == LTK_Sun)
    {
      value += light.level;
    }
    else
    {
      float dist = ComputeDist(mx, my, mz, light.x, light.y, light.z);

      if (dist < light.radius)
      {
        value += light.level * (1.0 - dist / light.radius);
      }
    }
  }

  model->light = CLAMP(0, I_ROUND(value), 255);
}


void QCOM_LightAllFaces()
{
  LogPrintf("\nLighting World...\n");

  QCOM_FindLights();
  QCOM_MakeTraceNodes();

  for (unsigned int i = 0 ; i < qk_all_faces.size() ; i++)
  {
    quake_face_c *F = qk_all_faces[i];    

    // FIXME: check elsewhere, handling liquid surfaces too 
    if (strncmp(F->texture.c_str(), "sky", 3) == 0)
      continue;

    QCOM_LightFace(F);

    if (i % 400 == 0)
      Main_Ticker();
  }

  // now do map models

  for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
  {
    QCOM_LightMapModel(qk_all_mapmodels[i]);
  }

  QCOM_FreeLights();
  QCOM_FreeTraceNodes();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
