//----------------------------------------------------------------
//  Level Architecture
//----------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

//  box(FL_FLAT_BOX); //!!!!
  color(BUILD_BG, BUILD_BG); //!!!!


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


  detail = new UI_RChoice(x+ 78, cy, 114, 24, "Detail: ");
  detail->align(FL_ALIGN_LEFT);
  detail->selection_color(MY_GREEN);
  detail->callback(callback_Detail, this);

  setup_Detail();

  add(detail);

  cy += detail->h() + 6;

  cy += 10;


  heights = new UI_RChoice(x+ 78, cy, 114, 24, "Heights: ");
  heights->align(FL_ALIGN_LEFT);
  heights->selection_color(MY_GREEN);
  heights->callback(callback_Heights, this);

  setup_Heights();

  add(heights);

  cy += heights->h() + 6;


  light = new UI_RChoice(x+ 78, cy, 114, 24, "Lighting: ");
  light->align(FL_ALIGN_LEFT);
  light->selection_color(MY_GREEN);
  light->callback(callback_Light, this);

  setup_Light();

  add(light);

  cy += light->h() + 6;


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
    detail ->deactivate();
    heights->deactivate();
    light  ->deactivate();
  }
  else
  {
    theme  ->activate();
    size   ->activate();
    detail ->activate();
    heights->activate();
    light  ->activate();
  }
}


//----------------------------------------------------------------

void UI_Level::callback_Theme(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("theme", that->theme->GetID());
}
 
void UI_Level::callback_Size(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("size", that->size->GetID());
}
 
void UI_Level::callback_Detail(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("detail", that->detail->GetID());
}
 
void UI_Level::callback_Heights(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("heights", that->heights->GetID());
}
 
void UI_Level::callback_Light(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("light", that->light->GetID());
}

void UI_Level::Defaults()
{
  // Note: theme handled by LUA code (ob_init)

  ParseValue("size",    "small");
  ParseValue("detail",  "normal");
  ParseValue("heights", "mixed");
  ParseValue("light",   "mixed");
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

  if (StringCaseCmp(key, "heights") == 0)
  {
    heights->SetID(value);
    callback_Heights(NULL, this);
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
  "xlarge", "X-Large",

  "prog",   "Progressive",
  "mixed",  "Mix It Up",

  NULL, NULL
};

const char * UI_Level::detail_syms[] =
{
  "kein",   "NONE",
  "low",    "Low",
  "normal", "Medium",
  "high",   "High",

  NULL, NULL
};

const char * UI_Level::height_syms[] =
{
  "gentle", "Gentle",
  "normal", "Normal",
  "wild",   "Wild",

  "mixed",  "Mix It Up",

  NULL, NULL
};

const char * UI_Level::light_syms[] =
{
  "kein",   "NONE",
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

void UI_Level::setup_Heights()
{
  for (int i = 0; height_syms[i]; i += 2)
  {
    heights->AddPair(height_syms[i], height_syms[i+1]);
    heights->ShowOrHide(height_syms[i], 1);
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
