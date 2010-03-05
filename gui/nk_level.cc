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


extern void NK_WriteNukem(void);

// Properties
static char *level_name;
static char *error_tex;


static qLump_c *nk_sectors;
static qLump_c *nk_walls;
static qLump_c *nk_sprites;


bool NK_StartGRP(const char *filename)
{
  if (! GRP_OpenWrite(filename))
    return false;

  return true;
}

void NK_EndGRP(void)
{
  GRP_CloseWrite();
}

void NK_BeginLevel(const char *level_name)
{
  char buffer[40];

  sprintf(buffer, "%s.MAP", level_name);
  StringUpper(buffer);

  GRP_NewLump(buffer);
}

void NK_EndLevel(void)
{
  GRP_FinishLump();
}


void NK_AddSector(int first_wall, int num_wall, int f_h, int c_h, ...)
{
  raw_nukem_sector_t raw;

  memset(&raw, 0, sizeof(raw));

  raw.wall_ptr = LE_U16(first_wall);
  raw.wall_num = LE_U16(num_wall); 

  raw.floor_pic = LE_U16(742);
  raw.ceil_pic  = LE_U16(757);

  raw.floor_h = LE_S32(f_h);
  raw.ceil_h  = LE_S32(c_h);

  raw.visibility = 16;
  raw.extra = -1;

  nk_sectors->Append(&raw, sizeof(raw));
}

void NK_AddWall(int x, int y, int right, int back, int back_sec, ... )
{
  raw_nukem_wall_t raw;

  memset(&raw, 0, sizeof(raw));

  raw.x = LE_S32(x);
  raw.y = LE_S32(y);

  raw.right_wall = LE_U16(right);

  raw.back_wall = LE_U16(back);
  raw.back_sec  = LE_U16(back_sec);

  raw.pic[0] = LE_U16(723);
  raw.pic[1] = LE_U16(0);

  raw.xscale = raw.yscale = 4;

  raw.extra = -1;

  nk_walls->Append(&raw, sizeof(raw));
}

void NK_AddSprite( ... )
{
  raw_nukem_sprite_t raw;

  memset(&raw, 0, sizeof(raw));

  // FIXME

  nk_sprites->Append(&raw, sizeof(raw));
}


int NK_NumSectors(void)
{
  return nk_sectors->GetSize() / sizeof(raw_nukem_sector_t);
}

int NK_NumWalls(void)
{
  return nk_walls->GetSize() / sizeof(raw_nukem_wall_t);
}

int NK_NumSprites(void)
{
  return nk_sprites->GetSize() / sizeof(raw_nukem_sprite_t);
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
};




bool nukem_game_interface_c::Start()
{
  filename = Select_Output_File("grp");

  if (! filename)
  {
    Main_ProgStatus("Cancelled");
    return false;
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

  return build_ok;
}


void nukem_game_interface_c::BeginLevel()
{
//!!!!!!  FreeLevelStuff();
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

  NK_BeginLevel(level_name);

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
