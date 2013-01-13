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

#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "csg_local.h"

#include "q_common.h"
#include "q_light.h"

#include <algorithm>

/*

Doom Lighting Model
-------------------

1. light comes from entities (points in 3D space)
   [ Lua code can create them for light-emitting surfaces ]

2. result value is MAXIMUM of all tests made 

3. (a) sky ceiling is like a light of 184 units
   (b) if diagonal vector (4,1,2) from floor can hit sky, light is 208
   (c) these tests are skipped for night skies

4. a "sector" here is a group of brush regions.
   rules for grouping them:

   (a) same floor brush, or
   (b) same "tag" property

5. sectors perform lighting tests at various points in sector
   (most basic: middle point of each region).  Further distance
   means lower light level [equation yet to be determined...]

6. clamp results to a certain minimum (e.g. 96)

*/

static int current_region_group;


static int SHADE_CalcRegionGroup(region_c *R)
{
  if (R->gaps.size() == 0)
    return -1;

  csg_brush_c *B = R->gaps.front()->bottom;
  csg_brush_c *T = R->gaps.back() ->top;

  csg_property_set_c *f_face = &B->t.face;
  csg_property_set_c *c_face = &T->b.face;

  const char *tag = f_face->getStr("tag");
  if (tag)
    return atoi(tag);

  tag = c_face->getStr("tag");
  if (tag)
    return atoi(tag);

  tag = f_face->getStr("_shade_tag");
  if (tag)
    return atoi(tag);

  // create a new tag for this brush

  int result = current_region_group;
  current_region_group++;
  
  char result_buf[64];
  sprintf(result_buf, "%d", result);

  f_face->Add("_shade_tag", result_buf);

  return result;
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
  current_region_group = 1000000;  // a value outside normal tag values

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


static int SHADE_TraceLeaf(region_c *leaf, shade_trace_t *trace)
{
  // FIXME

  return 1;
}


static int SHADE_RecursiveTrace(bsp_node_c *node, region_c *leaf, shade_trace_t *trace)
{
  while (node)
  {
    double a = PerpDist(trace->x1,trace->y1, node->x1,node->y1, node->x2,node->y2);
    double b = PerpDist(trace->x2,trace->y2, node->x1,node->y1, node->x2,node->y2);

    int a_side = (a < 0) ? -1 : +1;
    int b_side = (b < 0) ? -1 : +1;

    if (a_side != b_side)
    {
      int front = SHADE_RecursiveTrace(node->front_node, node->front_leaf, trace);

      if (front <= 0)
        return front;

      int back = SHADE_RecursiveTrace(node-> back_node, node-> back_leaf, trace);

      return MIN(front, back);
    }

    // traverse down a single side of the node

    if (a_side < 0)
    {
      node = node->back_node;
      leaf = node->back_leaf;
    }
    else
    {
      node = node->front_node;
      leaf = node->front_leaf;
    }
  }

  if (! leaf || leaf->degenerate)
    return 0;

  return SHADE_TraceLeaf(leaf, trace);
}


static void SHADE_ProcessLight(region_c *R, double x1, double y1,
                               quake_light_t & light)
{
  if (light.kind == LTK_Sun)
    Main_FatalError("Sun lights found in DOOM-ish format map.\n");

  float dist = ComputeDist(x1, y1, light.x, light.y);

  // FIXME: dist = dist * light.factor;

  // skip lights which are too far away
  if (dist > 999)
    return;

  // FIXME: trace !!!

  int value = light.level >> 8;

  if (dist > 110) value -= 16;
  if (dist > 220) value -= 16;
  if (dist > 330) value -= 16;
  if (dist > 440) value -= 16;
  if (dist > 580) value -= 16;
  if (dist > 730) value -= 16;

  R->shade = MAX(R->shade, value); 
}


static void SHADE_LightRegion(region_c *R)
{
  SYS_ASSERT(R->gaps.size() > 0);

  R->shade = 0;

  double mid_x, mid_y;

  R->GetMidPoint(&mid_x, &mid_y);

  for (unsigned int i = 0 ; i < qk_all_lights.size() ; i++)
  {
    SHADE_ProcessLight(R, mid_x, mid_y, qk_all_lights[i]);
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
  QCOM_FindLights();

  SHADE_GroupRegions();
  SHADE_ProcessRegions();
  SHADE_MergeResults();

  QCOM_FreeLights();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
