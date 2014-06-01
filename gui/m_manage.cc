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

#include "lib_util.h"

#include "main.h"
#include "m_lua.h"


#define MANAGE_WIN_W  620
#define MANAGE_WIN_H  380

#define BG_COLOR  fl_gray_ramp(10)


class UI_Manage_Config : public Fl_Double_Window
{
public:
	bool want_quit;

	Fl_Text_Buffer *text_buf;

	Fl_Text_Display *conf_disp;

	Fl_Button *load_but;
	Fl_Button *extract_but;
	Fl_Button *save_but;
	Fl_Button *use_but;
	Fl_Button *close_but;

	Fl_Button *cut_but;
	Fl_Button *copy_but;
	Fl_Button *paste_but;

public:
	UI_Manage_Config(const char *label = NULL);

	virtual ~UI_Manage_Config();

	bool WantQuit() const
	{
		return want_quit;
	}

	void MarkSource(const char *where)
	{
		if (! where)
			where = "NONE";

		char *full = StringPrintf(" Configuration Text  [%s]", where);

		conf_disp->copy_label(full);

		StringFree(full);

		redraw();
	}

	void Clear()
	{
		MarkSource(NULL);

		text_buf->select(0, text_buf->length());
		text_buf->remove_selection();

		save_but->deactivate();
		 use_but->deactivate();

		 cut_but->deactivate();
		copy_but->deactivate();

		redraw();
	}

	void Enable()
	{
		save_but->activate();
		 use_but->activate();

		 cut_but->activate();
		copy_but->activate();

		redraw();
	}

	void ReadCurrentSettings()
	{
		Clear();

		text_buf->append("-- CONFIG FILE : OBLIGE " OBLIGE_VERSION "\n"); 
		text_buf->append("-- " OBLIGE_TITLE " (C) 2006-2014 Andrew Apted\n");
		text_buf->append("-- http://oblige.sourceforge.net/\n\n");

		std::vector<std::string> lines;

		ob_read_all_config(&lines);

		for (unsigned int i = 0 ; i < lines.size() ; i++)
		{
			text_buf->append(lines[i].c_str());
			text_buf->append("\n");
		}

		MarkSource("current settings");

		Enable();
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
UI_Manage_Config::UI_Manage_Config(const char *label) :
    Fl_Double_Window(MANAGE_WIN_W, MANAGE_WIN_H, label),
	want_quit(false)
{
	size_range(MANAGE_WIN_W, MANAGE_WIN_H);

	if (alternate_look)
		color(FL_DARK2, FL_DARK2);
	else
		color(BG_COLOR, BG_COLOR);

	callback(callback_Quit, this);


	text_buf = new Fl_Text_Buffer();


	conf_disp = new Fl_Text_Display(190, 30, 410, 288, " Reading Config....");
	conf_disp->align(Fl_Align(FL_ALIGN_TOP_LEFT));
	conf_disp->labelsize(16);
	conf_disp->buffer(text_buf);
	conf_disp->textfont(FL_COURIER);
	conf_disp->textsize(16);


	/* Main Buttons */

	Fl_Box * o;

	load_but = new Fl_Button(30, 25, 100, 35, "  Load @-3>");
	load_but->labelsize(FL_NORMAL_SIZE + 0);

	extract_but = new Fl_Button(30, 85, 100, 35, "  Extract @-3>");
	extract_but->labelsize(FL_NORMAL_SIZE);

	o = new Fl_Box(15, 116, 171, 40, "from a WAD or PAK file");
	o->align(Fl_Align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE));
	o->labelsize(14);

	save_but = new Fl_Button(30, 165, 100, 35, "Save");
	save_but->labelsize(FL_NORMAL_SIZE);

	use_but = new Fl_Button(30, 225, 100, 35, "Use");
	use_but->labelsize(FL_NORMAL_SIZE);

	o = new Fl_Box(15, 256, 173, 50, "Note: this will replace\nall current settings!");
	o->align(Fl_Align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE));
	o->labelsize(14);

	close_but = new Fl_Button(30, 325, 100, 40, "Close");
	close_but->labelfont(FL_HELVETICA_BOLD);
	close_but->labelsize(FL_NORMAL_SIZE);
	close_but->callback(callback_Quit, this);


	/* Clipboard buttons */

	{
		Fl_Group *g = new Fl_Group(conf_disp->x(), 318, conf_disp->w(), MANAGE_WIN_H - 318);
		g->resizable(NULL);

		o = new Fl_Box(215, 318, 355, 30, " Clipboard Operations");
		o->align(Fl_Align(FL_ALIGN_CENTER | FL_ALIGN_INSIDE));
		o->labelsize(14);

		cut_but = new Fl_Button(245, 345, 80, 25, "Cut");
		cut_but->labelsize(FL_NORMAL_SIZE - 2);
		cut_but->shortcut(FL_CTRL + 'x');

		copy_but = new Fl_Button(360, 345, 80, 25, "Copy");
		copy_but->labelsize(FL_NORMAL_SIZE - 2);
		copy_but->shortcut(FL_CTRL + 'c');

		paste_but = new Fl_Button(475, 345, 80, 25, "Paste");
		paste_but->labelsize(FL_NORMAL_SIZE - 2);
		paste_but->shortcut(FL_CTRL + 'v');

		g->end();
	}

	end();

	resizable(conf_disp);
}


//
// Destructor
//
UI_Manage_Config::~UI_Manage_Config()
{ }


void DLG_ManageConfig(void)
{
	static UI_Manage_Config * config_window = NULL;

	if (config_window)  // already in use?
		return;

	config_window = new UI_Manage_Config("OBLIGE Config Manager");

	config_window->set_modal();
	config_window->show();

	config_window->ReadCurrentSettings();

	// run the GUI until the user closes
	while (! config_window->WantQuit())
		Fl::wait();

	// this deletes all the child widgets too...
	delete config_window;

	config_window = NULL;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
