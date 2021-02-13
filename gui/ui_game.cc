//----------------------------------------------------------------
//  Game Panel
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_signal.h"
#include "lib_util.h"
#include "main.h"
#include "m_lua.h"


//
// Constructor
//
UI_Game::UI_Game(int X, int Y, int W, int H, const char *label) :
	Fl_Group(X, Y, W, H, label)
{
	box(FL_FLAT_BOX);


	int y_step  = kf_h(30);
	int y_step2 = kf_h(44);

	int cx = X + W * 0.39;
	int cy = Y + kf_h(4);


	const char *heading_text = _("Game Settings");

	Fl_Box *heading = new Fl_Box(FL_NO_BOX, X + kf_w(8), cy, W - kf_w(12), kf_h(24), heading_text);
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(header_font_size);

	cy = Y + kf_h(32);


	int cw = W * 0.58;
	int ch = kf_h(24);

	game = new UI_RChoice(cx, cy, cw, ch, _("Game: "));
	game->align(FL_ALIGN_LEFT);
	game->selection_color(FL_BLUE);
	game->callback(callback_Game, this);

	cy += y_step;


	engine = new UI_RChoice(cx, cy, cw, ch, _("Engine: "));
	engine->align(FL_ALIGN_LEFT);
	engine->selection_color(FL_BLUE);
	engine->callback(callback_Engine, this);

	cy += y_step2;


	length = new UI_RChoice(cx, cy, cw, ch, _("Length: "));
	length->align(FL_ALIGN_LEFT);
	length->selection_color(FL_BLUE);
	length->callback(callback_Length, this);

	cy += y_step2;


	theme = new UI_RChoice(cx, cy, cw, ch, _("Theme: "));
	theme->align(FL_ALIGN_LEFT);
	theme->selection_color(FL_BLUE);
	theme->callback(callback_Theme, this);

	cy += y_step;


	end();

	resizable(NULL);  // don't resize our children
}


//
// Destructor
//
UI_Game::~UI_Game()
{ }


void UI_Game::callback_Game(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("game", that->game->GetID());
}


void UI_Game::callback_Engine(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("engine", that->engine->GetID());
}


void UI_Game::callback_Length(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("length", that->length->GetID());
}


void UI_Game::callback_Theme(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *) data;

	ob_set_config("theme", that->theme->GetID());
}


void UI_Game::Locked(bool value)
{
	if (value)
	{
		game  ->deactivate();
		engine->deactivate();
		length->deactivate();
		theme ->deactivate();
	}
	else
	{
		game  ->activate();
		engine->activate();
		length->activate();
		theme ->activate();
	}
}


bool UI_Game::AddChoice(const char *button, const char *id, const char *label)
{
	if (StringCaseCmp(button, "game") == 0)
	{
		game->AddChoice(id, label);
		return true;
	}
	if (StringCaseCmp(button, "engine") == 0)
	{
		engine->AddChoice(id, label);
		return true;
	}
	if (StringCaseCmp(button, "length") == 0)
	{
		length->AddChoice(id, label);
		return true;
	}
	if (StringCaseCmp(button, "theme") == 0)
	{
		theme->AddChoice(id, label);
		return true;
	}

	return false;  // unknown button
}


bool UI_Game::EnableChoice(const char *button, const char *id, bool enable_it)
{
	if (StringCaseCmp(button, "game") == 0)
	{
		game->EnableChoice(id, enable_it);
		return true;
	}
	if (StringCaseCmp(button, "engine") == 0)
	{
		engine->EnableChoice(id, enable_it);
		return true;
	}
	if (StringCaseCmp(button, "length") == 0)
	{
		length->EnableChoice(id, enable_it);
		return true;
	}
	if (StringCaseCmp(button, "theme") == 0)
	{
		theme->EnableChoice(id, enable_it);
		return true;
	}

	return false;  // unknown button
}


bool UI_Game::SetButton(const char *button, const char *id)
{
	if (StringCaseCmp(button, "game") == 0)
	{
		game->ChangeTo(id);
		return true;
	}
	if (StringCaseCmp(button, "engine") == 0)
	{
		engine->ChangeTo(id);
		return true;
	}
	if (StringCaseCmp(button, "length") == 0)
	{
		length->ChangeTo(id);
		return true;
	}
	if (StringCaseCmp(button, "theme") == 0)
	{
		theme->ChangeTo(id);
		return true;
	}

	return false;  // unknown button
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
