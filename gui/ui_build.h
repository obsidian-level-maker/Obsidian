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

class UI_Build : public Fl_Group
{
private:
	Fl_Box *status;
	Fl_Progress *progress;

	char  status_label[200];
	char  prog_label[100];

	int   level_index;  // starts at 1
	int   level_total;

	bool  node_begun;
	float node_ratio;
	float node_along;

	std::vector<std::string> step_names;

	Fl_Menu_Across *misc_menu;

	Fl_Button *build;
	Fl_Button *quit;

public:
	UI_MiniMap *mini_map;

public:
	UI_Build(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_Build();

public:
	void Prog_Init(int node_perc, const char *extra_steps);
	void Prog_AtLevel(int index, int total);
	void Prog_Step(const char *step_name);
	void Prog_Nodes(int pos, int limit);
	void Prog_Finish();

	void SetStatus(const char *msg);
	void SetAbortButton(bool abort);
	void Locked(bool value);

private:
	void ParseSteps(const char *list);
	int  FindStep(const char *name);  // -1 if not found

	void AddStatusStep(const char *name);

	static void build_callback(Fl_Widget *, void*);
	static void stop_callback(Fl_Widget *, void*);
	static void quit_callback(Fl_Widget *, void*);

	static void menu_do_about(Fl_Widget *, void*);
	static void menu_do_options(Fl_Widget *, void*);
	static void menu_do_manage_config(Fl_Widget *, void*);
	static void menu_do_console(Fl_Widget *, void*);
};

#endif /* __UI_BUILD_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
