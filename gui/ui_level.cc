//----------------------------------------------------------------
//  Level Architecture
//----------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2009 Andrew Apted
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
#include "lib_util.h"


#define MY_GREEN  fl_rgb_color(0,166,0)


//
// Constructor
//
UI_Level::UI_Level(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
  end(); // cancel begin() in Fl_Group constructor
 
  box(FL_THIN_UP_BOX);

  color(BUILD_BG, BUILD_BG);


  int cy = y + 6;

  Fl_Box *heading = new Fl_Box(FL_NO_BOX, x+6, cy, w-12, 24, "Level Architecture");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += heading->h() + 6;


  size = new UI_RChoice(x+ 78, cy, 114, 24, "Size: ");
  size->align(FL_ALIGN_LEFT);
  size->selection_color(MY_GREEN);
  size->callback(callback_Size, this);

  setup_Size();

  add(size);

  cy += size->h() + 6;

  cy += 10;


  theme = new UI_RChoice(x+ 78, cy, 114, 24, "Theme: ");
  theme->align(FL_ALIGN_LEFT);
  theme->selection_color(MY_GREEN);
  theme->callback(callback_Theme, this);

  add(theme);

  cy += theme->h() + 6;


  outdoors = new UI_RChoice(x+ 78, cy, 114, 24, "Outdoors: ");
  outdoors->align(FL_ALIGN_LEFT);
  outdoors->selection_color(MY_GREEN);
  outdoors->callback(callback_Outdoors, this);

  setup_Outdoors();

  add(outdoors);

  cy += outdoors->h() + 6;

  cy += 10;


  light = new UI_RChoice(x+ 78, cy, 114, 24, "Lighting: ");
  light->align(FL_ALIGN_LEFT);
  light->selection_color(MY_GREEN);
  light->callback(callback_Light, this);

  setup_Light();

  add(light);

  cy += light->h() + 6;


  detail = new UI_RChoice(x+ 78, cy, 114, 24, "Detail: ");
  detail->align(FL_ALIGN_LEFT);
  detail->selection_color(MY_GREEN);
  detail->callback(callback_Detail, this);

  setup_Detail();

  add(detail);

  cy += detail->h() + 6;


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
    theme  ->deactivate();
    size   ->deactivate();
    outdoors->deactivate();
    detail ->deactivate();
    light  ->deactivate();
  }
  else
  {
    theme  ->activate();
    size   ->activate();
    outdoors->activate();
    detail ->activate();
    light  ->activate();
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
 
void UI_Level::callback_Detail(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("detail", that->detail->GetID());
}
 
void UI_Level::callback_Outdoors(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("outdoors", that->outdoors->GetID());
}
 
void UI_Level::callback_Light(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  ob_set_config("light", that->light->GetID());
}

void UI_Level::Defaults()
{
  // Note: theme handled by LUA code (ob_init)

  ParseValue("size",     "normal");
  ParseValue("outdoors", "mixed");
  ParseValue("light",    "mixed");
  ParseValue("detail",   "normal");
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

  if (StringCaseCmp(key, "detail") == 0)
  {
    detail->SetID(value);
    callback_Detail(NULL, this);
    return true;
  }

  if (StringCaseCmp(key, "outdoors") == 0)
  {
    outdoors->SetID(value);
    callback_Outdoors(NULL, this);
    return true;
  }

  if (StringCaseCmp(key, "light") == 0)
  {
    light->SetID(value);
    callback_Light(NULL, this);
    return true;
  }

  return false;
}


//----------------------------------------------------------------

const char * UI_Level::size_syms[] =
{
  "small",  "Small",
  "normal", "Regular",
  "large",  "Large",

/// "xlarge", "X-Large",

  "prog",   "Progressive",
  "mixed",  "Mix It Up",

  NULL, NULL
};

const char * UI_Level::outdoor_syms[] =
{
  "few",    "Rare",
  "some",   "Normal",
  "heaps",  "Abundant",

  "mixed",  "Mix It Up",

  NULL, NULL
};

const char * UI_Level::detail_syms[] =
{
  "none",   "NONE",
  "low",    "Low",
  "normal", "Medium",
  "high",   "High",

  NULL, NULL
};

const char * UI_Level::light_syms[] =
{
  "none",   "NONE",
  "dark",   "Dark",
  "normal", "Normal",
  "bright", "Bright",

  "mixed",  "Mix It Up",

  NULL, NULL
};

void UI_Level::setup_Size()
{
  for (int i = 0; size_syms[i]; i += 2)
  {
    size->AddPair(size_syms[i], size_syms[i+1]);
    size->ShowOrHide(size_syms[i], 1);
  }
}

void UI_Level::setup_Detail()
{
  for (int i = 0; detail_syms[i]; i += 2)
  {
    detail->AddPair(detail_syms[i], detail_syms[i+1]);
    detail->ShowOrHide(detail_syms[i], 1);
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

void UI_Level::setup_Light()
{
  for (int i = 0; light_syms[i]; i += 2)
  {
    light->AddPair(light_syms[i], light_syms[i+1]);
    light->ShowOrHide(light_syms[i], 1);
  }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
