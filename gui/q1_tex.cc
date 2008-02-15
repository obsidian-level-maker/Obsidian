//------------------------------------------------------------------------
//  QUAKE 1 - Texture Extractor
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

#include <map>

#include "lib_file.h"
#include "lib_util.h"

#include "g_image.h"

#include "q1_main.h"
#include "q1_structs.h"

#include "main.h"

#ifndef PATH_MAX
#define PATH_MAX  2048
#endif


class miptex_locator_c
{
public:
  std::string filename;

  int offset;
  int length;

public:
  miptex_locator_c(std::string& _fn, int _ofs, int _len) :
      filename(_fn), offset(_ofs), length(_len)
  { }

  ~miptex_locator_c()
  { }

  bool operator< (const miptex_locator_c& other) const
  {
    int cmp = StringCaseCmp(filename.c_str(), other.filename.c_str());

    if (cmp != 0)
      return (cmp < 0);

    return offset < other.offset;
  }
};


typedef std::map<std::string, miptex_locator_c*> miptex_database_t;

static miptex_database_t miptex_db;


static bool MiptexDB_Load(const char *filename)
{
  FILE *fp = fopen(filename, "r");

  if (! fp)
  {
    DebugPrintf("MiptexDB_Load: cannot open file: %s\n", filename);
    return false;
  }
  
  char * line_buf = new char[PATH_MAX+1];

  while (fgets(line_buf, PATH_MAX, fp))
  {
    
  }

  delete[] line_buf;
  return true;
}


static bool MiptexDB_Save(const char *filename)
{
  FILE *fp = fopen(filename, "w");

  if (! fp)
  {
    DebugPrintf("MiptexDB_Save: cannot create file: %s\n", filename);
    return false;
  }

  miptex_database_t::iterator MDI;

  for (MDI = miptex_db.begin(); MDI != miptex_db.end(); MDI++)
  {
    const std::string& tex_name = MDI->first;

    fprintf(fp, "%s\n", tex_name.c_str());

    miptex_locator_c *loc = MDI->second;

    fprintf(fp, "%s\n",    loc->filename.c_str());
    fprintf(fp, "%d %d\n", loc->offset, loc->length);
  }

  fflush(fp);
  fclose(fp);

  return true;
}


void Quake1_ExtractTextures(void)
{
  
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
