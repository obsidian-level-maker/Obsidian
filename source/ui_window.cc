//------------------------------------------------------------------------
//  Main Window
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

#ifndef _WIN32
#include <unistd.h>
#endif
#include "m_trans.h"
#include "main.h"
#include "ui_imgui.h"

static constexpr uint16_t BASE_WINDOW_W = 816;
static constexpr uint16_t BASE_WINDOW_H = 512;

UI_MainWin *main_win;

int KF = 0;

int small_font_size;
int header_font_size;

static void main_win_close_CB()
{
    main_action = MAIN_QUIT;
}

static void main_win_surprise_go_CB()
{
    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        tab->SurpriseMe();
    }
    did_randomize = true;
}

int UI_MainWin::handle(SDL_Event event)
{
    switch (event.type)
    {
    case SDL_QUIT:
        return 1;
    case SDL_KEYDOWN:
        if (event.key.keysym.sym == SDLK_ESCAPE)
        {
            if (clippy->shown())
            {
                clippy->hide();
                return 1;
            }
        }
    default:
        return 0;
    }
}

//
// MainWin Constructor
//
UI_MainWin::UI_MainWin(int W, int H, const char *title) : Fl_Double_Window(W, H, title)
{
    size_range(W, H, 0, 0, 0, 0, 1);

    callback((Fl_Callback *)main_win_close_CB);

    color(GAP_COLOR, SELECTION);

    int LEFT_W = KromulentWidth(232);
    int MOD_W  = (W - LEFT_W) / 2 - KromulentHeight(4);

    int TOP_H = KromulentHeight(240);
    int BOT_H = H - TOP_H - KromulentHeight(4);

    menu_bar = new Fl_Menu_Bar(0, 0, W, KromulentHeight(20));
    menu_bar->box(box_style);
    menu_bar->textfont(font_style);
    menu_bar->textsize(font_scaling * .90);
    menu_bar->labelfont(font_style);
    menu_bar->labelsize(font_scaling * .90);
    menu_bar->add(_("File/Options"), FL_F + 4, menu_do_options);
    menu_bar->add(_("File/Theme"), FL_F + 7, menu_do_theme);
    menu_bar->add(_("File/Set Seed"), FL_F + 5, menu_do_edit_seed);
    menu_bar->add(_("File/Config Manager"), FL_F + 9, menu_do_manage_config);
    menu_bar->add(_("Help/About"), FL_F + 1, menu_do_about);
    menu_bar->add(_("Help/View Logs"), FL_F + 6, menu_do_view_logs);
    menu_bar->add(_("Help/Glossary"), 0, menu_do_glossary);
    menu_bar->add(_("Surprise Me/Go"), FL_F + 8, main_win_surprise_go_CB);
    menu_bar->selection_color(SELECTION);
    menu_bar->align(FL_ALIGN_INSIDE | FL_ALIGN_CLIP | FL_ALIGN_LEFT);

    sizing_group = new Fl_Group(0, KromulentHeight(22), W, H - KromulentHeight(20));
    sizing_group->box(FL_NO_BOX);

    game_box = new UI_Game(0, KromulentHeight(22), LEFT_W, TOP_H - KromulentHeight(22));

    build_box = new UI_Build(0, TOP_H + KromulentHeight(4), LEFT_W, BOT_H);

    mod_tabs = new UI_CustomTabs(LEFT_W + KromulentHeight(4), KromulentHeight(22), MOD_W * 2, H - KromulentHeight(22));

    clippy = new UI_Clippy();

    visible_focus(0);

    end();

    resizable(sizing_group);

    end();
}

//
// MainWin Destructor
//
UI_MainWin::~UI_MainWin()
{
}

void UI_MainWin::MenuBar()
{
    if (auto _bar = UI::MainMenuBar())
    {
        ImGuiIO     &io = ImGui::GetIO();
        ImFontConfig conf;
        conf.SizePixels     = font_scaling * .90;
        auto          _font = UI::PushFont(io.Fonts->AddFontDefault(&conf));
        UI::PushStyle style;
        style.Color(ImGuiCol_HeaderHovered, SELECTION);
        style.Color(ImGuiCol_Border, box_style);
        style.Var(ImGuiStyleVar_FramePadding, ImVec2(0.0, KromulentHeight(20) - conf.SizePixels));
        // left-align
        style.Var(ImGuiStyleVar_ButtonTextAlign, {0.0f, 0.5f});
        if (auto _menu = UI::Menu(_("File")))
        {
            if (ImGui::MenuItem(_("Options")))
            {
                DLG_OptionsEditor();
            }
            if (ImGui::MenuItem(_("Theme")))
            {
                DLG_ThemeEditor();
            }
            if (ImGui::MenuItem(_("Set Seed")))
            {
                DLG_EditSeed();
            }
            if (ImGui::MenuItem(_("Config Manager")))
            {
                DLG_ManageConfig();
            }
        }
        if (auto _menu = UI::Menu(_("Help")))
        {
            if (ImGui::MenuItem(_("About")))
            {
                DLG_AboutText();
            }
            if (ImGui::MenuItem(_("View Logs")))
            {
                DLG_ViewLogs();
            }
            if (ImGui::MenuItem(_("Glossary")))
            {
                DLG_ViewGlossary();
            }
        }
        if (auto _menu = UI::Menu(_("Surprise Me")))
        {
            if (ImGui::MenuItem(_("Go")))
            {
                main_win_surprise_go_CB();
            }
        }
    }
}

void UI_MainWin::CalcWindowSize(int *W, int *H)
{
    *W = KromulentWidth(BASE_WINDOW_W);
    *H = KromulentHeight(BASE_WINDOW_H);

    // tweak for "Tiny" setting
    if (KF < 0)
    {
        *W -= 24;
        *H -= 24;
    }

    //// DEBUG
    //    fprintf(stderr, "\n\nCalcWindowSize --> %d x %d\n", *W, *H);
}

void UI_MainWin::Locked(bool value)
{
    if (value)
    {
        main_win->menu_bar->deactivate();
    }
    else
    {
        main_win->menu_bar->activate();
    }
    game_box->Locked(value);
    for (int i = 0; i < main_win->mod_tabs->children(); i++)
    {
        UI_CustomMods *tab = (UI_CustomMods *)main_win->mod_tabs->child(i);
        tab->Locked(value);
    }
}
//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
