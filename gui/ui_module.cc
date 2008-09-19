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


#define MY_PURPLE  fl_rgb_color(208,0,208)


UI_Module::UI_Module(int x, int y, int w, int h,
                     const char *id, const char *label) :
    Fl_Group(x, y, w, h),
    mod_id(id),
    choice_map()
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_SHADOW_BOX);

  resizable(NULL);


  enabler = new Fl_Check_Button(x, y+4, w, 24, label);

  add(enabler);

  // enabler->hide()


#if 0

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Custom Options");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

#endif
}


UI_Module::~UI_Module()
{
}


void UI_Module::AddOption(const char *id, const char *label, const char *choices)
{
  int nh = 28;
  int ny = y() + children() * nh;

  // FIXME: make label with ': ' suffixed

fprintf(stderr, "AddOption: x, y = %d,%d\n", x(), y());
  UI_RChoice *rch = new UI_RChoice(x() + 140, ny, 120, 24, label);

  rch->align(FL_ALIGN_LEFT);
  rch->selection_color(MY_PURPLE);

  add(rch);

  choice_map[id] = rch;
  

  rch->AddPair("foo", "Foo");
  rch->AddPair("bar", "Bar");
  rch->AddPair("jim", "Jimmy");

  rch->ShowOrHide("foo", 1);
  rch->ShowOrHide("bar", 1);
  rch->ShowOrHide("jim", 1);

  rch->redraw();

  redraw();
}


//----------------------------------------------------------------


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


  scroller = new Fl_Scroll(x+4, cy, w-4, y+h - cy);
  scroller->end();
  scroller->type(Fl_Scroll::VERTICAL_ALWAYS);
  scroller->color(BUILD_BG);
///---  scroller->scrollbar.align(FL_ALIGN_LEFT | FL_ALIGN_BOTTOM);

///!!!  opts->callback2(callback_Module, this);

  add(scroller);

  
  mods = new Fl_Pack(scroller->x(), scroller->y(), scroller->w()-20, scroller->h());
  mods->end();
  mods->spacing(2);

//scroller->color(FL_BLACK);

  scroller->add(mods);


//  resizable(scroller);
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


void UI_ModBox::AddModule(const char *id, const char *label)
{
  UI_Module *new_mod = new UI_Module(x(), y(), 260, 120, id, label);

  mods->add(new_mod);


  new_mod->AddOption("a", "One: ", "Bleh");
  new_mod->AddOption("b", "Two: ", "Bleh");
  new_mod->AddOption("c", "Three: ", "Bleh");
//  new_mod->AddOption("d", "Foundation: ", "Bleh");


  new_mod->redraw();
  mods->redraw();
  scroller->redraw();
}


void UI_ModBox::Locked(bool value)
{
  if (value)
  {
    mods->deactivate();
  }
  else
  {
    mods->activate();
  }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
