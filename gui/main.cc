//------------------------------------------------------------------------
//  Main program
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
#include "hdr_lua.h"

#include "lib_argv.h"
#include "lib_util.h"

#include "main.h"
#include "g_cookie.h"
#include "g_doom.h"
#include "g_glbsp.h"
///--- #include "g_image.h"
#include "g_lua.h"
#include "g_wolf.h"

#include "hdr_fltk.h"
#include "ui_chooser.h"
#include "ui_dialog.h"
#include "ui_window.h"


#define TICKER_TIME  20 /* ms */

#define CONFIG_FILENAME  "CONFIG.cfg"
#define LOG_FILENAME     "LOGS.txt"

#define TEMP_FILENAME    "TEMP.wad"  // FIXME: move to g_doom


const char *working_path = NULL;
const char *install_path = NULL;


/* ----- user information ----------------------------- */

static void ShowInfo(void)
{
  printf(
    "\n"
    "** " OBLIGE_TITLE " " OBLIGE_VERSION " (C) 2006,2007 Andrew Apted **\n"
    "\n"
  );

  printf(
    "Usage: Oblige [options...]\n"
    "\n"
    "Available options:\n"
    "  -d  -debug        Enable debugging\n"
    "  -t  -terminal     Print log messages to stdout\n"
    "  -h  -help         Show this help message\n"
    "\n"
  );

  printf(
    "This program is free software, under the terms of the GNU General\n"
    "Public License, and comes with ABSOLUTELY NO WARRANTY.  See the\n"
    "documentation for more details, or visit this web page:\n"
    "http://www.gnu.org/licenses/gpl.html\n"
    "\n"
  );
}

void Determine_WorkingPath(const char *argv0)
{
  // firstly find the "Working directory", and set it as the
  // current directory.  That's the place where the CONFIG.cfg
  // and LOGS.txt files are, as well the temp files.

#ifndef FHS_INSTALL
  working_path = GetExecutablePath(argv0);

#else
  working_path = StringNew(FL_PATH_MAX + 4);

  fl_filename_expand(working_path, "$HOME/.oblige");

  // try to create it (doesn't matter if it already exists)
  FileMakeDir(working_path);
#endif

  if (! working_path)
    working_path = StringDup(".");
}

void Determine_InstallPath(const char *argv0)
{
  // secondly find the "Install directory", and store the
  // result in the global variable 'install_path'.  This is
  // where all the LUA scripts and other data files are.

#ifndef FHS_INSTALL
  install_path = StringDup(working_path);

#else
  static const char *prefixes[] =
  {
    "/usr/local", "/usr", "/opt", NULL
  };

  for (int i = 0; prefixes[i]; i++)
  {
    install_path = StringPrintf("%s/share/oblige-%s",
        prefixes[i], OBLIGE_VERSION);

    const char *filename = StringPrintf("%s/scripts/oblige.lua", install_path);

fprintf(stderr, "Trying install path: [%s]\n  with file: [%s]\n\n",
install_path, filename)

    bool exists = FileExists(filename);

    StringFree(filename);

    if (exists)
      break;

    StringFree(install_path);
    install_path = NULL;
  }
#endif

  if (! install_path)
    Main_FatalError("Unable to find LUA script folder!\n");
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
  if (main_win)
  {
    Cookie_Save(CONFIG_FILENAME);

    delete main_win;
    main_win = NULL;
  }

  Script_Close();
  LogClose();
  ArgvClose();
}

void Main_FatalError(const char *msg, ...)
{
  static char buffer[MSG_BUF_LEN];

  va_list arg_pt;

  va_start(arg_pt, msg);
  vsnprintf(buffer, MSG_BUF_LEN-1, msg, arg_pt);
  va_end(arg_pt);

  buffer[MSG_BUF_LEN-2] = 0;

  DLG_ShowError("%s", buffer);

  Main_Shutdown();

  exit(9);
}


//------------------------------------------------------------------------

void Build_Cool_Shit()
{
  bool is_wolf  = (strcmp(main_win->setup_box->get_Game(), "wolf3d") == 0) ||
                  (strcmp(main_win->setup_box->get_Game(), "spear")  == 0);

  bool is_hexen = (strcmp(main_win->setup_box->get_Game(), "hexen")  == 0);

  // multiplayer not supported in Wolf3d / SOD
  // FIXME: disable the "Mode:" control when wolf/spear are selected
  if (is_wolf)
  {
    if (strcmp(main_win->setup_box->get_Mode(), "sp") != 0)
    {
      DLG_ShowError("Multiplayer modes not supported in Wolf3D or Spear-of-Destiny.");
      return;
    }
  }

  UI_Build *bb_area = main_win->build_box;

  char *filename = Select_Output_File();
  if (! filename)
    return;

  Fl::check();

  // lock most widgets of user interface
  main_win->Locked(true);
  bb_area->ProgSetButton(true);

  bool was_ok;

  if (is_wolf)
    was_ok = Wolf_Begin();
  else
    was_ok = Doom_CreateWAD(TEMP_FILENAME, is_hexen);

  bb_area->ProgInit(is_wolf ? 1 : 2);

  if (was_ok)
  {
    bb_area->ProgStatus("Making levels");
    bb_area->ProgBegin(1, 100);

    if (! Script_Run())
    {
      if (main_win->action >= UI_MainWin::ABORT)
        bb_area->ProgStatus("Aborted");
      else
        bb_area->ProgStatus("Script Error");

      was_ok = false;
    }

    if (is_wolf)
      Wolf_Finish();
    else
      Doom_FinishWAD();
  }

  // FIXME: backup wolf output files on failure

  if (was_ok and !is_wolf)
  {
    DebugPrintf("TARGET FILENAME: [%s]\n", filename);

    if (FileExists(filename))
    {
      LogPrintf("Backing up existing file: %s\n", filename);

      // make a backup
      char *backup_name = ReplaceExtension(filename, "bak");

      if (! FileCopy(filename, backup_name))
        LogPrintf("WARNING: unable to create backup: %s\n", backup_name);

      StringFree(backup_name);
    }

    bb_area->ProgStatus("Building nodes");

    if (! GB_BuildNodes(TEMP_FILENAME, filename))
    {
      if (main_win->action >= UI_MainWin::ABORT)
        bb_area->ProgStatus("Aborted");
      else
        bb_area->ProgStatus("glBSP Error");

      was_ok = false;
    }
  }

  bb_area->ProgFinish();

  // FIXME: delete wolf output files on failure

  if (!is_wolf)
  {
/* !!!!!
    if (! FileDelete(TEMP_FILENAME))
      LogPrintf("WARNING: unable to delete temp file: %s\n", TEMP_FILENAME);
*/
  }

  StringFree(filename);

  if (was_ok)
    bb_area->ProgStatus("Success");

  bb_area->ProgSetButton(false);
  main_win->Locked(false);

  if (main_win->action == UI_MainWin::ABORT)
    main_win->action =  UI_MainWin::NONE;
}


/* ----- main program ----------------------------- */

int main(int argc, char **argv)
{
  // initialise argument parser (skipping program name)
  ArgvInit(argc-1, (const char **)(argv+1));

  if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0)
  {
    ShowInfo();
    exit(1);
  }

  Fl::scheme("plastic");

  fl_message_font(FL_HELVETICA /* _BOLD */, 18);

  Determine_WorkingPath(argv[0]);
  Determine_InstallPath(argv[0]);

  FileChangeDir(working_path);

  LogInit(LOG_FILENAME);

  if (ArgvFind('d', "debug") >= 0)
    LogEnableDebug();

  if (ArgvFind('t', "terminal") >= 0)
    LogEnableTerminal();

  LogPrintf(OBLIGE_TITLE " " OBLIGE_VERSION " (C) 2006,2007 Andrew Apted\n\n");

  LogPrintf("working_path: [%s]\n",   working_path);
  LogPrintf("install_path: [%s]\n\n", install_path);

  // load icons for file chooser
  Fl_File_Icon::load_system_icons();

  Script_Init();
  Doom_Init();
  Wolf_Init();

  Default_Location();

  main_win = new UI_MainWin(OBLIGE_TITLE);

  // load config after creating window (set widget values)
  Cookie_Load(CONFIG_FILENAME);

  Script_Load();
  
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

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
