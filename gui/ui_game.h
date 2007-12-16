//------------------------------------------------------------------------
//  Setup screen
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

#ifndef __UI_GAME_H__
#define __UI_GAME_H__

class UI_Game : public Fl_Group
{
private:
  Fl_Int_Input *seed;
  Fl_Button *bump;

public:
  UI_RChoice *game;
  UI_RChoice *mode;

  UI_RChoice *engine;
  UI_RChoice *length;

public:
  UI_Game(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Game();

public:

  void SetSeed(u32_t new_val);

  void FreshSeed();
  void BumpSeed();

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

  const char *get_Seed();
  const char *get_Game();
  const char *get_Mode();
  const char *get_Length();
  const char *get_Engine();
  
  bool set_Seed(const char *str);
  bool set_Game(const char *str);
  bool set_Mode(const char *str);
  bool set_Length(const char *str);
  bool set_Engine(const char *str);

  
private:
  void setup_Mode();
  void setup_Length();

  static void callback_Bump(Fl_Widget *, void*);

  static void callback_Game  (Fl_Widget *, void*);
  static void callback_Mode  (Fl_Widget *, void*);
  static void callback_Engine(Fl_Widget *, void*);
  static void callback_Length(Fl_Widget *, void*);

  static const char *mode_syms[];
  static const char *length_syms[];

};

#endif /* __UI_GAME_H__ */
