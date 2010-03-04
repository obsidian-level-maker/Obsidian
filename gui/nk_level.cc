//------------------------------------------------------------------------
//  2.5D CSG : NUKEM output
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010 Andrew Apted
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
//------------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"  // ui_build.h

#include <algorithm>

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "ui_chooser.h"

#include "nk_structs.h"
#include "nk_level.h"

#include "csg_main.h"
#include "lib_wad.h"
#include "q_bsp.h"


// Properties
static char *level_name;
static char *error_tex;


void NK_StartGRP()
{
  // FIXME
}

void NK_EndGRP()
{
  // FIXME
}

void NK_BeginLevel()
{
  // FIXME
}

void NK_EndLevel()
{
  // FIXME
}


//------------------------------------------------------------------------


class nukem_game_interface_c : public game_interface_c
{
private:
  const char *filename;

public:
  nukem_game_interface_c() : filename(NULL)
  { }

  ~nukem_game_interface_c()
  {
    StringFree(filename);
  }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);

private:
  bool CheckDirectory(const char *filename);
};


// FIXME: duplicated code (dm_level.cc)
bool nukem_game_interface_c::CheckDirectory(const char *filename)
{
  char *dir_name = StringDup(filename);

  // remove the base filename to get the plain directory
  const char *base = FindBaseName(filename);

  dir_name[base - filename] = 0;

  if (strlen(dir_name) == 0)
    return true;

  // this badly-named function checks the directory exists
  bool result = fl_filename_isdir(dir_name);

  if (! result)
    DLG_ShowError("The specified folder does not exist:\n\n  %s", dir_name);

  StringFree(dir_name);

  return result;
}


bool nukem_game_interface_c::Start()
{
  for (;;)
  {
    filename = Select_Output_File("grp");

    if (! filename)
    {
      Main_ProgStatus("Cancelled");
      return false;
    }

    if (CheckDirectory(filename))
      break;

    // keep trying until filename is valid
  }

  if (! NK_StartGRP(filename))
  {
    Main_ProgStatus("Error (create file)");
    return false;
  }

  if (main_win)
  {
    main_win->build_box->ProgInit(1);
    main_win->build_box->ProgBegin(1, 100, BUILD_PROGRESS_FG);
  }

  return true;
}


bool nukem_game_interface_c::Finish(bool build_ok)
{
  NK_EndGRP();

  // tidy up
  FileDelete(TEMP_FILENAME);

  return build_ok;
}


void nukem_game_interface_c::BeginLevel()
{
  FreeLevelStuff();
}


void nukem_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else if (StringCaseCmp(key, "description") == 0)
  {
    // ignored (for now)
    // [another mechanism sets the description via BEX/DDF]
  }
  else if (StringCaseCmp(key, "error_tex") == 0)
  {
    error_tex = StringDup(value);
  }
  else if (StringCaseCmp(key, "error_flat") == 0)
  {
    // silently accepted, but not used
  }
  else
  {
    LogPrintf("WARNING: unknown NUKEM property: %s=%s\n", key, value);
  }
}


void nukem_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  NK_BeginLevel();

  CSG2_MergeAreas();
  CSG2_MakeMiniMap();

  NK_WriteNukem();

  NK_EndLevel();

  StringFree(level_name);
  level_name = NULL;

  if (error_tex)
  {
    StringFree(error_tex);
    error_tex = NULL;
  }
}


game_interface_c * Nukem_GameObject()
{
  return new nukem_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
