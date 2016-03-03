//------------------------------------------------------------------------
//  TGA (Targa) IMAGE LOADING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2013-2015 Andrew Apted
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

#ifndef __OBLIGE_TGA_LOADER_H__
#define __OBLIGE_TGA_LOADER_H__


// this layout is compatible with Fl_Color (except for alpha)
typedef unsigned int rgb_color_t;

#define MAKE_RGBA(r, g, b, a)	(((r) << 24) | ((g) << 16) | ((b) << 8) | (a))

#define RGB_RED(col)	((col >> 24) & 255)
#define RGB_GREEN(col)	((col >> 16) & 255)
#define RGB_BLUE(col)	((col >>  8) & 255)
#define RGB_ALPHA(col)	((col      ) & 255)


typedef enum
{
	OPAC_UNKNOWN = 0,

	OPAC_Solid,		// utterly solid (alpha = 255 everywhere)
	OPAC_Masked,	// only uses alpha 255 and 0
	OPAC_Complex 	// uses full range of alpha values
}
opacity_e;


class tga_image_c
{
public:
	int  width;
	int  height;

	opacity_e  opacity; 

	rgb_color_t * pixels;

public:
	 tga_image_c(int W, int H);
	~tga_image_c();
};


tga_image_c * TGA_LoadImage(const char *path);


#endif  /* __OBLIGE_TGA_LOADER_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
