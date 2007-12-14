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
  return (StringCaseCmp(id,    other->id)    == 0) &&
         (StringCaseCmp(label, other->label) == 0);
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

  updating = false;

  if (ListsEqual())
  {
    KillList(new_list);
    return;
  }

  // remember the id and label of current entry

  const char *cur_id  = StringDup(GetID());
  const char *cur_lab = StringDup(GetLabel());


  // transfer new list to old (emptying the new list)
  
  clear();

  KillList(id_list);

  for (unsigned int j = 0; j < new_list.size(); j++)
  {
    remember_pair_c *pair = new_list[j];

    id_list.push_back(pair);
    new_list[j] = NULL;

    add(pair->label, 0, 0, 0, 0);
  }

  new_list.clear();


  // update the currently selected choice

  if (cur_lab[0] && SetLabel(cur_lab))
  { /* OK */ }
  else if (cur_id[0] && SetID(cur_id))
  { /* OK */ }
  else
  {
    value(0);
  }

  StringFree(cur_id);
  StringFree(cur_lab);
}

const char *UI_RChoice::GetID() const
{
  if (size() <= 1)
    return "";
      
  SYS_ASSERT(value() >= 0);
  SYS_ASSERT(value() < (int)id_list.size());

  return id_list[value()]->id;
}

const char *UI_RChoice::GetLabel() const
{
  if (size() <= 1)
    return "";

  SYS_ASSERT(value() >= 0);
  SYS_ASSERT(value() < (int)id_list.size());

  return id_list[value()]->label;
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

bool UI_RChoice::SetLabel(const char *lab)
{
  int index = FindLabel(lab);

  if (index < 0)
    return false;

  SYS_ASSERT(index < (int)id_list.size());

  value(index);

  return true;
}


//----------------------------------------------------------------

int UI_RChoice::FindID(const char *id) const
{
  for (unsigned int i = 0; i < id_list.size(); i++)
  {
    remember_pair_c *pair = id_list[i];
    
    if (strcmp(pair->id, id) == 0)
      return (int)i;
  }

  return -1; // not found
}
 
int UI_RChoice::FindLabel(const char *lab) const
{
  for (unsigned int i = 0; i < id_list.size(); i++)
  {
    remember_pair_c *pair = id_list[i];
    
    if (strcmp(pair->label, lab) == 0)
      return (int)i;
  }

  return -1; // not found
}
 
bool UI_RChoice::ListsEqual() const
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

void UI_RChoice::KillList(std::vector<remember_pair_c *> &list)
{
  for (unsigned int i = 0; i < list.size(); i++)
  {
    delete list[i]; list[i] = NULL;
  }

  list.clear();
}

