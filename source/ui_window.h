//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#pragma once

#include "ui_build.h"
#include "ui_game.h"
#include "ui_module.h"
#include "ui_widgets.h"

// support for scaling up the GUI
extern int KF; // Kromulent Factor : -1 .. 3

inline int KromulentWidth(int w)
{
    return ((w) + KF * (w) / (KF >= 0 ? 4 : 8));
}

inline int KromulentHeight(int h)
{
    return ((h) + KF * (h) / (KF >= 0 ? 5 : 10));
}

extern int small_font_size;
extern int header_font_size;

class UI_MainWin
{
  public:
    // main child widgets

    UI_Game *game_box;

    UI_Build *build_box;

    UI_CustomTabs *mod_tabs;

    UI_Clippy *clippy;

  public:
             UI_MainWin(int W, int H, const char *title);
    virtual ~UI_MainWin();

    static void MenuBar();

    static void CalcWindowSize(int *W, int *H);

    void Locked(bool value);

    int handle(SDL_Event event);
};

extern UI_MainWin *main_win;

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
