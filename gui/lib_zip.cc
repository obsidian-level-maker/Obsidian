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


#define ZIPF_MAX_PATH  256

typedef struct
{
  raw_zip_central_header_t hdr;

  char name[ZIPF_MAX_PATH];
}
zip_central_entry_t;


typedef struct
{
  raw_zip_local_header_t hdr;

  char name[ZIPF_MAX_PATH];
}
zip_local_entry_t;



//------------------------------------------------------------------------
//  ZIP READING
//------------------------------------------------------------------------


// !!! TODO TODO !!!


//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

static FILE *zipf_write_fp;

static std::list<zip_central_entry_t> zipf_W_directory;

static zip_local_entry_t zipf_W_lump;

// common date and time (not swapped)
static int zipf_date;
static int zipf_time;


bool ZIPF_OpenWrite(const char *filename)
{
  zipf_write_fp = fopen(filename, "wb");

  if (! zipf_write_fp)
  {
    LogPrintf("ZIPF_OpenWrite: cannot create file: %s\n", filename);
    return false;
  }

  LogPrintf("Created ZIP file: %s\n", filename);

  // grab the current date and time
  struct tm *t = localtime(time());

  if (false)  // FIXME !!!!
  {
    zipf_date = (((t->tm_year - 80) & 0x7f) << 9) |
                (((t->tm_mon  +  1) & 0x0f) << 5) |
                (  t->tm_mday       & 0x1f);

    zipf_time = ((t->tm_hour & 0x1f) << 11) |
                ((t->tm_min  & 0x3f) <<  5) |
                ((t->tm_sec  & 0x3e) >>  1);
  }
  else
  {
    // fallback
    zipf_date = ((2011 - 1980) << 9) | (7 << 5) | 1;
    zipf_time = (12 << 11) | (34 << 5) | (56 >> 1);
  }

  return true;
}


void ZIPF_CloseWrite(void)
{
  fflush(zipf_write_fp);

  // write the directory

  LogPrintf("Writing ZIP directory\n");

  raw_zip_end_of_directory_t  end_part;

  memcpy(end_part.magic, ZIPF_CENTRAL_MAGIC, 4);

  end_part.dir_offset = (u32_t)ftell(zipf_write_fp);
  end_part.dir_size   = 0;

  std::list<raw_wad_lump_t>::iterator ZDI;

  for (ZDI = zipf_W_directory.begin(); ZDI != zipf_W_directory.end(); ZDI++)
  {
    zip_central_entry_t *L = & (*ZDI);

    fwrite(L, sizeof(zip_central_entry_t), 1, zipf_write_fp);

    header.num_lumps++;
  }

  fwrite(&end_part, sizeof(end_part), 1, zipf_write_fp);

  fflush(zipf_write_fp);
  fclose(zipf_write_fp);

  LogPrintf("Closed ZIP file\n");

  zipf_write_fp = NULL;
  zipf_W_directory.clear();
}


void ZIPF_NewLump(const char *name)
{
  if (strlen(name)+1 >= ZIPF_MAX_PATH)
    Main_FatalError("ZIPF_NewLump: name too long (>= %d)\n", ZIPF_MAX_W_PATH);

  // setup the zip_local_entry_t fields
  memset(&zipf_W_lump, 0, sizeof(zipf_W_lump));

  memcpy(zipf_W_lump.hdr.magic, ZIPF_LOCAL_MAGIC, 4);

  zipf_W_lump.hdr.req_version = LE_U16(ZIPF_REQ_VERSION);
  zipf_W_lump.hdr.flags = 0;

  // no compression... yet...
  zipf_W_lump.hdr.comp_method = LE_U16(ZIPF_COMP_STORE);

  zipf_W_lump.hdr.file_date = zipf_date;
  zipf_W_lump.hdr.file_time = zipf_time;

  /* size stuff done in ZIPF_FinishLump */

  zipf_W_lump.hdr.name_length  = strlen(name);
  zipf_W_lump.hdr.extra_length = 0;

  strcpy(zipf_W_lump.name, name);

  wad_W_lump.start = (u32_t)ftell(wad_write_fp);
}


bool ZIPF_AppendData(const void *data, int length)
{
  if (length == 0)
    return true;

  SYS_ASSERT(length > 0);

  if (fwrite(data, length, 1, zipf_write_fp) != 1)
    return false;

  // FIXME: CRC

  return true;
}


void ZIPF_FinishLump(void)
{
  int len = (int)ftell(zipf_write_fp) - (int)zipf_W_lump.start;

  // create the central from the local entry

  zip_central_entry_t  central;

  strcpy(central.name, zipf_W_lump.name);

  // FIXME !!!

  zipf_W_lump.start  = LE_U32(wad_W_lump.start);
  zipf_W_lump.length = LE_U32(len);

  zipf_W_directory.push_back(wad_W_lump);
  
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
