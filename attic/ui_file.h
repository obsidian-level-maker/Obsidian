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

#ifndef __UI_FILE_H__
#define __UI_FILE_H__

class UI_File : public Fl_Group
{
private:
	Fl_NameInput *filename;

	Fl_Box *ext;

	Fl_Output *dir_name;
	Fl_Button *browse;

	char *full_path;

public:
	UI_File(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_File();

public:
	void SetDefaultLocation();
	void AbbreviatePath();

	char *CopyFilename(const char *ext);
	// free the result using StringFree()

	void Locked(bool value);

	void resize(int X, int Y, int W, int H);

private:
	static void browse_callback(Fl_Widget *, void*);
};

#endif /* __UI_FILE_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
