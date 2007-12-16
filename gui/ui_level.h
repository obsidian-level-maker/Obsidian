//------------------------------------------------------------------------
//  Level Architecture
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

#ifndef __UI_LEVEL_H__
#define __UI_LEVEL_H__

class UI_Level : public Fl_Group
{
private:
  Fl_Choice *size;

  Fl_Choice *detail;

  Fl_Choice *heights;
  Fl_Choice *yyy;

public:
  UI_RChoice *theme;


public:
  UI_Level(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Level();

public:

  void Locked(bool value);

  void TransferToLUA();
  // transfer settings from this panel into the LUA config table.
 
  const char *GetAllValues();
  // return a string containing all the values from this panel,
  // in a form suitable for the Config file.
  // The string should NOT be freed.

  bool ParseValue(const char *key, const char *value);
  // parse the name and store the value in the appropriate
  // widget.  Returns false if the key was unknown or the
  // value was invalid.

  const char *get_Size();
  const char *get_Theme();
  const char *get_Detail();
  const char *get_Heights();
//const char *get_YYY();

  bool set_Size   (const char *str);
  bool set_Theme  (const char *str);
  bool set_Detail (const char *str);
  bool set_Heights(const char *str);
//bool set_YYY(const char *str);

private:
  static const char *adjust_syms[3];
  static const char *size_syms[3];

  int FindSym(const char *str);

  static void callback_Any(Fl_Widget *, void*);
};

#endif /* __UI_LEVEL_H__ */
