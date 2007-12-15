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
  bump->callback(bump_callback, this);

  add(bump);

  cy += seed->h() + 6;

  cy += 10;


  game = new UI_RChoice(x+68, cy, 130, 24, "Game: ");
  game->align(FL_ALIGN_LEFT);
  game->selection_color(FL_BLUE);

///---  game->add("Wolf 3d|"
///---            "Doom 1|"
///---            "Doom 2|"
///---            "TNT Evilution|"
///---            "Plutonia|"
///---            "FreeDoom 0.5|"
///---            "Heretic|"
///---            "Hexen");
///---  game->value(2);
  game->callback(game_callback, this);

  add(game);
  
  cy += game->h() + 6;


  mode = new Fl_Choice(x+68, cy, 130, 24, "Mode: ");
  mode->align(FL_ALIGN_LEFT);
  mode->selection_color(FL_BLUE);
  mode->add("Single Player|Co-op|Deathmatch");
  mode->value(0);
  mode->callback(mode_callback, this);

  add(mode);

  cy += mode->h() + 6;

  cy += 10;


  engine = new UI_RChoice(x+68, cy, 130, 24, "Engine: ");
  engine->align(FL_ALIGN_LEFT);
  engine->selection_color(FL_BLUE);
///---  engine->value(0);

///---  engine->BeginUpdate();
///---  engine->AddPair("nolimit", "Limit Removing");
///---  engine->AddPair("boom", "Boom Compat");
///---  engine->AddPair("edge", "EDGE");
///---  engine->EndUpdate();

  add(engine);

  cy += engine->h() + 6;


  length = new Fl_Choice(x +68, cy, 130, 24, "Length: ");
  length->align(FL_ALIGN_LEFT);
  length->selection_color(FL_BLUE);
  length->add("Single Level|One Episode|Full Game");
  length->value(1);

  add(length);

  cy += length->h() + 6;


  DebugPrintf("UI_Game: final h = %d\n", cy - y);

  resizable(0);  // don't resize our children

  FreshSeed();
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

void UI_Game::bump_callback(Fl_Widget *w, void *data)
{
  UI_Game *that = (UI_Game *)data;

  that->BumpSeed();
}

void UI_Game::game_callback(Fl_Widget *w, void *data)
{
  Signal_Raise("game");

///---  UI_Game *that = (UI_Game *)data;
///---
///---  if (main_win)
///---  {
///---    Script_UpdateEngine();
///---    Script_UpdateTheme();
///--- 
///---    main_win->play_box->UpdateLabels(that->get_Game(), that->get_Mode());
///---  }
}

void UI_Game::mode_callback(Fl_Widget *w, void *data)
{
  Signal_Raise("mode");

///---  UI_Game *that = (UI_Game *)data;
///---
///---  if (main_win)
///---  {
///---    Script_UpdateEngine();
///---    Script_UpdateTheme();
///---
///---    main_win->play_box->UpdateLabels(that->get_Game(), that->get_Mode());
///---  }
}

void UI_Game::engine_callback(Fl_Widget *w, void *data)
{
  Signal_Raise("engine");

///---  UI_Game *that = (UI_Game *)data;
///---
///---  if (main_win)
///---  {
///---    Script_UpdateTheme();
///---  }
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
  Script_AddSetting("seed",   get_Seed());
  Script_AddSetting("game",   get_Game());
  Script_AddSetting("mode",   get_Mode());
  Script_AddSetting("engine", get_Engine());
  Script_AddSetting("length", get_Length());
}
 
const char * UI_Game::GetAllValues()
{
  static const char *last_str = NULL;

  if (last_str)
    StringFree(last_str);

  last_str = StringPrintf(
      "seed = %s\n"  "game = %s\n"
      "mode = %s\n"  "engine = %s\n"
      "length = %s\n",
      get_Seed(), get_Game(),
      get_Mode(), get_Engine(),
      get_Length()
  );

  return last_str;
}

bool UI_Game::ParseValue(const char *key, const char *value)
{
  if (StringCaseCmp(key, "seed") == 0)
    return set_Seed(value);

  if (StringCaseCmp(key, "game") == 0)
    return set_Game(value);

  if (StringCaseCmp(key, "mode") == 0)
    return set_Mode(value);

  if (StringCaseCmp(key, "engine") == 0)
    return set_Engine(value);

  if (StringCaseCmp(key, "length") == 0)
    return set_Length(value);

  return false;
}


//----------------------------------------------------------------
  
const char * UI_Game::game_syms[] =
{
  "wolf3d", /// "spear",
  "doom1", "doom2", "tnt", "plutonia", "freedoom",
  "heretic", "hexen"
};

///--- const char * UI_Game::port_syms[] =
///--- {
///---   "nolimit" /// , "boom", "edge", "zdoom", etc..
///--- };

const char * UI_Game::mode_syms[] =
{
  "sp", "coop", "dm"
};

const char * UI_Game::length_syms[] =
{
  "single", "episode", "full"
};


const char *UI_Game::get_Seed()
{
  return seed->value();
}

const char *UI_Game::get_Game()
{
  return "doom2"; //!!!! FIXME game_syms[game->value()];
}

const char *UI_Game::get_Engine()
{
  return "nolimit";  // FIXME !!!!
}

const char *UI_Game::get_Mode()
{
  return mode_syms[mode->value()];
}

const char *UI_Game::get_Length()
{
  return length_syms[length->value()];
}

//----------------------------------------------------------------

bool UI_Game::set_Seed(const char *str)
{
  seed->value(str);

  return true;
}

bool UI_Game::set_Game(const char *str)
{
  for (int i=0; game_syms[i]; i++)
  {
    if (StringCaseCmp(str, game_syms[i]) == 0)
    {
      game->value(i);
//!!!!!!      game_callback(this, this);
      return true;
    }
  }
  return false; // Unknown
}

bool UI_Game::set_Engine(const char *str)
{
#if 0 // FIXME !!!
  for (int i=0; port_syms[i]; i++)
  {
    if (StringCaseCmp(str, port_syms[i]) == 0)
    {
      port->value(i);
      return true;
    }
  }
#endif
  return false; // Unknown
}

bool UI_Game::set_Mode(const char *str)
{
  for (int i=0; mode_syms[i]; i++)
  {
    if (StringCaseCmp(str, mode_syms[i]) == 0)
    {
      mode->value(i);

//!!!!!!      mode_callback(this, this);
//!!!!!!      game_callback(this, this);
      return true;
    }
  }
  return false; // Unknown
}

bool UI_Game::set_Length(const char *str)
{
  for (int i=0; length_syms[i]; i++)
  {
    if (StringCaseCmp(str, length_syms[i]) == 0)
    {
      length->value(i);
      return true;
    }
  }
  return false; // Unknown
}

