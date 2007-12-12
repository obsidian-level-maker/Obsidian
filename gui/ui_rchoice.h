//------------------------------------------------------------------------
//  Remember Choice widget
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#ifndef __UI_RCHOICE_H__
#define __UI_RCHOICE_H__

//
// DESCRIPTION:
//   Sub-classesed Fl_Choice widget which remembers an 'id'
//   string associated with each selectable value, and allows
//   these ids and labels to be updated at any time.
//

class remember_pair_c
{
public:
  const char *id;     // terse identifier
  const char *label;  // description (for the UI)
  
public:
  remember_pair_c() : id(NULL), label(NULL)
  { }

  remember_pair_c(const char *_id, const char *_label);

  ~remember_pair_c();

public:
  bool Equal(const remember_pair_c *other) const;
};


class UI_RChoice : public Fl_Choice
{
private:

  std::vector<remember_pair_c *> id_list;

  std::vector<remember_pair_c *> new_list;

  bool updating;

public:
  UI_RChoice(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_RChoice();

public:
  void BeginUpdate();
  // begin an update session.

  void AddPair(const char *id, const char *label);
  // add a new id/label pair to the list.

  void EndUpdate();
  // end the current update session.  If the old selected value
  // still exists (check label first, id second) then that will
  // become the new selected value, regardless of number of
  // entries or their ordering.  If it doesn't exist, the first
  // entry is used.  Nothing happens if the new list is exactly
  // the same as the old list.

  const char *GetID() const;
  // get the id string for the currently shown value.

  bool SetID(const char *id);
  // set the currently shown value via the new 'id'.  If no
  // such exists, returns false and nothing was changed.
  
private:
  int FindID(const char *id);

  bool ListsEqual();
  // returns true if the old and new lists are identical.

};


#endif /* __UI_RCHOICE_H__ */
