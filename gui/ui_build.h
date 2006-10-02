//------------------------------------------------------------------------
//  Build screen
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

#ifndef __UI_BUILD_H__
#define __UI_BUILD_H__

class UI_Build : public Fl_Group
{
private:
	Fl_Box *status;
	Fl_Progress *progress;

	char prog_msg[20];
  int  prog_pass;    // 1 or 2
  float prog_limit;

	Fl_Button *build;
	Fl_Button *stop;
	Fl_Button *quit;

	Fl_Box *map_box;
	Fl_RGB_Image *map;

	int map_W, map_H;

	u8_t *map_start;
	u8_t *map_pos;
	u8_t *map_end;

public:
	UI_Build(int x, int y, int w, int h, const char *label = NULL);
	virtual ~UI_Build();

public:
	void P_Begin(float limit, int pass);
	void P_Update(float val);
	void P_Finish();
	void P_Status(const char *msg);
	void P_SetButton(bool abort);

	void Locked(bool value);

	void MapBegin(int pixel_W, int pixel_H);
	void MapPixel(int kind);
	void MapFinish();

	void MapCorner(int x, int y);

private:
	static void build_callback(Fl_Widget *, void*);
	static void stop_callback(Fl_Widget *, void*);
	static void quit_callback(Fl_Widget *, void*);
};

#endif /* __UI_BUILD_H__ */
