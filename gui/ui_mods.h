//------------------------------------------------------------------------
//  Custom Mod list
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

#ifndef __UI_MODS_H__
#define __UI_MODS_H__

class UI_Mods : public Fl_Group
{
public: /// private:

  UI_OptionList *opts;

public:
  UI_Mods(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Mods();

public:

  void Locked(bool value);

  
private:
  static void callback_Module(option_data_c *, void *);

};


class UI_ModOptions : public Fl_Group
{
public: /// private:

  UI_OptionList *opts;

public:
  UI_ModOptions(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_ModOptions();

public:

  void Locked(bool value);

  
private:
  static void callback_Option(option_data_c *, void *);

};

#endif /* __UI_MODS_H__ */
