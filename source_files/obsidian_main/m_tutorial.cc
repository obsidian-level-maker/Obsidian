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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("Game Settings, in the upper left area of the program window, contains all you \
need to build your very first WAD. Select the Game you would like to build a WAD for, the Engine that \
it will be played on, the Length (number of maps) of the WAD, and the Theme that you would like it to have. \
Once you press 'Build', you will be prompted to choose a location and filename for your WAD. After that, your \
WAD will be generated and saved to the location that you specified.\n\nNOTE: If you select 'Vanilla Doom' for the \
engine, an alternate map generator will be used to create your WAD. Although this WAD will be compatible \
with all versions of Doom, it is much simpler in nature than the maps made by Obsidian's main generator.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial1);
        g->end();
    }
    // Wizard: page 3
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nAt some point, you will want to have more control over the contents of the \
WADs that you generate. This is where modules come into play. Modules are groups of options that can be \
changed to fine-tune your experience. Most modules are optional, and will need to be enabled or disabled \
accordingly.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial2);
        g->end();
    }
    // Wizard: page 3
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nSome modules do not have any additional options to configure, \
and only need to be enabled or disabled. To enable them, simply click the checkbox to the \
left of their name. To disable them, clear the same checkbox by clicking it again.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial3);
        g->end();
    }
    // Wizard: page 3
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nOther modules will have options that you can adjust after you enable them. These modules will \
have a + symbol next to their name instead of a checkbox. To enable them, click the + symbol. The + will turn into a - \
and the module will expand to show its options. Once you have adjusted these options, you MUST LEAVE THE MODULE EXPANDED for them \
to take effect. To disable the module, click the - symbol. It will collapse and the - will turn back into a +");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial4);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nModule options come in three different flavors: Checkboxes, drop-down menus, and sliders. Checkboxes and drop-down menus \
are fairly self-explanatory, but we will cover some of the more advanced slider functions.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial5);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nSome sliders will have an inverted triangle icon in the top right corner. Clicking this will show a menu \
with various choices. With the exception of 'Use Slider Value', these will ignore the number that the slider is set to in favor of a different \
means of determining the related value.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial6);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nAll sliders will have a pair of brackets in the top right corner. Clicking these will open a dialog box where you \
can enter a value manually instead of using the slider handle or arrow buttons.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial7);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nAll module options will have a tooltip that is shown by hovering your cursor over the option title. In addition, there \
is a question mark icon in the top right corner of each option that can be clicked to open a window with a more detailed explanation.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial8);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nAddons are a way to enhance the Obsidian experience further by adding new content, modules, and options. They come in the \
form of *.pk3 files that must be placed in the /addons folder of your Obsidian install. Once there, open the Addons window by pressing F3 or choosing \
File->Addon List from the program menu. A list of available addon files will be shown, and can be enabled or disabled via checkbox.\n\nGood sources for \
new addons are either the public Obsidian-Addons repo at https://github.com/GTD-Carthage/Obsidian-Addons or the #addon-files channel of our Discord.");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial9);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nIf, for whatever reason, you receive an error while building, you can view Obsidian's logs by pressing F6 or \
selecting Help->View Logs from the program menu. From here, you can view and save the log contents to a file of your choosing. In addition, \
there is a LOGS.txt file with the same information that is stored in the same folder as obsidian.exe. This file is overwritten each time you \
start the program, so be sure to save this information elsewhere if you need to refer to it later! These logs are extremely important when \
seeking help or filing bug reports!");
        out->align(FL_ALIGN_WRAP);
        out->image(tutorial10);
        g->end();
    }
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
        out->labelsize(FL_NORMAL_SIZE);
        out->label("\n\nThere are more options to explore within Obsidian, but this should be enough to get you started. \
The tutorial can be viewed again at any time by choosing Help->Tutorial from the program menu.\n\nIf you need more help, please ask in our \
Discord (invite link https://discord.gg/dfqCt9v) or check our wiki at https://github.com/dashodanger/Obsidian/wiki.\n\nGood luck in the \
infinite Hells!");
        out->align(FL_ALIGN_WRAP);
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
    tutorial_window->show();

    // run the GUI until the user closes
    while (!tutorial_window->WantQuit()) {
        Fl::wait();
    }

    delete tutorial_window;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
