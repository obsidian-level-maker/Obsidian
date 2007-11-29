//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

// this includes everything we need
#include "defs.h"


namespace level_doom
{
/* private data */

std::vector<vertex_c *>  lev_verts;
std::vector<sector_c *>  lev_sectors;
std::vector<linedef_c *> lev_lines;
std::vector<thing_c *>   lev_things;

FILE *text_fp;

level_c *out_lev;

int free_tag;


//------------------------------------------------------------------------

vertex_c::vertex_c(short _x, short _y) : x(_x), y(_y)
{ }

vertex_c::~vertex_c()
{ }


sector_c::sector_c(const char *_ftex, const char *_ctex, short _fh, short _ch) :
	floor_h(_fh), ceil_h(_ch), light(192), type(0), tag(0)
{
	SYS_ASSERT(strlen(_ftex) <= 8);
	SYS_ASSERT(strlen(_ctex) <= 8);

	strcpy(floor_tex, _ftex);
	strcpy(ceil_tex,  _ctex);
}

sector_c::~sector_c()
{ }


sidedef_c::sidedef_c() : sec(NULL), x_offset(0), y_offset(0)
{
	strcpy(upper_tex, "-");
	strcpy(lower_tex, "-");
	strcpy(mid_tex, "-");
}

sidedef_c::~sidedef_c()
{ }

void sidedef_c::SetTex(const char *_upper, const char *_lower, const char *_mid)
{
	if (! _upper) _upper = "-";
	if (! _lower) _lower = "-";
	if (! _mid  ) _mid   = "-";

	SYS_ASSERT(strlen(_upper) <= 8);
	SYS_ASSERT(strlen(_lower) <= 8);
	SYS_ASSERT(strlen(_mid) <= 8);

	strcpy(upper_tex, _upper);
	strcpy(lower_tex, _lower);
	strcpy(mid_tex,   _mid);
}


linedef_c::linedef_c(vertex_c *_s, vertex_c *_e) : start(_s), end(_e),
		front(), back(), flags(0), type(0), tag(0)
{ }

linedef_c::~linedef_c()
{ }

void linedef_c::Flip()
{
	vertex_c *temp_vert = start;
	start = end;
	end = temp_vert;

	sidedef_c temp_side = front;
	front = back;
	back = temp_side;
}


thing_c::thing_c(short _x, short _y, short _type) : x(_x), y(_y),
		angle(90), type(_type), options(7)
{ }

thing_c::~thing_c()
{ }


//------------------------------------------------------------------------
//  TEXT OUTPUT
//------------------------------------------------------------------------

void T_WriteVertexes()
{
    fprintf(text_fp, "VERTEXES_START\n");

	for (int i = 0; i < (int)lev_verts.size(); i++)
	{
		vertex_c *V = lev_verts[i];
		if (! V) continue;

		fprintf(text_fp, "V%d : %d %d\n", V->wad_index, V->x, V->y);
	}

    fprintf(text_fp, "VERTEXES_END\n");
}

void T_WriteSectors()
{
    fprintf(text_fp, "SECTORS_START\n");

	for (int i = 0; i < (int)lev_sectors.size(); i++)
	{
		sector_c *S = lev_sectors[i];
		if (! S) continue;

		fprintf(text_fp, "S%d : %d %d %s %s %d %d %d\n", S->wad_index,
				S->floor_h, S->ceil_h, S->floor_tex, S->ceil_tex,
				S->light, S->type, S->tag);
	}

    fprintf(text_fp, "SECTORS_END\n");
}

void T_WriteLinedefs()
{
    fprintf(text_fp, "LINEDEFS_START\n");

	for (int i = 0; i < (int)lev_lines.size(); i++)
	{
		linedef_c *L = lev_lines[i];
		if (! L) continue;

		if (! L->front.sec && ! L->back.sec)
			continue;

		SYS_ASSERT(L->front.sec);

		fprintf(text_fp, "V%d V%d : %d %d %d\n",
				L->start->wad_index, L->end->wad_index,
				L->flags, L->type, L->tag);

		fprintf(text_fp, "   S%d %d %d %s %s %s\n", L->front.sec->wad_index,
				L->front.x_offset, L->front.y_offset,
				L->front.upper_tex, L->front.lower_tex, L->front.mid_tex);

		if (! L->back.sec)
		{
			fprintf(text_fp, "   -\n");
		}
		else
		{
			fprintf(text_fp, "   S%d %d %d %s %s %s\n", L->back.sec->wad_index,
					L->back.x_offset, L->back.y_offset,
					L->back.upper_tex, L->back.lower_tex, L->back.mid_tex);
		}
	}

    fprintf(text_fp, "LINEDEFS_END\n");
}

void T_WriteThings()
{
    fprintf(text_fp, "THINGS_START\n");

	for (int i = 0; i < (int)lev_things.size(); i++)
	{
		thing_c *T = lev_things[i];
		if (! T) continue;

		fprintf(text_fp, "%d : %d %d %d %d\n", T->type,
				T->x, T->y, T->angle, T->options);
	}

    fprintf(text_fp, "THINGS_END\n");
}


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

void W_WriteVertexes()
{
	lump_c *lump = the_wad->CreateLump("VERTEXES", the_level);

	raw_vertex_t raw_vert;

	for (int i = 0; i < (int)lev_verts.size(); i++)
	{
		vertex_c *V = lev_verts[i];
		if (! V) continue;

		raw_vert.x = SINT16(V->x);
		raw_vert.y = SINT16(V->y);

		lump->Append(&raw_vert, sizeof(raw_vert));
	}
}

void W_WriteSectors()
{
	lump_c *lump = the_wad->CreateLump("SECTORS", the_level);

	raw_sector_t raw_sect;

	for (int i = 0; i < (int)lev_sectors.size(); i++)
	{
		sector_c *S = lev_sectors[i];
		if (! S) continue;

		raw_sect.floor_h = SINT16(S->floor_h);
		raw_sect. ceil_h = SINT16(S-> ceil_h);

		memcpy(raw_sect.floor_tex, S->floor_tex, 8);
		memcpy(raw_sect. ceil_tex, S-> ceil_tex, 8);

		raw_sect.light   = UINT16(S->light);
		raw_sect.special = UINT16(S->type);
		raw_sect.tag     = SINT16(S->tag);

		lump->Append(&raw_sect, sizeof(raw_sect));
	}
}

void W_WriteOneSidedef(lump_c *SD_lump, const sidedef_c *SD)
{
	raw_sidedef_t raw_side;

	raw_side.x_offset = SINT16(SD->x_offset);
	raw_side.y_offset = SINT16(SD->y_offset);

	memcpy(raw_side.upper_tex, SD->upper_tex, 8);
	memcpy(raw_side.lower_tex, SD->lower_tex, 8);
	memcpy(raw_side.  mid_tex, SD->  mid_tex, 8);

	raw_side.sector = SINT16(SD->sec->wad_index);

	SD_lump->Append(&raw_side, sizeof(raw_side));
}

void W_WriteLinedefs()
{
	lump_c *LN_lump = the_wad->CreateLump("LINEDEFS", the_level);
	lump_c *SD_lump = the_wad->CreateLump("SIDEDEFS", the_level);

	raw_linedef_t raw_line;

	int cur_side_idx = 0;
	
	for (int i = 0; i < (int)lev_lines.size(); i++)
	{
		linedef_c *L = lev_lines[i];
		if (! L) continue;

		raw_line.start = UINT16(L->start->wad_index);
		raw_line.  end = UINT16(L->  end->wad_index);

		raw_line.flags = UINT16(L->flags);
		raw_line.type  = UINT16(L->type);
		raw_line.tag   = SINT16(L->tag);

		raw_line.sidedef1 = 0xFFFF;
		raw_line.sidedef2 = 0xFFFF;

		if (L->front.sec)
		{
			raw_line.sidedef1 = UINT16(cur_side_idx);
			cur_side_idx++;

			W_WriteOneSidedef(SD_lump, &L->front);
		}

		if (L->back.sec)
		{
			raw_line.sidedef2 = UINT16(cur_side_idx);
			cur_side_idx++;

			W_WriteOneSidedef(SD_lump, &L->back);
		}

		LN_lump->Append(&raw_line, sizeof(raw_line));
	}
}

void W_WriteThings()
{
	lump_c *lump = the_wad->CreateLump("THINGS", the_level);

	raw_thing_t raw_thing;

	for (int i = 0; i < (int)lev_things.size(); i++)
	{
		thing_c *T = lev_things[i];
		if (! T) continue;

		raw_thing.x = SINT16(T->x);
		raw_thing.y = SINT16(T->y);

		raw_thing.angle   = SINT16(T->angle);
		raw_thing.type    = UINT16(T->type);
		raw_thing.options = UINT16(T->options);

		lump->Append(&raw_thing, sizeof(raw_thing));
	}
}


//------------------------------------------------------------------------
//  CONSTRUCTION (world -> level)
//------------------------------------------------------------------------

inline int VX(int bx, int offset = 0)
{
	return (bx - (the_world->w() / 2)) * 64 + offset;
}

inline int VY(int by, int offset = 0)
{
	return (by - (the_world->h() / 2)) * 64 + offset;
}

int FreeTag()
{
	free_tag++;

	return free_tag - 1;
}

const char *PlaneTex(const location_c& loc)
{
	switch (loc.mat)
	{
		// Land
		case MAT_Grass:  return "GRASS2";
		case MAT_Sand:   return "MFLR8_3";
		case MAT_Rock:   return "RROCK04";
		case MAT_Stone:  return "MFLR8_1";

		// Water
		case MAT_Water:  return "FWATER1";
		case MAT_Lava:   return "LAVA1";
		case MAT_Nukage: return "NUKAGE1";
		case MAT_Slime:  return "SLIME01";
		case MAT_Blood:  return "BLOOD1";

		// Building
		case MAT_Lead:   return "FLOOR4_8";
		case MAT_Alum:   return "FLAT9";
		case MAT_Tech:   return "FLOOR1_1";
		case MAT_Light:  return "TLITE6_1";
		case MAT_Wood:   return "CEIL1_1";
		case MAT_Brick:  return "FLAT1_1";
		case MAT_Marble: return "SLIME13";

		// Cave
		case MAT_Ash:    return "FLAT10";

		default:
			return "SFLR7_1";  // ILLEGAL
	}
}

const char *FloorTex(const location_c& loc)
{
	switch (loc.stru)
	{
		case STRU_CoopStart:
		case STRU_DM_Start:
		case STRU_LandingPad: return "FLAT22";

		case STRU_Teleporter: return "GATE3";

		case STRU_Stairs: return "TLITE6_1";
		case STRU_Lift: return "STEP1";
		case STRU_Door: return "FLAT20";
		case STRU_Bars: return "FLAT17";

		default: break;  // check the material
	}

	return PlaneTex(loc);
}

const char *CeilingTex(const location_c& loc)
{
	if (loc.Void())
		return "SFLR7_1";  // ILLEGAL

	if (loc.env <= ENV_Water && loc.stru != STRU_Door)
		return "F_SKY1";

	if (loc.stru == STRU_Door)
		return "FLAT20";

	return PlaneTex(loc);
}

const char *SideTex(const location_c& loc)
{
	switch (loc.mat)
	{
		// Land
		case MAT_Grass:  return "ZIMMER1";
		case MAT_Sand:   return "TANROCK2";
		case MAT_Rock:   return "TANROCK5";
		case MAT_Stone:  return "STONE";

		// Water
		case MAT_Water:  return "COMPBLUE";
		case MAT_Lava:   return "DBRAIN1";
		case MAT_Nukage: return "SFALL1";
		case MAT_Slime:  return "BLAKWAL1";
		case MAT_Blood:  return "BFALL1";

		// Building
		case MAT_Lead:   return "METAL";
		case MAT_Alum:   return "STARGR2";
		case MAT_Tech:   return "TEKGREN1"; // "COMPTALL";
		case MAT_Light:  return "LITE3";
		case MAT_Wood:   return "WOOD1";
		case MAT_Brick:  return "BRICK7";
		case MAT_Marble: return "GSTONE1";

		// Cave
		case MAT_Ash:    return "ASHWALL4";

		default:
			return "SLOPPY2";  // ILLEGAL
	}
}

bool SameSector(const location_c& loc, const location_c& other)
{
	bool loc_walk = (loc.stru == 0) || (loc.stru == STRU_Railing) ||
					(loc.stru == STRU_Railing2);

	bool other_walk = (other.stru == 0) || (other.stru == STRU_Railing) ||
					  (other.stru == STRU_Railing2);

	return loc.env == other.env &&
	       loc.mat == other.mat &&
		   loc.area == other.area &&
		   loc.floor_h == other.floor_h &&
		   loc.ceil_h == other.ceil_h &&
		   (loc.stru == other.stru || (loc_walk && other_walk));
}

void CreateSector(int bx, int by, location_c& loc)
{
///---	// handle 2x2 (or bigger) lifts, etc..
///---	if (loc.stru == STRU_Lift ||
///---		!(loc.stru == 0 || loc.stru == STRU_Railing || loc.stru == STRU_Railing2))
///---	{
///---		if (bx > 0 && SameSector(loc, the_world->Loc(bx-1, by)))
///---			return the_world->Loc(bx-1, by).sec_idx;
///---
///---		if (by > 0 && SameSector(loc, the_world->Loc(bx, by-1)))
///---			return the_world->Loc(bx, by-1).sec_idx;
///---	}

	loc.sec_idx = lev_sectors.size();

	sector_c *SS = new sector_c(FloorTex(loc), CeilingTex(loc),
		short(loc.floor_h) * 64, short(loc.ceil_h) * 64);

	lev_sectors.push_back(SS);

	if (loc.env == ENV_Water)
	{
		switch (loc.mat)
		{
			case MAT_Slime:  SS->type = SECTYPE_DAMAGE_5;  SS->floor_h -= 32; break;
			case MAT_Nukage: SS->type = SECTYPE_DAMAGE_10; SS->floor_h -= 32; break;
			case MAT_Lava:   SS->type = SECTYPE_DAMAGE_20; SS->floor_h -= 32; break;

			default: SS->floor_h -= 16; break;
		}
	}

	if (loc.stru == STRU_Lift)
		SS->tag = FreeTag();

	// spread sector to other blocks

	int changes;

	for (;;)
	{
		changes = 0;

		FOR_LOC(x, y, tmp_loc)
		{
			if (tmp_loc.sec_idx != loc.sec_idx)
				continue;

			static int dxs[4] = { -1, +1, 0, 0 };
			static int dys[4] = { 0, 0, -1, +1 };

			for (int d = 0; d < 4; d++)
			{
				if (the_world->Outside(x+dxs[d], y+dys[d]))
					continue;

				location_c& other = the_world->Loc(x+dxs[d], y+dys[d]);
				
				if (other.sec_idx == -1 && SameSector(loc, other))
				{
					other.sec_idx = loc.sec_idx;
					changes++;
				}
			}
		}}

		if (changes == 0)
			break;
	}
#if 0
	if (! (loc.stru == 0 || loc.stru == STRU_Railing || loc.stru == STRU_Railing2))
		return;

	FOR_LOC(x, y, other)
    {
		if (x == bx && y == by)
			continue;

		if (SameSector(loc, other))
		{
			SYS_ASSERT(other.sec_idx == -1);

			other.sec_idx = loc.sec_idx;
		}
	}}
#endif
}

void ConstructSectors()
{
	FOR_LOC(x, y, loc)
    {
		if (loc.Void() || loc.stru == STRU_Wall)
			continue;

		if (loc.sec_idx != -1)
			continue;

		CreateSector(x, y, loc);
	}}
}

char OppositeDir(char dir)
{
	switch (dir)
	{
		case LOCDIR_E: return LOCDIR_W;
		case LOCDIR_W: return LOCDIR_E;

		case LOCDIR_N: return LOCDIR_S;
		case LOCDIR_S: return LOCDIR_N;

		default:
			AssertFail("OppositeDir: bad dir value 0x%x\n", dir);
			return 0 /* NOT REACHED */;
   }	
}

vertex_c *CreateVertex(int rx, int ry)
{
	for (int i = 0; i < (int)lev_verts.size(); i++)
	{
		SYS_ASSERT(lev_verts[i]);

		if (lev_verts[i]->Match(rx, ry))
			return lev_verts[i];
	}

	vertex_c *V = new vertex_c(rx, ry);

	lev_verts.push_back(V);

	return V;
}

void CreateSidedef(sidedef_c *SD, const location_c& loc, char face_dir,
		const location_c& other, bool one_sided)
{
	SYS_ASSERT(! (loc.Void() || loc.stru == STRU_Wall));

	SYS_ASSERT(loc.sec_idx >= 0);
	SYS_ASSERT(loc.sec_idx < (int)lev_sectors.size());

	SD->sec = lev_sectors[loc.sec_idx];

	const char *upper_tex = 
				other.mat == MAT_INVALID ? SideTex(loc) :
				other.stru == STRU_Bars ? "MODWALL4" :
				other.stru == STRU_Door ?
					( (other.s_act == 1) ? "DOORBLU2" :
					  (other.s_act == 2) ? "DOORRED2" :
					  (other.s_act == 3) ? "DOORYEL2" : "SPCDOOR2" ) :
				SideTex(other);

	const char *lower_tex = 
				other.mat == MAT_INVALID ? SideTex(loc) :
				other.stru == STRU_Lift ? "SUPPORT2" : SideTex(other);
	/* !!! PLAT1 */

	const char *rail_tex = "-";

	if (! one_sided)
	{
		if ((loc.stru == STRU_Railing && (loc.s_dir & face_dir)) ||
			(other.stru == STRU_Railing) && (other.s_dir & OppositeDir(face_dir)))
			rail_tex = "MIDBRONZ";
		else if ((loc.stru == STRU_Railing2 && (loc.s_dir & face_dir)) ||
				 (other.stru == STRU_Railing2) && (other.s_dir & OppositeDir(face_dir)))
			rail_tex = "MIDGRATE";
	}

	if (one_sided)
		SD->SetTex("-", "-", lower_tex);
	else
		SD->SetTex(upper_tex, lower_tex, rail_tex);
}

void TryAddLinedef(int sx, int sy, int ex, int ey,
	const location_c& front, const location_c& back, char face_dir)
{
	if ((front.Void() || front.stru == STRU_Wall) &&
	    (back.Void()  || back.stru  == STRU_Wall))
	{
		return;
	}

	if (SameSector(front, back))
		return;

	if (front.Void() || front.stru == STRU_Wall ||
		(! back.Void() && back.stru == 0 &&
		 (front.stru == STRU_Door || front.stru == STRU_Lift ||
		  front.stru == STRU_Bars ||
		  front.stru == STRU_Teleporter)))
	{
		TryAddLinedef(ex, ey, sx, sy, back, front, OppositeDir(face_dir));
		return;
	}

	bool one_sided = (back.Void() || back.stru == STRU_Wall);

	linedef_c *L = new linedef_c(CreateVertex(VX(sx), VY(sy)),
								 CreateVertex(VX(ex), VY(ey)));

	lev_lines.push_back(L);

	// determine sidedef info...
	CreateSidedef(&L->front, front, face_dir, back, one_sided);
	if (! one_sided)
		CreateSidedef(&L->back, back, OppositeDir(face_dir), front, false);

	if (one_sided)
		L->flags |= ML_IMPASSABLE;
	else
		L->flags |= ML_TWOSIDED;

	if (L->front.mid_tex[0] != '-' || L->back.mid_tex[0] != '-')  // FIXME: hack
		L->flags |= ML_IMPASSABLE | ML_LOWER_UNPEG;

	L->type = (back.stru == STRU_Wall) ? 48 :
	           (back.stru == STRU_Door) ? 
			      (	(MAX(back.s_act, front.s_act) == 1) ? 32 :
					(MAX(back.s_act, front.s_act) == 2) ? 33 :
					(MAX(back.s_act, front.s_act) == 3) ? 34 : 1 ) :
	           (back.stru == STRU_Lift) ? 123 : 0;

    if (back.stru == STRU_Lift)
	{
		SYS_ASSERT(L->back.sec);

		L->tag = L->back.sec->tag;
	}
}

void ConstructSwitch(int bx, int by, location_c& loc)
{
	vertex_c *v1 = CreateVertex(VX(bx,8), VY(by,8));
	vertex_c *v2 = CreateVertex(VX(bx,56), VY(by,8));
	vertex_c *v3 = CreateVertex(VX(bx,56), VY(by,56));
	vertex_c *v4 = CreateVertex(VX(bx,8), VY(by,56));

	linedef_c *L[4];
	
	L[0] = new linedef_c(v1, v2);
	L[1] = new linedef_c(v2, v3);
	L[2] = new linedef_c(v3, v4);
	L[3] = new linedef_c(v4, v1);

	SYS_ASSERT(loc.sec_idx >= 0);

	L[0]->front.sec = lev_sectors[loc.sec_idx];
	L[0]->front.SetTex("-", "-", (loc.s_act & LOCACT_EXIT) ? "SW1WOOD" : "SW1COMM");
	L[0]->front.x_offset = 8;

	L[0]->back = L[0]->front;

	L[0]->flags = ML_IMPASSABLE | ML_TWOSIDED | ML_LOWER_UNPEG;
	L[0]->type  = 102;  // floor down to HEF
	L[0]->tag   = loc.Area()->stage + 11;

	if (loc.s_act & LOCACT_EXIT)
		L[0]->type = 11;

	for (int idx=0; idx < 4; idx++)
	{
		if (idx > 0)
		{
			L[idx]->front = L[0]->front;
			L[idx]->back  = L[0]->back;

			L[idx]->flags = L[0]->flags;
			L[idx]->type  = L[0]->type;
			L[idx]->tag   = L[0]->tag;
		}

		lev_lines.push_back(L[idx]);
	}
}

void ProcessBlock(int x, int y)
{
	location_c dummy;
	dummy.env = ENV_VOID;
	dummy.mat = MAT_INVALID;

	location_c& mid   = the_world->Outside(x, y)   ? dummy : the_world->Loc(x, y);
	location_c& left  = the_world->Outside(x-1, y) ? dummy : the_world->Loc(x-1, y);
	location_c& below = the_world->Outside(x, y-1) ? dummy : the_world->Loc(x, y-1);

	TryAddLinedef(x, y, x, y+1, mid, left,  LOCDIR_W);
	TryAddLinedef(x+1, y, x, y, mid, below, LOCDIR_S);

	if (the_world->Inside(x, y) && mid.stru == STRU_Switch)
		ConstructSwitch(x, y, mid);
}

void ConstructLinedefs()
{
	// Note the <= here, we go one past the edge (far right and bottom)
    for (int y = 0; y <= the_world->h(); y++)
    for (int x = 0; x <= the_world->w(); x++)
    {
        ProcessBlock(x, y);
    }
}

void ConstructThings()
{
	static const int stage_things[8] = //!!!! stage debugging
	{ 2014, 2015, 2048, 2008, 2010, 2047, 79, 15 };

	FOR_LOC(x, y, loc)
    {
        if (loc.Void())
            continue;

		area_c *A = the_world->Area(loc.area);
		if (! A || A->island < 0 || A->stage < 0)
			continue;

		//!!!! stage debugging
  		if (RandomPerc(25))
			AddThing(x, y, stage_things[A->stage]);
    }}
}

void SetIndices()
{
	int i;
	int cur_vert = 0;
	int cur_sec  = 0;

	for (i = 0; i < (int)lev_verts.size(); i++)
		if (lev_verts[i])
			lev_verts[i]->wad_index = cur_vert++;

	for (i = 0; i < (int)lev_sectors.size(); i++)
		if (lev_sectors[i])
			lev_sectors[i]->wad_index = cur_sec++;
}

//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void AddThing(short x, short y, short type)
{
if (type == 1) fprintf(stderr, "PLAYER ADDED AT %d,%d\n", x, y);
	lev_things.push_back(new thing_c(VX(x,32), VY(y,32), type));
}

void Construct()
{
	free_tag = 100;

	ConstructSectors();
	ConstructLinedefs();
	ConstructThings();

	SetIndices();
}

void Cleanup()
{
	int i;

	for (i = 0; i < (int)lev_verts.size(); i++)
		delete lev_verts[i];

	for (i = 0; i < (int)lev_sectors.size(); i++)
		delete lev_sectors[i];

	for (i = 0; i < (int)lev_lines.size(); i++)
		delete lev_lines[i];

	for (i = 0; i < (int)lev_things.size(); i++)
		delete lev_things[i];
	
	lev_verts.resize(0);
	lev_sectors.resize(0);
	lev_lines.resize(0);
	lev_things.resize(0);
}

void WriteText(const char *filename)
{
	text_fp = fopen(filename, "wb");  // "wb"

	if (! text_fp)
		FatalError("Unable to create file: %s\n", filename);

	Construct();

    fprintf(text_fp, "LEVEL_START 0 1 0 Doom2\n");

    T_WriteVertexes();
    T_WriteSectors();
    T_WriteLinedefs();
    T_WriteThings();

    fprintf(text_fp, "LEVEL_END\n");

	fclose(text_fp);
	text_fp = NULL;

	Cleanup();
}

void WriteWAD(const char *filename)
{
	Construct();

	the_wad = new wad_c();

	the_level = the_wad->CreateLevel("MAP01");

    W_WriteVertexes();
    W_WriteSectors();
    W_WriteLinedefs();
    W_WriteThings();

	/* add empty nodes, blockmap and reject lumps */

	the_wad->CreateLump("SEGS", the_level);
	the_wad->CreateLump("SSECTORS", the_level);
	the_wad->CreateLump("NODES", the_level);
	the_wad->CreateLump("BLOCKMAP", the_level);
	the_wad->CreateLump("REJECT", the_level);

	the_level = NULL;

	the_wad->Save(filename);

	Cleanup();
}


}  // namespace level_doom
