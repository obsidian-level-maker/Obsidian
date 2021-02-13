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


#define ABORT_COLOR  fl_color_cube(3,1,1)

#define PROGRESS_FG  fl_color_cube(3,3,0)
#define PROGRESS_BG  fl_gray_ramp(10)

#define NODE_PROGRESS_FG  fl_color_cube(1,4,2)


UI_Build::UI_Build(int X, int Y, int W, int H, const char *label) :
	Fl_Group(X, Y, W, H, label)
{
	box(FL_THIN_UP_BOX);

	resizable(NULL);

	status_label[0] = 0;


	int button_w = W * 0.35;
	int button_h = kf_h(30);
	int button_x = X + kf_w(16);


	int mini_w = W * 0.42;
	int mini_h = mini_w;
	int mini_x = button_x + button_w + kf_w(24);
	int mini_y = Y + kf_h(28);

	mini_map = new UI_MiniMap(mini_x, mini_y, mini_w, mini_h);


	int cy = mini_y - button_h/2;

	misc_menu = new Fl_Menu_Across(button_x, cy, button_w, button_h,
		StringPrintf("     %s @-3>", _("Menu")));
	misc_menu->selection_color(fl_rgb_color(120,80,20));

	misc_menu->add(_("About"),         FL_F+1, menu_do_about);
	misc_menu->add(_("Options"),       FL_F+4, menu_do_options);
	misc_menu->add(_("Addon List"),    FL_F+3, menu_do_addons);
	misc_menu->add(_("Set Seed"),      FL_F+5, menu_do_edit_seed);
	misc_menu->add(_("View Logs"),     FL_F+6, menu_do_view_logs);
	misc_menu->add(_("Config Manager"),FL_F+9, menu_do_manage_config);


	cy = mini_y + mini_h / 2 - (button_h+4) / 2;


	build = new Fl_Button(button_x, cy, button_w, button_h + 4, _("Build"));
	build->labelfont(FL_HELVETICA_BOLD);
	build->labelsize(FL_NORMAL_SIZE + 2);
	build->callback(build_callback, this);
	build->shortcut(FL_F+2);


	cy = mini_y + mini_h - button_h/2;

	quit = new Fl_Button(button_x, cy, button_w, button_h, _("Quit"));
	quit->callback(quit_callback, this);
	quit->shortcut(FL_COMMAND + 'q');


	/* --- Status Area --- */

	cy = cy + button_h + kf_h(16);


	int pad = kf_w(14);

	status = new Fl_Box(FL_FLAT_BOX, X + pad, cy, W - pad*2, kf_h(26), _("Ready to go!"));
	status->align(FL_ALIGN_INSIDE | FL_ALIGN_BOTTOM_LEFT);

	cy += status->h() + kf_h(12);


	progress = new Fl_Progress(X + pad, cy, W - pad*2, kf_h(26));
	progress->align(FL_ALIGN_INSIDE);
	progress->box(FL_FLAT_BOX);
	progress->color(PROGRESS_BG, PROGRESS_BG);
	progress->value(0.0);
	progress->labelsize(FL_NORMAL_SIZE + 2);

	cy = cy + progress->h() + kf_h(8);


	int cw = kf_w(10);
	int ch = kf_h(26);

	seed_display = new Fl_Box(FL_NO_BOX, X + cw, cy, W - cw*2, ch, "---- ---- ---- ----");
	seed_display->labelfont(FL_COURIER);
	seed_display->labelsize(FL_NORMAL_SIZE + 2);
	seed_display->labelcolor(34);


	end();
}


UI_Build::~UI_Build()
{ }


void UI_Build::Locked(bool value)
{
	if (value)
	{
		misc_menu->deactivate();
		build->deactivate();
	}
	else
	{
		misc_menu->activate();
		build->activate();
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
	progress->color(FL_DARK3, PROGRESS_FG);
	progress->labelcolor(FL_WHITE);
}


void UI_Build::Prog_Finish()
{
	progress->color(PROGRESS_BG, PROGRESS_BG);
	progress->value(0.0);
	progress->label("");
}


void UI_Build::Prog_AtLevel(int index, int total)
{
	level_index = index;
	level_total = total;

	Prog_Step(N_("Plan"));
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

	AddStatusStep(_(step_name));

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
		quit->label(_("Cancel"));
		quit->labelcolor(ABORT_COLOR);
		quit->labelfont(FL_HELVETICA_BOLD);

		quit->callback(stop_callback, this);

		build->labelfont(FL_HELVETICA);
	}
	else
	{
		quit->label(_("Quit"));
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
	step_names.push_back(N_("Plan"));
	step_names.push_back(N_("Rooms"));
	step_names.push_back(N_("Mons"));

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


void UI_Build::DisplaySeed(double value)
{
	if (value < 0)
	{
		seed_display->label("---- ---- ---- ----");
		return;
	}

	// format the number to be 4 groups of 4 digits.
	// if the seed is longer than 16 digits, then we truncate it.

	char buffer[256];

	sprintf(buffer, "%016.0f", value);

	char newbuf[64];
	memset(newbuf, 0, sizeof(newbuf));

	int i, k;

	for (i = 0 ; i < 4 ; i++)
	{
		for (k = 0 ; k < 4 ; k++)
			newbuf[i*5 + k] = buffer[i*4 + k];

		if (i < 3)
			newbuf[(i+1) * 5 - 1] = ' ';
	}

	seed_display->copy_label(newbuf);
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
