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

static raw_pak_header_t r_header;

static std::vector<raw_pak_entry_t> r_directory;


bool PAK_OpenRead(const char *filename)
{
  read_fp = fopen(filename, "rb");

  if (! read_fp)
  {
    LogPrintf("PAK_OpenRead: cannot open file: %s\n", filename);
    return false;
  }

  LogPrintf("Opened PAK file: %s\n", filename);

  if (fread(&r_header, sizeof(r_header), 1, read_fp) != 1)
  {
    LogPrintf("PAK_OpenRead: failed reading header\n");
    fclose(read_fp);
    return false;
  }

  if (memcmp(r_header.magic, PAK_MAGIC, 4) != 0)
  {
    LogPrintf("PAK_OpenRead: not a PAK file!\n");
    fclose(read_fp);
    return false;
  }

  r_header.dir_start = LE_U32(r_header.dir_start);
  r_header.entry_num = LE_U32(r_header.entry_num);

  // convert directory length to entry count
  r_header.entry_num /= sizeof(raw_pak_entry_t);

  /* read directory */

  if (r_header.entry_num == 0)
  {
    LogPrintf("PAK_OpenRead: empty PAK file!\n");
    fclose(read_fp);
    return false;
  }
  if (r_header.entry_num >= 4000)  // sanity check
  {
    LogPrintf("PAK_OpenRead: bad header (%d entries?)\n", r_header.entry_num);
    fclose(read_fp);
    return false;
  }

  if (fseek(read_fp, r_header.dir_start, SEEK_SET) != 0)
  {
    LogPrintf("PAK_OpenRead: cannot seek to directory (at 0x%08x)\n", r_header.dir_start);
    fclose(read_fp);
    return false;
  }

  r_directory.resize(r_header.entry_num);

  for (int i = 0; i < (int)r_header.entry_num; i++)
  {
    raw_pak_entry_t *E = &r_directory[i];

    int res = fread(&E, sizeof(raw_pak_entry_t), 1, read_fp);

    if (res == EOF || res != 1 || ferror(read_fp))
    {
      LogPrintf("PAK_OpenRead: hit EOF reading dir-entry %d\n", i);

      // truncate directory
      r_header.entry_num = i;
      break;
    }

    // make sure name is NUL terminated.  For the longest possible
    // name, this will chop off the last character.  However for
    // our purposes this should not matter much.
    E->name[55] = 0;

    E->offset = LE_U32(E->offset);
    E->length = LE_U32(E->length);

    DebugPrintf("-- %3d: %08x %08x '%s'\n", i, E->offset, E->length, E->name);
  }

  if (r_header.entry_num == 0)
  {
    LogPrintf("PAK_OpenRead: could not read any dir-entries!\n");
    fclose(read_fp);
    return false;
  }

  return true; // OK
}

void PAK_CloseRead(void)
{
  fclose(read_fp);

  r_directory.resize(0);

  LogPrintf("Closed PAK file\n");
}

int PAK_FindMaps(std::vector<int>& entries)
{
  // TODO
  return 0;
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
