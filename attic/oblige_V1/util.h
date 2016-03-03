//------------------------------------------------------------------------
//  UTILITY : general purpose functions
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

#ifndef __OBLIGE_UTIL_H__
#define __OBLIGE_UTIL_H__

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

// free some memory or a string.
void UtilFree(void *data);

// compare two strings case insensitively.
int UtilStrCaseCmp(const char *A, const char *B);

// round a positive value up to the nearest power of two.
int UtilRoundPOW2(int x);

// compute angle & distance from (0,0) to (dx,dy)
angle_g UtilComputeAngle(double dx, double dy);
#define UtilComputeDist(dx,dy)  sqrt((dx) * (dx) + (dy) * (dy))

// compute the parallel and perpendicular distances from a partition
// line to a point.
//
#define UtilParallelDist(part,x,y)  \
    (((x) * (part)->pdx + (y) * (part)->pdy + (part)->p_para)  \
     / (part)->p_length)

#define UtilPerpDist(part,x,y)  \
    (((x) * (part)->pdy - (y) * (part)->pdx + (part)->p_perp)  \
     / (part)->p_length)

// return the millisecond counter.  Note: it WILL overflow.
unsigned int UtilGetMillis();

// --- file utilities ---
bool FileExists(const char *filename);
bool HasExtension(const char *filename);
bool CheckExtension(const char *filename, const char *ext);
const char *ReplaceExtension(const char *filename, const char *ext);
const char *FileBaseName(const char *filename);

// --- random numbers ---
int RandomRange(int low, int high);
int RandomShuffle(int *values, int size, bool fill = false);

#define RandomIndex(TOP)     RandomRange(0, (TOP)-1)
#define RandomOdds(X,Y)      ((X) > RandomIndex(Y))
#define RandomPerc(X)        (RandomIndex(100) < (X))
#define RandomBool()         RandomOdds(1,2) // !!!! RandomPerc(50)

void UtilSort(int *values, int size);

#endif /* __OBLIGE_UTIL_H__ */
