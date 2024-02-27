//------------------------------------------------------------------------
//  Constants/Macros/Inlines
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

#pragma once

// basic constants
constexpr uint16_t kMessageBufferLength = 2000;
constexpr double   kDistanceEpsilon     = (1.0 / 128.0);
constexpr double   kAngleEpsilon        = (1.0 / 1024.0);
constexpr double   kPiApproximate       = 3.14159265358979323846;

// basic math
#define OBSIDIAN_MAX(a, b)           ((a > b) ? a : b)
#define OBSIDIAN_MIN(a, b)           ((a < b) ? a : b)
#define OBSIDIAN_ABS(a)              ((a < 0) ? -a : a)
#define OBSIDIAN_CLAMP(low, x, high) ((x < low) ? low : ((x > high) ? high : x))
inline int RoundToInteger(float x) { return (int)roundf(x); }
inline int RoundToInteger(double x) { return (int)round(x); }

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
