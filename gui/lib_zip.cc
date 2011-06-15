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

#include <zlib.h>

#include <list>

#include "lib_util.h"
#include "lib_zip.h"


#define ZIPF_MAX_PATH  256

typedef struct
{
  raw_zip_central_header_t  hdr;

  char name[ZIPF_MAX_PATH];
}
zip_central_entry_t;


typedef struct
{
  raw_zip_local_header_t  hdr;

  char name[ZIPF_MAX_PATH];
}
zip_local_entry_t;



//------------------------------------------------------------------------
//  ZIP READING
//------------------------------------------------------------------------

static FILE *r_zip_fp;

static raw_zip_end_of_directory_t  r_end_part;
static raw_zip_central_header_t  * r_directory;

// !!! TODO TODO !!!


//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

static FILE *w_zip_fp;

static std::list<zip_central_entry_t> w_directory;

static zip_local_entry_t w_local;

static int w_local_start;
static int w_local_length;

// common date and time (not swapped)
static int zipf_date;
static int zipf_time;

#define LOCAL_CRC_OFFSET  (7*2)


bool ZIPF_OpenWrite(const char *filename)
{
  w_zip_fp = fopen(filename, "wb");

  if (! w_zip_fp)
  {
    LogPrintf("ZIPF_OpenWrite: cannot create file: %s\n", filename);
    return false;
  }

  LogPrintf("Created ZIP file: %s\n", filename);

  // grab the current date and time
  time_t cur_time = time(NULL);

  struct tm *t = localtime(&cur_time);

  if (t)
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
  fflush(w_zip_fp);

  // write the directory

  LogPrintf("Writing ZIP directory\n");

  int dir_offset = (int)ftell(w_zip_fp);
  int dir_size   = 0;

  int total_entries = 0;

  std::list<zip_central_entry_t>::iterator ZDI;

  for (ZDI = w_directory.begin(); ZDI != w_directory.end(); ZDI++)
  {
    zip_central_entry_t *L = & (*ZDI);

    fwrite(&L->hdr, sizeof(raw_zip_central_header_t), 1, w_zip_fp);
    fwrite(&L->name, strlen(L->name), 1, w_zip_fp);

    dir_size += (int)sizeof(raw_zip_central_header_t);
    dir_size += strlen(L->name);

    total_entries++;
  }

  // write the end-of-directory info

  raw_zip_end_of_directory_t  end_part;

  memcpy(end_part.magic, ZIPF_END_MAGIC, 4);

  end_part.this_disk        = 0;
  end_part.central_dir_disk = 0;
  end_part.comment_length   = 0;

  end_part.disk_entries  = LE_U16(total_entries);
  end_part.total_entries = LE_U16(total_entries);

  end_part.dir_offset = LE_U32(dir_offset);
  end_part.dir_size   = LE_U32(dir_size);

  fwrite(&end_part, sizeof(end_part), 1, w_zip_fp);

  fflush(w_zip_fp);
  fclose(w_zip_fp);

  LogPrintf("Closed ZIP file\n");

  w_zip_fp = NULL;
  w_directory.clear();
}


void ZIPF_NewLump(const char *name)
{
  if (strlen(name)+1 >= ZIPF_MAX_PATH)
    Main_FatalError("ZIPF_NewLump: name too long (>= %d)\n", ZIPF_MAX_PATH);

  // remember position
  w_local_start  = (int)ftell(w_zip_fp);
  w_local_length = 0;

  // setup the zip_local_entry_t fields
  memcpy(w_local.hdr.magic, ZIPF_LOCAL_MAGIC, 4);

  w_local.hdr.req_version = LE_U16(ZIPF_REQ_VERSION);
  w_local.hdr.flags = 0;

  // no compression... yet...
  w_local.hdr.comp_method = LE_U16(ZIPF_COMP_STORE);

  w_local.hdr.file_date = LE_U16(zipf_date);
  w_local.hdr.file_time = LE_U16(zipf_time);

  /* CRC and sizes are fixed up in ZIPF_FinishLump */
  w_local.hdr.crc           = 0;
  w_local.hdr.compress_size = 0;
  w_local.hdr.real_size     = 0;

  int name_length = strlen(name);

  w_local.hdr.name_length  = LE_U16(name_length);
  w_local.hdr.extra_length = 0;

  strcpy(w_local.name, name);

  fwrite(&w_local.hdr, sizeof(w_local.hdr), 1, w_zip_fp);
  fwrite(&w_local.name, name_length, 1, w_zip_fp);
}


bool ZIPF_AppendData(const void *data, int length)
{
  if (length == 0)
    return true;

  SYS_ASSERT(length > 0);

  if (fwrite(data, length, 1, w_zip_fp) != 1)
    return false;

  // FIXME: CRC

  w_local_length += length;

  return true;
}


void ZIPF_FinishLump(void)
{
  fflush(w_zip_fp);

  w_local.hdr.real_size     = LE_U32(w_local_length);
  w_local.hdr.compress_size = LE_U32(w_local_length);

  // seek back and fix up the CRC and size fields
  // FIXME: check if worked
  fseek(w_zip_fp, w_local_start + LOCAL_CRC_OFFSET, SEEK_SET);

  fwrite(&w_local.hdr.crc,           4, 1, w_zip_fp);
  fwrite(&w_local.hdr.compress_size, 4, 1, w_zip_fp);
  fwrite(&w_local.hdr.real_size,     4, 1, w_zip_fp);

  fflush(w_zip_fp);

  // seek back to end of file
  fseek(w_zip_fp, 0, SEEK_END);

  // create the central entry from the local entry
  zip_central_entry_t  central;

  memcpy(central.hdr.magic, ZIPF_CENTRAL_MAGIC, 4);

  central.hdr.made_version = LE_U16(ZIPF_MADE_VERSION);
  central.hdr.req_version  = w_local.hdr.req_version;

  central.hdr.flags       = w_local.hdr.flags;
  central.hdr.comp_method = w_local.hdr.comp_method;
  central.hdr.file_time   = w_local.hdr.file_time;
  central.hdr.file_date   = w_local.hdr.file_date;

  central.hdr.crc           = w_local.hdr.crc;
  central.hdr.compress_size = w_local.hdr.compress_size;
  central.hdr.real_size     = w_local.hdr.real_size;

  central.hdr.name_length    = w_local.hdr.name_length;
  central.hdr.extra_length   = 0;
  central.hdr.comment_length = 0;

  central.hdr.start_disk      = 0;
  central.hdr.internal_attrib = 0;
  central.hdr.external_attrib = LE_U32(ZIPF_ATTRIB_NORMAL);

  central.hdr.local_offset = LE_U32(w_local_start);

  strcpy(central.name, w_local.name);

  w_directory.push_back(central);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
