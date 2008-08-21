//------------------------------------------------------------------------
//  Remember Choice widget
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#ifndef __UI_RCHOICE_H__
#define __UI_RCHOICE_H__

//
// DESCRIPTION:
//   A sub-classed Fl_Choice widget which remembers an 'id'
//   string associated with each selectable value, and allows
//   these ids and labels to be updated at any time.
//


class UI_RChoice : public Fl_Choice
{
private:
  std::vector<option_data_c *> opt_list;

public:
  UI_RChoice(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_RChoice();

public:
  void AddPair(const char *id, const char *label);
  // add a new option to the list.  If an option with the same 'id'
  // already exists, that option is replaced instead.
  // The option will begin with shown == 0.

  bool ShowOrHide(const char *id, int new_shown);
  // finds the option with the given ID, and update the shown
  // value.  Returns true if successful, or false if no such
  // option exists.  Any change will call Recreate().

  const char *GetID() const;
  // get the id string for the currently shown value.
  // Returns the string "none" if there are no choices.

  bool SetID(const char *id);
  // set the currently shown value via the new 'id'.  If no
  // such exists, returns false and nothing was changed.

private:
  option_data_c * FindID(const char *id) const;
  option_data_c * FindMapped() const;

  void Recreate(); ///--- option_data_c *LAST = NULL);
  // The available choices will be updated to reflect the
  // 'shown' values.  If the previous selected item is still
  // valid, it remains set, otherwise we try and find a shown
  // value with the same label, and failing that: select the
  // first entry.

  const char *GetLabel() const;  // ????
};


#endif /* __UI_RCHOICE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
