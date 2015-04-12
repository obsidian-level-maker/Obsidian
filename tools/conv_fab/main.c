//------------------------------------------------------------------------
// MAIN : Command-line version main program
//------------------------------------------------------------------------
//
//  GL-Friendly Node Builder (C) 2000-2010 Andrew Apted
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

#include "glbsp.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <math.h>
#include <limits.h>
#include <assert.h>

#include "display.h"


static nodebuildinfo_t info;
static volatile nodebuildcomms_t comms;


/* ----- user information ----------------------------- */

static void ShowTitle(void)
{
  TextPrintMsg(
    "\n"
    "----***  CONV_FAB  ***----\n\n"
  );
}

static void ShowOptions(void)
{
  TextPrintMsg(
    "Usage: conv_fab [options] *.wad\n"
    "\n"
    "General Options:\n"
    "  (none yet)\n"
    "\n");
}

static void ShowDivider(void)
{
  TextPrintMsg("\n------------------------------------------------------------\n\n");
}

static int FileExists(const char *filename)
{
  FILE *fp = fopen(filename, "rb");

  if (fp)
  {
    fclose(fp);
    return TRUE;
  }

  return FALSE;
}


/* ----- response files ----------------------------- */

#define RESP_MAX_ARGS  1000
#define MAX_WORD_LEN   4000

static const char *resp_argv[RESP_MAX_ARGS+4];
static int resp_argc;

static char word_buffer[MAX_WORD_LEN+4];


static void AddArg(const char *str)
{
  if (resp_argc >= RESP_MAX_ARGS)
    TextFatalError("Error: Too many options! (limit is %d)\n", RESP_MAX_ARGS);

  resp_argv[resp_argc++] = GlbspStrDup(str);

#if 0  // DEBUGGING
  fprintf(stderr, "Arg [%s]\n", str);
#endif
}

static void ProcessResponseFile(const char *filename)
{
  int word_len = 0;
  int in_quote = 0;
 
  FILE *fp = fopen(filename, "rb");

  if (! fp)
    TextFatalError("Error: Cannot find RESPONSE file: %s\n", filename);

  // the word buffer is always kept NUL-terminated
  word_buffer[0] = 0;

  for (;;)
  {
    int ch = fgetc(fp);

    if (ch == EOF)
      break;

    if (isspace(ch) && !in_quote)
    {
      if (word_len > 0)
        AddArg(word_buffer);

      word_len = 0;
      in_quote = 0;

      continue;
    }

    if (isspace(ch) && !in_quote)
      continue;

    if ((ch == '\n' || ch == '\r') && in_quote)
      break;  // causes the unclosed-quotes error

    if (ch == '"')
    {
      in_quote = ! in_quote;
      continue;
    }

    if (word_len >= MAX_WORD_LEN)
      TextFatalError("Error: option in RESPONSE file too long (limit %d chars)\n",
          MAX_WORD_LEN);

    word_buffer[word_len++] = ch;
    word_buffer[word_len] = 0;
  }

  if (in_quote)
    TextFatalError("Error: unclosed quotes in RESPONSE file\n");

  if (word_len > 0)
    AddArg(word_buffer);

  fclose(fp);
}

static void BuildArgumentList(int argc, char **argv)
{
  for (; argc > 0; argv++, argc--)
  {
    if (argv[0][0] == '@')
    {
      ProcessResponseFile(argv[0] + 1);
      continue;
    }

    AddArg(*argv);
  }

  resp_argv[resp_argc] = NULL;
}

static void FreeArgumentList(void)
{
  while (--resp_argc >= 0)
  {
    GlbspFree(resp_argv[resp_argc]);
  }
}


/* ----- main program ----------------------------- */

int main(int argc, char **argv)
{
  int extra_idx = 0;

  TextStartup();

  ShowTitle();

  // skip program name itself
  argv++, argc--;
  
  if (argc <= 0)
  {
    ShowOptions();
    TextShutdown();
    exit(1);
  }

  if (strcmp(argv[0], "/?") == 0 || strcmp(argv[0], "-h") == 0 ||
      strcmp(argv[0], "-help") == 0 || strcmp(argv[0], "--help") == 0 ||
      strcmp(argv[0], "-HELP") == 0 || strcmp(argv[0], "--HELP") == 0)
  {
    ShowOptions();
    TextShutdown();
    exit(1);
  }

  BuildArgumentList(argc, argv);

  info  = default_buildinfo;
  comms = default_buildcomms;

  if (GLBSP_E_OK != GlbspParseArgs(&info, &comms, resp_argv, resp_argc))
  {
    TextFatalError("Error: %s\n", comms.message ? comms.message : 
        "(Unknown error when parsing args)");
  }

  if (info.extra_files)
  {
    int ext_j;

    /* catch this mistake: glbsp in.wad out.wad (forget the -o) */

    if (info.input_file && info.extra_files[0] && ! info.extra_files[1] &&
        FileExists(info.input_file) && ! FileExists(info.extra_files[0]))
    {
      TextFatalError("Error: Cannot find WAD file: %s ("
          "Maybe you forgot -o)\n", info.extra_files[0]);
    }

    /* balk NOW if any of the input files doesn't exist */

    if (! FileExists(info.input_file))
      TextFatalError("Error: Cannot find WAD file: %s\n",
          info.input_file);

    for (ext_j = 0; info.extra_files[ext_j]; ext_j++)
    {
      if (FileExists(info.extra_files[ext_j]))
        continue;

      TextFatalError("Error: Cannot find WAD file: %s\n",
          info.extra_files[ext_j]);
    }
  }

  /* process each input file */

  for (;;)
  {
    if (GLBSP_E_OK != GlbspCheckInfo(&info, &comms)) 
    {
      TextFatalError("Error: %s\n", comms.message ? comms.message : 
          "(Unknown error when checking args)");
    }

    if (info.no_progress)
      TextDisableProgress();

    if (GLBSP_E_OK != GlbspBuildNodes(&info, &cmdline_funcs, &comms))
    {
      TextFatalError("Error: %s\n", comms.message ? comms.message : 
          "(Unknown error during build)");
    }

    /* when there are extra input files, process them too */

    if (! info.extra_files || ! info.extra_files[extra_idx])
      break;

    ShowDivider();

    GlbspFree(info.input_file);
    GlbspFree(info.output_file);

    info.input_file  = GlbspStrDup(info.extra_files[extra_idx]);
    info.output_file = NULL;

    extra_idx++;
  }

  TextShutdown();
  FreeArgumentList();

  return 0;
}

