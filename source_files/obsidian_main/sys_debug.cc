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

#define DEBUG_BUF_LEN 20000

std::fstream log_file;
std::fstream ref_file;
std::filesystem::path log_filename;
std::filesystem::path ref_filename;

bool debugging = false;
bool terminal = false;

bool LogInit(const std::filesystem::path &filename) {
    if (!filename.empty()) {
        log_filename = filename;

        log_file.open(log_filename, std::ios::out);

        if (!log_file.is_open()) {
            return false;
        }
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

    log_file.close();

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

    if (zip_logs) {
        std::filesystem::path txt_filename;
        std::filesystem::path zip_filename;
        if (timestamp_logs) {
            txt_filename = new_logpath;
            zip_filename = new_logpath;
        } else {
            txt_filename = log_filename;
            zip_filename = log_filename;
        }
        zip_filename.replace_extension("zip");
        if (std::filesystem::exists(zip_filename)) {
            std::filesystem::remove(zip_filename);
        }
        FILE *zip_file = fopen(txt_filename.string().c_str(), "rb");
        int zip_length = std::filesystem::file_size(txt_filename);
        byte *zip_buf = new byte[zip_length];
        if (zip_buf && zip_file) {
            memset(zip_buf, 0, zip_length);
            fread(zip_buf, 1, zip_length, zip_file);
        }
        if (zip_file) {
            fclose(zip_file);
        }
        if (zip_buf) {
            if (mz_zip_add_mem_to_archive_file_in_place(
                    zip_filename.string().c_str(),
                    txt_filename.filename().string().c_str(), zip_buf,
                    zip_length, NULL, 0, MZ_DEFAULT_COMPRESSION)) {
                std::filesystem::remove(txt_filename);
                delete[] zip_buf;
            } else {
                fmt::print(
                    "Zipping logs to {} failed! Retaining original "
                    "logs.\n",
                    txt_filename.generic_string());
            }
        } else {
            fmt::print(
                "Zipping logs to {} failed! Retaining original "
                "logs.\n",
                txt_filename.generic_string());
        }
    }

    log_filename.clear();
}

void RefClose(void) {
    RefPrintf("\n====== END OF REFERENCE ======\n\n");

    ref_file.close();

    ref_filename.clear();
}

void LogReadLines(log_display_func_t display_func, void *priv_data) {
    if (!log_file) {
        return;
    }

    // we close the log file so we can read it, and then open it
    // again when finished.  That is because Windows OSes can be
    // fussy about opening already open files (in Linux it would
    // not be an issue).

    log_file.close();

    log_file.open(log_filename, std::ios::in);

    // this is very unlikely to happen, but check anyway
    if (!log_file.is_open()) {
        return;
    }

    std::string buffer;
    while (std::getline(log_file, buffer)) {
        // remove any newline at the end (LF or CR/LF)
        StringRemoveCRLF(&buffer);

        // remove any DEL characters (mainly to workaround an FLTK bug)
        StringReplaceChar(&buffer, 0x7f, 0);

        std::cout << buffer << std::endl;

        display_func(buffer, priv_data);
    }

    // close the log file after current contents are read
    log_file.close();

    // open the log file for writing again
    // [ it is unlikely to fail, but if it does then no biggie ]
    log_file.open(log_filename, std::ios::app);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
