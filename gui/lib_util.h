//------------------------------------------------------------------------
//  Utility functions
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006 Andrew Apted
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

// file utilities
bool FileExists(const char *filename);
bool HasExtension(const char *filename);
bool CheckExtension(const char *filename, const char *ext);
const char *ReplaceExtension(const char *filename, const char *ext);
const char *FileBaseName(const char *filename);

// string utilities
int StrCaseCmp(const char *A, const char *B);
int StrCaseCmpPartial(const char *A, const char *B);
void StrMaxCopy(char *dest, const char *src, int max);
const char *StrUpper(const char *name);
char *StringNew(int length);
char *StringDup(const char *orig);
void StringFree(const char *str);

// math utilities
u32_t IntHash(u32_t key);
u32_t StringHash(const char *str);

// time utilities
u32_t TimeGetMillies();
void TimeDelay(u32_t millies);

#endif /* __LIB_UTIL_H__ */
