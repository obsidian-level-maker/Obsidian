//------------------------------------------------------------------------
//  Simple Signaling
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

#ifndef __LIB_SIGNAL_H__
#define __LIB_SIGNAL_H__

typedef void (* signal_notify_f)(const char *name, void *priv_dat);

void Signal_Watch(const char *name, signal_notify_f func, void *priv_dat = NULL);
// adds a signal notifier function for the signal name.
// If the same name/func pair already exists, it is simply
// replaced (useful for changing the private data pointer).

void Signal_DontCare(const char *name, signal_notify_f func);
// stop watching the given signal.

void Signal_Raise(const char *name);
// raises the named signal.  If this is called during a
// signal notification run, then it is remembered and another
// run will occur after the current run, even if the raised
// signal is the same one.
//
// Care must be taked to prevent infinite loops (excessive
// looping will be detected and cause a fatal error).

#endif /* __LIB_SIGNAL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
