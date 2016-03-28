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


// TODO : stuff to parse PO files


//----------------------------------------------------------------------


typedef struct
{
	const char *langcode;
	const char *fullname;

} available_language_t;


static std::vector<available_language_t> available_langs;


void Trans_ParseLangLine(const char *line)
{
	// skip any BOM (may occur at very start of file)
	if ((u8_t)(line[0]) == 0xEF &&
		(u8_t)(line[1]) == 0xBB &&
		(u8_t)(line[2]) == 0xBF)
	{
		line += 3;
	}

	// TODO
}


void Trans_Init()
{
	// TODO : stuff to create a Lua state to store messages in

	// read the list of languages

	char *path = StringPrintf("%s/language/LANGS.txt", install_dir);

	FILE *fp = fopen(path, "rb");

	if (! fp)
	{
		LogPrintf("WARNING: missing language/LANGS.txt file\n");
		return;
	}

	LogPrintf("Loading the language/LANGS.txt file...\n");

	// FIXME

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
