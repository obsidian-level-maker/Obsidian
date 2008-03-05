//------------------------------------------------------------------------
//  2.5D CSG : DOOM output
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

#ifndef __OBLIGE_DOOM_LEVEL_H__
#define __OBLIGE_DOOM_LEVEL_H__

typedef enum
{
  DMSUB_Doom = 0,
  DMSUB_Heretic = 1,
  DMSUB_Hexen = 2
}
doom_subtype_e;

game_interface_c * Doom_GameObject(int subtype = DMSUB_Doom);

#endif /* __OBLIGE_DOOM_LEVEL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
