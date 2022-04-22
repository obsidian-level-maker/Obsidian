//------------------------------------------------------------------------
//  Argument library
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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

#include "lib_argv.h"

#include "headers.h"
#include "lib_util.h"

std::vector<std::string> argv::list;

//
// ArgvInit
//
// Initialise argument list.  Do NOT include the program name
// (usually in argv[0]).  The strings (and array) are copied.
//
// NOTE: doesn't merge multiple uses of an option, hence
//       using ArgvFind() will only return the first usage.
//
void argv::Init(const int argc, const char *const *argv) {
    list.resize(argc);
    SYS_ASSERT(argv::list.size() >= 0);

    int dest = 0;

    for (size_t i = 0; i < list.size(); i++) {
        const char *cur = argv[i];
        SYS_NULL_CHECK(cur);

#ifdef __APPLE__
        // ignore MacOS X rubbish
        if (strncmp(cur, "-psn", 4) == 0) continue;
#endif

        // support GNU-style long options
        if (cur[0] == '-' && cur[1] == '-' && isalnum(cur[2])) {
            cur++;
        }

        list[dest] = cur;

        // support DOS-style short options
        if (cur[0] == '/' && (isalnum(cur[1]) || cur[1] == '?') &&
            cur[2] == '\0') {
            list[dest] = "-";
        }

        dest++;
    }

    list.resize(dest);
}

int argv::Find(const char shortName, const char *longName, int *numParams) {
    SYS_ASSERT(shortName || longName);

    if (numParams) {
        *numParams = 0;
    }

    size_t p = 0;

    for (; p < list.size(); ++p) {
        if (!IsOption(p)) {
            continue;
        }

        const std::string &str = list[p];

        if (shortName && (shortName == tolower(str[1])) && str[2] == 0) {
            break;
        }

        if (longName &&
            StringCaseCmp(longName,
                          std::string_view{&str[1], (str.size() - 1)}) == 0) {
            break;
        }
    }

    if (p == list.size()) {
        // NOT FOUND
        return -1;
    }

    if (numParams) {
        size_t q = p + 1;

        while (q < list.size() && !IsOption(q)) {
            ++q;
        }

        *numParams = q - p - 1;
    }

    return p;
}

bool argv::IsOption(const int index) { return list.at(index)[0] == '-'; }

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
