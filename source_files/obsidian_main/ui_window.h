//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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

#include "hdr_fltk.h"
#include "ui_build.h"
#include "ui_game.h"
#include "ui_module.h"

// support for scaling up the GUI
extern int KF;  // Kromulent Factor : -1 .. 3

#define kf_w(w) ((w) + KF * (w) / (KF >= 0 ? 4 : 8))
#define kf_h(h) ((h) + KF * (h) / (KF >= 0 ? 5 : 10))

extern int small_font_size;
extern int header_font_size;

class UI_MainWin : public Fl_Double_Window {
   public:
    // main child widgets

    Fl_Menu_Bar *menu_bar;

    Fl_Group *sizing_group;

    UI_Game *game_box;

    UI_Build *build_box;

    UI_CustomMods *left_mods;
    UI_CustomMods *right_mods;

   public:
    UI_MainWin(int W, int H, const char *title);
    virtual ~UI_MainWin();

    static void CalcWindowSize(int *W, int *H);

    void Locked(bool value);

   private:
    static void menu_do_about(Fl_Widget *w, void *data);
    static void menu_do_tutorial(Fl_Widget *w, void *data);
    static void menu_do_view_logs(Fl_Widget *w, void *data);
    static void menu_do_options(Fl_Widget *w, void *data);
    static void menu_do_theme(Fl_Widget *w, void *data);
    static void menu_do_addons(Fl_Widget *w, void *data);
    static void menu_do_edit_seed(Fl_Widget *w, void *data);
    static void menu_do_manage_config(Fl_Widget *w, void *data);
};

extern UI_MainWin *main_win;

#endif /* __UI_WINDOW_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
