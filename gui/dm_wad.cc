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
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_wad.h"

#include "main.h"
#include "g_image.h"

#include "csg_main.h"

#include "dm_level.h"
#include "dm_wad.h"
#include "q_bsp.h"  // qLump_c


bool wad_hexen;  // FIXME: not global

static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;

static int write_errors_seen;
static int seek_errors_seen;


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
    { "WALL52_1", "WALL53_1" },  // Doom    : CEMENT1,  CEMENT2
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

 
  L->Printf("-- Game Settings --\n");
  L->Printf("%s\n", main_win->game_box->GetAllValues());

  L->Printf("-- Level Architecture --\n");
  L->Printf("%s\n", main_win->level_box->GetAllValues());

  L->Printf("-- Playing Style --\n");
  L->Printf("%s\n", main_win->play_box->GetAllValues());

//L->Printf("-- Custom Mods --\n");
//L->Printf("%s\n", main_win->mod_box->GetAllValues());

//L->Printf("-- Custom Options --\n");
//L->Printf("%s\n", main_win->option_box->GetAllValues());

  L->Printf("\n\n\n\n\n\n");

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
