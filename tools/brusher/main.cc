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

    int z = 0;  // FIXME !!!!  determine z from sector

    fprintf(output_fp, "    { ent = \"type%d\", x = %d, y = %d, z = %d, angle = %d }\n",
            th->type, th->x, th->y, z, th->angle);
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
