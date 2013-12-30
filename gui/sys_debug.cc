//------------------------------------------------------------------------
//  Debugging support
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
#include "main.h"
#include "lib_util.h"


#define DEBUG_BUF_LEN  20000


static FILE *log_file = NULL;

static bool debugging = false;
static bool terminal  = false;


void LogInit(const char *filename)
{
	if (filename)
	{
		const char *path = StringPrintf("%s/%s", home_dir, filename);

		log_file = fopen(path, "w");

		StringFree(path);
	}

	LogPrintf("====== START OF OBLIGE LOGS ======\n");
}


void LogEnableDebug(bool enable)
{
	if (debugging == enable)
		return;

	debugging = enable;

	if (debugging)
		LogPrintf("===  DEBUGGING ENABLED  ===\n\n");
	else
		LogPrintf("===  DEBUGGING DISABLED  ===\n\n");
}

void LogEnableTerminal(bool enable)
{
	terminal = enable;
}


void LogClose(void)
{
	LogPrintf("\n====== END OF OBLIGE LOGS ======\n\n");

	if (log_file)
	{
		fclose(log_file);

		log_file = NULL;
	}
}


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
		vfprintf(stdout, str, args);
		va_end(args);
	}
}


void DebugPrintf(const char *str, ...)
{
	if (debugging)
	{
		static char buffer[DEBUG_BUF_LEN];

		va_list args;

		va_start(args, str);
		vsnprintf(buffer, DEBUG_BUF_LEN-1, str, args);
		va_end(args);

		buffer[DEBUG_BUF_LEN-2] = 0;

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

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
