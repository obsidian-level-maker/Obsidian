//------------------------------------------------------------------------
// MAIN : Main program for glBSP
//------------------------------------------------------------------------
//
//  GL-Friendly Node Builder (C) 2000-2007 Andrew Apted
//
//  Based on 'BSP 2.3' by Colin Reed, Lee Killough and others.
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
 
#include "system.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <math.h>
#include <limits.h>
#include <assert.h>

#include "analyze.h"
#include "level.h"
#include "node.h"
#include "seg.h"
#include "structs.h"
#include "util.h"
#include "wad.h"


const nodebuildinfo_t *cur_info = NULL;
const nodebuildfuncs_t *cur_funcs = NULL;
volatile nodebuildcomms_t *cur_comms = NULL;


const nodebuildinfo_t default_buildinfo =
{
  NULL,    // filename

  DEFAULT_FACTOR,  // factor

  FALSE,   // no_reject
  FALSE,   // no_progress
  FALSE,   // quiet
  FALSE,   // mini_warnings
  FALSE,   // force_hexen
  FALSE,   // pack_sides
  FALSE,   // fast

  2,   // spec_version

  FALSE,   // load_all
  FALSE,   // no_normal
  FALSE,   // force_normal
  FALSE,   // prune_sect
  FALSE,   // no_prune
  FALSE,   // merge_vert

  3333,   // block_limit

  FALSE,   // missing_output
  FALSE    // same_filenames
};

const nodebuildcomms_t default_buildcomms =
{
  NULL,    // message
  FALSE,   // cancelled

  0, 0,    // total warnings
  0, 0     // build and file positions
};


/* ----- option parsing ----------------------------- */

#define HANDLE_BOOLEAN(name, field)  \
    if (UtilStrCaseCmp(opt_str, name) == 0)  \
    {  \
      info->field = TRUE;  \
      argv++; argc--;  \
      continue;  \
    }

#define HANDLE_BOOLEAN2(abbrev, name, field)  \
    HANDLE_BOOLEAN(abbrev, field)  \
    HANDLE_BOOLEAN(name, field)

glbsp_ret_e GlbspParseArgs(nodebuildinfo_t *info, 
    volatile nodebuildcomms_t *comms,
    const char ** argv, int argc)
{
  const char *opt_str;
  int num_files = 0;

  cur_comms = comms;
  SetErrorMsg("(Unknown Problem)");

  while (argc > 0)
  {
    if (argv[0][0] != '-')
    {
      // --- ORDINARY FILENAME ---

      if (CheckExtension(argv[0], "gwa"))
      {
        SetErrorMsg("Input file cannot be GWA (contains nothing to build)");
        cur_comms = NULL;
        return GLBSP_E_BadArgs;
      }

      if (num_files >= 1)
      {
        SetErrorMsg("Cannot specify multiple filenames");
        cur_comms = NULL;
        return GLBSP_E_BadArgs;
      }

      info->filename = GlbspStrDup(argv[0]);
      num_files++;

      argv++; argc--;
      continue;
    }

    // --- AN OPTION ---

    opt_str = &argv[0][1];

    // handle GNU style options beginning with '--'
    if (opt_str[0] == '-')
      opt_str++;

    if (UtilStrCaseCmp(opt_str, "factor") == 0 ||
        UtilStrCaseCmp(opt_str, "c") == 0)
    {
      if (argc < 2)
      {
        SetErrorMsg("Missing factor value");
        cur_comms = NULL;
        return GLBSP_E_BadArgs;
      }

      info->factor = (int) strtol(argv[1], NULL, 10);

      argv += 2; argc -= 2;
      continue;
    }

    if (tolower(opt_str[0]) == 'v' && isdigit(opt_str[1]))
    {
      info->spec_version = (opt_str[1] - '0');

      argv++; argc--;
      continue;
    }

    if (UtilStrCaseCmp(opt_str, "maxblock") == 0 ||
        UtilStrCaseCmp(opt_str, "b") == 0)
    {
      if (argc < 2)
      {
        SetErrorMsg("Missing maxblock value");
        cur_comms = NULL;
        return GLBSP_E_BadArgs;
      }

      info->block_limit = (int) strtol(argv[1], NULL, 10);

      argv += 2; argc -= 2;
      continue;
    }

    HANDLE_BOOLEAN2("q",  "quiet",      quiet)
    HANDLE_BOOLEAN2("f",  "fast",       fast)
    HANDLE_BOOLEAN2("w",  "warn",       mini_warnings)
    HANDLE_BOOLEAN2("p",  "pack",       pack_sides)
    HANDLE_BOOLEAN2("n",  "normal",     force_normal)
    HANDLE_BOOLEAN2("xr", "noreject",   no_reject)
    HANDLE_BOOLEAN2("xp", "noprog",     no_progress)

    HANDLE_BOOLEAN2("m",  "mergevert",   merge_vert)
    HANDLE_BOOLEAN2("u",  "prunesec",    prune_sect)
    HANDLE_BOOLEAN2("xu", "noprune",     no_prune)
    HANDLE_BOOLEAN2("xn", "nonormal",    no_normal)

    // to err is human...
    HANDLE_BOOLEAN("noprogress",  no_progress)
    HANDLE_BOOLEAN("packsides",   pack_sides)
    HANDLE_BOOLEAN("prunesect",   prune_sect)

    SetErrorMsg("Unknown option: %s", argv[0]);

    cur_comms = NULL;
    return GLBSP_E_BadArgs;
  }

  cur_comms = NULL;
  return GLBSP_E_OK;
}

glbsp_ret_e GlbspCheckInfo(nodebuildinfo_t *info,
    volatile nodebuildcomms_t *comms)
{
  cur_comms = comms;
  SetErrorMsg("(Unknown Problem)");

  info->same_filenames = FALSE;
  info->missing_output = FALSE;

  if (!info->filename || info->filename[0] == 0)
  {
    SetErrorMsg("Missing input filename !");
    return GLBSP_E_BadArgs;
  }

  if (CheckExtension(info->filename, "gwa"))
  {
    SetErrorMsg("Input file cannot be GWA (contains nothing to build)");
    return GLBSP_E_BadArgs;
  }

  info->load_all = TRUE;
  info->same_filenames = TRUE;

  if (info->no_prune && info->pack_sides)
  {
    info->pack_sides = FALSE;
    SetErrorMsg("-noprune and -packsides cannot be used together");
    return GLBSP_E_BadInfoFixed;
  }

  if (info->no_normal && info->force_normal)
  {
    info->force_normal = FALSE;
    SetErrorMsg("-forcenormal and -nonormal cannot be used together");
    return GLBSP_E_BadInfoFixed;
  }
 
  if (info->factor <= 0 || info->factor > 32)
  {
    info->factor = DEFAULT_FACTOR;
    SetErrorMsg("Bad factor value !");
    return GLBSP_E_BadInfoFixed;
  }

  if (info->spec_version <= 0 || info->spec_version > 5)
  {
    info->spec_version = 2;
    SetErrorMsg("Bad GL-Nodes version number !");
    return GLBSP_E_BadInfoFixed;
  }
  else if (info->spec_version == 4)
  {
    info->spec_version = 5;
    SetErrorMsg("V4 GL-Nodes is not supported");
    return GLBSP_E_BadInfoFixed;
  }

  return GLBSP_E_OK;
}


/* ----- memory functions --------------------------- */

const char *GlbspStrDup(const char *str)
{
  if (! str)
    return NULL;

  return UtilStrDup(str);
}

void GlbspFree(const char *str)
{
  if (! str)
    return;

  UtilFree((char *) str);
}


void VerifyOuterLines(void)
{
  int i;
  int seen = 0;

  for (i = 0 ; i < num_linedefs ; i++)
  {
    linedef_t *L = LookupLinedef(i);

    int x1 = (int)L->start->x;
    int y1 = (int)L->start->y;
    int x2 = (int)L->end->x;
    int y2 = (int)L->end->y;

    if (L->left && L->right)
      continue;

    if (x1 == limit_x1 && x2 == limit_x2 && y1 == limit_y2 && y2 == y1)
    {
      seen |= 0x0008; L->is_border = 1;
    }

    if (x1 == limit_x2 && x2 == limit_x1 && y1 == limit_y1 && y2 == y1)
    {
      seen |= 0x2000; L->is_border = 1;
    }

    if (x1 == limit_x1 && x2 == x1 && y1 == limit_y1 && y2 == limit_y2)
    {
      seen |= 0x0400; L->is_border = 1;
    }

    if (x1 == limit_x2 && x2 == x1 && y1 == limit_y2 && y2 == limit_y1)
    {
      seen |= 0x0060; L->is_border = 1;
    }
  }
  
  if (seen != 0x2468)
  {
    FatalError("Missing box around level (saw %04x)", seen);
  }
}


/* ----- build nodes for a single level --------------------------- */

static glbsp_ret_e HandleLevel(void)
{
  glbsp_ret_e ret;

  if (cur_comms->cancelled)
    return GLBSP_E_Cancelled;

  DisplaySetBarLimit(1, 1000);
  DisplaySetBar(1, 0);

  cur_comms->build_pos = 0;

  LoadLevel();

  DetermineMapLimits();

  VerifyOuterLines();

  // create initial segs
  CreateSegs();


  ret = BuildEverything();

  if (ret == GLBSP_E_OK)
  {
    ClockwiseSubsectors();

    PrintVerbose("Built %d SUBSECS, %d SEGS, %d VERTEXES\n",
        num_subsecs, num_segs, num_gl_vert);

    SaveLevel();
  }

  FreeLevel();
  FreeQuickAllocCuts();

  return ret;
}


/* ----- main routine -------------------------------------- */

glbsp_ret_e GlbspBuildNodes(const nodebuildinfo_t *info,
    const nodebuildfuncs_t *funcs, volatile nodebuildcomms_t *comms)
{
  char *file_msg;

  glbsp_ret_e ret = GLBSP_E_OK;

  cur_info  = info;
  cur_funcs = funcs;
  cur_comms = comms;

  cur_comms->total_big_warn = 0;
  cur_comms->total_small_warn = 0;

  // clear cancelled flag
  comms->cancelled = FALSE;

  // sanity check
  if (!cur_info->filename || cur_info->filename[0] == 0)
  {
    SetErrorMsg("INTERNAL ERROR: Missing filename !");
    return GLBSP_E_BadArgs;
  }

  InitDebug();
  InitEndian();
 
  if (info->same_filenames)
    PrintMsg("* Output file is same as input file. Using -loadall\n\n");

  // opens and reads directory from the input wad
  ret = ReadWadFile(cur_info->filename);

  if (ret != GLBSP_E_OK)
  {
    TermDebug();
    return ret;
  }

  if (CountLevels() <= 0)
  {
    CloseWads();
    TermDebug();

    SetErrorMsg("No levels found in wad !");
    return GLBSP_E_Unknown;
  }
   
  PrintMsg("\n");
  PrintVerbose("Creating nodes using tunable factor of %d\n", info->factor);

  DisplayOpen(DIS_BUILDPROGRESS);
  DisplaySetTitle("glBSP Build Progress");

  file_msg = UtilFormat("File: %s", cur_info->filename);
 
  DisplaySetBarText(2, file_msg);
  DisplaySetBarLimit(2, CountLevels() * 10);
  DisplaySetBar(2, 0);

  UtilFree(file_msg);
  
  cur_comms->file_pos = 0;
  
  // loop over each level in the wad
  while (FindNextLevel())
  {
    ret = HandleLevel();

    if (ret != GLBSP_E_OK)
      break;

    cur_comms->file_pos += 10;
    DisplaySetBar(2, cur_comms->file_pos);
  }

  DisplayClose();

  // writes all the lumps to the output wad
  if (ret == GLBSP_E_OK)
  {
    ret = WriteWadFile(cur_info->filename);

    PrintMsg("\n");
    PrintMsg("Total serious warnings: %d\n", cur_comms->total_big_warn);
    PrintMsg("Total minor warnings: %d\n", cur_comms->total_small_warn);
  }

  // close wads and free memory
  CloseWads();

  TermDebug();

  cur_info  = NULL;
  cur_comms = NULL;
  cur_funcs = NULL;

  return ret;
}

