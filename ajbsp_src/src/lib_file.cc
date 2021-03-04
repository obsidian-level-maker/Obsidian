//------------------------------------------------------------------------
//  File Utilities
//------------------------------------------------------------------------
//
//  Copyright (C) 2006-2016 Andrew Apted
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

#include "main.h"

#ifdef WIN32
#include <io.h>
#else  // UNIX or MACOSX
#include <dirent.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#endif

#ifdef __APPLE__
#include <sys/param.h>
#include <mach-o/dyld.h> // _NSGetExecutablePath
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

	for (; A >= 0 ; A--)
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
// MatchExtension
//
// When ext is NULL, checks if the file has no extension.
//
bool MatchExtension(const char *filename, const char *ext)
{
	if (! ext)
		return ! HasExtension(filename);

	int A = (int)strlen(filename) - 1;
	int B = (int)strlen(ext) - 1;

	for (; B >= 0 ; B--, A--)
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

	size_t total_len = strlen(filename) + (ext ? strlen(ext) : 0);

	char *buffer = StringNew((int)total_len + 10);

	strcpy(buffer, filename);

	char *dot_pos = buffer + strlen(buffer) - 1;

	for (; dot_pos >= buffer && *dot_pos != '.' ; dot_pos--)
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


const char *FindBaseName(const char *filename)
{
	// Find the base name of the file (i.e. without any path).
	// The result always points within the given string.
	//
	// Example:  "C:\Foo\Bar.wad"  ->  "Bar.wad"

	const char *pos = filename + strlen(filename) - 1;

	for (; pos >= filename ; pos--)
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


bool FilenameIsBare(const char *filename)
{
	if (strchr(filename, '.')) return false;
	if (strchr(filename, '/')) return false;
	if (strchr(filename, '\\')) return false;
	if (strchr(filename, ':')) return false;

	return true;
}


void FilenameStripBase(char *buffer)
{
	char *pos = buffer + strlen(buffer) - 1;

	for (; pos > buffer ; pos--)
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


//
// takes the basename in 'filename' and prepends the path from 'othername'.
// returns a newly allocated string.
//
/* CURRENTLY DISABLED
const char *FilenameReposition(const char *filename, const char *othername)
{
	filename = fl_filename_name(filename);

	const char *op = fl_filename_name(othername);

	if (op <= othername)
		return StringDup(filename);

	size_t dir_len = op - othername;
	size_t len = strlen(filename) + dir_len;

	char *result = StringNew((int)len + 10);

	memcpy(result, othername, dir_len);
	result[dir_len] = 0;

	strcat(result, filename);

	return result;
}
*/


void FilenameGetPath(char *dest, size_t maxsize, const char *filename)
{
	size_t len = (size_t)(FindBaseName(filename) - filename);

	// remove trailing slash (except when following "C:" or similar)
	if (len >= 1 &&
		(filename[len-1] == '/' || filename[len-1] == '\\') &&
		! (len >= 2 && filename[len-2] == ':'))
	{
		len--;
	}

	if (len == 0)
	{
		strcpy(dest, ".");
		return;
	}

	if (len >= maxsize)
		len =  maxsize - 1;

	strncpy(dest, filename, len);
	dest[len] = 0;
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
		size_t rlen = fread(buffer, 1, sizeof(buffer), src);
		if (rlen == 0)
			break;

		size_t wlen = fwrite(buffer, 1, rlen, dest);
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

#else // UNIX or MACOSX

	return (rename(old_name, new_name) == 0);
#endif
}


bool FileDelete(const char *filename)
{
#ifdef WIN32
	return (::DeleteFile(filename) != 0);

#else // UNIX or MACOSX

	return (remove(filename) == 0);
#endif
}


bool FileChangeDir(const char *dir_name)
{
#ifdef WIN32
	return (::SetCurrentDirectory(dir_name) != 0);

#else // UNIX or MACOSX

	return (chdir(dir_name) == 0);
#endif
}


bool FileMakeDir(const char *dir_name)
{
#ifdef WIN32
	return (::CreateDirectory(dir_name, NULL) != 0);

#else // UNIX or MACOSX

	return (mkdir(dir_name, 0775) == 0);
#endif
}


u8_t * FileLoad(const char *filename, int *length)
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
		FatalError("Out of memory (%d bytes for FileLoad)\n", *length);

	// ensure buffer is NUL-terminated
	data[*length] = 0;

	if (*length > 0 && 1 != fread(data, *length, 1, fp))
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


//
// Note: returns false when the path doesn't exist.
//
bool PathIsDirectory(const char *path)
{
#ifdef WIN32
	char old_dir[MAX_PATH+1];

	if (GetCurrentDirectory(MAX_PATH, (LPSTR)old_dir) == FALSE)
		return false;

	bool result = SetCurrentDirectory(path);

	SetCurrentDirectory(old_dir);

	return result;

#else // UNIX or MACOSX

	struct stat finfo;

	if (stat(path, &finfo) != 0)
		return false;

	return (S_ISDIR(finfo.st_mode)) ? true : false;
#endif
}


const char * FileFindInPath(const char *paths, const char *base_name)
{
	// search through the path list (separated by ';') to find the file.
	// If found, the complete filename is returned (which must be freed
	// using StringFree).  If not found, NULL is returned.

	for (;;)
	{
		const char *sep = strchr(paths, ';');
		size_t len = sep ? (sep - paths) : strlen(paths);

		SYS_ASSERT(len > 0);

		const char *filename = StringPrintf("%.*s/%s", (int)len, paths, base_name);

		//  fprintf(stderr, "Trying data file: [%s]\n", filename);

		if (FileExists(filename))
			return filename;

		StringFree(filename);

		if (! sep)
			return NULL;  // not found

		paths = sep + 1;
	}
}


//------------------------------------------------------------------------

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

		// minor kludge for consistency with Unix
		if (fdata.cFileName[0] == '.' && isalpha(fdata.cFileName[1]))
			flags |= SCAN_F_Hidden;

		if (strcmp(fdata.cFileName, ".")  == 0 ||
				strcmp(fdata.cFileName, "..") == 0)
		{
			// skip the funky "." and ".." dirs
		}
		else
		{
			(* func)(fdata.cFileName, flags, priv_dat);

			count++;
		}
	}
	while (FindNextFile(handle, &fdata) != FALSE);

	FindClose(handle);

	SetCurrentDirectory(old_dir);


#else // ---- UNIX ------------------------------------------------

	DIR *handle = opendir(path);
	if (handle == NULL)
		return SCAN_ERR_NoExist;

	for (;;)
	{
		const struct dirent *fdata = readdir(handle);
		if (fdata == NULL)
			break;

		if (strlen(fdata->d_name) == 0)
			continue;

		// skip the funky "." and ".." dirs
		if (strcmp(fdata->d_name, ".")  == 0 ||
				strcmp(fdata->d_name, "..") == 0)
			continue;


		const char *full_name = StringPrintf("%s/%s", path, fdata->d_name);

		struct stat finfo;

		if (stat(full_name, &finfo) != 0)
		{
			DebugPrintf(".... stat failed: %s\n", strerror(errno));
			StringFree(full_name);
			continue;
		}

		StringFree(full_name);


		int flags = 0;

		if (S_ISDIR(finfo.st_mode))
			flags |= SCAN_F_IsDir;

		if ((finfo.st_mode & (S_IWUSR | S_IWGRP | S_IWOTH)) == 0)
			flags |= SCAN_F_ReadOnly;

		if (fdata->d_name[0] == '.' && isalpha(fdata->d_name[1]))
			flags |= SCAN_F_Hidden;

		(* func)(fdata->d_name, flags, priv_dat);

		count++;
	}

	closedir(handle);
#endif

	return count;
}


//------------------------------------------------------------------------

const char *GetExecutablePath(const char *argv0)
{
	char *path;

#ifdef WIN32
	path = StringNew(AJ_PATH_MAX+2);

	int length = GetModuleFileName(GetModuleHandle(NULL), path, AJ_PATH_MAX);

	if (length > 0 && length < AJ_PATH_MAX)
	{
		if (access(path, 0) == 0)  // sanity check
		{
			FilenameStripBase(path);
			return path;
		}
	}

	// didn't work, free the memory
	StringFree(path);

#elif !defined(__APPLE__) // UNIX
	path = StringNew(AJ_PATH_MAX+2);

	int length = readlink("/proc/self/exe", path, AJ_PATH_MAX);

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

#else
	/*
	   from http://www.hmug.org/man/3/NSModule.html

	   extern int _NSGetExecutablePath(char *buf, uint32_t *bufsize);

	   _NSGetExecutablePath copies the path of the executable
	   into the buffer and returns 0 if the path was successfully
	   copied in the provided buffer. If the buffer is not large
	   enough, -1 is returned and the expected buffer size is
	   copied in *bufsize.
	 */
	uint32_t pathlen = AJ_PATH_MAX * 2;

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

#ifdef __APPLE__
	// FIXME: check if _inside_ the .app folder
#endif

	FilenameStripBase(path);
	return path;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
