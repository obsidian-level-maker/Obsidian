//------------------------------------------------------------------------
//  UTILITY : general purpose functions
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

#ifndef __BRUSHER_UTIL_H__
#define __BRUSHER_UTIL_H__

/* ----- useful macros ---------------------------- */

#define DIST_EPSILON  (1.0 / 128.0)

#ifndef M_PI
#define M_PI  3.14159265358979323846
#endif

#ifndef MAX
#define MAX(x,y)  ((x) > (y) ? (x) : (y))
#endif

#ifndef MIN
#define MIN(x,y)  ((x) < (y) ? (x) : (y))
#endif

#ifndef ABS
#define ABS(x)  ((x) >= 0 ? (x) : -(x))
#endif

#ifndef I_ROUND
#define I_ROUND(x)  int(((x) < 0) ? ((x) - 0.5f) : ((x) + 0.5f))
#endif

/* ----- function prototypes ---------------------------- */

// allocate and clear some memory.  guaranteed not to fail.
void *UtilCalloc(int size);

// re-allocate some memory.  guaranteed not to fail.
void *UtilRealloc(void *old, int size);

// duplicate a string.
char *UtilStrDup(const char *str);
char *UtilStrNDup(const char *str, int size);

// copy the string and make it uppercase
char *UtilStrUpper(const char *name);
  
// free some memory or a string.
void UtilFree(void *data);

// compare two strings case insensitively.
int UtilStrCaseCmp(const char *A, const char *B);

// round a positive value up to the nearest power of two.
int UtilRoundPOW2(int x);

// compute angle & distance from (0,0) to (dx,dy)
double ComputeAngle(double dx, double dy);
double ComputeDist(double dx, double dy);

double  PerpDist(double x, double y,
                 double x1, double y1, double x2, double y2);
double AlongDist(double x, double y,
                 double x1, double y1, double x2, double y2);


// return the millisecond counter.  Note: it WILL overflow.
unsigned int UtilGetMillis();

// --- file utilities ---
bool FileExists(const char *filename);
bool HasExtension(const char *filename);
bool CheckExtension(const char *filename, const char *ext);
const char *ReplaceExtension(const char *filename, const char *ext);
const char *FileBaseName(const char *filename);

#endif /* __BRUSHER_UTIL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
