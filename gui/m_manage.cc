//------------------------------------------------------------------------
//  Manage Config Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2014 Andrew Apted
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


#define WINDOW_MIN_W  620
#define WINDOW_MIN_H  380

#define BG_COLOR  fl_rgb_color(0x66, 0x5E, 0x55)


class UI_Manage_Config : public Fl_Double_Window
{
public:
	bool want_quit;

	Fl_Text_Display *conf_text;

	Fl_Button *load_but;
	Fl_Button *extract_but;
	Fl_Button *save_but;
	Fl_Button *use_but;
	Fl_Button *close_but;

	Fl_Button *cut_but;
	Fl_Button *copy_but;
	Fl_Button *paste_but;

public:
	UI_Manage_Config();

	virtual ~UI_Manage_Config();

	bool WantQuit() const
	{
		return want_quit;
	}

private:
	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		that->want_quit = true;
	}
};


//
// Constructor
//
UI_Manage_Config::UI_Manage_Config() :
    Fl_Double_Window(WINDOW_MIN_W, WINDOW_MIN_H, "Manage Configs"),
	want_quit(false)
{
	size_range(WINDOW_MIN_W, WINDOW_MIN_H,
	           2000, 2000);

	callback(callback_Quit, this);

	color(FL_DARK2, FL_DARK2);


	conf_text = new Fl_Text_Display(190, 30, 410, 288, " Configuration : current OBLIGE settings");
	conf_text->align(Fl_Align(FL_ALIGN_TOP_LEFT));


	/* Main Buttons */

	load_but = new Fl_Button(20, 25, 120, 35, "  Load @-3>");
	load_but->labelsize(18);

	extract_but = new Fl_Button(20, 85, 120, 35, "  Extract @-3>");
	extract_but->labelsize(18);

	new Fl_Box(15, 116, 171, 39, "from a WAD or PAK file");

	save_but = new Fl_Button(20, 165, 120, 35, "Save");
	save_but->labelsize(18);

	use_but = new Fl_Button(20, 225, 120, 35, "Use");
	use_but->labelsize(18);

	new Fl_Box(15, 256, 173, 39, "replace all current\nsettings in OBLIGE");

	close_but = new Fl_Button(30, 320, 100, 40, "Close");
	close_but->labelfont(1);
	close_but->labelsize(18);
	close_but->callback(callback_Quit, this);


	/* Clipboard buttons */

	{ Fl_Box* o = new Fl_Box(215, 318, 355, 29, " Clipboard Operations");
	  o->align(Fl_Align(FL_ALIGN_CENTER|FL_ALIGN_INSIDE));
	}

	cut_but = new Fl_Button(245, 345, 80, 25, "Cut");

	copy_but = new Fl_Button(360, 345, 80, 25, "Copy");

	paste_but = new Fl_Button(475, 345, 80, 25, "Paste");


	end();

	resizable(conf_text);
}


//
// Destructor
//
UI_Manage_Config::~UI_Manage_Config()
{ }


void DLG_ManageConfig()
{
	static UI_Manage_Config * config_window = NULL;

	if (config_window)  // already in use?
		return;

	config_window = new UI_Manage_Config(); /// opt_w, opt_h, "Oblige Options");

	config_window->show();

	// run the GUI until the user closes
	while (! config_window->WantQuit())
		Fl::wait();

	// this deletes all the child widgets too...
	delete config_window;

	config_window = NULL;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
