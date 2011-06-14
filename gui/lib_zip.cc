//------------------------------------------------------------------------
//  ARCHIVE Handling - ZIP files
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2009-2011 Andrew Apted
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
#include "main.h"

#include <list>

#include "lib_util.h"
#include "lib_zip.h"


//------------------------------------------------------------------------
//  ZIP READING
//------------------------------------------------------------------------


// !!! TODO TODO !!!


//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

static FILE *zipf_W_fp;

static std::list<raw_zip_central_header_t> zipf_W_directory;

//!! static raw_wad_lump_t wad_W_lump;


bool ZIPF_OpenWrite(const char *filename)
{
  zipf_W_fp = fopen(filename, "wb");

  if (! zipf_W_fp)
  {
    LogPrintf("ZIPF_OpenWrite: cannot create file: %s\n", filename);
    return false;
  }

  LogPrintf("Created ZIP file: %s\n", filename);

  return true;
}


void ZIPF_CloseWrite(void)
{
  fflush(zipf_W_fp);

  // write the directory

  LogPrintf("Writing ZIP directory\n");

  raw_zip_end_of_directory_t  end_part;

  memcpy(end_part.magic, ZIPF_CENTRAL_MAGIC, sizeof(end_part.magic));

  end_part.dir_offset = (u32_t)ftell(zipf_W_fp);
  end_part.dir_size   = 0;

  std::list<raw_wad_lump_t>::iterator ZDI;

  for (ZDI = zipf_W_directory.begin(); ZDI != zipf_W_directory.end(); ZDI++)
  {
    raw_zip_central_header_t *L = & (*ZDI);

    fwrite(L, sizeof(raw_zip_central_header_t), 1, zipf_W_fp);

    // FIXME: write filename

    header.num_lumps++;
  }

  fwrite(&end_part, sizeof(end_part), 1, zipf_W_fp);

  fflush(zipf_W_fp);
  fclose(zipf_W_fp);

  LogPrintf("Closed ZIP file\n");

  zipf_W_fp = NULL;
  zipf_W_directory.clear();
}


#if 0

void WAD_NewLump(const char *name)
{
  SYS_ASSERT(strlen(name) <= 8);  // FIXME: error

  memset(&wad_W_lump, 0, sizeof(wad_W_lump));

  strncpy(wad_W_lump.name, name, 8);

  wad_W_lump.start = (u32_t)ftell(wad_W_fp);
}


bool WAD_AppendData(const void *data, int length)
{
  if (length == 0)
    return true;

  SYS_ASSERT(length > 0);

  return (fwrite(data, length, 1, wad_W_fp) == 1);
}


void WAD_FinishLump(void)
{
  int len = (int)ftell(wad_W_fp) - (int)wad_W_lump.start;

  // pad lumps to a multiple of four bytes
  int padding = ALIGN_LEN(len) - len;

  if (padding > 0)
  {
    static u8_t zeros[4] = { 0,0,0,0 };

    fwrite(zeros, padding, 1, wad_W_fp);
  }

  // fix endianness
  wad_W_lump.start  = LE_U32(wad_W_lump.start);
  wad_W_lump.length = LE_U32(len);

  wad_W_directory.push_back(wad_W_lump);
}

#endif


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
