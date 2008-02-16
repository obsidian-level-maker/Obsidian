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
#include "q1_pakfile.h"

#include "main.h"


// WAD2_OpenWrite
// {
//   for each pakfile do
//   {
//     PAK_OpenRead
//
//     for each map do
//       for each miptex do
//         if not already seen
//           copy miptex into WAD2 file
// 
//     PAK_CloseRead
//   }
// }
// WAD2_CloseWrite


typedef std::map<std::string, int> miptex_database_t;


static void ExtractMipTex(miptex_database_t& tex_db, int map_idx)
{
  dheader_t bsp;

  if (! PAK_ReadData(map_idx, 0, sizeof(bsp), &bsp))
    Main_FatalError("dheader_t");

  // FIXME: check version in header (for sanity)

  u32_t tex_start = LE_U32(bsp.lumps[LUMP_TEXTURES].start);
  u32_t tex_total = LE_U32(bsp.lumps[LUMP_TEXTURES].length);

fprintf(stderr, "  BSP: version:0x%08x tex:0x%08x len:0x%08x\n",
                 LE_U32(bsp.version), tex_start, tex_total);

  dmiptexlump_t header;

  if (! PAK_ReadData(map_idx, tex_start, sizeof(header), &header))
    Main_FatalError("dmiptexlump_t");

  int num_miptex = LE_S32(header.num_miptex);
  
  for (int i = 0; i < num_miptex; i++)
  {
fprintf(stderr, "  mip %d/%d\n", i+1, num_miptex);
    u32_t data_ofs;

    if (! PAK_ReadData(map_idx, tex_start + 4 + i*4, 4, &data_ofs))
      Main_FatalError("data_ofs");

    data_ofs = LE_U32(data_ofs);
fprintf(stderr, "  data_ofs=%d\n", data_ofs);

    // -1 means unused slot
    if (data_ofs & 0x8000000U)
      continue;

    miptex_t mip;

    if (! PAK_ReadData(map_idx, tex_start + data_ofs, sizeof(miptex_t), &mip))
      Main_FatalError("miptex_t");

    mip.width  = LE_U32(mip.width);
    mip.height = LE_U32(mip.height);

    mip.name[15] = 0;
fprintf(stderr, "    name:%s size:%dx%d\n", mip.name, mip.width, mip.height);

    // already seen it?
    if (tex_db.find((const char *)mip.name) != tex_db.end())
      continue;

    // sanity check
    SYS_ASSERT(mip.width  <= 2048);
    SYS_ASSERT(mip.height <= 2048);

    // Quake ignores the offsets, hence we do too!

    int pixels = (mip.width * mip.height) / 64 * 85;

    data_ofs += sizeof(mip);

    // create WAD2 lump and mark database as seen
    tex_db[(const char *)mip.name] = 1;

    WAD2_NewLump(mip.name);

    mip.width  = LE_U32(mip.width);
    mip.height = LE_U32(mip.height);

    WAD2_AppendData(&mip, (int)sizeof(mip));

    // copy the pixel data
    static byte buffer[1024];

    while (pixels > 0)
    {
      int count = MIN(pixels, 1024);

      if (! PAK_ReadData(map_idx, tex_start + data_ofs, count, buffer))
        Main_FatalError("pixels");

      WAD2_AppendData(buffer, count);

      data_ofs += (u32_t)count;
      pixels   -= count;
    }

    WAD2_FinishLump();
  }
}


void Quake1_ExtractTextures(void)
{
  if (! WAD2_OpenWrite("data/quake_tex.wad"))
  {
    Main_FatalError("FUCK");
  }

  miptex_database_t tex_db;

  for (int pp = 0; pp <= 1; pp++)
  {
    const char *filename = StringPrintf("/home/aapted/quake/id1/pak%d.pak", pp);

fprintf(stderr, "Opening: %s\n", filename);
    if (! PAK_OpenRead(filename))
    {
      Main_FatalError("SHIT");
    }

    std::vector<int> maps;

    PAK_FindMaps(maps);

    for (unsigned int m = 0; m < maps.size(); m++)
    {
fprintf(stderr, "Doing map %d/%d\n", m+1, (int)maps.size());
      ExtractMipTex(tex_db, maps[m]);
    }

    PAK_CloseRead();

    StringFree(filename);
  }

  WAD2_CloseWrite();
}


//------------------------------------------------------------------------

bool Q1_AddTextureFromWad(const char *name)
{
  int lump = WAD2_FindEntry(name);

  if (! lump)
  { }
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
