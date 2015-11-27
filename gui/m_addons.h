//------------------------------------------------------------------------
//  Addons Loading and Selection GUI
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2015 Andrew Apted
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

#ifndef __OBLIGE_ADDONS_H__
#define __OBLIGE_ADDONS_H__

void VFS_InitAddons(const char *argv0);
void VFS_ParseCommandLine();

void VFS_OptParse(const char *name);
void VFS_OptWrite(FILE *fp);

// util functions
bool   VFS_CopyFile(const char *src_name, const char *dest_name);
byte * VFS_LoadFile(const char *filename, int *length);
void   VFS_FreeFile(const byte *mem);

#endif /* __OBLIGE_ADDONS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
