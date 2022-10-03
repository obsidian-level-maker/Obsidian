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
#include "sinks/basic_file_sink.h"

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

        log_file = spdlog::basic_logger_mt("basic_logger", log_filename.generic_string().c_str());

        if (log_file == nullptr) {
            return false;
        }
        spdlog::set_default_logger(log_file);
    }

    LogPrintf("====== START OF OBSIDIAN LOGS ======\n");

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

    std::filesystem::path bare_log = log_filename;
    std::filesystem::path oldest_log;
    int numlogs = 0;

    for (const std::filesystem::directory_entry &dir_entry :
         std::filesystem::directory_iterator{bare_log.remove_filename()}) {
        std::filesystem::path entry = dir_entry.path();
        if ((StringCaseCmp(entry.extension().string(), ".txt") == 0 ||
             StringCaseCmp(entry.extension().string(), ".zip") == 0) &&
            StringCaseCmpPartial(entry.filename().string(), "LOGS") == 0) {
            numlogs++;
            if (oldest_log.empty() ||
                std::filesystem::last_write_time(entry) <
                    std::filesystem::last_write_time(oldest_log)) {
                oldest_log = entry;
            }
        }
    }

    if (numlogs > log_limit) {
        std::filesystem::remove(oldest_log);
    }

    std::filesystem::path new_logpath;
    std::string new_filename;

    if (timestamp_logs) {
        new_logpath = log_filename;
        new_logpath.remove_filename();
        new_filename = "LOGS_";
        new_filename.append(log_timestamp);
        new_logpath.append(new_filename);
        if (std::filesystem::exists(new_logpath)) {
            std::filesystem::remove(new_logpath);
        }
        std::filesystem::rename(log_filename, new_logpath);
    }

    log_filename.clear();
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
        log_file = spdlog::basic_logger_mt("basic_logger", log_filename.generic_string().c_str());
        spdlog::set_default_logger(log_file);
        if (log_file != nullptr) {
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
    log_file = spdlog::basic_logger_mt("basic_logger", log_filename.generic_string().c_str());
    if (log_file != nullptr) {
        spdlog::set_default_logger(log_file);
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
