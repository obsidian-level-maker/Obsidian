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

#ifndef __LIB_UTIL_H__
#define __LIB_UTIL_H__

#include <string>
#include <string_view>
#include <codecvt>
#include "sys_type.h"

/* string utilities */

int StringCaseCmp(std::string_view a, std::string_view b);
int StringCaseCmpPartial(std::string_view a, std::string_view b);
bool StringCaseEquals(std::string_view a, std::string_view b);
bool StringCaseEqualsPartial(std::string_view a, std::string_view b);

std::string StringUpper(std::string_view name);

void StringRemoveCRLF(std::string *str);
void StringReplaceChar(std::string *str, char old_ch, char new_ch);

std::string StringFormat(std::string_view fmt, ...);

std::string NumToString(int value);
std::string NumToString(unsigned long long int value);
std::string NumToString(double value);
int StringToInt(std::string value);
int StringToHex(std::string value);
double StringToDouble(std::string value);

char *mem_gets(char *buf, int size, const char **str_ptr);

// The following string conversion classes/code are adapted from public domain
// code by Andrew Choi originally found at https://web.archive.org/web/20151209032329/http://members.shaw.ca/akochoi/articles/unicode-processing-c++0x/

struct UTF8 {
  typedef char storage_type;
  typedef std::string string_type;
};

struct UTF16 {
  typedef char16_t storage_type;
  typedef std::u16string string_type;
};

struct UTF32 {
  typedef char32_t storage_type;
  typedef std::u32string string_type;
};

template<class T, class F> int storageMultiplier();

template<class T, class F, class I>
class str_converter {
 private:
  typedef typename F::storage_type from_storage_type;
  typedef typename T::storage_type to_storage_type;
  typedef typename I::storage_type intern_storage_type;

  typedef std::codecvt<intern_storage_type, UTF8::storage_type, std::mbstate_t> codecvt_type;

 public:

  typedef typename F::string_type from_string_type;
  typedef typename T::string_type to_string_type;

  to_string_type out(const from_string_type& s)
  {
    if (s.empty())
      return to_string_type();

    static std::locale loc(std::locale::classic(), new codecvt_type);
    static std::mbstate_t state;
    static const codecvt_type& cvt = std::use_facet<codecvt_type>(loc);

    const from_storage_type* enx;

    int len = s.length() * storageMultiplier<T, F>();
    to_storage_type *i = new to_storage_type[len];
    to_storage_type *inx;

    typename codecvt_type::result r =
      cvt.out(state, s.c_str(), s.c_str() + s.length(), enx, i, i + len, inx);

    if (r != codecvt_type::ok)
      return to_string_type();

    return to_string_type(i, inx - i);
  }

  to_string_type in(const from_string_type& s)
  {
    if (s.empty())
      return to_string_type();

    static std::locale loc(std::locale::classic(), new codecvt_type);
    static std::mbstate_t state;
    static const codecvt_type& cvt = std::use_facet<codecvt_type>(loc);

    const from_storage_type* enx;

    int len = s.length() * storageMultiplier<T, F>();
    to_storage_type *i = new to_storage_type[len];
    to_storage_type *inx;

    typename codecvt_type::result r =
      cvt.in(state, s.c_str(), s.c_str() + s.length(), enx, i, i + len, inx);

    if (r != codecvt_type::ok)
      return to_string_type();

    return to_string_type(i, inx - i);
  }
};

extern std::string StringToUTF8(const std::string& s);
extern std::string StringToUTF8(const std::u16string& s);
extern std::string StringToUTF8(const std::u32string& s);
extern std::u16string StringToUTF16(const std::string& s);
extern std::u32string StringToUTF32(const std::string& s);

/* time utilities */

u32_t TimeGetMillies();
void TimeDelay(u32_t millies);

/* math utilities */

u32_t IntHash(u32_t key);
u32_t StringHash(std::string str);

#define ALIGN_LEN(x) (((x) + 3) & ~3)

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
                      double px1, double py1, double px2, double py2, double *x,
                      double *y);

std::pair<double, double> AlongCoord(double along, double px1, double py1,
                                     double px2, double py2);

bool VectorSameDir(double dx1, double dy1, double dx2, double dy2);

#endif /* __LIB_UTIL_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
