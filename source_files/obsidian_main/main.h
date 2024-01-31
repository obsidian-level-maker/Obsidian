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
#include "lib_util.h"
#include "sys_debug.h"
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
constexpr const char *LOG_FILENAME = "LOGS.txt";

extern std::filesystem::path home_dir;
extern std::filesystem::path install_dir;
extern std::filesystem::path config_file;
extern std::filesystem::path options_file;
extern std::filesystem::path logging_file;
extern bool batch_mode;
extern std::filesystem::path batch_output_file;
extern unsigned long long next_rand_seed;

// Misc Options
extern bool create_backups;
extern bool overwrite_warning;
extern bool debug_messages;
extern bool limit_break;
extern bool random_string_seeds;
extern bool password_mode;
extern bool mature_word_lists;
extern bool did_specify_seed;
extern std::string def_filename;
extern std::filesystem::path last_directory;
extern std::string numeric_locale;
extern std::filesystem::path default_output_path;
extern std::filesystem::path Resolve_DefaultOutputPath();
extern std::filesystem::path gif_filename;
extern std::string string_seed;
extern std::string selected_lang;

namespace Main {

namespace Detail {
void Shutdown(bool error);
}

template <typename... Args>
[[noreturn]] void FatalError(std::string_view msg, Args &&...args) {
    Detail::Shutdown(true);
    if (batch_mode) {
        std::cout << "ERROR!\n";
#if defined WIN32 && !defined CONSOLE_ONLY
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
    StdErrPrintf("%s\n", buffer.c_str());
}
bool BackupFile(const std::filesystem::path &filename);

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

    virtual std::filesystem::path ZIP_Filename() = 0;

    // likely only useful for Doom, but informs the program if it needs to package
    // each map in its own native format (WAD, etc)
    bool file_per_map = false;
};

extern game_interface_c *game_object;

/* interface for each game format */

game_interface_c *Doom_GameObject();
game_interface_c *Nukem_GameObject();
game_interface_c *Quake1_GameObject();
game_interface_c *Quake2_GameObject();
game_interface_c *Wolf_GameObject();

#endif /* __OBSIDIAN_MAIN_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
