//------------------------------------------------------------------------
//  MAIN DEFS
//------------------------------------------------------------------------
//
//  Brusher (C) 2012 Andrew Apted
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

#ifndef __BRUSHER_DEFS_H__
#define __BRUSHER_DEFS_H__

//
//  SYSTEM INCLUDES
//
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

#include <string.h>
#include <ctype.h>
#include <errno.h>

#include <math.h>
#include <limits.h>

#ifndef WIN32
#include <sys/time.h>
#endif

#include <map>
#include <string>
#include <vector>

//
//  LOCAL INCLUDES
//
#include "system.h"
#include "util.h"
#include "wad.h"
#include "level.h"

extern FILE *output_fp;

#endif /* __BRUSHER_DEFS_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
