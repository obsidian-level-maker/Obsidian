//----------------------------------------------------------------
//  Remember Choice widget
//----------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2016 Andrew Apted
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
//----------------------------------------------------------------

#include "hdr_fltk.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_util.h"
#include "main.h"

choice_data_c::choice_data_c(const char *_id, const char *_label)
    : id(NULL), label(NULL), enabled(false), mapped(-1), widget(NULL) {
    if (_id) {
        id = StringDup(_id);
    }
    if (_label) {
        label = StringDup(_label);
    }
}

choice_data_c::~choice_data_c() {
    if (id) {
        StringFree(id);
    }
    if (label) {
        StringFree(label);
    }

    // ignore 'widget' field when enabled, we assume it exists in
    // an Fl_Group and hence FLTK will take care to delete it.
    if (!enabled) {
        delete widget;
    }
}

//----------------------------------------------------------------

UI_RChoice::UI_RChoice(int x, int y, int w, int h, const char *label)
    : Fl_Choice(x, y, w, h, label), opt_list() {}

UI_RChoice::~UI_RChoice() {
    for (unsigned int i = 0; i < opt_list.size(); i++) {
        delete opt_list[i];
    }
}

void UI_RChoice::AddChoice(const char *id, const char *label) {
    choice_data_c *opt = FindID(id);

    if (opt) {
        StringFree(opt->label);
        opt->label = StringDup(label);

        if (opt->enabled) {
            Recreate();
        }
    } else {
        opt = new choice_data_c(id, label);

        opt_list.push_back(opt);

        // no need to call Recreate() here since new pairs are always
        // hidden (enabled == false).
    }
}

bool UI_RChoice::EnableChoice(const char *id, bool enable_it) {
    SYS_ASSERT(id);

    choice_data_c *P = FindID(id);

    if (!P) {
        return false;
    }

    if (P->enabled != enable_it) {
        P->enabled = enable_it;
        Recreate();
    }

    return true;
}

const char *UI_RChoice::GetID() const {
    choice_data_c *P = FindMapped();

    return P ? P->id : "";
}

const char *UI_RChoice::GetLabel() const {
    choice_data_c *P = FindMapped();

    return P ? P->label : "";
}

bool UI_RChoice::ChangeTo(const char *id) {
    SYS_ASSERT(id);

    choice_data_c *P = FindID(id);

    if (!P || P->mapped < 0) {
        return false;
    }

    value(P->mapped);

    return true;
}

//----------------------------------------------------------------

void UI_RChoice::Recreate() {
    // recreate the choice list

    choice_data_c *LAST = FindMapped();

    clear();

    for (unsigned int j = 0; j < opt_list.size(); j++) {
        choice_data_c *P = opt_list[j];

        // is it just a separator?
        if (strcmp(P->label, "_") == 0) {
            P->mapped = -1;
            add("", 0, 0, 0, FL_MENU_DIVIDER | FL_MENU_INACTIVE);
            continue;
        }

        if (!P->enabled) {
            P->mapped = -1;
            continue;
        }

        P->mapped = add(P->label, 0, 0, 0, 0);
    }

    // update the currently selected choice

    if (LAST && LAST->mapped >= 0) {
        value(LAST->mapped);
        return;
    }

    value(0);
}

choice_data_c *UI_RChoice::FindID(const char *id) const {
    for (unsigned int j = 0; j < opt_list.size(); j++) {
        choice_data_c *P = opt_list[j];

        if (strcmp(P->id, id) == 0) {
            return P;
        }
    }

    return NULL;
}

choice_data_c *UI_RChoice::FindMapped() const {
    for (unsigned int j = 0; j < opt_list.size(); j++) {
        choice_data_c *P = opt_list[j];

        if (P->mapped >= 0 && P->mapped == value()) {
            return P;
        }
    }

    return NULL;
}

void UI_RChoice::GotoPrevious() {
    int v = value();

    if (v > 0) {
        v--;
        value(v);

        // skip dividers
        while (v > 0 && (mvalue()->flags & FL_MENU_INACTIVE)) {
            v--;
            value(v);
        }

        do_callback();
    }
}

void UI_RChoice::GotoNext() {
    int v = value();
    int last = size() - 2;

    if (v < last) {
        v++;
        value(v);

        // skip dividers
        while (v < last && (mvalue()->flags & FL_MENU_INACTIVE)) {
            v++;
            value(v);
        }

        do_callback();
    }
}

int UI_RChoice::handle(int event) {
    if (wheel_can_bump && event == FL_MOUSEWHEEL && Fl::belowmouse() == this) {
        if (Fl::event_dy() < 0) {
            GotoPrevious();
        } else if (Fl::event_dy() > 0) {
            GotoNext();
        }

        return 1;  // eat it
    }

    return Fl_Choice::handle(event);
}

//----------------------------------------------------------------

choice_data_c *UI_RSlide::FindMapped() const {
    for (unsigned int j = 0; j < opt_list.size(); j++) {
        choice_data_c *P = opt_list[j];

        if (P->mapped >= 0 && P->mapped == value()) {
            return P;
        }
    }

    return NULL;
}

const char *UI_RSlide::GetID() const {
    choice_data_c *P = FindMapped();

    return P ? P->id : "";
}

const char *UI_RSlide::GetLabel() const {
    choice_data_c *P = FindMapped();

    return P ? P->label : "";
}

bool UI_RSlide::ChangeTo(const char *id) {
    SYS_ASSERT(id);

    choice_data_c *P = FindID(id);

    if (!P || P->mapped < 0) {
        return false;
    }

    value(P->mapped);

    return true;
}

choice_data_c *UI_RSlide::FindID(const char *id) const {
    for (unsigned int j = 0; j < opt_list.size(); j++) {
        choice_data_c *P = opt_list[j];

        if (strcmp(P->id, id) == 0) {
            return P;
        }
    }

    return NULL;
}

//----------------------------------------------------------------

UI_RButton::UI_RButton(int x, int y, int w, int h, const char *label)
    : Fl_Light_Button(x, y, w, h, label), opt_list() { visible_focus(0); box(FL_NO_BOX); }

UI_RButton::~UI_RButton() {}

// Custom draw function to have right-aligned 'checkbox'
void UI_RButton::draw() {
  if (box()) draw_box(this==Fl::pushed() ? fl_down(box()) : box(), color());
  Fl_Color col = value() ? (active_r() ? selection_color() :
                            fl_inactive(selection_color())) : color();

  int W  = labelsize();
  int bx = Fl::box_dx(box());	// box frame width
  int dx = bx + 2;		// relative position of check mark etc.
  int dy = (h() - W) / 2;	// neg. offset o.k. for vertical centering
  int lx = 0;			// relative label position (STR #3237)

  if (down_box()) {
    // draw other down_box() styles:
    switch (down_box()) {
      case FL_DOWN_BOX :
      case FL_UP_BOX :
      case _FL_PLASTIC_DOWN_BOX :
      case _FL_PLASTIC_UP_BOX :
        // Check box...
        draw_box(down_box(), x()+dx, y()+dy, W, W, FL_BACKGROUND2_COLOR);
	if (value()) {
	  if (Fl::is_scheme("gtk+")) {
	    fl_color(FL_SELECTION_COLOR);
	  } else {
	    fl_color(col);
	  }
	  int tx = x() + dx + 3;
	  int tw = W - 6;
	  int d1 = tw/3;
	  int d2 = tw-d1;
	  int ty = y() + dy + (W+d2)/2-d1-2;
	  for (int n = 0; n < 3; n++, ty++) {
	    fl_line(tx, ty, tx+d1, ty+d1);
	    fl_line(tx+d1, ty+d1, tx+tw-1, ty+d1-d2+1);
	  }
	}
        break;
      case _FL_ROUND_DOWN_BOX :
      case _FL_ROUND_UP_BOX :
        // Radio button...
        draw_box(down_box(), x()+dx, y()+dy, W, W, FL_BACKGROUND2_COLOR);
	if (value()) {
	  int tW = (W - Fl::box_dw(down_box())) / 2 + 1;
	  if ((W - tW) & 1) tW++; // Make sure difference is even to center
	  int tdx = dx + (W - tW) / 2;
	  int tdy = dy + (W - tW) / 2;

	  if (Fl::is_scheme("gtk+")) {
	    fl_color(FL_SELECTION_COLOR);
	    tW --;
	    fl_pie(x() + tdx - 1, y() + tdy - 1, tW + 3, tW + 3, 0.0, 360.0);
	    fl_color(fl_color_average(FL_WHITE, FL_SELECTION_COLOR, 0.2f));
	  } else fl_color(col);

	  switch (tW) {
	    // Larger circles draw fine...
	    default :
              fl_pie(x() + tdx, y() + tdy, tW, tW, 0.0, 360.0);
	      break;

            // Small circles don't draw well on many systems...
	    case 6 :
	      fl_rectf(x() + tdx + 2, y() + tdy, tW - 4, tW);
	      fl_rectf(x() + tdx + 1, y() + tdy + 1, tW - 2, tW - 2);
	      fl_rectf(x() + tdx, y() + tdy + 2, tW, tW - 4);
	      break;

	    case 5 :
	    case 4 :
	    case 3 :
	      fl_rectf(x() + tdx + 1, y() + tdy, tW - 2, tW);
	      fl_rectf(x() + tdx, y() + tdy + 1, tW, tW - 2);
	      break;

	    case 2 :
	    case 1 :
	      fl_rectf(x() + tdx, y() + tdy, tW, tW);
	      break;
	  }

	  if (Fl::is_scheme("gtk+")) {
	    fl_color(fl_color_average(FL_WHITE, FL_SELECTION_COLOR, 0.5));
	    fl_arc(x() + tdx, y() + tdy, tW + 1, tW + 1, 60.0, 180.0);
	  }
	}
        break;
      default :
        draw_box(down_box(), x()+dx, y()+dy, W, W, col);
        break;
    }
    lx = dx + W + 2;
  } else {
    // if down_box() is zero, draw light button style:
    int hh = h()-2*dy - 2;
    int ww = W/2+1;
    int xx = dx;
    if (w()<ww+2*xx) xx = (w()-ww)/2;
    if (Fl::is_scheme("plastic")) {
      col = active_r() ? selection_color() : fl_inactive(selection_color());
      fl_color(value() ? col : fl_color_average(col, FL_BLACK, 0.5f));
      fl_pie(x()+xx, y()+dy+1, ww, hh, 0, 360);
    } else {
      draw_box(FL_THIN_DOWN_BOX, x()+w()-W, y()+dy+1, hh, hh, col);
    }
    lx = dx + ww + 2;
  }
  draw_label(x(), y(), w()-lx-bx, h());
  if (Fl::focus() == this) draw_focus();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
