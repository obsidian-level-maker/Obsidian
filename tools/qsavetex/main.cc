//------------------------------------------------------------------------
//  QSAVETEX : Main program
//------------------------------------------------------------------------
// 
//  Copyright (c) 2009-2010  Andrew J Apted
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

#include "main.h"

#include "im_tex.h"
#include "pakfile.h"


#define VERSION  "0.75"

#define LOG_FILE  "qsavetex_log.txt"

#define QUAKE1_OUTPUT  "quake_tex.wd2"
#define HEXEN2_OUTPUT  "hexen2_tex.wd2"


static FILE *log_file;

static const char * output_name = QUAKE1_OUTPUT;

static bool explicit_output = false;


void LogInit(const char *filename)
{
  log_file = fopen(filename, "w");

  LogPrintf("\n");
  LogPrintf("QSAVETEX LOG\n");
  LogPrintf("============\n\n");
}


void LogClose(void)
{
  LogPrintf("\n");

  if (log_file)
  {
    fflush(log_file);
    fclose(log_file);

    log_file = NULL;
  }
}


void LogPrintf(const char *str, ...)
{
  if (log_file)
  {
    va_list args;

    va_start(args, str);
    vfprintf(log_file, str, args);
    va_end(args);

    fflush(log_file);
  }
}


void FatalError(const char *message, ...)
{
  LogPrintf("\nFATAL ERROR OCCURRED:\n\n");

  if (log_file)
  {
    va_list argptr;

    va_start(argptr, message);
    vfprintf(log_file, message, argptr);
    va_end(argptr);

    fprintf(log_file, "\n\n");
  }

  // delete output file (need to close it first)
  WAD2_CloseWrite();

  if (FileDelete(output_name))
  {
    LogPrintf("\n(deleted incomplete output file)\n");
  }

  LogClose();

  exit(9);
}


void ShowHelp(void)
{
  printf("\n");
  printf("**** QSAVETEX v" VERSION "  (C) 2009-2010 Andrew Apted ****\n");
  printf("\n");
  printf("USAGE: qsavetex\n");
  printf("\n");

  printf("OPTIONS:\n");
  printf("   -h  --help            show this help text\n");
  printf("   -o  --output <name>   set the output filename\n");
  printf("\n");

  printf("This program is free software, under the terms of the GNU General\n");
  printf("Public License, and comes with ABSOLUTELY NO WARRANTY.  See the\n");
  printf("accompanying documentation for more details.  USE AT OWN RISK.\n");
  printf("\n");
}


/* returns number of arguments used, at least 1 */
int HandleOption(int argc, char **argv)
{
  const char *opt = argv[0];

  // GNU style options begin with two dashes
  if (opt[0] == '-' && opt[1] == '-')
    opt++;

  if (StringCaseCmp(opt, "-o") == 0 || StringCaseCmp(opt, "-output") == 0)
  {
    if (argc <= 1 || argv[1][0] == '-')
      FatalError("Missing output filename after %s\n", argv[0]);

    output_name = StringDup(argv[1]);
    explicit_output = true;
    return 2;
  }

  FatalError("Unknown option: %s\n", argv[0]);
  return 0; // NOT REACHED
}


void DetectGame(void)
{
  if (explicit_output)
    return;

  if (! PAK_OpenRead("pak0.pak"))
    return;

  bool is_hexen2 = false;

  if (PAK_FindEntry("puzzles.txt") >= 0)
  {
    is_hexen2 = true;
    output_name = HEXEN2_OUTPUT;
  }

  PAK_CloseRead();

  LogPrintf("\nGame detected: %s\n\n", is_hexen2 ? "Hexen II" : "Quake");
}


int main(int argc, char **argv)
{
  // skip program name itself
  argv++, argc--;

  if (argc >= 1 &&
      (StringCaseCmp(argv[0], "/?") == 0 ||
       StringCaseCmp(argv[0], "-h") == 0 ||
       StringCaseCmp(argv[0], "-help") == 0 ||
       StringCaseCmp(argv[0], "--help") == 0))
  {
    ShowHelp();
    return 1;
  }


  LogInit(LOG_FILE);

  const char *working_path = GetExecutablePath(argv[0]);
  if (! working_path)
    working_path = ".";

  FileChangeDir(working_path);


  // handle command-line arguments
  while (argc > 0)
  {
    if (argv[0][0] == '-')
    {
      int num = HandleOption(argc, argv);

      argv += num;
      argc -= num;

      continue;
    }

    argv++; argc--;
  }


  DetectGame();

  if (! WAD2_OpenWrite(output_name))
  {
    FatalError("Could not create file: %s\n", output_name);
  }

  LogPrintf("\n");


  TEX_ExtractStart();

  TEX_ExtractFromPAK("pak0.pak");
  TEX_ExtractFromPAK("pak1.pak");

  TEX_ExtractDone();

  WAD2_CloseWrite();


  LogPrintf("\nSuccess!");
  LogClose();

  return 0;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
