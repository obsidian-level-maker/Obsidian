//------------------------------------------------------------------------
//  Game Panel
//------------------------------------------------------------------------
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
//------------------------------------------------------------------------

#ifndef __UI_GAME_H__
#define __UI_GAME_H__

#include <cstddef>

#include "FL/Fl_Button.H"
#include "FL/Fl_Group.H"
#include "ui_widgets.h"

class UI_Game : public Fl_Group
{
  public:
    Fl_Box         *heading;
    UI_RChoiceMenu *engine;
    UI_HelpLink    *engine_help;
    UI_RChoiceMenu *game;
    UI_HelpLink    *game_help;
    UI_RChoiceMenu *port;
    UI_HelpLink    *port_help;
    UI_RChoiceMenu *theme;
    UI_RChoiceMenu *length;
    UI_HelpLink    *length_help;
    Fl_Button      *build;
    Fl_Button      *quit;
    Fl_Button      *surprise;

  private:
  public:
    UI_Game(int x, int y, int w, int h);
    virtual ~UI_Game();

  public:
    void Locked(bool value);

    // these return false if 'button' is not valid
    bool AddChoice(std::string button, std::string id, std::string label);
    bool EnableChoice(std::string button, std::string id, bool enable_it);
    bool SetButton(std::string button, std::string id);

    void SetAbortButton(bool abort);

  private:
    static void callback_Engine(Fl_Widget *, void *);
    static void callback_Game(Fl_Widget *, void *);
    static void callback_Port(Fl_Widget *, void *);
    static void callback_Length(Fl_Widget *, void *);
    static void callback_Theme(Fl_Widget *, void *);
    static void callback_EngineHelp(Fl_Widget *, void *);
    static void callback_GameHelp(Fl_Widget *, void *);
    static void callback_PortHelp(Fl_Widget *, void *);
    static void callback_LengthHelp(Fl_Widget *, void *);
    static void build_callback(Fl_Widget *, void *);
    static void stop_callback(Fl_Widget *, void *);
    static void quit_callback(Fl_Widget *, void *);
};

#endif /* __UI_GAME_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
