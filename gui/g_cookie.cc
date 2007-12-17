//------------------------------------------------------------------------
//  COOKIE : Save/Load user settings
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
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "main.h"

#include "g_cookie.h"
#include "g_lua.h"
#include "ui_chooser.h"


static FILE *cookie_fp;


static bool Cookie_SetValue(const char *name, const char *value)
{
  DebugPrintf("CONFIG: Name: [%s] Value: [%s]\n", name, value);

  // ignore the seed value
  if (StringCaseCmp(name, "seed") == 0)
    return true;

  // -- Game Settings --
  if (main_win->game_box->ParseValue(name, value))
    return true;

  // -- Level Architecture --
  if (main_win->level_box->ParseValue(name, value))
    return true;

  // -- Playing Style --
  if (main_win->play_box->ParseValue(name, value))
    return true;

  // -- Miscellaneous --
  if (StringCaseCmp(name, "last_file") == 0)
    return UI_SetLastFile(value);

  LogPrintf("CONFIG: Ignoring unknown setting: %s = %s\n", name, value);
  return false;
}

static bool Cookie_ParseLine(char *buf)
{
  // remove whitespace
  while (isspace(*buf))
    buf++;

  int len = strlen(buf);

  while (len > 0 && isspace(buf[len-1]))
    buf[--len] = 0;
 
  // ignore blank lines and comments
  if (*buf == 0)
    return true;

  if (buf[0] == '-' && buf[1] == '-')
    return true;

  if (! isalpha(*buf))
  {
    LogPrintf("Weird config line: [%s]\n", buf);
    return false;
  }

  // Righteo, line starts with an identifier.  It should be of the
  // form "name = value".  We'll terminate the identifier, and pass
  // the name/value strings to the matcher function.

  const char *name = buf;

  for (buf++; isalpha(*buf) || *buf == '_'; buf++)
  { /* nothing here */ }

  while (isspace(*buf))
    *buf++ = 0;
  
  if (*buf != '=')
  {
    LogPrintf("Config line missing '=': [%s]\n", buf);
    return false;
  }

  *buf++ = 0;

  while (isspace(*buf))
    buf++;

  if (*buf == 0)
  {
    LogPrintf("Config line missing value!\n");
    return false;
  }

  return Cookie_SetValue(name, buf);
}


//------------------------------------------------------------------------


bool Cookie_Load(const char *filename)
{
  cookie_fp = fopen(filename, "r");

  if (! cookie_fp)
  {
    LogPrintf("Missing Config file -- using defaults.\n\n");
    return false;
  }

  LogPrintf("Loading Config...\n");

  // simple line-by-line parser
  char buffer[MSG_BUF_LEN];

  int error_count = 0;

  while (fgets(buffer, MSG_BUF_LEN-2, cookie_fp))
  {
    if (! Cookie_ParseLine(buffer))
      error_count += 1;
  }

  if (error_count > 0)
    LogPrintf("DONE (found %d parse errors)\n\n", error_count);
  else
    LogPrintf("DONE.\n\n");

  return true;
}

bool Cookie_Save(const char *filename)
{
  cookie_fp = fopen(filename, "w");

  if (! cookie_fp)
  {
    LogPrintf("Error: unable to create file: %s\n(%s)\n\n",
        filename, strerror(errno));
    return false;
  }

  LogPrintf("Saving Config...\n");

  // header...
  fprintf(cookie_fp, "-- CONFIG FILE : OBLIGE %s\n", OBLIGE_VERSION); 
  fprintf(cookie_fp, "-- " OBLIGE_TITLE " (C) 2006,2007 Andrew Apted\n");
  fprintf(cookie_fp, "-- http://oblige.sourceforge.net/\n\n");

  fprintf(cookie_fp, "-- Game Settings --\n");
  fprintf(cookie_fp, "%s\n", main_win->game_box->GetAllValues());

  fprintf(cookie_fp, "-- Level Architecture --\n");
  fprintf(cookie_fp, "%s\n", main_win->level_box->GetAllValues());

  fprintf(cookie_fp, "-- Playing Style --\n");
  fprintf(cookie_fp, "%s\n", main_win->play_box->GetAllValues());

//fprintf(cookie_fp, "-- Custom Mods --\n");
//fprintf(cookie_fp, "%s\n", main_win->mod_box->GetAllValues());

//fprintf(cookie_fp, "-- Custom Options --\n");
//fprintf(cookie_fp, "%s\n", main_win->option_box->GetAllValues());

  fprintf(cookie_fp, "-- Miscellaneous --\n");
  fprintf(cookie_fp, "last_file = %s\n", UI_GetLastFile());
  fprintf(cookie_fp, "\n");

  LogPrintf("DONE.\n\n");

  return true;
}

