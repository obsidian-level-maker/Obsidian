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


bool remember_pair_c::Equal(const remember_pair_c *other) const
{
  return (StrCaseCmp(id,    other->id)    == 0) &&
         (StrCaseCmp(label, other->label) == 0);
}


//----------------------------------------------------------------


UI_RChoice::UI_RChoice(int x, int y, int w, int h, const char *label) :
    Fl_Choice(x, y, w, h, label),
    id_list(), new_list(), updating(false)
{ }


UI_RChoice::~UI_RChoice()
{ }


void UI_RChoice::BeginUpdate()
{
  // ??

  updating = true;
}

void UI_RChoice::AddPair(const char *id, const char *label)
{
  SYS_ASSERT(updating);
  SYS_ASSERT(id && label);

  new_list.push_back(new remember_pair_c(id, label));
}

void UI_RChoice::EndUpdate()
{
  SYS_ASSERT(updating);

  if (! ListsEqual())
  {
    // TODO
  }

  // FIXME transfer new to old, kill new
 
  updating = false;
}

const char *UI_RChoice::GetID() const
{
  SYS_ASSERT(value() >= 0);
  SYS_ASSERT(value() < (int)id_list.size());

  return id_list[value()]->id;
}

bool UI_RChoice::SetID(const char *id)
{
  int index = FindID(id);

  if (index < 0)
    return false;

  SYS_ASSERT(index < (int)id_list.size());

  value(index);

  return true;
}


//----------------------------------------------------------------

int UI_RChoice::FindID(const char *id)
{
  for (unsigned int i = 0; i < id_list.size(); i++)
  {
    remember_pair_c *pair = id_list[i];
    
    if (strcmp(pair->id, id) == 0)
      return (int)i;
  }

  return -1; // not found
}
 
bool UI_RChoice::ListsEqual()
{
  if (id_list.size() != new_list.size())
    return false;

  for (unsigned int i = 0; i < id_list.size(); i++)
  {
    remember_pair_c *p1 =  id_list[i];
    remember_pair_c *p2 = new_list[i];

    if (! p1->Equal(p2))
      return false;
  }

  return true;
}

