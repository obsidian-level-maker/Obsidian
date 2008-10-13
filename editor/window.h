//------------------------------------------------------------------------
//  WINDOW : Main application window
//------------------------------------------------------------------------
//
//  Lua_Modify  Copyright (C) 2008  Andrew Apted
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

#ifndef __LM_WINDOW_H__
#define __LM_WINDOW_H__

#define MAIN_BG_COLOR  fl_gray_ramp(FL_NUM_GRAY * 9 / 24)

#define MAIN_WINDOW_MIN_W  540
#define MAIN_WINDOW_MIN_H  450

class Guix_MainWin : public Fl_Double_Window
{
public:
    Guix_MainWin(const char *title);
    virtual ~Guix_MainWin();

    // main child widgets
  
#ifdef MACOSX
    Fl_Sys_Menu_Bar *menu_bar;
#else
    Fl_Menu_Bar *menu_bar;
#endif

    W_Editor *ed;

    // user closed the window
    bool want_quit;

};

extern Guix_MainWin * guix_win;

void WindowSmallDelay(void);


#endif /* __LM_WINDOW_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:expandtab
