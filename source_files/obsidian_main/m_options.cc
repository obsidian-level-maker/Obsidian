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

#include "lib_argv.h"
#include "lib_util.h"
#include "m_addons.h"
#include "m_cookie.h"
#include "m_lua.h"
#include "m_trans.h"
#include "main.h"
#include "sys_debug.h"
#include "sys_macro.h"

extern std::filesystem::path BestDirectory();

void Parse_Option(const std::string &name, const std::string &value)
{
    if (StringCaseCmpPartial(name, "recent") == 0)
    {
        Recent_Parse(name, value);
        return;
    }
    if (StringCaseCmp(name, "addon") == 0) { VFS_OptParse(value); }
    else if (StringCaseCmp(name, "language") == 0) { t_language = value; }
    else if (StringCaseCmp(name, "create_backups") == 0)
    {
        create_backups = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "overwrite_warning") == 0)
    {
        overwrite_warning = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "debug_messages") == 0)
    {
        debug_messages = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "limit_break") == 0)
    {
        limit_break = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "random_string_seeds") == 0)
    {
        random_string_seeds = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "password_mode") == 0)
    {
        password_mode = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "mature_word_lists") == 0)
    {
        mature_word_lists = StringToInt(value) ? true : false;
    }
    else if (StringCaseCmp(name, "default_output_path") == 0)
    {
        default_output_path = std::filesystem::u8path(value);
    }
    else { LogPrintf("%s '%s'\n", _("Unknown option: "), name.c_str()); }
}

static bool Options_ParseLine(std::string buf)
{
    std::string::size_type pos = 0;

    pos = buf.find('=', 0);
    if (pos == std::string::npos)
    {
        // Skip blank lines, comments, etc
        return true;
    }

    // For options file, don't strip whitespace as it can cause issue with addon
    // paths that have whitespace - Dasho

    /*while (std::find(buf.begin(), buf.end(), ' ') != buf.end()) {
        buf.erase(std::find(buf.begin(), buf.end(), ' '));
    }*/

    if (!isalpha(buf.front()))
    {
        printf("%s [%s]\n", _("Weird option line: "), buf.c_str());
        return false;
    }

    // pos = buf.find('=', 0);  // Fix pos after whitespace deletion
    std::string name  = buf.substr(0, pos - 1);
    std::string value = buf.substr(pos + 2);

    if (name.empty() || value.empty()) { return false; }

    Parse_Option(name, value);
    return true;
}

bool Options_Load(std::filesystem::path filename)
{
#ifdef _WIN32
    FILE *option_fp = _wfopen(filename.c_str(), L"r");
#else
    FILE *option_fp = fopen(filename.generic_u8string().c_str(), "r");
#endif

    if (!option_fp)
    {
        printf(_("Missing Options file -- using defaults.\n\n"));
        return false;
    }

    std::string line;
    line.reserve(4096);
    line.clear();

    for (fgets(line.data(), 4096, option_fp); !line.empty();)
    {
        Options_ParseLine(line);
        line.clear();
        fgets(line.data(), 4096, option_fp);
    }

    fclose(option_fp);

    return true;
}

bool Options_Save(std::filesystem::path filename)
{
#ifdef _WIN32
    FILE *option_fp = _wfopen(filename.c_str(), L"w");
#else
    FILE *option_fp = fopen(filename.generic_u8string().c_str(), "w");
#endif

    if (!option_fp)
    {
        LogPrintf("Error: unable to create file: %s\n(%s)\n\n",
                  filename.u8string().c_str(), strerror(errno));
        return false;
    }

    LogPrintf("Saving options file...\n");

    fprintf(option_fp, "-- OPTIONS FILE : OBSIDIAN %s \"%s\"\n", OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());

    fprintf(option_fp, "-- Build %s\n", OBSIDIAN_VERSION);
    fprintf(option_fp, "-- Based on OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    fprintf(option_fp, "-- %s\n\n", OBSIDIAN_WEBSITE);

    fprintf(option_fp, "language = %s\n\n", t_language.c_str());

    fprintf(option_fp, "create_backups = %d\n", (create_backups ? 1 : 0));
    fprintf(option_fp, "overwrite_warning = %d\n", (overwrite_warning ? 1 : 0));
    fprintf(option_fp, "debug_messages = %d\n", (debug_messages ? 1 : 0));
    fprintf(option_fp, "limit_break = %d\n", (limit_break ? 1 : 0));
    fprintf(option_fp, "random_string_seeds = %d\n", (random_string_seeds ? 1 : 0));
    fprintf(option_fp, "password_mode = %d\n", (password_mode ? 1 : 0));
    fprintf(option_fp, "mature_word_lists = %d\n", (mature_word_lists ? 1 : 0));
    fprintf(option_fp, "default_output_path = %s\n\n",
        default_output_path.generic_u8string().c_str());

    VFS_OptWrite(option_fp);

    Recent_Write(option_fp);

    fclose(option_fp);

    LogPrintf("DONE.\n\n");

    return true;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
