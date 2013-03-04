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

// this includes everything we need
#include "main.h"


#define DEBUG_DIR   1
#define DEBUG_LUMP  0

#define APPEND_BLKSIZE  256
#define LEVNAME_BUNCH   20

#define ALIGN_LEN(len)  ((((len) + 3) / 4) * 4)


// Global variables
wad_c *the_wad;
wad_c *the_gwa;


wad_c::wad_c() :
  in_file(NULL), kind(-1),
  num_entries(0), dir_start(-1),
  dir(), current_level(NULL),
  level_names(NULL), num_level_names(0)
{
}

wad_c::~wad_c()
{
  if (in_file)
    fclose(in_file);

  /* free directory entries */
  while (! dir.empty())
  {
    lump_c *cur = dir.back();
    dir.pop_back();

    delete cur;
  }


  /* free the level names */
  if (level_names)
  {
    for (int i = 0; i < num_level_names; i++)
      UtilFree((void *) level_names[i]);

    UtilFree(level_names);
  }
}

level_c::level_c() :
  flags(0), children(),
  soft_limit(0), hard_limit(0), v3_switch(0)
{
}

level_c::~level_c()
{
  for (unsigned int kk = 0; kk < children.size(); kk++)
  {
    delete children[kk];
  }
}

lump_c::lump_c() :
  name(NULL), start(-1), length(0), flags(0),
  data(NULL), lev_info(NULL)
{
}

lump_c::~lump_c()
{
  delete lev_info;

  if (data)
    UtilFree((void*)data);

  if (name)
    UtilFree((void*)name);
}

/* ---------------------------------------------------------------- */


#define NUM_LEVEL_LUMPS  12
#define NUM_GL_LUMPS     5

static const char *level_lumps[NUM_LEVEL_LUMPS]=
{
  "THINGS", "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS", 
  "SSECTORS", "NODES", "SECTORS", "REJECT", "BLOCKMAP",
  "BEHAVIOR",  // <-- hexen support
  "SCRIPTS"  // -JL- Lump with script sources
};

static const char *gl_lumps[NUM_GL_LUMPS]=
{
  "GL_VERT", "GL_SEGS", "GL_SSECT", "GL_NODES",
  "GL_PVS"  // -JL- PVS (Potentially Visible Set) lump
};


static bool CheckMagic(const char type[4])
{
  if ((type[0] == 'I' || type[0] == 'P') && 
     type[1] == 'W' && type[2] == 'A' && type[3] == 'D')
  {
    return true;
  }

  return false;
}


bool wad_c::CheckLevelName(const char *name)
{
  for (int i = 0; i < num_level_names; i++)
  {
    if (strcmp(level_names[i], name) == 0)
      return true;
  }

  return false;
}

static bool HasGLPrefix(const char *name)
{
  return (name[0] == 'G' && name[1] == 'L' && name[2] == '_');
}


//
// Tests if the entry name is one of the level lumps.
//
static bool CheckLevelLumpName(const char *name)
{
  for (int i = 0; i < NUM_LEVEL_LUMPS; i++)
  {
    if (strcmp(name, level_lumps[i]) == 0)
      return true;
  }

  return false;
}


//
// Tests if the entry name matches one of the GL lump names.
//
static bool CheckGLLumpName(const char *name)
{
  for (int i = 0; i < NUM_GL_LUMPS; i++)
  {
    if (strcmp(name, gl_lumps[i]) == 0)
      return true;
  }

  return false;
}


//
// Create new level information
//
static level_c *NewLevel(int flags)  // FIXME @@@@
{
  level_c *cur = new level_c();

  cur->flags = flags;

  return cur;
}


//
// Create new lump.  'name' must be allocated storage.
//
static lump_c *NewLump(const char *name)  // FIXME @@@@
{
  lump_c *cur = new lump_c();

  cur->name = name;

  return cur;
}


//
// Returns true if successful, or FALSE if there was a problem (in
// which case the error message as been setup).
//
bool wad_c::ReadHeader()
{
  raw_wad_header_t header;

  size_t len = fread(&header, sizeof(header), 1, in_file);

  if (len != 1)
  {
    PrintWarn("Trouble reading wad header: %s\n", strerror(errno));
    return false;
  }

  if (! CheckMagic(header.type))
  {
    PrintWarn("This file is not a WAD file : bad magic\n");
    return false;
  }

  kind = (header.type[0] == 'I') ? IWAD : PWAD;

  num_entries = UINT32(header.num_entries);
  dir_start   = UINT32(header.dir_start);

  return true;
}


void wad_c::ReadDirEntry()
{
  raw_wad_entry_t entry;

  size_t len = fread(&entry, sizeof(entry), 1, in_file);

  if (len != 1)
    FatalError("Trouble reading wad directory");

  lump_c *lump = NewLump(UtilStrNDup(entry.name, 8));

  lump->start  = UINT32(entry.start);
  lump->length = UINT32(entry.length);

#if DEBUG_DIR
  PrintDebug("Read dir... %s\n", lump->name);
#endif

  dir.push_back(lump);
}


void wad_c::AddLevelName(const char *name)
{
  if ((num_level_names % LEVNAME_BUNCH) == 0)
  {
    level_names = (const char **) UtilRealloc((void *)level_names,
        (num_level_names + LEVNAME_BUNCH) * sizeof(const char *));
  }

  level_names[num_level_names++] = UtilStrDup(name);
}


void wad_c::DetermineLevelNames()
{
  for (unsigned int kk = 0; kk < dir.size(); kk++)
  {
    lump_c *L = dir[kk];

    // check if the next four lumps after the current lump match the
    // level-lump or GL-lump names.

    int normal_count = 0;
    int gl_count = 0;

    for (unsigned int i = 1; (i <= 4) && (kk+i < dir.size()); i++)
    {
      lump_c *N = dir[kk+i];

      if (strcmp(N->name, level_lumps[i-1]) == 0)
        normal_count++;

      if (strcmp(N->name, gl_lumps[i-1]) == 0)
        gl_count++;
    }

    if (normal_count != 4 && gl_count != 4)
      continue;

#if DEBUG_DIR
    PrintDebug("Found level name: %s\n", L->name);
#endif

    // check for invalid name and duplicate levels
    if (normal_count == 4 && strlen(L->name) > 5)
      PrintWarn("Bad level '%s' in wad (name too long)\n", L->name);
    else if (CheckLevelName(L->name))
      PrintWarn("Level name '%s' found twice in wad\n", L->name);
    else
      AddLevelName(L->name);
  }
}


void wad_c::ProcessDirEntry(lump_c *lump)
{
  // --- LEVEL MARKERS ---

  if (CheckLevelName(lump->name))
  {
    lump->lev_info = NewLevel(0);

    current_level = lump;

#if DEBUG_DIR
    PrintDebug("Process level... %s\n", lump->name);
#endif

    dir.push_back(lump);
    return;
  }

  // --- LEVEL LUMPS ---

  if (current_level)
  {
    if (HasGLPrefix(current_level->name) ?
        CheckGLLumpName(lump->name) : CheckLevelLumpName(lump->name))
    {
      // check for duplicates
      if (FindLumpInLevel(lump->name))
      {
        PrintWarn("Duplicate entry '%s' ignored in %s\n",
            lump->name, current_level->name);

        delete lump;
        return;
      }

#if DEBUG_DIR
      PrintDebug("        |--- %s\n", lump->name);
#endif
      // link it in
      current_level->lev_info->children.push_back(lump);
      return;
    }

    // non-level lump -- end previous level and fall through.
    current_level = NULL;
  }

  // --- ORDINARY LUMPS ---

#if DEBUG_DIR
  PrintDebug("Process dir... %s\n", lump->name);
#endif

  if (CheckLevelLumpName(lump->name))
    PrintWarn("Level lump '%s' found outside any level\n", lump->name);
  else if (CheckGLLumpName(lump->name))
    PrintWarn("GL lump '%s' found outside any level\n", lump->name);

  // link it in
  dir.push_back(lump);
}


void wad_c::ReadDirectory()
{
  fseek(in_file, dir_start, SEEK_SET);

  for (int i = 0; i < num_entries; i++)
  {
    ReadDirEntry();
  }

  DetermineLevelNames();

  // finally, unlink all lumps and process each one in turn

  std::vector<lump_c *> temp;
  
  temp.swap(dir);

  for (unsigned int kk = 0; kk < temp.size(); kk++)
  {
    ProcessDirEntry(temp[kk]);
  }
}


/* ---------------------------------------------------------------- */


void wad_c::CacheLump(lump_c *lump)
{
  size_t len;

#if DEBUG_LUMP
  PrintDebug("Reading... %s (%d)\n", lump->name, lump->length);
#endif

  if (lump->length == 0)
    return;

  lump->data = UtilCalloc(lump->length);

  fseek(in_file, lump->start, SEEK_SET);

  len = fread(lump->data, lump->length, 1, in_file);

  if (len != 1)
  {
    if (current_level)
      PrintWarn("Trouble reading lump '%s' in %s\n",
          lump->name, current_level->name);
    else
      PrintWarn("Trouble reading lump '%s'\n", lump->name);
  }
}


bool wad_c::FindLevel(const char *map_name)
{
  current_level = NULL;

  for (unsigned int kk = 0; kk < dir.size(); kk++)
  {
    lump_c *L = dir[kk];

    if (! L->lev_info)
      continue;

    if (L->lev_info->flags & LEVEL_IS_GL)  // @@@@
      continue;

    if (UtilStrCaseCmp(L->name, map_name) == 0)
    {
      current_level = L;
      break;
    }
  }

  return (current_level != NULL);
}


const char *wad_c::FirstLevelName()
{
  for (unsigned int kk = 0; kk < dir.size(); kk++)
  {
    lump_c *L = dir[kk];

    if (L->lev_info)
      return L->name;
  }

  return NULL;
}


lump_c *wad_c::FindLumpInLevel(const char *name)
{
  SYS_ASSERT(current_level);

  for (unsigned int kk = 0; kk < current_level->lev_info->children.size(); kk++)
  {
    lump_c *L = current_level->lev_info->children[kk];

    if (strcmp(L->name, name) == 0)
      return L;
  }

  return NULL;  // not found
}


wad_c *wad_c::Load(const char *filename)
{
  wad_c *wad = new wad_c();

  // open input wad file & read header
  wad->in_file = fopen(filename, "rb");

  if (! wad->in_file)
  {
    PrintWarn("Cannot open WAD file %s : %s\n", filename, strerror(errno));
    return NULL;
  }

  if (! wad->ReadHeader())
    return NULL;

  PrintDebug("Opened %cWAD file : %s\n", (wad->kind == IWAD) ? 'I' : 'P', 
      filename); 
  PrintDebug("Reading %d dir entries at 0x%X\n", wad->num_entries, 
      wad->dir_start);

  // read directory
  wad->ReadDirectory();

  wad->current_level = NULL;

  return wad;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
