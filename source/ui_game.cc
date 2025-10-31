//----------------------------------------------------------------
//  Game Panel
//----------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
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

#include "lib_util.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"

//
// Constructor
//
UI_Game::UI_Game(int X, int Y, int W, int H) : Fl_Group(X, Y, W, H)
{
    box(box_style);

    int button_w = W * 0.35;
    int button_h = KromulentHeight(30);
    int button_x = X + KromulentWidth(25);

    int y_step = KromulentHeight(32);

    int cx = X + W * 0.29;
    int cy = Y + KromulentHeight(4);

    heading = new Fl_Box(FL_NO_BOX, X + KromulentWidth(8), cy, W - KromulentWidth(12), KromulentHeight(24),
                         _("Game Settings"));
    heading->align(FL_ALIGN_LEFT | FL_ALIGN_INSIDE);
    heading->labeltype(FL_NORMAL_LABEL);
    heading->labelfont(font_style == 13 ? (font_style + 1) : (font_style == 14 ? font_style : (font_style | FL_BOLD)));
    heading->labelsize(header_font_size);

    cy = Y + KromulentHeight(36);

    int cw = W * 0.50;
    int ch = KromulentHeight(26);

    game = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    game->copy_label(_("Game: "));
    game->align(FL_ALIGN_LEFT);
    game->labelfont(font_style);
    game->textcolor(FONT2_COLOR);
    game->selection_color(SELECTION);
    game->callback(callback_Game, this);

    cy += y_step;

    port = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    port->copy_label(_("Port: "));
    port->align(FL_ALIGN_LEFT);
    port->labelfont(font_style);
    port->textcolor(FONT2_COLOR);
    port->selection_color(SELECTION);
    port->callback(callback_Port, this);

    cy += y_step;

    length = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    length->copy_label(_("Length: "));
    length->align(FL_ALIGN_LEFT);
    length->labelfont(font_style);
    length->textcolor(FONT2_COLOR);
    length->selection_color(SELECTION);
    length->callback(callback_Length, this);

    cy += y_step;

    theme = new UI_RChoiceMenu(cx, cy, cw, ch, "");
    theme->copy_label(_("Theme: "));
    theme->align(FL_ALIGN_LEFT);
    theme->labelfont(font_style);
    theme->textcolor(FONT2_COLOR);
    theme->selection_color(SELECTION);
    theme->callback(callback_Theme, this);

    cy += y_step * 1.25;

    build = new Fl_Button(button_x, cy, button_w, button_h, _("Build"));
    build->visible_focus(0);
    build->box(button_style);
    build->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP);
    build->color(BUTTON_COLOR);
    build->labelcolor(FONT2_COLOR);
    build->labelfont(font_style == 13 ? (font_style + 1) : (font_style == 14 ? font_style : (font_style | FL_BOLD)));
    build->labelsize(header_font_size);
    build->callback(build_callback, this);
    build->shortcut(FL_F + 2);

    quit = new Fl_Button(W - button_x - button_w, cy, button_w, button_h, _("Quit"));
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
UI_Game::~UI_Game()
{
}

void UI_Game::callback_Game(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("game", that->game->GetID());
}

void UI_Game::callback_Port(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("port", that->port->GetID());
}

void UI_Game::callback_Length(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("length", that->length->GetID());
}

void UI_Game::callback_Theme(Fl_Widget *w, void *data)
{
    UI_Game *that = (UI_Game *)data;

    ob_set_config("theme", that->theme->GetID());
}

void UI_Game::Locked(bool value)
{
    if (value)
    {
        game->deactivate();
        port->deactivate();
        length->deactivate();
        theme->deactivate();
        build->deactivate();
    }
    else
    {
        game->activate();
        port->activate();
        length->activate();
        theme->activate();
        build->activate();
    }
}

bool UI_Game::AddChoice(const std::string &button, const std::string &id, const std::string &label)
{
    if (!StringCompare(button, "game"))
    {
        game->AddChoice(id, label);
        return true;
    }
    if (!StringCompare(button, "port"))
    {
        port->AddChoice(id, label);
        return true;
    }
    if (!StringCompare(button, "length"))
    {
        length->AddChoice(id, label);
        return true;
    }
    if (!StringCompare(button, "theme"))
    {
        theme->AddChoice(id, label);
        return true;
    }

    return false; // unknown button
}

bool UI_Game::EnableChoice(const std::string &button, const std::string &id, bool enable_it)
{
    if (!StringCompare(button, "game"))
    {
        game->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "port"))
    {
        port->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "length"))
    {
        length->EnableChoice(id, enable_it);
        return true;
    }
    if (!StringCompare(button, "theme"))
    {
        theme->EnableChoice(id, enable_it);
        return true;
    }

    return false; // unknown button
}

bool UI_Game::SetButton(const std::string &button, const std::string &id)
{
    if (!StringCompare(button, "game"))
    {
        game->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "port"))
    {
        port->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "length"))
    {
        length->ChangeTo(id);
        return true;
    }
    if (!StringCompare(button, "theme"))
    {
        theme->ChangeTo(id);
        return true;
    }

    return false; // unknown button
}

void UI_Game::SetAbortButton(bool abort)
{
    if (abort)
    {
        quit->label(_("Cancel"));
        quit->labelcolor(fl_color_cube(3, 1, 1));
        quit->labelfont(font_style == 13 ? (font_style + 1) : (font_style == 14 ? font_style : (font_style | FL_BOLD)));

        quit->callback(stop_callback, this);

        build->labelfont(font_style);
    }
    else
    {
        quit->label(_("Quit"));
        quit->labelcolor(FL_FOREGROUND_COLOR);
        quit->labelfont(font_style);

        quit->callback(quit_callback, this);

        build->labelfont(font_style == 13 ? (font_style + 1) : (font_style == 14 ? font_style : (font_style | FL_BOLD)));
    }
}

void UI_Game::build_callback(Fl_Widget *w, void *data)
{
    if (main_action == 0)
    {
        main_action = MAIN_BUILD;
    }
}

void UI_Game::stop_callback(Fl_Widget *w, void *data)
{
    if (main_action != MAIN_QUIT)
    {
        main_action = MAIN_CANCEL;
    }
}

void UI_Game::quit_callback(Fl_Widget *w, void *data)
{
    main_action = MAIN_QUIT;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
