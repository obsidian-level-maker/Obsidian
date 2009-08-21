//------------------------------------------------------------------------
//
//  Visibility Viewer / Tester
//
//  Copyright (C) 2009 Andrew Apted
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


/*
 *  Standard C headers
 */
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>
#include <math.h>


/*
 *  Standard C++ headers
 */
#include <vector>


/*
 *  Fast Light Tool Kit
 */
#include <FL/Fl.H>
#include <FL/Fl_Box.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Check_Button.H>
#include <FL/Fl_Choice.H>
#include <FL/Fl_Double_Window.H>
#include <FL/Fl_Group.H>
#include <FL/Fl_Output.H>
#include <FL/Fl_Menu_Bar.H>
#include <FL/Fl_Menu_Item.H>
#include <FL/Fl_Pack.H>
#include <FL/Fl_Widget.H>
#include <FL/Fl_Window.H>

#include <FL/fl_ask.H>
#include <FL/fl_draw.H>


/*
 *  Local Stuff
 */
#include "../gui/sys_type.h"
#include "../gui/sys_macro.h"

void FatalError(const char *msg, ...);

#include "vis_buf.cc"


class UI_Canvas : public Fl_Widget
{
private:
	Editor_State_c *e;

	bool render3d;

	Objid highlight;

	bool selbox_active;
	int  selbox_x1, selbox_y1;  // map coords
	int  selbox_x2, selbox_y2;

	// drawing state only
	int map_lx, map_ly;
	int map_hx, map_hy;

public:
	UI_Canvas(int X, int Y, int W, int H, const char *label = NULL);
	virtual ~UI_Canvas();

public:
	// FLTK virtual method for handling input events.
	int handle(int event);

	// FLTK virtual method for resizing.
	void resize(int X, int Y, int W, int H);

	void set_edit_info(Editor_State_c *new_e) { e = new_e; redraw(); }

	void DrawEverything();

	void DrawMap();

	void DrawMapPoint (int mapx, int mapy);
	void DrawMapLine (int mapx1, int mapy1, int mapx2, int mapy2);
	void DrawMapVector (int mapx1, int mapy1, int mapx2, int mapy2);
	void DrawMapArrow (int mapx1, int mapy1, unsigned angle);

	void HighlightSet(Objid& obj);
	void HighlightForget();

	void HighlightObject(int objtype, int objnum, Fl_Color colour);

	void HighlightSelection(selection_c *list);

	void SelboxBegin(int mapx, int mapy);
	void SelboxDrag(int mapx, int mapy);
	void SelboxFinish(int *x1, int *y1, int *x2, int *y2);

private:
	// FLTK virtual method for drawing.
	void draw();

	void DrawGrid();
	void DrawVertices();
	void DrawLinedefs();
	void DrawThings();
	void DrawRTS();
	void DrawObjNum(int x, int y, int obj_no, Fl_Color c);

	void SelboxDraw();

	// convert screen coordinates to map coordinates
	inline int MAPX(int sx) const { return (grid.orig_x + I_ROUND((sx - w()/2 - x()) / grid.Scale)); }
	inline int MAPY(int sy) const { return (grid.orig_y + I_ROUND((h()/2 - sy + y()) / grid.Scale)); }

	// convert map coordinates to screen coordinates
	inline int SCREENX(int mx) const { return (x() + w()/2 + I_ROUND((mx - grid.orig_x) * grid.Scale)); }
	inline int SCREENY(int my) const { return (y() + h()/2 + I_ROUND((grid.orig_y - my) * grid.Scale)); }

	inline bool Vis(int x, int y, int r) const
	{
		return (x+r >= map_lx) && (x-r <= map_hx) &&
		       (y+r >= map_ly) && (y-r <= map_hy);
	}
	inline bool Vis(int x1, int y1, int x2, int y2) const
	{
		return (x2 >= map_lx) && (x1 <= map_hx) &&
		       (y2 >= map_ly) && (y1 <= map_hy);
	}
};


UI_Canvas::UI_Canvas(int X, int Y, int W, int H, const char *label) : 
    Fl_Widget(X, Y, W, H, label),
    e(NULL), render3d(false),
	highlight(), selbox_active(false)
{ }

UI_Canvas::~UI_Canvas()
{ }


void UI_Canvas::resize(int X, int Y, int W, int H)
{
	Fl_Widget::resize(X, Y, W, H);
}


void UI_Canvas::draw()
{
	fl_push_clip(x(), y(), w(), h());

	fl_color(FL_WHITE);
	fl_font(FL_COURIER, 14);

	if (render3d)
		Render3D_Draw(x(), y());
	else if (e)
		DrawEverything();

	fl_pop_clip();
}


int UI_Canvas::handle(int event)
{
	//// fprintf(stderr, "HANDLE EVENT %d\n", event);

	switch (event)
	{
		case FL_FOCUS:
			return 1;

		case FL_KEYDOWN:
		case FL_SHORTCUT:
		{
			//      int result = handle_key();
			//      handle_mouse();

			int key   = Fl::event_key();
			int state = Fl::event_state();

			switch (key)
			{
				case FL_Num_Lock:
				case FL_Caps_Lock:

				case FL_Shift_L: case FL_Control_L:
				case FL_Shift_R: case FL_Control_R:
				case FL_Meta_L:  case FL_Alt_L:
				case FL_Meta_R:  case FL_Alt_R:

					/* IGNORE */
					return 1;

				default:
					/* OK */
					break;
			}

			if (key == FL_Tab || key == '\t')
			{
				render3d = !render3d;
				redraw();
				return 1;
			}

			if (key != 0)
			{
				if (key < 127 && isalpha(key) && (state & FL_SHIFT))
					key = toupper(key);

				if (render3d)
				{
					if (Render3D_Key(key))
						redraw();
				}
				else
					EditorKey(key, (state & FL_SHIFT) ? true : false);
			}

			return 1; // result;
		}

		case FL_ENTER:
			// we greedily grab the focus
			if (Fl::focus() != this)
				take_focus(); 

			return 1;

		case FL_LEAVE:
			//      hilite_rad = NULL;
			//      hilite_thing = NULL;
			//      dragging = false;
			//      determine_cursor();
			//      update_active_obj();
			redraw();
			return 1;

		case FL_MOVE:
		case FL_DRAG:
			EditorMouseMotion(Fl::event_x(), Fl::event_y(),
					MAPX(Fl::event_x()), MAPY(Fl::event_y()), event == FL_DRAG);
			return 1;

		case FL_PUSH:
			{
				int state = Fl::event_state();
				EditorMousePress((state & FL_CTRL) ? true : false);
			}
			return 1;

		case FL_RELEASE:
			EditorMouseRelease();
			return 1;

		case FL_MOUSEWHEEL:
			EditorWheel(0 - Fl::event_dy());
			return 1;

		default:
			break;
	}

	return 0;  // unused
}


//------------------------------------------------------------------------


void UI_Canvas::DrawEverything()
{
	map_lx = MAPX(x());
	map_ly = MAPY(y()+h());
	map_hx = MAPX(x()+w());
	map_hy = MAPY(y());

	DrawMap(); 

	HighlightSelection(edit.Selected); // FIXME should be widgetized

	if (highlight())
		HighlightObject(highlight.type, highlight.num, YELLOW);

	if (selbox_active)
		SelboxDraw();
}


/*
  draw the actual game map
*/
void UI_Canvas::DrawMap()
{
	fl_color(FL_BLACK);
	fl_rectf(x(), y(), w(), h());

	// draw the grid first since it's in the background
	if (grid.shown)
		DrawGrid();

	if (e->obj_type != OBJ_THINGS)
		DrawThings();

	DrawLinedefs();

	if (e->obj_type == OBJ_VERTICES)
		DrawVertices();

	if (e->obj_type == OBJ_THINGS)
		DrawThings();

	if (e->obj_type == OBJ_RADTRIGS)
		DrawRTS();


	int n;

	// Draw the things numbers
	if (e->obj_type == OBJ_THINGS && e->show_object_numbers)
	{
		for (n = 0; n < NumThings; n++)
		{
			int x = Things[n]->x;
			int y = Things[n]->y;

			if (Vis(x, y, MAX_RADIUS))
				DrawObjNum(SCREENX(x) + FONTW, SCREENY(y) + 2, n, THING_NO);
		}
	}

	// Draw the sector numbers
	if (e->obj_type == OBJ_SECTORS && e->show_object_numbers)
	{
		int xoffset = - FONTW / 2;

		for (n = 0; n < NumSectors; n++)
		{
			int x;
			int y;

			centre_of_sector(n, &x, &y);

			if (Vis(x, y, MAX_RADIUS))
				DrawObjNum(SCREENX(x) + xoffset, SCREENY(y) - FONTH / 2, n, SECTOR_NO);

			if (n == 10 || n == 100 || n == 1000 || n == 10000)
				xoffset -= FONTW / 2;
		}
	}
}



/*
 *  draw_grid - draw the grid in the background of the edit window
 */
void UI_Canvas::DrawGrid()
{
	int grid_step_1 = 1 * grid.step;    // Map units between dots
	int grid_step_2 = 8 * grid_step_1;  // Map units between dim lines
	int grid_step_3 = 8 * grid_step_2;  // Map units between bright lines

	float pixels_1 = grid.step * grid.Scale;


	if (pixels_1 < 1.99)
	{
		fl_color(GRID_DARK);
		fl_rectf(x(), y(), w(), h());
		return;
	}


	fl_color (GRID_BRIGHT);
	{
		int gx = (map_lx / grid_step_3) * grid_step_3;

		for (; gx <= map_hx; gx += grid_step_3)
			DrawMapLine(gx, map_ly-2, gx, map_hy+2);

		int gy = (map_ly / grid_step_3) * grid_step_3;

		for (; gy <=  map_hy; gy += grid_step_3)
			DrawMapLine(map_lx, gy, map_hx, gy);
	}


	fl_color (GRID_MEDIUM);
	{
		int gx = (map_lx / grid_step_2) * grid_step_2;

		for (; gx <= map_hx; gx += grid_step_2)
			if (gx % grid_step_3 != 0)
				DrawMapLine(gx, map_ly, gx, map_hy);

		int gy = (map_ly / grid_step_2) * grid_step_2;

		for (; gy <= map_hy; gy += grid_step_2)
			if (gy % grid_step_3 != 0)
				DrawMapLine(map_lx, gy, map_hx, gy);
	}


	// POINTS

	if (pixels_1 < 3.99)
		fl_color(GRID_MEDIUM);
	//??  else if (pixels_1 > 30.88)
	//??    fl_color(GRID_BRIGHT);
	else
		fl_color(GRID_POINT);

	{
		int gx = (map_lx / grid_step_1) * grid_step_1;
		int gy = (map_ly / grid_step_1) * grid_step_1;

		for (int ny = gy; ny <= map_hy; ny += grid_step_1)
		for (int nx = gx; nx <= map_hx; nx += grid_step_1)
		{
			int sx = SCREENX(nx);
			int sy = SCREENY(ny);

			if (pixels_1 < 30.99)
				fl_point(sx, sy);
			else
			{
				fl_line(sx-0, sy, sx+1, sy);
				fl_line(sx, sy-0, sx, sy+1);
			}
		}
	}
}


//--------------------------------------------------------------------


UI_MainWin *main_win;

#define MAIN_WINDOW_W  (800-32+KF*60)
#define MAIN_WINDOW_H  (600-98+KF*40)

#define MAX_WINDOW_W  MAIN_WINDOW_W
#define MAX_WINDOW_H  MAIN_WINDOW_H


class UI_MainWin : public Fl_Double_Window
{
public:
  // main child widgets

#ifdef MACOSX
	Fl_Sys_Menu_Bar *menu_bar;
#else
	Fl_Menu_Bar *menu_bar;
#endif

	UI_Canvas *canvas;

	UI_FlatTexList *tex_list;

	UI_InfoBar *info_bar;

	UI_ThingBox  *thing_box;
	UI_LineBox   *line_box;
	UI_SectorBox *sec_box;
	UI_VertexBox *vert_box;
	UI_RadiusBox *rad_box;

	enum  // actions
	{
		NONE = 0,
		BUILD,
		ABORT,
		QUIT
	};
	
	int action;

private:
	Fl_Cursor cursor_shape;

public:
	UI_MainWin(const char *title);
	virtual ~UI_MainWin();

public:
	// mode can be 't', 'l', 's', 'v' or 'r'.   FIXME: ENUMERATE
	void SetMode(char mode);

	// this is a wrapper around the FLTK cursor() method which
	// prevents the possibly expensive call when the shape hasn't
	// changed.
	void SetCursor(Fl_Cursor shape);
};


static void main_win_close_CB(Fl_Widget *w, void *data)
{
	if (main_win)
		main_win->action = UI_MainWin::QUIT;
}


//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(const char *title) :
    Fl_Double_Window(MAIN_WINDOW_W, MAIN_WINDOW_H, title),
    action(UI_MainWin::NONE),
    cursor_shape(FL_CURSOR_DEFAULT)
{
	end(); // cancel begin() in Fl_Group constructor

	size_range(MAIN_WINDOW_W, MAIN_WINDOW_H);

	callback((Fl_Callback *) main_win_close_CB);

	color(WINDOW_BG, WINDOW_BG);

	int cy = 0;
	int ey = h();

	int panel_W   = 260 + KF * 32;
	int flattex_W = 180 + KF * 20;

	/* ---- Menu bar ---- */
	{
		menu_bar = Menu_Create(0, 0, w() - panel_W, 28+KF*3);
		add(menu_bar);

#ifndef MACOSX
		cy += menu_bar->h();
#endif
	}


	info_bar = new UI_InfoBar(0, ey - (28+KF*3), w(), 28+KF*3);
	add(info_bar);

	ey = ey - info_bar->h();



	tex_list = new UI_FlatTexList(w() - panel_W - flattex_W, cy, flattex_W, ey - cy);
	add(tex_list);


	canvas = new UI_Canvas(0, cy, w() - flattex_W - panel_W, ey - cy);
	add(canvas);

	resizable(canvas);


	int BY = 0;     // cy+2
	int BH = ey-2;  // ey-BY-2

	thing_box = new UI_ThingBox(w() - panel_W, BY, panel_W, BH);
	add(thing_box);

	line_box = new UI_LineBox(w() - panel_W, BY, panel_W, BH);
	line_box->hide();
	add(line_box);

	sec_box = new UI_SectorBox(w() - panel_W, BY, panel_W, BH);
	sec_box->hide();
	add(sec_box);

	vert_box = new UI_VertexBox(w() - panel_W, BY, panel_W, BH);
	vert_box->hide();
	add(vert_box);

	rad_box = new UI_RadiusBox(w() - panel_W, BY, panel_W, BH);
	rad_box->hide();
	add(rad_box);

}

//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{ }


void UI_MainWin::SetMode(char mode)
{
	// TODO: if mode == cur_mode then return end

	thing_box->hide();
	line_box->hide();
	sec_box->hide();
	vert_box->hide();
	rad_box->hide();

	switch (mode)
	{
		case 't': thing_box->show(); break;
		case 'l':  line_box->show(); break;
		case 's':   sec_box->show(); break;
		case 'v':  vert_box->show(); break;
		case 'r':   rad_box->show(); break;

		default: break;
	}

	info_bar->SetMode(mode);

	redraw();
}


void UI_MainWin::SetCursor(Fl_Cursor shape)
{
	if (shape == cursor_shape)
		return;

	cursor_shape = shape;

	cursor(shape);
}


//--------------------------------------------------------------------


void FatalError(const char *msg, ...)
{
  static char buffer[MSG_BUF_LEN];

  va_list arg_pt;

  va_start(arg_pt, msg);
  vsnprintf(buffer, MSG_BUF_LEN-1, msg, arg_pt);
  va_end(arg_pt);

  buffer[MSG_BUF_LEN-2] = 0;

  DLG_ShowError("%s", buffer);

  Main_Shutdown(true);

  exit(9);
}

int main(int argc, char **argv)
{
  // initialise argument parser (skipping program name)
  ArgvInit(argc-1, (const char **)(argv+1));

  if (ArgvFind('?', NULL) >= 0 || ArgvFind('h', "help") >= 0)
  {
    ShowInfo();
    exit(1);
  }

  if (1)
  {
    Fl::background(236, 232, 228);
    Fl::background2(255, 255, 255);
    Fl::foreground(0, 0, 0);
  }

  if (1)
    Fl::scheme("plastic");

  fl_message_font(FL_HELVETICA /* _BOLD */, 18);

  Determine_WorkingPath(argv[0]);
  Determine_InstallPath(argv[0]);

  FileChangeDir(working_path);

  LogInit(LOG_FILENAME);

  if (ArgvFind('d', "debug") >= 0)
    LogEnableDebug();

  if (ArgvFind('t', "terminal") >= 0)
    LogEnableTerminal();

  LogPrintf(OBLIGE_TITLE " " OBLIGE_VERSION " (C) 2006-2009 Andrew Apted\n\n");

  LogPrintf("working_path: [%s]\n",   working_path);
  LogPrintf("install_path: [%s]\n\n", install_path);

  // create directory for temporary files
  FileMakeDir("temp");

  // load icons for file chooser
#ifndef WIN32
  Fl_File_Icon::load_system_icons();
#endif

  Script_Init();

  Default_Location();

  main_win = new UI_MainWin(OBLIGE_TITLE);

  // show window (pass some dummy arguments)
  {
    int argc = 1;
    char *argv[] = { "Oblige.exe", NULL };

    main_win->show(argc, argv);
  }

  // kill the stupid bright background of the "plastic" scheme
  delete Fl::scheme_bg_;
  Fl::scheme_bg_ = NULL;

  main_win->image(NULL);

  Fl::add_handler(escape_key_handler);

  // draw an empty map (must be done after main window is
  // shown() because that is when FLTK finalises the colors).
  main_win->build_box->mini_map->EmptyMap();

  Script_Load();

  main_win->game_box ->Defaults();
  main_win->level_box->Defaults();
  main_win->play_box ->Defaults();

  // load config after creating window (will set widget values)
  Cookie_Load(CONFIG_FILENAME);

  // handle -seed option
  {
    int num_par = 0;
    int index = ArgvFind('s', "seed", &num_par);

    if (index >= 0 && num_par > 0)
    {
      main_win->game_box->SetSeed(atoi(arg_list[index+1]));
    }
  }
 

  try
  {
    // run the GUI until the user quits
    for (;;)
    {
      Fl::wait(0.2f);

      if (main_win->action == UI_MainWin::QUIT)
        break;

      if (main_win->action == UI_MainWin::BUILD)
      {
        main_win->action = UI_MainWin::NONE;

        // save config in case everything blows up
        Cookie_Save(CONFIG_FILENAME);

        Build_Cool_Shit();
      }
    }
  }
  catch (assert_fail_c err)
  {
    Main_FatalError("Sorry, an internal error occurred:\n%s", err.GetMessage());
  }
  catch (...)
  {
    Main_FatalError("An unknown problem occurred (UI code)");
  }

  Main_Shutdown(false);

  return 0;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
