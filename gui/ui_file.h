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

#ifndef __UI_FILE_H__
#define __UI_FILE_H__

class UI_File : public Fl_Group
{
private:
	Fl_Input *filename;
	Fl_Box   *ext;

	Fl_Input *dir_name;
	Fl_Button *browse;

public:
	UI_File(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_File();

public:
	void InitialFocus();

	void Locked(bool value);

private:
	static void browse_callback(Fl_Widget *, void*);
};

#endif /* __UI_FILE_H__ */
