//------------------------------------------------------------------------
//  Tutorial Window
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2017 Andrew Apted
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

#include "fmt/format.h"
#include "hdr_fltk.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_util.h"
#include "main.h"

class UI_Tutorial_Window : public Fl_Window {
   public:
    bool want_quit;

   public:
    UI_Tutorial_Window(int W, int H, const char *label = NULL);

    virtual ~UI_Tutorial_Window() {}

    bool WantQuit() const { return want_quit; }

   public:
    // FLTK virtual method for handling input events.
    int handle(int event) {
        if (event == FL_KEYDOWN || event == FL_SHORTCUT) {
            int key = Fl::event_key();

            if (key == FL_Escape) {
                want_quit = true;
                return 1;
            }

            // eat all other function keys
            if (FL_F + 1 <= key && key <= FL_F + 12) {
                return 1;
            }
        }

        return Fl_Window::handle(event);
    }

   private:
    static void callback_Quit(Fl_Widget *w, void *data) {
        UI_Tutorial_Window *that = (UI_Tutorial_Window *)data;

        that->want_quit = true;
    }

    Fl_Wizard *tutorial_wiz;

    static void wiz_back(Fl_Widget*, void *data) {
        Fl_Wizard *that = (Fl_Wizard *)data;
        that->prev();
        that->redraw();
    }

     static void wiz_next(Fl_Widget*, void *data) {
        Fl_Wizard *that = (Fl_Wizard *)data;
        that->next();
        that->redraw();
    }
};

//
// Constructor
//
UI_Tutorial_Window::UI_Tutorial_Window(int W, int H, const char *label)
    : Fl_Window(W, H, label), want_quit(false) {
    // non-resizable
    size_range(W, H, W, H);

    callback(callback_Quit, this);

    tutorial_wiz = new Fl_Wizard(0, 0, W, H);

    // Wizard: page 1
    {
        Fl_Group *g = new Fl_Group(0,0,W,H);
        g->box(box_style);
        Fl_Button *next = new Fl_Button(W - 110, H - 35, 100, 25, "Next");
        next->box(button_style);
        next->visible_focus(0);
        next->color(BUTTON_COLOR);
        next->labelfont(font_style);
        next->labelcolor(FONT2_COLOR);
        next->callback(wiz_next, this->tutorial_wiz);
        Fl_Box *out = new Fl_Box(10,30,W-20,H-80);
        out->label("Welcome to OBSIDIAN Level Maker! This quick tutorial will teach you\
 the basics of navigating the user interface.");
        out->align(FL_ALIGN_WRAP);
        out->box(FL_FLAT_BOX);
        g->end();
    }
    // Wizard: page 2
    {
        Fl_Group *g = new Fl_Group(0,0,W,H);
        g->box(box_style);
        Fl_Button *next = new Fl_Button(W - 110, H - 35, 100, 25, "Next");
        next->box(button_style);
        next->visible_focus(0);
        next->color(BUTTON_COLOR);
        next->labelfont(font_style);
        next->labelcolor(FONT2_COLOR);
        next->callback(wiz_next, this->tutorial_wiz);
        Fl_Button *back = new Fl_Button(W - 220, H - 35, 100, 25,"Back");
        back->box(button_style);
        back->visible_focus(0);
        back->color(BUTTON_COLOR);
        back->labelfont(font_style);
        back->labelcolor(FONT2_COLOR);
        back->callback(wiz_back, this->tutorial_wiz);
        Fl_Box *out = new Fl_Box(10,30,W-20,H-80);
        out->box(FL_FLAT_BOX);
        out->labelsize(FL_NORMAL_SIZE * .9);
        out->label("Game Settings, in the upper left area of the program window, contains all you \
need to build your very first WAD. Select the Game you would like to build a WAD for, the Engine that \
it will be played on, the Length (number of maps) of the WAD, and the Theme that you would like it to have. \
Once you press 'Build', you will be prompted to choose a location and filename for your WAD. After that, your \
WAD will be generated and saved to the location that you specified.\n\nNOTE: If you select 'Vanilla Doom' for the \
engine, an alternate map generator called SLUMP will be used to create your WAD. Although this WAD will be compatible \
with all versions of Doom, it is much simpler in nature than the maps made by Obsidian's main generator.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial1);
        g->end();
    }
    // Wizard: page 3
    {
        Fl_Group *g = new Fl_Group(0,0,W,H);
        g->box(box_style);
        Fl_Button *done = new Fl_Button(W - 110, H - 35, 100, 25, "Finish");
        done->box(button_style);
        done->visible_focus(0);
        done->color(BUTTON_COLOR);
        done->labelfont(font_style);
        done->labelcolor(FONT2_COLOR);
        done->callback(callback_Quit, this);
        Fl_Button *back = new Fl_Button(W - 220, H - 35, 100, 25,"Back");
        back->box(button_style);
        back->visible_focus(0);
        back->color(BUTTON_COLOR);
        back->labelfont(font_style);
        back->labelcolor(FONT2_COLOR);
        back->callback(wiz_back, this->tutorial_wiz);
        Fl_Box *out = new Fl_Box(10,30,W-20,H-80);
        out->box(FL_FLAT_BOX);
        out->labelsize(FL_NORMAL_SIZE * .9);
        out->label("\n\nAt some point, you will want to have more control over the contents of the \
WADs that you generate. This is where modules come into play. Modules are groups of options that can be \
changed to fine-tune your experience. Most modules are optional, and will need to be enabled or disabled \
accordingly.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial2);
        g->end();
    }
    tutorial_wiz->end();

    end();
}

void DLG_Tutorial(void) {
    int tutorial_w = kf_w(640);
    int tutorial_h = kf_h(480) + KF * 20;

    UI_Tutorial_Window *tutorial_window =
        new UI_Tutorial_Window(tutorial_w, tutorial_h, _("OBSIDIAN Tutorial"));

    tutorial_window->want_quit = false;
    tutorial_window->set_modal();
    tutorial_window->show();

    // run the GUI until the user closes
    while (!tutorial_window->WantQuit()) {
        Fl::wait();
    }

    delete tutorial_window;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
