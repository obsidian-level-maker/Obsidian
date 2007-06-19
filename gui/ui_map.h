//------------------------------------------------------------------------
//  Mini Map
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

  Fl_RGB_Image *map;

  int map_X, map_Y;
  int map_W, map_H;

  u8_t *map_pix;

public:
  UI_MiniMap(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_MiniMap();

public:
  void MapBegin(int pixel_W, int pixel_H);
  void MapPixel(int kind);
  void MapFinish();

  void MapCorner(int x, int y);
};

#endif /* __UI_MAP_H__ */
