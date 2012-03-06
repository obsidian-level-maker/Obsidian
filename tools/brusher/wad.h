//------------------------------------------------------------------------
//  WAD : Wad file read/write functions.
//------------------------------------------------------------------------
//
//  Brusher (C) 2012 Andrew Apted
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

#ifndef __BRUSHER_WAD_H__
#define __BRUSHER_WAD_H__


class lump_c;


typedef enum { IWAD, PWAD } wad_kind_e;

// wad header

class wad_c
{
public:
  wad_c();
  ~wad_c();

  FILE *in_file;

  // kind of wad file (-1 if not opened yet)
  int kind;

  // number of entries in directory (original)
  int num_entries;

  // offset to start of directory
  int dir_start;

  // current directory entries
  std::vector<lump_c *> dir;

  // current level
  lump_c *current_level;

  // array of level names found
  const char ** level_names;
  int num_level_names;

public:
  // open the input wad file and read the contents into memory.
  static wad_c *Load(const char *filename);

  bool CheckLevelName(const char *name);
  bool CheckLevelNameGL(const char *name);

  // find a particular level in the wad directory, and store the
  // reference in 'wad.current_level'.  Returns false if not
  // found.
  bool FindLevel(const char *map_name);

  // name of first level in the wad.  Returns NULL if there
  // are no levels at all.
  const char *FirstLevelName();

  // find the level lump with the given name in the current level, and
  // return a reference to it.  Returns NULL if no such lump exists.
  // Level lumps are always present in memory (i.e. never marked
  // copyable).
  lump_c *FindLumpInLevel(const char *name);

  void CacheLump(lump_c *lump);

private:
  bool ReadHeader();
  void ReadDirEntry();
  void ReadDirectory();

  void ProcessDirEntry(lump_c *lump);

  void AddLevelName(const char *name);
  void DetermineLevelNames();
};


// level information

class level_c
{
public:
  level_c();
  ~level_c();

  // various flags
  int flags;

  // the child lump list
  std::vector<lump_c *> children;

  // information on overflow
  int soft_limit;
  int hard_limit;
  int v3_switch;
};

/* this level information holds GL lumps */
#define LEVEL_IS_GL   0x0002


// directory entry

class lump_c
{
public:
   lump_c();
  ~lump_c();

  // name of lump
  const char *name;

  // offset/length of lump in wad
  int start;
  int length;

  // various flags
  int flags;

  // data of lump
  void *data;

  // level information, usually NULL
  level_c *lev_info;
};


/* ------ Global variables ------ */

extern wad_c *the_wad;
extern wad_c *the_gwa;


/* ----- The wad structures ---------------------- */

// wad header

typedef struct raw_wad_header_s
{
  char type[4];

  uint32_g num_entries;
  uint32_g dir_start;
}
raw_wad_header_t;


// directory entry

typedef struct raw_wad_entry_s
{
  uint32_g start;
  uint32_g length;

  char name[8];
}
raw_wad_entry_t;


#endif /* __BRUSHER_WAD_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
