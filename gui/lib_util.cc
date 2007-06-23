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

#ifdef WIN32
#include <io.h>      // access()
#else
#include <sys/time.h>
#include <time.h>
#endif

#ifdef UNIX
#include <unistd.h>
#include <sys/stat.h>  // mkdir
#endif

#ifdef MACOSX
#include <sys/param.h>
#include <mach-o/dyld.h> // _NSGetExecutablePath
#endif

#ifndef PATH_MAX
#define PATH_MAX  2048
#endif


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

void FilenameStripBase(char *buffer)
{
  char *pos = buffer + strlen(buffer) - 1;

  for (; pos > buffer; pos--)
  {
    if (*pos == '/')
      break;

#ifdef WIN32
    if (*pos == '\\')
      break;

    if (*pos == ':')
    {
      pos[1] = 0;
      return;
    }
#endif
  }

  if (pos > buffer)
     *pos = 0;
  else
    strcpy(buffer, ".");
}

bool FileCopy(const char *src_name, const char *dest_name)
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

bool FileRename(const char *old_name, const char *new_name)
{
#ifdef WIN32
  return (::MoveFile(old_name, new_name) != 0);

#else // LINUX or MACOSX

  return (rename(old_name, new_name) == 0);
#endif
}

bool FileDelete(const char *filename)
{
#ifdef WIN32
  return (::DeleteFile(filename) != 0);

#else // LINUX or MACOSX

  return (remove(filename) == 0);
#endif
}

bool FileChangeDir(const char *dir_name)
{ 
#ifdef WIN32
  return (::SetCurrentDirectory(dir_name) != 0);

#else // LINUX or MACOSX

  return (chdir(dir_name) == 0);
#endif
}
  
bool FileMakeDir(const char *dir_name)
{
#ifdef WIN32
  return (::CreateDirectory(dir_name, NULL) != 0);

#else // LINUX or MACOSX

  return (mkdir(dir_name, 0775) == 0);
#endif
}

u8_t *FileLoad(const char *filename, int *length)
{
  *length = 0;

  FILE *fp = fopen(filename, "rb");

  if (! fp)
    return NULL;

  // determine size of file (via seeking)
  fseek(fp, 0, SEEK_END);
  {
    (*length) = (int)ftell(fp);
  }
  fseek(fp, 0, SEEK_SET);

  if (ferror(fp) || *length < 0)
  {
    fclose(fp);
    return NULL;
  }

  u8_t *data = (u8_t *) malloc(*length + 1);

  if (! data)
    AssertFail("Out of memory (%d bytes for FileLoad)\n", *length);

  if (1 != fread(data, *length, 1, fp))
  {
    FileFree(data);
    fclose(fp);
    return NULL;
  }

  fclose(fp);

  return data;
}

void FileFree(u8_t *mem)
{
  free((void*) mem);
}

//------------------------------------------------------------------------

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

void StrMaxCopy(char *dest, const char *src, int max)
{
  for (; *src && max > 0; max--)
  {
    *dest++ = *src++;
  }

  *dest = 0;
}

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

char *StringDup(const char *orig)
{
  char *s = strdup(orig);

  if (! s)
    AssertFail("Out of memory (copy string)\n");

  return s;
}

void StringFree(const char *str)
{
  free((void*) str);
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


//------------------------------------------------------------------------

const char *GetExecutablePath(const char *argv0)
{
  char *path;

#ifdef WIN32
  path = StringNew(PATH_MAX+2);

  int length = GetModuleFileName(GetModuleHandle(NULL), path, PATH_MAX);

  if (length > 0 && length < PATH_MAX)
  {
    if (access(path, 0) == 0)  // sanity check
    {
      FilenameStripBase(path);
      return path;
    }
  }

  // didn't work, free the memory
  StringFree(path);
#endif

#ifdef UNIX
  path = StringNew(PATH_MAX+2);

  int length = readlink("/proc/self/exe", path, PATH_MAX);

  if (length > 0)
  {
    path[length] = 0; // add the missing NUL

    if (access(path, 0) == 0)  // sanity check
    {
      FilenameStripBase(path);
      return path;
    }
  }

  // didn't work, free the memory
  StringFree(path);
#endif

#ifdef MACOSX
/*
  from http://www.hmug.org/man/3/NSModule.html

  extern int _NSGetExecutablePath(char *buf, unsigned long *bufsize);

  _NSGetExecutablePath copies the path of the executable
  into the buffer and returns 0 if the path was successfully
  copied in the provided buffer. If the buffer is not large
  enough, -1 is returned and the expected buffer size is
  copied in *bufsize.
*/
  int pathlen = PATH_MAX * 2;

  path = StringNew(pathlen+2);

  if (0 == _NSGetExecutablePath(path, &pathlen))
  {
    // FIXME: will this be _inside_ the .app folder???
    FilenameStripBase(path);
    return path;
  }
  
  // didn't work, free the memory
  StringFree(path);
#endif

  // fallback method: use argv[0]
  path = StringDup(argv0);

#ifdef MACOSX
  // FIXME: check if _inside_ the .app folder
#endif
  
  FilenameStripBase(path);
  return path;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
