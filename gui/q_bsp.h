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


class qLump_c:
{
private:
  std::vector<u8_t> buffer;

  // when true Printf() converts '\n' to CR/LF pair
  bool crlf;

public: // access only in q_bsp.cc!
  u32_t offset;

public:
   qLump_c();
  ~qLump_c();

  void Append (const void *data, u32_t len);
  void Prepend(const void *data, u32_t len);
  void Printf (int crlf, const char *str, ...);
  void KeyPair(const char *key, const char *val, ...);
  void SetCRLF(bool enable);

  int GetSize() const;

private:
  void RawPrintf(const char *str);
};


bool BSP_OpenPAK(const char *target_file);
bool BSP_ClosePAK();
void BSP_BackupPAK(const char *filename);

bool BSP_BeginLevel(const char *entry_in_pak, int bsp_ver);
bool BSP_WriteLevel();

qLump_c *BSP_NewLump(int entry);


#endif /* __OBLIGE_BSPOUT_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
