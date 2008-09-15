//------------------------------------------------------------------------
//  LEVEL building - Wolf3d format
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

#ifndef __OBLIGE_LWOLF_H__
#define __OBLIGE_LWOLF_H__

void Wolf_Init(void);

int Wolf_add_block(lua_State *L);


game_interface_c * Wolf_GameObject(void);

/* ----- File structures ---------------------- */

#endif /* __OBLIGE_LWOLF_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
