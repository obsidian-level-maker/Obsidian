//----------------------------------------------------------------------
//  Options Editor
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_argv.h"
#include "lib_util.h"

#include "main.h"
#include "m_cookie.h"


static void Parse_Option(const char *name, const char *value)
{
	if (StringCaseCmpPartial(name, "recent") == 0)
	{
		Recent_Parse(name, value);
		return;
	}

	if (StringCaseCmp(name, "alternate_look") == 0)
	{
		alternate_look = atoi(value) ? true : false;
	}
	else if (StringCaseCmp(name, "window_size") == 0)
	{
		window_size = atoi(value);
		window_size = CLAMP(0, window_size, 5);
	}
	else if (StringCaseCmp(name, "create_backups") == 0)
	{
		create_backups = atoi(value) ? true : false;
	}
	else if (StringCaseCmp(name, "debug_messages") == 0)
	{
		debug_messages = atoi(value) ? true : false;
	}
	else if (StringCaseCmp(name, "fast_lighting") == 0)
	{
		fast_lighting = atoi(value) ? true : false;
	}
	else if (StringCaseCmp(name, "last_file") == 0)
	{
//???		UI_SetLastFile(value);
	}
	else
	{
		LogPrintf("Unknown option: '%s'\n", name);
	}
}


static bool Options_ParseLine(char *buf)
{
	// remove whitespace
	while (isspace(*buf))
		buf++;

	int len = strlen(buf);

	while (len > 0 && isspace(buf[len-1]))
		buf[--len] = 0;

	// ignore blank lines and comments
	if (*buf == 0)
		return true;

	if (buf[0] == '-' && buf[1] == '-')
		return true;

	if (! isalpha(*buf))
	{
		LogPrintf("Weird option line: [%s]\n", buf);
		return false;
	}

	// Righteo, line starts with an identifier.  It should be of the
	// form "name = value".  We terminate the identifier and pass
	// the name/value strings to the matcher function.

	const char *name = buf;

	for (buf++ ; isalnum(*buf) || *buf == '_' || *buf == '.' ; buf++)
	{ /* nothing here */ }

	while (isspace(*buf))
		*buf++ = 0;

	if (*buf != '=')
	{
		LogPrintf("Option line missing '=': [%s]\n", buf);
		return false;
	}

	*buf++ = 0;

	if (isspace(*buf))
		*buf++ = 0;

	// everything after the " = " (note: single space) is the value,
	// and it does not need escaping since our values never contain
	// newlines or embedded spaces (nor control characters, but may
	// contain UTF-8 encoded filenames).

	if (*buf == 0)
	{
		LogPrintf("Option line missing value!\n");
		return false;
	}

	Parse_Option(name, buf);
	return true;
}


bool Options_Load(const char *filename)
{
	FILE *option_fp = fopen(filename, "r");

	if (! option_fp)
	{
		LogPrintf("Missing Options file -- using defaults.\n\n");
		return false;
	}

	LogPrintf("Loading Options...\n");

	// simple line-by-line parser
	char buffer[MSG_BUF_LEN];

	int error_count = 0;

	while (fgets(buffer, MSG_BUF_LEN-2, option_fp))
		if (! Options_ParseLine(buffer))
			error_count += 1;

	if (error_count > 0)
		LogPrintf("DONE (found %d parse errors)\n\n", error_count);
	else
		LogPrintf("DONE.\n\n");

	fclose(option_fp);

	return true;
}


bool Options_Save(const char *filename)
{
	FILE *option_fp = fopen(filename, "w");

	if (! option_fp)
	{
		LogPrintf("Error: unable to create file: %s\n(%s)\n\n",
				  filename, strerror(errno));
		return false;
	}

	LogPrintf("Saving Options...\n");

	fprintf(option_fp, "-- OPTIONS FILE : OBLIGE %s\n", OBLIGE_VERSION); 
	fprintf(option_fp, "-- " OBLIGE_TITLE " (C) 2006-2014 Andrew Apted\n");
	fprintf(option_fp, "-- http://oblige.sourceforge.net/\n\n");

	fprintf(option_fp, "alternate_look = %d\n", alternate_look ? 1 : 0);
	fprintf(option_fp, "window_size    = %d\n", window_size);
	fprintf(option_fp, "create_backups = %d\n", create_backups ? 1 : 0);
	fprintf(option_fp, "debug_messages = %d\n", debug_messages ? 1 : 0);
	fprintf(option_fp, "fast_lighting  = %d\n",  fast_lighting ? 1 : 0);

//???	fprintf(option_fp, "last_file = %s\n", UI_GetLastFile());
	fprintf(option_fp, "\n");

	Recent_Write(option_fp);

	fclose(option_fp);

	LogPrintf("DONE.\n\n");

	return true;
}


//----------------------------------------------------------------------


class UI_OptionsWin : public Fl_Window
{
public:
	bool want_quit;

private:
	Fl_Check_Button *opt_alt_look;
	Fl_Choice       *opt_win_size;

	Fl_Check_Button *opt_backups;
	Fl_Check_Button *opt_debug;

	Fl_Check_Button *opt_lighting;

public:
	UI_OptionsWin(int W, int H, const char *label = NULL);

	virtual ~UI_OptionsWin()
	{
		// nothing needed
	}

	bool WantQuit() const
	{
		return want_quit;
	}

public:
	// FLTK virtual method for handling input events.
	int handle(int event);

private:
	static void callback_Quit(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		that->want_quit = true;
	}

	static void callback_AltLook(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		alternate_look = that->opt_alt_look->value() ? true : false;
	}

	static void callback_WinSize(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		window_size = that->opt_win_size->value();
	}

	static void callback_Backups(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		create_backups = that->opt_backups->value() ? true : false;
	}

	static void callback_Debug(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		debug_messages = that->opt_debug->value() ? true : false;
		LogEnableDebug(debug_messages);
	}

	static void callback_Lighting(Fl_Widget *w, void *data)
	{
		UI_OptionsWin *that = (UI_OptionsWin *)data;

		fast_lighting = that->opt_lighting->value() ? true : false;
	}

};


//
// Constructor
//
UI_OptionsWin::UI_OptionsWin(int W, int H, const char *label) :
	Fl_Window(W, H, label),
	want_quit(false)
{
	// cancel Fl_Group's automatic add crap
	end();

	// non-resizable
	size_range(W, H, W, H);
	callback(callback_Quit, this);

	box(FL_THIN_UP_BOX);

	if (! alternate_look)
		color(BUILD_BG, BUILD_BG);


	int y_step = kf_h(6);
	int pad    = kf_w(6);

	int cx = x() + kf_w(24);
	int cy = y() + y_step;

	Fl_Box *heading;


	heading = new Fl_Box(FL_NO_BOX, x()+pad, cy, W-pad*2, kf_h(24), "Appearance");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(header_font_size);

	add(heading);

	cy += heading->h();


	opt_win_size = new Fl_Choice(145 + KF * 40, cy, kf_w(120), kf_h(24), "Window Size: ");
	opt_win_size->align(FL_ALIGN_LEFT);
	opt_win_size->add("Auto|Tiny|Small|Medium|Large|Huge");
	opt_win_size->callback(callback_WinSize, this);
	opt_win_size->value(window_size);

	add(opt_win_size);

	cy += opt_win_size->h() + y_step;


	opt_alt_look = new Fl_Check_Button(cx, cy, W-cx-pad, kf_h(24), " Alternate Look");
	opt_alt_look->value(alternate_look ? 1 : 0);
	opt_alt_look->callback(callback_AltLook, this);

	add(opt_alt_look);

	cy += opt_alt_look->h() + y_step;


	//----------------

	cy += y_step + y_step/2;

	heading = new Fl_Box(FL_NO_BOX, x()+pad, cy, W-pad*2, kf_h(24), "File Options");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(header_font_size);

	add(heading);

	cy += heading->h() + y_step;


	opt_backups = new Fl_Check_Button(cx, cy, W-cx-pad, kf_h(24), " Create Backups");
	opt_backups->value(create_backups ? 1 : 0);
	opt_backups->callback(callback_Backups, this);

	add(opt_backups);

	cy += opt_backups->h() + y_step;


	opt_debug = new Fl_Check_Button(cx, cy, W-cx-pad, kf_h(24), " Debugging Messages (in LOGS.txt)");
	opt_debug->value(debug_messages ? 1 : 0);
	opt_debug->callback(callback_Debug, this);

	add(opt_debug);

	cy += opt_debug->h() + y_step;


	//----------------


#if 0  // OLD
	cy += y_step + y_step/2;

	heading = new Fl_Box(FL_NO_BOX, x()+pad, cy, W-pad*2, kf_h(24), "Doom / Heretic / Hexen");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);
	heading->labelsize(header_font_size);

	add(heading);

	cy += heading->h() + y_step;


	opt_lighting = new Fl_Check_Button(cx, cy, W-cx-pad, kf_h(24), " Bland Lighting Mode");
	opt_lighting->value(fast_lighting ? 1 : 0);
	opt_lighting->callback(callback_Lighting, this);

	add(opt_lighting);

	cy += opt_lighting->h() + y_step;
#endif



	//----------------

	int dh = kf_h(60);

	Fl_Group *darkish = new Fl_Group(0, H - dh, W, dh);
	darkish->end();
	darkish->box(FL_FLAT_BOX);
	if (! alternate_look)
		darkish->color(BUILD_BG, BUILD_BG);

	add(darkish);


	// finally add an "Close" button
	int bw = kf_w(60);
	int bh = kf_h(30);
	int bx = W - kf_w(40) - bw;
	int by = H - dh/2 - bh/2;

	Fl_Button *button = new Fl_Button(bx, by, bw, bh, "Close");
	button->callback(callback_Quit, this);
	darkish->add(button);


	heading = new Fl_Box(FL_NO_BOX, x()+pad, H - dh - kf_h(30), W-pad*2, kf_h(14), "Note: some options require a restart.");
	heading->align(FL_ALIGN_INSIDE);
	heading->labelsize(small_font_size);
	add(heading);
}


int UI_OptionsWin::handle(int event)
{
	if (event == FL_KEYDOWN || event == FL_SHORTCUT)
	{
		int key = Fl::event_key();

		switch (key)
		{
			case FL_Escape:
				want_quit = true;
				return 1;

			default:
				break;
		}

		// eat all other function keys
		if (FL_F+1 <= key && key <= FL_F+12)
			return 1;
	}

	return Fl_Window::handle(event);
}


void DLG_OptionsEditor(void)
{
	static UI_OptionsWin * option_window = NULL;

	if (! option_window)
	{
		int opt_w = kf_w(350);
		int opt_h = kf_h(380);

		option_window = new UI_OptionsWin(opt_w, opt_h, "OBLIGE Options");
	}

	option_window->want_quit = false;
	option_window->set_modal();
	option_window->show();

	// run the GUI until the user closes
	while (! option_window->WantQuit())
		Fl::wait();

	option_window->set_non_modal();
	option_window->hide();

	// save the options now
	Options_Save(options_file);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
