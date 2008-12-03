//------------------------------------------------------------------------
//  Main Window
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

#ifndef __UI_WINDOW_H__
#define __UI_WINDOW_H__


#define WINDOW_BG  fl_gray_ramp(3)

#define BUILD_BG   fl_gray_ramp(4)


class UI_MainWin : public Fl_Double_Window
{
public:
  // main child widgets

  UI_Game   *game_box;
  UI_Level  *level_box;
  UI_Play   *play_box;

  UI_Build  *build_box;
  UI_CustomMods *mod_box;

  enum  // actions
  {
    NONE = 0,
    BUILD,
    ABORT,
    QUIT
  };
  
  int action;

public:
  UI_MainWin(const char *title);
  virtual ~UI_MainWin();

  void Locked(bool value);
};

extern UI_MainWin * main_win;


#endif /* __UI_WINDOW_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
