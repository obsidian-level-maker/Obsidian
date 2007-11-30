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


#define BUTTON_H  24
#define GAP_H     1
#define GAP_W     1

#define LIST_BG   BUILD_BG


option_data_c::option_data_c(const char *_id, const char *_desc,
                             int _pri, int _val) :
    shown(0), value(_val), priority(_pri), widget(NULL)
{
  id   = StringDup(_id);
  desc = StringDup(_desc);
}
 
option_data_c::~option_data_c()
{
  if (id)   StringFree(id);
  if (desc) StringFree(desc);

  // ignore 'widget' field when shown, assuming it exists in
  // an Fl_Group and hence FLTK will take care to delete it.
  if (shown == 0)
    delete widget;
}


//----------------------------------------------------------------


UI_OptionList::UI_OptionList(int x, int y, int w, int h, const char *label) :
    Fl_Scroll(x, y, w, h, label),
    opt_list()
{
  end(); // cancel begin() in Fl_Group constructor
 
  type(Fl_Scroll::VERTICAL_ALWAYS);
  
  color(LIST_BG);
}


UI_OptionList::~UI_OptionList()
{
  for (unsigned int i = 0; i < opt_list.size(); i++)
  {
    delete opt_list[i];
  }
}


void UI_OptionList::AddOption(const char *id, const char *desc,
                              int pri, int val)
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

void UI_OptionList::Commit()
{
  // FIXME: visit in correct order (shown + priority + alphabetical)

  int cy = y();

  for (unsigned int i = 0; i < opt_list.size(); i++)
  {
    option_data_c *opt = opt_list[i];

    Fl_Check_Button *button = opt->widget;

    if ((opt->shown ? 1 : 0) != (button->inside(this) ? 1 : 0))
    {
      if (opt->shown > 0)
        this->add(button);
      else
        this->remove(*button);
    }

    // no mucking about with off-screen widgets
    if (opt->shown == 0)
      continue;
 
    button->resize(x()+GAP_W, cy, w() - Fl::scrollbar_size()-GAP_W*2, BUTTON_H);

    cy += button->h() + GAP_H;

    if (opt->shown != (button->active() ? 1 : -1))
    {
      if (opt->shown == 1)
        button->activate();
      else
        button->deactivate();
    }

    button->value(opt->value);
  }

  this->redraw();
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
 
