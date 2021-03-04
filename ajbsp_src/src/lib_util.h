//------------------------------------------------------------------------
//  UTILITIES
//------------------------------------------------------------------------
//
//  Copyright (C) 2001-2013 Andrew Apted
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

#ifndef __LIB_UTIL_H__
#define __LIB_UTIL_H__


int y_stricmp (const char *s1, const char *s2);
int y_strnicmp (const char *s1, const char *s2, size_t len);

void y_strupr (char *str);
void y_strlowr (char *str);

char *StringNew(int length);
char *StringDup(const char *orig, int limit = -1);
char *StringUpper(const char *name);
char *StringPrintf(const char *str, ...);
void StringFree(const char *str);

void StringRemoveCRLF(char *str);
char *StringTidy(const char *str, const char *bad_chars = "");

void CheckTypeSizes();

void TimeDelay(unsigned int millies);
unsigned int TimeGetMillies();

unsigned int ComputeAngle (int, int);
unsigned int ComputeDist  (int, int);

double PerpDist(double x, double y,  /* coord to test */
                double x1, double y1, double x2, double y2 /* line */);

double AlongDist(double x, double y, /* coord to test */
                 double x1, double y1, double x2, double y2 /* line */);

// round a positive value up to the nearest power of two
int RoundPOW2(int x);


const char * Int_TmpStr(int value);


/*
 *  dectoi
 *  If <c> is a decimal digit ("[0-9]"), return its value.
 *  Else, return a negative number.
 */
inline int dectoi (char c)
{
  if (isdigit ((unsigned char) c))
    return c - '0';
  else
    return -1;
}


/*
 *  hextoi
 *  If <c> is a hexadecimal digit ("[0-9A-Fa-f]"), return its value.
 *  Else, return a negative number.
 */
inline int hextoi (char c)
{
  if (isdigit ((unsigned char) c))
    return c - '0';
  else if (c >= 'a' && c <= 'f')
    return c - 'a' + 10;
  else if (c >= 'A' && c <= 'F')
    return c - 'A' + 10;
  else
    return -1;
}


/*
 *  y_isident - return true iff <c> is one of a-z, A-Z, 0-9 or "_".
 *
 *  Intentionally not using isalpha() and co. because I
 *  don't want the results to depend on the locale.
 */
inline bool y_isident (char c)
{
  switch (c)
  {
    case 'a': case 'b': case 'c': case 'd': case 'e': case 'f':
    case 'g': case 'h': case 'i': case 'j': case 'k': case 'l':
    case 'm': case 'n': case 'o': case 'p': case 'q': case 'r':
    case 's': case 't': case 'u': case 'v': case 'w': case 'x':
    case 'y': case 'z':

    case 'A': case 'B': case 'C': case 'D': case 'E': case 'F':
    case 'G': case 'H': case 'I': case 'J': case 'K': case 'L':
    case 'M': case 'N': case 'O': case 'P': case 'Q': case 'R':
    case 'S': case 'T': case 'U': case 'V': case 'W': case 'X':
    case 'Y': case 'Z':

    case '0': case '1': case '2': case '3': case '4': case '5':
    case '6': case '7': case '8': case '9':

    case '_':

      return true;

    default:

      return false;
  }
}


/*
 *  round_up
 *  Round a value up to the next multiple of quantum.
 *
 *  Both the value and the quantum are supposed to be positive.
 */
inline void round_up (int& value, int quantum)
{
  value = ((value + quantum - 1) / quantum) * quantum;
}


/*
 *  y_isprint
 *  Is <c> a printable character in ISO-8859-1 ?
 */
inline bool y_isprint (char c)
{
  return (c & 0x60) && (c != 0x7f);
}


#endif  /* __LIB_UTIL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
