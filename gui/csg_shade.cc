//------------------------------------------------------------------------
//  DOOM SHADING / LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2013-2015 Andrew Apted
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
#include "lib_argv.h"
#include "main.h"

#include "csg_main.h"
#include "csg_local.h"

#include "q_common.h"
#include "q_light.h"
#include "vis_occlude.h"


/*

Lighting Model
--------------

1. for indoor (non-sky) areas, default light level is given by the
   'indoor_light' value.

2. an AMBIENT light brush provides a different default for those areas.

3. under a SKY brush, default light level is the 'sky_bright' value.
   when a SHADOW light brush is present, the 'sky_shade' value is used
   instead.  [ SHADOW brushes have no other effect than this ]

4. every normal LIGHT brush in an area will test against the above
   value and the MAXIMUM value will be applied.

5. any floor or non-sky ceiling brush can supply a 'light' property in
   its top/bottom face.  It is equivalent to having a LIGHT brush there
   with the specified value.  [ liquid areas often use this ]

TODO : handle lighting effects 

TODO : handle 3D floors properly [ move 'shade' field to gap_c ?? ]

*/

int indoor_light;

int sky_bright;
int sky_shade;


static int current_region_group;


#if 0  // NOT USED, BUT POTENTIALLY USEFUL

struct outdoor_box_t
{
	int x1, y1, x2, y2;
};


static void SHADE_CollectBoxes()
{
	outdoor_box_t box;

	for (unsigned int i = 0 ; i < all_entities.size() ; i++)
	{
		csg_entity_c *E = all_entities[i];

		if (strcmp(E->id.c_str(), "oblige_box") != 0)
			continue;

		const char *box_type = E->props.getStr("box_type", "");

		if (strcmp(box_type, "outdoor") != 0)
			continue;

		box.x1 = E->props.getInt("x1");
		box.y1 = E->props.getInt("y1");
		box.x2 = E->props.getInt("x2");
		box.y2 = E->props.getInt("y2");

		if (box.x1 >= box.x2 || box.y1 >= box.y2)
		{
			LogPrintf("WARNING: bad outdoor box: (%d %d) .. (%d %d)\n",
					  box.x1, box.y1, box.x2, box.y2);
			continue;
		}

		outdoor_boxes.push_back(box);
	}
}
#endif



static int SHADE_CalcRegionGroup(region_c *R)
{
	if (R->isClosed())
		return -1;

	/* group regions with a tag and same floor height */

	csg_brush_c *B = R->gaps.front()->bottom;
	csg_brush_c *T = R->gaps.back() ->top;

	csg_property_set_c *f_face = &B->t.face;
	csg_property_set_c *c_face = &T->b.face;

	// differentiate floor heights
	int base = ((int)B->t.z & 0x1FFF) << 16;

	const char *tag = f_face->getStr("tag");
	if (tag)
		return base + atoi(tag);

	tag = c_face->getStr("tag");
	if (tag)
		return base + atoi(tag);

	/* otherwise keep separate */

	int xor_val = 0;

	if (T->bkind == BKIND_Sky)  // separate sky sectors  [ why?? ]
		xor_val = 0x77777777;

	int result = current_region_group;
	current_region_group++;

	return result ^ xor_val;
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
	current_region_group = 0x40000000;  // a value outside normal tag values

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c * R = all_regions[i];

		R->index = SHADE_CalcRegionGroup(R);
	}

	// group regions together in the array
	// (this has a side-effect of placing all solid regions at the end)

	std::sort(all_regions.begin(), all_regions.end(), region_index_Compare());
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


#if 0  // OLD STUFF -- POTENTIALLY USEFUL

static void DM_LightingBrushes(doom_sector_c *S, region_c *R,
                               csg_property_set_c *f_face,
                               csg_property_set_c *c_face)
{
  S->light = R->shade;

  S->light = CLAMP(96, S->light, 255);


  // TODO effects !!


  // final light value for the sector is the 'ambient' lighting
  // in a room PLUS the greatest additive light brush MINUS the
  // greatest subtractive (shadow) brush.

  // ambient default (FIXME: make non-sky default 128)
  S->light = (S->misc_flags & SEC_IS_SKY) ? 192 : 144;

  int max_add = 0;
  int max_sub = 0;

  int effect = 0;
  int delta  = 0;

  // Doom 64 TC support : colored sectors
  // this value is a sector type, and has lowest priority
  int color = -1;

  for (unsigned int i = 0 ; i < R->brushes.size() ; i++)
  {
    csg_brush_c *B = R->brushes[i];

    if (B->bkind != BKIND_Light)
      continue;

    if (B->t.z < S->f_h+1 || B->b.z > S->c_h-1)
      continue;

    int ambient = B->props.getInt("ambient");

    int add = B->props.getInt("add");
    int sub = B->props.getInt("sub");

    if (ambient > 0)
    {
      S->light = ambient;
    }

    {
      int c = B->props.getInt("color");

      if (c >= 0)
        color = c;
    }

    max_sub = MAX(max_sub, sub);

    // this logic means that the highest 'add' brush can also supply
    // a lighting effect (a sector special) and delta difference.

    if (add > max_add)
    {
      max_add = add;
      effect = delta = 0;  // clear previous fx
    }

    if (add > 0 && add >= max_add)
    {
      int val = B->props.getInt("effect");

      if (val > 0)
      {
        effect = val;
        delta  = B->props.getInt("delta");
      }
    }
  }

  // check faces too (keywords have a 'light_' prefix here)
  for (unsigned int f = 0 ; f < 2 ; f++)
  {
    csg_property_set_c *P = (f == 0) ? f_face : c_face;

    int add = P->getInt("light_add");
    int sub = P->getInt("light_sub");

    max_sub = MAX(max_sub, sub);

    if (add > max_add)
    {
      max_add = add;
      effect = delta = 0;  // clear previous fx
    }

    if (add > 0 && add >= max_add)
    {
      int val = P->getInt("light_effect");

      if (val > 0)
      {
        effect = val;
        delta  = P->getInt("light_delta");
      }
    }

    int c = P->getInt("light_color", -1);

    if (c >= 0)
      color = c;
  }

  // an existing sector special overrides the lighting effect
  if (S->special > 0)
    effect = color = 0;

  // additive component
  S->light += max_add;

  // subtractive component (shadow), but don't disturb the FX
  if (effect == 0)
    S->light -= max_sub;

  S->light = CLAMP(80, S->light, 255);

  // hack to force complete darkness
  if (effect == 0 && max_sub >= 255)
    S->light = 0;

  if (effect > 0)
  {
    S->special = effect;
    
    if (delta)
      S->light2 = CLAMP(1, S->light + delta, 255);
  }
  else if (color > 0)
  {
    S->special = color;
  }
}
#endif


static void SHADE_VisitRegion(region_c *R)
{
	csg_brush_c *B = R->gaps.front()->bottom;
	csg_brush_c *T = R->gaps. back()->top;

	int ambient = -1;	// Unset
	int light   = -1;
	bool shadow = false;

	// process light brushes

	for (unsigned int i = 0 ; i < R->brushes.size() ; i++)
	{
		csg_brush_c *LB = R->brushes[i];

		if (LB->bkind != BKIND_Light)
			continue;

		if (LB->t.z < B->t.z+1 || LB->b.z > T->b.z-1)
			continue;

		int new_ambient = LB->props.getInt("ambient");

		if (ambient < 0 && new_ambient > 0)
			ambient = new_ambient;

		int new_light = LB->props.getInt("light");

		light = MAX(light, new_light);

		if (LB->props.getInt("shadow") > 0)
			shadow = true;
	}

	// check brush faces

	for (unsigned int pass = 0 ; pass < 2 ; pass++)
	{
		csg_property_set_c *P = (pass == 0) ? &B->t.face : &T->b.face;

		int new_light = P->getInt("light");

		light = MAX(light, new_light);
	}

	// combine

	if (T->bkind == BKIND_Sky)
		ambient = shadow ? sky_shade : sky_bright;

	if (ambient < 0)
		ambient = indoor_light;

	R->shade = CLAMP(0, MAX(ambient, light), 255);
}


static void SHADE_LightWorld()
{
	bool no_light = (ArgvFind(0, "nolight") >= 0);

	if (no_light)
		LogPrintf("LIGHTING DISABLED (-nolight specified)\n");

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c *R = all_regions[i];

		if (R->gaps.empty())
			continue;

		if (no_light)
		{
			R->shade = 192;
			continue;
		}

		SHADE_VisitRegion(R);
	} 
}


void CSG_Shade()
{
	LogPrintf("Lighting level...\n");

	SHADE_GroupRegions();
	SHADE_LightWorld();
	SHADE_MergeResults();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
