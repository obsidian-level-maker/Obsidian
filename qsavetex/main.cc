//------------------------------------------------------------------------
//  QSAVETEX Main program
//------------------------------------------------------------------------
// 
//  Copyright (c) 2009  Andrew J Apted
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

/// #include <time.h>

#include "im_tex.h"
#include "pakfile.h"


#define VERSION  "0.71"


const char * output_name = "quake_tex.wad";


void FatalError(const char *message, ...)
{
  fprintf(stdout, "FATAL ERROR: ");

  va_list argptr;

  va_start(argptr, message);
  vfprintf(stdout, message, argptr);
  va_end(argptr);

  fprintf(stdout, "\n");
  fflush(stdout);

  exit(9);
}


void ShowTitle(void)
{
  printf("\n");
  printf("**** QSAVETEX v" VERSION "  (C) 2009 Andrew Apted ****\n");
  printf("\n");
}


void ShowUsage(void)
{
  printf("USAGE: qsavetex\n");
  printf("\n");

  printf("OPTIONS:\n");
  printf("   -h  -help        show this help text\n");
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
    return 2;
  }

  if (StringCaseCmp(opt, "-r") == 0 || StringCaseCmp(opt, "-raw") == 0)
  {
//    opt_raw = true;
    return 1;
  }

  FatalError("Unknown option: %s\n", argv[0]);
  return 0; // NOT REACHED
}


void AddInputFile(const char *filename)
{
  // input_names.push_back(std::string(filename));
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
    ShowTitle();
    ShowUsage();
    exit(1);
  }

  
  const char *working_path = GetExecutablePath(argv[0]);
  if (! working_path)
    working_path = ".";

  FileChangeDir(working_path);


  ShowTitle();

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

    AddInputFile(argv[0]);

    argv++;
    argc--;
  }


  if (! WAD2_OpenWrite(output_name))
    FatalError("Could not create texture file: %s", output_name);

  printf("\n");

  TEX_ExtractStart();

  TEX_ExtractFromPAK("pak0.pak");
  TEX_ExtractFromPAK("pak1.pak");

  TEX_ExtractDone();


  WAD2_CloseWrite();

  return 0;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
