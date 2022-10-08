//------------------------------------------------------------------------
//  INCLUDES
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

#ifndef __OBLIGE_INCLUDES_H__
#define __OBLIGE_INCLUDES_H__

// we C++
#ifdef NULL
#undef NULL
#endif
#define NULL nullptr

/* OS specifics */
#ifdef WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#else
#ifndef CONSOLE_ONLY
#include <fontconfig/fontconfig.h>
#define USE_XFT 1
#endif
#endif

/* C library */

#include <cstdio>

#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <math.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

/* STL goodies */

#include <list>
#include <map>
#include <string>
#include <vector>

/* Our own system defs */

#include "sys_assert.h"
#include "sys_debug.h"
#include "sys_endian.h"
#include "sys_macro.h"
#include "sys_type.h"

#define HAVE_PHYSFS 1

#define MSG_BUF_LEN 2000

/* Internationalization / Localization */

#define _(s) ob_gettext(s)
#define N_(s) (s)

const char *ob_gettext(const char *s);

#endif /* __OBLIGE_INCLUDES_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
