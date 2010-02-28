//------------------------------------------------------------------------
//  COOKIE : Save/Load user settings
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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

#include "lib_argv.h"
#include "lib_util.h"
#include "main.h"

#include "g_cookie.h"
#include "g_lua.h"
#include "ui_chooser.h"


static FILE *cookie_fp;

static bool doing_pre_load;


static bool ParseMiscOption(const char *name, const char *value)
{
  if (StringCaseCmp(name, "create_backups") == 0)
  {
    if (doing_pre_load)
      create_backups = atoi(value) ? true : false;
  }
  else if (StringCaseCmp(name, "debug_messages") == 0)
  {
    if (doing_pre_load)
      debug_messages = atoi(value) ? true : false;
  }
  else if (StringCaseCmp(name, "hide_modules") == 0)
  {
    if (doing_pre_load)
      hide_module_panel = atoi(value) ? true : false;
  }
  else
  {
    return false;  // not a misc option
  }

  return true;
}


static void Cookie_SetValue(const char *name, const char *value)
{
  if (! doing_pre_load)
    DebugPrintf("CONFIG: Name: [%s] Value: [%s]\n", name, value);

  // -- Misc Options --
  if (ParseMiscOption(name, value))
    return;

  // skip everything else during PRELOAD
  if (doing_pre_load)
    return;

  SYS_ASSERT(main_win);

  if (StringCaseCmp(name, "last_file") == 0)
  {
    UI_SetLastFile(value);
    return;
  }


  // -- Game Settings --
  if (main_win->game_box->ParseValue(name, value))
    return;
  
  // -- Level Architecture --
  if (main_win->level_box->ParseValue(name, value))
    return;
  
  // -- Playing Style --
  if (main_win->play_box->ParseValue(name, value))
    return;

  // -- Custom Modules/Options --
  const char *dot = strchr(name, '.');
  if (dot)
  {
    char *module = StringDup(name);
    module[dot - name] = 0;

    main_win->mod_box->ParseOptValue(module, dot+1 /* option */, value);

    StringFree(module);
    return;
  }

  // everything else goes to the script
  ob_set_config(name, value);
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
    if (! doing_pre_load)
      LogPrintf("Weird config line: [%s]\n", buf);

    return false;
  }

  // Righteo, line starts with an identifier.  It should be of the
  // form "name = value".  We'll terminate the identifier, and pass
  // the name/value strings to the matcher function.

  const char *name = buf;

  for (buf++; isalnum(*buf) || *buf == '_' || *buf == '.'; buf++)
  { /* nothing here */ }

  while (isspace(*buf))
    *buf++ = 0;
  
  if (*buf != '=')
  {
    if (! doing_pre_load)
      LogPrintf("Config line missing '=': [%s]\n", buf);

    return false;
  }

  *buf++ = 0;

  while (isspace(*buf))
    buf++;

  if (*buf == 0)
  {
    if (! doing_pre_load)
      LogPrintf("Config line missing value!\n");

    return false;
  }

  Cookie_SetValue(name, buf);
  return true;
}


//------------------------------------------------------------------------


bool Cookie_Load(const char *filename, bool pre_load)
{
  doing_pre_load = pre_load;

  cookie_fp = fopen(filename, "r");

  if (! cookie_fp)
  {
    if (! doing_pre_load)
      LogPrintf("Missing Config file -- using defaults.\n\n");

    return false;
  }

  LogPrintf("Loading Config (%s)...\n", pre_load ? "PRELOAD" : "FULL");

  // simple line-by-line parser
  char buffer[MSG_BUF_LEN];

  int error_count = 0;

  while (fgets(buffer, MSG_BUF_LEN-2, cookie_fp))
  {
    if (! Cookie_ParseLine(buffer))
      error_count += 1;
  }

  if (error_count > 0 && ! pre_load)
    LogPrintf("DONE (found %d parse errors)\n\n", error_count);
  else
    LogPrintf("DONE.\n\n");

  fclose(cookie_fp);

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
  fprintf(cookie_fp, "-- " OBLIGE_TITLE " (C) 2006-2010 Andrew Apted\n");
  fprintf(cookie_fp, "-- http://oblige.sourceforge.net/\n\n");

  fprintf(cookie_fp, "-- Misc Options --\n");
  fprintf(cookie_fp, "create_backups = %d\n", create_backups ? 1 : 0);
  fprintf(cookie_fp, "debug_messages = %d\n", debug_messages ? 1 : 0);
  fprintf(cookie_fp, "hide_modules = %d\n", hide_module_panel ? 1 : 0);
  fprintf(cookie_fp, "last_file = %s\n", UI_GetLastFile());
  fprintf(cookie_fp, "\n");


  std::vector<std::string> lines;

  ob_read_all_config(&lines, true /* all_opts */);

  for (unsigned int i = 0; i < lines.size(); i++)
  {
    fprintf(cookie_fp, "%s\n", lines[i].c_str());
  }

  LogPrintf("DONE.\n\n");

  fclose(cookie_fp);

  return true;
}


void Cookie_ParseArguments(void)
{
  doing_pre_load = false;

  for (int i = 0; i < arg_count; i++)
  {
    const char *arg = arg_list[i];

    if (arg[0] == '-')
      continue;

    const char *eq_pos = strchr(arg, '=');
    if (! eq_pos)
      continue;

    // split argument into name/value pair
    int eq_offset = (eq_pos - arg);

    char *name = StringDup(arg);
    char *value = name + eq_offset + 1;

    name[eq_offset] = 0;

    if (name[0] == 0 || value[0] == 0)
      Main_FatalError("Bad setting on command line: '%s'\n", arg);

    if (batch_mode)
    {
      DebugPrintf("ARGUMENT: Name: [%s] Value: [%s]\n", name, value);
      ob_set_config(name, value);
    }
    else
    {
      // need special handling for the 'seed' value
      if (StringCaseCmp(name, "seed") == 0)
        main_win->game_box->SetSeed(atoi(value));
      else
        Cookie_SetValue(name, value);
    }

    StringFree(name);
  }
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
