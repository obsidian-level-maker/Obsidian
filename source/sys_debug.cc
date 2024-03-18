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
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "sys_debug.h"

#include "lib_util.h"
#include "m_lua.h"
#include "main.h"

#define DEBUG_BUF_LEN 20000

FILE                 *log_file = nullptr;
std::filesystem::path log_filename;

bool debugging = false;
bool terminal  = false;

void LogPrintf(const char *message, ...)
{
    if (!log_file && !terminal)
        return;

    char message_buf[4096];

    message_buf[4095] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    // I hope nobody is printing strings longer than 4096 chars...
    SYS_ASSERT(message_buf[4095] == 0);

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

void DebugPrintf(const char *message, ...)
{
    if (!debugging || (!log_file && !terminal))
        return;

    char message_buf[4096];

    message_buf[4095] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    // I hope nobody is printing strings longer than 4096 chars...
    SYS_ASSERT(message_buf[4095] == 0);

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

[[noreturn]] void ErrorPrintf(const char *message, ...)
{
    char message_buf[4096];

    message_buf[4095] = 0;

    // Print the message into a text string
    va_list argptr;

    va_start(argptr, message);
    vsprintf(message_buf, message, argptr);
    va_end(argptr);

    // I hope nobody is printing strings longer than 4096 chars...
    SYS_ASSERT(message_buf[4095] == 0);

    if (log_file)
    {
        fprintf(log_file, "ERROR: %s", message_buf);
        fflush(log_file);
    }

    if (terminal)
        printf("ERROR: %s", message_buf);

    Main::Shutdown();
#if defined WIN32 && !defined CONSOLE_ONLY
    if (batch_mode)
    {
        printf("\nClose window when finished...");
        do
        {
        } while (true);
    }
#endif
    std::exit(9);
}

bool LogInit(const std::filesystem::path &filename)
{
    if (!filename.empty())
    {
        log_filename = filename;

#ifdef _WIN32
        log_file = _wfopen(log_filename.c_str(), L"w");
#else
        log_file = fopen(log_filename.generic_u8string().c_str(), "w");
#endif

        if (!log_file)
        {
            return false;
        }
    }

    std::time_t result = std::time(nullptr);

    LogPrintf("====== START OF OBSIDIAN LOGS ======\n\n");

    LogPrintf("Initialized on %s", std::ctime(&result));

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
        LogPrintf("===  DEBUGGING ENABLED  ===\n\n");
    }
    else
    {
        LogPrintf("===  DEBUGGING DISABLED  ===\n\n");
    }
}

void LogEnableTerminal(bool enable)
{
    terminal = enable;
}

void LogClose(void)
{
    LogPrintf("\n====== END OF OBSIDIAN LOGS ======\n\n");

    if (log_file)
        fclose(log_file);

    log_filename.clear();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
