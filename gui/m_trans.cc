//----------------------------------------------------------------------
//  TRANSLATION / INTERNATIONALIZATION
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2016 Andrew Apted
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
//----------------------------------------------------------------------

#include "headers.h"
#include "hdr_lua.h"

#include "lib_util.h"

#include "main.h"
#include "m_trans.h"

#ifndef WIN32
#include <locale.h>
#endif


// current language
const char * t_language = "AUTO";


/* DETERMINE CURRENT LANGUAGE */

static const char * Trans_GetUserLanguage()
{
}


//----------------------------------------------------------------------


// TODO : stuff to parse PO files


//----------------------------------------------------------------------


typedef struct
{
	const char *langcode;
	const char *fullname;

} available_language_t;


static std::vector<available_language_t> available_langs;


void Trans_ParseLangLine(char *line)
{
	char *pos;

	// skip any BOM (may occur at very start of file)
	if ((u8_t)(line[0]) == 0xEF &&
		(u8_t)(line[1]) == 0xBB &&
		(u8_t)(line[2]) == 0xBF)
	{
		line += 3;
	}

	// remove CR/LF line ending
	pos = (char *)strchr(line, '\r');
	if (pos) pos[0] = 0;

	pos = (char *)strchr(line, '\n');
	if (pos) pos[0] = 0;

	// ignore blank lines and comments
	if (line[0] == 0 || line[0] == '#')
		return;

	// find separator
	pos = (char *)strchr(line, '=');

	if (! pos)
		return;  // uh oh

	*pos++ = 0;

	if (strlen(line) < 2 || strlen(pos) < 2)
		return;	 // uh oh

	// Ok, add the language

	available_language_t lang;

	lang.langcode = StringDup(line);
	lang.fullname = StringDup(pos);

//DEBUG
//  LogPrintf("  '%s' --> '%s'\n", lang.langcode, lang.fullname);

	available_langs.push_back(lang);
}


void Trans_Init()
{
#ifndef WIN32
	setlocale(LC_ALL, "");
#endif

	// TODO : stuff to create a Lua state to store messages in

	/* read the list of languages */

	char *path = StringPrintf("%s/language/LANGS.txt", install_dir);

	FILE *fp = fopen(path, "rb");

	if (! fp)
	{
		LogPrintf("WARNING: missing language/LANGS.txt file\n");
		return;
	}

	LogPrintf("Loading language list: %s\n", path);

	// simple line-by-line parser
	char buffer[MSG_BUF_LEN];

	while (fgets(buffer, MSG_BUF_LEN-2, fp))
	{
		Trans_ParseLangLine(buffer);
	}

	LogPrintf("DONE.\n\n");

	fclose(fp);
}


void Trans_SetLanguage(const char *langcode)
{
	// TODO
}


const char * Trans_GetAvailCode(int idx)
{
	SYS_ASSERT(idx >= 0);

	// end of list?
	if (idx >= (int)available_langs.size())
		return NULL;

	return available_langs[idx].langcode;
}


const char * Trans_GetAvailLanguage(int idx)
{
	SYS_ASSERT(idx >= 0);

	// end of list?
	if (idx >= (int)available_langs.size())
		return NULL;

	return available_langs[idx].fullname;
}


//----------------------------------------------------------------------


const char * ob_gettext(const char *s)
{
	return s;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
