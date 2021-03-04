//------------------------------------------------------------------------
//  Utility functions
//------------------------------------------------------------------------
//
//  Copyright (c) 2008-2009  Andrew J Apted
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

#ifndef __LIB_UTIL_H__
#define __LIB_UTIL_H__

/* string utilities */

int StringCaseCmp(const char *A, const char *B);
int StringCaseCmpPartial(const char *A, const char *B);
void StringMaxCopy(char *dest, const char *src, int max);

char *StringUpper(const char *name);
char *StringNew(int length);
char *StringDup(const char *orig);
char *StringPrintf(const char *str, ...); // GCCATTR((format (printf, 1, 2)));
void StringFree(const char *str);

/* time utilities */

u32_t TimeGetMillies();
void TimeDelay(u32_t millies);

/* math utilities */

u32_t IntHash(u32_t key);
u32_t StringHash(const char *str);

#define AlignLen(x)  (((x) + 3) & ~3)

double  PerpDist(double x, double y,
                 double x1, double y1, double x2, double y2);
double AlongDist(double x, double y,
                 double x1, double y1, double x2, double y2);
double CalcAngle(double sx, double sy, double ex, double ey);

double ComputeDist(double sx, double sy, double ex, double ey);
double ComputeDist(double sx, double sy, double sz,
                   double ex, double ey, double ez);

#endif /* __LIB_UTIL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
