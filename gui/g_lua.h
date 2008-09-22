//------------------------------------------------------------------------
//  LUA interface
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

void Script_Init(void);
void Script_Close(void);

void Script_Load(void);

int Script_RegisterLib(const char *name, const luaL_Reg *reg);

bool Script_SetConfig(const char *key, const char *value);
bool Script_SetModOption(const char *module, const char *option,
                         const char *value);
bool Script_ReadAllConfig(std::vector<std::string> * lines);

const char * Script_GameFormat(void);

bool Script_Build(void);

#endif /* __SCRIPTING_HEADER__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
