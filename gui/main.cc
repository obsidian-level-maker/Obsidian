//------------------------------------------------------------------------
//  Main program
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006 Andrew Apted
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
#include "hdr_lua.h"

#include "lib_argv.h"
#include "lib_util.h"

#include "main.h"
#include "g_doom.h"
#include "g_glbsp.h"
#include "g_lua.h"

#include "hdr_fltk.h"
#include "ui_chooser.h"
#include "ui_dialog.h"
#include "ui_window.h"


#define TICKER_TIME  20 /* ms */


/* ----- user information ----------------------------- */

static void ShowInfo(void)
{
	printf(
		"\n"
		"** " OBLIGE_TITLE " " OBLIGE_VERSION " (C) Andrew Apted 2006 **\n"
		"\n"
	);

	printf(
		"Usage: oblige [options...]\n"
		"\n"
		"Available options:\n"
		"  -d  -debug             Enable debugging\n"
		"  -h  -help              Show this help message\n"
		"\n"
	);

	printf(
		"This program is free software, under the terms of the GNU General\n"
		"Public License, and comes with ABSOLUTELY NO WARRANTY.  See the\n"
		"documentation for more details, or visit this web page:\n"
		"    http://www.gnu.org/licenses/licenses.html\n"
		"\n"
	);
}

void MainSetDefaults(void)
{
#if 0
  memcpy((guix_preferences_t *) &guix_prefs, &default_guiprefs,
      sizeof(guix_prefs));

  // set default filename for saving the log
  guix_prefs.save_log_file = GlbspStrDup("glbsp.log");
#endif
}


void Main_Ticker()
{
	// This function is called very frequently.
	// To prevent a slow-down, we only call Fl::check()
	// after a certain time has elapsed.

	static u32_t last_millis = 0;

	u32_t cur_millis = TimeGetMillies();

	if ((cur_millis - last_millis) >= TICKER_TIME)
	{
		Fl::check();

		last_millis = cur_millis;
	}
}

void Main_Shutdown()
{
	delete main_win;
	main_win = NULL;

	DebugTerm();
	ArgvTerm();
}

void Main_FatalError(const char *msg, ...)
{
	static char buffer[MSG_BUF_LEN+4];

	va_list arg_pt;

	va_start(arg_pt, msg);
	vsnprintf(buffer, MSG_BUF_LEN, msg, arg_pt);
	va_end(arg_pt);

	buffer[MSG_BUF_LEN] = 0;

	// FIXME: if (inited_fltk) ... else ...
fprintf(stderr, "%s\n", buffer);

	DebugPrintf("%s\n", buffer);
	
	DLG_ShowError(buffer);

	Main_Shutdown();

	exit(9);
}


void Build_Cool_Shit()
{
	UI_Build *that = main_win->build_box;

  char *filename = Select_Output_File(); //--- main_win->file_box->CopyFilename(".wad");
  if (! filename)
    return;

  Fl::check();

	// lock most widgets of user interface
	main_win->Locked(true);
	that->P_SetButton(true);

	bool is_hexen = !strcmp(main_win->setup_box->cur_Game(), "hexen");

	bool was_ok = Doom_CreateWAD(DATA_DIR "/TEMP.wad", is_hexen);

	if (was_ok)
	{
		that->P_Status("Making levels");
		that->P_Begin(100, 1);

		was_ok = Script_Run();

		Doom_FinishWAD();

///  that->P_Finish();
	}

	if (was_ok)
	{
    DebugPrintf("FILENAME: [%s]\n", filename);

    if (FileExists(filename))
    {
      // FIXME: con_printf("Backing up existing file: XXX");
      
      // make a backup
      char *backup_name = ReplaceExtension(filename, "bak");

      if (! CopyFile(filename, backup_name))
      {
        // FIXME: either show a warning OR fatal error
      }

      StringFree(backup_name);
    }

		that->P_Status("Building nodes");

		was_ok = GB_BuildNodes(DATA_DIR "/TEMP.wad", filename);
	}

  StringFree(filename);

	// FIXME !!! distinguish between Failure and Aborted
	if (was_ok)
		that->P_Status("Success");
	else
		that->P_Status("Aborted");

	that->P_SetButton(false);
	main_win->Locked(false);

	if (main_win->action == UI_MainWin::ABORT)
		main_win->action =  UI_MainWin::NONE;
}


/* ----- main program ----------------------------- */

int main(int argc, char **argv)
{
	// skip program name
	argv++, argc--;

	ArgvInit(argc, (const char **)argv);

	if (ArgvFind('?', NULL) >= 0 ||
		ArgvFind('h', "help") >= 0)
	{
		ShowInfo();
		exit(1);
	}

	DebugInit(ArgvFind('d', "debug") >= 0);

	// set defaults, also initializes the nodebuildxxxx stuff
	MainSetDefaults();

#if 0
	// read persistent data
	CookieSetPath(argv[0]);

	cookie_status_t cookie_ret = CookieReadAll();
#endif

  Fl::scheme("plastic");

	fl_message_font(FL_HELVETICA /* _BOLD */, 18);

	// load icons for file chooser
	Fl_File_Icon::load_system_icons();


	
//	LogInit();

	Script_Init();

	
	main_win = new UI_MainWin(OBLIGE_TITLE);

  Default_Location();
#if 0
  main_win->file_box->SetDefaultLocation();
#endif

	/// TITLE --> log file

	try
	{
		// run the GUI until the user quits
		for (;;)
		{
			Fl::wait(0.2f);

			if (main_win->action == UI_MainWin::QUIT)
				break;

			if (main_win->action == UI_MainWin::BUILD)
			{
				main_win->action = UI_MainWin::NONE;

				Build_Cool_Shit();
			}
		}
	}
	catch (assert_fail_c err)
	{
		Main_FatalError("Sorry, an internal error occurred:\n%s", err.GetMessage());
	}
	catch (...)
	{
		Main_FatalError("An unknown problem occurred (UI code)");
	}

	Main_Shutdown();

	return 0;
}

