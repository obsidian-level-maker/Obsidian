//------------------------------------------------------------------------
//  Build screen
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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
#include "lib_util.h"

#include "main.h"
#include "ui_build.h"
#include "ui_window.h"


#define PROGRESS_BG  fl_gray_ramp(FL_NUM_GRAY * 16 / 24)
#define PROGRESS_FG  fl_color_cube(3,3,0)
#define GLBSP_FG     fl_color_cube(1,4,2)

#define ABORT_COLOR  fl_color_cube(3,1,1)

#define MAP_BG       fl_gray_ramp(FL_NUM_GRAY * 2 / 24)


UI_Build::UI_Build(int x, int y, int w, int h, const char *label) :
    Fl_Group(x, y, w, h, label),
	map(NULL)
{
	end(); // cancel begin() in Fl_Group constructor
 
	box(FL_FLAT_BOX);
	color(MAIN_BG_COLOR, MAIN_BG_COLOR);


	int cy = y + 4;

	Fl_Box *sizer = new Fl_Box(FL_NO_BOX, x+12 , cy, x+120, 8, NULL);
	sizer->color(FL_RED, FL_RED);

	add(sizer);


	cy = y + h - 70;

	progress = new Fl_Progress(x+12, cy+8, 136, 20);
	progress->align(FL_ALIGN_INSIDE);
	progress->box(FL_FLAT_BOX);
	progress->color(PROGRESS_BG, PROGRESS_FG);
	progress->value(50);

	add(progress);

	progress->hide();


	cy = y + h - 40;

	status = new Fl_Box(FL_FLAT_BOX, x+12, cy, 136, 24, "Ready to go!");
	status->align(FL_ALIGN_INSIDE | FL_ALIGN_BOTTOM_LEFT);
	status->color(MAIN_BG_COLOR, MAIN_BG_COLOR);
	add(status);


	quit = new Fl_Button(x+w - 82, cy, 70, 30, "Quit");
	quit->callback(quit_callback, this);

	add(quit);

	build = new Fl_Button(x+w - 170, cy, 76, 30, "Build...");
	build->labelfont(FL_HELVETICA_BOLD);
	build->callback(build_callback, this);

	add(build);

	map_box = new Fl_Box(x+w - 308, y + h - 94, 120, 90);
//	map_box->color(MAP_BG, MAP_BG);

	add(map_box);

	
	resizable(sizer);
}


UI_Build::~UI_Build()
{
}

void UI_Build::P_Begin(float limit, int pass)
{
  prog_pass  = pass;
  prog_limit = limit;

	progress->minimum(0.0);
	progress->maximum(100.0);

	progress->value((pass == 1) ? 0.0 : 75.0);

	progress->color(PROGRESS_BG, (pass==1) ? PROGRESS_FG : GLBSP_FG);
	progress->show();
}

void UI_Build::P_Update(float val)
{
	if (val < 0) val = 0;
	if (val > prog_limit) val = prog_limit;

  if (prog_pass == 1)
    val = val * 75.0 / prog_limit;
  else
    val = 75.0 + (val * 25.0 / prog_limit);

	sprintf(prog_msg, "%d%%", int(val));

	progress->value(val);
	progress->label(prog_msg);

	Main_Ticker();
}

void UI_Build::P_Finish()
{
	progress->hide();
}

void UI_Build::P_Status(const char *msg)
{
	status->label(msg);
}

void UI_Build::P_SetButton(bool abort)
{
	if (abort)
	{
		build->callback(stop_callback, this);
		build->label("Abort");
		build->labelcolor(ABORT_COLOR);
	}
	else
	{
		build->label("Build...");
		build->labelcolor(FL_FOREGROUND_COLOR);
		build->callback(build_callback, this);
	}
}

//----------------------------------------------------------------

void UI_Build::Locked(bool value)
{
	if (value)
	{
		quit->deactivate();
	}
	else
	{
		quit->activate();
	}
}

void UI_Build::MapBegin(int pixel_W, int pixel_H)
{
	map_W = pixel_W;
	map_H = pixel_H;

	map_start = new u8_t[map_W * map_H * 3];
	map_pos   = map_start;
	map_end   = map_start + (map_W * map_H * 3);

	// clear map
	u8_t r, g, b;

	Fl::get_color(MAP_BG, r, g, b);

	for (u8_t *pos = map_start; pos < map_end; )
	{
		*pos++ = r;
		*pos++ = g;
		*pos++ = b;
	}
}

void UI_Build::MapPixel(int kind)
{
	SYS_ASSERT(0 <= kind && kind <= 4);

	static u8_t colors[5*3] =
	{
		0,0,0,  224,216,208,  192,96,96,  96,96,192,  0,224,96
	};

	SYS_ASSERT(map_pos < map_end);

	if (kind == 0)
	{
		map_pos += 3;
		return;
	}

	*map_pos++ = colors[kind*3 + 0];
	*map_pos++ = colors[kind*3 + 1];
	*map_pos++ = colors[kind*3 + 2];
}

void UI_Build::MapFinish()
{
	MapCorner(0, 0);
	MapCorner(0, map_H-1);
	MapCorner(map_W-1, 0);
	MapCorner(map_W-1, map_H-1);

	if (map) { map_box->image(NULL); delete map; }

	map = new Fl_RGB_Image(map_start, map_W, map_H);

	map_box->image(map);
	map_box->redraw();
}

void UI_Build::MapCorner(int x, int y)
{
	u8_t *pos = map_start + (y*map_W+x)*3;

	Fl::get_color(MAIN_BG_COLOR, pos[0], pos[1], pos[2]);
}

//----------------------------------------------------------------
	
void UI_Build::build_callback(Fl_Widget *w, void *data)
{
	if (main_win->action == UI_MainWin::NONE)
	{
		main_win->action = UI_MainWin::BUILD;
	}
}

void UI_Build::stop_callback(Fl_Widget *w, void *data)
{
	if (main_win->action != UI_MainWin::QUIT)
	{
		main_win->action = UI_MainWin::ABORT;
	}
}

void UI_Build::quit_callback(Fl_Widget *w, void *data)
{
	main_win->action = UI_MainWin::QUIT;
}
