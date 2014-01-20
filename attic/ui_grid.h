//------------------------------------------------------------------------
//  Grid Editor
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

#ifndef __UI_GRID_H__
#define __UI_GRID_H__

class UI_Grid : public Fl_Widget
{

public:
  UI_Grid(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Grid();

public:
  /* FLTK event handler method */
  int handle(int event);

  /* FLTK resize method */
  void resize(int X, int Y, int W, int H);

private:
  /* FLTK draw method */
  void draw();

  void draw_grid();
  void draw_rooms();
  void draw_seeds();
  void draw_links();

  int  handle_key(int key);
  void handle_mouse(int wx, int wy);
};

#endif /* __UI_GRID_H__ */
