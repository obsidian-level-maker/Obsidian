//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2023 The OBSIDIAN Team
//			Copyright (C) 2001-2022  Andrew Apted
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

#include "system.h"
#include "bsp.h"
#include "utility.h"
#include "wad.h"

// this is only needed for CheckTypeSizes
#include "raw_def.h"

bool opt_backup   = false;
bool opt_help     = false;
bool opt_version  = false;

int total_failed_files = 0;
int total_empty_files  = 0;
int total_built_maps   = 0;
int total_failed_maps  = 0;

struct map_range_t
{
	const char *low;
	const char *high;
};

std::vector< map_range_t > map_list;


// this is > 0 when ShowMap() is used and the current line
// has not been terminated with a new-line ('\n') character.
int hanging_pos;

void StopHanging()
{
	if (hanging_pos > 0)
	{
		hanging_pos = 0;

		printf("\n");
		fflush(stdout);
	}
}


class mybuildinfo_t : public buildinfo_t
{
public:
	void Print(int level, const char *fmt, ...)
	{
		if (level > verbosity)
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

	void Debug(const char *fmt, ...)
	{
		static char buffer[MSG_BUF_LEN];

		va_list args;

		va_start(args, fmt);
		vsnprintf(buffer, sizeof(buffer), fmt, args);
		va_end(args);

		fprintf(stderr, "%s", buffer);
	}

	void ShowMap(const char *name)
	{
		if (verbosity >= 1)
		{
			Print(0, "  %s\n", name);
			return;
		}

		// display the map names across the terminal

		if (hanging_pos >= 68)
			StopHanging();

		printf("  %s", name);
		fflush(stdout);

		hanging_pos += strlen(name) + 2;
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

		ajbsp::CloseWad();

		StopHanging();

		fprintf(stderr, "\nFATAL ERROR: %s", buffer);

		exit(3);
	}
};


class mybuildinfo_t config;



//------------------------------------------------------------------------


bool CheckMapInRange(const map_range_t *range, const char *name)
{
	if (strlen(name) != strlen(range->low))
		return false;

	if (strcmp(name, range->low) < 0)
		return false;

	if (strcmp(name, range->high) > 0)
		return false;

	return true;
}


bool CheckMapInMaplist(int lev_idx)
{
	// when --map is not used, allow everything
	if (map_list.empty())
		return true;

	const char *name = ajbsp::GetLevelName(lev_idx);

	for (unsigned int i = 0 ; i < map_list.size() ; i++)
		if (CheckMapInRange(&map_list[i], name))
			return true;

	return false;
}


build_result_e BuildFile()
{
	config.total_warnings = 0;
	config.total_minor_issues = 0;

	int num_levels = ajbsp::LevelsInWad();

	if (num_levels == 0)
	{
		config.Print(0, "  No levels in wad\n");
		total_empty_files += 1;
		return BUILD_OK;
	}

	int visited  = 0;
	int failures = 0;

	build_result_e res = BUILD_OK;

	// loop over each level in the wad
	for (int n = 0 ; n < num_levels ; n++)
	{
		if (! CheckMapInMaplist(n))
			continue;

		visited += 1;

		if (n > 0 && config.verbosity >= 2)
			config.Print(0, "\n");

		res = ajbsp::BuildLevel(n);

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
		config.Print(0, "  No matching levels\n");
		total_empty_files += 1;
		return BUILD_OK;
	}

	config.Print(0, "\n");

	total_failed_maps += failures;

	if (failures > 0)
	{
		config.Print(0, "  Failed maps: %d (out of %d)\n", failures, visited);

		// allow building other files
		total_failed_files += 1;
	}

	if (true)
	{
		config.Print(0, "  Serious warnings: %d\n", config.total_warnings);
	}

	if (config.verbosity >= 1)
	{
		config.Print(0, "  Minor issues: %d\n", config.total_minor_issues);
	}

	return BUILD_OK;
}

void VisitFile(std::filesystem::path filename)
{
	config.Print(0, "\n");
	config.Print(0, "Building %s\n", filename);

	// this will fatal error if it fails
	ajbsp::OpenWad(filename);

	build_result_e res = BuildFile();

	ajbsp::CloseWad();

	if (res == BUILD_Cancelled)
		config.FatalError("CANCELLED\n");
}


// ----- user information -----------------------------

void ShowBanner()
{
	printf("+-----------------------------------------------+\n");
	printf("|   AJBSP " AJBSP_VERSION "   (C) 2022 Andrew Apted, et al   |\n");
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
		config.FatalError("illegal map name: '%s'\n", low);

	if (! ValidateMapName(high))
		config.FatalError("illegal map name: '%s'\n", high);

	if (strlen(low) < strlen(high))
		config.FatalError("bad map range (%s shorter than %s)\n", low, high);

	if (strlen(low) > strlen(high))
		config.FatalError("bad map range (%s longer than %s)\n", low, high);

	if (low[0] != high[0])
		config.FatalError("bad map range (%s and %s start with different letters)\n", low, high);

	if (strcmp(low, high) > 0)
		config.FatalError("bad map range (wrong order, %s > %s)\n", low, high);

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
	char *buf = ajbsp::StringDup(from_arg);

	char *arg = buf;

	while (*arg)
	{
		if (*arg == ',')
			config.FatalError("bad map list (empty element)\n");

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
// sanity checks for the sizes and properties of certain types.
// useful when porting.
//
#define assert_size(type,size)  \
    do {  \
        if (sizeof (type) != size)  \
            config.FatalError("sizeof " #type " is %d (should be " #size ")\n", (int)sizeof(type));  \
    } while (0)

void CheckTypeSizes()
{
	assert_size(u8_t,  1);
	assert_size(s8_t,  1);
	assert_size(u16_t, 2);
	assert_size(s16_t, 2);
	assert_size(u32_t, 4);
	assert_size(s32_t, 4);

	assert_size(raw_linedef_t, 14);
	assert_size(raw_sector_s,  26);
	assert_size(raw_sidedef_t, 30);
	assert_size(raw_thing_t,   10);
	assert_size(raw_vertex_t,   4);
}


int AJBSP_BuildNodes(std::filesystem::path filename, std::string current_port, bool UDMF_mode, bool build_reject, int num_maps, buildinfo_t *build_info)
{
	// need this early, especially for fatal errors in utility/wad code
	ajbsp::SetInfo(&config);

	// sanity check on type sizes (useful when porting)
	CheckTypeSizes();

	if (filename.empty())
	{
		config.FatalError("no files to process\n");
		return 0;
	}

	ShowBanner();

	// validate file before processing it
	if (! ajbsp::FileExists(filename))
		config.FatalError("no such file: %s\n", filename.string().c_str());

	VisitFile(filename);

	config.Print(0, "\n");

	if (total_failed_files > 0)
	{
		config.Print(0, "FAILURES occurred on %d map%s in %d file%s.\n",
				total_failed_maps,  total_failed_maps  == 1 ? "" : "s",
				total_failed_files, total_failed_files == 1 ? "" : "s");

		if (config.verbosity == 0)
			config.Print(0, "Rerun with --verbose to see more details.\n");

		return 2;
	}
	else if (total_built_maps == 0)
	{
		config.Print(0, "NOTHING was built!\n");

		return 1;
	}
	else if (total_empty_files == 0)
	{
		config.Print(0, "Ok, built all files.\n");
	}
	else
	{
		int built = 1 - total_empty_files;
		int empty = total_empty_files;

		config.Print(0, "Ok, built %d file%s, %d file%s empty.\n",
				built, (built == 1 ? "" : "s"),
				empty, (empty == 1 ? " was" : "s were"));
	}

	// that's all folks!
	return 0;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
