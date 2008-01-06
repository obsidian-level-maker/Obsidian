//----------------------------------------------------------------
//  Setup screen
//----------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Game Settings");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += heading->h() + 6;


  seed = new Fl_Int_Input(x+66, cy, 60, 24, "Seed: ");
  seed->align(FL_ALIGN_LEFT);
  seed->selection_color(FL_BLUE);
  seed->maximum_size(5);
  seed->value("1");

  add(seed);

  bump = new Fl_Button(x+134, cy, 66, 24, "Bump");
  bump->callback(callback_Bump, this);

  add(bump);

  cy += seed->h() + 6;

  cy += 10;


  game = new UI_RChoice(x+68, cy, 130, 24, "Game: ");
  game->align(FL_ALIGN_LEFT);
  game->selection_color(FL_BLUE);
  game->callback(callback_Game, this);

  add(game);
  
  cy += game->h() + 6;


  mode = new UI_RChoice(x+68, cy, 130, 24, "Mode: ");
  mode->align(FL_ALIGN_LEFT);
  mode->selection_color(FL_BLUE);
///---  mode->add("Single Player|Co-op|Deathmatch");
///---  mode->value(0);
  mode->callback(callback_Mode, this);

  setup_Mode();

  add(mode);

  cy += mode->h() + 6;

  cy += 10;


  engine = new UI_RChoice(x+68, cy, 130, 24, "Engine: ");
  engine->align(FL_ALIGN_LEFT);
  engine->selection_color(FL_BLUE);
  engine->callback(callback_Engine, this);

  add(engine);

  cy += engine->h() + 6;


  length = new UI_RChoice(x +68, cy, 130, 24, "Length: ");
  length->align(FL_ALIGN_LEFT);
  length->selection_color(FL_BLUE);
///---  length->add("Single Level|One Episode|Full Game");
///---  length->value(1);
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
}

void UI_Game::FreshSeed()
{
  u32_t bump = TimeGetMillies();

  bump = IntHash(bump);
  
  SetSeed(bump);
}

void UI_Game::BumpSeed()
{
  u32_t old_val = atoi(seed->value());

  u32_t bump = 100 + (IntHash(old_val) & 255);

  SetSeed(old_val + bump);
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
  Signal_Raise("length");
}

void UI_Game::Defaults()
{
  // Note: game, engine are handled by LUA code (ob_init)

  FreshSeed();

  mode  ->SetID("sp");
  length->SetID("episode");
  
  Script_SetConfig("mode",   mode->GetID());
  Script_SetConfig("length", length->GetID());
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


//----------------------------------------------------------------

void UI_Game::TransferToLUA()
{
#if 0
  Script_SetConfig("seed",   get_Seed());
  Script_SetConfig("game",   get_Game());
  Script_SetConfig("mode",   get_Mode());
  Script_SetConfig("engine", get_Engine());
  Script_SetConfig("length", get_Length());
#endif
}
 
const char * UI_Game::GetAllValues()
{
  static const char *last_str = NULL;

  if (last_str)
    StringFree(last_str);

//!!!!  last_str = StringPrintf(
//!!!!      "seed = %s\n"  "game = %s\n"
//!!!!      "mode = %s\n"  "engine = %s\n"
//!!!!      "length = %s\n",
//!!!!      get_Seed(), get_Game(),
//!!!!      get_Mode(), get_Engine(),
//!!!!      get_Length()
//!!!!  );

  return last_str;
}

bool UI_Game::ParseValue(const char *key, const char *value)
{
///  if (StringCaseCmp(key, "seed") == 0)
///    return set_Seed(value);
///
///  if (StringCaseCmp(key, "game") == 0)
///    return set_Game(value);
///
///  if (StringCaseCmp(key, "mode") == 0)
///    return set_Mode(value);
///
///  if (StringCaseCmp(key, "engine") == 0)
///    return set_Engine(value);
///
///  if (StringCaseCmp(key, "length") == 0)
///    return set_Length(value);

  return false;
}


//----------------------------------------------------------------

const char * UI_Game::mode_syms[] =
{
  "sp",   "Single Player",
  "coop", "Co-op",
  "dm",   "Deathmatch",

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
    mode->AddPair(mode_syms[i], mode_syms[i+1]);

  mode->Recreate();
}

void UI_Game::setup_Length()
{
  for (int i = 0; length_syms[i]; i += 2)
    length->AddPair(length_syms[i], length_syms[i+1]);

  length->Recreate();
}

const char *UI_Game::get_Seed()
{
  return seed->value();
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
