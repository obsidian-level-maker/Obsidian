//------------------------------------------------------------------------
//  About and Options Windows
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

#include "main.h"


#ifdef RANDOMIZER
# define TITLE_COLOR  FL_RED
# define INFO_COLOR   fl_color_cube(6,0,2)
#else
# define TITLE_COLOR  FL_BLUE
# define INFO_COLOR  fl_color_cube(0,6,4)
#endif


class UI_About : public Fl_Window
{
private:
  bool want_quit;

public:
  UI_About(int W, int H, const char *label = NULL);

  virtual ~UI_About()
  {
    // nothing needed
  }

  bool WantQuit() const
  {
    return want_quit;
  }

public:
  // FLTK virtual method for handling input events.
  int handle(int event)
  {
    if (event == FL_KEYDOWN || event == FL_SHORTCUT)
    {
      int key = Fl::event_key();

      if (key == FL_Escape)
      {
        want_quit = true;
        return 1;
      }
        
      // eat all other function keys
      if (FL_F+1 <= key && key <= FL_F+12)
        return 1;
    }

    return Fl_Window::handle(event);
  }

private:
  static void callback_Quit(Fl_Widget *w, void *data)
  {
    UI_About *that = (UI_About *)data;

    that->want_quit = true;
  }

  static const char *Text;
};


const char *UI_About::Text =
#ifdef RANDOMIZER
  "Randomizer is a tool to randomly replace\n"
  "monsters and items in DOOM (etc) maps.\n"
#else
  "OBLIGE is a random level generator for\n"
  "DOOM, DOOM II, Heretic and Quake\n"
#endif
  "\n"
  "Copyright (C) 2006-2010 Andrew Apted\n"
  "\n"
  "This program is free software, and may be\n"
  "distributed and modified under the terms of\n"
  "the GNU General Public License\n"
  "\n"
  "There is ABSOLUTELY NO WARRANTY\n"
  "Use at your OWN RISK";


//
// Constructor
//
UI_About::UI_About(int W, int H, const char *label) :
    Fl_Window(W, H, label),
    want_quit(false)
{
  // cancel Fl_Group's automatic add crap
  end();


  // non-resizable
  size_range(W, H, W, H);
  callback(callback_Quit, this);

  int cy = 0;

  // nice big logo text
  const char *logo_text = randomizer ? RMZ_TITLE " " RMZ_VERSION :
                                       OBLIGE_TITLE " " OBLIGE_VERSION;

  Fl_Box *box = new Fl_Box(0, cy, W, 50, logo_text);
  box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
  box->labelcolor(TITLE_COLOR);
  box->labelsize(24);
  add(box);


  cy += box->h() + 10;
  
  int pad = 12 + KF * 6;

  // the very informative text
  box = new Fl_Box(pad, cy, W-pad-pad, H-172, Text);
  box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
  box->box(FL_UP_BOX);
  box->color(INFO_COLOR);
  add(box);

  cy += box->h() + 10;


  // website address
  box = new Fl_Box(10, cy, W-20, 30, "http://oblige.sourceforge.net");
  box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
  box->labelsize(20);
  add(box);

  cy += box->h() + 10;


  SYS_ASSERT(cy < H);

  Fl_Group *darkish = new Fl_Group(0, cy, W, H-cy);
  darkish->end();
  darkish->box(FL_FLAT_BOX);
  darkish->color(BUILD_BG, BUILD_BG);
  add(darkish);

  // finally add an "OK" button
  int bw = 60 + KF * 10;
  int bh = 30 + KF * 3;

  Fl_Button *button = new Fl_Button(W-10-bw, H-10-bh, bw, bh, "OK");
  button->callback(callback_Quit, this);
  darkish->add(button);
}


void DLG_AboutText(void)
{
  static UI_About * about_window = NULL;

  if (about_window)  // already up?
    return;

  int about_w = 350 + KF * 30;
  int about_h = 370 + KF * 40;

  about_window = new UI_About(about_w, about_h, "About Box");

  about_window->show();

  // run the GUI until the user closes
  while (! about_window->WantQuit())
    Fl::wait();

  // this deletes all the child widgets too...
  delete about_window;

  about_window = NULL;
}


//////////////////////////////////////////////////////////////////////////


class UI_OptionsWin : public Fl_Window
{
private:
  bool want_quit;

  Fl_Check_Button *opt_modules;
  Fl_Check_Button *opt_backups;
  Fl_Check_Button *opt_debug;

public:
  UI_OptionsWin(int W, int H, const char *label = NULL);

  virtual ~UI_OptionsWin()
  {
    // nothing needed
  }

  bool WantQuit() const
  {
    return want_quit;
  }

public:
  // FLTK virtual method for handling input events.
  int handle(int event);

private:
  static void callback_Quit(Fl_Widget *w, void *data)
  {
    UI_OptionsWin *that = (UI_OptionsWin *)data;

    that->want_quit = true;
  }

  static void callback_Backups(Fl_Widget *w, void *data)
  {
    UI_OptionsWin *that = (UI_OptionsWin *)data;

    create_backups = that->opt_backups->value() ? true : false;
  }

  static void callback_Modules(Fl_Widget *w, void *data)
  {
    UI_OptionsWin *that = (UI_OptionsWin *)data;

    hide_module_panel = that->opt_modules->value() ? true : false;
    main_win->HideModules(hide_module_panel);
  }

  static void callback_Debug(Fl_Widget *w, void *data)
  {
    UI_OptionsWin *that = (UI_OptionsWin *)data;

    debug_messages = that->opt_debug->value() ? true : false;
    LogEnableDebug(debug_messages);
  }

};


//
// Constructor
//
UI_OptionsWin::UI_OptionsWin(int W, int H, const char *label) :
    Fl_Window(W, H, label),
    want_quit(false)
{
  // cancel Fl_Group's automatic add crap
  end();

  // non-resizable
  size_range(W, H, W, H);
  callback(callback_Quit, this);

  box(FL_THIN_UP_BOX);
  color(BUILD_BG, BUILD_BG);


  int y_step = 6 + KF;

  int cx = x() + 24 + KF*3;
  int cy = y() + y_step;

  Fl_Box *heading = new Fl_Box(FL_NO_BOX, x()+6, cy, W-12, 24, "Miscellaneous Options");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);
  heading->labelsize(FL_NORMAL_SIZE + 2);

  add(heading);

  cy += heading->h() + y_step;

  
  opt_backups = new Fl_Check_Button(cx, cy, 24, 24, "Create Backups");
  opt_backups->align(FL_ALIGN_RIGHT);
  opt_backups->value(create_backups ? 1 : 0);
  opt_backups->callback(callback_Backups, this);

  add(opt_backups);

  cy += opt_backups->h() + y_step;


  opt_modules = new Fl_Check_Button(cx, cy, 24, 24, "Hide Modules Panel (same as F5 key)");
  opt_modules->align(FL_ALIGN_RIGHT);
  opt_modules->value(hide_module_panel ? 1 : 0);
  opt_modules->callback(callback_Modules, this);

  add(opt_modules);

  cy += opt_modules->h() + y_step;


  opt_debug = new Fl_Check_Button(cx, cy, 24, 24, "Debugging Messages (in LOGS.txt)");
  opt_debug->align(FL_ALIGN_RIGHT);
  opt_debug->value(debug_messages ? 1 : 0);
  opt_debug->callback(callback_Debug, this);

  add(opt_debug);

  cy += opt_debug->h() + y_step;


  int dh = 50 + KF * 4;

  Fl_Group *darkish = new Fl_Group(0, H-dh, W, dh);
  darkish->end();
  darkish->box(FL_FLAT_BOX);
  darkish->color(BUILD_BG, BUILD_BG);
  add(darkish);


  // finally add an "OK" button
  int bw = 60 + KF * 10;
  int bh = 30 + KF * 3;

  Fl_Button *button = new Fl_Button(W-10-bw, H-10-bh, bw, bh, "OK");
  button->callback(callback_Quit, this);
  darkish->add(button);
}


int UI_OptionsWin::handle(int event)
{
  if (event == FL_KEYDOWN || event == FL_SHORTCUT)
  {
    int key = Fl::event_key();

    switch (key)
    {
      case FL_Escape:
        want_quit = true;
        return 1;
      
      // intercept the F5 key and toggle the associated checkbox
      case FL_F+5:
        opt_modules->value(opt_modules->value() ? 0 : 1);    
        callback_Modules(opt_modules, this);
        return 1;
    
      default: break;
    }

    // eat all other function keys
    if (FL_F+1 <= key && key <= FL_F+12)
      return 1;
  }

  return Fl_Window::handle(event);
}


void DLG_OptionsEditor(void)
{
  static UI_OptionsWin * option_window = NULL;

  if (option_window)  // already in use?
    return;

  int opt_w = 340 + KF * 30;
  int opt_h = 370 + KF * 40;

  option_window = new UI_OptionsWin(opt_w, opt_h, "Oblige Options");

  option_window->show();

  // run the GUI until the user closes
  while (! option_window->WantQuit())
    Fl::wait();

  // this deletes all the child widgets too...
  delete option_window;

  option_window = NULL;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
