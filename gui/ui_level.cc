//----------------------------------------------------------------
//  Level Architecture
//----------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#include "lib_util.h"
#include "m_lua.h"
#include "main.h"


#define MY_GREEN  fl_rgb_color(0,166,0)


//
// Constructor
//
UI_Level::UI_Level(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);

  if (! alternate_look)
    color(BUILD_BG, BUILD_BG);


  int y_step = 6 + KF;

  int cx = x + 84 + KF * 11;
  int cy = y + y_step + KF * 3;

  Fl_Box *heading = new Fl_Box(FL_NO_BOX, x+6, cy, w-12, 24, "Level Architecture");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);
  heading->labelsize(FL_NORMAL_SIZE + 2);

  add(heading);

  cy += heading->h() + y_step;


  int cw = 114 + KF * 12;
  int ch = 24 + KF * 2;

  size = new UI_RChoice(cx, cy, cw, ch, "Size: ");
  size->align(FL_ALIGN_LEFT);
  size->selection_color(MY_GREEN);
  size->callback(callback_Size, this);

  setup_Size();

  add(size);

  cy += size->h() + y_step;

  cy += y_step + y_step/2;


  theme = new UI_RChoice(cx, cy, cw, ch, "Theme: ");
  theme->align(FL_ALIGN_LEFT);
  theme->selection_color(MY_GREEN);
  theme->callback(callback_Theme, this);

  add(theme);

  cy += theme->h() + y_step;


  outdoors = new UI_RChoice(cx, cy, cw, ch, "Outdoors: ");
  outdoors->align(FL_ALIGN_LEFT);
  outdoors->selection_color(MY_GREEN);
  outdoors->callback(callback_Outdoors, this);

  setup_Outdoors();

  add(outdoors);

  cy += outdoors->h() + y_step;

  cy += y_step + y_step/2;


  secrets = new UI_RChoice(cx, cy, cw, ch, "Secrets: ");
  secrets->align(FL_ALIGN_LEFT);
  secrets->selection_color(MY_GREEN);
  secrets->callback(callback_Secrets, this);

  setup_Secrets();

  add(secrets);

  cy += secrets->h() + y_step;


  traps = new UI_RChoice(cx, cy, cw, ch, "Traps: ");
  traps->align(FL_ALIGN_LEFT);
  traps->selection_color(MY_GREEN);
  traps->callback(callback_Traps, this);

  setup_Traps();

  add(traps);

  cy += traps->h() + y_step;


//  DebugPrintf("UI_Level: final h = %d\n", cy - y);

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
    theme->deactivate();
    size ->deactivate();

    outdoors->deactivate();
    secrets ->deactivate();
    traps   ->deactivate();
  }
  else
  {
    theme->activate();
    size ->activate();

    outdoors->activate();
    secrets ->activate();
    traps   ->activate();
  }
}


//----------------------------------------------------------------

void UI_Level::callback_Theme(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("theme", that->theme->GetID());
}
 
void UI_Level::callback_Size(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("size", that->size->GetID());
}
 
void UI_Level::callback_Traps(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("traps", that->traps->GetID());
}
 
void UI_Level::callback_Outdoors(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("outdoors", that->outdoors->GetID());
}
 
void UI_Level::callback_Secrets(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("secrets", that->secrets->GetID());
}

void UI_Level::Defaults()
{
  // Note: theme handled by LUA code (ob_init)

  ParseValue("size",     "prog");
  ParseValue("outdoors", "mixed");
  ParseValue("secrets",  "mixed");
  ParseValue("traps",    "mixed");
}
 
bool UI_Level::ParseValue(const char *key, const char *value)
{
  // Note: theme handled by LUA code

  if (StringCaseCmp(key, "size") == 0)
  {
    size->SetID(value);
    callback_Size(NULL, this);
    return true;
  }

  if (StringCaseCmp(key, "outdoors") == 0)
  {
    outdoors->SetID(value);
    callback_Outdoors(NULL, this);
    return true;
  }

  if (StringCaseCmp(key, "secrets") == 0)
  {
    secrets->SetID(value);
    callback_Secrets(NULL, this);
    return true;
  }

  if (StringCaseCmp(key, "traps") == 0)
  {
    traps->SetID(value);
    callback_Traps(NULL, this);
    return true;
  }

  return false;
}


//----------------------------------------------------------------

const char * UI_Level::size_syms[] =
{
  "tiny",    "Tiny",
  "small",   "Small",
  "regular", "Regular",
  "large",   "Large",
  "extreme", "Extreme",

  "prog",    "Progressive",
  "mixed",   "Mix It Up",

  NULL, NULL
};

const char * UI_Level::outdoor_syms[] =
{
  "none",   "NONE",
  "few",    "Rare",
  "some",   "Medium",
  "heaps",  "Heaps",
  "always", "Always",

  "mixed",  "Mix It Up",

  NULL, NULL
};

const char * UI_Level::trap_syms[] =
{
  // also used for: Secrets

  "none",   "NONE",  
  "few",    "Rare",
  "some",   "Medium",
  "heaps",  "Heaps",

  "mixed",  "Mix It Up",

  NULL, NULL
};

#if 0
const char * UI_Level::light_syms[] =
{
  "none",   "NONE",
  "dark",   "Dark",
  "normal", "Medium",
  "bright", "Bright",

  "mixed",  "Mix It Up",

  NULL, NULL
};
#endif

void UI_Level::setup_Size()
{
  for (int i = 0; size_syms[i]; i += 2)
  {
    size->AddPair(size_syms[i], size_syms[i+1]);
    size->ShowOrHide(size_syms[i], 1);
  }
}

void UI_Level::setup_Outdoors()
{
  for (int i = 0; outdoor_syms[i]; i += 2)
  {
    outdoors->AddPair(outdoor_syms[i], outdoor_syms[i+1]);
    outdoors->ShowOrHide(outdoor_syms[i], 1);
  }
}

void UI_Level::setup_Secrets()
{
  for (int i = 0; trap_syms[i]; i += 2)
  {
    secrets->AddPair(trap_syms[i], trap_syms[i+1]);
    secrets->ShowOrHide(trap_syms[i], 1);
  }
}

void UI_Level::setup_Traps()
{
  for (int i = 0; trap_syms[i]; i += 2)
  {
    traps->AddPair(trap_syms[i], trap_syms[i+1]);
    traps->ShowOrHide(trap_syms[i], 1);
  }

}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
