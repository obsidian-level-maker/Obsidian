//------------------------------------------------------------------------
//  DOOM SHADING / LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2013 Andrew Apted
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

#include <algorithm>

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "csg_local.h"

#include "q_common.h"
#include "q_light.h"
#include "vis_occlude.h"


/*

Doom Lighting Model
-------------------

1. light comes from entities (points in 3D space)
   [ Lua code can create them for light-emitting surfaces ]

2. result value is MAXIMUM of all tests made 

3. result is clamped to a certain minimum (e.g. 96)

4. (a) sky will use light entities too (e.g. 184 units)
   (b) if diagonal vector (4,1,2) from floor can hit sky, light is 208
   (c) both these tests are skipped for night skies

5. a "sector" here is a group of brush regions.
   rules for grouping them:

   (a) same floor brush, or
   (b) same "tag" property

6. sectors perform lighting tests at various points in sector
   (most basic: middle point of each region).  If the LOS is
   blocked, no light is transferred.  Further distance means
   lower light level.

7. closed sectors (e.g. doors) block light, hence they determine
   their lighting value as the value of an adjacent region.

*/

#define MIN_SHADE  96

#define DISTANCE_LIMIT  1600


int shade_sky_level = 200;  // FIXME: a way to set this from Lua


static int current_region_group;

static int stat_targets;
static int stat_traces;


static int SHADE_CalcRegionGroup(region_c *R)
{
  if (R->gaps.size() == 0)
    return -1;

  csg_brush_c *B = R->gaps.front()->bottom;
  csg_brush_c *T = R->gaps.back() ->top;

  csg_property_set_c *f_face = &B->t.face;
  csg_property_set_c *c_face = &T->b.face;

  // differentiate floor heights
  int base = ((int)B->t.z & 0x1FF8) << 17;

  const char *tag = f_face->getStr("tag");
  if (tag)
    return base + atoi(tag);

  tag = c_face->getStr("tag");
  if (tag)
    return base + atoi(tag);

  tag = f_face->getStr("_shade_tag");
  if (tag)
    return base + atoi(tag);

  // create a new tag for this brush

  int result = current_region_group;

  char result_buf[64];
  sprintf(result_buf, "%d", result);

  f_face->Add("_shade_tag", result_buf);

  current_region_group++;
  if (current_region_group == 0xFFFFF)
    current_region_group = 0x10000;

  return base + result;
}


struct region_index_Compare
{
  inline bool operator() (const region_c *A, const region_c *B) const
  {
    return A->index > B->index;
  }
};


static void SHADE_GroupRegions()
{
  current_region_group = 0x10000;  // a value outside normal tag values

  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c * R = all_regions[i];

    R->index = SHADE_CalcRegionGroup(R);
  }

  // group regions together in the array
  // (this has a side-effect of placing all solid regions at the end)

  std::sort(all_regions.begin(), all_regions.end(), region_index_Compare());
}


typedef struct
{
  float x1, y1;
  float x2, y2;
}
shade_trace_t;


static int SHADE_TraceLeaf(region_c *leaf)
{
  if (leaf->gaps.size() == 0)
    return 0;

  int z1 = leaf->gaps.front()->bottom->t.z;
  int z2 = leaf->gaps.back() ->top->b.z;

  // close door?
  if (z2 - z1 <= 4)
    return 0;  // should be 10 or 20, but not supported yet

  return 100;
}


static int SHADE_RecursiveTrace(bsp_node_c *node, region_c *leaf,
                                float x1, float y1,
                                float x2, float y2)
{
  while (node)
  {
    double a = PerpDist(x1,y1, node->x1,node->y1, node->x2,node->y2);
    double b = PerpDist(x2,y2, node->x1,node->y1, node->x2,node->y2);

    int a_side = (a < 0) ? -1 : +1;
    int b_side = (b < 0) ? -1 : +1;

    if (a_side != b_side)
    {
      // compute intersection point
      
      double frac = a / (double)(a - b);

      float mx = x1 + (x2 - x1) * frac;
      float my = y1 + (y2 - y1) * frac;

      int front, back;

      // traverse down the side containing the start point

      if (a_side < 0)
        front = SHADE_RecursiveTrace(node-> back_node, node-> back_leaf, x1, y1, mx, my);
      else
        front = SHADE_RecursiveTrace(node->front_node, node->front_leaf, x1, y1, mx, my);

      if (front <= 0)
        return front;

      // traverse down the side containing the end point

      if (a_side < 0)
        back = SHADE_RecursiveTrace(node->front_node, node->front_leaf, mx, my, x2, y2);
      else
        back = SHADE_RecursiveTrace(node-> back_node, node-> back_leaf, mx, my, x2, y2);

      return MIN(front, back);
    }

    // traverse down a single side of the node

    if (a_side < 0)
    {
      leaf = node->back_leaf;
      node = node->back_node;
    }
    else
    {
      leaf = node->front_leaf;
      node = node->front_node;
    }
  }

  if (! leaf || leaf->degenerate)
    return 100;

  return SHADE_TraceLeaf(leaf);
}


static int SHADE_CheckSkyLeaf(region_c *leaf,
                              float x1, float y1, float z1,
                              float x2, float y2, float z2)
{
  // check if ray intersects this region (in 2D)
  // [logic is basically the same as csg_brush_c::IntersectRay]

  for (unsigned int k = 0 ; k < leaf->snags.size() ; k++)
  {
    snag_c *snag = leaf->snags[k];

    double a = -PerpDist(x1,y1, snag->x1,snag->y1, snag->x2,snag->y2);
    double b = -PerpDist(x2,y2, snag->x1,snag->y1, snag->x2,snag->y2);

    // ray is completely outside the region?
    if (a > 0 && b > 0)
      return false;

    // ray is completely inside it?
    if (a <= 0 && b <= 0)
      continue;

    // gotta clip the ray

    double frac = a / (double)(a - b);

    if (a > 0)
    {
      x1 = x1 + (x2 - x1) * frac;
      y1 = y1 + (y2 - y1) * frac;
      z1 = z1 + (z2 - z1) * frac;
    }
    else
    {
      x2 = x1 + (x2 - x1) * frac;
      y2 = y1 + (y2 - y1) * frac;
      z2 = z1 + (z2 - z1) * frac;
    }
  }

  // at here, the clipped ray lies inside the region

  if (z1 > z2)
    std::swap(z1, z2);

  for (unsigned int k = 0 ; k < leaf->brushes.size() ; k++)
  {
    csg_brush_c *B = leaf->brushes[k];

    if (z1 > B->t.z) continue;
    if (z2 < B->b.z) continue;

    if (B->bkind == BKIND_Sky)
      return +1;
    else
      return -1;
  }

  if (leaf->gaps.size() == 0)
    return -1;

  return 0;  // hit nothing
}


/* returns:
 *   -1 : hit solid brush
 *    0 : hit nothing at all
 *   +1 : hit sky brush
 */
static int SHADE_RecursiveSkyCheck(bsp_node_c *node, region_c *leaf,
                                   float x1, float y1, float z1,
                                   float x2, float y2, float z2)
{
  while (node)
  {
    double a = PerpDist(x1,y1, node->x1,node->y1, node->x2,node->y2);
    double b = PerpDist(x2,y2, node->x1,node->y1, node->x2,node->y2);

    int a_side = (a < 0) ? -1 : +1;
    int b_side = (b < 0) ? -1 : +1;

    if (a_side != b_side)
    {
      // compute intersection point
      
      double frac = a / (double)(a - b);

      float mx = x1 + (x2 - x1) * frac;
      float my = y1 + (y2 - y1) * frac;
      float mz = z1 + (z2 - z1) * frac;

      int front, back;

      // traverse down the side containing the start point

      if (a_side < 0)
        front = SHADE_RecursiveSkyCheck(node-> back_node, node-> back_leaf, x1, y1, z1, mx, my, mz);
      else
        front = SHADE_RecursiveSkyCheck(node->front_node, node->front_leaf, x1, y1, z1, mx, my, mz);

      if (front != 0)
        return front;

      // traverse down the side containing the end point

      if (a_side < 0)
        back = SHADE_RecursiveSkyCheck(node->front_node, node->front_leaf, mx, my, mz, x2, y2, z2);
      else
        back = SHADE_RecursiveSkyCheck(node-> back_node, node-> back_leaf, mx, my, mz, x2, y2, z2);

      return back;
    }

    // traverse down a single side of the node

    if (a_side < 0)
    {
      leaf = node->back_leaf;
      node = node->back_node;
    }
    else
    {
      leaf = node->front_leaf;
      node = node->front_node;
    }
  }

  if (! leaf || leaf->degenerate)
    return 0;

  return SHADE_CheckSkyLeaf(leaf, x1, y1, z1, x2, y2, z2);
}


static bool SHADE_CastRayTowardSky(region_c *R, float x1, float y1)
{
  // starting Z
  csg_brush_c *B = R->gaps.front()->bottom;

  float z1 = B->t.z + 0.5;

  // end point
  float x2 = x1 + 1024;
  float y2 = y1 + 2048;
  float z2 = z1 + 3072;

  int vis = SHADE_RecursiveSkyCheck(bsp_root, NULL, x1, y1, z1, x2, y2, z2);

  return (vis == 1);
}


static inline void SHADE_ComputeLevel(quake_light_t& light, double x, double y)
{
  double dist = ComputeDist(x, y, light.x, light.y);

  dist = dist / light.factor;

  light.style = (light.level >> 8) - (int)dist / 6;

  if (light.style > 0)
      light.style &= 0xF0;
}


static inline int SHADE_ComputeLevel(float dist, int light, float factor)
{
  dist = dist / factor;

  int result = light - (int)dist / 5;

  if (result > 0)
    result &= 0xF0;

  return result;
}


static void SHADE_ProcessLight(region_c *R, double x, double y, quake_light_t & light)
{
  if (light.kind == LTK_Sun)
    Main_FatalError("Sun lights found in DOOM-ish format map.\n");

  // skip lights which cannot increase the maximum
  if (light.style <= R->shade)
    return;

  int vis = SHADE_RecursiveTrace(bsp_root, NULL, x, y, light.x, light.y);

  stat_traces++;

  if (vis == 0)
    return;

  R->shade = light.style;
}


static float view_x, view_y;


static void SHADE_RenderLeaf(region_c *leaf)
{
  // FIXME : determine angle range

  // FIXME : if (! Occlusion_Test(low, high))
  //           return;

  if (leaf->gaps.size() == 0)
  {
    // FIXME : Occlusion_Set(low, high);

    return;
  }

  // FIXME : visit light entities in this region
  //         (test them for occlusion)

  // handle lit faces
  // FIXME: pre-collect this information

  csg_brush_c *B = leaf->gaps.front()->bottom;
  csg_brush_c *T = leaf->gaps.back()->top;

  csg_property_set_c *f_face = &B->t.face;
  csg_property_set_c *c_face = &T->b.face;

  int f_level = f_face->getInt("light");
  int c_level = c_face->getInt("light");

  if (f_level < MIN_SHADE && c_level < MIN_SHADE)
    return;

  float dist = 123; // FIXME : distance to region

  float f_factor = f_face->getDouble("_factor", 1.0);
  float c_factor = c_face->getDouble("_factor", 1.0);

  if (f_level > MIN_SHADE)
  {
    int f_shade = SHADE_ComputeLevel(dist, f_level, f_factor);
    leaf->shade = MAX(leaf->shade, f_shade);
  }

  if (c_level > MIN_SHADE)
  {
    int c_shade = SHADE_ComputeLevel(dist, c_level, c_factor);
    leaf->shade = MAX(leaf->shade, c_shade);
  }
}


static void SHADE_RecursiveRenderView(bsp_node_c *node, region_c *leaf)
{
  while (node)
  {
    // !!!! FIXME: check if node bbox is occluded OR TOO FAR AWAY

    double a = PerpDist(view_x,view_y, node->x1,node->y1, node->x2,node->y2);

    // handle case of view point sitting on partition line
    if (fabs(a) < 1.0)
    {
      SHADE_RecursiveRenderView(node->front_node, node->front_leaf);
      SHADE_RecursiveRenderView(node-> back_node, node-> back_leaf);
      return;
    }

    if (a > 0)
    {
      leaf = node->front_leaf;
      node = node->front_node;
    }
    else
    {
      leaf = node->back_leaf;
      node = node->back_node;
    }
  }

  if (! leaf || leaf->degenerate)
    return;

  SHADE_RenderLeaf(leaf);
}


static void SHADE_LightRegion(region_c *R)
{
  SYS_ASSERT(R->gaps.size() > 0);

  R->shade = MIN_SHADE;

  double mid_x, mid_y;

  R->GetMidPoint(&mid_x, &mid_y);

  view_x = mid_x;
  view_y = mid_y;

  Occlusion_Clear();

  SHADE_RecursiveRenderView(bsp_root, NULL);

  // TODO: a way to quickly ignore far away lights (e.g. put in a quadtree)

  for (unsigned int i = 0 ; i < qk_all_lights.size() ; i++)
  {
    SHADE_ComputeLevel(qk_all_lights[i], mid_x, mid_y);

    SHADE_ProcessLight(R, mid_x, mid_y, qk_all_lights[i]);
  }

  if (shade_sky_level > 0 && SHADE_CastRayTowardSky(R, mid_x, mid_y))
  {
    R->shade = MAX(R->shade, shade_sky_level);
  }
}


static void SHADE_ProcessRegions()
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c *R = all_regions[i];

    if (R->index < 0)
      break;

    SHADE_LightRegion(all_regions[i]);

    stat_targets++;

    if (stat_targets % 400 == 0)
    {
      Main_Ticker();

      if (main_action >= MAIN_CANCEL)
        break;
    }
  }
}


static void SHADE_MergeResults()
{
  unsigned int i, k, n;

  // ensure groups get same value in every region

  for (i = 0 ; i < all_regions.size() ; i = k + 1)
  {
    if (all_regions[i]->index < 0)
      break;

    k = i;

    for (k = i ; k + 1 < all_regions.size() &&
                 all_regions[k+1]->index == all_regions[i]->index ; k++)
    { }

    int result = 0;

    for (n = i ; n <= k ; n++)
      result = MAX(result, all_regions[n]->shade);

    for (n = i ; n <= k ; n++)
      all_regions[n]->shade = result;
  }
}


void CSG_Shade()
{
  stat_targets = stat_traces = 0;

  QCOM_FindLights();

  LogPrintf("Found %u lights\n", qk_all_lights.size());

  SHADE_GroupRegions();
  SHADE_ProcessRegions();
  SHADE_MergeResults();

  QCOM_FreeLights();

  LogPrintf("Lit %d targets, with %d vis tests\n", stat_targets, stat_traces);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
