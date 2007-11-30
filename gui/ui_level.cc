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

#include "ui_level.h"
#include "ui_window.h"

#include "lib_util.h"


//
// Constructor
//
UI_Level::UI_Level(int x, int y, int w, int h, const char *label) :
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
  size->selection_color(FL_GREEN);
  size->add("Small|Regular|X-Large");
  size->value(1);

  add(size);

  cy += size->h() + 6;

  cy += 10;


  theme = new Fl_Choice(x+ 82, cy, 112, 24, "Theme: ");
  theme->align(FL_ALIGN_LEFT);
  theme->selection_color(FL_GREEN);
  theme->add("Mixture|Hell|Nature|Tech|Urban");
  theme->value(0);

  add(theme);

  cy += theme->h() + 6;


  detail = new Fl_Choice(x+ 82, cy, 112, 24, "Detail: ");
  detail->align(FL_ALIGN_LEFT);
  detail->selection_color(FL_GREEN);
  detail->add("None|Low|Medium|High");
  detail->value(2);

  add(detail);

  cy += detail->h() + 6;

  cy += 10;


  heights = new Fl_Choice(x+ 82, cy, 112, 24, "Heights: ");
  heights->align(FL_ALIGN_LEFT);
  heights->selection_color(FL_GREEN);
  heights->add("Flat|Gentle|Normal|Wild");
  heights->value(1);

  add(heights);

  cy += heights->h() + 6;


  yyy = new Fl_Choice(x+ 82, cy, 112, 24, "YYY: ");
  yyy->align(FL_ALIGN_LEFT);
  yyy->selection_color(FL_GREEN);
  yyy->add("Few|Normal|Heaps");
  yyy->value(1);

  add(yyy);

  cy += yyy->h() + 6;


  DebugPrintf("UI_Level: final h = %d\n", cy - y);

  resizable(0);  // don't resize our children
}


//
// Destructor
//
UI_Level::~UI_Level()
{
}

void UI_Level::Locked(bool value)
{
  if (value)
  {
    size  ->deactivate();
    theme ->deactivate();
    detail->deactivate();
    heights->deactivate();
    yyy   ->deactivate();
  }
  else
  {
    size  ->activate();
    theme ->activate();
    detail->activate();
    heights->activate();
    yyy   ->activate();
  }
}


//----------------------------------------------------------------

const char * UI_Level::adjust_syms[3] =
{
  "less", "normal", "more"
};

const char * UI_Level::size_syms[3] =
{
  "small", "regular", "large"
};


const char *UI_Level::get_Size()
{
  return size_syms[size->value()];
}

const char *UI_Level::get_Theme()  // FIXME
{
  return adjust_syms[1];
}

const char *UI_Level::get_Detail()  // FIXME
{
  return adjust_syms[1];
}

const char *UI_Level::get_Heights()  // FIXME
{
  return adjust_syms[1];
}


//----------------------------------------------------------------

int UI_Level::FindSym(const char *str)
{
  for (int i=0; adjust_syms[i]; i++)
    if (StrCaseCmp(str, adjust_syms[i]) == 0)
      return i;

  return -1; // Unknown
}


bool UI_Level::set_Size(const char *str)
{
  for (int i=0; size_syms[i]; i++)
    if (StrCaseCmp(str, size_syms[i]) == 0)
    {
      size->value(i); return true;
    }

  return false;
}

bool UI_Level::set_Theme(const char *str)
{
  // TODO !!! set_Theme
  return true;
}

bool UI_Level::set_Detail(const char *str)
{
  // TODO !!! set_Detail
  return true;
}

bool UI_Level::set_Heights(const char *str)
{
  // TODO !!! set_Heights
  return true;
}

