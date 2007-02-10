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

#include "g_cookie.h"

#include "hdr_fltk.h"
#include "ui_dialog.h"
#include "ui_window.h"
#include "main.h"


static FILE *cookie_fp;


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
    return false;

  // Righteo, line starts with an identifier.  It should be of the
  // form "name = value".  We'll terminate the identifier, and pass
  // the name/value strings to the matcher function.

  const char *name = buf;

  for (buf++; isalpha(*buf) || *buf == '_'; buf++)
  { /* nothing here */ }

  while (isspace(*buf))
    *buf++ = 0;
  
  if (*buf != '=')
    return false;

  *buf++ = 0;

  while (isspace(*buf))
    buf++;

  if (*buf == 0)
    return false;

  DebugPrintf("COOKIE: Name: [%s]  Value: [%s]\n", name, buf);

  // FIXME: match name

  return true;
}

bool Cookie_Load(const char *filename)
{
  cookie_fp = fopen(filename, "r");

  if (! cookie_fp)
  {
    LogPrintf("Missing Settings file -- using defaults.\n\n");
    return false;
  }

  LogPrintf("Loading Settings...\n");

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

  LogPrintf("Saving Settings...\n");

  // header...
  fprintf(cookie_fp, "-- SETTINGS FOR OBLIGE %s\n", OBLIGE_VERSION); 
  fprintf(cookie_fp, "-- " OBLIGE_TITLE " (C) 2006,2007 Andrew Apted\n");
  fprintf(cookie_fp, "-- http://oblige.sourceforge.net/\n\n");

  // FIXME: duplicate code from g_doom.cc : How to merge??
 
  fprintf(cookie_fp, "-- General --\n");
  fprintf(cookie_fp, "seed = %s\n",  main_win->setup_box->cur_Seed());
  fprintf(cookie_fp, "game = %s\n",  main_win->setup_box->cur_Game());
  fprintf(cookie_fp, "addon = %s\n", main_win->setup_box->cur_Addon());
  fprintf(cookie_fp, "mode = %s\n",  main_win->setup_box->cur_Mode());
  fprintf(cookie_fp, "length = %s\n",main_win->setup_box->cur_Length());
  fprintf(cookie_fp, "\n");

  fprintf(cookie_fp, "-- Adjustments --\n");
  fprintf(cookie_fp, "health = %s\n", main_win->adjust_box->cur_Health());
  fprintf(cookie_fp, "ammo = %s\n",   main_win->adjust_box->cur_Ammo());
  fprintf(cookie_fp, "mons = %s\n",   main_win->adjust_box->cur_Monsters());
  fprintf(cookie_fp, "traps = %s\n",  main_win->adjust_box->cur_Traps());
  
  LogPrintf("DONE.\n\n");

  return true;
}

