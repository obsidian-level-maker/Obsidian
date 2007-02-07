//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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
#include "hdr_lua.h"

#include "g_doom.h"

#include "hdr_fltk.h"
#include "ui_dialog.h"
#include "ui_window.h"
#include "main.h"


typedef std::vector<u8_t> lump_c;

typedef std::vector<raw_dir_entry_t> directory_c;


static FILE *wad_fp;

static directory_c wad_dir;
static bool wad_hexen;

static char *level_name;

static lump_c *thing_lump;
static lump_c *vertex_lump;
static lump_c *sector_lump;
static lump_c *sidedef_lump;
static lump_c *linedef_lump;



//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

static u32_t AlignLen(u32_t len)
{
	return ((len + 3) & ~3);
}

void WAD_RawSeek(u32_t pos)
{
	fflush(wad_fp);

	// FIXME: check result
	fseek(wad_fp, pos, SEEK_SET);
}

void WAD_RawWrite(const void *data, u32_t len)
{
	SYS_ASSERT(wad_fp);

	if (1 != fwrite(data, len, 1, wad_fp))
	{
		// FIXME: log
		fprintf(stderr, "Failure writing to wad file!\n");
	}
}

void WAD_WriteLump(const char *name, const void *data, u32_t len)
{
	SYS_ASSERT(strlen(name) <= 8);

  // create entry for directory (written out later)
	raw_dir_entry_t entry;

	entry.start  = LE_U32((u32_t)ftell(wad_fp));
	entry.length = LE_U32(len);

	strncpy(entry.name, name, 8);

	wad_dir.push_back(entry);

	if (len > 0)
	{
		WAD_RawWrite(data, len);

		// pad lumps to a multiple of four bytes
		u32_t padding = AlignLen(len) - len;

		SYS_ASSERT(0 <= padding && padding <= 3);

		if (padding > 0)
		{
			static u8_t zeros[4] = { 0,0,0,0 };

			WAD_RawWrite(zeros, padding);
		}
	}
}

void WAD_WriteLump(const char *name, lump_c *lump)
{
	WAD_WriteLump(name, &(*lump)[0], lump->size());
}

void WAD_WriteBehavior()
{
	raw_behavior_header_t behavior;

	strncpy(behavior.marker, "ACS", 4);

	behavior.offset   = LE_U32(8);
	behavior.func_num = 0;
	behavior.str_num  = 0;

	WAD_WriteLump("BEHAVIOR", &behavior, sizeof(behavior));
}

void WAD_Append(lump_c *lump, const void *data, u32_t len)
{
	if (len > 0)
	{
		u32_t old_size = lump->size();
		u32_t new_size = old_size + len;

		lump->resize(new_size);

		memcpy(& (*lump)[old_size], data, len);
	}
}

void WAD_Printf(lump_c *lump, const char *str, ...)
{
  static char buffer[MSG_BUF_LEN + 4];

	va_list args;

	va_start(args, str);
	vsnprintf(buffer, MSG_BUF_LEN, str, args);
	va_end(args);

	buffer[MSG_BUF_LEN] = 0;

  WAD_Append(lump, buffer, strlen(buffer));
}

void WAD_CreateInfoLump()
{
  lump_c *L = new lump_c();

  WAD_Printf(L, "# Levels created by OBLIGE %s\n", OBLIGE_VERSION);
  WAD_Printf(L, "# " OBLIGE_TITLE " (C) 2006,2007 Andrew Apted\n");
  WAD_Printf(L, "# http://oblige.sourceforge.net/\n");
  WAD_Printf(L, "\n");

  WAD_Printf(L, "# Settings:\n");
	WAD_Printf(L, "seed = %s\n",  main_win->setup_box->cur_Seed());
	WAD_Printf(L, "game = %s\n",  main_win->setup_box->cur_Game());
	WAD_Printf(L, "addon = %s\n", main_win->setup_box->cur_Addon());
	WAD_Printf(L, "mode = %s\n",  main_win->setup_box->cur_Mode());
	WAD_Printf(L, "length = %s\n",main_win->setup_box->cur_Length());
  WAD_Printf(L, "\n");

  WAD_Printf(L, "# Adjustments:\n");
  WAD_Printf(L, "health = %s\n", main_win->adjust_box->cur_Health());
  WAD_Printf(L, "ammo = %s\n",   main_win->adjust_box->cur_Ammo());
  WAD_Printf(L, "mons = %s\n",   main_win->adjust_box->cur_Monsters());
  WAD_Printf(L, "traps = %s\n",  main_win->adjust_box->cur_Traps());

  WAD_WriteLump("OBLIGDAT", L);
}

int Hexen_GrabArgs(lua_State *L, u8_t *args, int stack_pos)
{
  memset(args, 0, 5);

  int what = lua_type(L, stack_pos);

  if (what == LUA_TNONE || what == LUA_TNIL)
    return 0;

  if (what != LUA_TTABLE)
    return luaL_argerror(L, stack_pos, "expected a table");

  for (int i = 0; i < 5; i++)
  {
    lua_pushinteger(L, i+1);
    lua_gettable(L, stack_pos);

    if (lua_isnumber(L, -1))
    {
      args[i] = lua_tointeger(L, -1);
    }

    lua_pop(L, 1);
  }

  return 0;
}


//------------------------------------------------------------------------

namespace wad
{

// LUA: begin_level(name)
//
int begin_level(lua_State *L)
{
	const char *name = luaL_checkstring(L,1);

	level_name = strdup(name);

	thing_lump   = new lump_c();
	vertex_lump  = new lump_c();
	sector_lump  = new lump_c();
	linedef_lump = new lump_c();
	sidedef_lump = new lump_c();

	return 0;
}

// LUA: end_level()
//
int end_level(lua_State *L)
{
	SYS_ASSERT(level_name);

	WAD_WriteLump(level_name, NULL, 0);

	WAD_WriteLump("THINGS",   thing_lump);
	WAD_WriteLump("LINEDEFS", linedef_lump);
	WAD_WriteLump("SIDEDEFS", sidedef_lump);
	WAD_WriteLump("VERTEXES", vertex_lump);

	WAD_WriteLump("SEGS",     NULL, 0);
	WAD_WriteLump("SSECTORS", NULL, 0);
	WAD_WriteLump("NODES",    NULL, 0);
	WAD_WriteLump("SECTORS",  sector_lump);

	if (wad_hexen)
		WAD_WriteBehavior();

	// free data
	delete thing_lump;   thing_lump   = NULL;
	delete sector_lump;  sector_lump  = NULL;
	delete vertex_lump;  vertex_lump  = NULL;
	delete sidedef_lump; sidedef_lump = NULL;
	delete linedef_lump; linedef_lump = NULL;

	delete level_name; level_name = NULL;

	return 0;
}


// LUA: add_thing(x, y, h, type, angle, flags, tid, special, args)
//
int add_thing(lua_State *L)
{
	if (! wad_hexen)
	{
		raw_thing_t thing;

		thing.x = LE_S16(luaL_checkint(L,1));
		thing.y = LE_S16(luaL_checkint(L,2));

		thing.type    = LE_U16(luaL_checkint(L,4));
		thing.angle   = LE_S16(luaL_checkint(L,5));
		thing.options = LE_U16(luaL_checkint(L,6));

		WAD_Append(thing_lump, &thing, sizeof(thing));
	}
	else  // Hexen format
	{
		raw_hexen_thing_t thing;

		// clear unused fields (tid, specials)
		memset(&thing, 0, sizeof(thing));

		thing.x = LE_S16(luaL_checkint(L,1));
		thing.y = LE_S16(luaL_checkint(L,2));

		thing.height  = LE_S16(luaL_checkint(L,3));
		thing.type    = LE_U16(luaL_checkint(L,4));
		thing.angle   = LE_S16(luaL_checkint(L,5));
		thing.options = LE_U16(luaL_checkint(L,6));

		thing.tid     = LE_S16(luaL_checkint(L,7));
		thing.special = luaL_checkint(L,8);  // 8 bits

    Hexen_GrabArgs(L, thing.args, 9);

		WAD_Append(thing_lump, &thing, sizeof(thing));
	}

	return 0;
}

// LUA: add_vertex(x, y)
//
int add_vertex(lua_State *L)
{
	raw_vertex_t vert;

	vert.x = LE_S16(luaL_checkint(L,1));
	vert.y = LE_S16(luaL_checkint(L,2));

	WAD_Append(vertex_lump, &vert, sizeof(vert));

	return 0;
}

// LUA: add_sector(f_h, c_h, f_tex, c_tex, light, type, tag)
//   
int add_sector(lua_State *L)
{
	raw_sector_t sec;

	sec.floor_h = LE_S16(luaL_checkint(L,1));
	sec.ceil_h  = LE_S16(luaL_checkint(L,2));

	memcpy(sec.floor_tex, luaL_checkstring(L,3), 8);
	memcpy(sec.ceil_tex,  luaL_checkstring(L,4), 8);

	sec.light   = LE_U16(luaL_checkint(L,5));
	sec.special = LE_U16(luaL_checkint(L,6));
	sec.tag     = LE_S16(luaL_checkint(L,7));

	WAD_Append(sector_lump, &sec, sizeof(sec));

	return 0;
}

// LUA: add_sidedef(sec, lower, mid, upper, x, y)
//   
int add_sidedef(lua_State *L)
{
	raw_sidedef_t side;

	side.sector = LE_S16(luaL_checkint(L,1));

	memcpy(side.lower_tex, luaL_checkstring(L,2), 8);
	memcpy(side.mid_tex,   luaL_checkstring(L,3), 8);
	memcpy(side.upper_tex, luaL_checkstring(L,4), 8);

	side.x_offset = LE_S16(luaL_checkint(L,5));
	side.y_offset = LE_S16(luaL_checkint(L,6));

	WAD_Append(sidedef_lump, &side, sizeof(side));

	return 0;
}

// LUA: add_linedef(vert1, vert2, side1, side2, type, flags, tag, args)
//
int add_linedef(lua_State *L)
{
	if (! wad_hexen)
	{
		raw_linedef_t line;

		line.start = LE_U16(luaL_checkint(L,1));
		line.end   = LE_U16(luaL_checkint(L,2));

		int side1 = luaL_checkint(L,3);
		int side2 = luaL_checkint(L,4);
		
		line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
		line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

		line.type  = LE_U16(luaL_checkint(L,5));
		line.flags = LE_U16(luaL_checkint(L,6));
		line.tag   = LE_S16(luaL_checkint(L,7));

		WAD_Append(linedef_lump, &line, sizeof(line));
	}
	else  // Hexen format
	{
		raw_hexen_linedef_t line;

		// clear unused fields (specials)
		memset(&line, 0, sizeof(line));

		line.start = LE_U16(luaL_checkint(L,1));
		line.end   = LE_U16(luaL_checkint(L,2));

		int side1 = luaL_checkint(L,3);
		int side2 = luaL_checkint(L,4);
			
		line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
		line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

		line.special = luaL_checkint(L,5); // 8 bits
		line.flags = LE_U16(luaL_checkint(L,6));

		// tag value is UNUSED

    Hexen_GrabArgs(L, line.args, 8);

		WAD_Append(linedef_lump, &line, sizeof(line));
	}

	return 0;
}

} // namespace wad


//------------------------------------------------------------------------

static const luaL_Reg wad_funcs[] =
{
	{ "begin_level", wad::begin_level },
	{ "end_level",   wad::end_level   },

	{ "add_thing",   wad::add_thing   },
	{ "add_vertex",  wad::add_vertex  },
	{ "add_sector",  wad::add_sector  },
	{ "add_sidedef", wad::add_sidedef },
	{ "add_linedef", wad::add_linedef },

	{ NULL, NULL } // the end
};


void Doom_InitLua(lua_State *L)
{
	luaL_register(L, "wad", wad_funcs);
}

bool Doom_CreateWAD(const char *filename, bool is_hexen)
{
	wad_fp = fopen(filename, "wb");

	if (! wad_fp)
	{
		DLG_ShowError("Unable to create wad file:\n%s", strerror(errno));
		return false;
	}

	wad_dir.clear();
	wad_hexen = is_hexen;

	// dummy header
	raw_wad_header_t header;

	strncpy(header.type, "XWAD", 4);

	header.dir_start   = 0;
	header.num_entries = 0;

	WAD_RawWrite(&header, sizeof(header));

	WAD_CreateInfoLump();

	return true; //OK
}

bool Doom_FinishWAD()
{
	// compute *real* header 
	raw_wad_header_t header;

	strncpy(header.type, "PWAD", 4);

	header.dir_start   = LE_U32((u32_t)ftell(wad_fp));
	header.num_entries = LE_U32(wad_dir.size());


	// WRITE DIRECTORY
	directory_c::iterator D;

	for (D = wad_dir.begin(); D != wad_dir.end(); D++)
	{
		WAD_RawWrite(& *D, sizeof(raw_dir_entry_t));
	}

	// FSEEK, WRITE HEADER

	WAD_RawSeek(0);
	WAD_RawWrite(&header, sizeof(header));

	fclose(wad_fp);
  wad_fp = NULL;

	// FIXME: free memory

	return true; //OK
}

