//------------------------------------------------------------------------
//  Custom Mod list
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

#ifndef __UI_MODS_H__
#define __UI_MODS_H__


class UI_Module : public Fl_Group
{
private:
  std::string mod_id;

  Fl_Check_Button *enabler;  

  std::map<std::string, UI_RChoice *> choice_map;

public:
  UI_Module(int x, int y, int w, int h, const char *id, const char *label);
  virtual ~UI_Module();

  void AddOption(const char *id, const char *label, const char *choices);

public:

};


class UI_ModBox : public Fl_Group
{
private:
  Fl_Pack   *mods;
  Fl_Scroll *scroller;

public:
  UI_ModBox(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_ModBox();

public:
  void AddModule(const char *id, const char *label);

  void Locked(bool value);

  
private:
  static void callback_Module(option_data_c *, void *);

};


#endif /* __UI_MODS_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
