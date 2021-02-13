//------------------------------------------------------------------------
//
//  AJ-Polygonator (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#ifndef __AJPOLY_UTIL_H__
#define __AJPOLY_UTIL_H__

/* ----- TYPES ----------------------------------- */

typedef signed char  s8_t;
typedef signed short s16_t;
typedef signed int   s32_t;
   
typedef unsigned char  u8_t;
typedef unsigned short u16_t;
typedef unsigned int   u32_t;

typedef u8_t  byte;


/* ----- MARCOS ------------------------------------- */

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
#define I_ROUND(x)  ((int) (((x) < 0.0f) ? ((x) - 0.5f) : ((x) + 0.5f)))
#endif


/* ----- CONSTANTS ---------------------------------- */

// smallest distance between two points before being considered equal
#define DIST_EPSILON  (1.0 / 128.0)

// smallest degrees between two angles before being considered equal
#define ANG_EPSILON  (1.0 / 1024.0)


/* ----- FUNCTIONS ---------------------------------- */

// set message for certain errors
void SetErrorMsg(const char *str, ...);

// compute angle for a 2D vector
double ComputeAngle(double dx, double dy);


#endif /* __AJPOLY_UTIL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
