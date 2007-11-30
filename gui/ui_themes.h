//------------------------------------------------------------------------
//  Play Settings
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

#ifndef __UI_PLAY_H__
#define __UI_PLAY_H__

class UI_Play : public Fl_Group
{
private:

  Fl_Choice *mons;
  Fl_Choice *puzzles;
  Fl_Choice *traps;

  Fl_Choice *health;
  Fl_Choice *ammo;

public:
  UI_Play(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Play();

public:

  void Locked(bool value);
  
  void UpdateLabels(const char *game, const char *mode);

  const char *get_Monsters();
  const char *get_Puzzles();
  const char *get_Traps();
  const char *get_Health();
  const char *get_Ammo();

  bool set_Monsters(const char *str);
  bool set_Puzzles (const char *str);
  bool set_Traps   (const char *str);
  bool set_Health  (const char *str);
  bool set_Ammo    (const char *str);

private:
  int FindSym(const char *str);

  static const char *adjust_syms[3];
};

#endif /* __UI_PLAY_H__ */
