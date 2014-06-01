//------------------------------------------------------------------------
//  Build panel
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2014 Andrew Apted
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
#define INACTIVE_BG2  fl_gray_ramp(14)

#define ABORT_COLOR  fl_color_cube(3,1,1)

#define PROGRESS_FG  fl_color_cube(3,3,0)

#define NODE_PROGRESS_FG  fl_color_cube(1,4,2)


UI_Build::UI_Build(int x, int y, int w, int h, const char *label) :
	Fl_Group(x, y, w, h, label)
{
	end(); // cancel begin() in Fl_Group constructor

	box(FL_THIN_UP_BOX);

	if (! alternate_look)
		color(BUILD_BG, BUILD_BG);

	status_label[0] = 0;


	int cy = y + 18 + KF * 4;

	int mini_w = 100 + KF * 12;
	int mini_h = 106 + KF *  6;
	int mini_x = x + 12 + KF * 2;
mini_x = x + 100 + KF * 16;

	mini_map = new UI_MiniMap(mini_x, cy + 14, mini_w, mini_h);

	add(mini_map);


	int button_w = 74 + KF * 16;
	int button_h = 30 + KF * 4;
	int button_x = x + 120 + KF * 16;
button_x = x + 12 + KF * 2;

	about = new Fl_Button(button_x, cy, button_w, button_h, "About");
	about->labelsize(FL_NORMAL_SIZE + 0);
	// about->callback(about_callback, this);
about->hide();

	add(about);

///	cy += about->h() + 8 + KF;


Fl_Menu_Across *
	misc_menu = new Fl_Menu_Across(button_x, cy, button_w, button_h, "     Menu @-3>");
	misc_menu->labelsize(FL_NORMAL_SIZE + 0);
	misc_menu->selection_color(fl_rgb_color(120,80,20));

	misc_menu->add("About",            FL_F+1, menu_do_about);
	misc_menu->add("Options",          FL_F+4, menu_do_options);
	misc_menu->add("Manage Config   ", FL_F+9, menu_do_manage_config);
	misc_menu->add("Console",          FL_F+7, menu_do_console);

	add(misc_menu);



	options = new Fl_Button(button_x, cy, button_w, button_h, "Options");
	options->labelsize(FL_NORMAL_SIZE + 0);
	// options->callback(options_callback, this);
options->hide();

	add(options);

	cy += options->h() + 16 + KF;



	const char *build_text = "Build";

	build = new Fl_Button(button_x, cy, button_w, button_h, build_text);
	build->labelfont(FL_HELVETICA_BOLD);
	build->labelsize(FL_NORMAL_SIZE + 2);
	build->callback(build_callback, this);
	build->shortcut(FL_F+2);

	add(build);

	cy += build->h() + 8 + KF;

cy += 10;


	quit = new Fl_Button(button_x, cy, button_w, button_h, "Quit");
	quit->labelsize(FL_NORMAL_SIZE + 0);
	quit->callback(quit_callback, this);
	quit->shortcut(FL_COMMAND + 'q');

	add(quit);


	cy += quit->h();


	cy = y + h - 88;


	status = new Fl_Box(FL_FLAT_BOX, x+12, cy, w-22, 24+KF*2, "Ready to go!");
	status->align(FL_ALIGN_INSIDE | FL_ALIGN_BOTTOM_LEFT);

	if (! alternate_look)
		status->color(FL_DARK2, FL_DARK2);

	add(status);

	cy += status->h() + 14;


	progress = new Fl_Progress(x+14+KF*2, cy, w-28-KF*4, 26);
	progress->align(FL_ALIGN_INSIDE);
	progress->box(FL_FLAT_BOX);
	progress->color(alternate_look ? INACTIVE_BG2 : INACTIVE_BG, FL_BLACK);
	progress->value(0.0);
	progress->labelsize(16);

	add(progress);

	cy += progress->h() + 12;


	resizable(NULL);
}


UI_Build::~UI_Build()
{ }


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
	progress->color(alternate_look ? FL_BLACK : FL_BACKGROUND_COLOR, PROGRESS_FG);

	if (alternate_look)
		progress->labelcolor(FL_WHITE);
}


void UI_Build::Prog_Finish()
{
	progress->color(alternate_look ? INACTIVE_BG2 : INACTIVE_BG, FL_BLACK);
	progress->value(0.0);
	progress->label("");
}


void UI_Build::Prog_AtLevel(int index, int total)
{
	level_index = index;
	level_total = total;

	Prog_Step("Plan");
}


void UI_Build::Prog_Step(const char *step_name)
{
	int pos = FindStep(step_name);

	if (pos < 0)
		return;

	SYS_ASSERT(level_total > 0);

	float val = level_index-1;

	val = val + pos / (float)step_names.size();

	val = (val / (float)level_total) * (1 - node_ratio);

	if (val < 0) val = 0;
	if (val > 1) val = 1;

	sprintf(prog_label, "%d%%", int(val * 100));

	progress->value(val);
	progress->label(prog_label);

	AddStatusStep(step_name);

	Main_Ticker();
}


void UI_Build::Prog_Nodes(int pos, int limit)
{
	SYS_ASSERT(limit > 0);

	if (! node_begun)
	{
		node_begun = true;
		progress->selection_color(NODE_PROGRESS_FG);
	}

	float val = pos / (float)limit;

	val = 1 + node_ratio * (val - 1);

	if (val < 0) val = 0;
	if (val > 1) val = 1;

	sprintf(prog_label, "%d%%", int(val * 100));

	progress->value(val);
	progress->label(prog_label);

	Main_Ticker();
}


void UI_Build::SetStatus(const char *msg)
{
	int limit = (int)sizeof(status_label);

	strncpy(status_label, msg, limit);

	status_label[limit-1] = 0;

	status->label(status_label);
	status->redraw();
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

	// these three are done by Lua (no variation)
	step_names.push_back("Plan");
	step_names.push_back("Rooms");
	step_names.push_back("Mons");

	while (*names)
	{
		const char *comma = strchr(names, ',');

		if (! comma)
		{
			step_names.push_back(names);
			break;
		}

		SYS_ASSERT(comma > names);

		step_names.push_back(std::string(names, comma - names));

		names = comma+1;
	}
}


int UI_Build::FindStep(const char *name)
{
	for (int i = 0; i < (int)step_names.size(); i++)
		if (StringCaseCmp(step_names[i].c_str(), name) == 0)
			return i;

	return -1;  // not found
}


void UI_Build::AddStatusStep(const char *name)
{
	// modifies the current status string to show the current step

	char *pos = strchr(status_label, ':');

	if (pos)
		pos[1] = 0;
	else
		strcat(status_label, " :");

	strcat(status_label, " ");
	strcat(status_label, name);

	status->label(status_label);
	status->redraw();
}


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

void UI_Build::menu_do_manage_config(Fl_Widget *w, void *data)
{
	fl_beep();
}

void UI_Build::menu_do_console(Fl_Widget *w, void *data)
{
	UI_ToggleConsole();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
