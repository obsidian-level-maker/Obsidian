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
#include "m_cookie.h"
#include "m_lua.h"


#define MANAGE_WIN_W  620
#define MANAGE_WIN_H  380

#define BG_COLOR  fl_gray_ramp(10)


//
// this prevents the text display widget from selecting areas,
// as well as eating the CTRL-A and CTRL-C keyboard events.
//
class Fl_Text_Display_NoSelect : public Fl_Text_Display
{
public:
	Fl_Text_Display_NoSelect(int X, int Y, int W, int H, const char *label = 0) : 
		Fl_Text_Display(X, Y, W, H, label)
	{ }

	virtual ~Fl_Text_Display_NoSelect()
	{ }

	virtual int handle(int e)
	{
		switch (e)
		{
			case FL_KEYBOARD: case FL_KEYUP:
			case FL_PUSH: case FL_RELEASE:
			case FL_DRAG:
				return Fl_Group::handle(e);
		}

		return Fl_Text_Display::handle(e);
	}
};


class UI_Manage_Config : public Fl_Double_Window
{
public:
	bool want_quit;

	Fl_Text_Buffer *text_buf;

	Fl_Text_Display_NoSelect *conf_disp;

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

		Enable();

		MarkSource("CURRENT SETTINGS");
	}

	void ReplaceWithString(const char *new_text)
	{
		Clear();

		text_buf->append(new_text);

		Enable();
	}

	const char * AskSaveFilename()
	{
		Fl_Native_File_Chooser chooser;

		chooser.title("Pick file to save to");
		chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);
		chooser.filter("Text files\t*.txt\nConfig files\t*.cfg");

		// FIXME: chooser.directory(LAST_USED_DIRECTORY)

		switch (chooser.show())
		{
			case -1:
				LogPrintf("Error choosing save file:\n");
				LogPrintf("   %s\n", chooser.errmsg());

				DLG_ShowError("Unable to save the file:\n\n%s", chooser.errmsg());
				return NULL;

			case 1:  // cancelled
				return NULL;

			default:
				break;  // OK
		}

		static char filename[FL_PATH_MAX + 10];

		strcpy(filename, chooser.filename());

		// if extension is missing then add ".txt"
		char *pos = (char *)fl_filename_ext(filename);
		if (! *pos)
			strcat(filename, ".txt");

		return filename;
	}

	void SaveToFile(const char *filename)
	{
		// (checking FLTK code, the file is opened in "w" mode,
		//  hence should end-of-line in an OS-appropriate way).
		int res = text_buf->savefile(filename);

		int err_no = errno;

		if (res)
		{
			const char *reason = (res == 1 && err_no) ? strerror(err_no) :
								 "Error writing to file.";

			DLG_ShowError("Unable to save the file:\n\n%s", reason);
		}
	}

private:
	// FLTK virtual method for handling input events
	int handle(int event)
	{
		if (event == FL_PASTE)
		{
			const char *text = Fl::event_text();
			SYS_ASSERT(text);

			if (strlen(text) == 0)
			{
				fl_beep();
			}
			else
			{
				ReplaceWithString(text);
				MarkSource("PASTED TEXT");
			}
			return 1;
		}

		return Fl_Double_Window::handle(event);
	}

private:
	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		that->want_quit = true;
	}

	static void callback_Save(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		if (that->text_buf->length() == 0)
		{
			fl_beep();
			return;
		}

		const char *filename = that->AskSaveFilename();
		if (! filename)
			return;

		that->SaveToFile(filename);
	}

	static void callback_Load(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		// FIXME
	}

	static void callback_Extract(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		// FIXME
	}

	static void callback_Use(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		if (that->text_buf->length() == 0)
		{
			fl_beep();
			return;
		}

		const char *str = that->text_buf->text();

		Cookie_LoadString(str);

		free((void*)str);
	}

	/* Clipboard stuff */

	static void callback_Copy(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		if (that->text_buf->length() == 0)
		{
			fl_beep();
			return;
		}

		const char *str = that->text_buf->text();

		Fl::copy(str, strlen(str), 1);

		free((void*)str);
	}

	static void callback_Cut(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		callback_Copy(w, data);

		if (that->text_buf->length() > 0)
			that->Clear();
	}

	static void callback_Paste(Fl_Widget *w, void *data)
	{
		UI_Manage_Config *that = (UI_Manage_Config *)data;

		Fl::paste(*that, 1);
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


	conf_disp = new Fl_Text_Display_NoSelect(190, 30, 410, 288, " Reading Config....");
	conf_disp->align(Fl_Align(FL_ALIGN_TOP_LEFT));
	conf_disp->labelsize(16);
	conf_disp->buffer(text_buf);
	conf_disp->textfont(FL_COURIER);
	conf_disp->textsize(12);


	/* Main Buttons */

	Fl_Box * o;

	{
		Fl_Group *g = new Fl_Group(0, 0, conf_disp->x(), conf_disp->h());
		g->resizable(NULL);

		load_but = new Fl_Button(30, 25, 100, 35, "  Load @-3>");
		load_but->labelsize(FL_NORMAL_SIZE + 0);

		extract_but = new Fl_Button(30, 85, 100, 35, "  Extract @-3>");
		extract_but->labelsize(FL_NORMAL_SIZE);

		o = new Fl_Box(15, 116, 171, 40, "from a WAD or PAK file");
		o->align(Fl_Align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE));
		o->labelsize(14);

		save_but = new Fl_Button(30, 165, 100, 35, "Save");
		save_but->labelsize(FL_NORMAL_SIZE);
		save_but->callback(callback_Save, this);
		save_but->shortcut(FL_CTRL + 's');

		use_but = new Fl_Button(30, 225, 100, 35, "Use");
		use_but->labelsize(FL_NORMAL_SIZE);
		use_but->callback(callback_Use, this);

		o = new Fl_Box(15, 256, 173, 50, "Note: this will replace\nall current settings!");
		o->align(Fl_Align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE));
		o->labelsize(14);

		g->end();
	}

	close_but = new Fl_Button(30, 325, 100, 40, "Close");
	close_but->labelfont(FL_HELVETICA_BOLD);
	close_but->labelsize(FL_NORMAL_SIZE);
	close_but->callback(callback_Quit, this);
	close_but->shortcut(FL_CTRL + 'w');


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
		cut_but->callback(callback_Cut, this);

		copy_but = new Fl_Button(360, 345, 80, 25, "Copy");
		copy_but->labelsize(FL_NORMAL_SIZE - 2);
		copy_but->shortcut(FL_CTRL + 'c');
		copy_but->callback(callback_Copy, this);

		paste_but = new Fl_Button(475, 345, 80, 25, "Paste");
		paste_but->labelsize(FL_NORMAL_SIZE - 2);
		paste_but->shortcut(FL_CTRL + 'v');
		paste_but->callback(callback_Paste, this);

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

	// if it already exists, simply re-show it
	if (! config_window)
		config_window = new UI_Manage_Config("OBLIGE Config Manager");

	config_window->want_quit = false;
	config_window->set_modal();
	config_window->show();

	config_window->ReadCurrentSettings();

	// run the GUI until the user closes
	while (! config_window->WantQuit())
		Fl::wait();

	config_window->set_non_modal();
	config_window->hide();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
