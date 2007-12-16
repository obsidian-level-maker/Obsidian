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
#include "hdr_ui.h"

#include "lib_util.h"


#define BUTTON_H  24
#define GAP_H     1
#define GAP_W     1

#define LIST_BG   BUILD_BG


option_data_c::option_data_c(const char *_id, const char *_label, int _val) :
    shown(1), value(_val), widget(NULL), mapped(-1)
{
  id    = StringDup(_id);
  label = StringDup(_label);
}
 
option_data_c::~option_data_c()
{
  if (id)    StringFree(id);
  if (label) StringFree(label);

  // ignore 'widget' field when shown, assuming it exists in
  // an Fl_Group and hence FLTK will take care to delete it.
  if (shown == 0)
    delete widget;
}

bool option_data_c::Equal(const option_data_c& other) const
{
  return (StringCaseCmp(id,    other.id)    == 0) &&
         (StringCaseCmp(label, other.label) == 0);
}


//----------------------------------------------------------------


UI_OptionList::UI_OptionList(int x, int y, int w, int h, const char *label) :
    Fl_Scroll(x, y, w, h, label),
    opt_list(), cb_func(NULL), cb_data(NULL)
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


void UI_OptionList::callback2(option_callback_f func, void *priv_dat)
{
  cb_func = func;
  cb_data = priv_dat;
}


void UI_OptionList::AddPair(const char *id, const char *label, int val)
{
  option_data_c *opt = FindOption(id);

DebugPrintf("UI_OptionList::AddPair(%s,%s) %s\n", id, label, opt ? "EXIST" : "new");
  if (opt)
  {
    StringFree(opt->label);
    opt->label = StringDup(label);

    opt->shown = 1;  //!!!!!!
    opt->value = val;

    opt->widget->label(opt->label);
  }
  else
  {
    opt = new option_data_c(id, label, val);

    opt->widget = new Fl_Check_Button(0, 0, 20, 20, opt->label);
    opt->widget->box(FL_UP_BOX);
    opt->widget->callback(callback_Widget, this);

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

void UI_OptionList::BeginUpdate()
{
  // updating = true;
}

bool UI_OptionList::ShowOrHide(const char *id, int shown)
{
  option_data_c *opt = FindOption(id);

  if (! opt)
    return false;

  opt->shown = shown;

  return true;
}

void UI_OptionList::EndUpdate()
{
  // updating = false;
  // if (! modified)
  //   return;

  Commit();
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
  // FIXME: visit in correct order (shown)

  int cy = y();

DebugPrintf("UI_OptionList::Commit begun\n");
  for (unsigned int i = 0; i < opt_list.size(); i++)
  {
    option_data_c *opt = opt_list[i];

    Fl_Check_Button *button = opt->widget;

DebugPrintf("UI_OptionList::Commit [%d] shown:%d inside:%d\n",
i, (opt->shown ? 1 : 0), (button->inside(this) ? 1 : 0));

    if ((opt->shown ? 1 : 0) != (button->inside(this) ? 1 : 0))
    {
DebugPrintf("UI_OptionList::Commit changing [%d]\n", i);
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
 

void UI_OptionList::callback_Widget(Fl_Widget *w, void *data)
{
  UI_OptionList *that = (UI_OptionList *)data;
  SYS_ASSERT(that);

  if (! that->cb_func)
    return;

  for (unsigned int i = 0; i < that->opt_list.size(); i++)
  {
    option_data_c *opt = that->opt_list[i];
  
    if (opt->widget == w)
    {
      (* that->cb_func)(opt, that->cb_data);
      return;
    }
  }      

  DebugPrintf("UI_OptionList::callback_Widget: cannot find widget %p\n", w);
}

