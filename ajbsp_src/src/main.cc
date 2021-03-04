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

#include "main.h"

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

const char *opt_output = NULL;

bool opt_help		= false;
bool opt_version	= false;


std::vector< const char * > wad_list;

const char *Level_name;

map_format_e Level_format;

int total_failed_files = 0;
int total_empty_files = 0;
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
		total_empty_files += 1;
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
		total_empty_files += 1;
		return BUILD_OK;
	}

	PrintMsg("\n");

	total_failed_maps += failures;

	if (res == BUILD_BadFile)
	{
		PrintMsg("  Corrupted wad or level detected.\n");

		// allow building other files
		total_failed_files += 1;
		return BUILD_OK;
	}

	if (failures > 0)
	{
		PrintMsg("  Failed maps: %d (out of %d)\n", failures, visited);

		// allow building other files
		total_failed_files += 1;
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


void ValidateInputFilename(const char *filename)
{
	// NOTE: these checks are case-insensitive

	// files with ".bak" extension cannot be backed up, so refuse them
	if (MatchExtension(filename, "bak"))
		FatalError("cannot process a backup file: %s\n", filename);

	// GWA files only contain GL-nodes, never any maps
	if (MatchExtension(filename, "gwa"))
		FatalError("cannot process a GWA file: %s\n", filename);

	// we do not support packages
	if (MatchExtension(filename, "pak") || MatchExtension(filename, "pk2") ||
		MatchExtension(filename, "pk3") || MatchExtension(filename, "pk4") ||
		MatchExtension(filename, "pk7") ||
		MatchExtension(filename, "epk") || MatchExtension(filename, "pack") ||
		MatchExtension(filename, "zip") || MatchExtension(filename, "rar"))
	{
		FatalError("package files (like PK3) are not supported: %s\n", filename);
	}

	// check some very common formats
	if (MatchExtension(filename, "exe") || MatchExtension(filename, "dll") ||
		MatchExtension(filename, "com") || MatchExtension(filename, "bat") ||
		MatchExtension(filename, "txt") || MatchExtension(filename, "doc") ||
		MatchExtension(filename, "deh") || MatchExtension(filename, "bex") ||
		MatchExtension(filename, "lmp") || MatchExtension(filename, "cfg") ||
		MatchExtension(filename, "gif") || MatchExtension(filename, "png") ||
		MatchExtension(filename, "jpg") || MatchExtension(filename, "jpeg"))
	{
		FatalError("not a wad file: %s\n", filename);
	}
}


void BackupFile(const char *filename)
{
	const char *dest_name = ReplaceExtension(filename, "bak");

	if (! FileCopy(filename, dest_name))
		FatalError("failed to create backup: %s\n", dest_name);

	PrintVerbose("\nCreated backup: %s\n", dest_name);

	StringFree(dest_name);
}


void VisitFile(unsigned int idx, const char *filename)
{
	if (opt_output != NULL)
	{
		if (! FileCopy(filename, opt_output))
			FatalError("failed to create output file: %s\n", opt_output);

		PrintMsg("\nCopied input file: %s\n", filename);

		filename = opt_output;
	}

	if (opt_backup)
		BackupFile(filename);

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


// ----- user information -----------------------------

static void ShowHelp()
{
	/*
	printf(	"AJBSP is free software, under the terms of the GNU GPL\n"
			"(General Public License), and has ABSOLUTELY NO WARRANTY.\n"
			"\n");
	*/
	printf("\n");

	printf( "Usage: ajbsp [options...] FILE...\n"
			"\n"
			"Available options are:\n"
			"    -v --verbose       Verbose output, show all warnings\n"
			"    -b --backup        Backup input files (.bak extension)\n"
			"    -f --fast          Faster partition selection\n"
			"    -m --map   XXXX    Control which map(s) are built\n"
			"\n"
			"    -n --nogl          Disable creation of GL-Nodes\n"
			"    -g --gl5           Use V5 format for GL-nodes\n"
			"    -x --xnod          Use XNOD format for normal nodes\n"
			"    -c --cost  ##      Cost assigned to seg splits (1-32)\n"
			"\n"
			"Short options may be mixed, for example: -fbv\n"
			"Long options must always begin with a double hyphen\n"
			"\n"
			"Map names should be full, like E1M3 or MAP24, but a list\n"
			"and/or ranges can be specified: MAP01,MAP04-MAP07,MAP12\n"
			);

	//	"Home page: https://gitlab.com/andwj/ajbsp\n"

	fflush(stdout);
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


void ParseShortArgument(const char *arg)
{
	// skip the leading '-'
	arg++;

	while (*arg)
	{
		char c = *arg++;
		int val = 0;

		switch (c)
		{
			case 'h': opt_help = true; continue;
			case 'v': opt_verbosity += 1; continue;
			case 'b': opt_backup = true; continue;
			case 'f': opt_fast = true; continue;
			case 'n': opt_no_gl = true; continue;
			case 'g': opt_force_v5 = true; continue;
			case 'x': opt_force_xnod = true; continue;

			case 'm':
			case 'o':
				FatalError("cannot use option '-%c' like that\n", c);
				return;

			case 'c':
				if (*arg == 0 || ! isdigit(*arg))
					FatalError("missing value for '-c' option\n");

				// we only accept one or two digits here
				val = *arg - '0';
				arg++;

				if (*arg && isdigit(*arg))
				{
					val = (val * 10) + (*arg - '0');
					arg++;
				}

				if (val < 1 || val > MAX_SPLIT_COST)
					FatalError("illegal value for '-c' option\n");

				opt_split_cost = val;
				continue;

			default:
				if (isprint(c) && !isspace(c))
					FatalError("unknown short option: '-%c'\n", c);
				else
					FatalError("illegal short option (ascii code %d)\n", (int)(unsigned char)c);
				return;
		}
	}
}


int ParseLongArgument(const char *name, int argc, char *argv[])
{
	int used = 0;

	if (strcmp(name, "--help") == 0)
	{
		opt_help = true;
	}
	else if (strcmp(name, "--version") == 0)
	{
		opt_version = true;
	}
	else if (strcmp(name, "--verbose") == 0)
	{
		opt_verbosity += 1;
	}
	else if (strcmp(name, "--very-verbose") == 0)
	{
		opt_verbosity += 2;
	}
	else if (strcmp(name, "--super-verbose") == 0)
	{
		opt_verbosity += 3;
	}
	else if (strcmp(name, "--backup") == 0 || strcmp(name, "--backups") == 0)
	{
		opt_backup = true;
	}
	else if (strcmp(name, "--fast") == 0)
	{
		opt_fast = true;
	}
	else if (strcmp(name, "--map") == 0 || strcmp(name, "--maps") == 0)
	{
		if (argc < 1 || argv[0][0] == '-')
			FatalError("missing value for '--map' option\n");

		ParseMapList(argv[0]);

		used = 1;
	}
	else if (strcmp(name, "--nogl") == 0 || strcmp(name, "--no-gl") == 0)
	{
		opt_no_gl = true;
	}
	else if (strcmp(name, "--xnod") == 0)
	{
		opt_force_xnod = true;
	}
	else if (strcmp(name, "--gl5") == 0)
	{
		opt_force_v5 = true;
	}
	else if (strcmp(name, "--cost") == 0)
	{
		if (argc < 1 || ! isdigit(argv[0][0]))
			FatalError("missing value for '--cost' option\n");

		int val = atoi(argv[0]);

		if (val < 1 || val > MAX_SPLIT_COST)
			FatalError("illegal value for '--cost' option\n");

		opt_split_cost = val;
		used = 1;
	}
	else if (strcmp(name, "--output") == 0)
	{
		// this option is *only* for compatibility

		if (argc < 1 || argv[0][0] == '-')
			FatalError("missing value for '--output' option\n");

		if (opt_output != NULL)
			FatalError("cannot use '--output' option twice\n");

		opt_output = StringDup(argv[0]);
		used = 1;
	}
	else
	{
		FatalError("unknown long option: '%s'\n", name);
	}

	return used;
}


void ParseCommandLine(int argc, char *argv[])
{
	// skip program name
	argc--;
	argv++;

	bool rest_are_files = false;

	while (argc > 0)
	{
		const char *arg = *argv++;
		argc--;

#ifdef __APPLE__
		// ignore MacOS X rubbish
		if (strncmp(arg, "-psn_", 5) == 0)
			continue;
#endif

		if (strlen(arg) == 0)
			continue;

		// a normal filename?
		if (arg[0] != '-' || rest_are_files)
		{
			wad_list.push_back(arg);
			continue;
		}

		if (strcmp(arg, "-") == 0)
			FatalError("illegal option '-'\n");

		if (strcmp(arg, "--") == 0)
		{
			rest_are_files = true;
			continue;
		}

		// handle short args which are isolate and require a value
		if (strcmp(arg, "-c") == 0) arg = "--cost";
		if (strcmp(arg, "-m") == 0) arg = "--map";
		if (strcmp(arg, "-o") == 0) arg = "--output";

		if (arg[1] != '-')
		{
			ParseShortArgument(arg);
			continue;
		}

		int count = ParseLongArgument(arg, argc, argv);

		if (count > 0)
		{
			argc -= count;
			argv += count;
		}
	}
}


//
//  the program starts here
//
int main(int argc, char *argv[])
{
	// sanity check on type sizes (useful when porting)
	CheckTypeSizes();

	ParseCommandLine(argc, argv);

	if (opt_version)
	{
		ShowVersion();
		return 0;
	}

	if (opt_help || argc <= 1)
	{
		ShowBanner();
		ShowHelp();
		return 0;
	}

	int total_files = (int)wad_list.size();

	if (total_files == 0)
	{
		FatalError("no files to process\n");
		return 0;
	}

	if (opt_output != NULL)
	{
		if (opt_backup)
			FatalError("cannot use --backup with --output\n");

		if (total_files > 1)
			FatalError("cannot use multiple input files with --output\n");

		if (y_stricmp(wad_list[0], opt_output) == 0)
			FatalError("input and output files are the same\n");
	}

	ShowBanner();

	// validate all filenames before processing any of them
	for (unsigned int i = 0 ; i < wad_list.size() ; i++)
	{
		const char *filename = wad_list[i];

		ValidateInputFilename(filename);

		if (! FileExists(filename))
			FatalError("no such file: %s\n", filename);
	}

	for (unsigned int i = 0 ; i < wad_list.size() ; i++)
	{
		VisitFile(i, wad_list[i]);
	}

	PrintMsg("\n");

	if (total_failed_files > 0)
	{
		PrintMsg("FAILURES occurred on %d map%s in %d file%s.\n",
				total_failed_maps,  total_failed_maps  == 1 ? "" : "s",
				total_failed_files, total_failed_files == 1 ? "" : "s");

		if (opt_verbosity == 0)
			PrintMsg("Rerun with --verbose to see more details.\n");

		return 2;
	}
	else if (total_built_maps == 0)
	{
		PrintMsg("NOTHING was built!\n");

		return 1;
	}
	else if (total_empty_files == 0)
	{
		PrintMsg("Ok, built all files.\n");
	}
	else
	{
		int built = total_files - total_empty_files;
		int empty = total_empty_files;

		PrintMsg("Ok, built %d file%s, %d file%s empty.\n",
				built, (built == 1 ? "" : "s"),
				empty, (empty == 1 ? " was" : "s were"));
	}

	// that's all folks!
	return 0;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
