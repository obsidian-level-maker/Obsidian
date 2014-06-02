//------------------------------------------------------------------------
//  COOKIE : Save/Load user settings
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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

#ifndef __OBLIGE_COOKIE_H__
#define __OBLIGE_COOKIE_H__

bool Cookie_Load(const char *filename);
bool Cookie_Save(const char *filename);

bool Cookie_LoadString(const char *str);

void Cookie_ParseArguments(void);

/* option stuff */

bool Options_Load(const char *filename);
bool Options_Save(const char *filename);

/* recent file stuff */

void Recent_Parse(const char *name, const char *value);
void Recent_Write(FILE *fp);

typedef enum
{
	RECG_Output = 0,   // generated WAD or PAK file
	RECG_Config = 1,   // file saved from Config Manager

	RECG_NUM_GROUPS

} recent_group_e;

void Recent_AddFile(int group, const char *filename);
void Recent_RemoveFile(int group, const char *filename);
bool Recent_GetName(int group, int index, char *name_buf, bool for_menu = false);

#endif /* __OBLIGE_COOKIE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
