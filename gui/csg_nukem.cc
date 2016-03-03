//------------------------------------------------------------------------
//  CSG : DUKE NUKEM output
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
#include "hdr_ui.h"  // ui_build.h

#include <algorithm>

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "csg_main.h"
#include "csg_local.h"

#include "g_nukem.h"


// Properties


#define NK_WALL_MUL      10
#define NK_HEIGHT_MUL  -200


#define VOID_INDEX  -2


#define SEC_IS_SKY       (0x1 << 16)
#define SEC_PRIMARY_LIT  (0x2 << 16)
#define SEC_SHADOW       (0x4 << 16)


#define light_dist_factor  800.0


class nukem_sector_c;


class nukem_wall_c
{
public:
	int x1, y1;
	int x2, y2;

	snag_c *snag;

	nukem_wall_c *partner;

	nukem_sector_c *sector;

	int index;

	// texturing stuff

	int pic;
	int flags;

public:
	nukem_wall_c(int _x1, int _y1, int _x2, int _y2) :
		x1(_x1), y1(_y1), x2(_x2), y2(_y2),
		snag(NULL), partner(NULL), index(-1),
		pic(0), flags(0)
	{ }

	~nukem_wall_c()
	{ }

	void Write();
};


class nukem_plane_c
{
public:
	float h;

	int pic;
	int flags;

public:
	nukem_plane_c() : h(0), pic(0), flags(0)
	{ }

	~nukem_plane_c()
	{ }
};


class nukem_sector_c 
{
public:
	nukem_plane_c floor;
	nukem_plane_c ceil;

	region_c *region;

	std::vector<nukem_wall_c *> walls;

	std::vector<csg_entity_c *> entities;

	int mark;
	int index;

	// double mid_x, mid_y;

	int first_wall;
	int num_walls;

public:
	nukem_sector_c() :
		floor(), ceil(),
		region(NULL), walls(), entities(),
		mark(0), index(-1),
		first_wall(-1), num_walls(-1)
	{ }

	~nukem_sector_c()
	{ }

	void AddWall(nukem_wall_c *W)
	{
		W->sector = this;

		walls.push_back(W);
	}

	void AddEntity(csg_entity_c *E)
	{
		entities.push_back(E);
	}

#if 0
	bool Match(const nukem_sector_c *other) const
	{
		// deliberately absent: misc_flags

		return (f_h == other->f_h) &&
			(c_h == other->c_h) &&
			(light == other->light) &&
			(special == other->special) &&
			(tag  == other->tag)  &&
			(mark == other->mark) &&
			(strcmp(f_tex.c_str(), other->f_tex.c_str()) == 0) &&
			(strcmp(c_tex.c_str(), other->c_tex.c_str()) == 0)
	}

	void CalcMiddle()
	{
		mid_x = 0;
		mid_y = 0;

		int count = (int)region->segs.size();

		for (int i = 0; i < count; i++)
		{
			merge_segment_c *G = region->segs[i];

			// tally both start and end, as segs may face either way
			mid_x = mid_x + G->start->x + G->end->x;
			mid_y = mid_y + G->start->y + G->end->y;
		}

		if (count > 0)
		{
			mid_x /= (double)(count * 2);
			mid_y /= (double)(count * 2);
		}
	}
#endif

	nukem_wall_c *FindSnagWall(snag_c *snag)
	{
		for (unsigned int i = 0 ; i < walls.size() ; i++)
		{
			nukem_wall_c *W = walls[i];

			if (W->snag == snag)
				return W;
		}

		return NULL;
	}

	void AssignWallIndices();

	void Write();
	void WriteSprites();
	void WriteWalls();
};



static std::vector<nukem_wall_c *>   nk_all_walls;
static std::vector<nukem_sector_c *> nk_all_sectors;

static int nk_current_wall;


//------------------------------------------------------------------------

void NK_FreeStuff()
{
	unsigned int i;

	for (i = 0 ; i < nk_all_walls.size()   ; i++) delete nk_all_walls[i];
	for (i=  0 ; i < nk_all_sectors.size() ; i++) delete nk_all_sectors[i];

	nk_all_walls.clear();
	nk_all_sectors.clear();
}


static void NK_MakeBasicWall(nukem_sector_c *S, snag_c *snag)
{
	int x1 = I_ROUND( snag->x1 * NK_WALL_MUL);
	int y1 = I_ROUND(-snag->y1 * NK_WALL_MUL);

	int x2 = I_ROUND( snag->x2 * NK_WALL_MUL);
	int y2 = I_ROUND(-snag->y2 * NK_WALL_MUL);

	if (x1 == x2 && y1 == y2)
	{
		LogPrintf("WARNING: degenerate wall @ (%d %d)\n", x1, y1);
		return;
	}

	nukem_wall_c *W = new nukem_wall_c(x1, y1, x2, y2);

	W->snag = snag;

	// FIXME: MORE STUFF !!!!!!

	S->AddWall(W);
}


static void NK_GetPlaneInfo(nukem_plane_c *P, csg_property_set_c *face)
{
	P->pic = atoi(face->getStr("tex", dummy_plane_tex.c_str()));

	// FIXME: other floor / ceiling stuff

}


static void NK_DoLightingBrush(...)
{
#if 0
	for (unsigned int i = 0; i < R->brushes.size(); i++)
	{
		csg_brush_c *B = R->brushes[i];

		if (B->bkind != BKIND_Light)
			continue;

		if (B->t.z < S->f_h+1 || B->b.z > S->c_h-1)
			continue;

		csg_property_set_c *t_face = &B->t.face;
		csg_property_set_c *b_face = &B->b.face;

		double raw = b_face->getInt("light", t_face->getInt("light"));
		int light = I_ROUND(raw * 256);

		if (light < 0)
		{
			// don't put shadow in closed doors
			if (S->f_h < S->c_h)
				S->misc_flags |= SEC_SHADOW;
			continue;
		}

		if (light > S->light)
		{
			S->light = light;
			S->misc_flags |= SEC_PRIMARY_LIT;
		}
	}
#endif
}


static void NK_MakeSector(region_c *R)
{
	unsigned int i;

	// completely solid (no gaps) ?
	if (R->gaps.size() == 0)
	{
		R->index = -1;
		return;
	}


	nukem_sector_c *S = new nukem_sector_c;

	S->region = R;

	R->index = (int)nk_all_sectors.size();

	nk_all_sectors.push_back(S);


	csg_brush_c *B = R->gaps.front()->bottom;
	csg_brush_c *T = R->gaps.back() ->top;

	csg_property_set_c *f_face = &B->t.face;
	csg_property_set_c *c_face = &T->b.face;


	///???  S->CalcMiddle();


	// determine floor and ceiling heights
	// Note: are converted (via NK_HEIGHT_MUL) when sector is written

	double f_delta = f_face->getDouble("delta_z");
	double c_delta = c_face->getDouble("delta_z");

	S->floor.h = B->t.z + f_delta;
	S-> ceil.h = T->b.z + c_delta;

	if (S->ceil.h < S->floor.h)
		S->ceil.h = S->floor.h;


	NK_GetPlaneInfo(&S->floor, f_face);
	NK_GetPlaneInfo(&S->ceil,  c_face);


	int f_mark = f_face->getInt("mark");
	int c_mark = c_face->getInt("mark");

	S->mark = f_mark ? f_mark : c_mark;



	if (T->bkind == BKIND_Sky)
	{
		S->ceil.flags |= SECTOR_F_PARALLAX;
	}


	// handle Lighting brushes

	NK_DoLightingBrush(S);


	// create walls

	for (i = 0 ; i < R->snags.size() ; i++)
	{
		NK_MakeBasicWall(S, R->snags[i]);
	}


	// grab entities

	for (i = 0 ; i < R->entities.size() ; i++)
		S->AddEntity(R->entities[i]);
}


static void NK_CreateSectors()
{
	for (unsigned int i = 0 ; i < all_regions.size() ; i++)
	{
		NK_MakeSector(all_regions[i]);
	}
}


#if 0
static void LightingFloodFill(void)
{
	int i;
	std::vector<nukem_sector_c *> active;

	int valid_count = 1;

	for (i = 1; i < (int)dm_sectors.size(); i++)
	{
		nukem_sector_c *S = dm_sectors[i];

		if (S->misc_flags & SEC_PRIMARY_LIT)
		{
			active.push_back(dm_sectors[i]);
			S->valid_count = valid_count;
		}
	}

	while (! active.empty())
	{
		valid_count++;

		//fprintf(stderr, "LightingFloodFill: active=%d\n", active.size());

		std::vector<nukem_sector_c *> changed;

		for (i = 0; i < (int)active.size(); i++)
		{
			nukem_sector_c *S = active[i];

			for (int k = 0; k < (int)S->region->segs.size(); k++)
			{
				merge_segment_c *G = S->region->segs[k];

				if (! G->front || ! G->back)
					continue;

				if (G->front->index <= 0 || G->back->index <= 0)
					continue;

				nukem_sector_c *F = dm_sectors[G->front->index];
				nukem_sector_c *B = dm_sectors[G->back ->index];

				if (! (F==S || B==S))
					continue;

				if (B == S)
					std::swap(F, B);

				if (B->misc_flags & SEC_PRIMARY_LIT)
					continue;

				int light = MIN(F->light, 176);

				SYS_ASSERT(B != F);

				double dist = ComputeDist(F->mid_x,F->mid_y, B->mid_x,B->mid_y);

				double A = log(light) / log(2);
				double L2 = pow(2, A - dist / light_dist_factor);

				light = (int)L2;

				// less light through closed doors
				if (F->f_h >= B->c_h || B->f_h >= F->c_h)
					light -= 32;

				if (B->light >= light)
					continue;

				// spread brighter light into back sector

				B->light = light;

				if (B->valid_count != valid_count)
				{
					B->valid_count = valid_count;
					changed.push_back(B);
				}
			}
		}

		std::swap(active, changed);
	}

	//fprintf(stderr, "LightingFloodFill EMPTY\n");

	for (i = 0; i < (int)dm_sectors.size(); i++)
	{
		nukem_sector_c *S = dm_sectors[i];

		if (smoother_lighting)
			S->light = ((S->light + 1) / 8) * 8;
		else
			S->light = ((S->light + 3) / 16) * 16;

		if ((S->misc_flags & SEC_SHADOW))
			S->light -= (S->light > 168) ? 48 : 32;

		if (S->light <= 64)
			S->light = 96;
		else if (S->light < 112)
			S->light = 112;
		else if (S->light > 255)
			S->light = 255;
	}
}
#endif


//------------------------------------------------------------------------

static void NK_GetFaceProps(nukem_wall_c *W, csg_property_set_c *face)
{
	const char *tex_name = dummy_wall_tex.c_str();

	if (face)
	{
		tex_name = face->getStr("tex", tex_name);

		// FIXME  offsets, shade  etc...
	}

	W->pic = atoi(tex_name);
}


static void NK_TextureSolidWall(nukem_wall_c *W)
{
	csg_property_set_c *face = NULL;

	if (W->snag->partner)
	{
		float f_h = W->sector->floor.h;
		float c_h = W->sector->ceil.h;

		brush_vert_c *bvert = W->snag->partner->FindOneSidedVert((f_h + c_h) / 2.0);

		if (bvert)
			face = &bvert->face;
	}

	NK_GetFaceProps(W, face);
}


static void NK_TextureTwoSider(nukem_wall_c *W, csg_brush_c *B)
{
	SYS_ASSERT(B);

	brush_vert_c *bvert = NULL;

	if (W->snag->partner)
		bvert = W->snag->partner->FindBrushVert(B);

	// try other side (important but hacky)
	if (! bvert)
		bvert = W->snag->FindBrushVert(B);

	// fallback to something safe
	if (! bvert)
		bvert = B->verts[0];

	NK_GetFaceProps(W, &bvert->face);    
}


static void NK_TextureWallPair(nukem_wall_c *W1, nukem_wall_c *W2)
{
	W1->flags |= WALL_F_PEGGED;
	W2->flags |= WALL_F_PEGGED;

	// figure out which part of the wall sides (upper and lower) should
	// be used to get the texturing / offsets / etc for each wall.
	//
	// When one side has both a lower and upper visible, the SWAP_LOWER
	// flag is needed to allow different textures on each surface.  It
	// causes the information to be obtained from the partner wall.

	int f1 = W1->sector->floor.h;  
	int f2 = W2->sector->floor.h;  

	int c1 = W1->sector->ceil.h;  
	int c2 = W2->sector->ceil.h;  

	// 0 = lower, 1 = upper, 2 = lower on other side
	int what1 = 0;
	int what2 = 0;

	if (c1 > c2) what1 = 1;
	if (c1 < c2) what2 = 1;

	if (c1 > c2 && f1 < f2) what2 = 2;
	if (c1 < c2 && f1 > f2) what1 = 2;

	if (what1 == 2 || what2 == 2)
	{
		W1->flags |= WALL_F_SWAP_LOWER;
		W2->flags |= WALL_F_SWAP_LOWER;
	}


	region_c *R1 = W1->sector->region;
	region_c *R2 = W1->sector->region;


	csg_brush_c *brushes[2][3];

	brushes[0][0] = R1->gaps.front()->bottom;
	brushes[1][0] = R2->gaps.front()->bottom;

	brushes[0][1] = R1->gaps.back()->top;
	brushes[1][1] = R2->gaps.back()->top;

	brushes[0][2] = brushes[1][0];
	brushes[1][2] = brushes[0][0];


	NK_TextureTwoSider(W1, brushes[0][what1]);
	NK_TextureTwoSider(W2, brushes[1][what2]);
}


static void NK_PartnerWalls()
{
	for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
	{
		nukem_sector_c *S = nk_all_sectors[i];

		for (unsigned int k = 0 ; k < S->walls.size() ; k++)
		{
			nukem_wall_c *W = S->walls[k];

			if (W->partner)  // already done
				continue;

			region_c *N = W->snag->partner ? W->snag->partner->region : NULL;

			if (N && N->index >= 0)
			{
				nukem_sector_c *T = nk_all_sectors[N->index];

				W->partner = T->FindSnagWall(W->snag->partner);

				if (W->partner)
					W->partner->partner = W;
			}

			if (W->partner)
				NK_TextureWallPair(W, W->partner);
			else
				NK_TextureSolidWall(W);
		}
	}
}


//----------------------------------------------------------------------

void nukem_wall_c::Write()
{
	int point2 = index + 1;

	if (point2 >= sector->first_wall + sector->num_walls)
		point2 = sector->first_wall;


	int xscale = 8; // FIXME  1 + (int)line->length / 16;
	if (xscale > 255)
		xscale = 255;

	int lo_tag = 0;  // FIXME
	int hi_tag = 0;


	NK_AddWall(
		x1, y1, point2,
		partner ? partner->index : -1,
		partner ? partner->sector->index : -1,          
		flags, pic, 0,
		xscale, 8, 0, 0,
		lo_tag, hi_tag);
}


void nukem_sector_c::WriteSprites()
{
	for (unsigned int i = 0 ; i < entities.size() ; i++)
	{
		csg_entity_c *E = entities[i];

		int x = I_ROUND( E->x * NK_WALL_MUL);
		int y = I_ROUND(-E->y * NK_WALL_MUL);
		int z = I_ROUND( E->z * NK_HEIGHT_MUL);

		int type = atoi(E->id.c_str());

		// parse entity properties
		int flags  = E->props.getInt("flags");
		int angle  = E->props.getInt("angle");
		int lo_tag = E->props.getInt("lo_tag");
		int hi_tag = E->props.getInt("hi_tag");

		// convert angle to 0-2047 range
		angle = ((405 - angle) * 256 / 45) & 2047;

		NK_AddSprite(x, y, z, index, flags, type, angle, lo_tag, hi_tag);
	}
}


void nukem_sector_c::AssignWallIndices()
{
	first_wall = nk_current_wall;
	num_walls  = (int)walls.size();

	for (unsigned int i = 0 ; i < walls.size() ; i++)
	{
		walls[i]->index = nk_current_wall;

		nk_current_wall++;
	}
}


void nukem_sector_c::WriteWalls()
{
	for (unsigned int k = 0 ; k < walls.size() ; k++)
	{
		walls[k]->Write();
	}
}


void nukem_sector_c::Write()
{
	int visibility = 1;

	int f_h = I_ROUND(floor.h * NK_HEIGHT_MUL);
	int c_h = I_ROUND( ceil.h * NK_HEIGHT_MUL);

	NK_AddSector(first_wall, num_walls, visibility,
				 f_h, floor.pic,
				 c_h,  ceil.pic,  ceil.flags,
				 0, 0);
}


static void NK_WriteSectors()
{
	nk_current_wall = 0;

	for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
	{
		nukem_sector_c *S = nk_all_sectors[i];

		///    if (! S->used)
		///      continue;

		S->index = (int)i;

		S->AssignWallIndices();

		S->Write();
		S->WriteSprites();
	}
}


static void NK_WriteWalls()
{
	for (unsigned int i = 0 ; i < nk_all_sectors.size() ; i++)
	{
		nukem_sector_c *S = nk_all_sectors[i];

		///    if (! S->used)
		///      continue;

		S->WriteWalls();
	}
}


//------------------------------------------------------------------------

void CSG_NUKEM_Write()
{
	LogPrintf("NUKEM CSG...\n");

	nk_all_sectors.clear();
	nk_all_walls.clear();

	CSG_BSP(1.0);

	CSG_MakeMiniMap();

	NK_CreateSectors();
	NK_PartnerWalls();

	//  NK_MergeColinearLines();

	NK_WriteSectors();
	NK_WriteWalls();

	NK_FreeStuff();
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
