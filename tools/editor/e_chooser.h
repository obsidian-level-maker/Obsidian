//------------------------------------------------------------------------
//  File Chooser dialog
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

#ifndef __UI_CHOOSER_H__
#define __UI_CHOOSER_H__

void Default_Location(void);

char *Select_Output_File(const char *ext);
char *Select_Input_File(const char *ext);

// for config file...
bool UI_SetLastFile(const char *filename);
const char *UI_GetLastFile(void);

#endif /* __UI_CHOOSER_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
