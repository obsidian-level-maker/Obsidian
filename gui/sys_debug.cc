//------------------------------------------------------------------------
//  Debugging support
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


#define DEBUGGING_FILE  "obl_debug.txt"

static FILE *debug_fp = NULL;


//
// DebugInit
//
void DebugInit(bool enable)
{
	if (enable)
	{
		debug_fp = fopen(DEBUGGING_FILE, "w");

		DebugPrintf("====== START OF DEBUG FILE ======\n\n");
	}
}

//
// DebugTerm
//
void DebugTerm(void)
{
	if (debug_fp)
	{
		DebugPrintf("\n====== END OF DEBUG FILE ======\n");

		fclose(debug_fp);
		debug_fp = NULL;
	}
}

//
// DebugPrintf
//
void DebugPrintf(const char *str, ...)
{
	if (debug_fp)
	{
		va_list args;

		va_start(args, str);
		vfprintf(debug_fp, str, args);
		va_end(args);

		fflush(debug_fp);
	}
}

