//----------------------------------------------------------------
//  Setup screen
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
	end(); // cancel begin() in Fl_Group constructor

	box(FL_THIN_UP_BOX);

	if (! alternate_look)
		color(BUILD_BG, BUILD_BG);


	int y_step = kf_h(6) + KF;

	int cx = X + W * 0.36;
	int cy = Y + y_step;


	const char *heading_text = "Game Settings";

	Fl_Box *heading = new Fl_Box(FL_NO_BOX, X + kf_w(6), cy, W - kf_w(12), kf_h(24), heading_text);
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(header_font_size);

	add(heading);

	cy += heading->h() + y_step;


	int cw = W * 0.61;
	int ch = kf_h(24);

	game = new UI_RChoice(cx, cy, cw, ch, "Game: ");
	game->align(FL_ALIGN_LEFT);
	game->selection_color(FL_BLUE);
	game->callback(callback_Game, this);

	add(game);

	cy += game->h() + y_step;


	engine = new UI_RChoice(cx, cy, cw, ch, "Engine: ");
	engine->align(FL_ALIGN_LEFT);
	engine->selection_color(FL_BLUE);
	engine->callback(callback_Engine, this);

	add(engine);

	cy += engine->h() + y_step * 2;


	mode = new UI_RChoice(cx, cy, cw, ch, "Mode: ");
	mode->align(FL_ALIGN_LEFT);
	mode->selection_color(FL_BLUE);
	mode->callback(callback_Mode, this);

	setup_Mode();

	add(mode);

	cy += mode->h() + y_step;


	length = new UI_RChoice(cx, cy, cw, ch, "Length: ");
	length->align(FL_ALIGN_LEFT);
	length->selection_color(FL_BLUE);
	length->callback(callback_Length, this);

	setup_Length();

	add(length);

	cy += length->h() + y_step;


	resizable(NULL);  // don't resize our children


	length->SetID("episode");
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
	Signal_Raise("game");
}


void UI_Game::callback_Mode(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("mode", that->mode->GetID());
	Signal_Raise("mode");
}


void UI_Game::callback_Engine(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("engine", that->engine->GetID());
	Signal_Raise("engine");
}


void UI_Game::callback_Length(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("length", that->length->GetID());
}


void UI_Game::Locked(bool value)
{
	if (value)
	{
		game->deactivate();
		mode->deactivate();
		length->deactivate();
		engine->deactivate();
	}
	else
	{
		game->activate();
		mode->activate();
		length->activate();
		engine->activate();

		// ????    game_callback(this, this);
		// ????    mode_callback(this, this);
	}
}


void UI_Game::Defaults()
{
	// Note: game, engine are handled by LUA code (ob_init)

	ParseValue("mode", "sp");
	ParseValue("length", "few");
}


bool UI_Game::ParseValue(const char *key, const char *value)
{
	// Note: game, engine are handled by LUA code
	//
	if (StringCaseCmp(key, "mode") == 0)
	{
		mode->SetID(value);
		callback_Mode(NULL, this);
		return true;
	}

	if (StringCaseCmp(key, "length") == 0)
	{
		length->SetID(value);
		callback_Length(NULL, this);
	}

	return false;
}


//----------------------------------------------------------------

const char * UI_Game::mode_syms[] =
{
	"sp",   "Single Player",
	"coop", "Co-op",
///	"dm",   "Deathmatch",
///	"ctf",  "Capture Flag",

	NULL, NULL
};

const char * UI_Game::length_syms[] =
{
	"single",  "Single Level",
	"few",     "A Few Maps",
	"episode", "One Episode",
	"game",    "Full Game",

	NULL, NULL
};


void UI_Game::setup_Mode()
{
	for (int i = 0; mode_syms[i]; i += 2)
	{
		mode->AddPair(mode_syms[i], mode_syms[i+1]);
		mode->ShowOrHide(mode_syms[i], 1);
	}
}


void UI_Game::setup_Length()
{
	for (int i = 0; length_syms[i]; i += 2)
	{
		length->AddPair(length_syms[i], length_syms[i+1]);
		length->ShowOrHide(length_syms[i], 1);
	}
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
