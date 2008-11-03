//------------------------------------------------------------------------
//  About Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

#include "main.h"


static const char *about_Text =
  "Oblige is a random level generator for\n"
  "DOOM, Heretic & Hexen\n"
  "\n"
  "Copyright (C) 2006-2008 Andrew Apted\n"
  "\n"
  "This program is free software, and may be\n"
  "distributed and modified under the terms of\n"
  "the GNU General Public License\n"
  "\n"
  "There is ABSOLUTELY NO WARRANTY\n"
  "Use at your OWN RISK";

static const char *about_Web =
  "http://oblige.sourceforge.net";

#define TITLE_COLOR  FL_BLUE

#define INFO_COLOR  fl_color_cube(0,6,4)


class UI_About : public Fl_Window
{
private:
  bool want_quit;

public:
  UI_About(int W, int H, const char *label = NULL);

  virtual ~UI_About()
  {
    // nothing needed
  }

  bool WantQuit() const
  {
    return want_quit;
  }

private:
  static void quit_callback(Fl_Widget *w, void *data)
  {
    UI_About *that = (UI_About *)data;

    that->want_quit = true;
  }
};

//
// Constructor
//
UI_About::UI_About(int W, int H, const char *label) :
    Fl_Window(W, H, label),
    want_quit(false)
{
  // cancel Fl_Group's automatic add crap
  end();


  // non-resizable
  size_range(W, H, W, H);
  callback(quit_callback, this);

  int cy = 0;

  // nice big logo text
  Fl_Box *box = new Fl_Box(0, cy, W, 50, OBLIGE_TITLE " " OBLIGE_VERSION);
  box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
  box->labelcolor(TITLE_COLOR);
  box->labelsize(24);
  add(box);


  cy += box->h() + 10;
  
  // the very informative text
  box = new Fl_Box(10, cy, W-20, 192, about_Text);
  box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
  box->box(FL_UP_BOX);
  box->color(INFO_COLOR);
  add(box);

  cy += box->h() + 10;


  // website address
  box = new Fl_Box(10, cy, W-20, 30, about_Web);
  box->align(FL_ALIGN_INSIDE | FL_ALIGN_CENTER);
  box->labelsize(20);
  add(box);

  cy += box->h() + 10;


  SYS_ASSERT(cy < H);

  Fl_Group *darkish = new Fl_Group(0, cy, W, H-cy);
  darkish->end();
  darkish->box(FL_FLAT_BOX);
  darkish->color(BUILD_BG, BUILD_BG);
  add(darkish);

  // finally add an "OK" button
  Fl_Button *button = new Fl_Button(W-10-60, H-10-30, 
      60, 30, "OK");
  button->callback(quit_callback, this);
  darkish->add(button);
}


void DLG_AboutText(void)
{
  UI_About *about = new UI_About(340, 364, "About Oblige");

  about->show();

  // run the GUI until the user closes
  while (! about->WantQuit())
    Fl::wait();

  // this deletes all the child widgets too...
  delete about;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
