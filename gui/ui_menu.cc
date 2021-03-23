//------------------------------------------------------------------------
//  Build panel
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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


UI_Menu::UI_Menu(int X, int Y, int W, int H, const char *label) :
	Fl_Menu_Bar(X, Y, W, H, label)
{


	misc_menu = new Fl_Menu_Across(button_x, cy, button_w, button_h,
		StringPrintf("     %s @-3>", _("Menu")));
	misc_menu->selection_color(WINDOW_BG);

	misc_menu->add(_("About"),         FL_F+1, menu_do_about);
	misc_menu->add(_("Options"),       FL_F+4, menu_do_options);
	misc_menu->add(_("Addon List"),    FL_F+3, menu_do_addons);
	misc_menu->add(_("Set Seed"),      FL_F+5, menu_do_edit_seed);
	misc_menu->add(_("View Logs"),     FL_F+6, menu_do_view_logs);
	misc_menu->add(_("Config Manager"),FL_F+9, menu_do_manage_config);

	end();
}


UI_Menu::~UI_Menu()
{ }

//----------------------------------------------------------------

void UI_Build::build_callback(Fl_Widget *w, void *data)
{
	if (main_action == 0)
	{
		main_action = MAIN_BUILD;
	}
}

void UI_Build::stop_callback(Fl_Widget *w, void *data)
{
	if (main_action != MAIN_QUIT)
	{
		main_action = MAIN_CANCEL;
	}
}

void UI_Build::quit_callback(Fl_Widget *w, void *data)
{
	main_action = MAIN_QUIT;
}


void UI_Build::menu_do_about(Fl_Widget *w, void *data)
{
	DLG_AboutText();
}

void UI_Build::menu_do_options(Fl_Widget *w, void *data)
{
	DLG_OptionsEditor();
}

void UI_Build::menu_do_addons(Fl_Widget *w, void *data)
{
	DLG_SelectAddons();
}

void UI_Build::menu_do_edit_seed(Fl_Widget *w, void *data)
{
	DLG_EditSeed();
}

void UI_Build::menu_do_view_logs(Fl_Widget *w, void *data)
{
	DLG_ViewLogs();
}

void UI_Build::menu_do_manage_config(Fl_Widget *w, void *data)
{
	DLG_ManageConfig();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
