//------------------------------------------------------------------------
//  UTILITIES
//------------------------------------------------------------------------
//
//  Copyright (C) 2001-2018 Andrew Apted
//  Copyright (C) 1997-2003 André Majorel et al
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

#include "ajbsp_main.h"

#include <sys/time.h>
#include <time.h>


//
// a case-insensitive strcmp()
// replaces StringCaseCmp
int y_stricmp(const char *s1, const char *s2)
{
	for (;;)
	{
		if (tolower(*s1) != tolower(*s2))
			return (int)(unsigned char)(*s1) - (int)(unsigned char)(*s2);

		if (*s1 && *s2)
		{
			s1++;
			s2++;
			continue;
		}

		// both *s1 and *s2 must be zero
		return 0;
	}
}


//
// a case-insensitive strncmp()
//
int y_strnicmp(const char *s1, const char *s2, size_t len)
{
	SYS_ASSERT(len != 0);

	while (len-- > 0)
	{
		if (tolower(*s1) != tolower(*s2))
			return (int)(unsigned char)(*s1) - (int)(unsigned char)(*s2);

		if (*s1 && *s2)
		{
			s1++;
			s2++;
			continue;
		}

		// both *s1 and *s2 must be zero
		return 0;
	}

	return 0;
}


//
// upper-case a string (in situ)
// replaces StringUpper
void y_strupr(char *str)
{
	for ( ; *str ; str++)
	{
		*str = toupper(*str);
	}
}


//
// lower-case a string (in situ)
//
void y_strlowr(char *str)
{
	for ( ; *str ; str++)
	{
		*str = tolower(*str);
	}
}


char *StringNew(int length)
{
	// length does not include the trailing NUL.

	char *s = (char *) calloc(length + 1, 1);

	if (! s)
		FatalError("Out of memory (%d bytes for string)\n", length);

	return s;
}


char *StringDup(const char *orig, int limit)
{
	if (! orig)
		return NULL;

	if (limit < 0)
	{
		char *s = strdup(orig);

		if (! s)
			FatalError("Out of memory (copy string)\n");

		return s;
	}

	char * s = StringNew(limit+1);
	strncpy(s, orig, limit);
	s[limit] = 0;

	return s;
}


char *StringUpper(const char *name)
{
	char *copy = StringDup(name);

	for (char *p = copy; *p; p++)
		*p = toupper(*p);

	return copy;
}


char *StringPrintf(const char *str, ...)
{
	// Algorithm: keep doubling the allocated buffer size
	// until the output fits. Based on code by Darren Salt.

	char *buf = NULL;
	int buf_size = 128;

	for (;;)
	{
		va_list args;
		int out_len;

		buf_size *= 2;

		buf = (char*)realloc(buf, buf_size);
		if (!buf)
			FatalError("Out of memory (formatting string)\n");

		va_start(args, str);
		out_len = vsnprintf(buf, buf_size, str, args);
		va_end(args);

		// old versions of vsnprintf() simply return -1 when
		// the output doesn't fit.
		if (out_len < 0 || out_len >= buf_size)
			continue;

		return buf;
	}
}


void StringFree(const char *str)
{
	if (str)
	{
		free((void*) str);
	}
}


void StringRemoveCRLF(char *str)
{
	size_t len = strlen(str);

	if (len > 0 && str[len - 1] == '\n')
		str[--len] = 0;

	if (len > 0 && str[len - 1] == '\r')
		str[--len] = 0;
}


char * StringTidy(const char *str, const char *bad_chars)
{
	char *buf  = StringNew(strlen(str) + 2);
	char *dest = buf;

	for ( ; *str ; str++)
		if (isprint(*str) && ! strchr(bad_chars, *str))
			*dest++ = *str;

	*dest = 0;

	return buf;
}


void TimeDelay(unsigned int millies)
{
	SYS_ASSERT(millies < 300000);

#ifdef WIN32
	::Sleep(millies);

#else // LINUX or MacOSX

	usleep(millies * 1000);
#endif
}


unsigned int TimeGetMillies()
{
	// Note: you *MUST* handle overflow (it *WILL* happen)

#ifdef WIN32
	return GetTickCount();
#else
	struct timeval tv;
	struct timezone tz;

	gettimeofday(&tv, &tz);

	return ((int)tv.tv_sec * 1000 + (int)tv.tv_usec / 1000);
#endif
}


//
// sanity checks for the sizes and properties of certain types.
// useful when porting.
//

#define assert_size(type,size)            \
  do                  \
  {                 \
    if (sizeof (type) != size)            \
      FatalError("sizeof " #type " is %d (should be " #size ")\n",  \
  (int) sizeof (type));           \
  }                 \
  while (0)

#define assert_wrap(type,high,low)          \
  do                  \
  {                 \
    type n = high;              \
    if (++n != low)             \
      FatalError("Type " #type " wraps around to %lu (should be " #low ")\n",\
  (unsigned long) n);           \
  }                 \
  while (0)


void CheckTypeSizes()
{
	assert_size(u8_t,  1);
	assert_size(s8_t,  1);
	assert_size(u16_t, 2);
	assert_size(s16_t, 2);
	assert_size(u32_t, 4);
	assert_size(s32_t, 4);

	assert_size(raw_linedef_t, 14);
	assert_size(raw_sector_s,  26);
	assert_size(raw_sidedef_t, 30);
	assert_size(raw_thing_t,   10);
	assert_size(raw_vertex_t,   4);
}


//
// translate (dx, dy) into an integer angle value (0-65535)
//
unsigned int ComputeAngle(int dx, int dy)
{
	return (unsigned int) (atan2 ((double) dy, (double) dx) * 10430.37835 + 0.5);
}



//
// compute the distance from (0, 0) to (dx, dy)
//
unsigned int ComputeDist(int dx, int dy)
{
	return (unsigned int) (hypot ((double) dx, (double) dy) + 0.5);
}


double PerpDist(double x, double y,
                double x1, double y1, double x2, double y2)
{
	x  -= x1; y  -= y1;
	x2 -= x1; y2 -= y1;

	double len = sqrt(x2*x2 + y2*y2);

	SYS_ASSERT(len > 0);

	return (x * y2 - y * x2) / len;
}


double AlongDist(double x, double y,
                 double x1, double y1, double x2, double y2)
{
	x  -= x1; y  -= y1;
	x2 -= x1; y2 -= y1;

	double len = sqrt(x2*x2 + y2*y2);

	SYS_ASSERT(len > 0);

	return (x * x2 + y * y2) / len;
}


const char *Int_TmpStr(int value)
{
	static char buffer[200];

	sprintf(buffer, "%d", value);

	return buffer;
}


//
// rounds the value _up_ to the nearest power of two.
//
int RoundPOW2(int x)
{
	if (x <= 2)
		return x;

	x--;

	for (int tmp = x >> 1 ; tmp ; tmp >>= 1)
		x |= tmp;

	return x + 1;
}

int StringCaseCmpPartial(const char *A, const char *B)
{
	// Checks that the string B occurs at the front of string A.
	// NOTE: This function is not symmetric, A can be longer than B and
	// still match, but the match always fails if A is shorter than B.

	for (; *B; A++, B++)
	{
		// this test also catches end-of-string conditions
		if (toupper(*A) != toupper(*B))
			return (toupper(*A) - toupper(*B));
	}

	return 0;
}


void StringMaxCopy(char *dest, const char *src, int max)
{
	for (; *src && max > 0; max--)
	{
		*dest++ = *src++;
	}

	*dest = 0;
}


void StringReplaceChar(char *str, char old_ch, char new_ch)
{
	// when 'new_ch' is zero, the character is simply removed

	SYS_ASSERT(old_ch != 0);

	char *dest = str;

	while (*str)
	{
		if (*str == old_ch)
		{
			str++;

			if (new_ch)
				*dest++ = new_ch;
		}
		else
		{
			*dest++ = *str++;
		}
	}

	*dest = 0;
}


char *mem_gets(char *buf, int size, const char ** str_ptr)
{
	// This is like fgets() but reads lines from a string.
	// The pointer at 'str_ptr' will point to the next line
	// after this call (or the trailing NUL).
	// Lines which are too long will be truncated (silently).
	// Returns NULL when at end of the string.

	SYS_ASSERT(str_ptr && *str_ptr);
	SYS_ASSERT(size >= 4);

	const char *p = *str_ptr;

	if (! *p)
		return NULL;

	char *dest = buf;
	char *dest_end = dest + (size - 2);

	for ( ; *p && *p != '\n' ; p++)
	{
		if (dest < dest_end)
			*dest++ = *p;
	}

	if (*p == '\n')
	{
		*dest++ = *p++;
	}

	*dest = 0;

	*str_ptr = p;

	return buf;
}


//------------------------------------------------------------------------

/* Thomas Wang's 32-bit Mix function */
u32_t IntHash(u32_t key)
{
	key += ~(key << 15);
	key ^=  (key >> 10);
	key +=  (key << 3);
	key ^=  (key >> 6);
	key += ~(key << 11);
	key ^=  (key >> 16);

	return key;
}


u32_t StringHash(const char *str)
{
	u32_t hash = 0;

	if (str)
		while (*str)
			hash = (hash << 5) - hash + *str++;

	return hash;
}

double CalcAngle(double sx, double sy, double ex, double ey)
{
	// result is Degrees (0 <= angle < 360).
	// East  (increasing X) -->  0 degrees
	// North (increasing Y) --> 90 degrees

	ex -= sx;
	ey -= sy;

	if (fabs(ex) < 0.0001)
		return (ey > 0) ? 90.0 : 270.0;

	if (fabs(ey) < 0.0001)
		return (ex > 0) ? 0.0 : 180.0;

	double angle = atan2(ey, ex) * 180.0 / M_PI;

	if (angle < 0)
		angle += 360.0;

	return angle;
}

double DiffAngle(double A, double B)
{
	// A + result = B
	// result ranges from -180 to +180

	double D = B - A;

	while (D >  180.0) D = D - 360.0;
	while (D < -180.0) D = D + 360.0;

	return D;
}

//Was ComputeDist
double ComputeDistDouble(double sx, double sy, double ex, double ey)
{
	return sqrt((ex-sx)*(ex-sx) + (ey-sy)*(ey-sy));
}


double ComputeDistDouble(double sx, double sy, double sz,
                   double ex, double ey, double ez)
{
	return sqrt((ex-sx)*(ex-sx) + (ey-sy)*(ey-sy) + (ez-sz)*(ez-sz));
}

double PointLineDist(double x, double y,
                     double x1, double y1, double x2, double y2)
{
	x  -= x1; y  -= y1;
	x2 -= x1; y2 -= y1;

	double len_squared = (x2*x2 + y2*y2);

	SYS_ASSERT(len_squared > 0);

	double along_frac = (x * x2 + y * y2) / len_squared;

	// three cases:
	//   (a) off the "left" side (closest to start point)
	//   (b) off the "right" side (closest to end point)
	//   (c) in-between : use the perpendicular distance

	if (along_frac <= 0)
		return sqrt(x*x + y*y);

	else if (along_frac >= 1)
		return ComputeDist(x, y, x2, y2);

	else
		// perp dist
		return fabs(x * y2 - y * x2) / sqrt(len_squared);
}

void CalcIntersection(double nx1, double ny1, double nx2, double ny2,
                      double px1, double py1, double px2, double py2,
                      double *x, double *y)
{
	// NOTE: lines are extended to infinity to find the intersection

	double a = PerpDist(nx1, ny1,  px1, py1, px2, py2);
	double b = PerpDist(nx2, ny2,  px1, py1, px2, py2);

	// BIG ASSUMPTION: lines are not parallel or colinear
	SYS_ASSERT(fabs(a - b) > 1e-6);

	// determine the intersection point
	double along = a / (a - b);

	*x = nx1 + along * (nx2 - nx1);
	*y = ny1 + along * (ny2 - ny1);
}


void AlongCoord(double along, double px1, double py1, double px2, double py2,
                double *x, double *y)
{
	double len = ComputeDist(px1, py1, px2, py2);

	*x = px1 + along * (px2 - px1) / len;
	*y = py1 + along * (py2 - py1) / len;
}


bool VectorSameDir(double dx1, double dy1, double dx2, double dy2)
{
	return (dx1 * dx2 + dy1 * dy2) >= 0;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
