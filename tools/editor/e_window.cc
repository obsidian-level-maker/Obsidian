//------------------------------------------------------------------------
//  WINDOW : Main application window
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

// this includes everything we need
#include "headers.h"

#ifndef WIN32
#include <unistd.h>
#endif


W_MainWindow *main_win;


static void main_win_close_CB(Fl_Widget *w, void *data)
{
    if (main_win)
        main_win->want_quit = true;
}


//
// MainWin Constructor
//
W_MainWindow::W_MainWindow(const char *title) :
     Fl_Double_Window(600, 420, title)
{
    // turn off auto-add-widget mode
    end();

    size_range(MAIN_WINDOW_MIN_W, MAIN_WINDOW_MIN_H);

    // Set initial position.
    //
    // Note: this may not work properly.  It seems that when my window
    // manager adds the titlebar/border, it moves the actual window
    // down and slightly to the right, causing subsequent invokations
    // to keep going lower and lower.

    ///  position(guix_prefs.win_x, guix_prefs.win_y);

    callback((Fl_Callback *) main_win_close_CB);

    // set a nice darkish gray for the space between main boxes
    color(MAIN_BG_COLOR, MAIN_BG_COLOR);

    want_quit = false;


    // create contents
    int hw = (w() - 8*2 - 4) / 2;
    int mh = 28;

#ifdef MACOSX
    mh = 1;
#endif

    int sb_w = 220;

    menu_bar = MenuCreate(0, 0, w() - sb_w, 28);
    add(menu_bar);


    status = new W_Status(w() - sb_w, 0, sb_w, 28);
    add(status);


    ed = new W_Editor(0, mh, w(), h()-mh);
    add(ed);
    resizable(ed);

}

//
// MainWin Destructor
//
W_MainWindow::~W_MainWindow()
{
}


//--- editor settings ---
// vi:ts=4:sw=4:expandtab
