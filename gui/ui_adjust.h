//------------------------------------------------------------------------
//  Adjustment screen
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

#ifndef __UI_ADJUST_H__
#define __UI_ADJUST_H__

class UI_Adjust : public Fl_Group
{
private:
  Fl_Choice *size;
  Fl_Choice *detail;

  Fl_Choice *mons;
  Fl_Choice *puzzles;
  Fl_Choice *traps;

  Fl_Choice *health;
  Fl_Choice *ammo;

public:
  UI_Adjust(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Adjust();

public:

  void Locked(bool value);
  void UpdateLabels(const char *game, const char *mode);

  const char *get_Size();
  const char *get_Puzzles();
  const char *get_Traps();

  const char *get_Monsters();
  const char *get_Health();
  const char *get_Ammo();

  bool set_Size(const char *str);
  bool set_Puzzles(const char *str);
  bool set_Traps(const char *str);

  bool set_Monsters(const char *str);
  bool set_Health(const char *str);
  bool set_Ammo(const char *str);

private:
  static const char *adjust_syms[3];
  static const char *size_syms[3];

  int FindSym(const char *str);
};

#endif /* __UI_ADJUST_H__ */
