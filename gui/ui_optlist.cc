//----------------------------------------------------------------
//  Option list widget
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

#include "ui_optlist.h"
#include "ui_window.h"

#include "lib_util.h"


UI_OptionList::UI_OptionList(int x, int y, int w, int h, const char *label) :
    Fl_Scroll(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
//  box(FL_THIN_UP_BOX);

  type(Fl_Scroll::VERTICAL_ALWAYS);
  

Fl_Box *
  pack = new Fl_Box(x, y, 600, 600);
//  pack->end();
  pack->box(FL_THIN_UP_BOX);
  pack->color(FL_RED);


  add(pack);
}


UI_OptionList::~UI_OptionList()
{
}

