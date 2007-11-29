//----------------------------------------------------------------
//  Adjustment screen
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

#include "ui_adjust.h"
#include "ui_window.h"

#include "lib_util.h"


//
// Adjust Constructor
//
UI_Adjust::UI_Adjust(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);
//  align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);

  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Level Adjustments");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += heading->h() + 6;


  size = new Fl_Choice(x+ 82, cy, 112, 24, "Size: ");
  size->align(FL_ALIGN_LEFT);
  size->selection_color(FL_RED);
  size->add("Small|Regular|X-Large");
  size->value(1);

  add(size);

  cy += size->h() + 6;


  detail = new Fl_Choice(x+ 82, cy, 112, 24, "Detail: ");
  detail->align(FL_ALIGN_LEFT);
  detail->selection_color(FL_RED);
  detail->add("None|Low|Medium|High");
  detail->value(2);

  add(detail);

  cy += detail->h() + 6;

  cy += 10;


  mons = new Fl_Choice(x+ 82, cy, 112, 24, "Monsters: ");
  mons->align(FL_ALIGN_LEFT);
  mons->selection_color(FL_RED);
  mons->add("Scarce|Normal|Hordes");
  mons->value(1);

  add(mons);

  cy += mons->h() + 6;


  puzzles = new Fl_Choice(x+ 82, cy, 112, 24, "Puzzles: ");
  puzzles->align(FL_ALIGN_LEFT);
  puzzles->selection_color(FL_RED);
  puzzles->add("Few|Normal|Heaps");
  puzzles->value(1);

  add(puzzles);

  cy += puzzles->h() + 6;


  traps = new Fl_Choice(x+ 82, cy, 112, 24, "Traps: ");
  traps->align(FL_ALIGN_LEFT);
  traps->selection_color(FL_RED);
  traps->add("Few|Normal|Heaps");
  traps->value(1);

  add(traps);

  cy += traps->h() + 6;

  cy += 10;


  health = new Fl_Choice(x+82, cy, 112, 24, "Health: ");
  health->align(FL_ALIGN_LEFT);
  health->selection_color(FL_RED);
  health->add("Less|Enough|More");
  health->value(1);

  add(health);

  cy += health->h() + 6;


  ammo = new Fl_Choice(x+82, cy, 112, 24, "Ammo: ");
  ammo->align(FL_ALIGN_LEFT);
  ammo->selection_color(FL_RED);
  ammo->add("Less|Enough|More");
  ammo->value(1);
  
  add(ammo);
  
  cy += ammo->h() + 6;


  DebugPrintf("UI_Adjust: final h = %d\n", cy - y);

  resizable(0);  // don't resize our children
}


//
// Adjust Destructor
//
UI_Adjust::~UI_Adjust()
{
}

void UI_Adjust::Locked(bool value)
{
  if (value)
  {
    size ->deactivate();
    health->deactivate();
    ammo ->deactivate();
    mons ->deactivate();
    puzzles->deactivate();
  }
  else
  {
    size ->activate();
    health->activate();
    ammo ->activate();
    mons ->activate();
    puzzles->activate();
  }
}

void UI_Adjust::UpdateLabels(const char *game, const char *mode)
{
  if (strcmp(mode, "dm") == 0)
  {
    mons->label("Players: ");
    puzzles->label("Weapons: ");
  }
  else
  {
    mons->label("Monsters: ");

    if (strcmp(game, "wolf3d") == 0 || strcmp(game, "spear") == 0)
      puzzles->label("Bosses: ");
    else
      puzzles->label("Puzzles: ");
  }

  SYS_ASSERT(main_win);

  main_win->adjust_box->redraw();
}

//----------------------------------------------------------------

const char * UI_Adjust::adjust_syms[3] =
{
  "less", "normal", "more"
};

const char * UI_Adjust::size_syms[3] =
{
  "small", "regular", "large"
};

const char *UI_Adjust::get_Health()
{
  return adjust_syms[health->value()];
}

const char *UI_Adjust::get_Ammo()
{
  return adjust_syms[ammo->value()];
}

const char *UI_Adjust::get_Monsters()
{
  return adjust_syms[mons->value()];
}

const char *UI_Adjust::get_Traps()
{
  return adjust_syms[1];  // TODO
}

const char *UI_Adjust::get_Puzzles()
{
  return adjust_syms[puzzles->value()];
}

const char *UI_Adjust::get_Size()
{
  return size_syms[size->value()];
}

//----------------------------------------------------------------

int UI_Adjust::FindSym(const char *str)
{
  for (int i=0; adjust_syms[i]; i++)
    if (StrCaseCmp(str, adjust_syms[i]) == 0)
      return i;

  return -1; // Unknown
}

bool UI_Adjust::set_Health(const char *str)
{
  int i = FindSym(str);

  if (i >= 0) { health->value(i); return true; }

  return false;
}

bool UI_Adjust::set_Ammo(const char *str)
{
  int i = FindSym(str);

  if (i >= 0) { ammo->value(i); return true; }

  return false;
}

bool UI_Adjust::set_Monsters(const char *str)
{
  int i = FindSym(str);

  if (i >= 0) { mons->value(i); return true; }

  return false;
}

bool UI_Adjust::set_Puzzles(const char *str)
{
  int i = FindSym(str);

  if (i >= 0) { puzzles->value(i); return true; }

  return false;
}

bool UI_Adjust::set_Traps(const char *str)
{
  // TODO !!! set_Traps
  return true;
}

bool UI_Adjust::set_Size(const char *str)
{
  for (int i=0; size_syms[i]; i++)
    if (StrCaseCmp(str, size_syms[i]) == 0)
    {
      size->value(i); return true;
    }

  return false;
}

