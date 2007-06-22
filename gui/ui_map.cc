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
#include "ui_window.h"


#define MAP_BORDER  2

#define BG_COLOR  fl_gray_ramp(FL_NUM_GRAY * 2 / 24)


UI_MiniMap::UI_MiniMap(int x, int y, int w, int h, const char *label) :
    Fl_Box(x, y, w, h, label),
    pixels(NULL), cur_image(NULL)
{
  box(FL_FLAT_BOX);
  color(MAIN_BG_COLOR, MAIN_BG_COLOR);
}


UI_MiniMap::~UI_MiniMap()
{
  if (cur_image)
  {
    image(NULL);
    delete cur_image;
  }

  if (pixels)
    delete[] pixels;
}

void UI_MiniMap::MapBegin(int pixel_W, int pixel_H)
{
  map_X = 0;
  map_Y = 0;
  map_W = pixel_W;
  map_H = pixel_H;

  real_W = w();
  real_H = h();

  int real_size = real_W * real_H * 3;

  if (pixels)
    delete[] pixels;

  pixels = new u8_t[real_size];

  MapClear();
}

void UI_MiniMap::MapClear()
{
  u8_t r, g, b;
  u8_t *map_end = pixels + (map_W * map_H * 3);

  Fl::get_color(BG_COLOR, r, g, b);

  for (u8_t *pos = pixels; pos < map_end; )
  {
    *pos++ = r; *pos++ = g; *pos++ = b;
  }
}

void UI_MiniMap::MapPixel(int kind)
{
  SYS_ASSERT(pixels);
  SYS_ASSERT(0 <= kind && kind <= 4);

  static u8_t colors[5*3] =
  {
    0,0,0,  224,216,208,  192,96,96,  96,96,192,  224,96,224
  };

  if (kind > 0)
  {
    int x = MAP_BORDER + map_X;
    int y = real_H-1 - MAP_BORDER - map_Y;

    if (x >= 0 && x < real_W && y >= 0 && y < real_H)
    {
      u8_t *pos = pixels + (y*real_W + x) * 3;

      *pos++ = colors[kind*3 + 0];
      *pos++ = colors[kind*3 + 1];
      *pos++ = colors[kind*3 + 2];
    }
  }

  map_Y++;

  if (map_X >= map_W)
  {
    map_X = 0; map_Y++;
  }
}

void UI_MiniMap::MapFinish()
{
  MapCorner(0, 0);
  MapCorner(0, real_H-1);
  MapCorner(real_W-1, 0);
  MapCorner(real_W-1, real_H-1);

  if (cur_image)
  {
    image(NULL);
    delete cur_image;
  }

  cur_image = new Fl_RGB_Image(pixels, real_W, real_H);

  image(cur_image);
  redraw();
}

void UI_MiniMap::MapCorner(int x, int y)
{
  u8_t *pos = pixels + (y*real_W + x)*3;

  Fl::get_color(MAIN_BG_COLOR, pos[0], pos[1], pos[2]);
}

