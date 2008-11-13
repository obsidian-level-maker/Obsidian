//------------------------------------------------------------------------
//  LEVEL building - QUAKE 1 format
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
#include "lib_pak.h"
#include "main.h"

#include "csg_main.h"

#include "g_image.h"
#include "ui_chooser.h"

#include "q_bsp.h"
#include "q1_main.h"
#include "q1_structs.h"


static char *level_name;


void Q1_CreateEntities(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_ENTITIES);

  /* add the worldspawn entity */

  lump->Printf("{\n");

  lump->KeyPair("_generated_by", "OBLIGE " OBLIGE_VERSION " (c) Andrew Apted");
  lump->KeyPair("_homepage", "http://oblige.sourceforge.net");

  lump->KeyPair("message",   "level created by Oblige");
  lump->KeyPair("worldtype", "0");
//lump->KeyPair("origin",    "0 0 0");
  lump->KeyPair("classname", "worldspawn");

  lump->Printf("}\n");

  // add everything else

  for (unsigned int j = 0; j < all_entities.size(); j++)
  {
    entity_info_c *E = all_entities[j];

    lump->Printf("{\n");

    // TODO: other models (doors etc) --> "model" "*45"

    // FIXME: other entity properties

    lump->KeyPair("origin", "%1.1f %1.1f %1.1f", E->x, E->y, E->z);
    lump->KeyPair("classname", E->name.c_str());

    lump->Printf("}\n");
  }

  // add a trailing nul
  u8_t zero = 0;

  lump->Append(&zero, 1);
}


//------------------------------------------------------------------------

const byte quake1_palette[256*3] =
{
    0,  0,  0,  15, 15, 15,  31, 31, 31,  47, 47, 47,  63, 63, 63,
   75, 75, 75,  91, 91, 91, 107,107,107, 123,123,123, 139,139,139,
  155,155,155, 171,171,171, 187,187,187, 203,203,203, 219,219,219,
  235,235,235,  15, 11,  7,  23, 15, 11,  31, 23, 11,  39, 27, 15,
   47, 35, 19,  55, 43, 23,  63, 47, 23,  75, 55, 27,  83, 59, 27,
   91, 67, 31,  99, 75, 31, 107, 83, 31, 115, 87, 31, 123, 95, 35,
  131,103, 35, 143,111, 35,  11, 11, 15,  19, 19, 27,  27, 27, 39,
   39, 39, 51,  47, 47, 63,  55, 55, 75,  63, 63, 87,  71, 71,103,
   79, 79,115,  91, 91,127,  99, 99,139, 107,107,151, 115,115,163,
  123,123,175, 131,131,187, 139,139,203,   0,  0,  0,   7,  7,  0,
   11, 11,  0,  19, 19,  0,  27, 27,  0,  35, 35,  0,  43, 43,  7,
   47, 47,  7,  55, 55,  7,  63, 63,  7,  71, 71,  7,  75, 75, 11,
   83, 83, 11,  91, 91, 11,  99, 99, 11, 107,107, 15,   7,  0,  0,
   15,  0,  0,  23,  0,  0,  31,  0,  0,  39,  0,  0,  47,  0,  0,
   55,  0,  0,  63,  0,  0,  71,  0,  0,  79,  0,  0,  87,  0,  0,
   95,  0,  0, 103,  0,  0, 111,  0,  0, 119,  0,  0, 127,  0,  0,
   19, 19,  0,  27, 27,  0,  35, 35,  0,  47, 43,  0,  55, 47,  0,
   67, 55,  0,  75, 59,  7,  87, 67,  7,  95, 71,  7, 107, 75, 11,
  119, 83, 15, 131, 87, 19, 139, 91, 19, 151, 95, 27, 163, 99, 31,
  175,103, 35,  35, 19,  7,  47, 23, 11,  59, 31, 15,  75, 35, 19,
   87, 43, 23,  99, 47, 31, 115, 55, 35, 127, 59, 43, 143, 67, 51,
  159, 79, 51, 175, 99, 47, 191,119, 47, 207,143, 43, 223,171, 39,
  239,203, 31, 255,243, 27,  11,  7,  0,  27, 19,  0,  43, 35, 15,
   55, 43, 19,  71, 51, 27,  83, 55, 35,  99, 63, 43, 111, 71, 51,
  127, 83, 63, 139, 95, 71, 155,107, 83, 167,123, 95, 183,135,107,
  195,147,123, 211,163,139, 227,179,151, 171,139,163, 159,127,151,
  147,115,135, 139,103,123, 127, 91,111, 119, 83, 99, 107, 75, 87,
   95, 63, 75,  87, 55, 67,  75, 47, 55,  67, 39, 47,  55, 31, 35,
   43, 23, 27,  35, 19, 19,  23, 11, 11,  15,  7,  7, 187,115,159,
  175,107,143, 163, 95,131, 151, 87,119, 139, 79,107, 127, 75, 95,
  115, 67, 83, 107, 59, 75,  95, 51, 63,  83, 43, 55,  71, 35, 43,
   59, 31, 35,  47, 23, 27,  35, 19, 19,  23, 11, 11,  15,  7,  7,
  219,195,187, 203,179,167, 191,163,155, 175,151,139, 163,135,123,
  151,123,111, 135,111, 95, 123, 99, 83, 107, 87, 71,  95, 75, 59,
   83, 63, 51,  67, 51, 39,  55, 43, 31,  39, 31, 23,  27, 19, 15,
   15, 11,  7, 111,131,123, 103,123,111,  95,115,103,  87,107, 95,
   79, 99, 87,  71, 91, 79,  63, 83, 71,  55, 75, 63,  47, 67, 55,
   43, 59, 47,  35, 51, 39,  31, 43, 31,  23, 35, 23,  15, 27, 19,
   11, 19, 11,   7, 11,  7, 255,243, 27, 239,223, 23, 219,203, 19,
  203,183, 15, 187,167, 15, 171,151, 11, 155,131,  7, 139,115,  7,
  123, 99,  7, 107, 83,  0,  91, 71,  0,  75, 55,  0,  59, 43,  0,
   43, 31,  0,  27, 15,  0,  11,  7,  0,   0,  0,255,  11, 11,239,
   19, 19,223,  27, 27,207,  35, 35,191,  43, 43,175,  47, 47,159,
   47, 47,143,  47, 47,127,  47, 47,111,  47, 47, 95,  43, 43, 79,
   35, 35, 63,  27, 27, 47,  19, 19, 31,  11, 11, 15,  43,  0,  0,
   59,  0,  0,  75,  7,  0,  95,  7,  0, 111, 15,  0, 127, 23,  7,
  147, 31,  7, 163, 39, 11, 183, 51, 15, 195, 75, 27, 207, 99, 43,
  219,127, 59, 227,151, 79, 231,171, 95, 239,191,119, 247,211,139,
  167,123, 59, 183,155, 55, 199,195, 55, 231,227, 87, 127,191,255,
  171,231,255, 215,255,255, 103,  0,  0, 139,  0,  0, 179,  0,  0,
  215,  0,  0, 255,  0,  0, 255,243,147, 255,247,199, 255,255,255,
  159, 91, 83
};

//------------------------------------------------------------------------

static std::vector<std::string>   q1_miptexs;
static std::map<std::string, int> q1_miptex_map;

s32_t Q1_AddMipTex(const char *name);

static void ClearMipTex(void)
{
  q1_miptexs.clear();
  q1_miptex_map.clear();

  // built-in textures
  Q1_AddMipTex("error");   // #0
  Q1_AddMipTex("missing"); // #1
  Q1_AddMipTex("oblige");  // #2
}

s32_t Q1_AddMipTex(const char *name)
{
  if (q1_miptex_map.find(name) != q1_miptex_map.end())
  {
    return q1_miptex_map[name];
  }

  int index = (int)q1_miptexs.size();

  q1_miptexs.push_back(name);
  q1_miptex_map[name] = index;

  return index;
}

static void CreateDummyMip(qLump_c *lump, const char *name, int pix1, int pix2)
{
  SYS_ASSERT(strlen(name) < 16);

  miptex_t mm_tex;

  strcpy(mm_tex.name, name);

  int size = 64;

  mm_tex.width  = LE_U32(size);
  mm_tex.height = LE_U32(size);

  int offset = sizeof(mm_tex);

  for (int i = 0; i < MIP_LEVELS; i++)
  {
    mm_tex.offsets[i] = LE_U32(offset);

    offset += (size * size);
    size /= 2;
  }

  lump->Append(&mm_tex, sizeof(mm_tex));


  u8_t pixels[2] = { pix1, pix2 };

  size = 64;

  for (int i = 0; i < MIP_LEVELS; i++)
  {
    for (int y = 0; y < size; y++)
    for (int x = 0; x < size; x++)
    {
      lump->Append(pixels + (((x^y) & (size/4)) ? 1 : 0), 1);
    }

    size /= 2;
  }
}

static void TransferOneMipTex(qLump_c *lump, unsigned int m, const char *name)
{
  if (strcmp(name, "error") == 0)
  {
    CreateDummyMip(lump, name, 210, 231);
    return;
  }
  if (strcmp(name, "missing") == 0)
  {
    CreateDummyMip(lump, name, 4, 12);
    return;
  }

  // TODO: "oblige"

  int entry = WAD2_FindEntry(name);

  if (entry >= 0)
  {
    int pos    = 0;
    int length = WAD2_EntryLen(entry);

    byte buffer[1024];

    while (length > 0)
    {
      int actual = MIN(1024, length);

      if (! WAD2_ReadData(entry, pos, actual, buffer))
        Main_FatalError("Error reading texture data in wad!");

      lump->Append(buffer, actual);

      pos    += actual;
      length -= actual;
    }

    // all good
    return;
  }

  // not found!
  LogPrintf("WARNING: texture '%s' not found in texture wad!\n", name);

  CreateDummyMip(lump, name, 4, 12);
}

static void Q1_CreateMipTex(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXTURES);

  if (! WAD2_OpenRead("data/quake_tex.wad"))
  {
    // this shouldn't happen, existence is checked earlier
    Main_FatalError("No such file: data/quake_tex.wad");
    return; /* NOT REACHED */
  }

  u32_t num_miptex = q1_miptexs.size();
  u32_t dir_size = 4 * num_miptex + 4;
  SYS_ASSERT(num_miptex > 0);

  u32_t *offsets = new u32_t[num_miptex];

  for (unsigned int m = 0; m < q1_miptexs.size(); m++)
  {
    offsets[m] = dir_size + (u32_t)lump->GetSize();

    TransferOneMipTex(lump, m, q1_miptexs[m].c_str());
  }

  WAD2_CloseRead();

  // create miptex directory
  // FIXME: endianness
  lump->Prepend(offsets, 4 * num_miptex);
  lump->Prepend(&num_miptex, 4);

  delete[] offsets;
}

static void DummyMipTex(void)
{
  /* TEMP DUMMY STUFF */

  // 0 = "error"
  // 1 = "gray"

  qLump_c *lump = BSP_NewLump(LUMP_TEXTURES);


  dmiptexlump_t mm_dir;

  mm_dir.num_miptex = LE_S32(2);

  mm_dir.data_ofs[0] = LE_S32(sizeof(mm_dir));
  mm_dir.data_ofs[1] = LE_S32(sizeof(mm_dir) + sizeof(miptex_t) + 85*4);

  lump->Append(&mm_dir, sizeof(mm_dir));


  for (int mt = 0; mt < 2; mt++)
  {
    miptex_t mm_tex;

    strcpy(mm_tex.name, (mt == 0) ? "error" : "gray");

    int size = 16;

    mm_tex.width  = LE_U32(size);
    mm_tex.height = LE_U32(size);

    int offset = sizeof(mm_tex);

    for (int i = 0; i < MIP_LEVELS; i++)
    {
      mm_tex.offsets[i] = LE_U32(offset);

      offset += (u32_t)(size * size);

      size = size / 2;
    }

    lump->Append(&mm_tex, sizeof(mm_tex));


    u8_t pixels[2];

    pixels[0] = (mt == 0) ? 210 : 4;
    pixels[1] = (mt == 0) ? 231 : 12;

    size = 16;

    for (int i = 0; i < MIP_LEVELS; i++)
    {
      for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++)
      {
        lump->Append(pixels + (((x^y) & 2)/2), 1);
      }

      size = size / 2;
    }
  }
}

//------------------------------------------------------------------------

static std::vector<texinfo_t> q1_texinfos;

#define NUM_TEXINFO_HASH  32
static std::vector<u16_t> * texinfo_hashtab[NUM_TEXINFO_HASH];


static void ClearTexInfo(void)
{
  q1_texinfos.clear();

  for (int h = 0; h < NUM_TEXINFO_HASH; h++)
  {
    delete texinfo_hashtab[h];
    texinfo_hashtab[h] = NULL;
  }
}

static bool MatchTexInfo(const texinfo_t *A, const texinfo_t *B)
{
  if (A->miptex != B->miptex)
    return false;

  if (A->flags != B->flags)
    return false;

  for (int k = 0; k < 4; k++)
  {
    if (fabs(A->s[k] - B->s[k]) > 0.01)
      return false;

    if (fabs(A->t[k] - B->t[k]) > 0.01)
      return false;
  }

  return true; // yay!
}

u16_t Q1_AddTexInfo(const char *texture, int flags, double *s4, double *t4)
{
  // create texinfo structure
  texinfo_t tin;

  for (int k = 0; k < 4; k++)
  {
    tin.s[k] = s4[k];
    tin.t[k] = t4[k];
  }

  tin.miptex = Q1_AddMipTex(texture);
  tin.flags  = flags;


  // find an existing texinfo.
  // For speed we use a hash-table.
  int hash = (int)tin.miptex % NUM_TEXINFO_HASH;

  SYS_ASSERT(hash >= 0);

  if (! texinfo_hashtab[hash])
    texinfo_hashtab[hash] = new std::vector<u16_t>;

  std::vector<u16_t> *hashtab = texinfo_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t tin_idx = (*hashtab)[i];

    SYS_ASSERT(tin_idx < q1_texinfos.size());

    if (MatchTexInfo(&tin, &q1_texinfos[tin_idx]))
      return tin_idx;  // found it
  }


  // not found, so add new one
  u16_t tin_idx = q1_texinfos.size();

  if (tin_idx >= MAX_MAP_TEXINFO)
    Main_FatalError("Quake1 build failure: exceeded limit of %d TEXINFOS\n",
                    MAX_MAP_TEXINFO);

  q1_texinfos.push_back(tin);

  hashtab->push_back(tin_idx);

  return tin_idx;
}

static void Q1_CreateTexInfo(void)
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  // FIXME: write separately, fix endianness as we go
 
  lump->Append(&q1_texinfos[0], q1_texinfos.size() * sizeof(texinfo_t));
}


static void DummyTexInfo(void)
{
  /* TEMP DUMMY STUFF */

  // 0 = "error" on PLANE_X / PLANE_ANYX
  // 1 = "error" on PLANE_Y / PLANE_ANYY
  // 2 = "error" on PLANE_Z / PLANE_ANYZ
  //
  // 3 = "gray"  on PLANE_X / PLANE_ANYX
  // 4 = "gray"  on PLANE_Y / PLANE_ANYY
  // 5 = "gray"  on PLANE_Z / PLANE_ANYZ

  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  float scale = 8.0;

  for (int T = 0; T < 6; T++)
  {
    int P = T % 3;

    texinfo_t tex;

    tex.s[0] = (P == PLANE_X) ? 0 : 1;
    tex.s[1] = (P == PLANE_X) ? 1 : 0;
    tex.s[2] = 0;
    tex.s[3] = 0;

    tex.t[0] = 0;
    tex.t[1] = (P == PLANE_Z) ? 1 : 0;
    tex.t[2] = (P == PLANE_Z) ? 0 : 1;
    tex.t[3] = 0;

    for (int k = 0; k < 3; k++)
    {
      tex.s[k] /= scale;
      tex.t[k] /= scale;

      // FIXME: endianness swap!
    }

    int flags = 0;

    tex.miptex = LE_S32(T / 3);
    tex.flags  = LE_S32(flags);

    lump->Append(&tex, sizeof(tex));
  }
}


//------------------------------------------------------------------------


class quake1_game_interface_c : public game_interface_c
{
private:
  const char *filename;

public:
  quake1_game_interface_c() : filename(NULL)
  { }

  ~quake1_game_interface_c()
  { }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);
};


bool quake1_game_interface_c::Start()
{
  filename = Select_Output_File("pak");

  if (! filename)  // cancelled
    return false;

  BSP_BackupPAK(filename);

  if (! PAK_OpenWrite(filename))
    return false;

  BSP_CreateInfoFile();

  main_win->build_box->ProgInit(1);

  main_win->build_box->ProgBegin(1, 100, BUILD_PROGRESS_FG);
  main_win->build_box->ProgStatus("Making levels");

  return true;
}


bool quake1_game_interface_c::Finish(bool build_ok)
{
  PAK_CloseWrite();

  // tidy up
/////  FileDelete(TEMP_FILENAME);

  return build_ok;
}


void quake1_game_interface_c::BeginLevel()
{
  // nothing needed
}


void quake1_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else
  {
    LogPrintf("WARNING: QUAKE1: unknown level prop: %s=%s\n", key, value);
  }
}


void quake1_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  if (strlen(level_name) >= 32)
    Main_FatalError("Script problem: level name too long: %s\n", level_name);

  char entry_in_pak[64];
  sprintf(entry_in_pak, "maps/%s.bsp", level_name);

  if (! BSP_OpenLevel(entry_in_pak, 1))
    return; //!!!!!! FUCK

  ClearMipTex();
  ClearTexInfo();

  BSP_PreparePlanes  (LUMP_PLANES,   MAX_MAP_PLANES);
  BSP_PrepareVertices(LUMP_VERTEXES, MAX_MAP_VERTS);
  BSP_PrepareEdges   (LUMP_EDGES,    MAX_MAP_EDGES);
  BSP_PrepareLightmap(LUMP_LIGHTING, MAX_MAP_LIGHTING);

//!!!! TEMP CRUD
byte solid_light[512];
for (int L=0; L < 512; L++) solid_light[L] = 64;
BSP_AddLightBlock(16, 32, solid_light);


  CSG2_MergeAreas();
  CSG2_MakeMiniMap();

  Q1_BuildBSP();

  Q1_CreateModel();
  Q1_CreateMipTex();
  Q1_CreateTexInfo();
  Q1_CreateEntities();

  BSP_WritePlanes();
  BSP_WriteVertices();
  BSP_WriteEdges();

  BSP_CloseLevel();

  // FREE STUFF !!!!
}


game_interface_c * Quake1_GameObject(void)
{
  return new quake1_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
