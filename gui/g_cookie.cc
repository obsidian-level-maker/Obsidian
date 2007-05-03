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

#include "g_cookie.h"

#include "lib_util.h"
#include "ui_chooser.h"
#include "ui_dialog.h"
#include "ui_window.h"
#include "main.h"


static FILE *cookie_fp;


static bool Cookie_SetValue(const char *name, const char *value)
{
  DebugPrintf("CONFIG: Name: [%s] Value: [%s]\n", name, value);

  // ignore the seed value
  if (StrCaseCmp(name, "seed") == 0)
    return true;

  // Settings...

  if (StrCaseCmp(name, "game") == 0)
    return main_win->setup_box->set_Game(value);
  if (StrCaseCmp(name, "port") == 0)
    return main_win->setup_box->set_Port(value);
  if (StrCaseCmp(name, "length") == 0)
    return main_win->setup_box->set_Length(value);
  if (StrCaseCmp(name, "mode") == 0)
    return main_win->setup_box->set_Mode(value);

  // Adjustments...

  if (StrCaseCmp(name, "health") == 0)
    return main_win->adjust_box->set_Health(value);
  if (StrCaseCmp(name, "ammo") == 0)
    return main_win->adjust_box->set_Ammo(value);
  if (StrCaseCmp(name, "mons") == 0)
    return main_win->adjust_box->set_Monsters(value);
  if (StrCaseCmp(name, "traps") == 0)
    return main_win->adjust_box->set_Traps(value);
  if (StrCaseCmp(name, "size") == 0)
    return main_win->adjust_box->set_Size(value);

  // Other stuff...
  if (StrCaseCmp(name, "last_file") == 0)
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

  // FIXME: duplicate code from g_doom.cc : How to merge??
 
  fprintf(cookie_fp, "-- Settings --\n");
  fprintf(cookie_fp, "seed = %s\n",  main_win->setup_box->get_Seed());
  fprintf(cookie_fp, "game = %s\n",  main_win->setup_box->get_Game());
  fprintf(cookie_fp, "port = %s\n",  main_win->setup_box->get_Port());
  fprintf(cookie_fp, "mode = %s\n",  main_win->setup_box->get_Mode());
  fprintf(cookie_fp, "length = %s\n",main_win->setup_box->get_Length());
  fprintf(cookie_fp, "\n");

  fprintf(cookie_fp, "-- Adjustments --\n");
  fprintf(cookie_fp, "health = %s\n", main_win->adjust_box->get_Health());
  fprintf(cookie_fp, "ammo = %s\n",   main_win->adjust_box->get_Ammo());
  fprintf(cookie_fp, "mons = %s\n",   main_win->adjust_box->get_Monsters());
  fprintf(cookie_fp, "traps = %s\n",  main_win->adjust_box->get_Traps());
  fprintf(cookie_fp, "size = %s\n",  main_win->adjust_box->get_Size());
  fprintf(cookie_fp, "\n");

  fprintf(cookie_fp, "-- Miscellaneous --\n");
  fprintf(cookie_fp, "last_file = %s\n", UI_GetLastFile());
  fprintf(cookie_fp, "\n");

  LogPrintf("DONE.\n\n");

  return true;
}

