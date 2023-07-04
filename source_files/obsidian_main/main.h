//------------------------------------------------------------------------
//  Main defines
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

#ifndef __OBSIDIAN_MAIN_H__
#define __OBSIDIAN_MAIN_H__

#include <cstddef>
#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <filesystem>
#ifndef CONSOLE_ONLY
#include "hdr_fltk.h"
#include "ui_window.h"
#include "lib_util.h"
#include "sys_debug.h"
#endif
extern std::string OBSIDIAN_TITLE;

#ifdef OBSIDIAN_TIMESTAMP
constexpr const char *OBSIDIAN_VERSION = OBSIDIAN_TIMESTAMP;
#else
// Fallback in case the CMake timestamp stuff fails for some reason, but this
// shouldn't be used in practice
constexpr const char *OBSIDIAN_VERSION = __DATE__;
#endif

constexpr const char *OBSIDIAN_SHORT_VERSION = "21";
extern std::string OBSIDIAN_CODE_NAME;

constexpr const char *OBSIDIAN_WEBSITE =
    "https://obsidian-level-maker.github.io";

constexpr const char *CONFIG_FILENAME = "CONFIG.txt";
constexpr const char *OPTIONS_FILENAME = "OPTIONS.txt";
constexpr const char *THEME_FILENAME = "THEME.txt";
constexpr const char *LOG_FILENAME = "LOGS.txt";
constexpr const char *REF_FILENAME = "REFERENCE.txt";

#ifdef _WIN32
#ifndef CONSOLE_ONLY
extern int v_unload_private_font(const char *path);
#endif
#else
#ifndef CONSOLE_ONLY
#ifndef __APPLE__
extern int v_unload_private_font(const char *path);
#endif
#endif
#endif

extern std::filesystem::path home_dir;
extern std::filesystem::path install_dir;
#ifdef WIN32
char32_t *ucs4_path(const char *path);
extern std::filesystem::path physfs_dir;
#endif

extern std::filesystem::path config_file;
extern std::filesystem::path options_file;
extern std::filesystem::path theme_file;
extern std::filesystem::path logging_file;
extern std::filesystem::path reference_file;

extern bool batch_mode;

extern std::filesystem::path batch_output_file;

extern unsigned long long next_rand_seed;

// this records the user action, e.g. Cancel or Quit buttons
enum main_action_kind_e {
    MAIN_NONE = 0,
    MAIN_BUILD,
    MAIN_CANCEL,
    MAIN_QUIT,
    MAIN_HARD_RESTART,
    MAIN_SOFT_RESTART
};

extern int main_action;

// Misc Options
#ifndef CONSOLE_ONLY
extern uchar text_red;
extern uchar text_green;
extern uchar text_blue;
extern uchar text2_red;
extern uchar text2_green;
extern uchar text2_blue;
extern uchar bg_red;
extern uchar bg_green;
extern uchar bg_blue;
extern uchar bg2_red;
extern uchar bg2_green;
extern uchar bg2_blue;
extern uchar button_red;
extern uchar button_green;
extern uchar button_blue;
extern uchar gradient_red;
extern uchar gradient_green;
extern uchar gradient_blue;
extern uchar border_red;
extern uchar border_green;
extern uchar border_blue;
extern uchar gap_red;
extern uchar gap_green;
extern uchar gap_blue;
extern Fl_Boxtype box_style;
extern Fl_Boxtype button_style;
extern Fl_Font font_style;
extern Fl_Color FONT_COLOR;
extern Fl_Color FONT2_COLOR;
extern Fl_Color WINDOW_BG;
extern Fl_Color SELECTION;
extern Fl_Color GAP_COLOR;
extern Fl_Color GRADIENT_COLOR;
extern Fl_Color BUTTON_COLOR;
extern Fl_Color BORDER_COLOR;
#endif
extern int color_scheme;
extern int font_theme;
extern int box_theme;
extern int button_theme;
extern int widget_theme;
extern int window_scaling;
extern int font_scaling;
extern int num_fonts;
extern int filename_prefix;
extern std::string custom_prefix;
extern bool use_system_fonts;
extern std::vector<std::map<std::string, int>> font_menu_items;

extern bool create_backups;
extern bool overwrite_warning;
extern bool debug_messages;
extern bool limit_break;
extern bool preserve_failures;
extern bool preserve_old_config;
extern bool did_randomize;
extern bool randomize_architecture;
extern bool randomize_monsters;
extern bool randomize_pickups;
extern bool randomize_misc;
extern bool random_string_seeds;
extern bool password_mode;
extern bool mature_word_lists;
extern bool did_specify_seed;
extern bool first_run;
extern bool mid_batch;
extern int builds_per_run;

extern std::string def_filename;

extern std::filesystem::path last_directory;
extern std::string numeric_locale;
extern std::vector<std::string> batch_randomize_groups;

#ifndef CONSOLE_ONLY
// Dialog Windows
void DLG_ShowError(const char *msg, ...);

std::filesystem::path DLG_OutputFilename(const char *ext,
                                         const char *preset = nullptr);
#endif

extern std::filesystem::path default_output_path;

extern std::filesystem::path Resolve_DefaultOutputPath();

extern std::filesystem::path gif_filename;

extern std::string string_seed;
extern std::string selected_lang;

// Tutorial stuff
#ifndef CONSOLE_ONLY
extern Fl_BMP_Image *tutorial1;
extern Fl_BMP_Image *tutorial2;
extern Fl_BMP_Image *tutorial3;
extern Fl_BMP_Image *tutorial4;
extern Fl_BMP_Image *tutorial5;
extern Fl_BMP_Image *tutorial6;
extern Fl_BMP_Image *tutorial7;
extern Fl_BMP_Image *tutorial8;
extern Fl_BMP_Image *tutorial9;
extern Fl_BMP_Image *tutorial10;
extern Fl_Pixmap *clippy;

void DLG_AboutText();
void DLG_OptionsEditor();
void DLG_ThemeEditor();

void DLG_EditSeed();
void DLG_ViewLogs();
void DLG_ViewGlossary();
void DLG_ManageConfig();

void DLG_Tutorial();
#endif

namespace Main {

namespace Detail {
void Shutdown(bool error);
}

template <typename... Args>
[[noreturn]] void FatalError(std::string_view msg, Args &&...args) {
    auto buffer = StringFormat(msg, std::forward<Args>(args)...);
#ifndef CONSOLE_ONLY
    DLG_ShowError("%s", buffer.c_str());
#endif
    Detail::Shutdown(true);

    if (batch_mode) {
        StdErrPrintf("%s\n", buffer.c_str());
        StdErrPrintf("ERROR!\n");
#ifdef WIN32
        std::cout << '\n' << "Close window when finished...";
        do {
        } while (true);
#endif
    }

    std::exit(9);
}

template <typename... Args>
void ProgStatus(std::string_view msg, Args &&...args) {
    const std::string buffer = StringFormat(msg, std::forward<Args>(args)...);

#ifndef CONSOLE_ONLY
    if (main_win) {
        main_win->build_box->SetStatus(buffer.c_str());
    } else if (batch_mode) {
        StdErrPrintf("%s\n", buffer.c_str());
    }
#else
    StdErrPrintf("%s\n", buffer.c_str());
#endif
}
bool BackupFile(const std::filesystem::path &filename);
#if defined WIN32 && !defined CONSOLE_ONLY
void Blinker();
#endif

#if !defined(CONSOLE_ONLY) && !defined(__APPLE__)
bool LoadInternalFont(const char *fontpath, int fontnum, const char *fontname);
#endif
#ifndef CONSOLE_ONLY
void SetupFLTK();
int  DetermineScaling();
void PopulateFontMap();
void Ticker();
#endif

}  // namespace Main

class game_interface_c {
    /* this is an abstract base class */

   public:
    game_interface_c() = default;

    virtual ~game_interface_c() = default;
    game_interface_c(const game_interface_c &) = default;
    game_interface_c &operator=(const game_interface_c &) = default;
    game_interface_c(game_interface_c &&) = default;
    game_interface_c &operator=(game_interface_c &&) = default;

    /*** MAIN ***/

    // this selects an output filename or directory and prepares
    // for building a set of levels.  Returns false if an error
    // occurs (or the user simply Cancel'd).
    //
    // when 'preset' parameter is not NULL, it is a filename to
    // use in the save dialog.
    virtual bool Start(const char *preset) = 0;

    // this is called after all levels are done.  The 'build_ok'
    // value is the result from the LUA script, and is false if
    // an error occurred or the user clicked Abort.
    //
    // For DOOM this will run glBSP node builder, for QUAKE it will
    // put all the BSP files into the final PAK file.
    //
    // Returns false on error.  Note that Finish() is never
    // called if Start() fails.
    virtual bool Finish(bool build_ok) = 0;

    /*** CSG2 ***/

    // this will set things up in preparation for the next level
    // being built.  It is called after the CSG2 code sets itself
    // up and hence could alter some CSG2 parameters, other than
    // that there is lttle need to do anything here.
    virtual void BeginLevel() = 0;

    // called when all the brushes and entities have been added
    // but before the CSG2 performs a cleanup.  Typically the
    // game-specific code will call CSG_BSP() and convert
    // the result to the game-specific level format.
    virtual void EndLevel() = 0;

    // sets a certain property, especially "level_name" which is
    // required by most games (like DOOM and QUAKE).  Unknown
    // properties are ignored.  May be called during startup too.
    virtual void Property(std::string key, std::string value) = 0;

    virtual std::filesystem::path Filename() = 0;
};

extern game_interface_c *game_object;

/* interface for each game format */

game_interface_c *Doom_GameObject();
game_interface_c *Nukem_GameObject();
game_interface_c *Quake1_GameObject();
game_interface_c *Quake2_GameObject();
game_interface_c *Quake3_GameObject();
game_interface_c *Wolf_GameObject();

#endif /* __OBSIDIAN_MAIN_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
