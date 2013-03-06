//------------------------------------------------------------------------
//  EXTRA stuff for DOOM
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2008-2009 Andrew Apted
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

#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"

#include "main.h"
#include "m_lua.h"

#include "csg_main.h"

#include "dm_extra.h"
#include "g_doom.h"
#include "q_common.h"  // qLump_c

#include "img_all.h"
#include "tx_forge.h"
#include "tx_skies.h"


static byte *sky_pixels;
static int sky_W;
static int sky_H;
static int sky_final_W;


#define CUR_PIXEL(py)  (pixels[((py) % H) * W])

static void AddPost(qLump_c *lump, int y, int len,
                    const byte *pixels, int W, int H)
{
	if (len <= 0)
		return;

	byte buffer[512];
	byte *dest = buffer;

	*dest++ = y;     // Y-OFFSET
	*dest++ = len;   // # PIXELS

	*dest++ = CUR_PIXEL(y);  // TOP-PADDING

	for (; len > 0; len--, y++)
		*dest++ = CUR_PIXEL(y);

	*dest++ = CUR_PIXEL(y-1);  // BOTTOM-PADDING

	lump->Append(buffer, dest - buffer);
}

static void EndOfPost(qLump_c *lump)
{
	byte datum = 255;

	lump->Append(&datum, 1);
}


qLump_c * DM_CreatePatch(int new_W, int new_H, int ofs_X, int ofs_Y,
		const byte *pixels, int W, int H,
		int trans_p = -1)
{
	qLump_c *lump = new qLump_c();

	int x, y;

	u32_t *offsets  = new u32_t[new_W];
	u32_t beginning = sizeof(raw_patch_header_t) + new_W * 4;

	for (x = 0; x < W; x++, pixels++)
	{
		offsets[x] = beginning + (u32_t)lump->GetSize();

		for (y = 0; y < new_H; )
		{
			if (trans_p >= 0 && CUR_PIXEL(y) == trans_p)
			{
				y++; continue;
			}

			int len = 1;

			while ((y+len) < new_H && len < 240 &&
					! (trans_p >= 0 && CUR_PIXEL(y+len) == trans_p))
			{
				len++;
			}

			if (y <= 252)
				AddPost(lump, y, len, pixels, W, H);

			y = y + len;
		}

		EndOfPost(lump);
	}

	for (x = W; x < new_W; x++)
		offsets[x] = offsets[x % W];

	lump->Prepend(offsets, new_W * sizeof(u32_t));

	delete[] offsets;


	raw_patch_header_t header;

	header.width    = LE_U16(new_W);
	header.height   = LE_U16(new_H);
	header.x_offset = LE_U16(ofs_X);
	header.y_offset = LE_U16(ofs_Y);

	lump->Prepend(&header, sizeof(header));

	return lump;
}

#undef CUR_PIXEL

qLump_c * DM_CreateFlat(int new_W, int new_H, const byte *pixels, int W, int H)
{
	qLump_c *lump = new qLump_c();

	// create a skewed but working flat when original is 128x32
	if (W != new_W && W == new_W*2 && H*2 == new_H)
	{
		for (int y = 0; y < new_H; y++)
		for (int x = 0; x < new_W; x++)
		{
			int oy = (y + x / 2) % new_H;
			int ox = x + ((oy >= H) ? W/2 : 0);

			lump->Append(& pixels[(oy%H) * W + (ox%W)], 1);
		}
		return lump;
	}

	for (int y = 0; y < new_H; y++)
	for (int x = 0; x < new_W; x += W)
	{
		int span = MIN(W, new_W - x);

		SYS_ASSERT(span > 0);

		lump->Append(& pixels[(y%H) * W + (x%W)], span);
	}

	return lump;
}


static byte * Flat_Realign(const byte *pixels, int W, int H, int dx=32, int dy=32)
{
	byte *new_pix = new byte[W * H];

	for (int y = 0; y < H; y++)
	for (int x = 0; x < W; x++)
	{
		int nx = (x + dx + W) % W;
		int ny = (y + dy + H) % H;

		new_pix[ny*W + nx] = pixels[y*W + x];
	}

	return new_pix;
}


int DM_wad_logo_gfx(lua_State *L)
{
	// LUA: wad_logo_gfx(lump, kind, image, W, H, colmap)

	const char *patch = luaL_checkstring(L, 1);
	const char *kind  = luaL_checkstring(L, 2);
	const char *image = luaL_checkstring(L, 3);

	bool is_flat = false;
	bool realign = false;

	if (strchr(kind, 'p'))
		is_flat = false;
	else if (strchr(kind, 'f'))
		is_flat = true;
	else
		return luaL_argerror(L, 2, "unknown kind");

	if (strchr(kind, 'm'))
		realign = true;

	int new_W  = luaL_checkint(L, 4);
	int new_H  = luaL_checkint(L, 5);
	int map_id = luaL_checkint(L, 6);

	if (new_W < 1) return luaL_argerror(L, 4, "bad width");
	if (new_H < 1) return luaL_argerror(L, 5, "bad height");

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_argerror(L, 6, "colmap value out of range");


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
		return luaL_argerror(L, 3, "unknown image name");


	// colorize logo
	color_mapping_t *map = &color_mappings[map_id-1];

	if (map->size < 2)
		return luaL_error(L, "wad_logo_gfx: colormap too small");

	byte *pixels = new byte[logo->width * logo->height];
	byte *p_end = pixels + (logo->width * logo->height);

	const byte *src = logo->data;

	for (byte *dest = pixels; dest < p_end; dest++, src++)
	{
		int idx = ((*src) * map->size) >> 8;

		*dest = map->colors[idx];
	}


	if (realign)
	{
		byte *new_pix = Flat_Realign(pixels, logo->width, logo->height);

		delete[] pixels;
		pixels = new_pix;
	}

	// splosh it into the wad
	if (is_flat)
	{
		qLump_c *lump = DM_CreateFlat(new_W, new_H,
				pixels, logo->width, logo->height);

		DM_AddSectionLump('F', patch, lump);
	}
	else
	{
		qLump_c *lump = DM_CreatePatch(new_W, new_H, 0, 0,
				pixels, logo->width, logo->height);

		DM_AddSectionLump('P', patch, lump);
	}

	delete[] pixels;

	return 0;
}


//------------------------------------------------------------------------

int DM_fsky_create(lua_State *L)
{
	// LUA: fsky_create(width, height, bg_col)

	int W  = luaL_checkint(L, 1);
	int H  = luaL_checkint(L, 2);
	int bg = luaL_checkint(L, 3);

	sky_final_W = W;

	if (W != 256)
		return luaL_argerror(L, 1, "bad width");

	if (H < 128 || H > 256)
		return luaL_argerror(L, 2, "bad height");

	if (sky_pixels && ! (sky_W == W && sky_H == H))
		delete[] sky_pixels;

	if (! sky_pixels)
	{
		sky_W = W;
		sky_H = H;

		sky_pixels = new byte[sky_W * sky_H];
	}

	memset(sky_pixels, bg, sky_W * sky_H);

	return 0;
}


int DM_fsky_write(lua_State *L)
{
	// LUA: fsky_write(patch)

	const char *patch = luaL_checkstring(L, 1);

	SYS_ASSERT(sky_pixels);

	qLump_c *lump = DM_CreatePatch(sky_final_W, sky_H, 0, 0,
			sky_pixels, sky_W, sky_H);

	DM_AddSectionLump('P', patch, lump);

	return 0;
}


int DM_fsky_solid_box(lua_State *L)
{
	// LUA: fsky_solid_box(x, y, w, h, col)

	int x1 = luaL_checkint(L, 1);
	int y1 = luaL_checkint(L, 2);
	int x2 = x1 + luaL_checkint(L, 3);
	int y2 = y1 + luaL_checkint(L, 4);

	int col = luaL_checkint(L, 5);

	SYS_ASSERT(sky_pixels);

	// clip box to pixel rectangle
	x1 = MAX(x1, 0);
	y1 = MAX(y1, 0);

	x2 = MIN(x2, sky_W);
	y2 = MIN(y2, sky_H);

	for (int y = y1; y < y2; y++)
	{
		if (x2 > x1)
			memset(& sky_pixels[y*sky_W + x1], col, (x2-x1));
	}

	return 0;
}


int DM_fsky_add_stars(lua_State *L)
{
	// LUA: fsky_add_stars { seed=X, colmap=X, power=X, thresh=X }

	if (lua_type(L, 1) != LUA_TTABLE)
		return luaL_argerror(L, 1, "missing table: star info");

	int seed = 1;
	int map_id = 1;

	double powscale = 3.0;
	double thresh = 0.25;

	lua_getfield(L, 1, "seed");
	lua_getfield(L, 1, "colmap");
	lua_getfield(L, 1, "power");
	lua_getfield(L, 1, "thresh");

	if (! lua_isnil(L, -4)) seed     = luaL_checkint(L, -4);
	if (! lua_isnil(L, -3)) map_id   = luaL_checkint(L, -3);
	if (! lua_isnil(L, -2)) powscale = luaL_checknumber(L, -2);
	if (! lua_isnil(L, -1)) thresh   = luaL_checknumber(L, -1);

	lua_pop(L, 4);

	// validation... 
	SYS_ASSERT(sky_pixels);

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_error(L, "fsky_add_stars: colmap value out of range");

	if (powscale < 0.01)
		return luaL_error(L, "fsky_add_stars: bad power value");

	if (thresh > 0.98)
		return luaL_error(L, "fsky_add_stars: bad thresh value");

	SKY_AddStars(seed,  sky_pixels, sky_W, sky_H,
			&color_mappings[map_id-1], powscale, thresh);

	return 0;
}


int DM_fsky_add_clouds(lua_State *L)
{
	// LUA: fsky_add_clouds { seed=X, colmap=X, power=X, thresh=X,
	//                        fracdim=X, squish=X }

	if (lua_type(L, 1) != LUA_TTABLE)
		return luaL_argerror(L, 1, "missing table: cloud info");

	int seed = 1;
	int map_id = 1;

	double powscale = 1.2;
	double thresh   = 0.0;
	double fracdim  = 2.4;
	double squish   = 1.0;

	lua_getfield(L, 1, "seed");
	lua_getfield(L, 1, "colmap");

	if (! lua_isnil(L, -2)) seed     = luaL_checkint(L, -2);
	if (! lua_isnil(L, -1)) map_id   = luaL_checkint(L, -1);

	lua_pop(L, 2);

	lua_getfield(L, 1, "power");
	lua_getfield(L, 1, "thresh");
	lua_getfield(L, 1, "fracdim");
	lua_getfield(L, 1, "squish");

	if (! lua_isnil(L, -4)) powscale = luaL_checknumber(L, -4);
	if (! lua_isnil(L, -3)) thresh   = luaL_checknumber(L, -3);
	if (! lua_isnil(L, -2)) fracdim  = luaL_checknumber(L, -2);
	if (! lua_isnil(L, -1)) squish   = luaL_checknumber(L, -1);

	lua_pop(L, 4);

	// validation... 
	SYS_ASSERT(sky_pixels);

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_error(L, "fsky_add_clouds: colmap value out of range");

	if (powscale < 0.01)
		return luaL_error(L, "fsky_add_clouds: bad power value");

	if (thresh > 0.98)
		return luaL_error(L, "fsky_add_clouds: bad thresh value");

	if (fracdim > 2.99 || fracdim < 0.2)
		return luaL_error(L, "fsky_add_clouds: bad fracdim value");

	if (squish > 4.1 || squish < 0.24)
		return luaL_error(L, "fsky_add_clouds: bad squish value");

	SKY_AddClouds(seed,  sky_pixels, sky_W, sky_H,
			&color_mappings[map_id-1], powscale, thresh,
			fracdim, squish);

	return 0;
}


int DM_fsky_add_hills(lua_State *L)
{
	// LUA: fsky_add_hills { seed=X, colmap=X, power=X, fracdim=X,
	//                       min_h=X, max_h=X }

	if (lua_type(L, 1) != LUA_TTABLE)
		return luaL_argerror(L, 1, "missing table: cloud info");

	int seed = 1;
	int map_id = 1;

	double min_h = -0.20;
	double max_h =  0.75;

	double powscale = 0.8;
	double fracdim  = 1.8;

	lua_getfield(L, 1, "seed");
	lua_getfield(L, 1, "colmap");

	if (! lua_isnil(L, -2)) seed     = luaL_checkint(L, -2);
	if (! lua_isnil(L, -1)) map_id   = luaL_checkint(L, -1);

	lua_pop(L, 2);

	lua_getfield(L, 1, "min_h");
	lua_getfield(L, 1, "max_h");
	lua_getfield(L, 1, "power");
	lua_getfield(L, 1, "fracdim");

	if (! lua_isnil(L, -4)) min_h    = luaL_checknumber(L, -4);
	if (! lua_isnil(L, -3)) max_h    = luaL_checknumber(L, -3);
	if (! lua_isnil(L, -2)) powscale = luaL_checknumber(L, -2);
	if (! lua_isnil(L, -1)) fracdim  = luaL_checknumber(L, -1);

	lua_pop(L, 4);

	// validation... 
	SYS_ASSERT(sky_pixels);

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_error(L, "fsky_add_hills: colmap value out of range");

	if (min_h >= max_h || max_h <= 0.0)
		return luaL_error(L, "fsky_add_hills: bad height range");

	if (powscale < 0.01)
		return luaL_error(L, "fsky_add_hills: bad power value");

	if (fracdim > 2.99 || fracdim < 0.2)
		return luaL_error(L, "fsky_add_hills: bad fracdim value");

	SKY_AddHills(seed,  sky_pixels, sky_W, sky_H,
			&color_mappings[map_id-1], min_h, max_h,
			powscale, fracdim);

	return 0;
}


//------------------------------------------------------------------------

static int FontIndexForChar(char ch)
{
	ch = toupper(ch);

	if (ch == ' ')
		return 0;

	if ('A' <= ch && ch <= 'Z')
		return 12 + (ch - 'A');

	if ('0' <= ch && ch <= '9')
		return 1 + (ch - '0');

	switch (ch)
	{
		case ':':
		case ';':
		case '=': return 11;

		case '-':
		case '_': return 38;

		case '.':
		case ',': return 39;

		case '!': return 40;
		case '?': return 41;

		case '\'':
		case '`':
		case '"': return 42;

		case '&': return 43;

		case '\\':
		case '/': return 44;

				  // does not exist
		default: return -1;
	}
}


static void BlastFontChar(int index, int x, int y,
                          byte *pixels, int W, int H,
                          const logo_image_t *font, int fw, int fh,
                          const color_mapping_t *map, int thresh)
{
	SYS_ASSERT(0 <= index && index < 44);

	int fx = fw * (index % 11);
	int fy = fh * (index / 11);

	SYS_ASSERT(0 <= fx && fx+fw <= font->width);
	SYS_ASSERT(0 <= fy && fy+fh <= font->height);

	SYS_ASSERT(0 <= x && x+fw <= W);
	SYS_ASSERT(0 <= y && y+fh <= H);


	for (int dy = 0; dy < fh; dy++)
		for (int dx = 0; dx < fw; dx++)
		{
			byte pix = font->data[(fy+dy)*font->width + (fx+dx)];

			if (pix < thresh)
				continue;

			// map pixel
			pix = map->colors[map->size * (pix-thresh) / (256-thresh)];

			pixels[(y+dy)*W + (x+dx)] = pix;
		}
}


static void CreateNamePatch(const char *patch, const char *text,
                            const logo_image_t *font,
                            const color_mapping_t *map)
{
	// TODO: adjustable threshhold
	int thresh = 16;

	int font_w = font->width / 11;
	int font_h = font->height / 4;

	int buffer[64];
	int length = 0;

	// Convert string to font indexes (0 = space, 1+ = index)

	for (; *text && length < 60; text++)
	{
		int idx = FontIndexForChar(*text);

		if (idx >= 0)
			buffer[length++] = idx;
	}

	if (length == 0)
	{
		buffer[length++] = 41;
		buffer[length++] = 41;
	}


	int W = font_w * length;
	int H = font_h;

	byte *pixels = new byte[W * H];

	memset(pixels, 255, W * H);

	for (int p = 0; p < length; p++)
	{
		if (buffer[p] <= 0)
			continue;

		BlastFontChar(buffer[p] - 1, p * font_w, 0,
				pixels, W, H,
				font, font_w, font_h,
				map, thresh);
	}

	qLump_c *lump = DM_CreatePatch(W, H, 0, 0, pixels, W, H, 255);

	DM_WriteLump(patch, lump);

	delete lump;
	delete[] pixels;
}


int DM_wad_name_gfx(lua_State *L)
{
	// LUA: wad_name_gfx(patch, text, colmap)

	const char *patch = luaL_checkstring(L, 1);
	const char *text  = luaL_checkstring(L, 2);

	int map_id = luaL_checkint(L, 3);

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_argerror(L, 1, "colmap value out of range");

	CreateNamePatch(patch, text, &font_CWILV, &color_mappings[map_id-1]);

	return 0;
}


int DM_wad_add_text_lump(lua_State *L)
{
	// LUA: wad_add_text_lump(lump, strings)
	//
	// The 'strings' parameter is a table.

	const char *name = luaL_checkstring(L, 1);

	if (lua_type(L, 2) != LUA_TTABLE)
	{
		return luaL_argerror(L, 2, "expected a table: strings");
	}

	qLump_c *lump = new qLump_c();

	// grab all the strings from the table
	for (int i = 0; true; i++)
	{
		lua_pushinteger(L, 1+i);
		lua_gettable(L, 2);

		if (lua_isnil(L, -1))
		{
			lua_pop(L, 1);
			break;
		}

		if (lua_type(L, -1) != LUA_TSTRING)
			return luaL_error(L, "wad_add_text_lump: item #%d is not a string", 1+i);

		// use this method since it allows embedded zeros in the string
		// (just in case some crazy person wants to write a binary lump).
		size_t len;
		const char *str = lua_tolstring(L, -1, &len);

		lump->Append(str, (int)len);

		lua_pop(L, 1);
	}

	DM_WriteLump(name, lump);
	delete lump;

	return 0;
}


int DM_wad_add_binary_lump(lua_State *L)
{
	// LUA: wad_add_binary_lump(lump, bytes)
	//
	// The 'bytes' parameter is a table, which can contain numbers, strings,
	// and booleans.  Each number ends up as a single byte.

	const char *name = luaL_checkstring(L, 1);

	if (lua_type(L, 2) != LUA_TTABLE)
	{
		return luaL_argerror(L, 2, "expected a table: bytes");
	}

	qLump_c *lump = new qLump_c();

	// grab all the stuff from the table
	for (int i = 0; true; i++)
	{
		lua_pushinteger(L, 1+i);
		lua_gettable(L, 2);

		if (lua_isnil(L, -1))
		{
			lua_pop(L, 1);
			break;
		}

		int val_type = lua_type(L, -1);

		byte value;

		switch (val_type)
		{
			case LUA_TNUMBER:
				value = lua_tointeger(L, -1) & 0xFF;
				lump->Append(&value, 1);
				break;

			case LUA_TBOOLEAN:
				value = lua_toboolean(L, -1);
				lump->Append(&value, 1);
				break;

			case LUA_TSTRING:
				{
					size_t len;
					const char *str = lua_tolstring(L, -1, &len);

					lump->Append(str, (int)len);
				}
				break;

			default:
				return luaL_error(L, "wad_add_binary_lump: item #%d is illegal", 1+i);
		}

		lua_pop(L, 1);
	}

	DM_WriteLump(name, lump);
	delete lump;

	return 0;
}


static void TransferFILEtoWAD(FILE *fp, const char *dest_lump)
{
	WAD_NewLump(dest_lump);

	int buf_size = 4096;
	char *buffer = new char[buf_size];

	for (;;)
	{
		int got_len = fread(buffer, 1, buf_size, fp);

		if (got_len <= 0)
			break;

		WAD_AppendData(buffer, got_len);
	}

	delete[] buffer;

	WAD_FinishLump();
}


static void TransferWADtoWAD(int src_entry, const char *dest_lump)
{
	int length = WAD_EntryLen(src_entry);

	WAD_NewLump(dest_lump);

	int buf_size = 4096;
	char *buffer = new char[buf_size];

	for (int pos = 0; pos < length; )
	{
		int want_len = MIN(buf_size, length - pos);

		// FIXME: handle error better
		if (! WAD_ReadData(src_entry, pos, want_len, buffer))
			break;

		WAD_AppendData(buffer, want_len);

		pos += want_len;
	}

	delete[] buffer;

	WAD_FinishLump();
}


static qLump_c * DoLoadLump(int src_entry)
{
	qLump_c *lump = new qLump_c();

	int length = WAD_EntryLen(src_entry);

	int buf_size = 4096;
	char *buffer = new char[buf_size];

	for (int pos = 0; pos < length; )
	{
		int want_len = MIN(buf_size, length - pos);

		// FIXME: handle error better
		if (! WAD_ReadData(src_entry, pos, want_len, buffer))
			break;

		lump->Append(buffer, want_len);

		pos += want_len;
	}

	delete[] buffer;

	return lump;
}


#define NUM_LEVEL_LUMPS  12

static const char *level_lumps[NUM_LEVEL_LUMPS]=
{
	"THINGS", "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS", 
	"SSECTORS", "NODES", "SECTORS", "REJECT", "BLOCKMAP",
	"BEHAVIOR",  // <-- hexen support
	"SCRIPTS"  // -JL- Lump with script sources
};


static bool IsLevelLump(const char *name)
{
	for (int i=0; i < NUM_LEVEL_LUMPS; i++)
		if (strcmp(name, level_lumps[i]) == 0)
			return true;

	return false;
}


int DM_wad_insert_file(lua_State *L)
{
	// LUA: wad_insert_file(filename, lumpname)

	const char *base_name = luaL_checkstring(L, 1);
	const char *dest_lump = luaL_checkstring(L, 2);

	const char *full_name = FileFindInPath(data_path, base_name);
	if (! full_name)
		return luaL_error(L, "wad_insert_file: missing data file: %s", base_name);

	FILE *fp = fopen(full_name, "rb");

	if (! fp) // this is unlikely (we know it exists)
		return luaL_error(L, "wad_insert_file: cannot open file: %s", full_name);

	TransferFILEtoWAD(fp, dest_lump);

	fclose(fp);

	StringFree(full_name);

	return 0;
}


int DM_wad_transfer_lump(lua_State *L)
{
	// LUA: wad_transfer_lump(wad_file, src_lump, dest_lump)
	//
	// Open an existing wad file and copy the lump into our wad.

	const char *pkg_name  = luaL_checkstring(L, 1);
	const char *src_lump  = luaL_checkstring(L, 2);
	const char *dest_lump = luaL_checkstring(L, 3);

	// TODO: support PK3

	if (! MatchExtension(pkg_name, "wad"))
		return luaL_error(L, "wad_transfer_lump: file extension is not WAD: %s\n", pkg_name);

	const char *full_name = FileFindInPath(data_path, pkg_name);
	if (! full_name)
		return luaL_error(L, "wad_transfer_lump: missing WAD file: %s", pkg_name);

	if (! WAD_OpenRead(full_name))
		return luaL_error(L, "wad_transfer_lump: bad WAD file: %s", full_name);

	int entry = WAD_FindEntry(src_lump);
	if (entry < 0)
	{
		WAD_CloseRead();
		return luaL_error(L, "wad_transfer_lump: lump '%s' not found", src_lump);
	}

	TransferWADtoWAD(entry, dest_lump);

	WAD_CloseRead();

	StringFree(full_name);

	return 0;
}


int DM_wad_transfer_map(lua_State *L)
{
	// LUA: wad_transfer_map(wad_file, src_map, dest_map)
	//
	// Open an existing wad file and copy the map into our wad.

	const char *pkg_name = luaL_checkstring(L, 1);
	const char *src_map  = luaL_checkstring(L, 2);
	const char *dest_map = luaL_checkstring(L, 3);

	if (! MatchExtension(pkg_name, "wad"))
		return luaL_error(L, "wad_transfer_map: file extension is not WAD: %s\n", pkg_name);

	const char *full_name = FileFindInPath(data_path, pkg_name);
	if (! full_name)
		return luaL_error(L, "wad_transfer_map: missing WAD file: %s", pkg_name);

	if (! WAD_OpenRead(full_name))
		return luaL_error(L, "wad_transfer_map: bad WAD file: %s", full_name);

	int entry = WAD_FindEntry(src_map);
	if (entry < 0)
	{
		WAD_CloseRead();
		return luaL_error(L, "wad_transfer_map: map '%s' not found", src_map);
	}

	// step 1: copy the map marker
	TransferWADtoWAD(entry, dest_map);
	entry++;

	// step 2: copy all the lumps belonging to the map.
	for (int loop = 0; loop < 15; loop++)
	{
		if (entry >= WAD_NumEntries())
			break;

		const char *src_lump = WAD_EntryName(entry);
		if (! IsLevelLump(src_lump))
			break;

		TransferWADtoWAD(entry, src_lump);
		entry++;
	}

	WAD_CloseRead();

	StringFree(full_name);

	return 0;
}


static void DoMergeSection(char ch, const char *start1, const char *start2,
		const char *end1, const char *end2)
{
	int start = WAD_FindEntry(start1);
	if (start < 0 && start2)
	{
		start1 = start2;
		start = WAD_FindEntry(start1);
	}

	if (start < 0)
		return;

	int end = WAD_FindEntry(end1);
	if (end < 0 && end2)
	{
		end1 = end2;
		end = WAD_FindEntry(end1);
	}

	if (end < 0)
	{
		LogPrintf("WARNING: %s found but %s is missing.\n", start1, end1);
		return;
	}
	else if (end < start)
	{
		LogPrintf("WARNING: %s marker found before %s!\n", end1, start1);
		return;
	}

	for (int i = start+1; i < end; i++)
	{
		// skip other markers (e.g. F1_START)
		if (WAD_EntryLen(i) == 0)
			continue;

		DM_AddSectionLump(ch, WAD_EntryName(i), DoLoadLump(i));
	}
}


int DM_wad_merge_sections(lua_State *L)
{
	// LUA: wad_merge_sections(file_name)
	//
	// Open an existing wad file and merge the patches, sprites, flats
	// and other stuff (which occur in between P_START/P_END and similar
	// marker lumps).

	const char *pkg_name = luaL_checkstring(L, 1);

	LogPrintf("Merging WAD sections from: %s\n", pkg_name);

	if (! MatchExtension(pkg_name, "wad"))
		return luaL_error(L, "wad_merge_sections: file extension is not WAD: %s\n", pkg_name);

	const char *full_name = FileFindInPath(data_path, pkg_name);
	if (! full_name)
		return luaL_error(L, "wad_merge_sections: missing WAD file: %s\n", pkg_name);

	if (! WAD_OpenRead(full_name))
		return luaL_error(L, "wad_merge_sections: bad WAD file: %s", full_name);

	DoMergeSection('P', "P_START", "PP_START", "P_END", "PP_END");
	DoMergeSection('S', "S_START", "SS_START", "S_END", "SS_END");
	DoMergeSection('F', "F_START", "FF_START", "F_END", "FF_END");
	DoMergeSection('C', "C_START",  NULL,      "C_END",  NULL);
	DoMergeSection('T', "TX_START", NULL,      "TX_END", NULL);

	WAD_CloseRead();

	StringFree(full_name);

	return 0;
}


#define DIRTY_CHAR(ch)  ((ch) == 0)

void G_PushCleanString(lua_State *L, const char *buf, int len)
{
	bool dirty = false;

	for (int i = 0; i < len; i++)
		if (DIRTY_CHAR(buf[i]))
		{
			dirty = true; break;
		}

	if (! dirty)
	{
		lua_pushlstring(L, buf, len);
		return;
	}

	// this is quite sub-optimal, since we assume dirty strings are rare
	// (i.e. the usual case is plain text files).

	const char *src = buf;
	const char *s_end = src + len;

	char *new_str = StringNew(len);
	char *dest = new_str;

	for (; src < s_end; src++)
		if (! DIRTY_CHAR(*src))
			*dest++ = *src;

	*dest = 0;

	lua_pushstring(L, new_str);

	StringFree(new_str);
}


int DM_wad_read_text_lump(lua_State *L)
{
	// LUA: wad_read_text_lump(file_name, lump_name) --> table
	//
	// Open the wad file and find the given lump.  If it exists, it is assumed
	// to be text, and a table is returned containing a string for each line.
	// Certain characters (esp. zero bytes) will be silently removed.
	//
	// If the lump does not exist, nil is returned.
	// If the _file_ does not exist, An error is raised.

	const char *pkg_name = luaL_checkstring(L, 1);
	const char *src_lump = luaL_checkstring(L, 2);

	if (! MatchExtension(pkg_name, "wad"))
		return luaL_error(L, "wad_read_text_lump: file extension is not WAD: %s\n", pkg_name);

	const char *full_name = FileFindInPath(data_path, pkg_name);
	if (! full_name)
		return luaL_error(L, "wad_read_text_lump: missing WAD file: %s", pkg_name);

	if (! WAD_OpenRead(full_name))
		return luaL_error(L, "wad_read_text_lump: bad WAD file: %s", full_name);

	int entry = WAD_FindEntry(src_lump);
	if (entry < 0)
	{
		WAD_CloseRead();

		lua_pushnil(L);
		return 1;
	}

	qLump_c *lump = DoLoadLump(entry);

	WAD_CloseRead();

	StringFree(full_name);

	// create the table
	lua_newtable(L);

	const byte *buf = lump->GetBuffer();
	const byte *b_end = buf + lump->GetSize();

	int cur_pos = 1;

	while (buf < b_end)
	{
		const byte *next = buf;
		while (next < b_end && *next != '\n')
			next++;

		if (next < b_end)
			next++;

		size_t len = (next - buf);

		lua_pushinteger(L, cur_pos);
		G_PushCleanString(L, (const char *)buf, len);

		lua_rawset(L, -3);

		buf = next; cur_pos++;
	}

	return 1;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
