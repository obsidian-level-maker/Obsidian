//----------------------------------------------------------------------
//  LUA interface
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2014 Andrew Apted
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
//----------------------------------------------------------------------

#include "headers.h"

#include <algorithm>

#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_signal.h"
#include "lib_util.h"

#include "main.h"
#include "m_lua.h"

#include "twister.h"


static lua_State *LUA_ST;

const char *data_path;

static bool has_loaded = false;
static bool has_added_buttons = false;

static std::vector<std::string> * conf_line_buffer;

extern bool debug_onto_console;


// random number generator (Mersenne Twister)
static MT_rand_c GUI_RNG(0);

// color maps
color_mapping_t color_mappings[MAX_COLOR_MAPS];


// LUA: raw_log_print(str)
//
int gui_raw_log_print(lua_State *L)
{
	int nargs = lua_gettop(L);

	if (nargs >= 1)
	{
		const char *res = luaL_checkstring(L,1);
		SYS_ASSERT(res);

		ConPrintf("%s", res);

		// strip off colorizations
		if (res[0] == '@' && isdigit(res[1]))
			res += 2;

		LogPrintf("%s", res);
	}

	return 0;
}

// LUA: raw_debug_print(str)
//
int gui_raw_debug_print(lua_State *L)
{
	int nargs = lua_gettop(L);

	if (nargs >= 1)
	{
		const char *res = luaL_checkstring(L,1);
		SYS_ASSERT(res);

		if (debug_onto_console)
			ConPrintf("%s", res);

		DebugPrintf("%s", res);
	}

	return 0;
}

// LUA: raw_console_print(str)
//
int gui_raw_console_print(lua_State *L)
{
	int nargs = lua_gettop(L);

	if (nargs >= 1)
	{
		const char *res = luaL_checkstring(L,1);
		SYS_ASSERT(res);

		ConPrintf("%s", res);
	}

	return 0;
}


// LUA: config_line(str)
//
int gui_config_line(lua_State *L)
{
	const char *res = luaL_checkstring(L,1);

	SYS_ASSERT(conf_line_buffer);

	conf_line_buffer->push_back(res);

	return 0;
}


// LUA: mkdir(dir_name)
//
int gui_mkdir(lua_State *L)
{
	const char *name = luaL_checkstring(L,1);

	bool result = FileMakeDir(name);

	lua_pushboolean(L, result ? 1 : 0);
	return 1;
}


// LUA: set_colormap(map, colors)
//
int gui_set_colormap(lua_State *L)
{
	int map_id = luaL_checkint(L, 1);

	if (map_id < 1 || map_id > MAX_COLOR_MAPS)
		return luaL_argerror(L, 1, "colmap value out of range");

	if (lua_type(L, 2) != LUA_TTABLE)
	{
		return luaL_argerror(L, 2, "expected a table: colors");
	}

	color_mapping_t *map = & color_mappings[map_id-1];

	map->size = 0;

	for (int i = 0; i < MAX_COLORS_PER_MAP; i++)
	{
		lua_pushinteger(L, 1+i);
		lua_gettable(L, 2);

		if (lua_isnil(L, -1))
		{
			lua_pop(L, 1);
			break;
		}

		map->colors[i] = luaL_checkint(L, -1);
		map->size = i+1;

		lua_pop(L, 1);
	}

	return 0;
}


// LUA: locate_data(filename) --> string
//
int gui_locate_data(lua_State *L)
{
	const char *base_name = luaL_checkstring(L, 1);

	const char *full_name = FileFindInPath(data_path, base_name);

	if (! full_name)
	{
		lua_pushnil(L);
		return 1;
	}

	lua_pushstring(L, full_name);
	return 1;
}


// LUA: add_button (what, id, label)
//
int gui_add_button(lua_State *L)
{
	const char *what  = luaL_checkstring(L,1);
	const char *id    = luaL_checkstring(L,2);
	const char *label = luaL_checkstring(L,3);

	SYS_ASSERT(what && id && label);

	if (! main_win)
		return 0;

	// only allowed during startup
	if (has_added_buttons)
		Main_FatalError("Script problem: gui.add_button called late.\n");

	// DebugPrintf("  add_button: %s id:%s\n", what, id);

	if (StringCaseCmp(what, "game") == 0)
		main_win->game_box->game->AddPair(id, label);

	else if (StringCaseCmp(what, "engine") == 0)
		main_win->game_box->engine->AddPair(id, label);

	else if (StringCaseCmp(what, "theme") == 0)
		main_win->level_box->theme->AddPair(id, label);

	else if (StringCaseCmp(what, "module") == 0)
		main_win->mod_box->AddModule(id, label);

	else
		Main_FatalError("add_button: unknown what value '%s'\n", what);

	return 0;
}

// LUA: add_mod_option (module, option, [id,] label)
//
// When the 'id' string is omitted, it indicates mere creation of
// a new button widget for the module.  OTHERWISE we are adding a
// choice to the existing button (a la add_button).
//
int gui_add_mod_option(lua_State *L)
{
	int nargs = lua_gettop(L);

	const char *module = luaL_checkstring(L,1);
	const char *option = luaL_checkstring(L,2);

	const char *id    = NULL;
	const char *label = NULL;

	if (nargs >= 4)
	{
		id    = luaL_checkstring(L,3);
		label = luaL_checkstring(L,4);
	}
	else
		label = luaL_checkstring(L,3);

	SYS_ASSERT(module && option);

	if (! main_win)
		return 0;

	// only allowed during startup
	if (has_added_buttons)
		Main_FatalError("Script problem: gui.add_mod_option called late.\n");

	if (! id)
		main_win->mod_box->AddOption(module, option, label);
	else
		main_win->mod_box->OptionPair(module, option, id, label);

	return 0;
}


// LUA: show_button(what, id, shown)
//
int gui_show_button(lua_State *L)
{
	const char *what = luaL_checkstring(L,1);
	const char *id   = luaL_checkstring(L,2);

	int shown = lua_toboolean(L,3) ? 1 : 0;

	SYS_ASSERT(what && id);

	if (! main_win)
		return 0;

	// DebugPrintf("  show_button: %s id:%s %s\n", what, id, shown ? "show" : "HIDE");

	if (StringCaseCmp(what, "game") == 0)
		main_win->game_box->game->ShowOrHide(id, shown);

	else if (StringCaseCmp(what, "engine") == 0)
		main_win->game_box->engine->ShowOrHide(id, shown);

	else if (StringCaseCmp(what, "theme") == 0)
		main_win->level_box->theme->ShowOrHide(id, shown);

	else if (StringCaseCmp(what, "module") == 0)
		main_win->mod_box->ShowOrHide(id, shown);

	else
		Main_FatalError("show_button: unknown what value '%s'\n", what);

	return 0;
}


// LUA: change_button(what, id [, bool])
//
int gui_change_button(lua_State *L)
{
	const char *what = luaL_checkstring(L,1);
	const char *id   = luaL_checkstring(L,2);

	int opt_val = lua_toboolean(L,3) ? 1 : 0;

	SYS_ASSERT(what && id);

	if (! main_win)
		return 0;

	// DebugPrintf("  change_button: %s --> %s\n", what, id);

	if (StringCaseCmp(what, "game") == 0)
		main_win->game_box->game->SetID(id);

	else if (StringCaseCmp(what, "engine") == 0)
		main_win->game_box->engine->SetID(id);

	else if (StringCaseCmp(what, "theme") == 0)
		main_win->level_box->theme->SetID(id);

	else if (StringCaseCmp(what, "module") == 0)
		main_win->mod_box->ChangeValue(id, opt_val);

	else
		Main_FatalError("change_button: unknown what value '%s'\n", what);

	return 0;
}


// LUA: change_mod_option(module, option, value)
//
int gui_change_mod_option(lua_State *L)
{
	const char *module = luaL_checkstring(L,1);
	const char *option = luaL_checkstring(L,2);
	const char *value  = luaL_checkstring(L,3);

	SYS_ASSERT(module && option && value);

	// DebugPrintf("  change_mod_option: %s.%s --> %s\n", module, option, value);

	ob_set_mod_option(module, option, value);

	if (main_win)
		main_win->mod_box->ParseOptValue(module, option, value);

	return 0;
}


// LUA: at_level(name, idx, total)
//
int gui_at_level(lua_State *L)
{
	const char *name = luaL_checkstring(L,1);

	int index = luaL_checkint(L, 2);
	int total = luaL_checkint(L, 3);

	Main_ProgStatus("Making %s", name);

	if (main_win)
		main_win->build_box->Prog_AtLevel(index, total);

	return 0;
}


// LUA: prog_step(step_name)
//
int gui_prog_step(lua_State *L)
{
	const char *name = luaL_checkstring(L,1);

	if (main_win)
		main_win->build_box->Prog_Step(name);

	return 0;
}


// LUA: ticker()
//
int gui_ticker(lua_State *L)
{
	Main_Ticker();

	return 0;
}

// LUA: abort() --> boolean
//
int gui_abort(lua_State *L)
{
	int value = (main_action >= MAIN_CANCEL) ? 1 : 0;

	Main_Ticker();

	lua_pushboolean(L, value);
	return 1;
}


// LUA: rand_seed(seed)
//
int gui_rand_seed(lua_State *L)
{
	int the_seed = luaL_checkint(L, 1) & 0x7FFFFFFF;

	GUI_RNG.Seed(the_seed);

	return 0;
}

// LUA: random() --> number
//
int gui_random(lua_State *L)
{
	lua_Number value = GUI_RNG.Rand_fp();

	lua_pushnumber(L, value);
	return 1;
}


// LUA: bit_and(A, B) --> number
//
int gui_bit_and(lua_State *L)
{
	int A = luaL_checkint(L, 1);
	int B = luaL_checkint(L, 2);

	lua_pushinteger(L, A & B);
	return 1;
}

// LUA: bit_test(val) --> boolean
//
int gui_bit_test(lua_State *L)
{
	int A = luaL_checkint(L, 1);
	int B = luaL_checkint(L, 2);

	lua_pushboolean(L, (A & B) != 0);
	return 1;
}

// LUA: bit_or(A, B) --> number
//
int gui_bit_or(lua_State *L)
{
	int A = luaL_checkint(L, 1);
	int B = luaL_checkint(L, 2);

	lua_pushinteger(L, A | B);
	return 1;
}

// LUA: bit_xor(A, B) --> number
//
int gui_bit_xor(lua_State *L)
{
	int A = luaL_checkint(L, 1);
	int B = luaL_checkint(L, 2);

	lua_pushinteger(L, A ^ B);
	return 1;
}

// LUA: bit_not(val) --> number
//
int gui_bit_not(lua_State *L)
{
	int A = luaL_checkint(L, 1);

	// do not make the result negative
	lua_pushinteger(L, (~A) & 0x7FFFFFFF);
	return 1;
}


//------------------------------------------------------------------------


extern int SPOT_begin(lua_State *L);
extern int SPOT_draw_line(lua_State *L);
extern int SPOT_fill_poly(lua_State *L);
extern int SPOT_fill_box(lua_State *L);
extern int SPOT_apply_brushes(lua_State *L);
extern int SPOT_dump(lua_State *L);
extern int SPOT_get_mons(lua_State *L);
extern int SPOT_get_items(lua_State *L);
extern int SPOT_end(lua_State *L);

extern int CSG_begin_level(lua_State *L);
extern int CSG_end_level(lua_State *L);
extern int CSG_property(lua_State *L);
extern int CSG_add_brush(lua_State *L);
extern int CSG_add_entity(lua_State *L);
extern int CSG_trace_ray(lua_State *L);

extern int WF_wolf_block(lua_State *L);
extern int WF_wolf_read(lua_State *L);
extern int WF_wolf_mini_map(lua_State *L);

extern int DM_wad_name_gfx(lua_State *L);
extern int DM_wad_logo_gfx(lua_State *L);

extern int DM_wad_add_text_lump(lua_State *L);
extern int DM_wad_add_binary_lump(lua_State *L);
extern int DM_wad_insert_file(lua_State *L);
extern int DM_wad_transfer_lump(lua_State *L);
extern int DM_wad_transfer_map(lua_State *L);
extern int DM_wad_merge_sections(lua_State *L);
extern int DM_wad_read_text_lump(lua_State *L);

extern int DM_fsky_create(lua_State *L);
extern int DM_fsky_write(lua_State *L);
extern int DM_fsky_solid_box(lua_State *L);
extern int DM_fsky_add_stars(lua_State *L);
extern int DM_fsky_add_clouds(lua_State *L);
extern int DM_fsky_add_hills(lua_State *L);

extern int wadfab_load(lua_State *L);
extern int wadfab_free(lua_State *L);
extern int wadfab_get_polygon(lua_State *L);
extern int wadfab_get_sector(lua_State *L);
extern int wadfab_get_side(lua_State *L);
extern int wadfab_get_line(lua_State *L);
extern int wadfab_get_3d_floor(lua_State *L);
extern int wadfab_get_thing(lua_State *L);

extern int Q1_add_mapmodel(lua_State *L);
extern int Q1_add_tex_wad(lua_State *L);


static const luaL_Reg gui_script_funcs[] =
{
	{ "raw_log_print",     gui_raw_log_print },
	{ "raw_debug_print",   gui_raw_debug_print },
	{ "raw_console_print", gui_raw_console_print },

	{ "config_line",    gui_config_line },
	{ "mkdir",          gui_mkdir },
	{ "set_colormap",   gui_set_colormap },
	{ "locate_data",    gui_locate_data },

	{ "add_button",     gui_add_button },
	{ "add_mod_option", gui_add_mod_option },
	{ "show_button",    gui_show_button },
	{ "change_button",  gui_change_button },
	{ "change_mod_option", gui_change_mod_option },

	{ "at_level",    gui_at_level },
	{ "prog_step",   gui_prog_step },
	{ "ticker",      gui_ticker },
	{ "abort",       gui_abort },
	{ "rand_seed",   gui_rand_seed },
	{ "random",      gui_random },

	// CSG functions
	{ "begin_level", CSG_begin_level },
	{ "end_level",   CSG_end_level },
	{ "property",    CSG_property },
	{ "add_brush",   CSG_add_brush  },
	{ "add_entity",  CSG_add_entity },
	{ "trace_ray",   CSG_trace_ray },

	// Wolf-3D functions
	{ "wolf_block",     WF_wolf_block },
	{ "wolf_read",      WF_wolf_read },
	{ "wolf_mini_map",  WF_wolf_mini_map },

	// Doom/Heretic/Hexen functions
	{ "wad_name_gfx",   DM_wad_name_gfx  },
	{ "wad_logo_gfx",   DM_wad_logo_gfx  },
	{ "wad_add_text_lump",   DM_wad_add_text_lump },
	{ "wad_add_binary_lump", DM_wad_add_binary_lump },

	{ "wad_insert_file",   DM_wad_insert_file },
	{ "wad_transfer_lump", DM_wad_transfer_lump },
	{ "wad_transfer_map",  DM_wad_transfer_map },
	{ "wad_merge_sections",DM_wad_merge_sections },
	{ "wad_read_text_lump",DM_wad_read_text_lump },

	{ "fsky_create",      DM_fsky_create },
	{ "fsky_write",       DM_fsky_write },
	{ "fsky_solid_box",   DM_fsky_solid_box },
	{ "fsky_add_stars",   DM_fsky_add_stars },
	{ "fsky_add_clouds",  DM_fsky_add_clouds },
	{ "fsky_add_hills",   DM_fsky_add_hills },

	{ "wadfab_load",         wadfab_load },
	{ "wadfab_free",         wadfab_free },
	{ "wadfab_get_polygon",  wadfab_get_polygon },
	{ "wadfab_get_sector",   wadfab_get_sector },
	{ "wadfab_get_side",     wadfab_get_side },
	{ "wadfab_get_line",     wadfab_get_line },
	{ "wadfab_get_3d_floor", wadfab_get_3d_floor },
	{ "wadfab_get_thing",    wadfab_get_thing },

	// Quake functions
	{ "q1_add_mapmodel",  Q1_add_mapmodel },
	{ "q1_add_tex_wad",   Q1_add_tex_wad },

	// SPOT functions
	{ "spots_begin",     SPOT_begin },
	{ "spots_draw_line", SPOT_draw_line },
	{ "spots_fill_poly", SPOT_fill_poly },
	{ "spots_fill_box",  SPOT_fill_box },
	{ "spots_apply_brushes", SPOT_apply_brushes },
	{ "spots_dump",      SPOT_dump },
	{ "spots_get_mons",  SPOT_get_mons },
	{ "spots_get_items", SPOT_get_items },
	{ "spots_end",       SPOT_end },

	{ NULL, NULL } // the end
};


static const luaL_Reg bit_functions[] =
{
	{ "band",    gui_bit_and },
	{ "btest",   gui_bit_test },
	{ "bor",     gui_bit_or  },
	{ "bxor",    gui_bit_xor },
	{ "bnot",    gui_bit_not },

	{ NULL, NULL } // the end
};


int Script_RegisterLib(const char *name, const luaL_Reg *reg)
{
	SYS_NULL_CHECK(LUA_ST);

	luaL_register(LUA_ST, name, reg);

	// remove the table which luaL_register created
	lua_pop(LUA_ST, 1);

	return 0;
}


static int p_init_lua(lua_State *L)
{
	/* stop collector during initialization */
	lua_gc(L, LUA_GCSTOP, 0);
	{
		luaL_openlibs(L);  /* open libraries */

		Script_RegisterLib("gui", gui_script_funcs);
		Script_RegisterLib("bit", bit_functions);
	}
	lua_gc(L, LUA_GCRESTART, 0);

	return 0;
}


static void Script_SetScriptPath(lua_State *L, const char *path)
{
	LogPrintf("script_path: [%s]\n", path);

	lua_getglobal(L, "package");

	if (lua_type(L, -1) == LUA_TNIL)
		Main_FatalError("Script problem: no 'package' module!");

	lua_pushstring(L, path);

	lua_setfield(L, -2, "path");

	lua_pop(L, 1);
}


static void Script_SetDataPath(void)
{
	data_path = StringPrintf("%s/modules/data;%s/data", install_dir, install_dir);

	LogPrintf("data_path: [%s]\n\n", data_path);
}


static bool Script_CallFunc(const char *func_name, int nresult = 0, const char **params = NULL)
{
	// Note: the results of the function will be on the Lua stack

	lua_getglobal(LUA_ST, "ob_traceback");

	if (lua_type(LUA_ST, -1) == LUA_TNIL)
		Main_FatalError("Script problem: missing function '%s'", "ob_traceback");

	lua_getglobal(LUA_ST, func_name);

	if (lua_type(LUA_ST, -1) == LUA_TNIL)
		Main_FatalError("Script problem: missing function '%s'", func_name);

	int nargs = 0;
	if (params)
	{
		for (; *params; params++, nargs++)
			lua_pushstring(LUA_ST, *params);
	}

	int status = lua_pcall(LUA_ST, nargs, nresult, -2-nargs);
	if (status != 0)
	{
		const char *msg = lua_tolstring(LUA_ST, -1, NULL);

		// skip the filename
		const char *err_msg = strstr(msg, ": ");
		if (err_msg)
			err_msg += 2;
		else
			err_msg = msg;

		// this will appear in the log file too

		ConPrintf("\nScript Error: @1%s\n", err_msg);
		DLG_ShowError("Script Error: %s", err_msg);

		lua_pop(LUA_ST, 2);  // ob_traceback, message
		return false;
	}

	// remove the traceback function
	lua_remove(LUA_ST, -1-nresult);

	return true;
}


bool Script_RunString(const char *str, ...)
{
	static char buffer[MSG_BUF_LEN];

	va_list args;

	va_start(args, str);
	vsnprintf(buffer, MSG_BUF_LEN-1, str, args);
	va_end(args);

	buffer[MSG_BUF_LEN-2] = 0;


	lua_getglobal(LUA_ST, "ob_traceback");

	if (lua_type(LUA_ST, -1) == LUA_TNIL)
		Main_FatalError("Script problem: missing function '%s'", "ob_traceback");

	int status = luaL_loadbuffer(LUA_ST, buffer, strlen(buffer), "=CONSOLE");

	if (status != 0)
	{
		// const char *msg = lua_tolstring(LUA_ST, -1, NULL);

		ConPrintf("Error: @1Bad Syntax or Unknown Command\n");

		lua_pop(LUA_ST, 2);  // ob_traceback, message
		return false;
	}

	status = lua_pcall(LUA_ST, 0, 0, -2);
	if (status != 0)
	{
		const char *msg = lua_tolstring(LUA_ST, -1, NULL);

		// skip the filename
		const char *err_msg = strstr(msg, ": ");
		if (err_msg)
			err_msg += 2;
		else
			err_msg = msg;

		ConPrintf("\nScript Error: @1%s\n", err_msg);
		LogPrintf("\nScript Error: %s\n", err_msg);

		lua_pop(LUA_ST, 2);  // ob_traceback, message
		return false;
	}

	lua_pop(LUA_ST, 1);  // ob_traceback
	return true;
}


static void Script_Require(const char *name)
{
	char require_text[128];
	sprintf(require_text, "require '%s'", name);

	int status = luaL_loadstring(LUA_ST, require_text);

	if (status == 0)
		status = lua_pcall(LUA_ST, 0, 0, 0);

	if (status != 0)
	{
		const char *msg = lua_tolstring(LUA_ST, -1, NULL);

		Main_FatalError("Unable to load script '%s.lua'\n%s", name, msg);
	}
}


static void Script_LoadFile(const char *filename)
{
	int status = luaL_loadfile(LUA_ST, filename);

	if (status == 0)
		status = lua_pcall(LUA_ST, 0, 0, 0);

	if (status != 0)
	{
		const char *msg = lua_tolstring(LUA_ST, -1, NULL);

		Main_FatalError("Unable to load script '%s'\n%s",
				fl_filename_name(filename), msg);
	}
}


static bool Script_LoadAllFromDir(const char *path, const char *ext)
{
	// load all scripts (files which match "*.lua") from a
	// sub-directory.

	LogPrintf("Loading scripts from: [%s]\n", path);

	std::vector<std::string> file_list;

	int count = ScanDir_MatchingFiles(path, ext, file_list);

	if (count < 0)
	{
		LogPrintf("  --> No such directory.\n\n");
		return false;
	}

	DebugPrintf("Scanned %d entries in sub-directory.\n", count);

	for (unsigned int i = 0 ; i < file_list.size() ; i++)
	{
		const char *base_name = file_list[i].c_str();

		LogPrintf("Loading %d/%d : %s\n", i+1, file_list.size(), base_name);

		const char *full_name = StringPrintf("%s/%s", path, base_name);

		// load it !!
		Script_LoadFile(full_name);

		StringFree(full_name);
	}

	if (file_list.size() > 0)
		LogPrintf("DONE.\n\n");

	return true;  // OK
}


static void Script_LoadSubDir(const char *subdir)
{
	const char *path = StringPrintf("%s/%s", install_dir, subdir);

	Script_LoadAllFromDir(path, "lua");

	StringFree(path);
}


void Script_LoadSkins(void)
{
	std::vector<std::string> subdir_list;

	int count = ScanDir_GetSubDirs(game_dir, subdir_list);

	if (count < 0)
		Main_FatalError("Failed to scan prefab directory\n(error code %d)\n", count);

	if (count == 0)
		Main_FatalError("Missing prefab folders?!?\n");

	// visit each folder and load the skin files

	for (unsigned int i = 0 ; i < subdir_list.size() ; i++)
	{
		const char *subdir = StringPrintf("%s/%s", game_dir, subdir_list[i].c_str());

		Script_LoadAllFromDir(subdir, "lua");

		StringFree(subdir);
	}
}


void Script_Open(const char *game_name)
{
	// set the 'game_dir' global var

	game_dir = StringPrintf("%s/games/%s", install_dir, game_name);

	LogPrintf("\n--- OPENING LUA VM ---\n\n");
	LogPrintf("game_dir: %s\n\n", game_dir);


	// create Lua state

	LUA_ST = luaL_newstate();
	if (! LUA_ST)
		Main_FatalError("LUA Init failed: cannot create new state");

	int status = lua_cpcall(LUA_ST, &p_init_lua, NULL);
	if (status != 0)
		Main_FatalError("LUA Init failed: cannot load standard libs (%d)", status);

	Script_SetDataPath();


	// load main scripts

	LogPrintf("Loading main script: oblige.lua\n");

	const char *script_path = StringPrintf("%s/scripts/?.lua", install_dir);

	Script_SetScriptPath(LUA_ST, script_path);

	Script_Require("oblige");

	LogPrintf("DONE.\n\n");

	Script_LoadSubDir("engines");
	Script_LoadSubDir("modules");


	// load game-specific scripts

	const char *game_path = StringPrintf("%s/?.lua", game_dir);

	Script_SetScriptPath(LUA_ST, game_path);

	Script_Require("base");

	Script_LoadSkins();

	has_loaded = true;

	if (! Script_CallFunc("ob_init"))
		Main_FatalError("The ob_init script failed.\n");

	has_added_buttons = true;
}


void Script_Close()
{
	if (LUA_ST)
		lua_close(LUA_ST);

	LUA_ST = NULL;

	game_dir = NULL;

	LogPrintf("\n--- CLOSED LUA VM ---\n\n");
}


//------------------------------------------------------------------------
// WRAPPERS TO LUA FUNCTIONS
//------------------------------------------------------------------------


bool ob_set_config(const char *key, const char *value)
{
	// See the document 'doc/Config_Flow.txt' for a good
	// description of the flow of configuration values
	// between the C++ GUI and the Lua scripts.

	SYS_NULL_CHECK(key);
	SYS_NULL_CHECK(value);

	if (! has_loaded)
	{
		DebugPrintf("ob_set_config(%s) called before loaded!\n", key);
		return false;
	}

	const char *params[3];

	params[0] = key;
	params[1] = value;
	params[2] = NULL; // end of list

	return Script_CallFunc("ob_set_config", 0, params);
}


bool ob_set_mod_option(const char *module, const char *option,
		const char *value)
{
	if (! has_loaded)
	{
		DebugPrintf("Script_SetModOption called before loaded!\n");
		return false;
	}

	const char *params[4];

	params[0] = module;
	params[1] = option;
	params[2] = value;
	params[3] = NULL;

	return Script_CallFunc("ob_set_mod_option", 0, params);
}


bool ob_read_all_config(std::vector<std::string> * lines)
{
	if (! has_loaded)
	{
		DebugPrintf("Script_GetAllConfig called before loaded!\n");
		return false;
	}

	conf_line_buffer = lines;

	bool result = Script_CallFunc("ob_read_all_config", 0);

	conf_line_buffer = NULL;

	return result;
}


const char * ob_game_format(void)
{
	if (! Script_CallFunc("ob_game_format", 1))
		return NULL;

	const char *res = lua_tolstring(LUA_ST, -1, NULL);

	if (res)
		res = StringDup(res);

	// remove result from lua stack
	lua_pop(LUA_ST, 1);

	return res;
}


bool ob_build_cool_shit(void)
{
	if (! Script_CallFunc("ob_build_cool_shit", 1))
	{
		Main_ProgStatus("Script Error");
		return false;
	}

	const char *res = lua_tolstring(LUA_ST, -1, NULL);

	// remove result from lua stack
	lua_pop(LUA_ST, 1);

	if (res && strcmp(res, "ok") == 0)
		return true;

	Main_ProgStatus("Cancelled");
	return false;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
