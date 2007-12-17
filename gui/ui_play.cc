//----------------------------------------------------------------
//  Play Settings
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


#define MY_RED  fl_rgb_color(224,0,0)


//
// Constructor
//
UI_Play::UI_Play(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);


  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Playing Style");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;


  mons = new UI_RChoice(x+ 82, cy, 112, 24, "Monsters: ");
  mons->align(FL_ALIGN_LEFT);
  mons->selection_color(MY_RED);
  mons->callback(callback_Monsters, this);

  setup_Monsters();

  add(mons);

  cy += mons->h() + 6;


  puzzles = new UI_RChoice(x+ 82, cy, 112, 24, "Puzzles: ");
  puzzles->align(FL_ALIGN_LEFT);
  puzzles->selection_color(MY_RED);
  puzzles->callback(callback_Puzzles, this);

  setup_Puzzles();

  add(puzzles);

  cy += puzzles->h() + 6;


  traps = new UI_RChoice(x+ 82, cy, 112, 24, "Traps: ");
  traps->align(FL_ALIGN_LEFT);
  traps->selection_color(MY_RED);
  traps->callback(callback_Traps, this);

  setup_Traps();

  add(traps);

  cy += traps->h() + 6;

  cy += 10;


  health = new UI_RChoice(x+82, cy, 112, 24, "Health: ");
  health->align(FL_ALIGN_LEFT);
  health->selection_color(MY_RED);
  health->callback(callback_Health, this);

  setup_Health();

  add(health);

  cy += health->h() + 6;


  ammo = new UI_RChoice(x+82, cy, 112, 24, "Ammo: ");
  ammo->align(FL_ALIGN_LEFT);
  ammo->selection_color(MY_RED);
  ammo->callback(callback_Ammo, this);
 
  setup_Ammo();

  add(ammo);
  
  cy += ammo->h() + 6;


  DebugPrintf("UI_Play: final h = %d\n", cy - y);


  Signal_Watch("mode", notify_Mode, this);
}


//
// Destructor
//
UI_Play::~UI_Play()
{
}


void UI_Play::Locked(bool value)
{
  if (value)
  {
    mons  ->deactivate();
    puzzles->deactivate();
    traps ->deactivate();
    health->deactivate();
    ammo  ->deactivate();
  }
  else
  {
    mons  ->activate();
    puzzles->activate();
    traps ->activate();
    health->activate();
    ammo  ->activate();
  }
}


void UI_Play::notify_Mode(const char *name, void *priv_dat)
{
  if (! main_win)
    return;

  UI_Play *play = (UI_Play *)priv_dat;
  SYS_ASSERT(play);

  const char *mode = main_win->game_box->mode->GetID();

  if (strcmp(mode, "dm") == 0)
  {
    play->mons->label   ("Weapons: ");
    play->puzzles->label("Players: ");
    play->traps->label  ("Equip: ");
  }
  else
  {
    play->mons->label   ("Monsters: ");
    play->puzzles->label("Puzzles: ");
    play->traps->label  ("Traps: ");
  }

  play->redraw();
}


//----------------------------------------------------------------

void UI_Play::callback_Monsters(Fl_Widget *w, void *data)
{
  UI_Play *that = (UI_Play *) data;

  Script_SetConfig("mons", that->mons->GetID());
}

void UI_Play::callback_Puzzles(Fl_Widget *w, void *data)
{
  UI_Play *that = (UI_Play *) data;

  Script_SetConfig("puzzles", that->puzzles->GetID());
}

void UI_Play::callback_Traps(Fl_Widget *w, void *data)
{
  UI_Play *that = (UI_Play *) data;

  Script_SetConfig("traps", that->traps->GetID());
}

void UI_Play::callback_Health(Fl_Widget *w, void *data)
{
  UI_Play *that = (UI_Play *) data;

  Script_SetConfig("health", that->health->GetID());
}

void UI_Play::callback_Ammo(Fl_Widget *w, void *data)
{
  UI_Play *that = (UI_Play *) data;

  Script_SetConfig("ammo", that->ammo->GetID());
}

 
const char * UI_Play::GetAllValues()
{
  static const char *last_str = NULL;

  if (last_str)
    StringFree(last_str);

//!!!!  last_str = StringPrintf(
//!!!!      "mons = %s\n"  "puzzles = %s\n"
//!!!!      "traps = %s\n" "health = %s\n"
//!!!!      "ammo = %s\n",
//!!!!      get_Monsters(), get_Puzzles(),
//!!!!      get_Traps(),    get_Health(),
//!!!!      get_Ammo()
//!!!!  );

  return last_str;
}

bool UI_Play::ParseValue(const char *key, const char *value)
{
///  if (StringCaseCmp(key, "mons") == 0)
///    return set_Monsters(value);
///
///  if (StringCaseCmp(key, "puzzles") == 0)
///    return set_Puzzles(value);
///
///  if (StringCaseCmp(key, "traps") == 0)
///    return set_Traps(value);
///
///  if (StringCaseCmp(key, "health") == 0)
///    return set_Health(value);
///
///  if (StringCaseCmp(key, "ammo") == 0)
///    return set_Ammo(value);

  return false;
}

//----------------------------------------------------------------

const char * UI_Play::monster_syms[] =
{
  // also used for: Puzzles, Weapons and Players

  "mixed",  "Mix It Up",
  "low",    "Scarce",
  "less",   "Less",
  "normal", "Normal",
  "high",   "Hordes",

  NULL, NULL
};

const char * UI_Play::trap_syms[] =
{
  //_________Traps________Equip________

  "mixed",  "Mix It Up", "Mix It Up",
  "low",    "None",      "None",
  "less",   "Less",      "Small",
  "normal", "Normal",    "Medium",
  "high",   "Heaps",     "Large",

  NULL, NULL
};

const char * UI_Play::health_syms[] =
{
  // also used for: Ammo

  "low",    "Scarce",
  "less",   "Less",
  "normal", "Normal",
  "more",   "More",
  "high",   "Heaps",

  NULL, NULL
};

void UI_Play::setup_Monsters()
{
  for (int i = 0; monster_syms[i]; i += 2)
    mons->AddPair(monster_syms[i], monster_syms[i+1]);

  mons->Recreate();
}

void UI_Play::setup_Puzzles()
{
  for (int i = 0; monster_syms[i]; i += 2)
    puzzles->AddPair(monster_syms[i], monster_syms[i+1]);

  puzzles->Recreate();
}

void UI_Play::setup_Traps()
{
  for (int i = 0; trap_syms[i]; i += 3)
    traps->AddPair(trap_syms[i], trap_syms[i+2]);

  traps->Recreate();
}

void UI_Play::setup_Health()
{
  for (int i = 0; health_syms[i]; i += 2)
    health->AddPair(health_syms[i], health_syms[i+1]);

  health->Recreate();
}

void UI_Play::setup_Ammo()
{
  for (int i = 0; health_syms[i]; i += 2)
    ammo->AddPair(health_syms[i], health_syms[i+1]);

  ammo->Recreate();
}

