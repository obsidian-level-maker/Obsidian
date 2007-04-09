//------------------------------------------------------------------------
//  Utility functions
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#ifdef WIN32
#define DIR_SEP_CH   '\\'
#define DIR_SEP_STR  "\\"
#else
#define DIR_SEP_CH   '/'
#define DIR_SEP_STR  "/"
#endif

// file utilities
bool FileExists(const char *filename);
bool HasExtension(const char *filename);
bool CheckExtension(const char *filename, const char *ext);
char *ReplaceExtension(const char *filename, const char *ext);
const char *FileBaseName(const char *filename);
bool FileCopy(const char *src_name, const char *dest_name);
bool FileRename(const char *old_name, const char *new_name);
bool FileDelete(const char *filename);
bool FileChangeDir(const char *dir_name);
bool FileMakeDir(const char *dir_name);

// string utilities
int StrCaseCmp(const char *A, const char *B);
int StrCaseCmpPartial(const char *A, const char *B);
void StrMaxCopy(char *dest, const char *src, int max);
char *StrUpper(const char *name);
char *StringNew(int length);
char *StringDup(const char *orig);
void StringFree(const char *str);
char *StringPrintf(const char *str, ...); // GCCATTR((format (printf, 1, 2)));

// math utilities
u32_t IntHash(u32_t key);
u32_t StringHash(const char *str);

// time utilities
u32_t TimeGetMillies();
void TimeDelay(u32_t millies);

// miscellanous
const char *GetExecutablePath(const char *argv0);

#endif /* __LIB_UTIL_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
