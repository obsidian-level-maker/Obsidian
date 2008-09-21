//----------------------------------------------------------------
//  Setup screen
//----------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

#include "g_lua.h"
#include "lib_signal.h"
#include "lib_util.h"


//
// Constructor
//
UI_Game::UI_Game(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);
//  align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);
  color(BUILD_BG, BUILD_BG); //!!!!

  int cy = y + 6;

  Fl_Box *heading = new Fl_Box(FL_NO_BOX, x+6, cy, w-12, 24, "Game Settings");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += heading->h() + 6;


  seed = new Fl_Int_Input(x+66, cy, 60, 24, "Seed: ");
  seed->align(FL_ALIGN_LEFT);
  seed->selection_color(FL_BLUE);
  seed->maximum_size(5);
  seed->callback(callback_Seed, this);
  seed->value("1");

  add(seed);

  bump = new Fl_Button(x+136, cy, 66, 24, "Bump");
  bump->callback(callback_Bump, this);

  add(bump);

  cy += seed->h() + 6;

  cy += 10;


  game = new UI_RChoice(x+66, cy, 130, 24, "Game: ");
  game->align(FL_ALIGN_LEFT);
  game->selection_color(FL_BLUE);
  game->callback(callback_Game, this);

  add(game);
  
  cy += game->h() + 6;


  engine = new UI_RChoice(x+66, cy, 130, 24, "Engine: ");
  engine->align(FL_ALIGN_LEFT);
  engine->selection_color(FL_BLUE);
  engine->callback(callback_Engine, this);

  add(engine);

  cy += engine->h() + 6;

  cy += 10;


  mode = new UI_RChoice(x+66, cy, 130, 24, "Mode: ");
  mode->align(FL_ALIGN_LEFT);
  mode->selection_color(FL_BLUE);
///---  mode->add("Single Player|Co-op|Deathmatch");
///---  mode->value(0);
  mode->callback(callback_Mode, this);

  setup_Mode();

  add(mode);

  cy += mode->h() + 6;


  length = new UI_RChoice(x +66, cy, 130, 24, "Length: ");
  length->align(FL_ALIGN_LEFT);
  length->selection_color(FL_BLUE);
  length->callback(callback_Length, this);

  setup_Length();

  add(length);

  cy += length->h() + 6;


  DebugPrintf("UI_Game: final h = %d\n", cy - y);

  resizable(0);  // don't resize our children


  length->SetID("episode");
}


//
// Destructor
//
UI_Game::~UI_Game()
{
}

void UI_Game::SetSeed(u32_t new_val)
{
  char num_buf[40];

  sprintf(num_buf, "%05d", new_val % 100000);

  seed->value(num_buf);

  Script_SetConfig("seed", seed->value());
}

void UI_Game::FreshSeed()
{
  u32_t val = (u32_t)time(NULL);

  SetSeed((val/86400)*1000 + (val/11)%500);
}

void UI_Game::BumpSeed()
{
  u32_t val = atoi(seed->value());

  val += 7 + (IntHash(TimeGetMillies()) % 25);

  SetSeed(val);
}

void UI_Game::callback_Seed(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  Script_SetConfig("seed", that->seed->value());
}

void UI_Game::callback_Bump(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  that->BumpSeed();
}

void UI_Game::callback_Game(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  Script_SetConfig("game", that->game->GetID());
  Signal_Raise("game");
}

void UI_Game::callback_Mode(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  Script_SetConfig("mode", that->mode->GetID());
  Signal_Raise("mode");
}

void UI_Game::callback_Engine(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  Script_SetConfig("engine", that->engine->GetID());
  Signal_Raise("engine");
}

void UI_Game::callback_Length(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  Script_SetConfig("length", that->length->GetID());
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
  ParseValue("length", "single");
}

bool UI_Game::ParseValue(const char *key, const char *value)
{
  // Note: game, engine are handled by LUA code
 
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
  "dm",   "Deathmatch",
// "ctf",  "Capture Flag",

  NULL, NULL
};

const char * UI_Game::length_syms[] =
{
  "single",  "Single Level",
  "episode", "One Episode",
  "full",    "Full Game",

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
// vi:ts=2:sw=2:expandtab
