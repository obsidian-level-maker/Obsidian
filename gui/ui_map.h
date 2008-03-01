//------------------------------------------------------------------------
//  Mini Map
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
  void EmptyMap();

  void MapBegin();
  void MapFinish();

  void MapClear();
  void MapCorner(int x, int y, int dx, int dy);

  void DrawPixel(int x, int y, byte r, byte g, byte b);
  void DrawLine (int x1, int y1, int x2, int y2, byte r, byte g, byte b, bool end = true);
  void DrawEntity(int x, int y, byte r, byte g, byte b);
};

#endif /* __UI_MAP_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
