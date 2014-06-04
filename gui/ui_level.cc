//----------------------------------------------------------------
//  Level Architecture
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "m_lua.h"
#include "main.h"


#define MY_GREEN  fl_rgb_color(0,166,0)


//
// Constructor
//
UI_Level::UI_Level(int X, int Y, int W, int H, const char *label) :
    Fl_Group(X, Y, W, H, label)
{
	end(); // cancel begin() in Fl_Group constructor

	box(FL_THIN_UP_BOX);

	if (! alternate_look)
		color(BUILD_BG, BUILD_BG);


	int y_step = kf_h(6) + KF;

	int cx = X + W * 0.42;
	int cy = Y + y_step;

	const char *heading_text = "Level Architecture";

	Fl_Box *heading = new Fl_Box(FL_NO_BOX, X + kf_w(6), cy, W - kf_w(12), kf_h(24), heading_text);
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(header_font_size);

	add(heading);

	cy += heading->h() + y_step;


	int cw = W * 0.54;
	int ch = kf_h(24);

	size = new UI_RChoice(cx, cy, cw, ch, "Size: ");
	size->align(FL_ALIGN_LEFT);
	size->selection_color(MY_GREEN);
	size->callback(callback_Size, this);

	setup_Size();

	add(size);

	cy += size->h() + y_step;


	theme = new UI_RChoice(cx, cy, cw, ch, "Theme: ");
	theme->align(FL_ALIGN_LEFT);
	theme->selection_color(MY_GREEN);
	theme->callback(callback_Theme, this);

	add(theme);

	cy += theme->h() + y_step * 2;


	outdoors = new UI_RChoice(cx, cy, cw, ch, "Outdoors: ");
	outdoors->align(FL_ALIGN_LEFT);
	outdoors->selection_color(MY_GREEN);
	outdoors->callback(callback_Outdoors, this);

	setup_Outdoors();

	add(outdoors);

	cy += outdoors->h() + y_step;


	caves = new UI_RChoice(cx, cy, cw, ch, "Caves: ");
	caves->align(FL_ALIGN_LEFT);
	caves->selection_color(MY_GREEN);
	caves->callback(callback_Caves, this);

	setup_Caves();

	add(caves);


	resizable(NULL);  // don't resize our children
}


//
// Destructor
//
UI_Level::~UI_Level()
{ }


void UI_Level::Locked(bool value)
{
	if (value)
	{
		size ->deactivate();
		theme->deactivate();

		outdoors->deactivate();
		caves   ->deactivate();
	}
	else
	{
		size ->activate();
		theme->activate();

		outdoors->activate();
		caves   ->activate();
	}
}


//----------------------------------------------------------------

void UI_Level::callback_Theme(Fl_Widget *w, void *data)
{
	UI_Level *that = (UI_Level *) data;

	ob_set_config("theme", that->theme->GetID());
}


void UI_Level::callback_Size(Fl_Widget *w, void *data)
{
	UI_Level *that = (UI_Level *) data;

	ob_set_config("size", that->size->GetID());
}


void UI_Level::callback_Outdoors(Fl_Widget *w, void *data)
{
	UI_Level *that = (UI_Level *) data;

	ob_set_config("outdoors", that->outdoors->GetID());
}


void UI_Level::callback_Caves(Fl_Widget *w, void *data)
{
	UI_Level *that = (UI_Level *) data;

	ob_set_config("caves", that->caves->GetID());
}


void UI_Level::Defaults()
{
	// Note: theme handled by LUA code (ob_init)

	ParseValue("size",     "prog");
	ParseValue("outdoors", "mixed");
	ParseValue("caves",    "mixed");
}


bool UI_Level::ParseValue(const char *key, const char *value)
{
	// Note: theme handled by LUA code

	if (StringCaseCmp(key, "size") == 0)
	{
		size->SetID(value);
		callback_Size(NULL, this);
		return true;
	}

	if (StringCaseCmp(key, "outdoors") == 0)
	{
		outdoors->SetID(value);
		callback_Outdoors(NULL, this);
		return true;
	}

	if (StringCaseCmp(key, "caves") == 0)
	{
		caves->SetID(value);
		callback_Caves(NULL, this);
		return true;
	}

	return false;
}


//----------------------------------------------------------------

const char * UI_Level::size_syms[] =
{
	"tiny",    "Tiny",
	"small",   "Small",
	"regular", "Regular",
	"large",   "Large",
	"extreme", "Extreme",

	"prog",    "Progressive",
	"mixed",   "Mix It Up",

	NULL, NULL
};


const char * UI_Level::outdoor_syms[] =
{
	// also used for Caves

	"none",   "NONE",
	"few",    "Rare",
	"some",   "Some",
	"heaps",  "Heaps",
	"always", "Always",

	"mixed",  "Mix It Up",

	NULL, NULL
};


void UI_Level::setup_Size()
{
	for (int i = 0; size_syms[i]; i += 2)
	{
		size->AddPair(size_syms[i], size_syms[i+1]);
		size->ShowOrHide(size_syms[i], 1);
	}
}


void UI_Level::setup_Outdoors()
{
	for (int i = 0; outdoor_syms[i]; i += 2)
	{
		outdoors->AddPair(outdoor_syms[i], outdoor_syms[i+1]);
		outdoors->ShowOrHide(outdoor_syms[i], 1);
	}
}


void UI_Level::setup_Caves()
{
	for (int i = 0; outdoor_syms[i]; i += 2)
	{
		caves->AddPair(outdoor_syms[i], outdoor_syms[i+1]);
		caves->ShowOrHide(outdoor_syms[i], 1);
	}
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
