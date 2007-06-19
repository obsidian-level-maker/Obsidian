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

#include "headers.h"
#include "hdr_fltk.h"
#include "lib_util.h"

#include "main.h"
#include "ui_map.h"


#define MAP_BORDER   2
#define MAP_BG       fl_gray_ramp(FL_NUM_GRAY * 2 / 24)


UI_MiniMap::UI_MiniMap(int x, int y, int w, int h, const char *label) :
    Fl_Box(x, y, w, h, label),
    map(NULL)
{
  box(FL_FLAT_BOX);
  color(MAIN_BG_COLOR, MAIN_BG_COLOR);
}


UI_MiniMap::~UI_MiniMap()
{
}

void UI_MiniMap::MapBegin(int pixel_W, int pixel_H)
{
  map_X = 0;
  map_Y = 0;
  map_W = pixel_W;
  map_H = pixel_H;

  int real_size = (map_box->w() - MAP_BORDER * map_box->h() * 3)

  map_pix = new u8_t[real_size];

  // clear the image
  u8_t r, g, b;

  Fl::get_color(MAP_BG, r, g, b);

  u8_t* map_end = map_start + (map_W * map_H * 3);

  for (u8_t *pos = map_pix; pos < map_end; )
  {
    *pos++ = r;
    *pos++ = g;
    *pos++ = b;
  }
}

void UI_MiniMap::MapPixel(int kind)
{
  SYS_ASSERT(0 <= kind && kind <= 4);

  static u8_t colors[5*3] =
  {
    0,0,0,  224,216,208,  192,96,96,  96,96,192,  224,96,224
  };

  if (map_X >= MAP_BORDER && map_X < map_W-MAP_BORDER &&
      map_Y >= MAP_BORDER && map_Y < map_H-MAP_BORDER)

  if (kind == 0)
  {
    map_pos += 3;
    return;
  }

  *map_pos++ = colors[kind*3 + 0];
  *map_pos++ = colors[kind*3 + 1];
  *map_pos++ = colors[kind*3 + 2];
}

void UI_MiniMap::MapFinish()
{
  MapCorner(0, 0);
  MapCorner(0, map_H-1);
  MapCorner(map_W-1, 0);
  MapCorner(map_W-1, map_H-1);

  if (map) { map_box->image(NULL); delete map; }

  map = new Fl_RGB_Image(map_pix, map_box->w(), map_box->h());

  map_box->image(map);
  map_box->redraw();
}

void UI_MiniMap::MapCorner(int x, int y)
{
  u8_t *pos = map_pix + (y*map_W+x)*3;

  Fl::get_color(MAIN_BG_COLOR, pos[0], pos[1], pos[2]);
}

