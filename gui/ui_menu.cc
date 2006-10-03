//------------------------------------------------------------------------
//  Menus
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

#include "ui_menu.h"
#include "ui_window.h"
#include "main.h"


static bool menu_want_to_quit;


static void menu_quit_CB(Fl_Widget *w, void *data)
{
  menu_want_to_quit = true;
}

#ifndef MACOSX
static void menu_do_exit(Fl_Widget *w, void * data)
{
  main_win->action = UI_MainWin::QUIT;
}
#endif


//------------------------------------------------------------------------

static const char *about_Info =
  "By Andrew Apted (C) 2006\n"
  "\n"
  "This program is free software, under the terms of\n"
  "the GNU General Public License.  It comes with\n"
  "ABSOLUTELY NO WARRANTY.\n"
  "\n";


static void menu_do_about(Fl_Widget *w, void * data)
{
	menu_want_to_quit = false;

	Fl_Window *about = new Fl_Window(340, 366, "About Oblige");
	about->end();

	// non-resizable
	about->size_range(about->w(), about->h(), about->w(), about->h());
	about->callback((Fl_Callback *) menu_quit_CB);

#if 0
	// add the about image
	Fl_Group *group = new Fl_Group(0, 0, 230, about->h());
	group->end();
	group->box(FL_FLAT_BOX);
	group->color(FL_BLACK, FL_BLACK);
	about->add(group);

	Fl_Box *box = new Fl_Box(20, 90, ABOUT_IMG_W+2, ABOUT_IMG_H+2);
	box->image(about_image);
	group->add(box); 
#endif

	// nice big logo text
	Fl_Box *box1 = new Fl_Box(0, 0, about->w(), 80, "Oblige Level Maker " OBLIGE_VERSION);
  box1->labelcolor(FL_BLUE);
	box1->labelsize(24);
//  box1->box(FL_FLAT_BOX);
//  box1->color(FL_BACKGROUND_COLOR, FL_BACKGROUND_COLOR);
	about->add(box1);

	// about text
	Fl_Box *box2 = new Fl_Box(10, 96, about->w()-20, 220, about_Info);
	box2->align(FL_ALIGN_INSIDE | FL_ALIGN_LEFT | FL_ALIGN_TOP);
  box2->box(FL_UP_BOX);
  box2->color(FL_DARK3, FL_DARK3);
	about->add(box2);

	Fl_Box *box3 = new Fl_Box(0, 320, about->w(), about->h()-320);
	box3->box(FL_FLAT_BOX);
	box3->color(FL_DARK3, FL_DARK3);
  about->add(box3);

	// finally add an "OK" button
	Fl_Button *button = new Fl_Button(about->w()-10-60, about->h()-10-30, 
			60, 30, "OK");
	button->callback((Fl_Callback *) menu_quit_CB);
	about->add(button);

///	about->set_modal();
	about->show();

	// run the GUI until the user closes
	while (! menu_want_to_quit)
		Fl::wait();

#if 0
	// check if the user moved/resized the window
	if (ab_win->x() != init_x || ab_win->y() != init_y)
	{
		guix_prefs.manual_x = ab_win->x();
		guix_prefs.manual_y = ab_win->y();
	}
#endif

	// this deletes all the child widgets too...
	delete about;
}

static void menu_do_save_log(Fl_Widget *w, void * data)
{
	// TODO
}

//------------------------------------------------------------------------

#undef FCAL
#define FCAL  (Fl_Callback *)

static Fl_Menu_Item menu_items[] = 
{
	{ "&File", 0, 0, 0, FL_SUBMENU },
#ifdef MACOSX
		{ "&Save Log",         0, FCAL menu_do_save_log },
#else
		{ "&Save Log",         0, FCAL menu_do_save_log, 0, FL_MENU_DIVIDER },
		{ "&Quit",  0 /* FL_ALT + 'q' */, FCAL menu_do_exit },
#endif
		{ 0 },

	{ "&Help", 0, 0, 0, FL_SUBMENU },
		{ "&About...",         0,  FCAL menu_do_about },
		{ 0 },

	{ 0 }
};


//
// MenuCreate
//
#ifdef MACOSX
Fl_Sys_Menu_Bar * MenuCreate(int x, int y, int w, int h)
{
	Fl_Sys_Menu_Bar *bar = new Fl_Sys_Menu_Bar(x, y, w, h);
	bar->menu(menu_items);
	return bar;
}
#else
Fl_Menu_Bar * MenuCreate(int x, int y, int w, int h)
{
	Fl_Menu_Bar *bar = new Fl_Menu_Bar(x, y, w, h);
	bar->menu(menu_items);
	return bar;
}
#endif

