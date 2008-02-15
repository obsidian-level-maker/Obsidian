//------------------------------------------------------------------------
//  LEVEL building - Quake1/2 PAK files
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2008 Andrew Apted
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
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"

#include "q1_pakfile.h"

#include "main.h"


//------------------------------------------------------------------------
//  READING
//------------------------------------------------------------------------

static FILE *read_fp;


bool PAK_OpenRead(const char *filename)
{
  // TODO: PAK_OpenRead
  return false;
}

void PAK_CloseRead(void)
{
  // TODO
}

int PAK_FindMaps(std::vector<int>& entries)
{
  // TODO
}


//------------------------------------------------------------------------
//  WRITING
//------------------------------------------------------------------------

static FILE *write_fp;

bool PAK_OpenWrite(const char *filename)
{
  // TODO: PAK_OpenWrite
  return false;
}

void PAK_CloseWrite(void)
{
  // TODO
}

void PAK_NewLump(const char *name)
{
  // TODO
}

void PAK_AppendData(const void *data, int length)
{
  // TODO
}

void PAK_FinishLump(void)
{
  // TODO
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
