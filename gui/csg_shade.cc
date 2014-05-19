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

Doom Lighting Model
-------------------

1. light comes from entities (points in 3D space) and flat surfaces.
   these diminish by distance (with a controllable factor).

2. we also do a sky test -- cast a ray from floor to see if hit a sky
   brush.  When hit, use the 'sky_light' value.

3. result value is MAXIMUM of all tests made.

4. result is clamped to a certain minimum (e.g. 96)

5. solid walls and close doors block light.

6. since closed doors don't get lit, their value is computed later
   using the light from an adjacent sector.

*/

#define MIN_SHADE  96

#define DISTANCE_LIMIT  1440


int sky_light;
int sky_shade;

#define SKY_SHADE_FACTOR  2.0


static int current_region_group;

static int stat_targets;
static int stat_sources;


static const int shading_table[7][10] =
{
	// the major index is the brightness (reverse order!)

	// the minor index is distances, first is for 'level', second is
	// for 'level - 16', third is for 'level - 32', etc...

	/* 224 */ {   4,  64,  96,  96, 128, 128, 128, 128, 0 },
	/* 192 */ {   4,  64,  96, 128, 128, 128,   0 },
	/* 176 */ {  64,  96, 128, 128, 128,   0 },
	/* 160 */ {  64,  96, 128, 128,   0 },
	/* 144 */ {  96, 128, 128,   0 },
	/* 128 */ { 128, 128,   0 },
	/* 112 */ { 128,   0 },
};


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
	float z2 = z1 + 2560;

	int vis = SHADE_RecursiveSkyCheck(bsp_root, NULL, x1, y1, z1, x2, y2, z2);

	return (vis == 1);
}


static int SHADE_ComputeLevel(float dist, int light, float factor)
{
	dist = dist * 1.2 / factor;

	if (light < 112)
		return 0;

	light = light & 0xF0;

	int index = (light - 112) / 16;

	// this considers levels 192 and 208 as the same
	if (index >= 7)
		index = 6;
	else if (index == 6)
		index = 5;

	const int *pos = &shading_table[6 - index][0];

	for ( ; *pos ; pos++, light -= 16)
	{
		if (dist < *pos)
			return light;

		dist = dist - *pos;
	}

	return 0;
}



static float view_x, view_y;
static region_c * view_reg;

// bool debug_light_rend;


static void AngleRangeForLeaf(region_c *leaf, float *low, float *high)
{
	// output angles range from -180.0 to +540.0 with *low < *high

	SYS_ASSERT(leaf->snags.size() > 0);

	float baseline = CalcAngle(view_x, view_y, leaf->mid_x, leaf->mid_y);

	float l_diff = 0;
	float h_diff = 0;

	for (unsigned int k = 0 ; k < leaf->snags.size() ; k++)
	{
		snag_c *S = leaf->snags[k];

		float ang = DiffAngle(baseline, CalcAngle(view_x, view_y, S->x1, S->y1));

		l_diff = MIN(l_diff, ang);
		h_diff = MAX(h_diff, ang);
	}

	*low  = baseline + l_diff;
	*high = baseline + h_diff;
}


#define OCL_EPSILON  0.02


static void SHADE_RenderLeaf(region_c *leaf)
{
	stat_sources++;

	double dist = leaf->DistanceToPoint(view_x, view_y);

	if (dist >= DISTANCE_LIMIT)
		return;

	if (! leaf->ContainsPoint(view_x, view_y))
	{
		float ang_low  = 0;
		float ang_high = 0;

		AngleRangeForLeaf(leaf, &ang_low, &ang_high);

		if (leaf->index < 0 || leaf->isClosed())
		{
			Occlusion_Set(ang_low - OCL_EPSILON, ang_high + OCL_EPSILON);
			return;
		}

		if (Occlusion_Blocked(ang_low, ang_high))
		{
			return;
		}
	}


#if 0
	if (debug_light_rend)
	{
		fprintf(stderr, "SHADE_RenderLeaf %p @ (%1.0f %1.0f)\n", leaf, mid_x, mid_y);
		fprintf(stderr, "   gaps: %u  dist: %1.0f\n", leaf->gaps.size(), dist);
		fprintf(stderr, "   angle range: %1.5f .. %1.5f\n", ang_low, ang_high);
		fprintf(stderr, "   lights: %d / %d / %d\n", leaf->f_light, leaf->c_light, leaf->e_light);

		Occlusion_Dump();
	}
#endif


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

	csg_brush_c *T = R->gaps.back()->top;

	R->shade = MIN_SHADE;

	view_x = R->mid_x;
	view_y = R->mid_y;
	view_reg = R;

	Occlusion_Clear();

	SHADE_RecursiveRenderView(bsp_root, NULL);

	if (sky_light > 0 && SHADE_CastRayTowardSky(R, view_x, view_y))
	{
		// use a lower light for non-sky regions
		// (since it will affect the ceiling surface too)
		int light = (T->bkind == BKIND_Sky) ? sky_light : sky_shade;

		R->shade = MAX(R->shade, light);
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


void SHADE_BlandLighting()
{
	SHADE_CollectLights();

	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		region_c *R = all_regions[i];

		if (R->gaps.empty())
			continue;

		csg_brush_c *T = R->gaps.back()->top;
		csg_brush_c *B = R->gaps.front()->bottom;

		int base = MAX(R->c_light, MAX(R->f_light, R->e_light));

		int height = I_ROUND(T->b.z - B->t.z);

		if (T->bkind == BKIND_Sky)
			R->shade = MAX(sky_light, MAX(R->f_light, 120));
		else
			R->shade = MAX(base, (height <= 160) ? 128 : 144);
	} 
}


void CSG_Shade()
{
	stat_targets = stat_sources = 0;

	LogPrintf("Lighting level...\n");

	if (fast_lighting || ArgvFind(0, "nolight") >= 0)
	{
		LogPrintf("BLAND LIGHTING MODE!\n");
		SHADE_BlandLighting();
		return;
	}

	SHADE_CollectLights();

	SHADE_GroupRegions();
	SHADE_ProcessRegions();
	SHADE_MergeResults();

	LogPrintf("Lit %d targets (visited %d sources in total)\n",
			stat_targets, stat_sources);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
