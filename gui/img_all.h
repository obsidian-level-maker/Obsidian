//------------------------------------------------------------------------
//  LOGO Images
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#ifndef __OBLIGE_LOGOS_H__
#define __OBLIGE_LOGOS_H__

typedef struct
{
  const char *name;

  int width;
  int height;

  const byte *data;
}
logo_image_t;

extern const logo_image_t logo_BOLT;
extern const logo_image_t logo_PILL;
extern const logo_image_t logo_CARVE;
extern const logo_image_t logo_RELIEF;

extern const logo_image_t font_CWILV;

#endif /* __OBLIGE_LOGOS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
