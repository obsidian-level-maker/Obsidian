//------------------------------------------------------------------------
//  Macros
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

#pragma once

#include <math.h>
#include <stdint.h>

constexpr const char *BLANKOUT =
    "                                                                                           "
    "                                                                                           "
    "                                                                    ";

// basic constants
constexpr uint16_t OBSIDIAN_MSG_BUF_LEN  = 2000;
constexpr double   OBSIDIAN_POLY_EPSILON = (1.0 / 128.0);
constexpr double   OBSIDIAN_DIST_EPSILON = (1.0 / 1024.0);
constexpr double   OBSIDIAN_ANG_EPSILON  = (1.0 / 1024.0);
constexpr double   OBSIDIAN_PI           = 3.14159265358979323846;

// basic math
#define OBSIDIAN_MAX(a, b)           ((a > b) ? a : b)
#define OBSIDIAN_MIN(a, b)           ((a < b) ? a : b)
#define OBSIDIAN_ABS(a)              ((a < 0) ? -a : a)
#define OBSIDIAN_CLAMP(low, x, high) ((x < low) ? low : ((x > high) ? high : x))
#define OBSIDIAN_I_ROUND(x)          ((int)(((x) < 0.0f) ? ((x) - 0.5f) : ((x) + 0.5f)))

// colors
#define OBSIDIAN_MAKE_RGBA(r, g, b, a) (((r) << 24) | ((g) << 16) | ((b) << 8) | (a))
#define OBSIDIAN_RGB_RED(col)          ((col >> 24) & 255)
#define OBSIDIAN_RGB_GREEN(col)        ((col >> 16) & 255)
#define OBSIDIAN_RGB_BLUE(col)         ((col >> 8) & 255)
#define OBSIDIAN_RGB_ALPHA(col)        ((col) & 255)

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
