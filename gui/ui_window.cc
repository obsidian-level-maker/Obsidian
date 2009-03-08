//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2009 Andrew Apted
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

#define MIN_WINDOW_W  (640-12)
#define MIN_WINDOW_H  (480-56)

// not resizable!
#define MAX_WINDOW_W  MIN_WINDOW_W
#define MAX_WINDOW_H  MIN_WINDOW_H


static void main_win_close_CB(Fl_Widget *w, void *data)
{
  if (main_win)
    main_win->action = UI_MainWin::QUIT;
}


//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(const char *title) :
    Fl_Double_Window(MIN_WINDOW_W, MIN_WINDOW_H, title),
    action(UI_MainWin::NONE)
{
  end(); // cancel begin() in Fl_Group constructor

  size_range(MIN_WINDOW_W, MIN_WINDOW_H, MAX_WINDOW_W, MAX_WINDOW_H);

  callback((Fl_Callback *) main_win_close_CB);

  color(WINDOW_BG, WINDOW_BG);


  int GAME_W = 212;
  int LEV_W  = 204;
  int PLAY_W = 204;
  
  int BUILD_W = 256;
  int MOD_W   = w() - BUILD_W - 4;

  int TOP_H = 214;
  int BOT_H = h() - TOP_H - 4;

  game_box = new UI_Game(0, 0, GAME_W, TOP_H);
  add(game_box);

  level_box = new UI_Level(GAME_W+4, 0, LEV_W, TOP_H);
  add(level_box);

  play_box = new UI_Play(w() - PLAY_W, 0, PLAY_W, TOP_H);
  add(play_box);


  build_box = new UI_Build(0, h() - BOT_H, BUILD_W, BOT_H);
  add(build_box);

  mod_box = new UI_CustomMods(w() - MOD_W, h() - BOT_H, MOD_W, BOT_H);
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
