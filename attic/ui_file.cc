//------------------------------------------------------------------------
//  File screen
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

//
// File Constructor
//
UI_File::UI_File(int x, int y, int w, int h, const char *label) :
	Fl_Group(x, y, w, h, label),
	full_path(NULL)
{
	end(); // cancel begin() in Fl_Group constructor

	box(FL_THIN_UP_BOX);
	//  align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);
	//  labeltype(FL_NORMAL_LABEL);
	//  labelfont(FL_HELVETICA_BOLD);

	int cy = y + 9;

	Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, 160, 24, "Output");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);

	add(heading);

	cy += 28;

	filename = new Fl_NameInput(x+92, cy, 120, 24, "Filename: ");
	filename->align(FL_ALIGN_LEFT);
	filename->value("TEST");

	add(filename);

	ext = new Fl_Box(FL_FLAT_BOX, filename->x() + filename->w() + 16, cy, 80, 24, "Type: WAD");

	add(ext);

	cy += 32;


	dir_name = new Fl_Output(x+92, cy, 260, 24, "Location:  ");
	dir_name->align(FL_ALIGN_LEFT);

	add(dir_name);


	browse = new Fl_Button(dir_name->x() + dir_name->w() + 16, cy, 70, 24, "Browse...");
	browse->callback(browse_callback, this);

	add(browse);

	resizable(dir_name);
}


//
// File Destructor
//
UI_File::~UI_File()
{ }


void UI_File::SetDefaultLocation()
{
	if (! full_path)
	{
		full_path = new char[FL_PATH_MAX + 4];
	}

#if 1 // ifdef WIN32
	fl_filename_absolute(full_path, ".");
#else
	fl_filename_expand(full_path, "$HOME");
#endif

	// ensure full_path ends with DIR_SEP
	int len = strlen(full_path);

	if (len > 0 && full_path[len-1] != DIR_SEP_CH)
	{
		full_path[len] = DIR_SEP_CH;
		full_path[len+1] = 0;
	}

	AbbreviatePath();
}


void UI_File::AbbreviatePath()
{
	// set correct font for fl_width()
	fl_font(dir_name->textfont(), dir_name->textsize());

	int want_w = dir_name->w() - 10;
	int orig_w = (int)fl_width(full_path);

	if (orig_w <= want_w)
	{
		dir_name->value(full_path);
		return;
	}

	char *abbr = new char[FL_PATH_MAX+10];

	int total = strlen(full_path);
	int half = MAX(1, total / 2 - 2);

	float char_w = orig_w / float(total);  // average char width

	while (half > 1)
	{
		memcpy(abbr, full_path, half);

		abbr[half+0] = '.';
		abbr[half+1] = '.';
		abbr[half+2] = '.';

		memcpy(abbr+half+3, full_path+total-half, half+1);

		int new_w = (int)fl_width(abbr);

		if (new_w <= want_w)
			break;

		// compute number of characters to drop, with 1.5 penalty
		// to prevent over-shooting the mark.
		int cut = int( (new_w - want_w) / char_w / 3.0 );

		half -= MAX(1, cut);
	}

	dir_name->value(abbr);

	delete[] abbr;
}


char *UI_File::CopyFilename(const char *ext)
{
	const char *name = filename->value();

	int len = strlen(name);

	if (len == 0)
		return NULL;  // error!

	char *result = StringNew(strlen(full_path) + len + strlen(ext) + 4);

	strcpy(result, full_path);
	strcat(result, name);
	strcat(result, ext);

	return result;
}


void UI_File::resize(int X, int Y, int W, int H)
{
	bool change_W = (W != w());

	Fl_Group::resize(X, Y, W, H);

	if (change_W)
		AbbreviatePath();
}


void UI_File::Locked(bool value)
{
	if (value)
	{
		filename->deactivate();
		dir_name->deactivate();
		browse->deactivate();
	}
	else
	{
		filename->activate();
		dir_name->activate();
		browse->activate();
	}
}


void UI_File::browse_callback(Fl_Widget *w, void *data)
{
	UI_File *that = (UI_File *)data;

	char *new_dir = fl_dir_chooser("Oblige: Select output folder", that->full_path);

	if (new_dir)
	{
		strncpy(that->full_path, new_dir, FL_PATH_MAX);
		that->full_path[FL_PATH_MAX-1] = 0;

		that->AbbreviatePath();
	}
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
