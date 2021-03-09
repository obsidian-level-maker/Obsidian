//------------------------------------------------------------------------
//  MAIN PROGRAM
//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2001-2018  Andrew Apted
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
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

#include "ajbsp_main.h"

#include <time.h>

#ifndef WIN32
#include <time.h>
#endif


#define MAX_SPLIT_COST  32


//
//  global variables
//

int opt_verbosity = 0;  // 0 is normal, 1+ is verbose

bool opt_backup		= false;
bool opt_fast		= false;

bool opt_no_gl		= false;
bool opt_force_v5	= false;
bool opt_force_xnod	= false;
int  opt_split_cost	= DEFAULT_FACTOR;

const char *Level_name;

map_format_e Level_format;

int total_built_maps = 0;
int total_failed_maps = 0;


typedef struct map_range_s
{
	const char *low;
	const char *high;

} map_range_t;

std::vector< map_range_t > map_list;


// this is > 0 when PrintMapName() is used and the current line
// has not been terminated with a new-line ('\n') character.
static int hanging_pos;

static void StopHanging()
{
	if (hanging_pos > 0)
	{
		hanging_pos = 0;

		printf("\n");
		fflush(stdout);
	}
}


//
//  show an error message and terminate the program
//
void FatalError(const char *fmt, ...)
{
	va_list arg_ptr;

	static char buffer[MSG_BUF_LEN];

	va_start(arg_ptr, fmt);
	vsnprintf(buffer, MSG_BUF_LEN-1, fmt, arg_ptr);
	va_end(arg_ptr);

	buffer[MSG_BUF_LEN-1] = 0;

	StopHanging();

	fprintf(stderr, "\nFATAL ERROR: %s", buffer);

	exit(3);
}


void PrintMsg(const char *fmt, ...)
{
	va_list arg_ptr;

	static char buffer[MSG_BUF_LEN];

	va_start(arg_ptr, fmt);
	vsnprintf(buffer, MSG_BUF_LEN-1, fmt, arg_ptr);
	va_end(arg_ptr);

	buffer[MSG_BUF_LEN-1] = 0;

	StopHanging();

	printf("%s", buffer);
	fflush(stdout);
}


void PrintVerbose(const char *fmt, ...)
{
	if (opt_verbosity < 1)
		return;

	va_list arg_ptr;

	static char buffer[MSG_BUF_LEN];

	va_start(arg_ptr, fmt);
	vsnprintf(buffer, MSG_BUF_LEN-1, fmt, arg_ptr);
	va_end(arg_ptr);

	buffer[MSG_BUF_LEN-1] = 0;

	StopHanging();

	printf("%s", buffer);
	fflush(stdout);
}


void PrintDetail(const char *fmt, ...)
{
	if (opt_verbosity < 2)
		return;

	va_list arg_ptr;

	static char buffer[MSG_BUF_LEN];

	va_start(arg_ptr, fmt);
	vsnprintf(buffer, MSG_BUF_LEN-1, fmt, arg_ptr);
	va_end(arg_ptr);

	buffer[MSG_BUF_LEN-1] = 0;

	StopHanging();

	printf("%s", buffer);
	fflush(stdout);
}


void PrintMapName(const char *name)
{
	if (opt_verbosity >= 1)
	{
		PrintMsg("  %s\n", name);
		return;
	}

	// display the map names across the terminal

	if (hanging_pos >= 68)
		StopHanging();

	printf("  %s", name);
	fflush(stdout);

	hanging_pos += strlen(name) + 2;
}


void DebugPrintf(const char *fmt, ...)
{
	(void) fmt;
}


//------------------------------------------------------------------------


static bool CheckMapInRange(const map_range_t *range, const char *name)
{
	if (strlen(name) != strlen(range->low))
		return false;

	if (strcmp(name, range->low) < 0)
		return false;

	if (strcmp(name, range->high) > 0)
		return false;

	return true;
}


static bool CheckMapInMaplist(short lev_idx)
{
	// when --map is not used, allow everything
	if (map_list.empty())
		return true;

	short lump_idx = edit_wad->LevelHeader(lev_idx);

	const char *name = edit_wad->GetLump(lump_idx)->Name();

	for (unsigned int i = 0 ; i < map_list.size() ; i++)
		if (CheckMapInRange(&map_list[i], name))
			return true;

	return false;
}


static build_result_e BuildFile()
{
	int num_levels = edit_wad->LevelCount();

	if (num_levels == 0)
	{
		PrintMsg("  No levels in wad\n");
		return BUILD_OK;
	}

	int visited = 0;
	int failures = 0;

	// prepare the build info struct
	nodebuildinfo_t nb_info;

	nb_info.factor		= opt_split_cost;
	nb_info.gl_nodes	= ! opt_no_gl;
	nb_info.fast		= opt_fast;

	nb_info.force_v5	= opt_force_v5;
	nb_info.force_xnod	= opt_force_xnod;

	build_result_e res = BUILD_OK;

	// loop over each level in the wad
	for (int n = 0 ; n < num_levels ; n++)
	{
		if (! CheckMapInMaplist(n))
			continue;

		visited += 1;

		if (n > 0 && opt_verbosity >= 2)
			PrintMsg("\n");

		res = AJBSP_BuildLevel(&nb_info, n);

		// handle a failed map (due to lump overflow)
		if (res == BUILD_LumpOverflow)
		{
			res = BUILD_OK;
			failures += 1;
			continue;
		}

		if (res != BUILD_OK)
			break;

		total_built_maps += 1;
	}

	StopHanging();

	if (res == BUILD_Cancelled)
		return res;

	if (visited == 0)
	{
		PrintMsg("  No matching levels\n");
		return BUILD_OK;
	}

	PrintMsg("\n");

	if (res == BUILD_BadFile)
	{
		PrintMsg("  Corrupted wad or level detected.\n");

		return BUILD_OK;
	}

	if (failures > 0)
	{
		PrintMsg("  Failed maps: %d (out of %d)\n", failures, visited);
	}

	if (true)
	{
		PrintMsg("  Serious warnings: %d\n", nb_info.total_warnings);
	}

	if (opt_verbosity >= 1)
	{
		PrintMsg("  Minor issues: %d\n", nb_info.total_minor_issues);
	}

	return BUILD_OK;
}

void VisitFile(const char *filename)
{

	PrintMsg("\n");
	PrintMsg("Building %s\n", filename);

	edit_wad = Wad_file::Open(filename, 'a');
	if (! edit_wad)
		FatalError("Cannot open file: %s\n", filename);

	if (edit_wad->IsReadOnly())
	{
		delete edit_wad; edit_wad = NULL;

		FatalError("file is read only: %s\n", filename);
	}

	build_result_e res = BuildFile();

	// this closes the file
	delete edit_wad; edit_wad = NULL;

	if (res == BUILD_Cancelled)
		FatalError("CANCELLED\n");
}

static void ShowVersion()
{
	printf("ajbsp " AJBSP_VERSION "  (" __DATE__ ")\n");

	fflush(stdout);
}


static void ShowBanner()
{
	printf("+-----------------------------------------------+\n");
	printf("|   AJBSP " AJBSP_VERSION "   (C) 2018 Andrew Apted, et al   |\n");
	printf("+-----------------------------------------------+\n");

	fflush(stdout);
}


bool ValidateMapName(char *name)
{
	if (strlen(name) < 2 || strlen(name) > 8)
		return false;

	if (! isalpha(name[0]))
		return false;

	for (const char *p = name ; *p ; p++)
	{
		if (! (isalnum(*p) || *p == '_'))
			return false;
	}

	// Ok, convert to upper case
	for (char *s = name ; *s ; s++)
	{
		*s = toupper(*s);
	}

	return true;
}


void ParseMapRange(char *tok)
{
	char *low  = tok;
	char *high = tok;

	// look for '-' separator
	char *p = strchr(tok, '-');

	if (p)
	{
		*p++ = 0;

		high = p;
	}

	if (! ValidateMapName(low))
		FatalError("illegal map name: '%s'\n", low);

	if (! ValidateMapName(high))
		FatalError("illegal map name: '%s'\n", high);

	if (strlen(low) < strlen(high))
		FatalError("bad map range (%s shorter than %s)\n", low, high);

	if (strlen(low) > strlen(high))
		FatalError("bad map range (%s longer than %s)\n", low, high);

	if (low[0] != high[0])
		FatalError("bad map range (%s and %s start with different letters)\n", low, high);

	if (strcmp(low, high) > 0)
		FatalError("bad map range (wrong order, %s > %s)\n", low, high);

	// Ok

	map_range_t range;

	range.low  = low;
	range.high = high;

	map_list.push_back(range);
}


void ParseMapList(const char *from_arg)
{
	// create a mutable copy of the string
	// [ we will keep long-term pointers into this buffer ]
	char *buf = StringDup(from_arg);

	char *arg = buf;

	while (*arg)
	{
		if (*arg == ',')
			FatalError("bad map list (empty element)\n");

		// find next comma
		char *tok = arg;
		arg++;

		while (*arg && *arg != ',')
			arg++;

		if (*arg == ',')
		{
			*arg++ = 0;
		}

		ParseMapRange(tok);
	}
}

//
//  the program starts here
//
int ajbsp_main(const char *filename)
{
	// sanity check on type sizes (useful when porting)
	CheckTypeSizes();

	ShowVersion();

	ShowBanner();

	VisitFile(filename);

	PrintMsg("\n");

	if (total_built_maps == 0)
	{
		PrintMsg("NOTHING was built!\n");

		return 1;
	}
	else
	{
		PrintMsg("Ok, built nodes for %d map%s!\n",
				total_built_maps, (total_built_maps == 1 ? "" : "s"));
	}

	// that's all folks!
	return 0;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
