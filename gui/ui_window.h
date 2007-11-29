//------------------------------------------------------------------------
//  Main Window
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

#ifndef __UI_WINDOW_H__
#define __UI_WINDOW_H__

#include "ui_map.h"
#include "ui_build.h"
#include "ui_menu.h"
#include "ui_optlist.h"
#include "ui_mods.h"
#include "ui_setup.h"
#include "ui_themes.h"
#include "ui_adjust.h"

#define MAIN_BG_COLOR  fl_gray_ramp(FL_NUM_GRAY * 3 / 24)


class UI_MainWin : public Fl_Double_Window
{
public:
  // main child widgets

#ifdef MACOSX
  Fl_Sys_Menu_Bar *menu_bar;
#else
  Fl_Menu_Bar *menu_bar;
#endif

  UI_Setup *setup_box;
  UI_Mods  *mod_box;

  UI_Adjust *adjust_box;
  UI_ModOptions *option_box;

  UI_Themes *theme_box;
  UI_Build  *build_box;

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
