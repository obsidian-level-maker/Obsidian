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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#ifndef WIN32
#include <unistd.h>
#endif

#if (FL_MAJOR_VERSION != 1 ||  \
     FL_MINOR_VERSION != 1 ||  \
     FL_PATCH_VERSION < 7)
#error "Require FLTK version 1.1.7 or later"
#endif


UI_MainWin *main_win;

#define MAIN_WINDOW_W  620
#define MAIN_WINDOW_H  432

#if 0
#define MAX_WINDOW_W  760
#define MAX_WINDOW_H  720
#else
#define MAX_WINDOW_W  MAIN_WINDOW_W
#define MAX_WINDOW_H  MAIN_WINDOW_H
#endif


static void main_win_close_CB(Fl_Widget *w, void *data)
{
  if (main_win)
    main_win->action = UI_MainWin::QUIT;
}


//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(const char *title) :
    Fl_Double_Window(MAIN_WINDOW_W, MAIN_WINDOW_H, title),
    action(UI_MainWin::NONE)
{
  end(); // cancel begin() in Fl_Group constructor

  size_range(MAIN_WINDOW_W, MAIN_WINDOW_H, MAX_WINDOW_W, MAX_WINDOW_H);

  callback((Fl_Callback *) main_win_close_CB);

  color(WINDOW_BG, WINDOW_BG);


#if 0  // EXPERIMENT: Do we NEED the menu bar ?

  /* ---- Menu bar ---- */
  {
    menu_bar = MenuCreate(0, 0, w(), 28);
    add(menu_bar);

#ifndef MACOSX
    cy += menu_bar->h();
///   cy += 8;
#endif
  }
#endif

  int LW = 212;
  int MW = 200;
  int RW = 200;

  int GAME_H  = 220;
  int ADJ_H   = GAME_H;
  int MOD_H   = GAME_H;

  game_box = new UI_Game(0, 0, LW, GAME_H);
  add(game_box);

  build_box = new UI_Build(0, GAME_H+4, LW, h()-GAME_H-4);
  add(build_box);


  level_box = new UI_Level(LW+4, 0, MW, ADJ_H);
  add(level_box);

  play_box = new UI_Play(LW+MW+8, 0, RW, ADJ_H);
  add(play_box);


  mod_box = new UI_ModBox(LW+4, GAME_H+4, w()-LW-4, h()-GAME_H-4);
  add(mod_box);


  resizable(mod_box);
}

//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{ }


void UI_MainWin::Locked(bool value)
{
  game_box ->Locked(value);
  build_box->Locked(value);
  level_box->Locked(value);
  play_box ->Locked(value);

//!!!!  mod_box   ->Locked(value);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
