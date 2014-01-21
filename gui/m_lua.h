//------------------------------------------------------------------------
//  LUA interface
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#ifndef __SCRIPTING_HEADER__
#define __SCRIPTING_HEADER__

typedef struct lua_State lua_State;

void Script_Open(const char *game_name);
void Script_Close();

bool Script_RunString(const char *str, ...);


#define MAX_COLOR_MAPS  9  // 1 to 9 (from Lua)
#define MAX_COLORS_PER_MAP  260

typedef struct
{
	byte colors[MAX_COLORS_PER_MAP];
	int  size;
}
color_mapping_t;

extern color_mapping_t color_mappings[MAX_COLOR_MAPS];

// Wrappers which call Lua functions:

bool ob_set_config(const char *key, const char *value);
bool ob_set_mod_option(const char *module, const char *option,
                       const char *value);

bool ob_read_all_config(std::vector<std::string> * lines);

const char * ob_game_format(void);

bool ob_build_cool_shit(void);

#endif /* __SCRIPTING_HEADER__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
