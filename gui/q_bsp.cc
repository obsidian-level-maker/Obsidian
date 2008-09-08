//------------------------------------------------------------------------
//  BSP files - Quake I and II
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

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_pakfile.h"
#include "q_bsp.h"



static FILE *bsp_fp;

static qLump_c * bsp_directory[HEADER_LUMPS];



static int write_errors_seen;
static int seek_errors_seen;



qLump_c::qLump_c() : buffer(), crlf(false), offset(0)
{ }

qLump_c::~qLump_c()
{ }


int qLump_c::GetSize() const
{
  return (int)buffer.size();
}


void qLump_c::Append(const void *data, u32_t len)
{
  if (len == 0)
    return;

  u32_t old_size = buffer.size();
  u32_t new_size = old_size + len;

  buffer.resize(new_size);

  memcpy(& buffer[old_size], data, len);
}


void qLump_c::Prepend(const void *data, u32_t len)
{
  if (len == 0)
    return;

  u32_t old_size = buffer.size();
  u32_t new_size = old_size + len;

  buffer.resize(new_size);

  if (old_size > 0)
  {
    memmove(& buffer[len], & buffer[0], old_size);
  }
  memcpy(& buffer[0], data, len);
}


void qLump_c::RawPrintf(const char *str)
{
  if (! crlf)
  {
    Append(str, strlen(str));
    return;
  }

  // convert each newline into CR/LF pair
  while (*str)
  {
    char *next = strchr(str, '\n');

    Append(str, next ? (next - str) : strlen(str));

    if (! next)
      break;

    Append("\r\n", 2);

    str = next+1;
  }
}


void qLump_c::Printf(const char *str, ...)
{
  static char msg_buf[MSG_BUF_LEN];

  va_list args;

  va_start(args, str);
  vsnprintf(msg_buf, MSG_BUF_LEN-1, str, args);
  va_end(args);

  msg_buf[MSG_BUF_LEN-2] = 0;

  RawPrintf(msg_buf);
}


void qLump_c::KeyPair(const char *key, const char *val, ...)
{
  static char v_buffer[MSG_BUF_LEN];

  va_list args;

  va_start(args, val);
  vsnprintf(v_buffer, MSG_BUF_LEN-1, val, args);
  va_end(args);

  v_buffer[MSG_BUF_LEN-2] = 0;

  RawPrintf("\"");
  RawPrintf(key);
  RawPrintf("\" \"");
  RawPrintf(v_buffer);
  RawPrintf("\"\n");
}


void qLump_c::SetCRLF(bool enable)
{
  crlf = enable;
}


//------------------------------------------------------------------------


qLump_c *Q1_NewLump(int entry)
{
  SYS_ASSERT(0 <= entry && entry < HEADER_LUMPS);

  if (bsp_directory[entry] != NULL)
    Main_FatalError("INTERNAL ERROR: Q1_NewLump: already created entry [%d]\n", entry);

  bsp_directory[entry] = new qLump_c;

  return bsp_directory[entry];
}


static void BSP_RawSeek(u32_t pos)
{
  fflush(bsp_fp);

  if (fseek(bsp_fp, pos, SEEK_SET) < 0)
  {
    if (seek_errors_seen < 10)
    {
      LogPrintf("Failure seeking in bsp file! (offset %u)\n", pos);

      seek_errors_seen += 1;
    }
  }
}

static void BSP_RawWrite(const void *data, u32_t len)
{
  SYS_ASSERT(bsp_fp);

  if (1 != fwrite(data, len, 1, bsp_fp))
  {
    if (write_errors_seen < 10)
    {
      LogPrintf("Failure writing to bsp file! (%u bytes)\n", len);

      write_errors_seen += 1;
    }
  }
}

static void BSP_WriteLump(int entry, lump_t *info)
{
  qLump_c *lump = bsp_directory[entry];

  if (! lump)
  {
    info->start  = 0;
    info->length = 0;

    return;
  }


  int len = lump->GetSize();

  info->start  = LE_S32((u32_t)ftell(bsp_fp));
  info->length = LE_S32(len);


  if (len > 0)
  {
    BSP_RawWrite(& (*lump)[0], len);

    // pad lumps to a multiple of four bytes
    u32_t padding = AlignLen(len) - len;

    SYS_ASSERT(0 <= padding && padding <= 3);

    if (padding > 0)
    {
      static u8_t zeros[4] = { 0,0,0,0 };

      BSP_RawWrite(zeros, padding);
    }
  }
}

static void ClearLumps(void)
{
  for (int i = 0; i < HEADER_LUMPS; i++)
  {
    if (bsp_directory[i])
    {
      delete bsp_directory[i];

      bsp_directory[i] = NULL;
    }
  }
}

bool BSP_OpenWrite(const char *target_file)
{
  write_errors_seen = 0;
  seek_errors_seen  = 0;

  ClearLumps();

  bsp_fp = fopen(target_file, "wb");

  if (! bsp_fp)
  {
    DLG_ShowError("Unable to create bsp file:\n%s", strerror(errno));
    return false;
  }

  return true; //OK
}


bool BSP_CloseWrite(void)
{

  // WRITE FAKE HEADER
  dheader_t header;
  memset(&header, 0, sizeof(header));

  BSP_RawWrite(&header, sizeof(header));


  // WRITE ALL LUMPS

  header.version = LE_U32(0x1D); 

  for (int L = 0; L < HEADER_LUMPS; L++)
  {
    BSP_WriteLump(L, &header.lumps[L]);
  }


  // FSEEK, WRITE REAL HEADER

  BSP_RawSeek(0);
  BSP_RawWrite(&header, sizeof(header));

  fclose(bsp_fp);
  bsp_fp = NULL;

  return (write_errors_seen == 0) && (seek_errors_seen == 0);
}


bool BSP_BeginLevel(const char *entry_in_pak, int bsp_ver)
{
  // FIXME 
}

bool BSP_WriteLevel()
{
  // FIXME
}



bool BSP_OpenPAK(const char *target_file)
{
  // FIXME
}

bool BSP_ClosePAK()
{
  // FIXME
}


void BSP_Backup(const char *filename)
{
  if (FileExists(filename))
  {
    LogPrintf("Backing up existing file: %s\n", filename);

    char *backup_name = ReplaceExtension(filename, "bak");

    if (! FileCopy(filename, backup_name))
      LogPrintf("WARNING: unable to create backup: %s\n", backup_name);

    StringFree(backup_name);
  }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
