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

#include "ui_setup.h"
#include "ui_window.h"

#include "lib_util.h"


//
// Setup Constructor
//
UI_Setup::UI_Setup(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);
//  align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);

  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, 160, 24, "Game Settings");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += heading->h() + 6;


  seed = new Fl_Int_Input(x+68, cy, 60, 24, "Seed: ");
  seed->align(FL_ALIGN_LEFT);
  seed->maximum_size(5);
  seed->value("1");

  add(seed);

  bump = new Fl_Button(x+140, cy, 66, 24, "Bump");
  bump->callback(bump_callback, this);

  add(bump);

  cy += seed->h() + 6;

  cy += 10;


  game = new Fl_Choice(x+68, cy, 130, 24, "Game: ");
  game->align(FL_ALIGN_LEFT);
  game->add("Wolf 3d|"
///         "Spear of Destiny|"
            "Doom 1|"
            "Doom 2|"
            "TNT Evilution|"
            "Plutonia|"
            "FreeDoom 0.5|"
            "Heretic|"
            "Hexen");
  game->value(2);
  game->callback(game_callback, this);

  add(game);
  
  cy += game->h() + 6;


  mode = new Fl_Choice(x+68, cy, 130, 24, "Mode: ");
  mode->align(FL_ALIGN_LEFT);
  mode->add("Single Player|Co-op|Deathmatch");
  mode->value(0);
  mode->callback(mode_callback, this);

  add(mode);

  cy += mode->h() + 6;

  cy += 10;


  engine = new Fl_Choice(x+68, cy, 130, 24, "Engine: ");
  engine->align(FL_ALIGN_LEFT);
  engine->add("Limit Removing"); //TODO: BOOM|EDGE|Legacy|JDoom|ZDoom
  engine->value(0);

  add(engine);

  cy += engine->h() + 6;


  length = new Fl_Choice(x +68, cy, 130, 24, "Length: ");
  length->align(FL_ALIGN_LEFT);
  length->add("Single Level|One Episode|Full Game");
  length->value(1);

  add(length);

  cy += length->h() + 6;


  DebugPrintf("UI_Setup: final h = %d\n", cy - y);

  resizable(0);  // don't resize our children

  FreshSeed();
}


//
// Setup Destructor
//
UI_Setup::~UI_Setup()
{
}

void UI_Setup::SetSeed(u32_t new_val)
{
  char num_buf[40];

  sprintf(num_buf, "%05d", new_val % 100000);

  seed->value(num_buf);
}

void UI_Setup::FreshSeed()
{
  u32_t bump = TimeGetMillies();

  bump = IntHash(bump);
  
  SetSeed(bump);
}

void UI_Setup::BumpSeed()
{
  u32_t old_val = atoi(seed->value());

  u32_t bump = 100 + (IntHash(old_val) & 255);

  SetSeed(old_val + bump);
}

void UI_Setup::bump_callback(Fl_Widget *w, void *data)
{
  UI_Setup *that = (UI_Setup *)data;

  that->BumpSeed();
}

void UI_Setup::game_callback(Fl_Widget *w, void *data)
{
  UI_Setup *that = (UI_Setup *)data;

  // multiplayer is not supported in Wolf3d / SOD
  if (strcmp(that->get_Game(), "wolf3d") == 0 ||
      strcmp(that->get_Game(), "spear")  == 0)
  {
    that->mode->value(0);
    mode_callback(that, that);

    that->mode->deactivate();
  }
  else
    that->mode->activate();

  if (main_win)
  {
    main_win->adjust_box->UpdateLabels(that->get_Game(), that->get_Mode());
  }
}

void UI_Setup::mode_callback(Fl_Widget *w, void *data)
{
  UI_Setup *that = (UI_Setup *)data;

  if (main_win)
  {
    main_win->adjust_box->UpdateLabels(that->get_Game(), that->get_Mode());
  }
}

void UI_Setup::Locked(bool value)
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

    game_callback(this, this);
    mode_callback(this, this);
  }
}

//----------------------------------------------------------------

const char * UI_Setup::game_syms[] =
{
  "wolf3d", /// "spear",
  "doom1", "doom2", "tnt", "plutonia", "freedoom",
  "heretic", "hexen"
};

///--- const char * UI_Setup::port_syms[] =
///--- {
///---   "nolimit" /// , "boom", "edge", "zdoom", etc..
///--- };

const char * UI_Setup::mode_syms[] =
{
  "sp", "coop", "dm"
};

const char * UI_Setup::length_syms[] =
{
  "single", "episode", "full"
};


const char *UI_Setup::get_Seed()
{
  return seed->value();
}

const char *UI_Setup::get_Game()
{
  return game_syms[game->value()];
}

const char *UI_Setup::get_Engine()
{
  return "nolimit";  // FIXME !!!!
}

const char *UI_Setup::get_Mode()
{
  return mode_syms[mode->value()];
}

const char *UI_Setup::get_Length()
{
  return length_syms[length->value()];
}

//----------------------------------------------------------------

bool UI_Setup::set_Seed(const char *str)
{
  seed->value(str);

  return true;
}

bool UI_Setup::set_Game(const char *str)
{
  for (int i=0; game_syms[i]; i++)
  {
    if (StrCaseCmp(str, game_syms[i]) == 0)
    {
      game->value(i);
      game_callback(this, this);
      return true;
    }
  }
  return false; // Unknown
}

bool UI_Setup::set_Engine(const char *str)
{
#if 0 // FIXME !!!
  for (int i=0; port_syms[i]; i++)
  {
    if (StrCaseCmp(str, port_syms[i]) == 0)
    {
      port->value(i);
      return true;
    }
  }
#endif
  return false; // Unknown
}

bool UI_Setup::set_Mode(const char *str)
{
  for (int i=0; mode_syms[i]; i++)
  {
    if (StrCaseCmp(str, mode_syms[i]) == 0)
    {
      mode->value(i);

      mode_callback(this, this);
      game_callback(this, this);
      return true;
    }
  }
  return false; // Unknown
}

bool UI_Setup::set_Length(const char *str)
{
  for (int i=0; length_syms[i]; i++)
  {
    if (StrCaseCmp(str, length_syms[i]) == 0)
    {
      length->value(i);
      return true;
    }
  }
  return false; // Unknown
}

