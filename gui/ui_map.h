//------------------------------------------------------------------------
//  Mini Map
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

#ifndef __UI_MAP_H__
#define __UI_MAP_H__

class UI_MiniMap : public Fl_Box
{
private:
	int map_W, map_H;

	u8_t *pixels;

	Fl_RGB_Image *cur_image;

public:
	UI_MiniMap(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_MiniMap();

public:
	int GetWidth()  const { return map_W; }
	int GetHeight() const { return map_H; }

	void EmptyMap();

	void MapBegin();
	void MapFinish();

	void DrawPixel(int x, int y, byte r, byte g, byte b);
	void DrawBox  (int x1, int y1, int x2, int y2, byte r, byte g, byte b);
	void DrawLine (int x1, int y1, int x2, int y2, byte r, byte g, byte b);
	void DrawEntity(int x, int y, byte r, byte g, byte b);

private:
	void MapClear();
	void MapCorner(int x, int y, int dx, int dy);

	inline void RawPixel(int x, int y, byte r, byte g, byte b)
	{
		u8_t *pos = pixels + ((map_H-1 - y)*map_W + x) * 3;

		*pos++ = r; *pos++ = g; *pos = b;
	}

	enum outcode_flags_e
	{
		O_TOP    = 1,
		O_BOTTOM = 2,
		O_LEFT   = 4,
		O_RIGHT  = 8,
	};

	int Calc_Outcode(int x, int y)
	{
		return
			((y < 0)       ? O_BOTTOM : 0) |
			((y > map_H-1) ? O_TOP    : 0) |
			((x < 0)       ? O_LEFT   : 0) |
			((x > map_W-1) ? O_RIGHT  : 0);
	}
};

#endif /* __UI_MAP_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
