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

#include "headers.h"

#include "lib_util.h"

#ifndef WIN32
#include <sys/time.h>
#include <time.h>
#endif


//
// FileExists
//
bool FileExists(const char *filename)
{
	FILE *fp = fopen(filename, "rb");

	if (fp)
	{
		fclose(fp);
		return true;
	}

	return false;
}

//
// HasExtension
//
bool HasExtension(const char *filename)
{
	int A = (int)strlen(filename) - 1;

	if (A > 0 && filename[A] == '.')
		return false;

	for (; A >= 0; A--)
	{
		if (filename[A] == '.')
			return true;

		if (filename[A] == '/')
			break;

#ifdef WIN32
		if (filename[A] == '\\' || filename[A] == ':')
			break;
#endif
	}

	return false;
}

//
// CheckExtension
//
// When ext is NULL, checks if the file has no extension.
//
bool CheckExtension(const char *filename, const char *ext)
{
	if (! ext)
		return ! HasExtension(filename);

	int A = (int)strlen(filename) - 1;
	int B = (int)strlen(ext) - 1;

	for (; B >= 0; B--, A--)
	{
		if (A < 0)
			return false;

		if (toupper(filename[A]) != toupper(ext[B]))
			return false;
	}

	return (A >= 1) && (filename[A] == '.');
}

//
// ReplaceExtension
//
// When ext is NULL, any existing extension is removed.
//
// Returned string is a COPY.
//
char *ReplaceExtension(const char *filename, const char *ext)
{
	SYS_ASSERT(filename[0] != 0);

	char *buffer = StringNew(strlen(filename) + (ext ? strlen(ext) : 0) + 10);

	strcpy(buffer, filename);

	char *dot_pos = buffer + strlen(buffer) - 1;

	for (; dot_pos >= buffer && *dot_pos != '.'; dot_pos--)
	{
		if (*dot_pos == '/')
			break;

#ifdef WIN32
		if (*dot_pos == '\\' || *dot_pos == ':')
			break;
#endif
	}

	if (dot_pos < buffer || *dot_pos != '.')
		dot_pos = NULL;

	if (! ext)
	{
		if (dot_pos)
			dot_pos[0] = 0;

		return buffer;
	}

	if (dot_pos)
		dot_pos[1] = 0;
	else
		strcat(buffer, ".");

	strcat(buffer, ext);

	return buffer;
}

//
// FileBaseName
//
// Find the base name of the file (i.e. without any path).
// The result always points within the given string.
//
// Example:  "C:\Foo\Bar.wad"  ->  "Bar.wad"
// 
const char *FileBaseName(const char *filename)
{
	const char *pos = filename + strlen(filename) - 1;

	for (; pos >= filename; pos--)
	{
		if (*pos == '/')
			return pos + 1;

#ifdef WIN32
		if (*pos == '\\' || *pos == ':')
			return pos + 1;
#endif
	}

	return filename;
}

bool CopyFile(const char *src_name, const char *dest_name)
{
  char buffer[1024];

  FILE *src = fopen(src_name, "rb");
  if (! src)
    return false;

  FILE *dest = fopen(dest_name, "wb");
  if (! dest)
  {
    fclose(src);
    return false;
  }

  while (true)
  {
    int rlen = fread(buffer, 1, sizeof(buffer), src);
    if (rlen <= 0)
      break;

    int wlen = fwrite(buffer, 1, rlen, dest);
    if (wlen != rlen)
      break;
  }

  bool was_OK = !ferror(src) && !ferror(dest);

  fclose(dest);
  fclose(src);

  return was_OK;
}


//------------------------------------------------------------------------

//
// StrCaseCmp
//
int StrCaseCmp(const char *A, const char *B)
{
	for (; *A || *B; A++, B++)
	{
		// this test also catches end-of-string conditions
		if (toupper(*A) != toupper(*B))
			return (toupper(*A) - toupper(*B));
	}

	return 0;
}

//
// StrCaseCmpPartial
//
// Checks that the string B occurs at the front of string A.
// NOTE: This function is not symmetric, A can be longer than B and
// still match, but the match always fails if A is shorter than B.
//
int StrCaseCmpPartial(const char *A, const char *B)
{
	for (; *B; A++, B++)
	{
		// this test also catches end-of-string conditions
		if (toupper(*A) != toupper(*B))
			return (toupper(*A) - toupper(*B));
	}

	return 0;
}

//
// StrMaxCopy
//
void StrMaxCopy(char *dest, const char *src, int max)
{
	for (; *src && max > 0; max--)
	{
		*dest++ = *src++;
	}

	*dest = 0;
}

//
// StrUpper
//
char *StrUpper(const char *name)
{
	char *copy = StringDup(name);

	for (char *p = copy; *p; p++)
		*p = toupper(*p);

	return copy;
}

//
// StringNew
//
// Length does not include the trailing NUL.
//
char *StringNew(int length)
{
	char *s = (char *) calloc(length + 1, 1);

	if (! s)
		AssertFail("Out of memory (%d bytes for string)\n", length);

	return s;
}

//
// StringDup
//
char *StringDup(const char *orig)
{
	char *s = strdup(orig);

	if (! s)
		AssertFail("Out of memory (copy string)\n");
	
	return s;
}

//
// StringFree
//
void StringFree(const char *str)
{
	free((void*) str);
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


//------------------------------------------------------------------------

// be sure to handle overflow (it *WILL* happen)
u32_t TimeGetMillies()
{
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
