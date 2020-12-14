//------------------------------------------------------------------------
//  Debugging support
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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
static char *log_filename = NULL;

static bool debugging = false;
static bool terminal  = false;


bool LogInit(const char *filename)
{
	if (filename)
	{
		log_filename = StringDup(filename);

		log_file = fopen(log_filename, "w");

		if (! log_file)
			return false;
	}

	LogPrintf("====== START OF OBLIGE LOGS ======\n");

	return true;
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

		StringFree(log_filename);
		log_filename = NULL;
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


void LogReadLines(log_display_func_t display_func, void *priv_data)
{
	if (! log_file)
		return;

	// we close the log file so we can read it, and then open it
	// again when finished.  That is because Windows OSes can be
	// fussy about opening already open files (in Linux it would
	// not be an issue).

	fclose(log_file);

	log_file = fopen(log_filename, "r");

	// this is very unlikely to happen, but check anyway
	if (! log_file)
		return;

	char buffer[MSG_BUF_LEN];

	while (fgets(buffer, MSG_BUF_LEN-2, log_file))
	{
		// remove any newline at the end (LF or CR/LF)
		StringRemoveCRLF(buffer);

		// remove any DEL characters (mainly to workaround an FLTK bug)
		StringReplaceChar(buffer, 0x7f, 0);

		display_func(buffer, priv_data);
	}

	// open the log file for writing again
	// [ it is unlikely to fail, but if it does then no biggie ]
	log_file = fopen(log_filename, "a");
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
