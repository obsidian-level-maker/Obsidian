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

#include <fstream>
#include <iostream>
#include "headers.h"
#include "lib_util.h"
#include "main.h"
#include "miniz.h"
#include "m_lua.h"
#include "sinks/rotating_file_sink.h"

#define DEBUG_BUF_LEN 20000

std::shared_ptr<spdlog::logger> log_file;
std::fstream ref_file;
std::filesystem::path log_filename;
std::filesystem::path ref_filename;

bool debugging = false;
bool terminal = false;

bool LogInit(const std::filesystem::path &filename) {
    if (!filename.empty()) {
        log_filename = filename;

        spdlog::set_pattern("%v");

        log_file = spdlog::rotating_logger_mt(
            "ob_logger", log_filename.generic_string().c_str(),
            1048576 * log_size, log_limit, true);

        if (log_file == nullptr) {
            return false;
        }
        spdlog::flush_every(std::chrono::seconds(1));
        spdlog::set_default_logger(log_file);
    }

    std::time_t result = std::time(nullptr);

    LogPrintf("====== START OF OBSIDIAN LOGS ======\n\n");

    LogPrintf("Initialized on {}", 
        std::ctime(&result));

    return true;
}

bool RefInit(const std::filesystem::path &filename) {
    if (!filename.empty()) {
        ref_filename = filename;

        // Clear previously generated reference if present
        if (std::filesystem::exists(ref_filename)) {
            std::filesystem::remove(ref_filename);
        }

        ref_file.open(ref_filename, std::ios::out);

        if (!ref_file.is_open()) {
            return false;
        }
    }

    RefPrintf("====== OBSIDIAN REFERENCE for V{} BUILD {} ======\n\n",
              OBSIDIAN_SHORT_VERSION, OBSIDIAN_VERSION);

    return true;
}

void LogEnableDebug(bool enable) {
    if (debugging == enable) {
        return;
    }

    debugging = enable;

    if (debugging) {
        LogPrintf("===  DEBUGGING ENABLED  ===\n\n");
    } else {
        LogPrintf("===  DEBUGGING DISABLED  ===\n\n");
    }
}

void LogEnableTerminal(bool enable) { terminal = enable; }

void LogClose(void) {
    LogPrintf("\n====== END OF OBSIDIAN LOGS ======\n\n");

    spdlog::shutdown();

    log_filename.clear();

    log_file.reset();
}

void RefClose(void) {
    RefPrintf("\n====== END OF REFERENCE ======\n\n");

    ref_file.close();

    ref_filename.clear();
}

void LogReadLines(log_display_func_t display_func, void *priv_data) {
    if (log_file == nullptr) {
        return;
    }

    // we close the log file so we can read it, and then open it
    // again when finished.  That is because Windows OSes can be
    // fussy about opening already open files (in Linux it would
    // not be an issue).

    spdlog::shutdown();

    std::fstream log_stream;

    log_stream.open(log_filename, std::ios::in);

    // this is very unlikely to happen, but check anyway
    if (!log_stream.is_open()) {
        log_file = spdlog::rotating_logger_mt(
            "ob_logger", log_filename.generic_string().c_str(),
            1048576 * log_size, log_limit);
        if (log_file != nullptr) {
            spdlog::flush_every(std::chrono::seconds(1));
            spdlog::set_default_logger(log_file);
        }
        return;
    }

    std::string buffer;
    while (std::getline(log_stream, buffer)) {
        // remove any newline at the end (LF or CR/LF)
        StringRemoveCRLF(&buffer);

        // remove any DEL characters (mainly to workaround an FLTK bug)
        StringReplaceChar(&buffer, 0x7f, 0);

        std::cout << buffer << std::endl;

        display_func(buffer, priv_data);
    }

    // close the log file after current contents are read
    log_stream.close();

    // open the log file for writing again
    log_file = spdlog::rotating_logger_mt("ob_logger",
                                          log_filename.generic_string().c_str(),
                                          1048576 * log_size, log_limit);
    if (log_file != nullptr) {
        spdlog::flush_every(std::chrono::seconds(1));
        spdlog::set_default_logger(log_file);
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
