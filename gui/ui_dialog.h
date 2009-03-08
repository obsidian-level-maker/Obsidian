//------------------------------------------------------------------------
//  DIALOG when all fucked up
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2009 Andrew Apted
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
#ifndef __DIALOG_HEADER__
#define __DIALOG_HEADER__

void DLG_ShowError(const char *msg, ...);

typedef struct extract_info_s
{
  const char *game;   // e.g. "Quake1"
  const char *type;   // e.g. "the textures"
  const char *file;   // e.g. "pak0.pak"
  const char *dir;    // e.g. "id1", or NULL

  const char *detected;  // detected filename or NULL
}
extract_info_t;

typedef enum
{
  EXDLG_Abort = 1,
  EXDLG_UseDetected  = 2,
  EXDLG_FindManually = 3
}
extract_dialog_result_e;

int DLG_ExtractStuff(extract_info_t *info);

#endif // __DIALOG_HEADER__

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
