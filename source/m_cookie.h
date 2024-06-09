//------------------------------------------------------------------------
//  COOKIE : Save/Load user settings
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#include <cstdio>
#include <string>

bool Cookie_Load(std::string filename);
bool Cookie_Save(std::string filename);

bool Cookie_LoadString(std::string str, bool _keep_seed);

void Cookie_ParseArguments(void);

/* option stuff */

void Parse_Option(const std::string &name, const std::string &value);
bool Options_Load(std::string filename);
bool Options_Save(std::string filename);
bool Theme_Options_Load(std::string filename);
bool Theme_Options_Save(std::string filename);

/* recent file stuff */

void Recent_Parse(std::string name, std::string value);
void Recent_Write(std::ofstream &fp);

typedef enum
{
    RECG_Output = 0, // generated WAD
    RECG_Config = 1, // file saved from Config Manager

    RECG_NUM_GROUPS

} recent_group_e;

void Recent_AddFile(int group, std::string filename);
void Recent_RemoveFile(int group, std::string filename);
bool Recent_GetName(int group, int index, std::string name_buf, bool for_menu = false);

#endif /* __OBLIGE_COOKIE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
