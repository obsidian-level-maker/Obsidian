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
#include "hdr_ui.h"

#include "lib_util.h"
#include "main.h"


#define MAP_BORDER  2


UI_MiniMap::UI_MiniMap(int x, int y, int w, int h, const char *label) :
    Fl_Box(x, y, w, h, label),
    pixels(NULL), cur_image(NULL)
{
  box(FL_NO_BOX);
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

void UI_MiniMap::EmptyMap()
{
  MapBegin(w(), h());
  MapFinish();
}

void UI_MiniMap::MapBegin(int pixel_W, int pixel_H)
{
  map_X = 0;
  map_Y = 0;
  map_W = pixel_W;
  map_H = pixel_H;

  real_W = w();
  real_H = h();

  if (pixels)
    delete[] pixels;

  pixels = new u8_t[real_W * real_H * 3];

  MapClear();
}

void UI_MiniMap::MapClear()
{
  memset(pixels, 0, real_W * real_H * 3);

  for (int py = 0; py < real_H; py++)
  for (int px = 0; px < real_W; px++)
  {
    u8_t *pix = pixels + (py*real_W + px) * 3;

    if ((px % 10) == 5 || (py % 10) == 5)
    {
      pix[2] = 176;
    }
  }
}

void UI_MiniMap::MapPixel(int kind)
{
  SYS_ASSERT(pixels);
  SYS_ASSERT(0 <= kind && kind <= 4);

  static u8_t colors[5*3] =
  {
    0,0,0,  224,216,208,  192,96,96,  96,96,192,  224,192,96
  };

  if (kind > 0)
  {
    int x = MAP_BORDER + map_X;
    int y = real_H-1 - MAP_BORDER - map_Y;

    if (x >= MAP_BORDER && x < (real_W - MAP_BORDER) &&
        y >= MAP_BORDER && y < (real_H - MAP_BORDER))
    {
      u8_t *pos = pixels + (y*real_W + x) * 3;

      *pos++ = colors[kind*3 + 0];
      *pos++ = colors[kind*3 + 1];
      *pos++ = colors[kind*3 + 2];
    }
  }

  map_X++;

  if (map_X >= map_W)
  {
    map_X = 0; map_Y++;
  }
}

void UI_MiniMap::MapFinish()
{
  SYS_ASSERT(pixels);

  MapCorner(0, 0, 1, 1);
  MapCorner(0, real_H-1, 1, -1);
  MapCorner(real_W-1, 0, -1, 1);
  MapCorner(real_W-1, real_H-1, -1, -1);

  if (cur_image)
  {
    image(NULL);
    delete cur_image;
  }

  cur_image = new Fl_RGB_Image(pixels, real_W, real_H);

  image(cur_image);
  redraw();
}

void UI_MiniMap::MapCorner(int x, int y, int dx, int dy)
{
  u8_t r, g, b;

  Fl::get_color(BUILD_BG, r, g, b);

  DrawPixel(x+dx*0, y+dy*0, r, g, b);
  DrawPixel(x+dx*1, y+dy*0, r, g, b);
  DrawPixel(x+dx*0, y+dy*1, r, g, b);
}

void UI_MiniMap::DrawPixel(int x, int y, u8_t r, u8_t g, u8_t b)
{
  u8_t *pos = pixels + (y*real_W + x)*3;

  pos[0] = r;
  pos[1] = g;
  pos[2] = b;
}

