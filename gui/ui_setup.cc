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

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, 160, 24, "Settings");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;

  seed = new Fl_Int_Input(x+120, cy, 80, 24, "Random Seed: ");
  seed->align(FL_ALIGN_LEFT);
  seed->maximum_size(4);
  seed->value("1");

  add(seed);

  bump = new Fl_Button(x+208, cy, 96, 24, "New Seed");
  bump->callback(bump_callback, this);

  add(bump);

  cy += 32;

  game = new Fl_Choice(x+70, cy, 150, 24, "Game: ");
  game->align(FL_ALIGN_LEFT);
  game->add("Doom 1|"
            "Doom 2|"
            "TNT Evilution|"
            "Plutonia|"
            "FreeDoom|"
            "Heretic|"
            "Hexen");
  game->callback(game_callback, this);
  game->value(1);

  add(game);

  length = new Fl_Choice(x +300, cy, 150, 24, "Length: ");
  length->align(FL_ALIGN_LEFT);
  length->add("Single Level|One Episode|Full Game");
  length->value(1);

  add(length);

  cy += 32;

  addon = new Fl_Choice(x+70, cy, 150, 24, "Add-on: ");
  addon->align(FL_ALIGN_LEFT);
  addon->add("None"); //TODO: Eternal 3|Osiris|Gothic DM
  addon->value(0);
  
  add(addon);

  mode = new Fl_Choice(x+300, cy, 150, 24, "Mode: ");
  mode->align(FL_ALIGN_LEFT);
  mode->add("Single Player|Co-op|Deathmatch");
  mode->value(0);

  add(mode);

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

  sprintf(num_buf, "%04d", new_val % 10000);

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

  u32_t bump = 90 + (IntHash(old_val) & 255);

  SetSeed(old_val + bump);
}

void UI_Setup::bump_callback(Fl_Widget *w, void *data)
{
  UI_Setup *that = (UI_Setup *)data;

  that->BumpSeed();
}

void UI_Setup::game_callback(Fl_Widget *w, void *data)
{
#if 0
  UI_Setup *that = (UI_Setup *)data;

  if (that->game->value() == 1)
    that->addon->show();
  else
    that->addon->hide();
#endif
}

void UI_Setup::Locked(bool value)
{
  if (value)
  {
    seed->deactivate();
    bump->deactivate();

    game->deactivate();
    addon->deactivate();
    mode->deactivate();
    length->deactivate();
  }
  else
  {
    seed->activate();
    bump->activate();

    game->activate();
    addon->activate();
    mode->activate();
    length->activate();
  }
}

//----------------------------------------------------------------

const char * UI_Setup::game_syms[] =
{
  "doom1", "doom2", "tnt", "plutonia", "freedoom",
  "heretic", "hexen"
};

const char * UI_Setup::addon_syms[] =
{
  "none" /// , "eternal", "osiris", "gothic"
};

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

const char *UI_Setup::get_Addon()
{
  return addon_syms[addon->value()];
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
      return true;
    }
  }
  return false; // Unknown
}

bool UI_Setup::set_Addon(const char *str)
{
  for (int i=0; addon_syms[i]; i++)
  {
    if (StrCaseCmp(str, addon_syms[i]) == 0)
    {
      addon->value(i);
      return true;
    }
  }
  return false; // Unknown
}

bool UI_Setup::set_Mode(const char *str)
{
  for (int i=0; mode_syms[i]; i++)
  {
    if (StrCaseCmp(str, mode_syms[i]) == 0)
    {
      mode->value(i);
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

