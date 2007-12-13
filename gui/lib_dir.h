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

#ifndef __LIB_SCAN_H__
#define __LIB_SCAN_H__

typedef enum
{
  SCAN_F_IsDir    = (1 << 0),
  SCAN_F_Hidden   = (1 << 1),
  SCAN_F_ReadOnly = (1 << 2),
}
scan_flags_e;

typedef enum
{
  SCAN_ERROR = -1,  // general catch-all

  SCAN_ERR_NoExist  = -2,  // could not find given path
  SCAN_ERR_NotDir   = -3,  // path was not a directory
}
scan_error_e;

typedef void (* directory_iter_f)(const char *name, int flags, void *priv_dat);

int ScanDirectory(const char *path, directory_iter_f func, void *priv_dat);
// scan the directory with the given path and call the given
// function (passing the private data pointer to it) for each
// entry in the directory.  Returns the total number of entries,
// or a negative value on error (SCAN_ERR_xx value).

#endif /* __LIB_SCAN_H__ */
