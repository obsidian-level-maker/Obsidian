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


#define DEFAULT_OUT_NAME  "output.lua"

FILE *output_fp;


static void ShowTitle()
{
  printf(
    "\n"
    " /--------------------------------\\\n"
    "(  BRUSHER  (C) 2012 Andrew Apted  )\n"
    " \\--------------------------------/\n"
    "\n"
  );
}

static void ShowHelp()
{
  printf("USAGE: brusher file.wad [ -o output.lua ]\n\n");
}


typedef struct
{
  int type;
  const char *name;
}
thing_name_t;

static thing_name_t doom_thing_names[] =
{
  {    1, "player1" },
  {    2, "player2" },
  {    3, "player3" },
  {    4, "player4" },
  {   11, "dm_player" },
  {   14, "teleport_spot" },
  { 3004, "zombie" },
  {    9, "shooter" },
  {   65, "gunner" },
  { 3001, "imp" },
  { 3005, "caco" },
  {   66, "revenant" },
  {   69, "knight" },
  { 3003, "baron" },
  {   67, "mancubus" },
  {   68, "arach" },
  {   71, "pain" },
  {   64, "vile" },
  { 3002, "demon" },
  {   58, "spectre" },
  { 3006, "skull" },
  {   84, "ss_dude" },
  {   72, "keen" },
  {    7, "Mastermind" },
  {   16, "Cyberdemon" },
  {   13, "kc_red" },
  {    6, "kc_yellow" },
  {    5, "kc_blue" },
  {   38, "ks_red" },
  {   39, "ks_yellow" },
  {   40, "ks_blue" },
  { 2001, "shotty" },
  {   82, "super" },
  { 2002, "chain" },
  { 2003, "launch" },
  { 2004, "plasma" },
  { 2005, "saw" },
  { 2006, "bfg" },
  {    8, "backpack" },
  {   83, "mega" },
  { 2022, "invul" },
  { 2023, "berserk" },
  { 2024, "invis" },
  { 2025, "suit" },
  { 2026, "map" },
  { 2045, "goggle" },
  { 2014, "potion" },
  { 2011, "stimpack" },
  { 2012, "medikit" },
  { 2013, "soul" },
  { 2015, "helmet" },
  { 2018, "green_armor" },
  { 2019, "blue_armor" },
  { 2007, "bullets" },
  { 2048, "bullet_box" },
  { 2008, "shells" },
  { 2049, "shell_box" },
  { 2010, "rockets" },
  { 2046, "rocket_box" },
  { 2047, "cells" },
  {   17, "cell_pack" },
  { 2028, "lamp" },
  {   85, "mercury_lamp" },
  {   86, "short_lamp" },
  {   48, "tech_column" },
  {   34, "candle" },
  {   35, "candelabra" },
  {   70, "burning_barrel" },
  {   44, "blue_torch" },
  {   55, "blue_torch_sm" },
  {   45, "green_torch" },
  {   56, "green_torch_sm" },
  {   46, "red_torch" },
  {   57, "red_torch_sm" },
  { 2035, "barrel" },
  {   30, "green_pillar" },
  {   31, "green_column" },
  {   36, "green_column_hrt" },
  {   32, "red_pillar" },
  {   33, "red_column" },
  {   37, "red_column_skl" },
  {   43, "burnt_tree" },
  {   47, "brown_stub" },
  {   54, "big_tree" },
  {   41, "evil_eye" },
  {   42, "skull_rock" },
  {   27, "skull_pole" },
  {   28, "skull_kebab" },
  {   29, "skull_cairn" },
  {   25, "impaled_human" },
  {   26, "impaled_twitch" },
  {   73, "gutted_victim1" },
  {   74, "gutted_victim2" },
  {   75, "gutted_torso1" },
  {   76, "gutted_torso2" },
  {   77, "gutted_torso3" },
  {   78, "gutted_torso4" },
  {   59, "hang_arm_pair" },
  {   60, "hang_leg_pair" },
  {   61, "hang_leg_gone" },
  {   62, "hang_leg" },
  {   63, "hang_twitching" },
  {   24, "gibs" },
  {   10, "gibbed_player" },
  {   79, "pool_blood_1" },
  {   80, "pool_blood_2" },
  {   81, "pool_brains" },
  {   15, "dead_player" },
  {   18, "dead_zombie" },
  {   19, "dead_shooter" },
  {   20, "dead_imp" },
  {   21, "dead_demon" },
  {   22, "dead_caco" },
  {   23, "dead_skull" },
  {   88, "brain_boss" },
  {   89, "brain_shooter" },
  {   87, "brain_target" },

  // the end
  { -1, NULL }
};

static const char *NameForThingType(int type)
{
  for (int i = 0 ; doom_thing_names[i].name ; i++)
  {
    if (doom_thing_names[i].type == type)
      return doom_thing_names[i].name;
  }

  static char buffer[40];

  sprintf(buffer, "type%d", type);

  return buffer;
}


static const char * flat_mapping[] =
{
  "F_SKY1", "_SKY",  "F_SKY", "_SKY",

  // TODO: liquids

  NULL, NULL
};

static const char * texture_mapping[] =
{
  // TODO: liquids

  NULL, NULL
};

static const char * ApplyMapping(const char **tab, const char *orig)
{
  for (; *tab ; tab += 2)
  {
    if (strcmp(tab[0], orig) == 0)
      return tab[1];
  }

  return orig;
}


//------------------------------------------------------------------------

static int error_count = 0;


static void ProcessThings()
{
  fprintf(output_fp, "\n");
  fprintf(output_fp, "  entities =\n");
  fprintf(output_fp, "  {\n");

  for (int n = 0 ; n < lev_things.num ; n++)
  {
    thing_c *th = lev_things.Get(n);

    // determine z height from sector

    sector_c *sec = SectorAtPoint(th->x, th->y);

    int z = sec ? sec->floor_h : 0;

    fprintf(output_fp, "    { ent = \"%s\", x = %d, y = %d, z = %d, angle = %d }\n",
            NameForThingType(th->type), th->x, th->y, z, th->angle);
  }

  fprintf(output_fp, "  }\n");
}


static void WriteBrush(lineloop_c& loop, char kind, int z = 0, const char *flat = NULL)
{
  // recognise certain flats to mean "skip this brush"
  if (flat &&
      (strcmp(flat, "LAVA4") == 0 ||
       strcmp(flat, "FLATHUH4") == 0 ||
       strcmp(flat, "X_004") == 0) )
  {
    return;
  }

  if (flat)
    flat = ApplyMapping(flat_mapping, flat);

  fprintf(output_fp, "    {\n");

  int first = loop.IndexWithLowestX();

  const char *last_tex = NULL;
  int last_x = -1;
  int last_y = -1;

  for (int n = 0 ; n < (int)loop.lines.size() ; n++)
  {
    int k = first - n;

    if (k < 0)
      k += (int)loop.lines.size();

    SYS_ASSERT(k >= 0);
    SYS_ASSERT(k < (int)loop.lines.size());

    int k2 = k - 1;

    if (k2 < 0)
      k2 += (int)loop.lines.size();

    // determine texture
    const char *tex;
    const char *tex2;
    
    loop.GetProps(k,  kind, &tex);
    loop.GetProps(k2, kind, &tex2);

    if (tex[0]  == '-') tex  = "wall0";
    if (tex2[0] == '-') tex2 = "wall0";

    tex  = ApplyMapping(texture_mapping, tex);
    tex2 = ApplyMapping(texture_mapping, tex2);

    int x = loop.GetX(k);
    int y = loop.GetY(k);

    int x2 = loop.GetX(k2);
    int y2 = loop.GetY(k2);

    // skip this vertex if not needed, i.e. it's in the middle of an
    // axis-aligned line and the properties are same as previous one.
    if (last_tex &&
        strcmp(last_tex, tex) == 0 &&
        ( (last_x == x && x == x2) ||
          (last_y == y && y == y2)))
    {
      continue;
    }

    fprintf(output_fp, "      { x = %3d, y = %3d, mat = \"%s\" }\n", 
            x, y, tex);

    last_tex = tex;
    last_x = x;
    last_y = y;
  }

  if (kind == 't' || kind == 'b')
  {
    fprintf(output_fp, "      { %c = %d, mat = \"%s\" }\n", kind, z, flat);
  }

  fprintf(output_fp, "    }\n");
}


static void ProcessLoop(linedef_c *ld, int side, bool& have_one)
{
  lineloop_c loop;

// DebugPrintf("tracing %d @ %d\n", ld->index, side);

  if (! TraceLineLoop(ld, side, loop))
  {
    error_count += 1;
    return;
  }

  // ignore the outside loop of islands
  if (loop.faces_outward)
    return;

  // determine sector
  sector_c * sec = loop.GetSector();

  SYS_ASSERT(sec);

  // mark all lines in the loop as processed
  loop.MarkAsProcessed();

  if (have_one)
    fprintf(output_fp, "\n");

  have_one = true;

  // convert loop into a brush

  if (sec->ceil_h <= sec->floor_h)
  {
    // solid area, no top or bottom
    WriteBrush(loop, 'x');
  }
  else
  {
    WriteBrush(loop, 't', sec->floor_h, sec->floor_tex);
    WriteBrush(loop, 'b', sec-> ceil_h, sec-> ceil_tex);
  }
}


static bool AnalyseLevel()
{
  printf("\nAnalysing level...\n");

  fprintf(output_fp, "PREFAB.XXX =\n{\n");
  fprintf(output_fp, "  brushes =\n");
  fprintf(output_fp, "  {\n");

  bool have_one = false;

  for (int n = 0 ; n < lev_linedefs.num ; n++)
  {
    linedef_c * ld = lev_linedefs.Get(n);

    for (int side_idx = 0 ; side_idx < 2 ; side_idx++)
    {
      int side = side_idx ? SIDE_LEFT : SIDE_RIGHT;
      int mask = (1 << side_idx);

      // already processed?
      if (ld->traced_sides & mask)
        continue;

      // skip second side on one-sided linedefs
      if (side > 0 && ! ld->right) continue;
      if (side < 0 && ! ld->left)  continue;

      ProcessLoop(ld, side, have_one);
    }
  }

  fprintf(output_fp, "  }\n");

  if (lev_things.num > 0)
    ProcessThings();

  fprintf(output_fp, "}\n");

  if (error_count > 0)
    printf("\nTotal errors: %d\n", error_count);

  return (error_count == 0);
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

  ShowTitle();

  if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0 || arg_count == 0)
  {
    ShowHelp();
    exit(1);
  }

  // get input filename

  if (! (arg_count > 0 && ! ArgvIsOption(0)))
    FatalError("Missing input filename!\n");

  const char *input_name = arg_list[0];


  // get output filename

  const char *output_name = DEFAULT_OUT_NAME;

  {
    int params;
    int idx = ArgvFind('o', "output", &params);

    if (idx >= 0)
    {
      if (params < 1)
        FatalError("Missing output filename!\n");

      output_name = arg_list[idx + 1];
    }
    else
    {
      // FIXME: use input name, replace extension with "lua"
    }
  }


  the_wad = wad_c::Load(input_name);

  if (! the_wad)
    FatalError("Unable to read WAD file: %s\n", input_name);


  // determine level to load (usually just the first one)

  const char *level_name = the_wad->FirstLevelName();

  {
    int params;
    int idx = ArgvFind('w', "warp", &params);

    if (idx >= 0 && params >= 1)
      level_name = arg_list[idx + 1];
  }


  printf("Loading '%s' from file: %s\n", level_name, input_name);

  LoadLevel(level_name);


  output_fp = fopen(output_name, "w");

  if (! output_fp)
    FatalError("Unable to create output file!\n");

  printf("Created output file: %s\n", output_name);


  bool ok = AnalyseLevel();


  fclose(output_fp);

  TermDebug();

  if (ok)
    printf("\nOK.\n");
  else
    printf("\nFAILED!\n");

  return (ok ? 0 : 3);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
