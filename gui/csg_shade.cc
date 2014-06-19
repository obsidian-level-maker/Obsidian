//------------------------------------------------------------------------
//  DOOM SHADING / LIGHTING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2013-2014 Andrew Apted
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

1. indoor rooms have a fairly low default lighting, lower still
   for low areas of the room (under periphs).  for outdoor rooms,
   when the ceiling is SKY then use the 'sky_shade' value.

2. liquid areas and ceiling lights supply extra 'light' values.

3. (NOT DONE YET) light brushes can be used to light up areas of
   non-cave rooms.

4. outdoor rooms do a sky test -- cast a ray from floor to see if a
   sky brush is hit -- if hit, use the 'sky_bright' value.

5. in caves, certain entities (torches) are used as light sources,
   and we trace rays to see what nearby cells should be lit by them
   (less light for further distances).

*/

#define MIN_SHADE  112


int sky_bright;
int sky_shade;

#define SKY_SHADE_FACTOR  2.0


static int current_region_group;


struct outdoor_box_t
{
	int x1, y1, x2, y2;
};


static std::vector< csg_entity_c *> cave_lights;

static std::vector< outdoor_box_t > outdoor_boxes;


static void SHADE_CollectBoxes()
{
	outdoor_box_t box;

	for (unsigned int i = 0 ; i < all_entities.size() ; i++)
	{
		csg_entity_c *E = all_entities[i];

		if (strcmp(E->id.c_str(), "box") != 0)
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


static inline bool SHADE_IsPointOutdoor(int x, int y)
{
	for (unsigned int k = 0 ; k < outdoor_boxes.size() ; k++)
	{
		const outdoor_box_t& box = outdoor_boxes[k];

		if (box.x1 <= x && x <= box.x2 &&
			box.y1 <= y && y <= box.y2)
		{
			return true;
		}
	}

	return false;
}


static void SHADE_CollectLights()
{
	int face_count = 0;
	int sky_count  = 0;
	int ent_count  = 0;

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c * R = all_regions[i];

		// closed regions never provide light
		if (R->isClosed())
			continue;

		csg_brush_c *B = R->gaps.front()->bottom;
		csg_brush_c *T = R->gaps.back()->top;

		csg_property_set_c *f_face = &B->t.face;
		csg_property_set_c *c_face = &T->b.face;

		R->f_light = f_face->getInt("light");
		R->c_light = c_face->getInt("light");

		if (R->f_light > 0)
		{
			R->f_factor = f_face->getDouble("factor", 1.0);
			face_count++;
		}

		if (R->c_light > 0)
		{
			R->c_factor = c_face->getDouble("factor", 1.0);
			face_count++;
		}

		// sky brushes are lit automatically
		if (! R->c_light && T->bkind == BKIND_Sky && sky_shade > 0)
		{
			R->c_light  = sky_shade;
			R->c_factor = SKY_SHADE_FACTOR;
			sky_count++;
		}

		// scan entities : choose one with largest level

		// ignore when under a day-time sky
		if (T->bkind == BKIND_Sky && sky_shade > 0)
			continue;

		for (unsigned int k = 0 ; k < R->entities.size() ; k++)
		{
			csg_entity_c *E = R->entities[k];

			if (E->props.getInt("cave_light", 0) > 0)
				cave_lights.push_back(E);

			int e_light = E->props.getInt("light", 0);

			if (e_light <= 0)
				continue;

			float e_factor = E->props.getDouble("factor", 1.0);

			if (e_light > R->e_light ||
				(e_light == R->e_light && e_factor > R->e_factor))
			{
				R->e_light  = e_light;
				R->e_factor = e_factor;
			}

			ent_count++;
		}

#if 0  // debug
		fprintf(stderr, "region %p lights: %3d / %3d / %3d\n",
				R, R->f_light, R->c_light, R->e_light);
#endif
	}

	LogPrintf("Found %d light entities, %d lit faces, %d sky faces\n",
			ent_count, face_count, sky_count);
}


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

	/* otherwise combine regions with same floor brush */

	int xor_val = 0;

	if (T->bkind == BKIND_Sky)  // separate sky sectors
		xor_val = 0x77777777;

	tag = f_face->getStr("_shade_tag");
	if (tag)
		return atoi(tag) ^ xor_val;

	int result = current_region_group;
	current_region_group++;

	char buffer[64];
	sprintf(buffer, "%d", result);

	f_face->Add("_shade_tag", buffer);

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

		int a_side = (fabs(a) < 0.1) ? 0 : (a < 0) ? -1 : +1;
		int b_side = (fabs(b) < 0.1) ? 0 : (b < 0) ? -1 : +1;

		// ray is completely outside the region?
		if (a_side > 0 && b_side > 0)
			return false;

		// ray is completely inside it?
		if (a_side <= 0 && b_side <= 0)
			continue;

		// ray touches the edge?
		if (a_side == 0 && b_side > 0)
		{
			x2 = x1; y2 = y1; z2 = z1;
			continue;
		}
		else if (b_side == 0 && a_side > 0)
		{
			x1 = x2; y1 = y2; z1 = z2;
			continue;
		}

		// clip the ray

		double frac = a / (double)(a - b);

		if (a > 0)
		{
			// start of ray lies on outside of region, move it to edge
			x1 = x1 + (x2 - x1) * frac;
			y1 = y1 + (y2 - y1) * frac;
			z1 = z1 + (z2 - z1) * frac;
		}
		else
		{
			// end of ray lies on outside of region, move it to edge
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

		if (z1 > B->t.z + 0.2) continue;
		if (z2 < B->b.z - 0.2) continue;

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

		int a_side = (fabs(a) < 0.1) ? 0 : (a < 0) ? -1 : +1;
		int b_side = (fabs(b) < 0.1) ? 0 : (b < 0) ? -1 : +1;

		if (a_side == b_side && a_side != 0)
		{
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

			continue;
		}

		int front, back;

		if (a_side == 0 && b_side == 0)
		{
			// ray is (more-or-less) co-linear with partition line,
			// hence try both sides with unmodified ray coordinates.

			front = SHADE_RecursiveSkyCheck(node->front_node, node->front_leaf, x1, y1, z1, x2, y2, z2);

//			if (front != 0)
//				return front;

			back = SHADE_RecursiveSkyCheck(node-> back_node, node-> back_leaf, x1, y1, z1, x2, y2, z2);

			if (front < 0 || back < 0)
				return -1;

			if (front > 0 || back > 0)
				return +1;

			return 0;
		}

		// compute intersection point

		double frac = a / (double)(a - b);

		float mx = x1 + (x2 - x1) * frac;
		float my = y1 + (y2 - y1) * frac;
		float mz = z1 + (z2 - z1) * frac;

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

	if (! leaf || leaf->degenerate)
		return 0;

	return SHADE_CheckSkyLeaf(leaf, x1, y1, z1, x2, y2, z2);
}


static bool SHADE_CastRayTowardSky(region_c *R, float x1, float y1)
{
	// starting Z
	csg_brush_c *B = R->gaps.front()->bottom;

	float z1 = B->t.z + 1.2;

	// end point
	float x2 = x1 + 1024;
	float y2 = y1 + 2048;
	float z2 = z1 + 2560;

	int vis = SHADE_RecursiveSkyCheck(bsp_root, NULL, x1, y1, z1, x2, y2, z2);

	return (vis == 1);
}


static bool SHADE_CanRegionSeeSun(region_c *R)
{
	unsigned int k;

	if (R->gaps.empty() || R->degenerate)
		return false;
	
	// limit to outdoor areas
	if (! SHADE_IsPointOutdoor(R->mid_x, R->mid_y))
		return false;

	// just test the middle point for smallish brushes
	if (R->rw < 30 && R->rh < 30)
		return SHADE_CastRayTowardSky(R, R->mid_x, R->mid_y);

	// otherwise test several points inside the region, and
	// require them all to succeed.
	for (k = 0 ; k < R->snags.size() ; k++)
	{
		snag_c *snag = R->snags[k];

		double sx = snag->x1;
		double sy = snag->y1;

		double x = sx * 0.7 + R->mid_x * 0.3;
		double y = sy * 0.7 + R->mid_y * 0.3;

		if (! SHADE_CastRayTowardSky(R, x, y))
			return false;
	}

	return true;
}


static void SHADE_SunLight()
{
	if (sky_bright <= MIN_SHADE)
		return;

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c *R = all_regions[i];

		if (R->index < 0)
			break;

		if (SHADE_CanRegionSeeSun(R))
		{
			// use a lower light for non-sky regions
			// (since it will affect the ceiling surface too)
			csg_brush_c *T = R->gaps.back()->top;

			int light = (T->bkind == BKIND_Sky) ? sky_bright : sky_shade;

			R->f_light = MAX(R->f_light, light);
		}
	}
}


void SHADE_CaveLighting()
{
	/* collect cavey regions */

	std::vector< region_c * > regions;

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c *R = all_regions[i];

		if (R->gaps.empty())
			continue;

		csg_brush_c *B = R->gaps.front()->bottom;

		if (! B->t.face.getInt("cavelit"))
			continue;

		regions.push_back(R);
	}

	/* iterate over all cavey light sources */

	for (unsigned int k = 0 ; k < cave_lights.size() ; k++)
	{
		csg_entity_c *E = cave_lights[k];

		double x1 = E->x;
		double y1 = E->y;
		double z1 = E->z + 64.0;

		int brightness = E->props.getInt("cave_light", 0);

		for (unsigned int i = 0 ; i < regions.size() ; i++)
		{
			region_c *R = regions[i];

			double x2 = R->mid_x;
			double y2 = R->mid_y;

			// basic distance check
			if (fabs(x1 - x2) > 800 || fabs(y1 - y2) > 800)
				continue;

			// more complex distance check
			double dist = ComputeDist(x1, y1, x2, y2);

			int level = brightness - (int)(dist / 100.0) * 16;

			if (level <= MIN_SHADE)
				continue;

			csg_brush_c *B = R->gaps.front()->bottom;

			double z2 = B->t.z + 84.0;

			// line of sight blocked?
			if (CSG_TraceRay(x1,y1,z1, x2,y2,z2, "v"))
				continue;

			R->e_light = MAX(R->e_light, level);
		}
	}
}


void SHADE_BlandLighting()
{
	int min_shade = MIN_SHADE;

	if (ArgvFind(0, "nolight") >= 0)
	{
		LogPrintf("SKIPPING SUN / CAVE LIGHTS (-nolight specified)\n");
		min_shade = 144;
	}
	else
	{
		SHADE_SunLight();

		Main_Ticker();

		SHADE_CaveLighting();

		Main_Ticker();
	}

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c *R = all_regions[i];

		if (R->gaps.empty())
			continue;

		csg_brush_c *T = R->gaps.back()->top;
		csg_brush_c *B = R->gaps.front()->bottom;

		int base = MAX(R->c_light, MAX(R->f_light, R->e_light));

		int height = I_ROUND(T->b.z - B->t.z);

		if (B->t.face.getInt("cavelit"))
			R->shade = MAX(base, min_shade);
		else if (T->bkind == BKIND_Sky)
			R->shade = MAX(sky_shade, MAX(R->f_light, min_shade));
		else
			R->shade = MAX(base, (height <= 160) ? 128 : 144);
	} 
}


void CSG_Shade()
{
	LogPrintf("Lighting level...\n");

	cave_lights.clear();
	outdoor_boxes.clear();

	SHADE_CollectBoxes();
	SHADE_CollectLights();
	SHADE_GroupRegions();
	SHADE_BlandLighting();
	SHADE_MergeResults();

	cave_lights.clear();
	outdoor_boxes.clear();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
