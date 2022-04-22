//------------------------------------------------------------------------
//  Simple Signals
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

#include "lib_signal.h"

#include <algorithm>

#include "fmt/format.h"
#include "headers.h"
#include "lib_util.h"
#include "main.h"

#define EXCESSIVE_LOOPS 128

class signal_pair_c {
   public:
    std::string name;

    signal_notify_f func;

    void *priv_dat;

   public:
    signal_pair_c(const char *_name, signal_notify_f _func, void *_priv)
        : func(_func), priv_dat(_priv) {
        name = _name;
    }
};

static std::vector<signal_pair_c *> sig_list;

static std::list<std::string> pending_sigs;

static const char *signal_in_progress = NULL;

void Signal_Watch(const char *name, signal_notify_f func, void *priv_dat) {
    // check if already exists
    for (unsigned int i = 0; i < sig_list.size(); i++) {
        signal_pair_c *P = sig_list[i];

        if (P->name == name && P->func == func) {
            P->priv_dat = priv_dat;
            return;
        }
    }

    sig_list.push_back(new signal_pair_c(name, func, priv_dat));
}

void Signal_DontCare(const char *name, signal_notify_f func) {
    for (unsigned int i = 0; i < sig_list.size(); i++) {
        signal_pair_c *P = sig_list[i];

        if (P->name == name && P->func == func) {
            delete P;
            sig_list[i] = NULL;

            break;
        }
    }

    // remove NULL pointer(s) from the list
    std::vector<signal_pair_c *>::iterator ENDP;

    ENDP = std::remove(sig_list.begin(), sig_list.end(), (signal_pair_c *)NULL);

    sig_list.erase(ENDP, sig_list.end());
}

void Signal_Raise(std::string name) {
    if (signal_in_progress) {
#if 0
        if (strcmp(signal_in_progress, name) == 0)
        {
            DebugPrintf("Signal '{}' raised when already in progress\n", name);
            return;
        }
#endif

        for (auto LI = pending_sigs.begin(); LI != pending_sigs.end(); LI++) {
            if (*LI == name) {
                DebugPrintf(
                    fmt::format("Signal '{}' raised when already pending\n",
                                name)
                        .c_str());
                return;
            }
        }

        pending_sigs.emplace_back(name);
        return;
    }

    int loop_count = 0;

    // memory management strategy:
    //   - copy names when added in the pending list
    //   - free names after we perform a notification run

    for (;;) {
        loop_count++;
        if (loop_count >= EXCESSIVE_LOOPS) {
            Main::FatalError("Signal_Raise({}) : excessive looping!\n", name);
        }

        signal_in_progress = name.c_str();

        for (unsigned int i = 0; i < sig_list.size(); i++) {
            signal_pair_c *P = sig_list[i];

            if (P->name != name) {
                continue;
            }

            (*P->func)(name.c_str(), P->priv_dat);
        }

        signal_in_progress = NULL;

        if (pending_sigs.empty()) {
            break;
        }

        name = pending_sigs.front();
        pending_sigs.pop_front();
    }
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
