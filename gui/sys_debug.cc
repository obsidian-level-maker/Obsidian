//------------------------------------------------------------------------
//  Debugging support
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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
#include "main.h"

#define LOG_FILENAME  DATA_DIR "/LOGS.txt"


static FILE *log_file = NULL;

static bool debugging = false;
static bool terminal  = false;


//
// LogInit
//
void LogInit(bool debug_enable)
{
  log_file = fopen(LOG_FILENAME, "w");

  LogPrintf("========= START OF OBLIGE LOGS =========\n\n");

  debugging = debug_enable;
  terminal  = debug_enable;

  if (debugging)
    LogPrintf("DEBUGGING ENABLED.\n\n");
}

//
// LogClose
//
void LogClose(void)
{
  LogPrintf("\n========= END OF OBLIGE LOGS =========\n");

  if (log_file)
  {
    fclose(log_file);

    log_file = NULL;
  }
}

//
// LogPrintf
//
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

  // show on the Linux terminal too
  if (terminal)
  {
    va_list args;

    va_start(args, str);
    vfprintf(stderr, str, args);
    va_end(args);
  }
}

//
// DebugPrintf
//
void DebugPrintf(const char *str, ...)
{
  if (log_file && debugging)
  {
    static char buffer[MSG_BUF_LEN];

    va_list args;

    va_start(args, str);
    vsnprintf(buffer, MSG_BUF_LEN-1, str, args);
    va_end(args);

    buffer[MSG_BUF_LEN-2] = 0;

    // prefix each debugging line with a special symbol

    char *pos = buffer;
    char *next;

    while (pos && *pos)
    {
      next = strchr(pos, '\n');

      if (next) *next++ = 0;

      LogPrintf("# %s\n", pos);

      pos = next;
    }
  }
}

