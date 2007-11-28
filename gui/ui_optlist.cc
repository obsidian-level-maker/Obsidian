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


option_data_c::option_data_c(const char *_id, const char *_desc,
                             int _pri, int _val) :
    shown(0), value(_val), priority(_pri)
{
  id   = StringDup(_id);
  desc = StringDup(_desc);
}
 
option_data_c::~option_data_c()
{
  if (id)   StringFree(id);
  if (desc) StringFree(desc);
}


//----------------------------------------------------------------


UI_OptionList::UI_OptionList(int x, int y, int w, int h, const char *label) :
    Fl_Scroll(x, y, w, h, label),
    opt_list()
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


void UI_OptionList::AddOption(const char *id, const char *desc,
                              int pri, int val)
{
  // FIXME
}

bool UI_OptionList::SetOption(const char *id, int value)
{
  option_data_c *opt = FindOption(id);

  if (! opt)
    return false;

  opt->value = value;

  return true;
}

bool UI_OptionList::ShowOption(const char *id, int shown)
{
  option_data_c *opt = FindOption(id);

  if (! opt)
    return false;

  opt->shown = shown;

  return true;
}

void UI_OptionList::IterateOptions(option_iter_f func, void *data)
{
  for (unsigned int i = 0; i < opt_list.size(); i++)
  {
    option_data_c *opt = opt_list[i];

    (* func)(opt, data);
  }
}


option_data_c *UI_OptionList::FindOption(const char *id)
{
  for (unsigned int i = 0; i < opt_list.size(); i++)
  {
    option_data_c *opt = opt_list[i];
    
    if (strcmp(opt->id, id) == 0)
      return opt;
  }

  return NULL; // not found
}
  
void UI_OptionList::BuildPack()
{
  // FIXME
}

