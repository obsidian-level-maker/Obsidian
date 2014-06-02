//------------------------------------------------------------------------
//  COOKIE : Save/Load user settings
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2014 Andrew Apted
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
#include "m_cookie.h"
#include "m_lua.h"


typedef enum
{
	CCTX_Load,
	CCTX_Save,
	CCTX_Arguments
}
cookie_context_e;


static FILE *cookie_fp;

static int context;

static std::string active_module;

static bool keep_seed;


static void Cookie_SetValue(const char *name, const char *value)
{
	if (context == CCTX_Load)
		DebugPrintf("CONFIG: Name: [%s] Value: [%s]\n", name, value);
	else if (context == CCTX_Arguments)
		DebugPrintf("ARGUMENT: Name: [%s] Value: [%s]\n", name, value);


	// the new style module syntax
	if (name[0] == '@')
	{
		active_module = (name + 1);

		name = "self";
	}

	if (active_module[0])
	{
		const char *module = active_module.c_str();

		ob_set_mod_option(module, name, value);

		if (main_win)
			main_win->mod_box->ParseOptValue(module, name, value);

		return;
	}


	// need special handling for the 'seed' value
	if (StringCaseCmp(name, "seed") == 0)
	{
		// ignore seed when loading a config file unless
		// the -k / --keep option is given.

		if (context == CCTX_Arguments || keep_seed)
			ob_set_config(name, value);

		return;
	}


	if (main_win)
	{
		// -- Game Settings --
		if (main_win->game_box->ParseValue(name, value))
			return;

		// -- Level Architecture --
		if (main_win->level_box->ParseValue(name, value))
			return;

		// -- Playing Style --
		if (main_win->play_box->ParseValue(name, value))
			return;
	}


	// old style module syntax (for compatibility)
	const char *option = strchr(name, '.');

	if (option)
	{
		char *module = StringDup(name);
		module[option - name] = 0;

		option++;

		ob_set_mod_option(module, option, value);

		if (main_win)
			main_win->mod_box->ParseOptValue(module, option, value);

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

	// curly brackets are just for aesthetics : ignore them
	if (*buf == '{' || *buf == '}')
		return true;

	if (! (isalpha(*buf) || *buf == '@'))
	{
		LogPrintf("Weird config line: [%s]\n", buf);
		return false;
	}

	// Righteo, line starts with an identifier.  It should be of the
	// form "name = value".  We'll terminate the identifier, and pass
	// the name/value strings to the matcher function.

	const char *name = buf;

	for (buf++ ; isalnum(*buf) || *buf == '_' || *buf == '.' ; buf++)
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

	Cookie_SetValue(name, buf);
	return true;
}


//------------------------------------------------------------------------

bool Cookie_Load(const char *filename)
{
	context = CCTX_Load;

	keep_seed = (ArgvFind('k', "keep") >= 0);

	active_module.clear();

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

	fclose(cookie_fp);

	return true;
}


bool Cookie_LoadString(const char *str)
{
	context = CCTX_Load;
	keep_seed = false;

	active_module.clear();

	LogPrintf("Reading Config (from manager)...\n");

	// simple line-by-line parser
	char buffer[MSG_BUF_LEN];

	while (mem_gets(buffer, MSG_BUF_LEN-2, &str))
	{
		Cookie_ParseLine(buffer);
	}

	LogPrintf("DONE.\n\n");

	return true;
}


bool Cookie_Save(const char *filename)
{
	context = CCTX_Save;

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
	fprintf(cookie_fp, "-- " OBLIGE_TITLE " (C) 2006-2014 Andrew Apted\n");
	fprintf(cookie_fp, "-- http://oblige.sourceforge.net/\n\n");

	// settings...
	std::vector<std::string> lines;

	ob_read_all_config(&lines);

	for (unsigned int i = 0 ; i < lines.size() ; i++)
	{
		fprintf(cookie_fp, "%s\n", lines[i].c_str());
	}

	LogPrintf("DONE.\n\n");

	fclose(cookie_fp);

	return true;
}


void Cookie_ParseArguments(void)
{
	context = CCTX_Arguments;

	active_module.clear();

	for (int i = 0 ; i < arg_count ; i++)
	{
		const char *arg = arg_list[i];

		if (arg[0] == '-')
			continue;

		if (arg[0] == '{' || arg[0] == '}')
			continue;

		const char *eq_pos = strchr(arg, '=');
		if (! eq_pos)
		{
			// allow module names to omit the (rather useless) value
			if (arg[0] == '@')
				Cookie_SetValue(arg, "1");

			continue;
		}

		// split argument into name/value pair
		int eq_offset = (eq_pos - arg);

		char *name = StringDup(arg);
		char *value = name + eq_offset + 1;

		name[eq_offset] = 0;

		if (name[0] == 0 || value[0] == 0)
			Main_FatalError("Bad setting on command line: '%s'\n", arg);

		Cookie_SetValue(name, value);

		StringFree(name);
	}
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
