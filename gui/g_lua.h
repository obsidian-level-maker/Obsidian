//------------------------------------------------------------------------
//  LUA interface
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006 Andrew Apted
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

void Script_Init();
void Script_Done();

void Script_Load();
bool Script_Run();

#endif // __SCRIPTING_HEADER__
