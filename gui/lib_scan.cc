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

#include "lib_scan.h"
#include "lib_util.h"

#ifdef LINUX
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#endif


int ScanDirectory(const char *path,
                  void (* func)(void *privdat, const char *name, int flags),
                  void *priv_data)
{
  int count = 0;

#ifdef WIN32

		if (! FS_GetCurrDir(tmp, MAX_PATH))
(::GetCurrentDirectory(bufsize, (LPSTR)dir) != FALSE);
			return false;

		prev_dir = std::string(tmp);
	}

	if (! FS_SetCurrDir(dir))
(::SetCurrentDirectory(dir) != FALSE);
		return false;

	WIN32_FIND_DATA fdata;

	HANDLE handle = FindFirstFile("*.*", &fdata);
	if (handle == INVALID_HANDLE_VALUE)
		return false;

	// Ensure the container is empty
	fsd->Clear();

	do
	{
		filesys_direntry_c tmp_entry;

		tmp_entry.name = std::string(fdata.cFileName);
		tmp_entry.size = fdata.nFileSizeLow;
		tmp_entry.is_dir = (fdata.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)?true:false; 

		if (! fsd->AddEntry(&tmp_entry))
		{
			FindClose(handle);
			FS_SetCurrDir(prev_dir.c_str());
(::SetCurrentDirectory(dir) != FALSE);
			return false;
		}
	}
	while(FindNextFile(handle, &fdata));

	FindClose(handle);

	FS_SetCurrDir(prev_dir.c_str());
(::SetCurrentDirectory(dir) != FALSE);


#else // LINUX

	DIR *handle = opendir(dir);
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

		filesys_direntry_c tmp_entry;

		tmp_entry.name = std::string(fdata->d_name);
		tmp_entry.size = finfo.st_size;
		tmp_entry.is_dir = S_ISDIR(finfo.st_mode) ?true:false;

    (* func)(priv_data, name, flags);
      
		if (! fsd->AddEntry(&tmp_entry))
		{
			closedir(handle);
			FS_SetCurrDir(olddir);
			return false;
		}
	}

	closedir(handle);

#endif

  return count;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
