//----------------------------------------------------------------------
//  DIALOG when all fucked up
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

#include "lib_util.h"

#include "main.h"


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
				BTN_W, BTN_H, "Close");

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
		DialogShowAndRun(buffer, "OBLIGE - Error Message", link_title, link_url);
}


//----------------------------------------------------------------------


const char * DLG_OutputFilename(const char *ext)
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

	chooser.title("Select output file");
	chooser.type(Fl_Native_File_Chooser::BROWSE_SAVE_FILE);
	chooser.options(Fl_Native_File_Chooser::SAVEAS_CONFIRM);
	chooser.filter(kind_buf);

	// TODO: chooser.directory(LAST_USED_DIRECTORY)


	int result = chooser.show();

	FL_NORMAL_SIZE = old_font_h;

	switch (result)
	{
		case -1:
			LogPrintf("Error choosing output file:\n");
			LogPrintf("   %s\n", chooser.errmsg());

			DLG_ShowError("Unable to select the file:\n\n%s", chooser.errmsg());
			return NULL;

		case 1:  // cancelled
			return NULL;

		default:
			break;  // OK
	}


	static char filename[FL_PATH_MAX + 16];

	strcpy(filename, chooser.filename());

	// add extension is missing
	char *pos = (char *)fl_filename_ext(filename);
	if (! *pos)
	{
		strcat(filename, ".");
		strcat(filename, ext);

		// check if exists, ask for confirmation
		FILE *fp = fl_fopen(filename, "rb");
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

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
