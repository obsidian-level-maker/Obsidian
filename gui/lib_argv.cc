//------------------------------------------------------------------------
//  Argument library
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#include "lib_argv.h"
#include "lib_util.h"


const char **arg_list = NULL;
int arg_count = 0;

//
// ArgvInit
//
// Initialise argument list.  Do NOT include the program name
// (usually in argv[0]).  The strings (and array) are copied.
//
// NOTE: doesn't merge multiple uses of an option, hence
//       using ArgvFind() will only return the first usage.
//
void ArgvInit(int argc, const char **argv)
{
	arg_count = argc;
	SYS_ASSERT(arg_count >= 0);

	if (arg_count == 0)
	{
		arg_list = NULL;
		return;
	}

	arg_list = new const char *[arg_count];

	int dest = 0;

	for (int i = 0; i < arg_count; i++)
	{
		const char *cur = argv[i];
		SYS_NULL_CHECK(cur);

#ifdef MACOSX
		// ignore MacOS X rubbish
		if (strncmp(cur, "-psn", 4) == 0)
			continue;
#endif

		// support GNU-style long options
		if (cur[0] == '-' && cur[1] == '-' && isalnum(cur[2]))
			cur++;

		arg_list[dest] = strdup(cur);

		// support DOS-style short options
		if (cur[0] == '/' && (isalnum(cur[1]) || cur[1] == '?') && cur[2] == 0)
			*(char *)(arg_list[dest]) = '-';

		dest++;
	}

	arg_count = dest;
}


void ArgvClose(void)
{
	while (arg_count-- > 0)
		free((void *) arg_list[arg_count]);

	if (arg_list)
		delete[] arg_list;
}


int ArgvFind(char short_name, const char *long_name, int *num_params)
{
	SYS_ASSERT(short_name || long_name);

	if (num_params)
		*num_params = 0;

	int p = 0;

	for (; p < arg_count; p++)
	{
		if (! ArgvIsOption(p))
			continue;

		const char *str = arg_list[p];

		if (short_name && (short_name == tolower(str[1])) && str[2] == 0)
			break;

		if (long_name && (StringCaseCmp(long_name, str + 1) == 0))
			break;
	}

	if (p >= arg_count)  // NOT FOUND
		return -1;

	if (num_params)
	{
		int q = p + 1;

		while ((q < arg_count) && ! ArgvIsOption(q))
			q++;

		*num_params = q - p - 1;
	}

	return p;
}


bool ArgvIsOption(int index)
{
	SYS_ASSERT(index >= 0);
	SYS_ASSERT(index < arg_count);

	const char *str = arg_list[index];
	SYS_NULL_CHECK(str);

	return (str[0] == '-');
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
