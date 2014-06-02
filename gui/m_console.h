//------------------------------------------------------------------------
//  DEBUGGING & VISUALIZATION
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

#ifndef __UI_DEBUG_H__
#define __UI_DEBUG_H__

extern bool debug_onto_console;

void UI_OpenConsole();
void UI_CloseConsole();
void UI_ToggleConsole();

void ConPrintf(const char *str, ...);

#endif /* __UI_DEBUG_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
