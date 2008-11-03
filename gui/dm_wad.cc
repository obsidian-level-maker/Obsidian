//------------------------------------------------------------------------
//  LEVEL building - DOOM format
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
#include "lib_wad.h"

#include "main.h"
#include "g_image.h"
#include "g_lua.h"

#include "csg_main.h"

#include "dm_level.h"
#include "dm_wad.h"
#include "q_bsp.h"  // qLump_c

#include "img_all.h"
#include "tx_forge.h"
#include "tx_skies.h"


bool wad_hexen;  // FIXME: not global

static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;

static int write_errors_seen;
static int seek_errors_seen;


static void AddPost(qLump_c *lump, int y, const byte *pixels, int W, int len)
{
  SYS_ASSERT(len > 0);

  byte buffer[288];
  byte *dest = buffer;

  *dest++ = y;     // Y-OFFSET
  *dest++ = len;   // # PIXELS

  *dest++ = *pixels;  // TOP-PADDING

  for (; len > 0; len--, pixels += W)
    *dest++ = *pixels;

  pixels -= W;

  *dest++ = *pixels;  // BOTTOM-PADDING

  lump->Append(buffer, dest - buffer);
}

static void EndOfPost(qLump_c *lump)
{
  byte datum = 255;

  lump->Append(&datum, 1);
}

qLump_c * WAD_BlockToPatch(int new_W, const byte *pixels, int W, int H)
{
  // creates a DOOM patch image from a _SOLID_ block of pixels.

  SYS_ASSERT(H <= 128);

  qLump_c *lump = new qLump_c();

  raw_patch_header_t header;

  header.width    = LE_U16(new_W);
  header.height   = LE_U16(H);
  header.x_offset = LE_U16(new_W / 2);
  header.y_offset = LE_U16(H);

  lump->Append(&header, sizeof(header));


  u32_t *offsets = new u32_t[new_W];

  for (int k = 0; k < new_W; k++)
  {
    if (k < W)
      offsets[k] = sizeof(raw_patch_header_t) + (new_W * 4) + k * (H + 5);
    else
      offsets[k] = offsets[k % W];

    offsets[k] = LE_U32(offsets[k]);
  }

  lump->Append(offsets, new_W * sizeof(u32_t));


  for (int x = 0; x < W; x++)
  {
    AddPost(lump, 0, pixels+x, W, H);
    EndOfPost(lump);
  }

  return lump;
}

static void WAD_WriteLump(const char *name, qLump_c *lump);


static void SkyTest2()
{
  std::vector<byte> star_cols;

  static byte star_mapping[15] =
  {
    8, 7, 6, 5,
    111, 109, 107, 104, 101,
    98, 95, 91, 87, 83,
    4
  };

  for (int k=0; k < 15; k++)
    star_cols.push_back(star_mapping[k]);

///  byte *pixels = SKY_GenStars(3, 256,128, star_cols, 2.0);


  std::vector<byte> cloud_cols;

  static byte cloud_mapping[14] =
  {
    106,104,102,100,
    98,96,94,92,90,
    88,86,84,82,80
  };

  static byte hell_mapping[14] =
  {
    188,185,184,183,182,181,180,
    179,178,177,176,175,174,173
  };

  static byte blue_mapping[14] =
  {
    245,245,244,244,243,242,241,
    240,206,205,204,204,203,203
  };


  for (int n=0; n < 14; n++)
    cloud_cols.push_back(blue_mapping[n]);

//  byte *pixels = SKY_GenClouds(5, 256,128, cloud_cols, 3.0, 2.6, 1.0);
  byte *pixels = SKY_GenGradient(256,128, cloud_cols);


  static byte hill_mapping[10] =
  {
    0, 2, 1,
    79, 77, 75, 73, 70, 67, 64,
  };

  static byte hill_of_hell[10] =
  {
    0, 6,
    47, 45, 43, 41, 39, 37, 35, 33
  };

  std::vector<byte> hill_cols;

  for (int i=0; i < 10; i++)
    hill_cols.push_back(hill_of_hell[i]);

//  SKY_AddHills(5, pixels, 256,128, hill_cols, 0.2,0.9, 2.1,2.1);


  std::vector<byte> build_cols;

  build_cols.push_back(0);
  build_cols.push_back(3);

  SKY_AddBuilding(1, pixels, 256, 128, build_cols,   4,32, 61,40,  90,2,2);
  SKY_AddBuilding(2, pixels, 256, 128, build_cols,  90,40, 31,30,  50,2,2);
  SKY_AddBuilding(3, pixels, 256, 128, build_cols, 200,48, 71,40,  70,2,2);

  build_cols[1] = 162;
  SKY_AddBuilding(4, pixels, 256, 128, build_cols,  40,20, 122,0,  30,1,1);
  SKY_AddBuilding(5, pixels, 256, 128, build_cols, 150,32, 91, 0,  60,1,1);


  qLump_c *lump = WAD_BlockToPatch(256, pixels, 256, 128);

  WAD_WriteLump("RSKY1", lump);

  delete lump;

  delete[] pixels;
}

static void LogoTest1()
{
  byte *pixels = new byte[128*128];

  static byte bronze_mapping[13] =
  {
    0, 2,
    191, 189, 187,
    235, 233,
    223, 221, 219, 216, 213, 210
  };

  static byte green_mapping[12] =
  {
    0, 7,
    127, 126, 125, 124, 123, 122, 120, 118, 116, 113
  };


  for (int y = 0; y < 128; y++)
  for (int x = 0; x < 128; x++)
  {
    byte ity = logo_RELIEF.data[(y&63)*64+(x&63)];

    pixels[y*128+x] = green_mapping[(ity*12)/256];
  }

  qLump_c *lump = WAD_BlockToPatch(128, pixels, 128, 128);

  WAD_WriteLump("WALL52_1", lump);

  delete lump;
  delete[] pixels;
}


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

static void WAD_WriteLump(const char *name, const void *data, u32_t len)
{
  SYS_ASSERT(strlen(name) <= 8);

  WAD_NewLump(name);

  if (len > 0)
  {
    // FIXME: check error
    WAD_AppendData(data, len);
  }

  WAD_FinishLump();
}

static void WAD_WriteLump(const char *name, qLump_c *lump)
{
  WAD_WriteLump(name, &lump->buffer[0], lump->buffer.size());
}

static void WAD_WriteBehavior()
{
  raw_behavior_header_t behavior;

  strncpy(behavior.marker, "ACS", 4);

  behavior.offset   = LE_U32(8);
  behavior.func_num = 0;
  behavior.str_num  = 0;

  WAD_WriteLump("BEHAVIOR", &behavior, sizeof(behavior));
}

static void WAD_WritePatches()
{
  WAD_WriteLump("PP_START", NULL, 0);

  static const char *patch_names[3][2] =
  {
/* !!!! */    { "WALL52_X", "WALL53_1" },  // Doom    : CEMENT1,  CEMENT2
    { "WALL00",   "WALL42"   },  // Heretic : GRSKULL2, CHAINSD
    { "W_320",    "W_321"    }   // Hexen   : BRASS3,   BRASS4
  };

  const char *game_str = main_win->game_box->game->GetID();
  
  int game = 0;
  if (strcmp(game_str, "heretic") == 0)
    game = 1;
  if (strcmp(game_str, "hexen") == 0)
    game = 2;

  for (int what=0; what < 2; what++)
  {
    // Heretic's WALL42 patch is only 64 wide
    int patch_w = (game == 1 && what == 1) ? 64 : 128;

    int length;
    const byte *pat = Image_MakePatch(what, &length, patch_w, game_str);

    WAD_WriteLump(patch_names[game][what], pat, length);

    Image_FreePatch(pat);
  }

  // load some patches from external files (DOOM only)
  if (game == 0)
  {
    static const char *ext_patches[] =
    {
      "W74A_1",   "W74A_2", "W74B_1",         // FIREMAGx (water)
      "WALL64_2", "W64B_1", "W64B_2",         // ROCKREDx (lava)
      "RP2_1",    "RP2_2",  "RP2_3", "RP2_4", // BLODRIPx (blood)
      "TP5_1",    "TP5_2",  "TP5_3", "TP5_4", // BLODGRx  (nukage)

      NULL // end marker
    };

    for (int i=0; ext_patches[i]; i++)
    {
      const char *filename = StringPrintf("%s/data/%s.lmp", install_path, ext_patches[i]);

      int length;

      u8_t *data = FileLoad(filename, &length);

      if (! data)
        Main_FatalError("Missing data file: %s.lmp", ext_patches[i]);

      WAD_WriteLump(ext_patches[i], data, length);

      FileFree(data);
    }
  }

  SkyTest2();

  WAD_WriteLump("PP_END", NULL, 0);
}


void WAD_CreateInfoLump()
{
  qLump_c *L = new qLump_c();

  L->SetCRLF(true);

  L->Printf("\n");
  L->Printf("-- Levels created by OBLIGE %s\n", OBLIGE_VERSION);
  L->Printf("-- " OBLIGE_TITLE " (C) 2006-2008 Andrew Apted\n");
  L->Printf("-- http://oblige.sourceforge.net/\n");
  L->Printf("\n");

  std::vector<std::string> lines;

  ob_read_all_config(&lines, false /* all_opts */);

  for (unsigned int i = 0; i < lines.size(); i++)
    L->Printf("%s\n", lines[i].c_str());
 
  L->Printf("\n\n\n");

  // terminate lump with ^Z and a NUL character
  static const byte terminator[2] = { 26, 0 };

  L->Append(terminator, 2);

  WAD_WriteLump("OBLIGDAT", L);

  delete L;
}


bool DM_Start(const char *filename)
{
  if (! WAD_OpenWrite(filename))
  {
    DLG_ShowError("Unable to create wad file:\n%s", strerror(errno));
    return false;
  }

  write_errors_seen = 0;
  seek_errors_seen  = 0;

  wad_hexen = false;

  WAD_CreateInfoLump();  // FIXME: move out ??

  return true; //OK
}


bool DM_End(void)
{
  WAD_WritePatches();  // FIXME: move out ??
 
  // FIXME: errors????
  WAD_CloseWrite();

  return (write_errors_seen == 0) && (seek_errors_seen == 0);
}


void DM_BeginLevel(void)
{
  thing_lump   = new qLump_c();
  vertex_lump  = new qLump_c();
  sector_lump  = new qLump_c();
  linedef_lump = new qLump_c();
  sidedef_lump = new qLump_c();

  thing_lump  ->SetCRLF(true);
  vertex_lump ->SetCRLF(true);
  sector_lump ->SetCRLF(true);
  linedef_lump->SetCRLF(true);
  sidedef_lump->SetCRLF(true);
}


void DM_EndLevel(const char *level_name)
{
  WAD_WriteLump(level_name, NULL, 0);

  WAD_WriteLump("THINGS",   thing_lump);
  WAD_WriteLump("LINEDEFS", linedef_lump);
  WAD_WriteLump("SIDEDEFS", sidedef_lump);
  WAD_WriteLump("VERTEXES", vertex_lump);

  WAD_WriteLump("SEGS",     NULL, 0);
  WAD_WriteLump("SSECTORS", NULL, 0);
  WAD_WriteLump("NODES",    NULL, 0);
  WAD_WriteLump("SECTORS",  sector_lump);

  if (wad_hexen)
    WAD_WriteBehavior();

  // free data
  delete thing_lump;   thing_lump   = NULL;
  delete sector_lump;  sector_lump  = NULL;
  delete vertex_lump;  vertex_lump  = NULL;
  delete sidedef_lump; sidedef_lump = NULL;
  delete linedef_lump; linedef_lump = NULL;
}


//------------------------------------------------------------------------


namespace wad
{

void add_vertex(int x, int y)
{
  raw_vertex_t vert;

  vert.x = LE_S16(x);
  vert.y = LE_S16(y);

  vertex_lump->Append(&vert, sizeof(vert));
}


void add_sector(int f_h, const char * f_tex, 
                int c_h, const char * c_tex,
                int light, int special, int tag)
{
  raw_sector_t sec;

  sec.floor_h = LE_S16(f_h);
  sec.ceil_h  = LE_S16(c_h);

  strncpy(sec.floor_tex, f_tex, 8);
  strncpy(sec.ceil_tex,  c_tex, 8);

  sec.light   = LE_U16(light);
  sec.special = LE_U16(special);
  sec.tag     = LE_S16(tag);

  sector_lump->Append(&sec, sizeof(sec));
}


void add_sidedef(int sector, const char *l_tex,
                 const char *m_tex, const char *u_tex,
                 int x_offset, int y_offset)
{
  raw_sidedef_t side;

  side.sector = LE_S16(sector);

  strncpy(side.lower_tex, l_tex, 8);
  strncpy(side.mid_tex,   m_tex, 8);
  strncpy(side.upper_tex, u_tex, 8);

  side.x_offset = LE_S16(x_offset);
  side.y_offset = LE_S16(y_offset);

  sidedef_lump->Append(&side, sizeof(side));
}


void add_linedef(int vert1, int vert2, int side1, int side2,
                 int type,  int flags, int tag,
                 const byte *args)
{
  if (! wad_hexen)
  {
    raw_linedef_t line;

    line.start = LE_U16(vert1);
    line.end   = LE_U16(vert2);

    line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
    line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

    line.type  = LE_U16(type);
    line.flags = LE_U16(flags);
    line.tag   = LE_S16(tag);

    linedef_lump->Append(&line, sizeof(line));
  }
  else  // Hexen format
  {
    raw_hexen_linedef_t line;

    // clear unused fields (specials)
    memset(&line, 0, sizeof(line));

    line.start = LE_U16(vert1);
    line.end   = LE_U16(vert2);

    line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
    line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

    line.special = type; // 8 bits
    line.flags = LE_U16(flags);

    // tag value is UNUSED

    if (args)
      memcpy(line.args, args, 5);

    linedef_lump->Append(&line, sizeof(line));
  }
}


void add_thing(int x, int y, int h, int type, int angle, int options,
               int tid, byte special, const byte *args)
{
  if (! wad_hexen)
  {
    raw_thing_t thing;

    thing.x = LE_S16(x);
    thing.y = LE_S16(y);

    thing.type    = LE_U16(type);
    thing.angle   = LE_S16(angle);
    thing.options = LE_U16(options);

    thing_lump->Append(&thing, sizeof(thing));
  }
  else  // Hexen format
  {
    raw_hexen_thing_t thing;

    // clear unused fields (tid, specials)
    memset(&thing, 0, sizeof(thing));

    thing.x = LE_S16(x);
    thing.y = LE_S16(y);

    thing.height  = LE_S16(h);
    thing.type    = LE_U16(type);
    thing.angle   = LE_S16(angle);
    thing.options = LE_U16(options);

    thing.tid     = LE_S16(tid);
    thing.special = special;

    if (args)
      memcpy(thing.args, args, 5);

    thing_lump->Append(&thing, sizeof(thing));
  }
}


int num_vertexes(void)
{
  return vertex_lump->buffer.size() / sizeof(raw_vertex_t);
}

int num_sectors(void)
{
  return sector_lump->buffer.size() / sizeof(raw_sector_t);
}

int num_sidedefs(void)
{
  return sidedef_lump->buffer.size() / sizeof(raw_sidedef_t);
}

} // namespace wad


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
