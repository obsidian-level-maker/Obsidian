//----------------------------------------------------------------------
//  DIALOG when all fucked up
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"

#include "lib_util.h"
#include "lib_file.h"

#include "main.h"

#include <FL/fl_utf8.h>


const char *last_directory = NULL;


static int dialog_result;

static void dialog_close_CB(Fl_Widget *w, void *data)
{
	dialog_result = 1;
}

#define BTN_W  kf_w(100)
#define BTN_H  kf_h(30)

#define ICON_W  kf_w(40)
#define ICON_H  ICON_W

#define FONT_SIZE  (18 + KF * 2)


static void DialogShowAndRun(const char *message, const char *title,
                             const char *link_title, const char *link_url)
{
	dialog_result = 0;

	// determine required size
	int mesg_W = kf_w(480);  // NOTE: fl_measure will wrap to this!
	int mesg_H = 0;

	fl_font(FL_HELVETICA, FONT_SIZE);
	fl_measure(message, mesg_W, mesg_H);

	if (mesg_W < kf_w(200))
		mesg_W = kf_w(200);

	if (mesg_H < ICON_H)
		mesg_H = ICON_H;

	// add a little wiggle room
	mesg_W += kf_w(16);
	mesg_H += kf_h(8);

	int total_W = ICON_W + mesg_W + kf_w(30);
	int total_H = mesg_H + BTN_H  + kf_h(30);

	if (link_title)
		total_H += FONT_SIZE + kf_h(10);

	// create window...
	Fl_Window *dialog = new Fl_Window(0, 0, total_W, total_H, title);

	dialog->end();
	dialog->size_range(total_W, total_H, total_W, total_H);
	dialog->callback((Fl_Callback *) dialog_close_CB);

	// create the error icon...
	Fl_Box *icon = new Fl_Box(kf_w(10), kf_h(15), ICON_W, ICON_H, "!");

	icon->box(FL_OVAL_BOX);
	icon->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
	icon->color(FL_RED, FL_RED);
	icon->labelfont(FL_HELVETICA_BOLD);
	icon->labelsize(24 + KF * 3);
	icon->labelcolor(FL_WHITE);

	dialog->add(icon);

	// create the message area...
	Fl_Box *box = new Fl_Box(ICON_W + kf_w(20), kf_h(10), mesg_W, mesg_H, message);

	box->align(FL_ALIGN_LEFT | FL_ALIGN_TOP | FL_ALIGN_INSIDE | FL_ALIGN_WRAP);
	box->labelfont(FL_HELVETICA);
	box->labelsize(FONT_SIZE);

	dialog->add(box);

	// create the hyperlink...
	if (link_title)
	{
		SYS_ASSERT(link_url);

		UI_HyperLink *link = new UI_HyperLink(ICON_W + kf_w(20), kf_h(10) + mesg_H, mesg_W, 24,
				link_title, link_url);
		link->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT);
		link->labelfont(FL_HELVETICA);
		link->labelsize(FONT_SIZE);

		dialog->add(link);
	}

	// create button...
	Fl_Button *button =
		new Fl_Button(total_W - BTN_W - kf_w(20), total_H - BTN_H - kf_h(12),
				BTN_W, BTN_H, fl_close);

	button->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
	button->callback((Fl_Callback *) dialog_close_CB);
	//  button->labelsize(FONT_SIZE - 2);

	dialog->add(button);

	// show time!
	dialog->set_modal();
	dialog->show();

	fl_beep();

	// run the GUI and let user make their choice
	while (dialog_result == 0)
	{
		Fl::wait();
	}

	// delete window (automatically deletes child widgets)
	delete dialog;
}


static void ParseHyperLink(char *buffer, unsigned int buf_len,
                           const char ** link_title, const char ** link_url)
{
	// the syntax for a hyperlink is similar to HTML :-
	//    <a http://blah.blah.org/foobie.html>Title</a>

	char *pos = strstr(buffer, "<a ");

	if (! pos)
		return;

	// terminate the rest of the message here
	pos[0] = '\n';
	pos[1] = 0;

	pos += 3;

	*link_url = pos;

	pos = strstr(pos, ">");

	if (! pos)  // malformed : oh well
		return;

	// terminate the URL here
	pos[0] = 0;

	pos++;

	*link_title = pos;

	pos = strstr(pos, "<");

	if (pos)
		pos[0] = 0;
}


void DLG_ShowError(const char *msg, ...)
{
	static char buffer[MSG_BUF_LEN];

	va_list arg_pt;

	va_start (arg_pt, msg);
	vsnprintf (buffer, MSG_BUF_LEN-1, msg, arg_pt);
	va_end (arg_pt);

	buffer[MSG_BUF_LEN-2] = 0;

	LogPrintf("\n%s\n\n", buffer);

	const char *link_title = NULL;
	const char *link_url   = NULL;

	// handle error messages with a hyperlink at the end
	ParseHyperLink(buffer, sizeof(buffer), &link_title, &link_url);

	if (! batch_mode)
		DialogShowAndRun(buffer, _("OBLIGE - Error Message"), link_title, link_url);
}


//----------------------------------------------------------------------


const char * DLG_OutputFilename(const char *ext, const char *preset)
{
	char kind_buf[200];

	sprintf(kind_buf, "%s files\t*.%s", ext, ext);

	// uppercase the first word
	for (char *p = kind_buf ; *p && *p != ' ' ; p++)
		*p = toupper(*p);


	// save and restore the font height
	// (because FLTK's own browser get totally borked)
	int old_font_h = FL_NORMAL_SIZE;
	FL_NORMAL_SIZE = 14 + KF;


	Fl_Native_File_Chooser  chooser;

	chooser.title(_("Select output file"));
	chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);

	if (overwrite_warning)
		chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);

	chooser.filter(kind_buf);

	if (last_directory)
		chooser.directory(last_directory);

	if (preset)
		chooser.preset_file(preset);


	int result = chooser.show();

	FL_NORMAL_SIZE = old_font_h;

	switch (result)
	{
		case -1:
			LogPrintf("Error choosing output file:\n");
			LogPrintf("   %s\n", chooser.errmsg());

			DLG_ShowError(_("Unable to create the file:\n\n%s"), chooser.errmsg());
			return NULL;

		case 1:  // cancelled
			return NULL;

		default:
			break;  // OK
	}


	static char filename[FL_PATH_MAX + 16];

	const char *src_name = chooser.filename();

#ifdef WIN32
	// workaround for accented characters in a username
	// [ real solution is yet to be determined..... ]

	fl_utf8toa(src_name, strlen(src_name), filename, sizeof(filename));
#else
	snprintf(filename, sizeof(filename), "%s", src_name);
#endif

	// remember the directory for next time
	static char dir_name[FL_PATH_MAX];

	FilenameGetPath(dir_name, sizeof(dir_name), src_name);

	if (strlen(dir_name) > 0)
		last_directory = StringDup(dir_name);

	// add extension if missing
	char *pos = (char *)fl_filename_ext(filename);
	if (! *pos)
	{
		strcat(filename, ".");
		strcat(filename, ext);

		// check if exists, ask for confirmation
		FILE *fp = fopen(filename, "rb");
		if (fp)
		{
			fclose(fp);
			if (! fl_choice("%s", fl_cancel, fl_ok, NULL,
							Fl_Native_File_Chooser::file_exists_message))
				return NULL;  // cancelled
		}
	}

	return StringDup(filename);
}


//----------------------------------------------------------------------


void DLG_EditSeed(void)
{
	char num_buf[256];

	sprintf(num_buf, "%1.0f", next_rand_seed);

	const char * user_buf = fl_input(_("Enter New Seed Number:"), num_buf);

	// cancelled?
	if (! user_buf)
		return;

	// transfer to our own buffer
	strncpy(num_buf, user_buf, sizeof(num_buf));
	num_buf[sizeof(num_buf) - 1] = 0;

	// remove spaces
	int s, d;

	for (s = d = 0 ; num_buf[s] ; s++)
		if (! isspace(num_buf[s]))
			num_buf[d++] = num_buf[s];

	num_buf[d] = 0;

	// nothing entered?
	if (num_buf[0] == 0)
		return;

	// skip leading zeros
	for (s = 0 ; num_buf[s] == '0' && num_buf[s+1] ; s++)
	{ }

	next_rand_seed = atof(&num_buf[s]);

	// negative values are not valid
	if (next_rand_seed < 0)
		next_rand_seed = -next_rand_seed;

	// fractional part is not used
	next_rand_seed = floor(next_rand_seed);
}


//----------------------------------------------------------------------


class UI_LogViewer : public Fl_Double_Window
{
private:
	bool want_quit;

	Fl_Multi_Browser * browser;

	Fl_Button * copy_but;

public:
	UI_LogViewer(int W, int H, const char *l);
	virtual ~UI_LogViewer();

	bool WantQuit() const
	{
		return want_quit;
	}

	void Add(const char *line);

	// ensure the very last line is visible
	void JumpEnd();

	void ReadLogs();

	void WriteLogs(FILE *fp);

private:
	int CountSelectedLines() const;

	char * GetSelectedText() const;

	static void   quit_callback(Fl_Widget *, void *);
	static void   save_callback(Fl_Widget *, void *);
	static void select_callback(Fl_Widget *, void *);
	static void   copy_callback(Fl_Widget *, void *);
};


UI_LogViewer::UI_LogViewer(int W, int H, const char *l) :
	Fl_Double_Window(W, H, l),
	want_quit(false)
{
	box(FL_NO_BOX);

	size_range(W * 3 / 4, H * 3 / 4);

	callback(quit_callback, this);

	int ey = h() - kf_h(65);

	browser = new Fl_Multi_Browser(0, 0, w(), ey);
	browser->textfont(FL_COURIER);
	browser->textsize(small_font_size);
	browser->callback(select_callback, this);

	// disable the special '@' formatting
	// [ should be zero here, but in FLTK 1.3.4 it causes garbage to be
	//   displayed.  LogReadLines() ensures 0x7f chars are removed. ]
	browser->format_char(0x7f);

	resizable(browser);


	int button_w = kf_w(80);
	int button_h = kf_h(35);

	int button_y = ey + (kf_h(65) - button_h) / 2;

	{
		Fl_Group *o = new Fl_Group(0, ey, w(), h() - ey);
		o->box(FL_FLAT_BOX);

		o->color(FL_DARK3);

		int bx  = w() - button_w - kf_w(25);
		int bx2 = bx;
		{
			Fl_Button * but = new Fl_Button(bx, button_y, button_w, button_h, fl_close);
			but->labelfont(FL_HELVETICA_BOLD);
			but->callback(quit_callback, this);
		}

		bx = kf_w(25);
		{
			Fl_Button * but = new Fl_Button(bx, button_y, button_w, button_h, _("Save"));
			but->callback(save_callback, this);
		}

		bx += kf_w(140);
		{
			copy_but = new Fl_Button(bx, button_y, button_w, button_h, _("Copy"));
			copy_but->callback(copy_callback, this);
			copy_but->shortcut(FL_CTRL + 'c');
			copy_but->deactivate();
		}

		bx += button_w + 10;

		Fl_Group *resize_box = new Fl_Group(bx + 10, ey + 2, bx2 - bx - 20, h() - ey - 4);
		resize_box->box(FL_NO_BOX);

		o->resizable(resize_box);

		o->end();
	}

	end();
}


UI_LogViewer::~UI_LogViewer()
{ }


void UI_LogViewer::JumpEnd()
{
	if (browser->size() > 0)
	{
		browser->bottomline(browser->size());
	}
}


int UI_LogViewer::CountSelectedLines() const
{
	int count = 0;

	for (int i = 1 ; i <= browser->size() ; i++)
		if (browser->selected(i))
			count++;

	return count;
}


char * UI_LogViewer::GetSelectedText() const
{
	char *buf = StringDup("");

	for (int i = 1 ; i <= browser->size() ; i++)
	{
		if (! browser->selected(i))
			continue;

		const char *line_text = browser->text(i);
		if (! line_text)
			continue;

		// append current line onto previous ones

		int new_len = (int)strlen(buf) + (int)strlen(line_text);

		char *new_buf = StringNew(new_len + 1 /* newline */ );

		strcpy(new_buf, buf);
		strcat(new_buf, line_text);

		if (new_len > 0 && new_buf[new_len - 1] != '\n')
		{
			new_buf[new_len++] = '\n';
			new_buf[new_len]   = 0;
		}

		StringFree(buf);

		buf = new_buf;
	}

	return buf;
}


void UI_LogViewer::Add(const char *line)
{
	browser->add(line);
}


static void logviewer_display_func(const char *line, void *priv_data)
{
	UI_LogViewer *log_viewer = (UI_LogViewer *)priv_data;

	log_viewer->Add(line);
}


void UI_LogViewer::ReadLogs()
{
	LogReadLines(logviewer_display_func, (void *)this);
}


void UI_LogViewer::WriteLogs(FILE *fp)
{
	for (int n = 1 ; n <= browser->size() ; n++)
	{
		const char *str = browser->text(n);

		if (str)
			fprintf(fp, "%s\n", str);
	}
}


void UI_LogViewer::quit_callback(Fl_Widget *w, void *data)
{
	UI_LogViewer *that = (UI_LogViewer *)data;

	that->want_quit = true;
}


void UI_LogViewer::select_callback(Fl_Widget *w, void *data)
{
	UI_LogViewer *that = (UI_LogViewer *)data;

	// require 2 or more lines to activate Copy button
	if (that->CountSelectedLines() >= 2)
		that->copy_but->activate();
	else
		that->copy_but->deactivate();
}


void UI_LogViewer::copy_callback(Fl_Widget *w, void *data)
{
	UI_LogViewer *that = (UI_LogViewer *)data;

	const char *text = that->GetSelectedText();

	if (text[0])
	{
		Fl::copy(text, (int)strlen(text), 1);
	}

	StringFree(text);
}


void UI_LogViewer::save_callback(Fl_Widget *w, void *data)
{
	UI_LogViewer *that = (UI_LogViewer *)data;

	Fl_Native_File_Chooser chooser;

	chooser.title(_("Pick file to save to"));
	chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);
	chooser.filter("Text files\t*.txt");

	if (last_directory)
		chooser.directory(last_directory);

	switch (chooser.show())
	{
		case -1:
			DLG_ShowError(_("Unable to save the file:\n\n%s"), chooser.errmsg());
			return;

		case 1:
			// cancelled
			return;

		default:
			break;  // OK
	}


	// add an extension if missing
	static char filename[FL_PATH_MAX];

	strcpy(filename, chooser.filename());

	if (! HasExtension(filename))
		strcat(filename, ".txt");


	FILE *fp = fopen(filename, "w");

	if (! fp)
	{
		sprintf(filename, "%s", strerror(errno));

		DLG_ShowError(_("Unable to save the file:\n\n%s"), filename);
		return;
	}

	that->WriteLogs(fp);

	fclose(fp);
}


void DLG_ViewLogs(void)
{
	int log_w = kf_w(560);
	int log_h = kf_h(380);

	UI_LogViewer *log_viewer = new UI_LogViewer(log_w, log_h, _("OBLIGE Log Viewer"));

	log_viewer->ReadLogs();

	log_viewer->set_modal();
	log_viewer->show();

	// run the dialog until the user closes it
	while (! log_viewer->WantQuit())
		Fl::wait();

	delete log_viewer;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
