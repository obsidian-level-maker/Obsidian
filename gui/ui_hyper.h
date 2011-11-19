//------------------------------------------------------------------------
//  Hyperlinks
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2011 Andrew Apted
//  Copyright (C) 2002 Jason Bryan
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

#ifndef __UI_HYPER_H__
#define __UI_HYPER_H__

class UI_HyperLink : public Fl_Button
{
private:
  // true when mouse is over this widget
  bool hover;

  // area containing the label
  int label_X, label_Y, label_W, label_H;

public:
  UI_HyperLink(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_HyperLink();

public:
  // FLTK overrides

/*
  //! Override of Fl_Widget::color()
  inline void color( unsigned c )
  { col = (Fl_Color)c; Fl_Button::color(col); }

  //! Override of Fl_Widget::color()
  inline Fl_Color color() const
  { return col; }

  //! Override of Fl_Widget::selection_color()
  inline void selection_color( unsigned c )
  { sCol = (Fl_Color)c; Fl_Button::selection_color(sCol); }

  //! Override of Fl_Widget::selection_color()
  inline Fl_Color selection_color() const
  { return sCol; }
*/

  //! Override of Fl_Button::handle()
  int handle( int event );

  // Override of Fl_Button::draw()
  void draw();

private:
  void checkLink();
};

#endif /* __UI_HYPER_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
