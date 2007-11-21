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

#include "headers.h"
#include "hdr_fltk.h"

#include "ui_menu.h"
#include "ui_window.h"

#ifndef WIN32
#include <unistd.h>
#endif

#if (FL_MAJOR_VERSION != 1 ||  \
     FL_MINOR_VERSION != 1 ||  \
     FL_PATCH_VERSION < 7)
#error "Require FLTK version 1.1.7 or later"
#endif


UI_MainWin *main_win;

#define MAIN_WINDOW_W  600
#define MAIN_WINDOW_H  450


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

  size_range(MAIN_WINDOW_W, MAIN_WINDOW_H,
             MAIN_WINDOW_W + MAIN_WINDOW_W/2,
             MAIN_WINDOW_H * 2);

  callback((Fl_Callback *) main_win_close_CB);

  color(MAIN_BG_COLOR, MAIN_BG_COLOR);
  image(NULL);


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

  int LW = 200;
  int MW = 200;
  int RW = 200;

  int MOD_H = 200;
  int THM_H = 200;

  setup_box = new UI_Setup(0, 0, LW-4, h() - MOD_H - 4);
  add(setup_box);


  mod_box = new UI_Mods(0, h()-MOD_H, LW-4, MOD_H);
  add(mod_box);


  adjust_box = new UI_Adjust(LW, 0, MW, h());
  add(adjust_box);

 
  Fl_Widget *theme_box = new UI_Mods(LW+MW+4, 0, RW-4, THM_H - 4);
  add(theme_box);


  build_box = new UI_Build(LW+MW+4, THM_H, RW-4, h() - THM_H);
  add(build_box);


  resizable(setup_box);

  // show window (pass some dummy arguments)
  int argc = 1;
  char *argv[] = { "Oblige.exe", NULL };

  show(argc, argv);
}

//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{ }


void UI_MainWin::Locked(bool value)
{
  setup_box->Locked(value);
  adjust_box->Locked(value);
  build_box->Locked(value);
}
