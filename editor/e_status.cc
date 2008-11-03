//------------------------------------------------------------------------
//  Status Bar
//------------------------------------------------------------------------
//
//  RTS Layout Tool (C) 2007 Andrew Apted
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


//
// Constructor
//
W_Status::W_Status(int X, int Y, int W, int H, const char *label) : 
    Fl_Group(X, Y, W, H, label)
{
  end();  // cancel begin() in Fl_Group constructor

  box(FL_FLAT_BOX);


  line_pos = new Fl_Output(X+28,       Y+2, 64, H-4, "lin");
   col_pos = new Fl_Output(X+28+72+10, Y+2, 64, H-4, "col");

  line_pos->align(FL_ALIGN_LEFT);
   col_pos->align(FL_ALIGN_LEFT);

  add(line_pos);
  add( col_pos);

  X = col_pos->x() + col_pos->w() + 12;


  // ---- resizable ----
 

}

//
// Destructor
//
W_Status::~W_Status()
{
}

int W_Status::handle(int event)
{
  return Fl_Group::handle(event);
}


void W_Status::SetPos(int line, int col)
{
  char line_buffer[60];
  char col_buffer[60];

  sprintf(line_buffer, "%d", line);
  sprintf( col_buffer, "%d", col);

  line_pos->value(line_buffer);
   col_pos->value( col_buffer);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
