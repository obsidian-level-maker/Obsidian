//------------------------------------------------------------------------
//  MAIN Program
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

// this includes everything we need
#include "defs.h"


#define GUI_PrintMsg  printf


static bool inited_FLTK = false;

static int main_result = 0;


static void ShowTitle()
{
	GUI_PrintMsg(
		"\n"
		"**** " PROG_NAME "  (C) 2005 Andrew Apted ****\n\n"
	);
}

static void ShowInfo()
{
	GUI_PrintMsg(
		"Info...\n\n"
	);
}


void InitFLTK()
{
	Fl::scheme(NULL);

	fl_message_font(FL_HELVETICA, 18);

	Fl_File_Icon::load_system_icons();

	inited_FLTK = true;
}

void SetDefaults()
{
}

void SetupRandom()
{
	const char *seed_str = NULL;
	{
		int params;
		int idx = ArgvFind('r', "seed", &params);

		if (idx >= 0 && params >= 1)
			seed_str = arg_list[idx + 1];
	}

	long int seed = seed_str ? atoi(seed_str) : (time(NULL) % 10000);

// seed=2716; //!!!!!
	if (seed < 0)
		seed = -seed;

	fprintf(stderr, "Using random seed: %ld\n", seed);
	PrintDebug("Using random seed: %ld\n", seed);

	srandom(seed);
}

static void GetMapSize(int *W, int *H)
{
	int params;
	int idx = ArgvFind('s', "size", &params);

	if (idx < 0)
		return;

	if (params < 1)
		FatalError("Missing -size parameter (e.g. 40x30).\n");

	char val_buf[80];
	char *x_pos;

	strncpy(val_buf, arg_list[idx+1], 80);
	val_buf[80] = 0;

	x_pos = strchr(val_buf, 'x');

	if (x_pos)
	{
		*x_pos++ = 0;

		*W = atoi(val_buf);
		*H = atoi(x_pos);
	}
	else
	{
		*W = *H = atoi(val_buf);
	}

	if (*W < MIN_DIM || *W > MAX_DIM || *H < MIN_DIM || *H > MAX_DIM)
		FatalError("Size %d out of range (must be %d..%d)\n", *W, MIN_DIM, MAX_DIM);
}

static void CreateWAD()
{
	int params;
	int idx = ArgvFind('o', "output", &params);

	if (idx < 0)
		return;

	if (params < 1)
		FatalError("Missing -output filename.\n");

	const char *filename = arg_list[idx+1];

#if 0
	level_block::WriteBlock(filename);
#elif 1
	level_doom::WriteWAD(filename);
#elif 0
	level_doom::WriteText(filename);
#elif 0
	level_quake::WriteText(filename);
#elif 0
	level_cube::WriteCube(filename);
#else
	level_wolf::WriteWolf();
#endif
}

static void DisplayError(const char *str, ...)
{
	va_list args;

	if (inited_FLTK)
	{
		char buffer[1024];

		va_start(args, str);
		vsprintf(buffer, str, args);
		va_end(args);

		fl_alert("%s", buffer);
	}
	else
	{
		va_start(args, str);
		vfprintf(stderr, str, args);
		va_end(args);

		fprintf(stderr, "\n");
	}

	main_result = 9;
}

//------------------------------------------------------------------------
//  MAIN PROGRAM
//------------------------------------------------------------------------


int main(int argc, char **argv)
{
	try
	{
		// skip program name
		argv++, argc--;

		ArgvInit(argc, (const char **)argv);
	 
		InitDebug(ArgvFind(0, "debug") >= 0);
		InitEndian();

		if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0)
		{
			ShowTitle();
			ShowInfo();
			exit(1);
		}

		InitFLTK();

		SetDefaults();
		SetupRandom();

		int W = 40;
		int H = 40;

		GetMapSize(&W, &H);

		PrintDebug("Map size %dx%d\n\n", W, H);

		the_world = new world_c(W, H);

		environ_build::CreateEnv();
		area_build::CreateAreas();
		island_build::CreateIslands();
		island_build::Cleanup();

  		stage_build::CreateStages();
		path_build::CreatePaths();
		room_build::CreateRooms();

		if (ArgvFind('g', "gui") >= 0)
		{
			guix_win = new Guix_MainWin(PROG_NAME);

			// run the GUI until the user quits
			while (! guix_win->want_quit)
				Fl::wait();
		}

		CreateWAD();
	}
	catch (const char * err)
	{
		DisplayError("%s", err);
	}
#if 1
	catch (assert_fail_c err)
	{
		DisplayError("Sorry, an internal error occurred:\n%s", err.GetMessage());
	}
	catch (...)
	{
		DisplayError("An unknown problem occurred (UI code)");
	}
#endif

	delete guix_win;

	TermDebug();

	return main_result;
}

