//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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


#ifdef RANDOMIZER
# define MIN_WINDOW_W  200
# define MIN_WINDOW_H  488
#else
# define MIN_WINDOW_W  428
# define MIN_WINDOW_H  432
#endif


UI_MainWin *main_win;

int KF = 0;


static void main_win_close_CB(Fl_Widget *w, void *data)
{
  if (main_win)
    main_win->action = UI_MainWin::QUIT;
}


//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(int W, int H, const char *title) :
    Fl_Double_Window(W, H, title),
    action(UI_MainWin::NONE)
{
  end(); // cancel begin() in Fl_Group constructor

  // not resizable!
  size_range(W, H, W, H);

  callback((Fl_Callback *) main_win_close_CB);

  color(WINDOW_BG, WINDOW_BG);

  int PANEL_W = 212 + KF*32;

#ifdef RANDOMIZER
  int TOP_H  = 104 + KF*22;
  int FIL_H  = 36;
  int BOT_H  = H - TOP_H - FIL_H - 8;
  int MOD_W  = W - PANEL_W - 4;
#else
  int TOP_H  = 214 + KF*22;
  int BOT_H  = H - TOP_H - 4;
  int MOD_W  = W - PANEL_W*2 - 8;
  int FIL_H  = 0;
#endif

  game_box = new UI_Game(0, 0, PANEL_W, TOP_H);
  add(game_box);

#ifndef RANDOMIZER
  level_box = new UI_Level(PANEL_W+4, 0, PANEL_W, TOP_H);
  add(level_box);

  play_box = new UI_Play(PANEL_W+4, TOP_H+4, PANEL_W, BOT_H);
  add(play_box);
#endif


  build_box = new UI_Build(0, TOP_H+4, PANEL_W, BOT_H);
  add(build_box);


  mod_box = new UI_CustomMods(W - MOD_W, 0, MOD_W, TOP_H+4 + BOT_H);
  add(mod_box);


#ifdef RANDOMIZER
  Fl_Group * infile_box = new Fl_Group(0, H - FIL_H, W, FIL_H);
  infile_box->end();
  infile_box->box(FL_THIN_UP_BOX);
  infile_box->color(BUILD_BG, BUILD_BG);

  Fl_Output * ff_name = new Fl_Output(114, H-FIL_H+7, W-118, FIL_H-14, "Current File: ");
  ff_name->align(FL_ALIGN_LEFT);
  ff_name->selection_color(FL_BLUE);
  ff_name->value("C:\\foobie\\DOOM2.WAD");

  infile_box->add(ff_name);

  add(infile_box);
#endif


  resizable(NULL);
}

//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{ }



void UI_MainWin::CalcWindowSize(bool hide_modules, int *W, int *H)
{
  *W = MIN_WINDOW_W + KF * 64;
  *H = MIN_WINDOW_H + KF * 44;
  
  if (! hide_modules)
    *W += 304 + KF * 32;
}


void UI_MainWin::Locked(bool value)
{
  game_box ->Locked(value);
#ifndef RANDOMIZER
  level_box->Locked(value);
  play_box ->Locked(value);
#endif
  build_box->Locked(value);
  mod_box  ->Locked(value);
}


void UI_MainWin::HideModules(bool hide)
{
  int new_w, new_h;
  CalcWindowSize(hide, &new_w, &new_h);

  if (hide)
  {
    mod_box->hide();
    mod_box->position(0, 0);

    size(new_w, new_h);
  }
  else
  {
    size(new_w, new_h);

    mod_box->position(w() - mod_box->w(), 0);
    mod_box->show();
  }

  redraw();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
