//----------------------------------------------------------------------
//  Options Editor
//----------------------------------------------------------------------
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
//----------------------------------------------------------------------

#ifndef CONSOLE_ONLY


#endif
#include "headers.h"
#include "lib_argv.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_trans.h"
#include "m_lua.h"
#include "main.h"

extern std::filesystem::path BestDirectory();

void Parse_Option(const std::string &name, const std::string &value) {
    if (StringCaseCmpPartial(name, "recent") == 0) {
        Recent_Parse(name, value);
        return;
    }
    if (StringCaseCmp(name, "addon") == 0) {
        VFS_OptParse(value);
    } else if (StringCaseCmp(name, "language") == 0) {
        t_language = value;
    } else if (StringCaseCmp(name, "create_backups") == 0) {
        create_backups = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "overwrite_warning") == 0) {
        overwrite_warning = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "debug_messages") == 0) {
        debug_messages = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "limit_break") == 0) {
        limit_break = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "preserve_old_config") == 0) {
        preserve_old_config = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_architecture") == 0) {
        randomize_architecture = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_monsters") == 0) {
        randomize_monsters = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_pickups") == 0) {
        randomize_pickups = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "randomize_misc") == 0) {
        randomize_misc = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "random_string_seeds") == 0) {
        random_string_seeds = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "password_mode") == 0) {
        password_mode = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "mature_word_lists") == 0) {
        mature_word_lists = StringToInt(value) ? true : false;
    } else if (StringCaseCmp(name, "filename_prefix") == 0) {
        filename_prefix = StringToInt(value);
    } else if (StringCaseCmp(name, "default_output_path") == 0) {
        default_output_path = std::filesystem::u8path(value);
    } else {
        LogPrintf("%s '%s'\n", _("Unknown option: "), name.c_str());
    }
}

static bool Options_ParseLine(std::string buf) {
    std::string::size_type pos = 0;

    pos = buf.find('=', 0);
    if (pos == std::string::npos) {
        // Skip blank lines, comments, etc
        return true;
    }

    // For options file, don't strip whitespace as it can cause issue with addon
    // paths that have whitespace - Dasho

    /*while (std::find(buf.begin(), buf.end(), ' ') != buf.end()) {
        buf.erase(std::find(buf.begin(), buf.end(), ' '));
    }*/

    if (!isalpha(buf.front())) {
        StdOutPrintf("%s [%s]\n", _("Weird option line: "), buf.c_str());
        return false;
    }

    // pos = buf.find('=', 0);  // Fix pos after whitespace deletion
    std::string name = buf.substr(0, pos - 1);
    std::string value = buf.substr(pos + 2);

    if (name.empty() || value.empty()) {
        StdOutPrintf(_("Name or value missing!\n"));
        return false;
    }

    Parse_Option(name, value);
    return true;
}

bool Options_Load(std::filesystem::path filename) {
    std::ifstream option_fp(filename, std::ios::in);

    if (!option_fp.is_open()) {
        StdOutPrintf(_("Missing Options file -- using defaults.\n\n"));
        return false;
    }

    for (std::string line; std::getline(option_fp, line);) {
        Options_ParseLine(line);
    }

    option_fp.close();

    return true;
}

bool Options_Save(std::filesystem::path filename) {
    std::ofstream option_fp(filename, std::ios::out);

    if (!option_fp.is_open()) {
        LogPrintf("Error: unable to create file: %s\n(%s)\n\n",
                  filename.u8string().c_str(), strerror(errno));
        return false;
    }

    if (main_action != MAIN_SOFT_RESTART) {
        LogPrintf("Saving options file...\n");
    }

    option_fp << "-- OPTIONS FILE : OBSIDIAN " << OBSIDIAN_SHORT_VERSION
              << " \"" << OBSIDIAN_CODE_NAME << "\"\n";
    option_fp << "-- Build " << OBSIDIAN_VERSION << "\n";
    option_fp << "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n";
    option_fp << "-- " << OBSIDIAN_WEBSITE << "\n\n";

    option_fp << "language = " << t_language << "\n";
    option_fp << "\n";

    option_fp << "create_backups = " << (create_backups ? 1 : 0) << "\n";
    option_fp << "overwrite_warning = " << (overwrite_warning ? 1 : 0) << "\n";
    option_fp << "debug_messages = " << (debug_messages ? 1 : 0) << "\n";
    option_fp << "limit_break = " << (limit_break ? 1 : 0) << "\n";
    option_fp << "preserve_old_config = " << (preserve_old_config ? 1 : 0)
              << "\n";
    option_fp << "randomize_architecture = " << (randomize_architecture ? 1 : 0)
              << "\n";
    option_fp << "randomize_monsters = " << (randomize_monsters ? 1 : 0)
              << "\n";
    option_fp << "randomize_pickups = " << (randomize_pickups ? 1 : 0) << "\n";
    option_fp << "randomize_misc = " << (randomize_misc ? 1 : 0) << "\n";
    option_fp << "random_string_seeds = " << (random_string_seeds ? 1 : 0)
              << "\n";
    option_fp << "password_mode = " << (password_mode ? 1 : 0) << "\n";
    option_fp << "mature_word_lists = " << (mature_word_lists ? 1 : 0) << "\n";
    option_fp << "filename_prefix = " << filename_prefix << "\n";
    std::string dop = StringFormat(
        "default_output_path = %s\n",
        StringToUTF8(default_output_path.generic_u16string()).c_str());
    option_fp.write(dop.c_str(), dop.size());

    option_fp << "\n";

    VFS_OptWrite(option_fp);

    Recent_Write(option_fp);

    option_fp.close();

    if (main_action != MAIN_SOFT_RESTART) {
        LogPrintf("DONE.\n\n");
    }

    return true;
}

//----------------------------------------------------------------------
#ifndef CONSOLE_ONLY

#endif
//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
