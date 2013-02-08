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

1. light comes from entities (points in 3D space) and flat surfaces

2. result value is MAXIMUM of all tests made 

3. result is clamped to a certain minimum (e.g. 96)

4. solid walls and close doors block light

5. light diminishes by distance

6. since closed doors don't get lit, there value is computed later
   using the light from an adjacent sector.

*/

#define MIN_SHADE  96

#define DISTANCE_LIMIT  1400


int sky_light;
int sky_shade;

#define SKY_SHADE_FACTOR  2.0


static int current_region_group;

static int stat_targets;
static int stat_traces;


static void SHADE_CollectLights()
{
  for (unsigned int i = 0 ; i < all_regions.size() ; i++)
  {
    region_c * R = all_regions[i];

    // closed regions never provide light
    if (R->gaps.size() == 0)
      continue;

    csg_brush_c *B = R->gaps.front()->bottom;
    csg_brush_c *T = R->gaps.back()->top;

    csg_property_set_c *f_face = &B->t.face;
    csg_property_set_c *c_face = &T->b.face;

    R->f_light = f_face->getInt("light");
    R->c_light = c_face->getInt("light");

    if (R->f_light > 0)
        R->f_factor = f_face->getDouble("_factor", 1.0);

    if (R->c_light > 0)
        R->c_factor = c_face->getDouble("_factor", 1.0);

    // sky brushes are lit automatically
    if (! R->c_light && T->bkind == BKIND_Sky && sky_shade > 0)
    {
      R->c_light  = sky_shade;
      R->c_factor = SKY_SHADE_FACTOR;
    }

    // scan entities : choose one with largest level

    for (unsigned int k = 0 ; k < R->entities.size() ; k++)
    {
      csg_entity_c *E = R->entities[k];

      if (strcmp(E->id.c_str(), "light") != 0)
        continue;

      int   e_light  = E->props.getInt("light", 0);
      float e_factor = E->props.getDouble("_factor", 1.0);

      if (e_light > R->e_light ||
          (e_light == R->e_light && e_factor > R->e_factor))
      {
        R->e_light  = e_light;
        R->e_factor = e_factor;
      }
    }
    
#if 0  // debug
fprintf(stderr, "region %p lights: %3d / %3d / %3d\n",
        R, R->f_light, R->c_light, R->e_light);
#endif
  }
}


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




static float view_x, view_y;
static region_c * view_reg;


static void AngleRangeForLeaf(region_c *leaf, float *low, float *high)
{
  SYS_ASSERT(leaf->snags.size() > 0);

  *low  = +9e9;
  *high = -9e9;

  for (unsigned int k = 0 ; k < leaf->snags.size() ; k++)
  {
    snag_c *S = leaf->snags[k];

    float ang = CalcAngle(view_x, view_y, S->x1, S->y1);

    *low  = MIN(*low,  ang);
    *high = MAX(*high, ang);
  }

  if (*high - *low > 180.0)
  {
    std::swap(*low, *high);
  }
}


static void SHADE_RenderLeaf(region_c *leaf)
{
  double dist = leaf->DistanceToPoint(view_x, view_y);

  if (! leaf->ContainsPoint(view_x, view_y))
  {
    if (dist >= DISTANCE_LIMIT)
      return;

    float ang_low;
    float ang_high;

    AngleRangeForLeaf(leaf, &ang_low, &ang_high);

    if (leaf->gaps.size() == 0)
    {
      Occlusion_Set(ang_low, ang_high);
      return;
    }

    if (Occlusion_Blocked(ang_low, ang_high))
      return;
  }

  // apply lighting from this region

  if (leaf->f_light > MIN_SHADE)
  {
    int f_shade = SHADE_ComputeLevel(dist, leaf->f_light, leaf->f_factor);
    view_reg->shade = MAX(view_reg->shade, f_shade);
  }

  if (leaf->c_light > MIN_SHADE)
  {
    int c_shade = SHADE_ComputeLevel(dist, leaf->c_light, leaf->c_factor);
    view_reg->shade = MAX(view_reg->shade, c_shade);
  }

  if (leaf->e_light > MIN_SHADE)
  {
    int e_shade = SHADE_ComputeLevel(dist, leaf->e_light, leaf->e_factor);
    view_reg->shade = MAX(view_reg->shade, e_shade);
  }
}


static bool SHADE_IsNodeOccluded(bsp_node_c *node)
{
  // determine rough relative position of node bbox to view
  int x_pos, y_pos;

  if (node->bb_x1 > view_x)
    x_pos = 2;
  else if (node->bb_x2 < view_x)
    x_pos = 0;
  else
    x_pos = 1;

  if (node->bb_y1 > view_y)
    y_pos = 2;
  else if (node->bb_y2 < view_y)
    y_pos = 0;
  else
    y_pos = 1;

  int pos = y_pos * 3 + x_pos;

  // node surrounds view point?
  if (pos == 4)
    return false;

  // determine corners of bbox to use

  float x1 = (0x00f & (1 << pos)) ? node->bb_x2 : node->bb_x1;
  float x2 = (0x1c8 & (1 << pos)) ? node->bb_x2 : node->bb_x1;

  float y1 = (0x126 & (1 << pos)) ? node->bb_y2 : node->bb_y1;
  float y2 = (0x04b & (1 << pos)) ? node->bb_y2 : node->bb_y1;

  float high = CalcAngle(view_x, view_y, x1, y1);
  float low  = CalcAngle(view_x, view_y, x2, y2);

  return Occlusion_Blocked(low, high);
}


static void SHADE_RecursiveRenderView(bsp_node_c *node, region_c *leaf)
{
  while (node)
  {
    // distance check  [TODO: better check]
    if (node->bb_x1 >= view_x + DISTANCE_LIMIT ||
        node->bb_x2 <= view_x - DISTANCE_LIMIT ||
        node->bb_y1 >= view_y + DISTANCE_LIMIT ||
        node->bb_y2 <= view_y - DISTANCE_LIMIT)
    {
      return;
    }

    if (SHADE_IsNodeOccluded(node))
      return;

    // decide which side to visit first

    double a = PerpDist(view_x,view_y, node->x1,node->y1, node->x2,node->y2);

    if (a > -0.01)
    {
      SHADE_RecursiveRenderView(node->front_node, node->front_leaf);

      leaf = node->back_leaf;
      node = node->back_node;
    }
    else
    {
      SHADE_RecursiveRenderView(node-> back_node, node-> back_leaf);

      leaf = node->front_leaf;
      node = node->front_node;
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
  view_reg = R;

  Occlusion_Clear();

  SHADE_RecursiveRenderView(bsp_root, NULL);

  if (sky_light > 0 && SHADE_CastRayTowardSky(R, mid_x, mid_y))
  {
    R->shade = MAX(R->shade, sky_light);
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

  SHADE_CollectLights();

  SHADE_GroupRegions();
  SHADE_ProcessRegions();
  SHADE_MergeResults();

  QCOM_FreeLights();

  LogPrintf("Lit %d targets, with %d vis tests\n", stat_targets, stat_traces);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
