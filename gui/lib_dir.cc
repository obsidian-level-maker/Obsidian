//------------------------------------------------------------------------
//  Directory Scanning
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

#include "lib_dir.h"
#include "lib_util.h"

#ifdef UNIX
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#endif


#ifndef MAX_PATH
#define MAX_PATH  1024
#endif


int ScanDirectory(const char *path, directory_iter_f func, void *priv_dat)
{
  int count = 0;

#ifdef WIN32

  // this is a bit clunky.  We set the current directory to the
  // target and use FindFirstFile with "*.*" as the pattern. 
  // Afterwards we restore the current directory.

  char old_dir[MAX_PATH+1];
  
  if (GetCurrentDirectory(MAX_PATH, (LPSTR)old_dir) == FALSE)
      return SCAN_ERROR;

  if (SetCurrentDirectory(path) == FALSE)
    return SCAN_ERR_NoExist;

  WIN32_FIND_DATA fdata;

  HANDLE handle = FindFirstFile("*.*", &fdata);
  if (handle == INVALID_HANDLE_VALUE)
  {
    SetCurrentDirectory(old_dir);

    return 0;  //??? (GetLastError() == ERROR_FILE_NOT_FOUND) ? 0 : SCAN_ERROR;
  }

  do
  {
    int flags = 0;

    if (fdata.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
      flags |= SCAN_F_IsDir;

    if (fdata.dwFileAttributes & FILE_ATTRIBUTE_READONLY)
      flags |= SCAN_F_ReadOnly;

    if (fdata.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN)
      flags |= SCAN_F_Hidden;

    (* func)(fdata.cFileName, flags, priv_dat);
  }
  while (FindNextFile(handle, &fdata) != FALSE);

  FindClose(handle);

  SetCurrentDirectory(old_dir);


#else // ---- LINUX ------------------------------------------------

  DIR *handle = opendir(path);
  if (handle == NULL)
    return SCAN_ERR_NoExist;

  for (;;)
  {
    const struct dirent *fdata = readdir(handle);
    if (fdata == NULL)
      break;

    struct stat finfo;

    if (stat(fdata->d_name, &finfo) != 0)
      continue;

    int flags = 0;

    if (S_ISDIR(finfo.st_mode))
      flags |= SCAN_F_IsDir;

    if ((finfo.st_mode & (S_IWUSR | S_IWGRP | S_IWOTH)) == 0)
      flags |= SCAN_F_ReadOnly;

    if (fdata->d_name[0] == '.' && isalpha(fdata->d_name[1]))
      flags |= SCAN_F_Hidden;

    (* func)(fdata->d_name, flags, priv_dat);
  }

  closedir(handle);
#endif

  return count;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
