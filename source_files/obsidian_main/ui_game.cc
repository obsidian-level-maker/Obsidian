//----------------------------------------------------------------
//  Game Panel
//----------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
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
#include <iostream>

#define ABORT_COLOR fl_color_cube(3, 1, 1)

//
// Constructor
//
UI_Game::UI_Game(int X, int Y, int W, int H) : Fl_Group(X, Y, W, H) {
    box(box_style);

    int button_w = W * 0.35;
    int button_h = kf_h(30);
    int button_x = X + kf_w(25);

    int y_step = kf_h(30);

    int cx = X + W * 0.29;
    int cy = Y + kf_h(4);

    heading = new Fl_Box(FL_NO_BOX, X + kf_w(8), cy, W - kf_w(12), kf_h(24),
                         _("Game Settings"));
    heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    heading->labeltype(FL_NORMAL_LABEL);
    heading->labelfont(use_system_fonts ? font_style : font_style | FL_BOLD);
    heading->labelsize(header_font_size);

    cy = Y + kf_h(32);

    int cw = W * 0.50;
    int ch = kf_h(22);

    game = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    game->copy_label(_("Game: "));
    game->align(FL_ALIGN_LEFT);
    game->labelfont(font_style);
    game->textcolor(FONT2_COLOR);
    game->selection_color(SELECTION);
    game->callback(callback_Game, this);
    game_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    game_help->labelfont(font_style);
    game_help->callback(callback_GameHelp, this);

    cy += y_step;

    engine = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    engine->copy_label(_("Engine: "));
    engine->align(FL_ALIGN_LEFT);
    engine->labelfont(font_style);
    engine->textcolor(FONT2_COLOR);
    engine->selection_color(SELECTION);
    engine->callback(callback_Engine, this);
    engine_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    engine_help->labelfont(font_style);
    engine_help->callback(callback_EngineHelp, this);

    cy += y_step;

    length = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    length->copy_label(_("Length: "));
    length->align(FL_ALIGN_LEFT);
    length->labelfont(font_style);
    length->textcolor(FONT2_COLOR);
    length->selection_color(SELECTION);
    length->callback(callback_Length, this);
    length_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    length_help->labelfont(font_style);
    length_help->callback(callback_LengthHelp, this);

    cy += y_step;

    theme = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    theme->copy_label(_("Theme: "));
    theme->align(FL_ALIGN_LEFT);
    theme->labelfont(font_style);
    theme->textcolor(FONT2_COLOR);
    theme->selection_color(SELECTION);
    theme->callback(callback_Theme, this);
    theme_help = new UI_HelpLink(cx + cw, cy, W * 0.10, ch);
    theme_help->labelfont(font_style);
    theme_help->callback(callback_ThemeHelp, this);

    cy += y_step + kf_h(10);

    build = new Fl_Button(button_x, cy, button_w, button_h, _("Build"));
    build->visible_focus(0);
    build->box(button_style);
    build->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    build->color(BUTTON_COLOR);
    build->labelcolor(FONT2_COLOR);
    build->labelfont(use_system_fonts ? font_style : font_style | FL_BOLD);
    build->labelsize(header_font_size);
    build->callback(build_callback, this);
    build->shortcut(FL_F + 2);

    quit = new Fl_Button(W - button_x - button_w, cy, button_w, button_h,
                         _("Quit"));
    quit->visible_focus(0);
    quit->box(button_style);
    quit->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    quit->color(BUTTON_COLOR);
    quit->labelcolor(FONT2_COLOR);
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

void UI_Game::callback_GameHelp(Fl_Widget *w, void *data) {
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window *win = new Fl_Window(640, 480, _("Game"));
    Fl_Text_Buffer *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("The following games will have gameplay that differs from the original IWADs:\n\nHexen: Game progression is linear and episodic. There are no hubs present. The Death Wyvern is not present in the monster table due to the infeasibility of scripting and flight pathing.\n\nStrife: Quests/multiple endings not yet implemented. Progression is linear and game will end on last level generated."));
    // clang-format on
}

void UI_Game::callback_EngineHelp(Fl_Widget *w, void *data) {
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window *win = new Fl_Window(640, 480, _("Engine"));
    Fl_Text_Buffer *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("Available Engines:\n\nZDoom Family: Engines that use ZDoom as a base. Example ports: GZDoom, LZDoom\n\nVanilla DOOM: Doom with its original engine limits. Example ports: Doom within DOSBox, Chocolate Doom. NOTE: This option will use SLUMP as the map builder.\n\nLimit Removing: Any engine that raises the limits of the original game to prevent crashes, but is not Boom-compatible. Example ports: Doom2-plus, Doomsday 1.x, Crispy Doom\n\nBoom-Compatible: Engines that are able to use the entire suite of Boom types and features. Most modern source ports fall into this category at a minimum.\n\nPrBoom-Compatible: Boom-compatible, but also capable of using extended nodes. Example ports: DSDA-Doom, PrBoom+um\n\nEDGE-Classic: Boom-compatible, plus additional specials and other advanced features.\n\nEternity: Boom-compatible, software renderer only, but with advanced features such as UDMF."));
    // clang-format on
}

void UI_Game::callback_LengthHelp(Fl_Widget *w, void *data) {
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window *win = new Fl_Window(640, 480, _("Length"));
    Fl_Text_Buffer *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(_("Available WAD Lengths:\n\nSingle Level: One map.\n\nA Few Maps: Four maps.\n\nOne Episode: The length of an episode in the original IWAD. For Doom 2, which normally doesn't have episodes, this is 11 maps.\n\nFull Game: The length of a full game in the original IWAD."));
    // clang-format on
}

void UI_Game::callback_ThemeHelp(Fl_Widget *w, void *data) {
    fl_cursor(FL_CURSOR_DEFAULT);
    Fl_Window *win = new Fl_Window(640, 480, _("Theme"));
    Fl_Text_Buffer *buff = new Fl_Text_Buffer();
    Fl_Text_Display *disp = new Fl_Text_Display(20, 20, 640 - 40, 480 - 40);
    disp->buffer(buff);
    disp->wrap_mode(Fl_Text_Display::WRAP_AT_BOUNDS, 0);
    win->resizable(*disp);
    win->hotspot(0, 0, 0);
    win->set_modal();
    win->show();
    // clang-format off
    buff->text(
        _("Available Themes:\n\nOriginal: Follows the theme progression of the original IWAD.\n\nEpisodic: Each episode follows a single randomly chose theme.\n\nBit Mixed: Theme will change every few levels.\n\nJumbled Up: Level themes are purely random.\n\nPsychedelic: Trippy.\n\nOther themes listed are game-specific."));
    // clang-format on
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

bool UI_Game::AddChoice(std::string button, std::string id, std::string label) {
    if (!StringCaseCmp(button, "game")) {
        game->AddChoice(id, label);
        return true;
    }
    if (!StringCaseCmp(button, "engine")) {
        if (StringCaseCmp(id, "advanced")) {
            engine->AddChoice(id, label);
        }
        return true;
    }
    if (!StringCaseCmp(button, "length")) {
        length->AddChoice(id, label);
        return true;
    }
    if (!StringCaseCmp(button, "theme")) {
        theme->AddChoice(id, label);
        return true;
    }

    return false;  // unknown button
}

bool UI_Game::EnableChoice(std::string button, std::string id, bool enable_it) {
    if (!StringCaseCmp(button, "game")) {
        game->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCaseCmp(button, "engine")) {
        engine->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCaseCmp(button, "length")) {
        length->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCaseCmp(button, "theme")) {
        theme->EnableChoice(id, enable_it);
        return true;
    }

    return false;  // unknown button
}

bool UI_Game::SetButton(std::string button, std::string id) {
    if (!StringCaseCmp(button, "game")) {
        game->ChangeTo(id);
        return true;
    }
    if (!StringCaseCmp(button, "engine")) {
        engine->ChangeTo(id);
        return true;
    }
    if (!StringCaseCmp(button, "length")) {
        length->ChangeTo(id);
        return true;
    }
    if (!StringCaseCmp(button, "theme")) {
        theme->ChangeTo(id);
        return true;
    }

    return false;  // unknown button
}

void UI_Game::SetAbortButton(bool abort) {
    if (abort) {
        quit->label(_("Cancel"));
        quit->labelcolor(ABORT_COLOR);
        quit->labelfont(use_system_fonts ? font_style : font_style | FL_BOLD);

        quit->callback(stop_callback, this);

        build->labelfont(font_style);
    } else {
        quit->label(_("Quit"));
        quit->labelcolor(FL_FOREGROUND_COLOR);
        quit->labelfont(font_style);

        quit->callback(quit_callback, this);

        build->labelfont(use_system_fonts ? font_style : font_style | FL_BOLD);
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
