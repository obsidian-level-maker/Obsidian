//------------------------------------------------------------------------
//  Debugging support
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2025 The OBSIDIAN Team
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

#include "sys_debug.h"

#include <stdarg.h>
#include <time.h>

#include "lib_util.h"
#include "main.h"
#include "sys_assert.h"

static constexpr uint16_t MAX_LOGBUF_SIZE = 16384;
static char *message_buf = nullptr;
static size_t message_buf_size = 128;
static FILE *log_file = nullptr;
std::string  log_filename;

bool debugging = false;
bool terminal  = false;

bool LogInit(const std::string &filename)
{
    if (!filename.empty())
    {
        log_filename = filename;

        log_file = FileOpen(log_filename, "w");

        if (!log_file)
        {
            return false;
        }
    }

    time_t result = time(nullptr);

    LogPrint("====== START OF OBSIDIAN LOGS ======\n\n");

    LogPrint("Initialized on %s", ctime(&result));

    return true;
}

void LogEnableDebug(bool enable)
{
    if (debugging == enable)
    {
        return;
    }

    debugging = enable;

    if (debugging)
    {
        LogPrint("===  DEBUGGING ENABLED  ===\n\n");
    }
    else
    {
        LogPrint("===  DEBUGGING DISABLED  ===\n\n");
    }
}

void LogEnableTerminal(bool enable)
{
    terminal = enable;
}

void LogClose(void)
{
    LogPrint("\n====== END OF OBSIDIAN LOGS ======\n\n");

    fclose(log_file);
    log_file = nullptr;

    log_filename.clear();

    if (message_buf)
    {
        free(message_buf);
        message_buf = nullptr;
        message_buf_size = 128;
    }
}

void LogPrint(const char *message, ...)
{
    if (!log_file && !terminal)
        return;

    if (!message_buf)
        message_buf = (char *)calloc(message_buf_size, sizeof(char));

    for (;;)
    {
        va_list args;

        va_start(args, message);
        int out_len = vsnprintf(message_buf, message_buf_size, message, args);
        va_end(args);

        if (out_len >= 0 && out_len < message_buf_size)
            break;
        if (message_buf_size == MAX_LOGBUF_SIZE)
            break;

        message_buf_size *= 2;
        message_buf = (char *)realloc(message_buf, message_buf_size * sizeof(char));
    }

    if (log_file)
    {
        fprintf(log_file, "%s", message_buf);
        fflush(log_file);
    }

    if (terminal)
    {
        printf("%s", message_buf);
        fflush(stdout);
    }
}

void DebugPrint(const char *message, ...)
{
    if (!debugging || (!log_file && !terminal))
        return;

    if (!message_buf)
        message_buf = (char *)calloc(message_buf_size, sizeof(char));

    for (;;)
    {
        va_list args;

        va_start(args, message);
        int out_len = vsnprintf(message_buf, message_buf_size, message, args);
        va_end(args);

        if (out_len >= 0 && out_len < message_buf_size)
            break;
        if (message_buf_size == MAX_LOGBUF_SIZE)
            break;

        message_buf_size *= 2;
        message_buf = (char *)realloc(message_buf, message_buf_size * sizeof(char));
    }

    if (log_file)
    {
        fprintf(log_file, "DEBUG: %s", message_buf);
        fflush(log_file);
    }

    if (terminal)
    {
        printf("DEBUG: %s", message_buf);
        fflush(stdout);
    }
}

void ProgStatus(const char *message, ...)
{
    if (!message_buf)
        message_buf = (char *)calloc(message_buf_size, sizeof(char));

    for (;;)
    {
        va_list args;

        va_start(args, message);
        int out_len = vsnprintf(message_buf, message_buf_size, message, args);
        va_end(args);

        if (out_len >= 0 && out_len < message_buf_size)
            break;
        if (message_buf_size == MAX_LOGBUF_SIZE)
            break;

        message_buf_size *= 2;
        message_buf = (char *)realloc(message_buf, message_buf_size * sizeof(char));
    }

#ifndef OBSIDIAN_CONSOLE_ONLY
    if (main_win)
    {
        main_win->build_box->SetStatus(message_buf);
    }
    else if (batch_mode)
    {
        if (log_file)
        {
            fprintf(log_file, "%s", message_buf);
            fflush(log_file);
        }

        if (terminal)
        {
            printf("%s", message_buf);
            fflush(stdout);
        }
    }
#else
    if (log_file)
    {
        fprintf(log_file, "%s", message_buf);
        fflush(log_file);
    }

    if (terminal)
    {
        printf("%s", message_buf);
        fflush(stdout);
    }
#endif
}

[[noreturn]] void FatalError(const char *message, ...)
{
    if (!message_buf)
        message_buf = (char *)calloc(message_buf_size, sizeof(char));

    for (;;)
    {
        va_list args;

        va_start(args, message);
        int out_len = vsnprintf(message_buf, message_buf_size, message, args);
        va_end(args);

        if (out_len >= 0 && out_len < message_buf_size)
            break;
        if (message_buf_size == MAX_LOGBUF_SIZE)
            break;

        message_buf_size *= 2;
        message_buf = (char *)realloc(message_buf, message_buf_size * sizeof(char));
    }

    if (log_file)
    {
        fprintf(log_file, "ERROR: %s", message_buf);
        fflush(log_file);
    }

    if (terminal)
        printf("ERROR: %s", message_buf);

#ifndef OBSIDIAN_CONSOLE_ONLY
    DLG_ShowError("%s", message_buf);
#endif

    Main::Shutdown(true);
#if defined _WIN32 && !defined OBSIDIAN_CONSOLE_ONLY
    if (batch_mode)
    {
        printf("\nClose window when finished...");
        do
        {
        } while (true);
    }
#endif
    exit(9);
}

void LogReadLines(log_display_func_t display_func, void *priv_data)
{
    if (!log_file)
    {
        return;
    }

    // we close the log file so we can read it, and then open it
    // again when finished.  That is because Windows OSes can be
    // fussy about opening already open files (in Linux it would
    // not be an issue).

    fclose(log_file);
    log_file = nullptr;

    log_file = FileOpen(log_filename, "r");

    // this is very unlikely to happen, but check anyway
    if (!log_file)
    {
        return;
    }

    std::string buffer;
    int         c = EOF;
    for (;;)
    {
        buffer.clear();
        while ((c = fgetc(log_file)) != EOF)
        {
            if (c == '\n' || c == '\r')
                break;
            else
                buffer.push_back(c);
        }

        buffer.push_back('\n');

        display_func(buffer, priv_data);

        if (feof(log_file) || ferror(log_file))
            break;
    }

    // close the log file after current contents are read
    fclose(log_file);
    log_file = nullptr;

    // open the log file for writing again
    log_file = FileOpen(log_filename, "a");
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
