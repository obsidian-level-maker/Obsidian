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
  fprintf(output_fp, "    {\n");

  for (int k = (int)loop.lines.size() - 1 ; k >= 0 ; k--)
  {
    linedef_c *ld = loop.lines[k];
    int side      = loop.sides[k];

    // determine texture
    const char *tex;

    // use opposite side if it exists

    if (! (ld->left && ld->right))
    {
      sidedef_c *sd = (ld->right ? ld->right : ld->left);

      SYS_ASSERT(sd);

      tex = sd->mid_tex;
    }
    else
    {
      sidedef_c *sd = (side > 0 ? ld->left : ld->right);

      if (kind == 'b')
        tex = sd->upper_tex;
      else
        tex = sd->lower_tex;
    }

    if (tex[0] == '-')
      tex = "wall0";

    double x = (side > 0) ? ld->start->x : ld->end->x;
    double y = (side > 0) ? ld->start->y : ld->end->y;

    fprintf(output_fp, "      { x = %3d, y = %3d, mat = \"%s\" }\n", 
            I_ROUND(x), I_ROUND(y), tex);
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
