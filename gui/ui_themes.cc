//----------------------------------------------------------------
//  Theme list
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
#include "ui_themes.h"
#include "ui_window.h"

#include "lib_util.h"


//
// Themes Constructor
//
UI_Themes::UI_Themes(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);


  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Theme Selection");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;


  opts = new UI_OptionList(x+4, cy, w-8, y+h-4 - cy); 

  add(opts);
  
  resizable(opts);


  opts->AddOption("tnt", "Tech");
  opts->AddOption("plu", "Industrial");
  opts->AddOption("etn", "Hell");
  opts->AddOption("qdm", "Nature");
  opts->AddOption("foo", "Foo Bar 3000");
  opts->AddOption("xxx", "X-Men X-Treme");

  opts->Commit(UI_OptionList::CF_OPTION);

  opts->ShowOption("tnt", 1);
  opts->ShowOption("plu", 1);
  opts->ShowOption("etn", 1);
  opts->ShowOption("qdm", 1);
  opts->ShowOption("foo", 0);
  opts->ShowOption("xxx", 0);

  opts->Commit(UI_OptionList::CF_VALUE);
}


//
// Themes Destructor
//
UI_Themes::~UI_Themes()
{
}


void UI_Themes::bump_callback(Fl_Widget *w, void *data)
{
  UI_Themes *that = (UI_Themes *)data;

//  that->BumpSeed();
}


void UI_Themes::Locked(bool value)
{
  if (value)
  {
    opts->deactivate();
  }
  else
  {
    opts->activate();
  }
}

