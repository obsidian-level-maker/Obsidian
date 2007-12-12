//----------------------------------------------------------------
//  Remember Choice widget
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

#include "ui_rchoice.h"
#include "ui_window.h"

#include "lib_util.h"


remember_pair_c::remember_pair_c(const char *_id, const char *_label)
{
  id    = StringDup(_id);
  label = StringDup(_label);
}
 
remember_pair_c::~remember_pair_c()
{
  if (id)    StringFree(id);
  if (label) StringFree(label);
}


//----------------------------------------------------------------


UI_RChoice::UI_RChoice(int x, int y, int w, int h, const char *label) :
    Fl_Choice(x, y, w, h, label),
    id_list(), new_list(), updating(false)
{ }


UI_RChoice::~UI_RChoice()
{ }


void UI_RChoice::AddPair(const char *id, const char *label)
{
  option_data_c *opt = FindOption(id);

  if (opt)
  {
    StringFree(opt->desc);
    opt->desc = StringDup(desc);

    opt->shown = 0;
    opt->value = val;
    opt->priority = pri;

    opt->widget->label(opt->desc);
  }
  else
  {
    opt = new option_data_c(id, desc, pri, val);

    opt->widget = new Fl_Check_Button(0, 0, 20, 20, opt->desc);
    opt->widget->box(FL_UP_BOX);

    opt_list.push_back(opt);
  }
}


remember_pair_c *UI_RChoice::FindPair(const char *id)
{
  for (unsigned int i = 0; i < id_list.size(); i++)
  {
    remember_pair_c *pair = id_list[i];
    
    if (strcmp(pair->id, id) == 0)
      return pair;
  }

  return NULL; // not found
}
 
