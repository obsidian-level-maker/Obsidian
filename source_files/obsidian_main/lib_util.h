//------------------------------------------------------------------------
//  Utility functions
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

#include <string>

/* string utilities */

#ifdef _WIN32
// Technically these are to and from UTF-16, but since these are only for
// Windows "wide" APIs I think we'll be ok - Dasho
std::string  WStringToUTF8(std::wstring_view instring);
std::wstring UTF8ToWString(std::string_view instring);
#endif
int StringCaseCompareASCII(std::string_view A, std::string_view B);
int StringPrefixCaseCompareASCII(std::string_view A, std::string_view B);
std::string StringUpperASCII(std::string_view instring);
std::string StringFormat(const char* fmt, ...);
std::string NumberToString(int value);
std::string NumberToString(unsigned long long int value);
std::string NumberToString(double value);
int         StringToInt(std::string_view value);
int         StringToHex(std::string_view value);
double      StringToDouble(std::string_view value);

/* time utilities */

uint32_t TimeGetMillies();

/* math utilities */

uint32_t IntHash(uint32_t key);
uint32_t StringHash(std::string_view str);
uint64_t StringHash64(std::string_view str);

#define OBSIDIAN_ALIGN_LENGTH(x) (((x) + 3) & ~3)

double PerpDist(double x, double y, double x1, double y1, double x2, double y2);
double AlongDist(double x, double y, double x1, double y1, double x2,
                 double y2);

double CalcAngle(double sx, double sy, double ex, double ey);
double DiffAngle(double A, double B);  // A + result = B

double ComputeDist(double sx, double sy, double ex, double ey);
double ComputeDist(double sx, double sy, double sz, double ex, double ey,
                   double ez);

double PointLineDist(double x, double y, double x1, double y1, double x2,
                     double y2);

void CalcIntersection(double nx1, double ny1, double nx2, double ny2,
                      double px1, double py1, double px2, double py2, double* x,
                      double* y);

std::pair<double, double> AlongCoord(double along, double px1, double py1,
                                     double px2, double py2);

bool VectorSameDir(double dx1, double dy1, double dx2, double dy2);

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
