//------------------------------------------------------------------------
//  MAIN Program
//------------------------------------------------------------------------
//
//  Tailor Lua Editor  Copyright (C) 2008  Andrew Apted
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
//
//  Based on the "editor.cxx" sample program from FLTK 1.1.6,
//  as described in Chapter 4 of the FLTK Programmer's Guide.
//  
//  Copyright 1998-2004 by Bill Spitzak, Mike Sweet and others.
//
//------------------------------------------------------------------------

// this includes everything we need
#include "headers.h"


#define GUI_PrintMsg  printf


static bool inited_FLTK = false;

static int main_result = 0;


static void ShowTitle(void)
{
    GUI_PrintMsg(
        "\n"
        "**** " PROG_NAME_FULL " (C) 2008 Andrew Apted ****\n\n"
    );
}

static void ShowInfo(void)
{
    GUI_PrintMsg(
        "Info...\n\n"
    );
}


void MainSetDefaults(void)
{
}

static int ignore_escape_key(int event)
{
    if (event == FL_SHORTCUT && Fl::event_key() == FL_Escape)
        return 1;

    return 0;
}

void InitFLTK(void)
{
    Fl::scheme(NULL);

    fl_message_font(FL_HELVETICA, 18);

    Fl_File_Icon::load_system_icons();

    // we don't want the ESCAPE key to automatically quit
    Fl::add_handler(ignore_escape_key);

    inited_FLTK = true;
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

void FatalError(...)
{
    exit(999); //!!!!!!! FIXME
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
     
        if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0)
        {
            ShowTitle();
            ShowInfo();
            exit(1);
        }

        if (arg_count < 1 || ArgvIsOption(0))
            FatalError("ERROR: Missing filename.\n");

        InitFLTK();

        MainSetDefaults();


#if 0
        const char *filename = "data/doom2.wad";

        if (arg_count > 0 && ! ArgvIsOption(0))
            filename = arg_list[0];
        else
        {
            int params;
            int idx = ArgvFind(0, "file", &params);

            if (idx >= 0 && params >= 1)
                filename = arg_list[idx + 1];
        }

        if (! CheckExtension(filename, "ddf"))
            FatalError("Main file must be a DDF file.\n");
#endif

        main_win = new W_MainWindow(PROG_NAME_FULL);

        // show window (pass some dummy arguments)
        {
            int argc = 1;
            char *argv[] = { PROG_NAME ".exe", NULL };

            main_win->show(argc, argv);
        }

        if (main_win->ed->Load(arg_list[0]))
        {
            // run the GUI until the user quits
            while (! main_win->want_quit)
            {
                Fl::wait(1.0);

                int line, col;
                main_win->ed->GetInsertPos(&line, &col);
                main_win->status->SetPos(line, col);
            }
        }
    }
    catch (const char * err)
    {
        DisplayError("%s", err);
    }
    catch (assert_fail_c err)
    {
        DisplayError("Sorry, an internal error occurred:\n%s", err.GetMessage());
    }
    catch (...)
    {
        DisplayError("An unknown problem occurred (UI code)");
    }

    delete main_win;

    return main_result;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
