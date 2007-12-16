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
#include "hdr_ui.h"

#include "lib_util.h"


///---remember_pair_c::remember_pair_c(const char *_id, const char *_label)
///---{
///---  id    = StringDup(_id);
///---  label = StringDup(_label);
///---}
///--- 
///---remember_pair_c::~remember_pair_c()
///---{
///---  if (id)    StringFree(id);
///---  if (label) StringFree(label);
///---}
///---
///---
///---bool remember_pair_c::Equal(const remember_pair_c *other) const
///---{
///---  return (StringCaseCmp(id,    other->id)    == 0) &&
///---         (StringCaseCmp(label, other->label) == 0);
///---}


//----------------------------------------------------------------


UI_RChoice::UI_RChoice(int x, int y, int w, int h, const char *label) :
    Fl_Choice(x, y, w, h, label),
    opt_list(), updating(false), modified(false)
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

    opt->shown = 1; //!!!!
    opt->value = 0;
  }
  else
  {
DebugPrintf("AddPair(%s, %s)\n", id, label);
    opt = new option_data_c(id, label, 50, 1);

    opt_list.push_back(opt);
  }
}


void UI_RChoice::BeginUpdate()
{
  updating = true;
  modified = false;
}

bool UI_RChoice::ShowOrHide(const char *id, int new_shown)
{
  SYS_ASSERT(id);
  SYS_ASSERT(updating);

  option_data_c *P = FindID(id);

  if (! P)
    return false;

  if (P->shown != new_shown)
  {
    P->shown = new_shown;
    modified = true;
  }

  return true;
}

bool UI_RChoice::EndUpdate()
{
  SYS_ASSERT(updating);

  updating = false;

  if (! modified)
    return false;

  Recreate(FindMapped());

  return true;
}

void UI_RChoice::Recreate(option_data_c *LAST)
{
  // recreate the choice list

  clear();

  int map_index = 0;
  
  for (unsigned int j = 0; j < opt_list.size(); j++)
  {
    option_data_c *P = opt_list[j];

    if (P->shown <= 0)
      P->mapped = -1;
    else
      P->mapped = map_index++;

DebugPrintf("EndUpdate: adding: %s\n", P->label);
    add(P->label, 0, 0, 0, 0);
  }


  // update the currently selected choice

  if (! LAST)
  {
    value(0);
    return;
  }

  if (LAST->mapped >= 0)
  {
    // OK it is still shown, but index may have changed
    value(LAST->mapped);
    return;
  }

  for (unsigned int j = 0; j < opt_list.size(); j++)
  {
    option_data_c *P = opt_list[j];

    if (P->mapped < 0)
      continue;

    if (StringCaseCmp(P->label, LAST->label) == 0)
    {
      // found equivalent entry
      value(P->mapped);
      break;
    }
  }

  value(0);
 
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

#if 0 // NEEDED ???
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
#endif


//----------------------------------------------------------------

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
 
#if 0  // NEEDED ???
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
#endif
 
option_data_c * UI_RChoice::FindMapped() const
{
  for (unsigned int j = 0; j < opt_list.size(); j++)
  {
    option_data_c *P = opt_list[j];

    if (P->mapped == value())
      return P;
  }

  return NULL;
}

///--- bool UI_RChoice::ListsEqual() const
///--- {
///---   if (id_list.size() != new_list.size())
///---     return false;
///--- 
///---   for (unsigned int i = 0; i < id_list.size(); i++)
///---   {
///---     remember_pair_c *p1 =  id_list[i];
///---     remember_pair_c *p2 = new_list[i];
///--- 
///---     if (! p1->Equal(p2))
///---       return false;
///---   }
///--- 
///---   return true;
///--- }
///--- 
///--- void UI_RChoice::KillList(std::vector<remember_pair_c *> &list)
///--- {
///---   for (unsigned int i = 0; i < list.size(); i++)
///---   {
///---     delete list[i]; list[i] = NULL;
///---   }
///--- 
///---   list.clear();
///--- }

