//----------------------------------------------------------------
//  Game Panel
//----------------------------------------------------------------
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
//----------------------------------------------------------------

#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_signal.h"
#include "lib_util.h"
#include "m_lua.h"
#include "main.h"

#define ABORT_COLOR fl_color_cube(3, 1, 1)

//
// Constructor
//
UI_Game::UI_Game(int X, int Y, int W, int H, const char *label)
    : Fl_Group(X, Y, W, H, label) {
    box(box_style);

    int button_w = W * 0.35;
    int button_h = kf_h(30);
    int button_x = X + kf_w(25);

    int y_step = kf_h(30);

    int cx = X + W * 0.29;
    int cy = Y + kf_h(4);

    const char *heading_text = _("Game Settings");

    Fl_Box *heading = new Fl_Box(FL_NO_BOX, X + kf_w(8), cy, W - kf_w(12),
                                 kf_h(24), heading_text);
    heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    heading->labeltype(FL_NORMAL_LABEL);
    heading->labelfont(font_style | FL_BOLD);
    heading->labelsize(header_font_size);

    cy = Y + kf_h(32);

    int cw = W * 0.60;
    int ch = kf_h(22);

    game = new UI_RChoice(cx, cy, cw, ch, _("Game: "));
    game->align(FL_ALIGN_LEFT);
    game->labelfont(font_style);
    game->selection_color(SELECTION);
    game->callback(callback_Game, this);

    cy += y_step;

    engine = new UI_RChoice(cx, cy, cw, ch, _("Engine: "));
    engine->align(FL_ALIGN_LEFT);
    engine->labelfont(font_style);
    engine->selection_color(SELECTION);
    engine->callback(callback_Engine, this);

    cy += y_step;

    length = new UI_RChoice(cx, cy, cw, ch, _("Length: "));
    length->align(FL_ALIGN_LEFT);
    length->labelfont(font_style);
    length->selection_color(SELECTION);
    length->callback(callback_Length, this);

    cy += y_step;

    theme = new UI_RChoice(cx, cy, cw, ch, _("Theme: "));
    theme->align(FL_ALIGN_LEFT);
    theme->labelfont(font_style);
    theme->selection_color(SELECTION);
    theme->callback(callback_Theme, this);

    cy += y_step + kf_h(10);

    build = new Fl_Button(button_x, cy, button_w, button_h, _("Build"));
    build->visible_focus(0);
    build->box(button_style);
    build->labelfont(font_style | FL_BOLD);
    build->labelsize(FL_NORMAL_SIZE + 2);
    build->callback(build_callback, this);
    build->shortcut(FL_F + 2);

    quit = new Fl_Button(W - button_x - button_w, cy, button_w, button_h,
                         _("Quit"));
    quit->visible_focus(0);
    quit->box(button_style);
    quit->labelfont(font_style);
    quit->callback(quit_callback, this);
    quit->shortcut(FL_COMMAND + 'q');

    end();
}

//
// Destructor
//
UI_Game::~UI_Game() {}

void UI_Game::callback_Game(Fl_Widget *w, void *data) {
    UI_Game *that = (UI_Game *)data;

    ob_set_config("game", that->game->GetID());
}

void UI_Game::callback_Engine(Fl_Widget *w, void *data) {
    UI_Game *that = (UI_Game *)data;

    ob_set_config("engine", that->engine->GetID());
}

void UI_Game::callback_Length(Fl_Widget *w, void *data) {
    UI_Game *that = (UI_Game *)data;

    ob_set_config("length", that->length->GetID());
}

void UI_Game::callback_Theme(Fl_Widget *w, void *data) {
    UI_Game *that = (UI_Game *)data;

    ob_set_config("theme", that->theme->GetID());
}

void UI_Game::Locked(bool value) {
    if (value) {
        game->deactivate();
        engine->deactivate();
        length->deactivate();
        theme->deactivate();
        build->deactivate();
    } else {
        game->activate();
        engine->activate();
        length->activate();
        theme->activate();
        build->activate();
    }
}

bool UI_Game::AddChoice(const char *button, const char *id, const char *label) {
    if (StringCaseCmp(button, "game") == 0) {
        game->AddChoice(id, label);
        return true;
    }
    if (StringCaseCmp(button, "engine") == 0) {
    	if (StringCaseCmp(id, "advanced") != 0) {
        	engine->AddChoice(id, label);
        }
        return true;
    }
    if (StringCaseCmp(button, "length") == 0) {
        length->AddChoice(id, label);
        return true;
    }
    if (StringCaseCmp(button, "theme") == 0) {
        theme->AddChoice(id, label);
        return true;
    }

    return false;  // unknown button
}

bool UI_Game::EnableChoice(const char *button, const char *id, bool enable_it) {
    if (StringCaseCmp(button, "game") == 0) {
        game->EnableChoice(id, enable_it);
        return true;
    }
    if (StringCaseCmp(button, "engine") == 0) {
        engine->EnableChoice(id, enable_it);
        return true;
    }
    if (StringCaseCmp(button, "length") == 0) {
        length->EnableChoice(id, enable_it);
        return true;
    }
    if (StringCaseCmp(button, "theme") == 0) {
        theme->EnableChoice(id, enable_it);
        return true;
    }

    return false;  // unknown button
}

bool UI_Game::SetButton(const char *button, const char *id) {
    if (StringCaseCmp(button, "game") == 0) {
        game->ChangeTo(id);
        return true;
    }
    if (StringCaseCmp(button, "engine") == 0) {
        engine->ChangeTo(id);
        return true;
    }
    if (StringCaseCmp(button, "length") == 0) {
        length->ChangeTo(id);
        return true;
    }
    if (StringCaseCmp(button, "theme") == 0) {
        theme->ChangeTo(id);
        return true;
    }

    return false;  // unknown button
}

void UI_Game::SetAbortButton(bool abort) {
    if (abort) {
        quit->label(_("Cancel"));
        quit->labelcolor(ABORT_COLOR);
        quit->labelfont(font_style | FL_BOLD);

        quit->callback(stop_callback, this);

        build->labelfont(font_style);
    } else {
        quit->label(_("Quit"));
        quit->labelcolor(FL_FOREGROUND_COLOR);
        quit->labelfont(font_style);

        quit->callback(quit_callback, this);

        build->labelfont(font_style | FL_BOLD);
    }
}

void UI_Game::build_callback(Fl_Widget *w, void *data) {
    if (main_action == 0) {
        main_action = MAIN_BUILD;
    }
}

void UI_Game::stop_callback(Fl_Widget *w, void *data) {
    if (main_action != MAIN_QUIT) {
        main_action = MAIN_CANCEL;
    }
}

void UI_Game::quit_callback(Fl_Widget *w, void *data) {
    main_action = MAIN_QUIT;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
