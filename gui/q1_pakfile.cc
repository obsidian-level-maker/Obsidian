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
//  PAK READING
//------------------------------------------------------------------------

static FILE *r_pak_fp;

static raw_pak_header_t r_header;

static raw_pak_entry_t * r_directory;


bool PAK_OpenRead(const char *filename)
{
  r_pak_fp = fopen(filename, "rb");

  if (! r_pak_fp)
  {
    LogPrintf("PAK_OpenRead: cannot open file: %s\n", filename);
    return false;
  }

  LogPrintf("Opened PAK file: %s\n", filename);

  if (fread(&r_header, sizeof(r_header), 1, r_pak_fp) != 1)
  {
    LogPrintf("PAK_OpenRead: failed reading header\n");
    fclose(r_pak_fp);
    return false;
  }

  if (memcmp(r_header.magic, PAK_MAGIC, 4) != 0)
  {
    LogPrintf("PAK_OpenRead: not a PAK file!\n");
    fclose(r_pak_fp);
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
    fclose(r_pak_fp);
    return false;
  }
  if (r_header.entry_num >= 4000)  // sanity check
  {
    LogPrintf("PAK_OpenRead: bad header (%d entries?)\n", r_header.entry_num);
    fclose(r_pak_fp);
    return false;
  }

  if (fseek(r_pak_fp, r_header.dir_start, SEEK_SET) != 0)
  {
    LogPrintf("PAK_OpenRead: cannot seek to directory (at 0x%08x)\n", r_header.dir_start);
    fclose(r_pak_fp);
    return false;
  }

  r_directory = new raw_pak_entry_t[r_header.entry_num];

  for (int i = 0; i < (int)r_header.entry_num; i++)
  {
    raw_pak_entry_t *E = &r_directory[i];

    int res = fread(E, sizeof(raw_pak_entry_t), 1, r_pak_fp);

    if (res == EOF || res != 1 || ferror(r_pak_fp))
    {
      LogPrintf("PAK_OpenRead: hit EOF reading dir-entry %d\n", i);

      // truncate directory
      r_header.entry_num = i;
      break;
    }

    // make sure name is NUL terminated.
    E->name[55] = 0;

    E->offset = LE_U32(E->offset);
    E->length = LE_U32(E->length);

    DebugPrintf(" %4d: %08x %08x : %s\n", i, E->offset, E->length, E->name);
  }

  if (r_header.entry_num == 0)
  {
    LogPrintf("PAK_OpenRead: could not read any dir-entries!\n");

    delete[] r_directory;
    r_directory = NULL;

    fclose(r_pak_fp);
    return false;
  }

  return true; // OK
}

void PAK_CloseRead(void)
{
  fclose(r_pak_fp);

  LogPrintf("Closed PAK file\n");

  delete[] r_directory;
  r_directory = NULL;
}


void PAK_FindMaps(std::vector<int>& entries)
{
  entries.resize(0);
  entries.reserve(r_header.entry_num);

  for (int i = 0; i < (int)r_header.entry_num; i++)
  {
    raw_pak_entry_t *E = &r_directory[i];

    const char *name = E->name;

    if (strncmp(name, "maps/", 5) != 0)
      continue;

    name += 5;

    // ignore the ammo boxes
    if (strncmp(name, "b_", 2) == 0)
      continue;

    while (*name && *name != '/' && *name != '.')
      name++;

    if (strcmp(name, ".bsp") == 0)
    {
      entries.push_back(i);

      DebugPrintf("Found map [%d] : '%s'\n", i, E->name);
    }
  }
}


bool PAK_ReadData(int entry, int offset, int length, void *buffer)
{
  SYS_ASSERT(entry >= 0 && entry < (int)r_header.entry_num);
  SYS_ASSERT(offset >= 0);
  SYS_ASSERT(length > 0);

  raw_pak_entry_t *E = &r_directory[entry];

  if (fseek(r_pak_fp, E->offset + offset, SEEK_SET) != 0)
    return false;

  int res = fread(buffer, length, 1, r_pak_fp);

  return (res == 1);
}


//------------------------------------------------------------------------
//  PAK WRITING
//------------------------------------------------------------------------

static FILE *w_pak_fp;

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


//------------------------------------------------------------------------
//  WAD2 READING
//------------------------------------------------------------------------

static FILE *wad_R_fp;

static raw_wad2_header_t  wad_R_header;
static raw_wad2_lump_t * wad_R_dir;

bool WAD2_OpenRead(const char *filename)
{
  wad_R_fp = fopen(filename, "rb");

  if (! wad_R_fp)
  {
    LogPrintf("WAD2_OpenRead: cannot open file: %s\n", filename);
    return false;
  }

  LogPrintf("Opened WAD2 file: %s\n", filename);

  if (fread(&wad_R_header, sizeof(wad_R_header), 1, wad_R_fp) != 1)
  {
    LogPrintf("WAD2_OpenRead: failed reading header\n");
    fclose(wad_R_fp);
    return false;
  }

  if (memcmp(wad_R_header.magic, WAD2_MAGIC, 4) != 0)
  {
    LogPrintf("WAD2_OpenRead: not a WAD2 file!\n");
    fclose(wad_R_fp);
    return false;
  }

  wad_R_header.num_lumps = LE_U32(wad_R_header.num_lumps);
  wad_R_header.dir_start = LE_U32(wad_R_header.dir_start);

  /* read directory */

  if (wad_R_header.num_lumps == 0)
  {
    LogPrintf("WAD2_OpenRead: empty PAK file!\n");
    fclose(wad_R_fp);
    return false;
  }
  if (wad_R_header.num_lumps >= 4000)  // sanity check
  {
    LogPrintf("WAD2_OpenRead: bad header (%d entries?)\n", wad_R_header.num_lumps);
    fclose(wad_R_fp);
    return false;
  }

  if (fseek(wad_R_fp, wad_R_header.dir_start, SEEK_SET) != 0)
  {
    LogPrintf("WAD2_OpenRead: cannot seek to directory (at 0x%08x)\n", wad_R_header.dir_start);
    fclose(wad_R_fp);
    return false;
  }

  wad_R_dir = new raw_wad2_lump_t[wad_R_header.num_lumps];

  for (int i = 0; i < (int)wad_R_header.num_lumps; i++)
  {
    raw_wad2_lump_t *L = &wad_R_dir[i];

    int res = fread(L, sizeof(raw_wad2_lump_t), 1, wad_R_fp);

    if (res == EOF || res != 1 || ferror(wad_R_fp))
    {
      LogPrintf("WAD2_OpenRead: hit EOF reading dir-entry %d\n", i);

      // truncate directory
      wad_R_header.num_lumps = i;
      break;
    }

    // make sure name is NUL terminated.
    L->name[15] = 0;

    L->start  = LE_U32(L->start);
    L->length = LE_U32(L->length);
    L->u_len  = LE_U32(L->u_len);

    DebugPrintf(" %4d: %08x %08x : %s\n", i, L->start, L->length, L->name);
  }

  if (wad_R_header.num_lumps == 0)
  {
    LogPrintf("WAD2_OpenRead: could not read any dir-entries!\n");

    delete[] wad_R_dir;
    wad_R_dir = NULL;

    fclose(wad_R_fp);
    return false;
  }

  return true; // OK
}

void WAD2_CloseRead(void)
{
  fclose(wad_R_fp);

  LogPrintf("Closed WAD2 file\n");

  delete[] wad_R_dir;
  wad_R_dir = NULL;
}

int WAD2_FindEntry(const char *name)
{
  // FIXME: optimise this (with a cache)

  for (unsigned int i = 0; i < wad_R_header.num_lumps; i++)
  {
    if (StringCaseCmp(name, wad_R_dir[i].name) == 0)
      return i;
  }

  return -1; // not found
}

int WAD2_EntryLen(int entry)
{
  SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_lumps);

  return wad_R_dir[entry].u_len;
}

bool WAD2_ReadData(int entry, int offset, int length, void *buffer)
{
  SYS_ASSERT(entry >= 0 && entry < (int)wad_R_header.num_lumps);
  SYS_ASSERT(offset >= 0);
  SYS_ASSERT(length > 0);

  raw_wad2_lump_t *L = &wad_R_dir[entry];

  if (fseek(wad_R_fp, L->start + offset, SEEK_SET) != 0)
    return false;

  int res = fread(buffer, length, 1, wad_R_fp);

  return (res == 1);
}


//------------------------------------------------------------------------
//  WAD2 WRITING
//------------------------------------------------------------------------

static FILE *wad_W_fp;

static std::list<raw_wad2_lump_t> wad_W_directory;

static raw_wad2_lump_t wad_W_lump;


bool WAD2_OpenWrite(const char *filename)
{
  wad_W_fp = fopen(filename, "wb");

  if (! wad_W_fp)
  {
    LogPrintf("WAD2_OpenWrite: cannot create file: %s\n", filename);
    return false;
  }

  LogPrintf("Created WAD2 file: %s\n", filename);

  // write out a dummy header
  raw_wad2_header_t header;
  memset(&header, 0, sizeof(header));

  fwrite(&header, sizeof(raw_wad2_header_t), 1, wad_W_fp);

  return true;
}


void WAD2_CloseWrite(void)
{
  fflush(wad_W_fp);

  // write the directory

  raw_wad2_header_t header;

  memcpy(header.magic, WAD2_MAGIC, 4);

  header.dir_start = (int)ftell(wad_W_fp);
  header.num_lumps = 0;

  std::list<raw_wad2_lump_t>::iterator WDI;

  for (WDI = wad_W_directory.begin(); WDI != wad_W_directory.end(); WDI++)
  {
    raw_wad2_lump_t *E = & (*WDI);

    fwrite(E, sizeof(raw_wad2_lump_t), 1, wad_W_fp);

    header.num_lumps++;
  }

  fflush(wad_W_fp);

  // finally write the _real_ WAD2 header

  header.dir_start = LE_U32(header.dir_start);
  header.num_lumps = LE_U32(header.num_lumps);

  fseek(wad_W_fp, 0, SEEK_SET);

  fwrite(&header, sizeof(header), 1, wad_W_fp);

  fflush(wad_W_fp);
  fclose(wad_W_fp);

  LogPrintf("Closed WAD2 file\n");

  wad_W_directory.clear();
}


void WAD2_NewLump(const char *name)
{
  SYS_ASSERT(strlen(name) <= 15);

  memset(&wad_W_lump, 0, sizeof(wad_W_lump));

  strcpy(wad_W_lump.name, name);

  wad_W_lump.start = (u32_t)ftell(wad_W_fp);
}


void WAD2_AppendData(const void *data, int length)
{
  SYS_ASSERT(length >= 0);

  if (length > 0)
  {
    if (fwrite(data, length, 1, wad_W_fp) != 1)
    {
      //TODO : write_errors++
    }
  }
}


void WAD2_FinishLump(void)
{
  int len = (int)ftell(wad_W_fp) - (int)wad_W_lump.start;

  // pad lumps to a multiple of four bytes
  int padding = AlignLen(len) - len;

  if (padding > 0)
  {
    static u8_t zeros[4] = { 0,0,0,0 };

    fwrite(zeros, padding, 1, wad_W_fp);
  }

  // fix endianness
  wad_W_lump.start  = LE_U32(wad_W_lump.start);
  wad_W_lump.length = LE_U32(len);
  wad_W_lump.u_len  = LE_U32(len);

  wad_W_directory.push_back(wad_W_lump);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
