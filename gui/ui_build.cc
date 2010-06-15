//------------------------------------------------------------------------
//  Build panel
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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


UI_Build::UI_Build(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);

  color(BUILD_BG, BUILD_BG);


  int cy = y + 18 + KF * 4;

  int mini_w = 100 + KF * 12;
  int mini_h = 76 + KF *  6;

  mini_map = new UI_MiniMap(x+14+KF*2, cy, mini_w, mini_h);

  add(mini_map);

//  cy += 10;


  int button_w = 74 + KF * 16;
  int button_h = 30 + KF * 4;
  int button_x = x + w-14-KF*2 - button_w;

  about = new Fl_Button(button_x, cy, button_w, button_h, "About");
  about->labelsize(FL_NORMAL_SIZE + 0);
  about->callback(about_callback, this);

  add(about);

  cy += about->h() + 14 + KF;

  build = new Fl_Button(button_x, cy, button_w, button_h, "Build");
  build->labelfont(FL_HELVETICA_BOLD);
  build->labelsize(FL_NORMAL_SIZE + 2);
  build->callback(build_callback, this);

  add(build);

  cy += build->h() + 14 + KF;


  options = new Fl_Button(x+20, cy, button_w, button_h, "Options");
  options->labelsize(FL_NORMAL_SIZE + 0);
  options->callback(options_callback, this);

  add(options);

// cy += options->h() + 6;

  quit = new Fl_Button(button_x, cy, button_w, button_h, "Quit");
  quit->labelsize(FL_NORMAL_SIZE + 0);
  quit->callback(quit_callback, this);

  add(quit);

  cy += quit->h();

  cy += 6 + KF;
  

  status = new Fl_Box(FL_FLAT_BOX, x+12, cy, w-22, 24+KF*2, "Ready to go!");
  status->align(FL_ALIGN_INSIDE | FL_ALIGN_BOTTOM_LEFT);
  status->color(FL_DARK2, FL_DARK2);

  add(status);

  cy += status->h() + 12;
  

  progress = new Fl_Progress(x+14+KF*2, cy, w-28-KF*4, 20);
  progress->align(FL_ALIGN_INSIDE);
  progress->box(FL_FLAT_BOX);
  progress->color(INACTIVE_BG, FL_BLACK);
  progress->value(0.0);
  progress->labelsize(16);

  add(progress);

  cy += progress->h() + 12;


  resizable(NULL);
}


UI_Build::~UI_Build()
{
}

void UI_Build::Locked(bool value)
{
  if (value)
  {
    build->deactivate();
    about->deactivate();
    options->deactivate();
  }
  else
  {
    build->activate();
    about->activate();
    options->activate();
  }
}

//----------------------------------------------------------------

void UI_Build::ProgInit(int node_perc)
{
  prog_num_pass = 1; //!!!!!!!  num_pass;

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
    val = val * 75.0;
  else
    val = 75.0 + (val * 25.0);

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

void UI_Build::Status(const char *msg)
{
  status->copy_label(msg);
}

void UI_Build::SetAbortButton(bool abort)
{
  if (abort)
  {
    quit->label("Cancel");
    quit->labelcolor(ABORT_COLOR);
    quit->labelfont(FL_HELVETICA_BOLD);

    quit->callback(stop_callback, this);

    build->labelfont(FL_HELVETICA);
  }
  else
  {
    quit->label("Quit");
    quit->labelcolor(FL_FOREGROUND_COLOR);
    quit->labelfont(FL_HELVETICA);

    quit->callback(quit_callback, this);

    build->labelfont(FL_HELVETICA_BOLD);
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

void UI_Build::about_callback(Fl_Widget *w, void *data)
{
  DLG_AboutText();
}

void UI_Build::options_callback(Fl_Widget *w, void *data)
{
  DLG_OptionsEditor();
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
