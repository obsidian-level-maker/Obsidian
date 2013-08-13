//----------------------------------------------------------------
//  Setup screen
//----------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2012 Andrew Apted
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
UI_Game::UI_Game(int x, int y, int w, int h, const char *label) :
	Fl_Group(x, y, w, h, label)
{
	end(); // cancel begin() in Fl_Group constructor

	box(FL_THIN_UP_BOX);

	if (! alternate_look)
		color(BUILD_BG, BUILD_BG);

	int y_step = 6 + KF;

	int cx = x + 70 + KF * 11;
	int cy = y + y_step + KF * 3;

	const char *heading_text = "Game Settings";

	Fl_Box *heading = new Fl_Box(FL_NO_BOX, x+6, cy, w-12, 24, heading_text);
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(FL_NORMAL_SIZE + 2);

	add(heading);

	cy += heading->h() + y_step;


	int cw = 130 + KF * 14;
	int ch = 24 + KF*2;

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

	cy += engine->h() + y_step;

	cy += y_step + y_step/2;


	mode = new UI_RChoice(cx, cy, cw, ch, "Mode: ");
	mode->align(FL_ALIGN_LEFT);
	mode->selection_color(FL_BLUE);
	///---  mode->add("Single Player|Co-op|Deathmatch");
	///---  mode->value(0);
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

	cy += y_step + y_step/2;


	seed = new Fl_Int_Input(cx, cy, 66+KF*6, 24+KF*2, "Seed: ");
	seed->align(FL_ALIGN_LEFT);
	seed->selection_color(FL_BLUE);
	seed->maximum_size(6);
	seed->callback(callback_Seed, this);
	seed->value("1");

	bump = new Fl_Button(cx + cw - (60+KF*4), cy, 24+KF*4, 24+KF*2, "+");
	bump->labelsize(FL_NORMAL_SIZE+2);
	bump->callback(callback_Bump, this);

	add(seed);

	add(bump);

	cy += seed->h() + y_step;



	//  DebugPrintf("UI_Game: final h = %d\n", cy - y);

	resizable(0);  // don't resize our children


	length->SetID("episode");
}


//
// Destructor
//
UI_Game::~UI_Game()
{ }


void UI_Game::SetSeed(u32_t new_val)
{
	char num_buf[40];

	sprintf(num_buf, "%06d", new_val % 1000000);

	seed->value(num_buf);

	ob_set_config("seed", seed->value());
}


// the xor here is to prevent the first digit of seed being zero
#define TIME_CALC  (u32_t)time(NULL) ^ 0x44444444

void UI_Game::FreshSeed()
{
	u32_t val   = TIME_CALC;
	u32_t usage = IntHash(val) % 100;

	SetSeed((val/43200) * 100 + usage);
}


void UI_Game::StaleSeed(u32_t old_val)
{
	u32_t val   = TIME_CALC;
	u32_t usage = IntHash(val) % 100;

	// when the day is the same, simply Bump the old value
	if ((val/43200) % 10000 == (old_val/100) % 10000)
		usage = (old_val+1) % 100;

	SetSeed((val/43200) * 100 + usage);
}


void UI_Game::BumpSeed()
{
	u32_t val   = atoi(seed->value());
	u32_t usage = (val+1) % 100;

	SetSeed((val / 100) * 100 + usage);
}


void UI_Game::callback_Seed(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	ob_set_config("seed", that->seed->value());
}


void UI_Game::callback_Bump(Fl_Widget *w, void *data)
{
	UI_Game *that = (UI_Game *)data;

	that->BumpSeed();
}


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
		seed->deactivate();
		bump->deactivate();

		game->deactivate();
		mode->deactivate();
		length->deactivate();
		engine->deactivate();
	}
	else
	{
		seed->activate();
		bump->activate();

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

	FreshSeed();

	ParseValue("mode", "sp");
	ParseValue("length", "few");
}


bool UI_Game::ParseValue(const char *key, const char *value)
{
	// Note: game, engine are handled by LUA code
	//
	// Note 2: seed is handled specially in cookie code

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


const char *UI_Game::get_Seed()
{
	return seed->value();
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
