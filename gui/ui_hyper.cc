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
//
//  Used some code from Jason Bryan's FLU (FLTK Utility Widgets),
//  which is under the the GNU LGPL license (same as FLTK itself).
//
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "main.h"

#define LINK_BLUE  FL_BLUE  // fl_rgb_color(0,0,192)


UI_HyperLink::UI_HyperLink(int x, int y, int w, int h, const char *label) :
    Fl_Button(x, y, w, h, label),
    hover(false)
{
  box(FL_FLAT_BOX);
  color(FL_GRAY);
  labelcolor(LINK_BLUE);
}


UI_HyperLink::~UI_HyperLink()
{
}


void UI_HyperLink::checkLink()
{
  // change the cursor if the mouse is over the link.
  // the 'hover' variable reduces the number of times fl_cursor()
  // needs to be called (since it can be expensive).

  if (Fl::event_inside(x()+labelSize[0], y()+labelSize[1], labelSize[2], labelSize[3]))
  {
    if (! hover)
      fl_cursor(FL_CURSOR_HAND);

    hover = true;
  }
  else
  {
    if (hover)
      fl_cursor(FL_CURSOR_DEFAULT);

    hover = false;
  }
}


int UI_HyperLink::handle(int event)
{
  if (!active_r())
    return Fl_Button::handle(event);

  switch (event)
  {
    case FL_MOVE:
    {
      checkLink();
      return 1;
    }

    case FL_ENTER:
    {
      checkLink();
      redraw();
      return 1;
    }
    break;

    case FL_LEAVE:
    {
      checkLink();
      redraw();
      return 1;
    }

    default:
      break;
  }

  return Fl_Button::handle(event);
}


void UI_HyperLink::draw()
{
  if (type() == FL_HIDDEN_BUTTON)
    return;

  // draw the link text

  fl_draw_box(box(), x(), y(), w(), h(), color());
  labelSize[0] = labelSize[1] = labelSize[2] = labelSize[3] = 0;
  fl_font(labelfont(), labelsize());
  fl_measure(label(), labelSize[2], labelSize[3], 1);

  labelSize[0] += 2;
  labelSize[1] += h()/2 - labelsize()/2 - 2;

  fl_color(labelcolor());
  fl_draw(label(), x()+labelSize[0], y()+labelSize[1],
      labelSize[2], labelSize[3], FL_ALIGN_LEFT);

  // draw the underline

  if (! value())
  {
    fl_line_style(FL_SOLID);
    fl_line(x()+labelSize[0], y()+labelSize[1]+labelSize[3]-2,
        x()+labelSize[0]+labelSize[2], y()+labelSize[1]+labelSize[3]-2);
    fl_line_style(0);
  }

/*
  if (Fl::focus() == this)
    draw_focus();
*/
}

