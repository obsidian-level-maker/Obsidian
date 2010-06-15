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

#define PROGRESS_FG  fl_color_cube(3,3,0)

#define NODE_PROGRESS_FG  fl_color_cube(1,4,2)


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

void UI_Build::Prog_Init(int node_perc, const char *extra_steps)
{
  level_index = 0;
  level_total = 0;

  node_begun = false;
  node_ratio = node_perc / 100.0;
  node_along = 0;

  ParseSteps(extra_steps);

  progress->minimum(0.0);
  progress->maximum(1.0);

  progress->value(0.0);
  progress->color(FL_BACKGROUND_COLOR, PROGRESS_FG);
}

void UI_Build::Prog_Finish()
{
  progress->color(INACTIVE_BG, FL_BLACK);
  progress->value(0.0);
  progress->label("");
}


void UI_Build::Prog_AtLevel(int index, int total)
{
  level_index = index;
  level_total = total;
}


void UI_Build::Prog_Step(const char *step_name)
{
  int pos = FindStep(step_name);

  if (pos < 0)
    return;

  SYS_ASSERT(level_total > 0);

  float val = level_index;

  val = val + pos / (float)step_names.size();

  val = (val / (float)level_total) * (1 - node_ratio);

  if (val < 0) val = 0;
  if (val > 1) val = 1;

  sprintf(prog_msg, "%d%%", int(val * 100));

  progress->value(val);
  progress->label(prog_msg);

  Main_Ticker();
}


void UI_Build::Prog_Nodes(int pos, int limit)
{
  SYS_ASSERT(limit > 0);

  if (! node_begun)
  {
    node_begun = true;
    progress->color(FL_BACKGROUND_COLOR, NODE_PROGRESS_FG);
  }

  float val = pos / (float)limit;

  val = 1 + node_ratio * (val - 1);

  if (val < 0) val = 0;
  if (val > 1) val = 1;

  sprintf(prog_msg, "%d%%", int(val * 100));

  progress->value(val);
  progress->label(prog_msg);

  Main_Ticker();
}


void UI_Build::SetStatus(const char *msg)
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


void UI_Build::ParseSteps(const char *names)
{
  step_names.clear();

  // these three are done in Lua (always the same)
  step_names.push_back("Plan");
  step_names.push_back("Layout");
  step_names.push_back("Mons");

  // FIXME !!!!!
  step_names.push_back("CSG");
}

int UI_Build::FindStep(const char *name)
{
  for (int i = 0; i < (int)step_names.size(); i++)
    if (StringCaseCmp(step_names[i].c_str(), name) == 0)
      return i;

  return -1;  // not found
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
