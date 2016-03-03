//------------------------------------------------------------------------
//  QUAKE 1 - Texture Extractor
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006-2009 Andrew Apted
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
#include "lib_pak.h"
#include "main.h"

#include "ui_chooser.h"


#include "q_bsp.h"
#include "q1_main.h"
#include "q1_structs.h"


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


#define EXTRACT_PROGRESS_FG  fl_color_cube(2,4,4)

#define QUAKE1_TEX_WAD  "data/quake_tex.wad"


static void ExtractMipTex(miptex_database_t& tex_db, int map_idx)
{
  dheader_t bsp;

  if (! PAK_ReadData(map_idx, 0, sizeof(bsp), &bsp))
    Main_FatalError("dheader_t");

  bsp.version = LE_S32(bsp.version);

  u32_t tex_start = LE_U32(bsp.lumps[LUMP_TEXTURES].start);
  u32_t tex_total = LE_U32(bsp.lumps[LUMP_TEXTURES].length);

  DebugPrintf("BSP: version:0x%08x tex:0x%08x len:0x%08x\n",
              bsp.version, tex_start, tex_total);

  // check version in header (for sanity)
  if (bsp.version < 0x17 || bsp.version > 0x1F)
    Main_FatalError("bad version in BSP");

  // no textures?
  if (tex_total == 0)
    return;

  dmiptexlump_t header;

  if (! PAK_ReadData(map_idx, tex_start, sizeof(header), &header))
    Main_FatalError("dmiptexlump_t");

  int num_miptex = LE_S32(header.num_miptex);
  
  for (int i = 0; i < num_miptex; i++)
  {
//fprintf(stderr, "  mip %d/%d\n", i+1, num_miptex);
    u32_t data_ofs;

    if (! PAK_ReadData(map_idx, tex_start + 4 + i*4, 4, &data_ofs))
      Main_FatalError("data_ofs");

    data_ofs = LE_U32(data_ofs);
//fprintf(stderr, "  data_ofs=%d\n", data_ofs);

    // -1 means unused slot
    if (data_ofs & 0x8000000U)
      continue;

    miptex_t mip;

    if (! PAK_ReadData(map_idx, tex_start + data_ofs, sizeof(miptex_t), &mip))
      Main_FatalError("miptex_t");

    mip.width  = LE_U32(mip.width);
    mip.height = LE_U32(mip.height);

    mip.name[15] = 0;

    DebugPrintf("    mip %2d/%d name:%s size:%dx%d\n",
                i+1, num_miptex, mip.name, mip.width, mip.height);

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


bool Do_ExtractTextures(const char *dest_file, std::vector<std::string>& src_files)
{
  SYS_ASSERT(src_files.size() > 0);

  if (! WAD2_OpenWrite(dest_file))
  {
    Main_FatalError("Could not create file: %s", dest_file);
    return false; /* NOT REACHED */
  }

  miptex_database_t tex_db;

  // assumes majority of the textures are in PAK1
  int total = 100 * (int)src_files.size() + (src_files.size() >= 2 ? 300 : 0);
  int where = 0;

  UI_Build *bb_area = main_win->build_box;

  bb_area->ProgBegin(0, total, EXTRACT_PROGRESS_FG);

  bool aborted = false;

  for (unsigned int pp = 0; pp < src_files.size(); pp++)
  {
    int pp_total = (pp == 1) ? 400 : 100;

    const char *filename = src_files[pp].c_str();

    LogPrintf("Opening: %s\n", filename);

    if (! PAK_OpenRead(filename))
    {
      // should not happen because we have checked that the files exist
      Main_FatalError("Could not open file: %s", filename);
      return false; /* NOT REACHED */
    }

    std::vector<int> maps;

    PAK_FindMaps(maps);

    for (unsigned int m = 0; m < maps.size(); m++)
    {
      DebugPrintf("Doing map %d/%d\n", m+1, (int)maps.size());

      ExtractMipTex(tex_db, maps[m]);

      // TimeDelay(100); // TESTING ONLY !

      // this update function calls Main_Ticker() for us
      bb_area->ProgUpdate(where + pp_total * m / (int)maps.size());

      if (main_win->action >= UI_MainWin::ABORT)
      {
        aborted = true;
        break;
      }
    }

    where += pp_total;

    PAK_CloseRead();

    if (aborted)
      break;
  }

  WAD2_CloseWrite();

  // show 100% complete unless aborted
  if (! aborted)
    bb_area->ProgUpdate(where);

  return aborted;
}


//------------------------------------------------------------------------

static const char *quake1_game_folders[] =
{
#ifdef WIN32
  "\\QUAKE",
  "\\Program Files\\Quake",

#else // LINUX or MACOSX
  "$HOME/quake",
  "$HOME/Quake",
  "$HOME/QUAKE",

  "$HOME/games/quake",
  "$HOME/Games/quake",
  "$HOME/Games/Quake",

  "/usr/share/games/quake",
  "/usr/games/quake",
  "/usr/local/games/quake",
  "/usr/local/share/games/quake",
  "/opt/quake",
#endif

  NULL  // end of list
};

static void CatUpperLower(char *dest, const char *src, int upper)
{
  dest += strlen(dest);

  for (; *src; src++)
  {
    *dest++ = upper ? toupper(*src) : tolower(*src);
  }

  *dest = 0;
}

static bool Q1_DetectInstallation(extract_info_t *info)
{
  char *name_buf = StringNew(FL_PATH_MAX);

  for (int i = 0; quake1_game_folders[i]; i++)
  {
    for (int k = 0; k < 4; k++)
    {
      fl_filename_expand(name_buf, quake1_game_folders[i]);

      strcat(name_buf, DIR_SEP_STR);

      if (info->dir)
      {
        CatUpperLower(name_buf, info->dir, k & 2);
        strcat(name_buf, DIR_SEP_STR);
      }

      CatUpperLower(name_buf, info->file, k & 1);

      DebugPrintf("Checking Quake1 installation at: %s\n", name_buf);

      if (FileExists(name_buf))
      {
        LogPrintf("Found Quake1 installation: %s\n", name_buf);
        info->detected = name_buf;
        return true;
      }
    }
  }

  LogPrintf("Quake1 installation not found\n");

  return false;
}

static void Q1_AdditionalPAKs(const char *first_pak, std::vector<std::string>& out_files)
{
  out_files.push_back(first_pak);

  const char *base = FindBaseName(first_pak);

  if (StringCaseCmpPartial(base, "pak0.") != 0)
    return;

  // the 'base' pointer is always inside the given filename,
  // hence this offset calculation is valid. 
  int offset = base - first_pak;

  char *next_pak = StringDup(first_pak);

  for (int n = 1; n < 10; n++)
  {
    next_pak[offset+3] = ('0' + n);

    DebugPrintf("Checking for additional pak: %s\n", next_pak);

    if (! FileExists(next_pak))
      break;

    LogPrintf("Using additional pak: %s\n", next_pak);

    out_files.push_back(next_pak);
  }

  StringFree(next_pak);
}


bool Quake1_ExtractTextures(void)
{
  extract_info_t info =
  {
    "Quake1",
    "the textures",
    "pak0.pak",
    "id1",
    NULL
  };

  Q1_DetectInstallation(&info);

  int res = DLG_ExtractStuff(&info);

  if (res == EXDLG_Abort)
    return false;

  const char *filename = info.detected;

  if (! (filename && res == EXDLG_UseDetected))
  {
    filename = Select_Input_File("pak");

    if (! filename)
      return false;
  }

  if (! FileExists(filename))
  {
    Main_FatalError("No such file: %s", filename);
    return false; /* NOT REACHED */
  }


  std::vector<std::string> pak_list;

  Q1_AdditionalPAKs(filename, pak_list);


  UI_Build *bb_area = main_win->build_box;

  // lock most widgets of user interface
  main_win->Locked(true);

  bb_area->ProgInit(1);
  bb_area->ProgSetButton(true);
  bb_area->ProgStatus("Extracting Textures");

  bool aborted = Do_ExtractTextures(QUAKE1_TEX_WAD, pak_list);

  if (aborted)
    bb_area->ProgStatus("Aborted");

  for (int pause = 0; pause < 6; pause++)
  {
    Main_Ticker(); TimeDelay(300);
  }

  if (! aborted)
    bb_area->ProgStatus("Success");

  bb_area->ProgFinish();
  bb_area->ProgSetButton(false);

  main_win->Locked(false);

  return !aborted;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
