//------------------------------------------------------------------------
//  Debugging support
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

#ifndef __SYS_DEBUG_H__
#define __SYS_DEBUG_H__

#include <algorithm>
#include <fstream>
#include <string>
#include <iostream>
extern bool terminal;
extern bool debugging;
extern std::fstream log_file;
extern std::fstream ref_file;
extern std::string StringFormat(std::string_view str, ...);

bool LogInit(const std::string &filename);  // NULL for none
void LogClose(void);
bool RefInit(const std::string &filename);  // NULL for none
void RefClose(void);

void LogEnableDebug(bool enable);
void LogEnableTerminal(bool enable);

template <typename... Args>
void LogPrintf(std::string_view str, Args &&...args) {
    std::string msg = StringFormat(str, args...);
    log_file << msg;
    if (terminal) {
        std::cout << msg;
    }
}
template <typename... Args>
void RefPrintf(std::string_view str, Args &&...args) {
    std::string msg = StringFormat(str, args...);
    ref_file << msg;
    if (terminal) {
        std::cout << msg;
    }
}
template <typename... Args>
void DebugPrintf(std::string_view str, Args &&...args) {
    if (debugging) {
        std::string msg = StringFormat(str, args...);
        log_file << msg;
        if (terminal) {
            std::cout << msg;
        }
    }
}
template <typename... Args>
void StdOutPrintf(std::string_view str, Args &&...args) {
    std::cout << StringFormat(str, args...);
}
template <typename... Args>
void StdErrPrintf(std::string_view str, Args &&...args) {
    std::cerr << StringFormat(str, args...);
}
template <typename... Args>
void StreamPrintf(std::ostream &stream, std::string_view str, Args &&...args) {
    stream << StringFormat(str, args...);
}

using log_display_func_t = void (*)(std::string_view line, void *priv_data);

void LogReadLines(log_display_func_t display_func, void *priv_data);

#endif /* __SYS_DEBUG_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
