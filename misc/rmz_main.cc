//------------------------------------------------------------------------
//  RANDOMIZER : Main program
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "glbsp.h"

#include "lib_argv.h"
#include "lib_file.h"
#include "lib_signal.h"
#include "lib_util.h"

#include "main.h"
#include "m_cookie.h"
#include "m_lua.h"

#include "csg_main.h"
#include "g_nukem.h"

#include "ui_chooser.h"


// game_interface_c * game_object = NULL;


/* ----- user information ----------------------------- */

static void RMZ_ShowInfo()
{
  printf(
    "\n"
    "** " RMZ_TITLE " " RMZ_VERSION " (C) 2006-2010 Andrew Apted **\n"
    "\n"
  );

  printf(
    "Usage: Randomizer [options...]\n"
    "\n"
    "Available options:\n"
    "  -b --batch   <output>  Batch mode (no GUI)\n"
    "  -c --config  <file>    Load configuration from a file\n"
    "  -k --keep              Keep seed value from config file\n"
    "\n"
    "  -d --debug             Enable debugging\n"
    "  -t --terminal          Print log messages to stdout\n"
    "  -h --help              Show this help message\n"
    "\n"
  );

  printf(
 //   "For more information about OBLIGE, please visit the web site:\n"
    "Please visit the web site for complete information:\n"
    "   http://oblige.sourceforge.net\n"
    "\n"
  );

  printf(
    "This program is free software, under the terms of the GNU General\n"
    "Public License, and comes with ABSOLUTELY NO WARRANTY.  See the\n"
    "documentation for more details, or visit the following web page:\n"
    "   http://www.gnu.org/licenses/gpl.html\n"
    "\n"
  );
}


//------------------------------------------------------------------------

extern void Determine_WorkingPath(const char *argv0);
extern void Determine_InstallPath(const char *argv0);

extern void Main_SetupFLTK();
extern void Main_Shutdown(bool error);

extern int Main_key_handler(int event);


//------------------------------------------------------------------------

bool Randomize_Dat_Shit()
{
  // clear the map
  if (main_win)
    main_win->build_box->mini_map->EmptyMap();

  const char *format = ob_game_format();

  if (! format || strlen(format) == 0)
    Main_FatalError("ERROR: missing 'format' for game?!?\n");

  // create game object
#if 0   // TODO
  {
    if (StringCaseCmp(format, "doom") == 0)
      game_object = Doom_GameObject();

    else if (StringCaseCmp(format, "nukem") == 0)
      game_object = Nukem_GameObject();

    else if (StringCaseCmp(format, "wolf3d") == 0)
      game_object = Wolf_GameObject();

    else if (StringCaseCmp(format, "quake") == 0)
      game_object = Quake1_GameObject();

    else if (StringCaseCmp(format, "quake2") == 0)
      game_object = Quake2_GameObject();

    else
      Main_FatalError("ERROR: unknown format: '%s'\n", format);
  }
#endif


  // lock most widgets of user interface
  if (main_win)
  {
    main_win->Locked(true);
    main_win->build_box->SetAbortButton(true);
    main_win->build_box->SetStatus("Preparing...");
  }

  u32_t start_time = TimeGetMillies();

  bool was_ok = game_object->Start();

  // coerce FLTK to redraw the main window
  for (int r_loop = 0; r_loop < 6; r_loop++)
    Fl::wait(0.06);

  if (was_ok)
  {
    // run the scripts Scotty!
    was_ok = ob_build_cool_shit();

    was_ok = game_object->Finish(was_ok);
  }

  if (was_ok)
  {
    Main_ProgStatus("Success");

    u32_t end_time = TimeGetMillies();
    u32_t total_time = end_time - start_time;

    LogPrintf("\nTOTAL TIME: %1.2f seconds\n\n", total_time / 1000.0);
  }

  if (main_win)
  {
    main_win->build_box->Prog_Finish();
    main_win->build_box->SetAbortButton(false);

    main_win->Locked(false);

    if (main_win->action == UI_MainWin::ABORT)
      main_win->action = UI_MainWin::NONE;
  }

  // don't need game object anymore
  delete game_object;
  game_object = NULL;

  return was_ok;
}


/* ----- main program ----------------------------- */

int main(int argc, char **argv)
{
  // initialise argument parser (skipping program name)
  ArgvInit(argc-1, (const char **)(argv+1));

  if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0)
  {
    RMZ_ShowInfo();
    exit(1);
  }


  int batch_arg = ArgvFind('b', "batch");
  if (batch_arg >= 0)
  {
    if (batch_arg+1 >= arg_count || arg_list[batch_arg+1][0] == '-')
    {
      fprintf(stderr, "OBLIGE ERROR: missing filename for --batch\n");
      exit(9);
    }

    batch_mode = true;
    batch_output_file = arg_list[batch_arg+1];
  }


  if (! batch_mode)
    Main_SetupFLTK();

  Determine_WorkingPath(argv[0]);
  Determine_InstallPath(argv[0]);

  FileChangeDir(working_path);


  LogInit(batch_mode ? NULL : LOG_FILENAME);

  if (batch_mode || ArgvFind('t', "terminal") >= 0)
    LogEnableTerminal(true);

  LogPrintf("\n");
  LogPrintf("********************************************************\n");
  LogPrintf("** " RMZ_TITLE " " RMZ_VERSION " (C) 2006-2010 Andrew Apted **\n");
  LogPrintf("********************************************************\n");
  LogPrintf("\n");

  LogPrintf("Library versions: %s / FLTK %d.%d.%d / glBSP %s\n\n",
            LUA_RELEASE, FL_MAJOR_VERSION, FL_MINOR_VERSION, FL_PATCH_VERSION,
            GLBSP_VER);

  LogPrintf("working_path: [%s]\n",   working_path);
  LogPrintf("install_path: [%s]\n\n", install_path);

  if (! batch_mode)
    Cookie_Load(CONFIG_FILENAME, true /* PRELOAD */);

  if (ArgvFind('d', "debug") >= 0)
    debug_messages = true;

  LogEnableDebug(debug_messages);

  // load icons for file chooser
#ifndef WIN32
  if (! batch_mode)
    Fl_File_Icon::load_system_icons();
#endif


  const char *config_file = NULL;
  
  int config_arg = ArgvFind('c', "config");
  if (config_arg >= 0)
  {
    if (config_arg+1 >= arg_count || arg_list[config_arg+1][0] == '-')
    {
      fprintf(stderr, "RANDOMIZER ERROR: missing filename for --config\n");
      exit(9);
    }

    config_file = arg_list[config_arg+1];
  }


  Script_Init();

  if (batch_mode)  // TODO
  {
    Main_FatalError("Randomizer does not support batch mode.\n"); 

#if 0
    Script_Load();

    Batch_Defaults();

    // only load an explicitly given config file
    if (config_file)
      Cookie_Load(config_file);

    Cookie_ParseArguments();

    if (! Randomize_Dat_Shit())
    {
      fprintf(stderr, "FAILED!\n");

      Main_Shutdown(false);
      return 3;
    }
#endif
  }
  else
  {
    Default_Location();

    int main_w, main_h;
    UI_MainWin::CalcWindowSize(false, &main_w, &main_h);

    main_win = new UI_MainWin(main_w, main_h, RMZ_TITLE " " RMZ_VERSION);

    Script_Load();

    // FIXME: main_win->Defaults();


    // load config after creating window (will set widget values)
    if (! config_file)
      config_file = CONFIG_FILENAME;

    Cookie_Load(config_file);

    Cookie_ParseArguments();

    if (hide_module_panel)
      main_win->HideModules(true);


    // show window (pass some dummy arguments)
    {
      char *argv[2];
      argv[0] = strdup("Oblige.exe");
      argv[1] = NULL;

      main_win->show(1 /* argc */, argv);
    }

    // kill the stupid bright background of the "plastic" scheme
    delete Fl::scheme_bg_;
    Fl::scheme_bg_ = NULL;

    main_win->image(NULL);

    Fl::add_handler(Main_key_handler);

    // draw an empty map (must be done after main window is
    // shown() because that is when FLTK finalises the colors).
    main_win->build_box->mini_map->EmptyMap();


    ConPrintf("All Globals: @b2table:e:0:0@\n\n");

    ConPrintf("READY\n");


    try
    {
      // run the GUI until the user quits
      for (;;)
      {
        Fl::wait(0.2);

        if (main_win->action == UI_MainWin::QUIT)
          break;

        if (main_win->action == UI_MainWin::BUILD)
        {
          main_win->action = UI_MainWin::NONE;

          // save config in case everything blows up
          Cookie_Save(CONFIG_FILENAME);

          Randomize_Dat_Shit();
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
  }

  Main_Shutdown(false);

  return 0;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
