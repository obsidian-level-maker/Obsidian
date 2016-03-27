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

//#include "lib_argv.h"
//#include "lib_util.h"

#include "main.h"


// TODO : stuff to parse PO files


//----------------------------------------------------------------------


void Trans_ParseLangLine(const char *line)
{
}


void Trans_Init()
{
	// TODO : read the language/LANGS.txt file

	// TODO : stuff to create a Lua state to store messages in
}


const char * Trans_GetLanguage(int idx)
{
	// end of list
	return NULL;
}


void Trans_SetLanguage(int idx)
{
}


void Trans_SetLanguageByCode(const char *langcode)
{
}


//----------------------------------------------------------------------


const char * ob_gettext(const char *s)
{
	return s;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
