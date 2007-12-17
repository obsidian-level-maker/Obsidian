//----------------------------------------------------------------
//  Level Architecture
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

  int cy = y + 8;

  Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, w-12, 24, "Level Architecture");
  heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
  heading->labeltype(FL_NORMAL_LABEL);
  heading->labelfont(FL_HELVETICA_BOLD);

  add(heading);

  cy += heading->h() + 6;


  theme = new UI_RChoice(x+ 82, cy, 112, 24, "Theme: ");
  theme->align(FL_ALIGN_LEFT);
  theme->selection_color(MY_GREEN);
  theme->callback(callback_Theme, this);

  add(theme);

  cy += theme->h() + 6;

  cy += 10;


  size = new UI_RChoice(x+ 82, cy, 112, 24, "Size: ");
  size->align(FL_ALIGN_LEFT);
  size->selection_color(MY_GREEN);
  size->callback(callback_Size, this);

  setup_Size();

  add(size);

  cy += size->h() + 6;


  detail = new UI_RChoice(x+ 82, cy, 112, 24, "Detail: ");
  detail->align(FL_ALIGN_LEFT);
  detail->selection_color(MY_GREEN);
  detail->callback(callback_Detail, this);

  setup_Detail();

  add(detail);

  cy += detail->h() + 6;

  cy += 10;


  heights = new UI_RChoice(x+ 82, cy, 112, 24, "Heights: ");
  heights->align(FL_ALIGN_LEFT);
  heights->selection_color(MY_GREEN);
  heights->callback(callback_Heights, this);

  setup_Heights();

  add(heights);

  cy += heights->h() + 6;


  light = new UI_RChoice(x+ 82, cy, 112, 24, "Lighting: ");
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

  Script_SetConfig("theme", that->get_Theme());
}
 
void UI_Level::callback_Size(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("size", that->get_Size());
}
 
void UI_Level::callback_Detail(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("detail", that->get_Detail());
}
 
void UI_Level::callback_Heights(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

  Script_SetConfig("heights", that->get_Heights());
}
 
void UI_Level::callback_Light(Fl_Widget *w, void *data)
{
  UI_Level *that = (UI_Level *) data;

//!!!  Script_SetConfig("light", that->get_Light());
}
 

const char * UI_Level::GetAllValues()
{
  static const char *last_str = NULL;

  if (last_str)
    StringFree(last_str);

  last_str = StringPrintf(
      "size = %s\n"    "theme = %s\n"
      "detail = %s\n"  "heights = %s\n",
      //!!! light
      get_Size(),   get_Theme(),
      get_Detail(), get_Heights()
  );

  return last_str;
}

bool UI_Level::ParseValue(const char *key, const char *value)
{
  if (StringCaseCmp(key, "theme") == 0)
    return set_Theme(value);

  if (StringCaseCmp(key, "size") == 0)
    return set_Size(value);

  if (StringCaseCmp(key, "detail") == 0)
    return set_Detail(value);

  if (StringCaseCmp(key, "heights") == 0)
    return set_Heights(value);

  // YYY

  return false;
}


//----------------------------------------------------------------

const char * UI_Level::size_syms[] =
{
  "mixed",  "Mix It Up",

  "low",    "Tiny",
  "less",   "Small",
  "normal", "Regular",
  "more",   "X-Large",

  NULL, NULL
};

const char * UI_Level::detail_syms[] =
{
  "low",    "None",
  "less",   "Low",
  "normal", "Medium",
  "more",   "High",

  NULL, NULL
};

const char * UI_Level::height_syms[] =
{
  "mixed",  "Mix It Up",

  "low",    "Flat",
  "less",   "Gentle",
  "normal", "Normal",
  "more",   "Wild",

  NULL, NULL
};

const char * UI_Level::light_syms[] =
{
  "mixed",  "Mix It Up",

  "low",    "None",
  "less",   "Dark",
  "normal", "Normal",
  "more",   "Bright",

  NULL, NULL
};

void UI_Level::setup_Size()
{
  for (int i = 0; size_syms[i]; i += 2)
    size->AddPair(size_syms[i], size_syms[i+1]);

  size->Recreate();
}

void UI_Level::setup_Detail()
{
  for (int i = 0; detail_syms[i]; i += 2)
    detail->AddPair(detail_syms[i], detail_syms[i+1]);

  detail->Recreate();
}

void UI_Level::setup_Heights()
{
  for (int i = 0; height_syms[i]; i += 2)
    heights->AddPair(height_syms[i], height_syms[i+1]);

  heights->Recreate();
}

void UI_Level::setup_Light()
{
  for (int i = 0; light_syms[i]; i += 2)
    light->AddPair(light_syms[i], light_syms[i+1]);

  light->Recreate();
}



const char * UI_Level::adjust_syms[3] =  // REMOVE !!
{
  "less", "normal", "more"
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
    if (StringCaseCmp(str, adjust_syms[i]) == 0)
      return i;

  return -1; // Unknown
}


bool UI_Level::set_Size(const char *str)
{
  for (int i=0; size_syms[i]; i++)
    if (StringCaseCmp(str, size_syms[i]) == 0)
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

