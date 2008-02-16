//------------------------------------------------------------------------
//  EXTRACTION Wizard
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

#ifndef __UI_EXTRACT_H__
#define __UI_EXTRACT_H__

typedef struct extract_info_s
{
  const char *game;   // e.g. "Quake1"
  const char *type;   // e.g. "the textures"
  const char *file;   // e.g. "pak0.pak"
  const char *dir;    // e.g. "id1", or NULL

  const char *detected;  // detected filename or NULL
}
extract_info_t;

void DLG_ExtractStuff(extract_info_t *info);

#endif // __UI_EXTRACT_H__

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
