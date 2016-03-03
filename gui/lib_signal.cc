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

#include "headers.h"

#include <algorithm>

#include "lib_signal.h"
#include "lib_util.h"

#include "main.h"


#define EXCESSIVE_LOOPS  128


class signal_pair_c
{
public:
	const char *name;

	signal_notify_f func;

	void *priv_dat;

public:
	signal_pair_c(const char *_name, signal_notify_f _func, void *_priv) :
		func(_func), priv_dat(_priv)
	{
		name = StringDup(_name);
	}

	~signal_pair_c()
	{
		StringFree(name);
	}
};


static std::vector<signal_pair_c *> sig_list;

static std::list<const char *> pending_sigs;

static const char * signal_in_progress = NULL;


void Signal_Watch(const char *name, signal_notify_f func, void *priv_dat)
{
	// check if already exists
	for (unsigned int i = 0; i < sig_list.size(); i++)
	{
		signal_pair_c *P = sig_list[i];

		if (strcmp(P->name, name) == 0 && P->func == func)
		{
			P->priv_dat = priv_dat;
			return;
		}
	}

	sig_list.push_back(new signal_pair_c(name, func, priv_dat));
}


void Signal_DontCare(const char *name, signal_notify_f func)
{
	for (unsigned int i = 0; i < sig_list.size(); i++)
	{
		signal_pair_c *P = sig_list[i];

		if (strcmp(P->name, name) == 0 && P->func == func)
		{
			delete P;
			sig_list[i] = NULL;

			break;
		}
	}

	// remove NULL pointer(s) from the list
	std::vector<signal_pair_c *>::iterator ENDP;

	ENDP = std::remove(sig_list.begin(), sig_list.end(), (signal_pair_c*)NULL);

	sig_list.erase(ENDP, sig_list.end());
}


void Signal_Raise(const char *name)
{
	if (signal_in_progress)
	{
#if 0
		if (strcmp(signal_in_progress, name) == 0)
		{
			DebugPrintf("Signal '%s' raised when already in progress\n", name);
			return;
		}
#endif

		std::list<const char *>::iterator LI;

		for (LI = pending_sigs.begin(); LI != pending_sigs.end(); LI++)
		{
			if (strcmp(*LI, name) == 0)
			{
				DebugPrintf("Signal '%s' raised when already pending\n", name);
				return;
			}
		}

		pending_sigs.push_back(StringDup(name));
		return;
	}

	int loop_count = 0;

	// memory management strategy:
	//   - copy names when added in the pending list
	//   - free names after we perform a notification run

	name = StringDup(name);

	for (;;)
	{
		loop_count++;
		if (loop_count >= EXCESSIVE_LOOPS)
			Main_FatalError("Signal_Raise(%s) : excessive looping!\n", name);

		signal_in_progress = name;

		for (unsigned int i = 0; i < sig_list.size(); i++)
		{
			signal_pair_c *P = sig_list[i];

			if (strcmp(P->name, name) != 0)
				continue;

			(* P->func)(name, P->priv_dat);
		}

		signal_in_progress = NULL;

		StringFree(name);

		if (pending_sigs.empty())
			break;

		name = pending_sigs.front();
		pending_sigs.pop_front();
	}
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
