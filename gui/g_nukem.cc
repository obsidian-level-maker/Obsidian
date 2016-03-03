//------------------------------------------------------------------------
//  2.5D CSG : NUKEM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010 Andrew Apted
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
#include "hdr_ui.h"  // ui_build.h

#include <algorithm>

#include "lib_file.h"
#include "lib_util.h"
#include "lib_grp.h"

#include "main.h"
#include "m_cookie.h"
#include "m_lua.h"

#include "img_all.h"

#include "csg_main.h"
#include "q_common.h"  // qLump_c

#include "g_nukem.h"


extern void CSG_NUKEM_Write();


// Properties
static char *level_name;


static qLump_c *nk_sectors;
static qLump_c *nk_walls;
static qLump_c *nk_sprites;

static raw_nukem_map_t nk_header;


static void NK_FreeLumps()
{
	delete nk_sectors;  nk_sectors = NULL;
	delete nk_walls  ;  nk_walls   = NULL;
	delete nk_sprites;  nk_sprites = NULL;
}


static void NK_WriteLump(const char *name, qLump_c *lump)
{
	SYS_ASSERT(strlen(name) <= 11);

	GRP_NewLump(name);

	int len = lump->GetSize();

	if (len > 0)
	{
		if (! GRP_AppendData(lump->GetBuffer(), len))
		{
			//    errors_seen++;
		}
	}

	GRP_FinishLump();
}


bool NK_StartGRP(const char *filename)
{
	if (! GRP_OpenWrite(filename))
		return false;

	qLump_c *info = BSP_CreateInfoLump();
	NK_WriteLump("OBLIGE.DAT", info);
	delete info;

	return true;
}


void NK_EndGRP(void)
{
	GRP_CloseWrite();
}


void NK_BeginLevel(const char *level_name)
{
	char lump_name[40];

	sprintf(lump_name, "%s.MAP", level_name);
	StringUpper(lump_name);

	GRP_NewLump(lump_name);

	// initialise the header
	memset(&nk_header, 0, sizeof(nk_header));

	nk_header.version = LE_U32(DUKE_MAP_VERSION);

	// create the lumps
	NK_FreeLumps();

	nk_sectors = new qLump_c;
	nk_walls   = new qLump_c;
	nk_sprites = new qLump_c;
}


void NK_EndLevel()
{
	// write everything...

	u16_t num_sectors = LE_U16(NK_NumSectors());
	u16_t num_walls   = LE_U16(NK_NumWalls());
	u16_t num_sprites = LE_U16(NK_NumSprites());

	GRP_AppendData(&nk_header, (int)sizeof(nk_header));

	GRP_AppendData(&num_sectors, 2);
	GRP_AppendData(nk_sectors->GetBuffer(), nk_sectors->GetSize());

	GRP_AppendData(&num_walls, 2);
	GRP_AppendData(nk_walls->GetBuffer(), nk_walls->GetSize());

	GRP_AppendData(&num_sprites, 2);
	GRP_AppendData(nk_sprites->GetBuffer(), nk_sprites->GetSize());

	GRP_FinishLump();

	NK_FreeLumps();
}


void NK_AddSector(int first_wall, int num_wall, int visibility,
                  int f_h, int f_pic,
                  int c_h, int c_pic, int c_flags,
                  int lo_tag, int hi_tag)
{
	raw_nukem_sector_t raw;

	memset(&raw, 0, sizeof(raw));

	raw.wall_ptr = LE_U16(first_wall);
	raw.wall_num = LE_U16(num_wall); 

	raw.floor_h = LE_S32(f_h);
	raw.ceil_h  = LE_S32(c_h);

	raw.floor_pic = LE_U16(f_pic);
	raw.ceil_pic  = LE_U16(c_pic);

	raw.ceil_flags = LE_U16(c_flags);

	// preven the space skies from killing the player
	if (c_flags & SECTOR_F_PARALLAX)
		raw.ceil_palette = 3;

	raw.visibility = visibility;

	raw.lo_tag = LE_U16(lo_tag);
	raw.hi_tag = LE_U16(hi_tag);
	raw.extra  = LE_U16(-1);

	nk_sectors->Append(&raw, sizeof(raw));
}


void NK_AddWall(int x, int y, int right, int back, int back_sec, 
                int flags, int pic, int mask_pic,
                int xscale, int yscale, int xpan, int ypan,
                int lo_tag, int hi_tag)
{
	raw_nukem_wall_t raw;

	memset(&raw, 0, sizeof(raw));

	raw.x = LE_S32(x);
	raw.y = LE_S32(y);

	raw.right_wall = LE_U16(right);

	raw.back_wall = LE_U16(back);
	raw.back_sec  = LE_U16(back_sec);

	raw.pic      = LE_U16(pic);
	raw.mask_pic = LE_U16(mask_pic);
	raw.flags    = LE_U16(flags);

	raw.xscale = xscale;  raw.xpan = xpan;
	raw.yscale = yscale;  raw.ypan = ypan;

	raw.lo_tag = LE_U16(lo_tag);
	raw.hi_tag = LE_U16(hi_tag);
	raw.extra  = LE_U16(-1);

	nk_walls->Append(&raw, sizeof(raw));
}


void NK_AddSprite(int x, int y, int z, int sec,
                  int flags, int pic, int angle,
                  int lo_tag, int hi_tag)
{
	raw_nukem_sprite_t raw;

	memset(&raw, 0, sizeof(raw));

	raw.x = LE_S32(x);
	raw.y = LE_S32(y);
	raw.z = LE_S32(z);

	raw.flags  = LE_U16(flags);
	raw.pic    = LE_U16(pic);
	raw.angle  = LE_U16(angle);
	raw.sector = LE_U16(sec);

	raw.xscale = 40;
	raw.yscale = 40;
	raw.clip_dist = 32;

	raw.lo_tag = LE_U16(lo_tag);
	raw.hi_tag = LE_U16(hi_tag);
	raw.extra  = LE_U16(-1);

	raw.owner = -1;

	if (NK_NumSprites() == 0 || pic == 1405 /* APLAYER */)
	{
		nk_header.pos_x  = raw.x;
		nk_header.pos_y  = raw.y;
		nk_header.pos_z  = raw.z;
		nk_header.angle  = raw.angle;
		nk_header.sector = raw.sector;
	}

	nk_sprites->Append(&raw, sizeof(raw));
}


int NK_NumSectors()
{
	return nk_sectors->GetSize() / sizeof(raw_nukem_sector_t);
}

int NK_NumWalls()
{
	return nk_walls->GetSize() / sizeof(raw_nukem_wall_t);
}

int NK_NumSprites()
{
	return nk_sprites->GetSize() / sizeof(raw_nukem_sprite_t);
}


//------------------------------------------------------------------------
//  ART STUFF
//------------------------------------------------------------------------

#define LOGO_ART_FILE  "TILES020.ART"
#define LOGO_START  6600

#define MAX_LOGOS  8


class nukem_picture_c
{
public:
	int width;
	int height;
	int anim;

	byte *pixels;

public:
	nukem_picture_c(int _W, int _H) : width(_W), height(_H), anim(0)
	{
		pixels = new byte[width * height];
	}

	~nukem_picture_c()
	{
		delete[] pixels;
	}

	byte& at(int x, int y) const
	{
		return pixels[y * width + x];
	}

	void Clear()
	{
		memset(pixels, 0, width * height);
	}

	void Write()
	{
		GRP_AppendData(pixels, width * height);
	}
};


static nukem_picture_c *nk_logos[MAX_LOGOS];


void NK_InitArt()
{
	for (int i = 0 ; i < MAX_LOGOS ; i++)
	{
		if (nk_logos[i])
		{
			delete nk_logos[i];
			nk_logos[i] = NULL;
		}
	}
}


int NK_grp_logo_gfx(lua_State *L)
{
	// LUA: grp_logo_gfx(index, image, W, H, colmap)

	int index = luaL_checkint(L, 1);
	if (index < 1 || index > MAX_LOGOS)
		return luaL_argerror(L, 1, "index value out of range");

	index--;

	const char *image = luaL_checkstring(L, 2);

	int new_W  = luaL_checkint(L, 3);
	int new_H  = luaL_checkint(L, 4);
	int map_id = luaL_checkint(L, 5);

	if (new_W < 1) return luaL_argerror(L, 3, "bad width");
	if (new_H < 1) return luaL_argerror(L, 4, "bad height");

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_argerror(L, 5, "colmap value out of range");


	// find the requested image (TODO: look in a table)
	const logo_image_t *logo = NULL;

	if (StringCaseCmp(image, logo_BOLT.name) == 0)
		logo = &logo_BOLT;
	else if (StringCaseCmp(image, logo_PILL.name) == 0)
		logo = &logo_PILL;
	else if (StringCaseCmp(image, logo_CARVE.name) == 0)
		logo = &logo_CARVE;
	else if (StringCaseCmp(image, logo_RELIEF.name) == 0)
		logo = &logo_RELIEF;
	else
		return luaL_argerror(L, 2, "unknown image name");


	// colorize logo
	color_mapping_t *map = &color_mappings[map_id-1];

	if (map->size < 2)
		return luaL_error(L, "grp_logo_gfx: colormap too small");


	nukem_picture_c *pic = new nukem_picture_c(new_W, new_H);

	if (nk_logos[index])
		delete nk_logos[index];

	nk_logos[index] = pic;


	byte *pixels = pic->pixels;
	byte *p_end = pixels + (logo->width * logo->height);

	const byte *src = logo->data;

	for (byte *dest = pixels; dest < p_end; dest++, src++)
	{
		int idx = ((*src) * map->size) >> 8;

		*dest = map->colors[idx];
	}

	return 0;
}


void NK_WriteLogos()
{
	GRP_NewLump(LOGO_ART_FILE);

	int i;

	for (i = 0 ; i < MAX_LOGOS ; i++)
	{
		if (! nk_logos[i])
		{
			nk_logos[0] = new nukem_picture_c(8, 8);
			nk_logos[0]->Clear();
		}
	}

	raw_art_header_t header;

	header.version = LE_U32(1);

	header.num_pics  = LE_U32(8);
	header.first_pic = LE_U32(LOGO_START);
	header.last_pic  = LE_U32(LOGO_START+MAX_LOGOS-1);

	GRP_AppendData(&header, sizeof(header));

	for (i = 0 ; i < MAX_LOGOS ; i++)
	{
		u16_t width = LE_U16(nk_logos[i]->width);
		GRP_AppendData(&width, sizeof(width));
	}

	for (i = 0 ; i < MAX_LOGOS ; i++)
	{
		u16_t height = LE_U16(nk_logos[i]->height);
		GRP_AppendData(&height, sizeof(height));
	}

	for (i = 0 ; i < MAX_LOGOS ; i++)
	{
		u32_t anim = LE_U32(nk_logos[i]->anim);
		GRP_AppendData(&anim, sizeof(anim));
	}

	for (i = 0 ; i < MAX_LOGOS ; i++)
		nk_logos[i]->Write();

	GRP_FinishLump();

	// free them now
	NK_InitArt();
}


//------------------------------------------------------------------------
//  GAME  INTERFACE
//------------------------------------------------------------------------

class nukem_game_interface_c : public game_interface_c
{
private:
	const char *filename;

public:
	nukem_game_interface_c() : filename(NULL)
	{ }

	~nukem_game_interface_c()
	{
		StringFree(filename);
	}

	bool Start();
	bool Finish(bool build_ok);

	void BeginLevel();
	void EndLevel();
	void Property(const char *key, const char *value);

private:
};


bool nukem_game_interface_c::Start()
{
	if (batch_mode)
		filename = StringDup(batch_output_file);
	else
		filename = DLG_OutputFilename("grp");

	if (! filename)
	{
		Main_ProgStatus("Cancelled");
		return false;
	}

	if (create_backups)
		Main_BackupFile(filename, "old");

	if (! NK_StartGRP(filename))
	{
		Main_ProgStatus("Error (create file)");
		return false;
	}

	if (main_win)
		main_win->build_box->Prog_Init(0, "CSG");

	return true;
}


bool nukem_game_interface_c::Finish(bool build_ok)
{
	NK_EndGRP();

	// remove the file if an error occurred
	if (! build_ok)
		FileDelete(filename);
	else
		Recent_AddFile(RECG_Output, filename);

	return build_ok;
}


void nukem_game_interface_c::BeginLevel()
{
}


void nukem_game_interface_c::Property(const char *key, const char *value)
{
	if (StringCaseCmp(key, "level_name") == 0)
	{
		level_name = StringDup(value);
	}
	else if (StringCaseCmp(key, "description") == 0)
	{
		// ignored (for now)
		// [another mechanism sets the description via BEX/DDF]
	}
	else
	{
		LogPrintf("WARNING: unknown NUKEM property: %s=%s\n", key, value);
	}
}


void nukem_game_interface_c::EndLevel()
{
	if (! level_name)
		Main_FatalError("Script problem: did not set level name!\n");

	NK_BeginLevel(level_name);

	if (main_win)
		main_win->build_box->Prog_Step("CSG");

	CSG_NUKEM_Write();

	NK_EndLevel();

	StringFree(level_name);
	level_name = NULL;
}


game_interface_c * Nukem_GameObject()
{
	return new nukem_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
