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

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, 160, 24, "Adjustments");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += 28;

#if 1
  health = new Fl_Choice(x+70, cy, 130, 24, "Health: ");
  health->align(FL_ALIGN_LEFT);
  health->add("Less|Normal|More");
  health->value(1);

#else  // SLIDER version (looks shite -- cannot set knob color)

  health = new Fl_Slider(x+90, cy, 100, 16, "Health:   ");
  health->align(FL_ALIGN_LEFT);
  health->type(FL_HOR_NICE_SLIDER);
  health->box(FL_FLAT_BOX);
  health->color(fl_gray_ramp(10)); // fl_color_cube(2,5,4));
  health->selection_color(FL_BLUE);

  health->slider_size(0.3);
  health->range(0,2);
  health->step(1);
  health->value(1);
#endif

  add(health);

  mons = new Fl_Choice(x+300, cy, 150, 24, "Monsters: ");
  mons->align(FL_ALIGN_LEFT);
  mons->add("Scarce|Less|Normal|More|Jam-packed");
  mons->value(2);

  add(mons);

  cy += 32;

  ammo = new Fl_Choice(x+70, cy, 130, 24, "Ammo: ");
  ammo->align(FL_ALIGN_LEFT);
  ammo->add("Less|Normal|More");
  ammo->value(1);
  
  add(ammo);

  traps = new Fl_Choice(x+300, cy, 150, 24, "Traps: ");
  traps->align(FL_ALIGN_LEFT);
  traps->add("Scarce|Less|Normal|More|Jam-packed");
  traps->value(2);

  add(traps);

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
    health->deactivate();
    ammo->deactivate();
    mons->deactivate();
    traps->deactivate();
  }
  else
  {
    health->activate();
    ammo->activate();
    mons->activate();
    traps->activate();
  }
}

//----------------------------------------------------------------

const char * UI_Adjust::adjust_syms[5] =
{
  "scarce", "less", "normal", "more", "heaps"
};

const char *UI_Adjust::get_Health()
{
  return adjust_syms[1 + health->value()];
}

const char *UI_Adjust::get_Ammo()
{
  return adjust_syms[1 + ammo->value()];
}

const char *UI_Adjust::get_Monsters()
{
  return adjust_syms[mons->value()];
}

const char *UI_Adjust::get_Traps()
{
  return adjust_syms[traps->value()];
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

  if (1 <= i && i <= 3) { health->value(i-1); return true; }

  return false;
}

bool UI_Adjust::set_Ammo(const char *str)
{
  int i = FindSym(str);

  if (1 <= i && i <= 3) { ammo->value(i-1); return true; }

  return false;
}

bool UI_Adjust::set_Monsters(const char *str)
{
  int i = FindSym(str);

  if (i >= 0) { mons->value(i); return true; }

  return false;
}

bool UI_Adjust::set_Traps(const char *str)
{
  int i = FindSym(str);

  if (i >= 0) { traps->value(i); return true; }

  return false;
}

