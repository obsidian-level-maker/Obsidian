//----------------------------------------------------------------
//  Grid Editor
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"

#include "ui_grid.h"
#include "ui_window.h"

#include "lib_util.h"


UI_Grid::UI_Grid(int x, int y, int w, int h, const char *label) :
    Fl_Widget(x, y, w, h, label)
{
}

UI_Grid::~UI_Grid()
{
}

void UI_Grid::resize(int X, int Y, int W, int H)
{
    Fl_Widget::resize(X, Y, W, H);
}


//------------------------------------------------------------------------


void UI_Grid::draw()
{
  fl_push_clip(x(), y(), w(), h());

  fl_color(FL_BLACK);
  fl_rectf(x(), y(), w(), h());

  draw_grid();
  draw_rooms();
  draw_links();
  draw_seeds();

  fl_pop_clip();
}

void UI_Grid::draw_grid()
{
  fl_color(fl_rgb_color(80, 80, 80));

  for (int sx = 1; sx <= 20; sx++)
  for (int sy = 1; sy <= 20; sy++)
  {
    int px = (sx-1) * 20 + 4  + 20;
    int py = h() - 4 - sy*20  - 20;

    fl_rectf(px+2, py+2, 16,16);
  }
}

void UI_Grid::draw_rooms()
{
}

void UI_Grid::draw_seeds()
{
}

void UI_Grid::draw_links()
{
}


//------------------------------------------------------------------------


int UI_Grid::handle(int event)
{
  switch (event)
  {
    case FL_FOCUS:
      return 1;

    case FL_KEYDOWN:
    case FL_SHORTCUT:
    {
      int result = handle_key(Fl::event_key());
      handle_mouse(Fl::event_x(), Fl::event_y());
      return result;
    }

    case FL_ENTER:
    case FL_LEAVE:
      return 1;

    case FL_MOVE:
      handle_mouse(Fl::event_x(), Fl::event_y());
      return 1;

    case FL_PUSH:
      if (Fl::focus() != this)
      {
        Fl::focus(this);
        handle(FL_FOCUS);
        return 1;
      }

      if (Fl::event_state() & FL_CTRL)
      {
      }
      else
      {
      }

      redraw();
      return 1;

    case FL_MOUSEWHEEL:
///      if (Fl::event_dy() < 0)
///        SetZoom(zoom + 1);
///      else if (Fl::event_dy() > 0)
///        SetZoom(zoom - 1);

      handle_mouse(Fl::event_x(), Fl::event_y());
      return 1;

    case FL_DRAG:
    case FL_RELEASE:
      // these are currently ignored.
      return 1;

    default:
      break;
  }

  return 0;  // unused
}

int UI_Grid::handle_key(int key)
{
  return 0;  // unused
}

void UI_Grid::handle_mouse(int wx, int wy)
{
}

