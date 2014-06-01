//
// Menu button widget for the Fast Light Tool Kit (FLTK).
//
// Copyright 1998-2010 by Bill Spitzak and others.
//
// This library is free software. Distribution and use rights are outlined in
// the file "COPYING" which should have been included with this file.  If this
// file is missing or damaged, see the license at:
//
//     http://www.fltk.org/COPYING.php
//
// Please report all bugs and problems on the following page:
//
//     http://www.fltk.org/str.php
//

//----------------------------------------------------------------
//
// Modified 1/June/2014 by Andrew Apted, from FLTK 1.3.2
//
// Provides an Fl_Menu_Across, based on Fl_Menu_Button, which puts
// the menu to the right of the button (instead of under it).
//
//----------------------------------------------------------------

#include "headers.h"
#include "hdr_fltk.h"

#include "zf_menu.h"


static Fl_Menu_Across	*pressed_across_menu_ = 0;


void Fl_Menu_Across::draw() {
  int H = (labelsize()-3)&-2;
  int X = x()+w()-H-Fl::box_dx(box())-Fl::box_dw(box())-1;
//int Y = y()+(h()-H)/2;
  draw_box(pressed_across_menu_ == this ? fl_down(box()) : box(), color());
  draw_label(x()+Fl::box_dx(box()), y(), X-x()+2, h());
  if (Fl::focus() == this) draw_focus();
}


/**
  Act exactly as though the user clicked the button or typed the
  shortcut key.  The menu appears, it waits for the user to pick an item,
  and if they pick one it sets value() and does the callback or
  sets changed() as described above.  The menu item is returned
  or NULL if the user dismisses the menu.
*/
const Fl_Menu_Item* Fl_Menu_Across::popup() {
  const Fl_Menu_Item* m;
  pressed_across_menu_ = this;
  redraw();
  Fl_Widget_Tracker mb(this);
  m = menu()->pulldown(x() + w() - 4, y() - h(), w(), h(), 0, this);
  picked(m);
  pressed_across_menu_ = 0;
  if (mb.exists()) redraw();
  return m;
}


int Fl_Menu_Across::handle(int e) {
  if (!menu() || !menu()->text) return 0;
  switch (e) {
  case FL_ENTER: /* FALLTHROUGH */
  case FL_LEAVE:
    return 1;
  case FL_PUSH:
    if (Fl::visible_focus()) Fl::focus(this);
    popup();
    return 1;
  case FL_KEYBOARD:
    if (Fl::event_key() == ' ' &&
        !(Fl::event_state() & (FL_SHIFT | FL_CTRL | FL_ALT | FL_META))) {
      popup();
      return 1;
    } else return 0;
  case FL_SHORTCUT:
    if (Fl_Widget::test_shortcut()) {popup(); return 1;}
    return test_shortcut() != 0;
  case FL_FOCUS: /* FALLTHROUGH */
  case FL_UNFOCUS:
    if (Fl::visible_focus()) {
      redraw();
      return 1;
    }
  default:
    return 0;
  }
}

/**
  Creates a new Fl_Menu_Across widget using the given position,
  size, and label string. The default boxtype is FL_UP_BOX.
  <P>The constructor sets menu() to NULL.  See 
  Fl_Menu_ for the methods to set or change the menu.
*/
Fl_Menu_Across::Fl_Menu_Across(int X,int Y,int W,int H,const char *l)
: Fl_Menu_(X,Y,W,H,l) {
  down_box(FL_NO_BOX);
}

