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
    Fl_Group(X, Y, W, H, label),
    cur_line(-1), cur_col(-1)
{
  end();  // cancel begin() in Fl_Group constructor

  box(FL_FLAT_BOX);

  
  int cx = X + 4;


  line_box = new Fl_Box(FL_FLAT_BOX, cx, Y, 80, H, "Line:");
  line_box->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT);
  add(line_box);

  cx = cx + line_box->w() + 8;


  column_box = new Fl_Box(FL_FLAT_BOX, cx, Y, 80, H, "Col:");
  column_box->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT);
  add(column_box);


  resizable(NULL);
}

//
// Destructor
//
W_Status::~W_Status()
{ }


void W_Status::SetPos(int line, int col)
{
  if (line == cur_line && col == cur_col)
    return;

  cur_line = line;
  cur_col  = col;

  char line_buffer[60];
  char col_buffer[60];

  sprintf(line_buffer, "Line:%d", line);
  sprintf( col_buffer,  "Col:%d", col);

    line_box->label(line_buffer);
  column_box->label( col_buffer);
}


void W_Status::ShowError(const char *msg)
{
  // TODO
}

void W_Status::ClearError()
{
  // TODO
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
