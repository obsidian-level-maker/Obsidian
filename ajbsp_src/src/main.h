//------------------------------------------------------------------------
//  MAIN DEFINITIONS
//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2001-2018  Andrew Apted
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
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

#ifndef __AJBSP_MAIN_H__
#define __AJBSP_MAIN_H__


#define AJBSP_VERSION  "1.01"


/*
 *  Windows support
 */

#if defined(WIN32) || defined(_WIN32) || defined(_WIN64)
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
  #ifndef WIN32
  #define WIN32
  #endif
#endif


/*
 *  Standard headers
 */

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <ctype.h>
#include <limits.h>
#include <errno.h>
#include <math.h>

#ifndef WIN32
#include <unistd.h>
#endif

#include <vector>


/*
 *  code headers
 */

#include "sys_type.h"
#include "sys_macro.h"
#include "sys_endian.h"

#include "lib_util.h"
#include "lib_file.h"
#include "w_rawdef.h"
#include "w_wad.h"

#include "bsp.h"


/*
 *  Misc constants
 */

#define AJ_PATH_MAX  4096

#define MSG_BUF_LEN  1024


/*
 *  Global variables
 */

extern int opt_verbosity;	// 0 is normal, 1+ is verbose

extern const char *Level_name;  // Name of map lump we are editing

extern map_format_e Level_format; // format of current map


/*
 *  Global functions
 */

#ifdef __GNUC__
__attribute__((noreturn))
#endif
void FatalError(const char *fmt, ...);

void PrintMsg(const char *fmt, ...);
void PrintVerbose(const char *fmt, ...);
void PrintDetail(const char *fmt, ...);

void DebugPrintf(const char *fmt, ...);

void PrintMapName(const char *name);

#define BugError  FatalError


/*
 *  Assertions
 */

#if defined(__GNUC__)
#define SYS_ASSERT(cond)  ((cond) ? (void)0 :  \
        BugError("Assertion (%s) failed\nIn function %s (%s:%d)\n", #cond , __func__, __FILE__, __LINE__))

#else
#define SYS_ASSERT(cond)  ((cond) ? (void)0 :  \
        BugError("Assertion (%s) failed\nIn file %s:%d\n", #cond , __FILE__, __LINE__))
#endif


#endif  /* __AJBSP_MAIN_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
