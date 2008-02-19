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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "main.h"


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
  MapBegin();
  MapFinish();
}


void UI_MiniMap::MapBegin()
{
  map_W = w();
  map_H = h();

  if (pixels)
    delete[] pixels;

  pixels = new u8_t[map_W * map_H * 3];

  MapClear();
}


void UI_MiniMap::MapClear()
{
  memset(pixels, 0, map_W * map_H * 3);

  // draw the grid

  for (int py = 0; py < map_H; py++)
  for (int px = 0; px < map_W; px++)
  {
    u8_t *pix = pixels + (py*map_W + px) * 3;

    if ((px % 10) == 5 || (py % 10) == 5)
    {
      pix[2] = 176;
    }
  }
}


void UI_MiniMap::MapFinish()
{
  SYS_ASSERT(pixels);

  MapCorner(0, 0, 1, 1);
  MapCorner(0, map_H-1, 1, -1);
  MapCorner(map_W-1, 0, -1, 1);
  MapCorner(map_W-1, map_H-1, -1, -1);

  if (cur_image)
  {
    image(NULL);
    delete cur_image;
  }

  cur_image = new Fl_RGB_Image(pixels, map_W, map_H);

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
  if (x < 0 || x >= map_W || y < 0 || y >= map_H)
    return;

  u8_t *pos = pixels + ((map_H-1-y)*map_W + x)*3;

  pos[0] = r;
  pos[1] = g;
  pos[2] = b;
}


void UI_MiniMap::DrawLine(int x1, int y1, int x2, int y2,
                          u8_t r, u8_t g, u8_t b, bool end)
{
  // FIXME: proper clipped line drawer please!

  if (MAX(x1, x2) < 0 || MIN(x1, x2) >= map_W ||
      MAX(y1, y2) < 0 || MIN(y1, y2) >= map_H)
    return;

  if (abs(x1-x2) <= 1 && abs(y1 - y2) <= 1)
  {
    if (end)
      DrawPixel(x2, y2, r, g, b);

    DrawPixel(x1, y1, r, g, b);
    return;
  }

  int mx = (x1 + x2) / 2;
  int my = (y1 + y2) / 2;

  DrawLine(x1,y1, mx,my, r,g,b, false);
  DrawLine(mx,my, x2,y2, r,g,b, end);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
