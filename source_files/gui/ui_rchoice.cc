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
    : UI_CustomMenu(x, y, w, h, label), opt_list() { visible_focus(0); labelfont(font_style); textfont(font_style); }

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

//----------------------------------------------------------------

UI_RSlide::UI_RSlide(int x, int y, int w, int h, const char *label)
    : Fl_Group(x, y, w, h, label) { visible_focus(0); labelfont(font_style); }

UI_RSlide::~UI_RSlide() {}

//----------------------------------------------------------------

UI_RButton::UI_RButton(int x, int y, int w, int h, const char *label)
    : Fl_Group(x, y, w, h, label) { visible_focus(0); box(FL_NO_BOX); }

UI_RButton::~UI_RButton() {}

//----------------------------------------------------------------

UI_CustomCheckBox::UI_CustomCheckBox(int x, int y, int w, int h, const char *label)
    : Fl_Check_Button(x, y, w, h, label) { visible_focus(0); box(FL_NO_BOX); down_box(button_style); }

UI_CustomCheckBox::~UI_CustomCheckBox() {}

// Custom draw function to use the checkmark style regardless of box type and respect custom colors
void UI_CustomCheckBox::draw() {
	if (box()) draw_box(this==Fl::pushed() ? fl_down(box()) : box(), color());
	Fl_Color col = value() ? (active_r() ? selection_color() :
		                      fl_inactive(selection_color())) : color();

	int W  = labelsize();
	int bx = Fl::box_dx(box());	// box frame width
	int dx = bx + 2;		// relative position of check mark etc.
	int dy = (h() - W) / 2;	// neg. offset o.k. for vertical centering
	int lx = 0;			// relative label position (STR #3237)

	draw_box(down_box(), x()+dx, y()+dy, W, W, FL_BACKGROUND2_COLOR);
  	if (value()) {
		fl_color(col);
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
	lx = dx + W + 2;
  	draw_label(x()+lx, y(), w()-lx-bx, h());
  	if (Fl::focus() == this) draw_focus();
}

//----------------------------------------------------------------

UI_CustomArrowButton::UI_CustomArrowButton(int x, int y, int w, int h, const char *label)
    : Fl_Repeat_Button(x, y, w, h, label) { visible_focus(0); }

UI_CustomArrowButton::~UI_CustomArrowButton() {}

void UI_CustomArrowButton::draw() {
  if (type() == FL_HIDDEN_BUTTON) return;
  Fl_Color col = value() ? selection_color() : color();
  draw_box(value() ? (down_box()?down_box():fl_down(box())) : box(), col);
  draw_backdrop();
  draw_label();
  if (Fl::focus() == this) draw_focus();
}

//----------------------------------------------------------------

UI_HelpLink::UI_HelpLink(int x, int y, int w, int h, const char *label)
    : Fl_Button(x, y, w, h, label),
      hover(false),
      label_X(0),
      label_Y(0),
      label_W(0),
      label_H(0) {
    box(FL_NO_BOX);
}

UI_HelpLink::~UI_HelpLink() { }

void UI_HelpLink::checkLink() {
    // change the cursor if the mouse is over the link.
    // the 'hover' variable reduces the number of times fl_cursor()
    // needs to be called (since it can be expensive).

    if (Fl::event_inside(x() + label_X, y() + label_Y, label_W, label_H)) {
        if (!hover) {
            fl_cursor(FL_CURSOR_HAND);
        }

        hover = true;
    } else {
        if (hover) {
            fl_cursor(FL_CURSOR_DEFAULT);
        }

        hover = false;
    }
}

int UI_HelpLink::handle(int event) {
    if (!active_r()) {
        return Fl_Button::handle(event);
    }

    switch (event) {
        case FL_MOVE: {
            checkLink();
            return 1;
        }

        case FL_ENTER: {
            checkLink();
            return 1;
        }

        case FL_LEAVE: {
            checkLink();
            return 1;
        }

        default:
            break;
    }

    return Fl_Button::handle(event);
}

void UI_HelpLink::draw() {
    if (type() == FL_HIDDEN_BUTTON) {
        return;
    }

    // determine where to draw the label

    label_X = label_Y = label_W = label_H = 0;

    fl_font(labelfont(), labelsize());
    fl_measure(label(), label_W, label_H, 1);

    if (align() & FL_ALIGN_LEFT) {
        label_X = 2;
    } else if (align() & FL_ALIGN_RIGHT) {
        label_X = w() - label_W - 2;
    } else {
        label_X = (w() - label_W) / 2;
    }

    label_Y += h() / 2 - labelsize() / 2 - 2;

    // draw the link text

    fl_draw_box(box(), x(), y(), w(), h(), color());

    fl_color(labelcolor());
    fl_draw(label(), x() + label_X, y() + label_Y, label_W, label_H,
            FL_ALIGN_LEFT);

    // draw the underline

    if (!value()) {
        int yy = y() + label_Y + label_H - 2;

        fl_line_style(FL_SOLID);
        fl_line(x() + label_X, yy, x() + label_X + label_W, yy);
        fl_line_style(0);
    }

    /*
       if (Fl::focus() == this)
       draw_focus();
     */
}

//----------------------------------------------------------------

UI_CustomMenu::UI_CustomMenu(int x, int y, int w, int h, const char *label)
    : Fl_Choice(x, y, w, h, label) { visible_focus(0); }

UI_CustomMenu::~UI_CustomMenu() {}

// Custom draw function to use selected button style
void UI_CustomMenu::draw() {
  Fl_Boxtype btype = button_style;
  
  int dx = Fl::box_dx(btype);
  int dy = Fl::box_dy(btype);

  // Arrow area
  int H = h() - 2 * dy;
  int W = Fl::is_scheme("gtk+")    ? 20 :			// gtk+  -- fixed size
          Fl::is_scheme("gleam")   ? 20 :			// gleam -- fixed size
          Fl::is_scheme("plastic") ? ((H > 20) ? 20 : H)	// plastic: shrink if H<20
                                   : ((H > 20) ? 20 : H);	// default: shrink if H<20
  int X = x() + w() - W - dx;
  int Y = y() + dy;

  // Arrow object
  int w1 = (W - 4) / 3; if (w1 < 1) w1 = 1;
  int x1 = X + (W - 2 * w1 - 1) / 2;
  int y1 = Y + (H - w1 - 1) / 2;

  if (Fl::scheme()) {
    // NON-DEFAULT SCHEME

    // Draw widget box
    draw_box(btype, color());

    // Draw arrow area
    fl_color(active_r() ? SELECTION : fl_inactive(SELECTION));
    if (Fl::is_scheme("plastic")) {
      // Show larger up/down arrows...
      fl_polygon(x1, y1 + 3, x1 + w1, y1 + w1 + 3, x1 + 2 * w1, y1 + 3);
      fl_polygon(x1, y1 + 1, x1 + w1, y1 - w1 + 1, x1 + 2 * w1, y1 + 1);
    } else {
      // Show smaller up/down arrows with a divider...
      x1 = x() + w() - 13 - dx;
      y1 = y() + h() / 2;
      fl_polygon(x1, y1 - 2, x1 + 3, y1 - 5, x1 + 6, y1 - 2);
      fl_polygon(x1, y1 + 2, x1 + 3, y1 + 5, x1 + 6, y1 + 2);

      fl_color(fl_darker(color()));
      fl_yxline(x1 - 7, y1 - 8, y1 + 8);

      fl_color(fl_lighter(color()));
      fl_yxline(x1 - 6, y1 - 8, y1 + 8);
    }
  } else {
    // DEFAULT SCHEME

    // Draw widget box
    draw_box(btype, color());

    // Draw arrow area
    draw_box(FL_UP_BOX,X,Y,W,H,color());
    fl_color(active_r() ? SELECTION : fl_inactive(SELECTION));
    fl_polygon(x1, y1, x1 + w1, y1 + w1, x1 + 2 * w1, y1);
  }

  W += 2 * dx;

  // Draw menu item's label
  if (mvalue()) {
    Fl_Menu_Item m = *mvalue();
    if (active_r()) m.activate(); else m.deactivate();

    // Clip
    int xx = x() + dx, yy = y() + dy + 1, ww = w() - W, hh = H - 2;
    fl_push_clip(xx, yy, ww, hh);

    if ( Fl::scheme()) {
      Fl_Label l;
      l.value = m.text;
      l.image = 0;
      l.deimage = 0;
      l.type = m.labeltype_;
      l.font = m.labelsize_ || m.labelfont_ ? m.labelfont_ : textfont();
      l.size = m.labelsize_ ? m.labelsize_ : textsize();
      l.color= m.labelcolor_ ? m.labelcolor_ : textcolor();
      if (!m.active()) l.color = fl_inactive((Fl_Color)l.color);
      fl_draw_shortcut = 2; // hack value to make '&' disappear
      l.draw(xx+3, yy, ww>6 ? ww-6 : 0, hh, FL_ALIGN_LEFT);
      fl_draw_shortcut = 0;
      if ( Fl::focus() == this ) draw_focus(box(), xx, yy, ww, hh);
    }
    else {
      fl_draw_shortcut = 2; // hack value to make '&' disappear
      m.draw(xx, yy, ww, hh, this, Fl::focus() == this);
      fl_draw_shortcut = 0;
    }

    fl_pop_clip();
  }

  // Widget's label
  draw_label();
}
//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
