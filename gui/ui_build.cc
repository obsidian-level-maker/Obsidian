//------------------------------------------------------------------------
//  Build screen
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

#include "lib_util.h"
#include "main.h"


#define INACTIVE_BG  fl_gray_ramp(5)

#define ABORT_COLOR  fl_color_cube(3,1,1)


/* extern */
void menu_do_about(Fl_Widget *w, void * data);


UI_Build::UI_Build(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_FLAT_BOX);
  box(FL_THIN_UP_BOX); //???
  color(BUILD_BG, BUILD_BG);


  int cy = y + 13;

  mini_map = new UI_MiniMap(x+20, cy + 6, 124, 104);

  add(mini_map);


  build = new Fl_Button(x+w - 88, cy, 74, 30, "Build...");
  build->labelfont(FL_HELVETICA_BOLD);
  build->callback(build_callback, this);

  add(build);

  cy += 42;

  Fl_Button *about = new Fl_Button(x+w - 88, cy, 74, 30, "About");
  about->callback(menu_do_about, this);

  add(about);

  cy += 42;

  quit = new Fl_Button(x+w - 88, cy, 74, 32, "Quit");
  quit->callback(quit_callback, this);

  add(quit);

  cy += 42;
  

  DebugPrintf("UI_Build: button h2 = %d\n", cy - y);


  cy = y + h - 72;

  status = new Fl_Box(FL_FLAT_BOX, x+12, cy, 136, 24, "Ready to go!");
  status->align(FL_ALIGN_INSIDE | FL_ALIGN_BOTTOM_LEFT);
  if (1) // plastic
    status->color(FL_DARK2, FL_DARK2);
  else
    status->color(BUILD_BG, BUILD_BG);
  add(status);

  cy += status->h() + 12;
  

  progress = new Fl_Progress(x+12, cy, w-24, 20);
  progress->align(FL_ALIGN_INSIDE);
  progress->box(FL_FLAT_BOX);
  progress->color(INACTIVE_BG, FL_BLACK);
  progress->value(0.0);

  add(progress);

///  progress->hide();

  cy += progress->h() + 12;


  DebugPrintf("UI_Build: status h2 = %d\n", cy - y);


#if 0
  Fl_Box *sizer = new Fl_Box(FL_NO_BOX, x+1, cy-4, w-2, 2, NULL);
  sizer->color(FL_RED, FL_RED);

  add(sizer);

  resizable(sizer);
#else
  resizable(NULL);
#endif
}


UI_Build::~UI_Build()
{
}

void UI_Build::Locked(bool value)
{
  if (value)
  {
    quit->deactivate();
  }
  else
  {
    quit->activate();
  }
}

//----------------------------------------------------------------

void UI_Build::ProgInit(int num_pass)
{
  prog_num_pass = num_pass;

  progress->minimum(0.0);
  progress->maximum(100.0);

  progress->value(0.0);
}

void UI_Build::ProgBegin(int pass, float limit, Fl_Color color)
{
  prog_pass  = pass;
  prog_limit = limit;

  progress->color(FL_BACKGROUND_COLOR, color);
  progress->show();
}

void UI_Build::ProgUpdate(float val)
{
  val = val / prog_limit;

  if (val < 0) val = 0;
  if (val > 1) val = 1;

  if (prog_num_pass == 1)
    val = val * 100.0;
  else if (prog_pass == 1)
    val = val * 50.0;
  else
    val = 50.0 + (val * 50.0);

  sprintf(prog_msg, "%d%%", int(val));

  progress->value(val);
  progress->label(prog_msg);

  Main_Ticker();
}

void UI_Build::ProgFinish()
{
///  progress->hide();

  progress->color(INACTIVE_BG, FL_BLACK);
  progress->value(0.0);
  progress->label("");
}

void UI_Build::ProgStatus(const char *msg)
{
  status->label(msg);
}

void UI_Build::ProgSetButton(bool abort)
{
  if (abort)
  {
    build->callback(stop_callback, this);
    build->label("Cancel");
    build->labelcolor(ABORT_COLOR);
  }
  else
  {
    build->label("Build...");
    build->labelcolor(FL_FOREGROUND_COLOR);
    build->callback(build_callback, this);
  }
}


//----------------------------------------------------------------
  
void UI_Build::build_callback(Fl_Widget *w, void *data)
{
  if (main_win->action == UI_MainWin::NONE)
  {
    main_win->action = UI_MainWin::BUILD;
  }
}

void UI_Build::stop_callback(Fl_Widget *w, void *data)
{
  if (main_win->action != UI_MainWin::QUIT)
  {
    main_win->action = UI_MainWin::ABORT;
  }
}

void UI_Build::quit_callback(Fl_Widget *w, void *data)
{
  main_win->action = UI_MainWin::QUIT;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
