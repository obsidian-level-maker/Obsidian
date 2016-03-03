//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2014 Andrew Apted
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
#include "hdr_ui.h"
#include "main.h"

#ifndef WIN32
#include <unistd.h>
#endif

#if (FL_MAJOR_VERSION != 1 ||  \
	 FL_MINOR_VERSION != 3 ||  \
	 FL_PATCH_VERSION < 0)
#error "Require FLTK version 1.3.0 or later"
#endif


#define BASE_WINDOW_W  732
#define BASE_WINDOW_H  432


UI_MainWin *main_win;

int KF = 0;

int  small_font_size;
int header_font_size;


static void main_win_close_CB(Fl_Widget *w, void *data)
{
	main_action = MAIN_QUIT;
}


//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(int W, int H, const char *title) :
	Fl_Double_Window(W, H, title)
{
	end(); // cancel begin() in Fl_Group constructor

	// not resizable!
	size_range(W, H, W, H);

	callback((Fl_Callback *) main_win_close_CB);

	color(WINDOW_BG, WINDOW_BG);

	int MOD_W   = W * 2 / 5;
	int TOP_H   = H * 2 / 5;

	int PANEL_W = (W - MOD_W) / 2 - 4;
	int BOT_H   = H - TOP_H - 4;

	game_box = new UI_Game(0, 0, PANEL_W, TOP_H);
	add(game_box);

	level_box = new UI_Level(PANEL_W+4, 0, PANEL_W, TOP_H);
	add(level_box);

	play_box = new UI_Play(PANEL_W+4, TOP_H+4, PANEL_W, BOT_H);
	add(play_box);


	build_box = new UI_Build(0, TOP_H+4, PANEL_W, BOT_H);
	add(build_box);


	mod_box = new UI_CustomMods(W - MOD_W, 0, MOD_W, TOP_H+4 + BOT_H);
	add(mod_box);


	resizable(NULL);
}


//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{ }


void UI_MainWin::CalcWindowSize(int *W, int *H)
{
	*W = kf_w(BASE_WINDOW_W);
	*H = kf_h(BASE_WINDOW_H);

	if (KF < 0) *W -= 20;
}


void UI_MainWin::Locked(bool value)
{
	game_box ->Locked(value);
	level_box->Locked(value);
	play_box ->Locked(value);
	build_box->Locked(value);
	mod_box  ->Locked(value);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
