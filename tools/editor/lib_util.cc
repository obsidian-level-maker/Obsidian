//------------------------------------------------------------------------
//  Utility functions
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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

#include "headers.h"

#include "lib_util.h"

#ifdef UNIX
#include <unistd.h>
#include <sys/time.h>
#include <time.h>
#endif


int StringCaseCmp(const char *A, const char *B)
{
  for (; *A || *B; A++, B++)
  {
    // this test also catches end-of-string conditions
    if (toupper(*A) != toupper(*B))
      return (toupper(*A) - toupper(*B));
  }

  return 0;
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

char *StringUpper(const char *name)
{
  char *copy = StringDup(name);

  for (char *p = copy; *p; p++)
    *p = toupper(*p);

  return copy;
}

char *StringNew(int length)
{
  // length does not include the trailing NUL.
  
  char *s = (char *) calloc(length + 1, 1);

  if (! s)
    AssertFail("Out of memory (%d bytes for string)\n", length);

  return s;
}

char *StringDup(const char *orig)
{
  char *s = strdup(orig);

  if (! s)
    AssertFail("Out of memory (copy string)\n");

  return s;
}

char *StringPrintf(const char *str, ...)
{
  /* Algorithm: keep doubling the allocated buffer size
   * until the output fits. Based on code by Darren Salt.
   */
  char *buf = NULL;
  int buf_size = 128;
  
  for (;;)
  {
    va_list args;
    int out_len;

    buf_size *= 2;

    buf = (char*)realloc(buf, buf_size);
    if (!buf)
      AssertFail("Out of memory (formatting string)");

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

double ComputeDist(double sx, double sy, double ex, double ey)
{
  return sqrt((ex-sx)*(ex-sx) + (ey-sy)*(ey-sy));
}

double ComputeDist(double sx, double sy, double sz,
                   double ex, double ey, double ez)
{
  return sqrt((ex-sx)*(ex-sx) + (ey-sy)*(ey-sy) + (ez-sz)*(ez-sz));
}


//------------------------------------------------------------------------

u32_t TimeGetMillies()
{
  // Note: you *MUST* handle overflow (it *WILL* happen)

#ifdef WIN32
  unsigned long ticks = GetTickCount();

  return (u32_t) ticks;

#else  // UNIX or MacOSX
  struct timeval tm;

  gettimeofday(&tm, NULL);

  return (u32_t) ((tm.tv_sec * 1000) + (tm.tv_usec / 1000));
#endif
}

void TimeDelay(u32_t millies)
{
#ifdef WIN32
  ::Sleep(millies);

#else // LINUX or MacOSX

  usleep(millies * 1000);
#endif
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
