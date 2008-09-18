//----------------------------------------------------------------
//  Custom Mod list
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_util.h"

#include "g_lua.h"


UI_ModBox::UI_ModBox(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);


  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Custom Mods");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;


  opts = new UI_OptionList(x+4, cy, w-4, y+h-4 - cy);
  opts->callback2(callback_Module, this);

  add(opts);

  resizable(opts);
}


UI_ModBox::~UI_ModBox()
{
}


void UI_ModBox::callback_Module(option_data_c *opt, void *data)
{
//  UI_ModBox *that = (UI_ModBox *)data;

  DebugPrintf("UI_ModBox: callback for %s\n", opt->id);

  // TODO: make a method in option_data_c
  Script_SetConfig(opt->id, opt->widget->value() ? "true" : "false");
}


void UI_ModBox::Locked(bool value)
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


//----------------------------------------------------------------


#if 0
UI_Module::UI_Module(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);


  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Custom Options");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;


  opts = new UI_OptionList(x+4, cy, w-4, y+h-4 - cy);
  opts->callback2(callback_Option, this);

  add(opts);

  resizable(opts);
}


UI_ModOptions::~UI_ModOptions()
{
}
#endif


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
