//------------------------------------------------------------------------
//  Texture Extraction
//------------------------------------------------------------------------
// 
//  Copyright (c) 2008-2009  Andrew J Apted
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

#ifndef __IMAGE_TEXTURE_H__
#define __IMAGE_TEXTURE_H__

void TEX_ExtractStart();
void TEX_ExtractDone();

void TEX_ExtractFromPAK(const char *filename);

#endif  /* __IMAGE_TEXTURE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
