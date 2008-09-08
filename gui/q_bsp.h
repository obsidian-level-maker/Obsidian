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

#ifndef __OBLIGE_BSPOUT_H__
#define __OBLIGE_BSPOUT_H__

// perhaps this should be elsewhere
#define Q_EPSILON  0.02


class qLump_c
{
/* !!!! */
public:

  std::vector<u8_t> buffer;

  // when true Printf() converts '\n' to CR/LF pair
  bool crlf;

///--- public: // access only in q_bsp.cc!
///---   u32_t offset;

public:
   qLump_c();
  ~qLump_c();

  void Append (const void *data, u32_t len);
  void Prepend(const void *data, u32_t len);

  void Printf (const char *str, ...);
  void KeyPair(const char *key, const char *val, ...);
  void SetCRLF(bool enable);

  int GetSize() const;

private:
  void RawPrintf(const char *str);
};


void BSP_BackupPAK(const char *filename);

bool BSP_OpenLevel(const char *entry_in_pak, int game /* 1 or 2 */);
bool BSP_CloseLevel();

qLump_c *BSP_NewLump(int entry);


/* ----- BSP lump directory ------------------------- */

#define Q1_HEADER_LUMPS  15
#define Q1_BSP_VERSION   29

#define Q2_HEADER_LUMPS  19
#define Q2_BSP_VERSION   38
#define Q2_IDENT_MAGIC   "IBSP"

typedef struct
{
  u32_t start;
  u32_t length;
}
lump_t;

typedef struct
{
  s32_t version;
  lump_t lumps[Q1_HEADER_LUMPS];
}
dheader_t;

typedef struct
{
  char   ident[4];
  s32_t  version;  

  lump_t lumps[Q2_HEADER_LUMPS];
}
dheader2_t;

#endif /* __OBLIGE_BSPOUT_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
