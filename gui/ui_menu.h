//------------------------------------------------------------------------
//  MAIN Menu Bar
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
//  Adapted from the Build Module by Dashodanger
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

#ifndef __UI_MENU_H__
#define __UI_MENU_H__

class UI_Menu : public Fl_Menu_Bar
{
public:
	UI_Menu *menu_bar;

private:
	Fl_Menu_Across *misc_menu;

	Fl_Button *build;
	Fl_Button *quit;

	Fl_Box *status;
	Fl_Progress *progress;

	Fl_Box *seed_display;

	char  status_label[200];
	char  prog_label[100];

	int   level_index;  // starts at 1
	int   level_total;

	bool  node_begun;
	float node_ratio;
	float node_along;

	std::vector<std::string> step_names;

public:
	UI_Menu(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_Menu();

public:

private:

	static void menu_do_about(Fl_Widget *, void*);
	static void menu_do_options(Fl_Widget *, void*);
	static void menu_do_addons(Fl_Widget *, void*);
	static void menu_do_edit_seed(Fl_Widget *, void*);
	static void menu_do_view_logs(Fl_Widget *, void*);
	static void menu_do_manage_config(Fl_Widget *, void*);
	
};

#endif /* __UI_MENU_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
