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


// !!! TODO TODO !!!


//------------------------------------------------------------------------
//  ZIP WRITING
//------------------------------------------------------------------------

static FILE *zipf_write_fp;

static std::list<zip_central_entry_t> zipf_W_directory;

static zip_local_entry_t zipf_W_local;

static int zipf_local_start;
static int zipf_local_length;

// common date and time (not swapped)
static int zipf_date;
static int zipf_time;

#define LOCAL_CRC_OFFSET  (7*2)


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
  fflush(zipf_write_fp);

  // write the directory

  LogPrintf("Writing ZIP directory\n");

  int dir_offset = (int)ftell(zipf_write_fp);
  int dir_size   = 0;

  int total_entries = 0;

  std::list<zip_central_entry_t>::iterator ZDI;

  for (ZDI = zipf_W_directory.begin(); ZDI != zipf_W_directory.end(); ZDI++)
  {
    zip_central_entry_t *L = & (*ZDI);

    fwrite(&L->hdr, sizeof(raw_zip_central_header_t), 1, zipf_write_fp);
    fwrite(&L->name, strlen(L->name), 1, zipf_write_fp);

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
    Main_FatalError("ZIPF_NewLump: name too long (>= %d)\n", ZIPF_MAX_PATH);

  // remember position
  zipf_local_start  = (int)ftell(zipf_write_fp);
  zipf_local_length = 0;

  // setup the zip_local_entry_t fields
  memcpy(zipf_W_local.hdr.magic, ZIPF_LOCAL_MAGIC, 4);

  zipf_W_local.hdr.req_version = LE_U16(ZIPF_REQ_VERSION);
  zipf_W_local.hdr.flags = 0;

  // no compression... yet...
  zipf_W_local.hdr.comp_method = LE_U16(ZIPF_COMP_STORE);

  zipf_W_local.hdr.file_date = LE_U16(zipf_date);
  zipf_W_local.hdr.file_time = LE_U16(zipf_time);

  /* CRC and sizes are fixed up in ZIPF_FinishLump */
  zipf_W_local.hdr.crc           = 0;
  zipf_W_local.hdr.compress_size = 0;
  zipf_W_local.hdr.real_size     = 0;

  int name_length = strlen(name);

  zipf_W_local.hdr.name_length  = LE_U16(name_length);
  zipf_W_local.hdr.extra_length = 0;

  strcpy(zipf_W_local.name, name);

  fwrite(&zipf_W_local.hdr, sizeof(zipf_W_local.hdr), 1, zipf_write_fp);
  fwrite(&zipf_W_local.name, name_length, 1, zipf_write_fp);
}


bool ZIPF_AppendData(const void *data, int length)
{
  if (length == 0)
    return true;

  SYS_ASSERT(length > 0);

  if (fwrite(data, length, 1, zipf_write_fp) != 1)
    return false;

  // FIXME: CRC

  zipf_local_length += length;

  return true;
}


void ZIPF_FinishLump(void)
{
  fflush(zipf_write_fp);

  zipf_W_local.hdr.real_size     = LE_U32(zipf_local_length);
  zipf_W_local.hdr.compress_size = LE_U32(zipf_local_length);

  // seek back and fix up the CRC and size fields
  // FIXME: check if worked
  fseek(zipf_write_fp, zipf_local_start + LOCAL_CRC_OFFSET, SEEK_SET);

  fwrite(&zipf_W_local.hdr.crc,           4, 1, zipf_write_fp);
  fwrite(&zipf_W_local.hdr.compress_size, 4, 1, zipf_write_fp);
  fwrite(&zipf_W_local.hdr.real_size,     4, 1, zipf_write_fp);

  fflush(zipf_write_fp);

  // seek back to end of file
  fseek(zipf_write_fp, 0, SEEK_END);

  // create the central entry from the local entry
  zip_central_entry_t  central;

  memcpy(central.hdr.magic, ZIPF_CENTRAL_MAGIC, 4);

  central.hdr.made_version = LE_U16(ZIPF_MADE_VERSION);
  central.hdr.req_version  = zipf_W_local.hdr.req_version;

  central.hdr.flags       = zipf_W_local.hdr.flags;
  central.hdr.comp_method = zipf_W_local.hdr.comp_method;
  central.hdr.file_time   = zipf_W_local.hdr.file_time;
  central.hdr.file_date   = zipf_W_local.hdr.file_date;

  central.hdr.crc           = zipf_W_local.hdr.crc;
  central.hdr.compress_size = zipf_W_local.hdr.compress_size;
  central.hdr.real_size     = zipf_W_local.hdr.real_size;

  central.hdr.name_length    = zipf_W_local.hdr.name_length;
  central.hdr.extra_length   = 0;
  central.hdr.comment_length = 0;

  central.hdr.start_disk      = 0;
  central.hdr.internal_attrib = 0;
  central.hdr.external_attrib = 0;

  central.hdr.local_offset = LE_U32(zipf_local_start);

  strcpy(central.name, zipf_W_local.name);

  zipf_W_directory.push_back(central);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
