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

#ifndef __UI_BUILD_H__
#define __UI_BUILD_H__

#define BUILD_PROGRESS_FG  fl_color_cube(3,3,0)

class UI_Build : public Fl_Group
{
private:
  Fl_Box *status;
  Fl_Progress *progress;

  char  prog_msg[20];
  int   prog_pass;
  int   prog_num_pass;
  float prog_limit;

  Fl_Button *build;
  Fl_Button *about;
  Fl_Button *options;
  Fl_Button *quit;

public:
  UI_MiniMap *mini_map;

public:
  UI_Build(int x, int y, int w, int h, const char *label = NULL);
  virtual ~UI_Build();

public:
  void Prog_Init(int node_perc, const char *level_steps);
  void Prog_AtLevel(const char *name, int index, int total);
  void Prog_Step(const char *step_name);
  void Prog_Nodes(int pos, int limit);
  void Prog_Finish();

  void SetStatus(const char *msg);

  void SetAbortButton(bool abort);
  void Locked(bool value);

private:
  static void build_callback(Fl_Widget *, void*);
  static void about_callback(Fl_Widget *, void*);
  static void options_callback(Fl_Widget *, void*);
  static void stop_callback(Fl_Widget *, void*);
  static void quit_callback(Fl_Widget *, void*);
};

#endif /* __UI_BUILD_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
