//------------------------------------------------------------------------
//  Utility functions
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

#ifndef __LIB_UTIL_H__
#define __LIB_UTIL_H__

/* string utilities */

int StringCaseCmp(const char *A, const char *B);
int StringCaseCmpPartial(const char *A, const char *B);
void StringMaxCopy(char *dest, const char *src, int max);

char *StringUpper(const char *name);
char *StringNew(int length);
char *StringDup(const char *orig, int limit = -1);
char *StringPrintf(const char *str, ...); // GCCATTR((format (printf, 1, 2)));
void StringFree(const char *str);

char *mem_gets(char *buf, int size, const char ** str_ptr);

/* time utilities */

u32_t TimeGetMillies();
void TimeDelay(u32_t millies);

/* math utilities */

u32_t IntHash(u32_t key);
u32_t StringHash(const char *str);

#define ALIGN_LEN(x)  (((x) + 3) & ~3)

double  PerpDist(double x, double y,
                 double x1, double y1, double x2, double y2);
double AlongDist(double x, double y,
                 double x1, double y1, double x2, double y2);

double CalcAngle(double sx, double sy, double ex, double ey);
double DiffAngle(double A, double B);  // A + result = B

double ComputeDist(double sx, double sy, double ex, double ey);
double ComputeDist(double sx, double sy, double sz,
                   double ex, double ey, double ez);

double PointLineDist(double x, double y,
                     double x1, double y1, double x2, double y2); 

void CalcIntersection(double nx1, double ny1, double nx2, double ny2,
                      double px1, double py1, double px2, double py2,
                      double *x, double *y);

void AlongCoord(double along, double px1, double py1, double px2, double py2,
                double *x, double *y);

bool VectorSameDir(double dx1, double dy1, double dx2, double dy2);

#endif /* __LIB_UTIL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
