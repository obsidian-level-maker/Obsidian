//----------------------------------------------------------------
//  Remember Choice widget
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
#include "hdr_ui.h"

#include "lib_util.h"


UI_RChoice::UI_RChoice(int x, int y, int w, int h, const char *label) :
    Fl_Choice(x, y, w, h, label),
    opt_list()
{ }


UI_RChoice::~UI_RChoice()
{
  for (unsigned int i = 0; i < opt_list.size(); i++)
  {
    delete opt_list[i];
  }
}


void UI_RChoice::AddPair(const char *id, const char *label)
{
  option_data_c *opt = FindID(id);

  if (opt)
  {
    StringFree(opt->label);
    opt->label = StringDup(label);

    if (opt->shown)
      Recreate();
  }
  else
  {
    opt = new option_data_c(id, label, 0);

    opt_list.push_back(opt);

    // no need to call Recreate() here since new pairs are always
    // hidden (shown == 0)
  }
}


bool UI_RChoice::ShowOrHide(const char *id, int new_shown)
{
  SYS_ASSERT(id);

  option_data_c *P = FindID(id);

  if (! P)
    return false;

  if (P->shown != new_shown)
  {
    P->shown = new_shown;
    Recreate();
  }

  return true;
}


const char *UI_RChoice::GetID() const
{
  option_data_c *P = FindMapped();

  return P ? P->id : "";
}

const char *UI_RChoice::GetLabel() const
{
  option_data_c *P = FindMapped();

  return P ? P->label : "";
}


bool UI_RChoice::SetID(const char *id)
{
  SYS_ASSERT(id);

  option_data_c *P = FindID(id);

  if (! P || P->mapped < 0)
    return false;

  value(P->mapped);

  return true;
}


//----------------------------------------------------------------


void UI_RChoice::Recreate()
{
  // recreate the choice list

  option_data_c *LAST = FindMapped();

  clear();

  for (unsigned int j = 0; j < opt_list.size(); j++)
  {
    option_data_c *P = opt_list[j];

    if (P->shown <= 0)
    {
      P->mapped = -1;
      continue;
    }

    P->mapped = add(P->label, 0, 0, 0, 0);
  }

  // update the currently selected choice

  if (LAST && LAST->mapped >= 0)
  {
    value(LAST->mapped);
    return;
  }

  value(0);
}


option_data_c * UI_RChoice::FindID(const char *id) const
{
  for (unsigned int j = 0; j < opt_list.size(); j++)
  {
    option_data_c *P = opt_list[j];
    
    if (strcmp(P->id, id) == 0)
      return P;
  }

  return NULL;
}
 
 
option_data_c * UI_RChoice::FindMapped() const
{
  for (unsigned int j = 0; j < opt_list.size(); j++)
  {
    option_data_c *P = opt_list[j];

    if (P->mapped >= 0 && P->mapped == value())
      return P;
  }

  return NULL;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
