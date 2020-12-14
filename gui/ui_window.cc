//------------------------------------------------------------------------
//  Main Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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


#define BASE_WINDOW_W  816
#define BASE_WINDOW_H  512


UI_MainWin *main_win;

int KF = 0;

int  small_font_size;
int header_font_size;

#define MODULE_GREEN	fl_rgb_color(0,160,0)
#define MODULE_RED		fl_rgb_color(224,0,0)
#define XXX_PURPLE		fl_rgb_color(208,0,208)



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
	// only vertically resizable
	size_range(W, H, W, 2000);

	callback((Fl_Callback *) main_win_close_CB);

	color(WINDOW_BG, WINDOW_BG);


	int LEFT_W = kf_w(232);
	int MOD_W   = (W - LEFT_W) / 2 - 4;

	int TOP_H   = kf_h(228);
	int BOT_H   = H - TOP_H - 4;

	game_box = new UI_Game(0, 0, LEFT_W, TOP_H);

	build_box = new UI_Build(0, TOP_H+4, LEFT_W, BOT_H);

	right_mods = new UI_CustomMods(W - MOD_W, 0, MOD_W, H, MODULE_RED);

	left_mods = new UI_CustomMods(LEFT_W+4, 0, MOD_W, H, MODULE_GREEN);


	end();

	resizable(right_mods);
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

	// tweak for "Tiny" setting
	if (KF < 0)
	{
		*W -= 24;
		*H -= 24;
	}

//// DEBUG
//	fprintf(stderr, "\n\nCalcWindowSize --> %d x %d\n", *W, *H);
}


void UI_MainWin::Locked(bool value)
{
	game_box  ->Locked(value);
	build_box ->Locked(value);
	left_mods ->Locked(value);
	right_mods->Locked(value);
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
