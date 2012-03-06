//------------------------------------------------------------------------
//  MAIN Program
//------------------------------------------------------------------------
//
//  Brusher (C) 2012 Andrew Apted
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

// this includes everything we need
#include "main.h"


FILE *map_fp;


static void ShowTitle(void)
{
  printf(
    "\n"
    " /--------------------------------\\\n"
    "|  Brusher  (C) 2012 Andrew Apted  |\n"
    " \\--------------------------------/\n"
  );
}

static void ShowInfo(void)
{
  printf(
    "Info...\n\n"
  );
}



//------------------------------------------------------------------------
//  MAIN PROGRAM
//------------------------------------------------------------------------

int main(int argc, char **argv)
{
  // skip program name
  argv++, argc--;

  ArgvInit(argc, (const char **)argv);

  InitDebug(ArgvFind(0, "debug") >= 0);
  InitEndian();

  if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0)
  {
    ShowTitle();
    ShowInfo();
    exit(1);
  }

  const char *filename = "doom2.wad";

  if (arg_count > 0 && ! ArgvIsOption(0))
    filename = arg_list[0];
  else
  {
    int params;
    int idx = ArgvFind(0, "file", &params);

    if (idx >= 0 && params >= 1)
      filename = arg_list[idx + 1];
  }

  if (CheckExtension(filename, "gwa"))
    FatalError("Main file must be a normal WAD (not GWA).\n");

  the_wad = wad_c::Load(filename);
  if (!the_wad)
    FatalError("Unable to read WAD file: %s\n", filename);

  const char *gwa_name = ReplaceExtension(filename, "gwa");

  if (FileExists(gwa_name))
  {
    the_gwa = wad_c::Load(gwa_name);
    if (!the_gwa)
      FatalError("Unable to read GWA file: %s\n", gwa_name);
  }

  const char *level_name = NULL;
  {
    int params;
    int idx = ArgvFind(0, "warp", &params);

    if (idx >= 0 && params >= 1)
      level_name = arg_list[idx + 1];

    if (! level_name)
    {
      level_name = the_wad->FirstLevelName();

      if (! level_name)
        FatalError("Unable to find ANY level in WAD.\n");
    }
  }


  LoadLevel(level_name);


  map_fp = fopen("result.obj", "w");
  if (! map_fp)
    FatalError("Unable to create output file: result.obj\n");

//  Brush_ConvertSectors();
//  Brush_ConvertWalls();

  fclose(map_fp);

  TermDebug();

  return 0;  // success!
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
