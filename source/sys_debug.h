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

#ifndef __SYS_DEBUG_H__
#define __SYS_DEBUG_H__

#include <filesystem>

extern bool terminal;
extern bool debugging;

bool LogInit(const std::filesystem::path &filename);
void LogClose(void);

void LogEnableDebug(bool enable);
void LogEnableTerminal(bool enable);

#ifdef __GNUC__
void              LogPrintf(const char *message, ...) __attribute__((format(printf, 1, 2)));
void              DebugPrintf(const char *message, ...) __attribute__((format(printf, 1, 2)));
[[noreturn]] void ErrorPrintf(const char *message, ...) __attribute__((format(printf, 1, 2)));
#else
void              LogPrintf(const char *message, ...);
void              DebugPrintf(const char *message, ...);
[[noreturn]] void ErrorPrintf(const char *message, ...);
#endif

#if defined(__GNUC__)
#define SYS_ASSERT(cond)                                                                                               \
    ((cond) ? (void)0                                                                                                  \
            : ErrorPrintf("Assertion (%s) failed\nIn function %s (%s:%d)\n", #cond, __func__, __FILE__, __LINE__))

#else
#define SYS_ASSERT(cond)                                                                                               \
    ((cond) ? (void)0 : ErrorPrintf("Assertion (%s) failed\nIn file %s:%d\n", #cond, __FILE__, __LINE__))

#endif

#define SYS_NULL_CHECK(ptr) SYS_ASSERT((ptr) != NULL)

#endif /* __SYS_DEBUG_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
