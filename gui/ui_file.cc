//------------------------------------------------------------------------
//  File screen
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006 Andrew Apted
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

#include "ui_setup.h"
#include "ui_window.h"

#include "lib_util.h"

//
// File Constructor
//
UI_File::UI_File(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label)
{
	end(); // cancel begin() in Fl_Group constructor
 
	box(FL_THIN_UP_BOX);
//	align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);
//	labeltype(FL_NORMAL_LABEL);
//	labelfont(FL_HELVETICA_BOLD);

	int cy = y + 9;

	Fl_Box *heading = new Fl_Box(FL_FLAT_BOX, x+6, cy, 160, 24, "Output");
	heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
	heading->labeltype(FL_NORMAL_LABEL);
	heading->labelfont(FL_HELVETICA_BOLD);

	add(heading);

	cy += 28;

	filename = new Fl_Input(x+92, cy, 120, 24, "Filename: ");
	filename->align(FL_ALIGN_LEFT);
	filename->value("TEST");

	add(filename);

	ext = new Fl_Box(FL_FLAT_BOX, filename->x() + filename->w() + 16, cy, 80, 24, "Type: WAD");

	add(ext);

	cy += 32;


	dir_name = new Fl_Input(x+92, cy, 260, 24, "Location:  ");
	dir_name->align(FL_ALIGN_LEFT);
	// value

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
{
}

void UI_File::InitialFocus()
{
	// FIXME ???? filename->take_focus();
}

void UI_File::browse_callback(Fl_Widget *w, void *data)
{
	UI_File *that = (UI_File *)data;

	// FIXME: browse button
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
