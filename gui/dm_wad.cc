//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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
#include "g_lua.h"

#include "csg_main.h"

#include "dm_extra.h"
#include "dm_level.h"
#include "dm_wad.h"
#include "q_bsp.h"  // qLump_c


bool wad_hexen;  // FIXME: not global

static std::vector<qLump_c *> patch_lumps;
static std::vector<qLump_c *> flat_lumps;

static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;

static int write_errors_seen; // FIXME: no longer used!
static int seek_errors_seen;


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

void DM_WriteLump(const char *name, const void *data, u32_t len)
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

void DM_WriteLump(const char *name, qLump_c *lump)
{
  DM_WriteLump(name, lump->GetBuffer(), lump->GetSize());
}

static void DM_WriteBehavior()
{
  raw_behavior_header_t behavior;

  strncpy(behavior.marker, "ACS", 4);

  behavior.offset   = LE_U32(8);
  behavior.func_num = 0;
  behavior.str_num  = 0;

  DM_WriteLump("BEHAVIOR", &behavior, sizeof(behavior));
}


static void ClearPatches()
{
  for (unsigned int i = 0; i < patch_lumps.size(); i++)
  {
    delete patch_lumps[i];
    patch_lumps[i] = NULL;
  }

  patch_lumps.clear();
}

void DM_AddPatch(const char *name, qLump_c *lump)
{
  lump->SetName(name);

  patch_lumps.push_back(lump);
}

static void WritePatches()
{
  if (patch_lumps.size() == 0)
    return;

  DM_WriteLump("PP_START", NULL, 0);

  for (unsigned int i = 0; i < patch_lumps.size(); i++)
  {
    qLump_c *lump = patch_lumps[i];

    DM_WriteLump(lump->GetName(), lump);
  }

  DM_WriteLump("PP_END", NULL, 0);

  ClearPatches();
}

#if 0
static void DM_OldWritePatches()
{
  // !!! TODO !!!
  // ============
  //
  // Open a wad in the data/ folder containing some patches
  // (and plain lumps), and add these into the current wad.
  //
  // Let Lua code specify name of data/ wad and lump/patch
  // names to merge.  Have this code in dm_extra.cc

  const char *filename = StringPrintf("%s/data/%s.lmp", install_path, ext_patches[i]);

  int length;

  u8_t *data = FileLoad(filename, &length);

  if (! data)
    Main_FatalError("Missing data file: %s.lmp", ext_patches[i]);

  DM_WriteLump(ext_patches[i], data, length);

  FileFree(data);
}
#endif


static void ClearFlats()
{
  for (unsigned int i = 0; i < flat_lumps.size(); i++)
  {
    delete flat_lumps[i];
    flat_lumps[i] = NULL;
  }

  flat_lumps.clear();
}

void DM_AddFlat(const char *name, qLump_c *lump)
{
  lump->SetName(name);

  flat_lumps.push_back(lump);
}

static void WriteFlats()
{
  if (flat_lumps.size() == 0)
    return;

  DM_WriteLump("FF_START", NULL, 0);

  for (unsigned int i = 0; i < flat_lumps.size(); i++)
  {
    qLump_c *lump = flat_lumps[i];

    DM_WriteLump(lump->GetName(), lump);
  }

  // must end with F_END (a single 'F') to be compatible
  // with vanilla doom.
  DM_WriteLump("F_END", NULL, 0);

  ClearFlats();
}



static void CreateInfoLump()
{
  qLump_c *L = new qLump_c();

  L->SetCRLF(true);

  L->Printf("\n");
  L->Printf("-- Levels created by OBLIGE %s\n", OBLIGE_VERSION);
  L->Printf("-- " OBLIGE_TITLE " (C) 2006-2009 Andrew Apted\n");
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

  DM_WriteLump("OBLIGDAT", L);

  delete L;
}


bool DM_StartWAD(const char *filename)
{
  if (! WAD_OpenWrite(filename))
  {
    DLG_ShowError("Unable to create wad file:\n%s", strerror(errno));
    return false;
  }

  write_errors_seen = 0;
  seek_errors_seen  = 0;

  wad_hexen = false;

  ClearPatches();
  ClearFlats();

  CreateInfoLump();

  BEX_Start();
  DDF_Start();
  DED_Start();

  return true; //OK
}


bool DM_EndWAD(void)
{
  WriteFlats();
  WritePatches();

  BEX_Finish();
  DDF_Finish();
  DED_Finish();

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
}


void DM_EndLevel(const char *level_name)
{
  DM_WriteLump(level_name, NULL, 0);

  DM_WriteLump("THINGS",   thing_lump);
  DM_WriteLump("LINEDEFS", linedef_lump);
  DM_WriteLump("SIDEDEFS", sidedef_lump);
  DM_WriteLump("VERTEXES", vertex_lump);

  DM_WriteLump("SEGS",     NULL, 0);
  DM_WriteLump("SSECTORS", NULL, 0);
  DM_WriteLump("NODES",    NULL, 0);
  DM_WriteLump("SECTORS",  sector_lump);

  if (wad_hexen)
    DM_WriteBehavior();

  // free data
  delete thing_lump;   thing_lump   = NULL;
  delete sector_lump;  sector_lump  = NULL;
  delete vertex_lump;  vertex_lump  = NULL;
  delete sidedef_lump; sidedef_lump = NULL;
  delete linedef_lump; linedef_lump = NULL;
}


//------------------------------------------------------------------------

void DM_AddVertex(int x, int y)
{
  raw_vertex_t vert;

  vert.x = LE_S16(x);
  vert.y = LE_S16(y);

  vertex_lump->Append(&vert, sizeof(vert));
}


void DM_AddSector(int f_h, const char * f_tex, 
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


void DM_AddSidedef(int sector, const char *l_tex,
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


void DM_AddLinedef(int vert1, int vert2, int side1, int side2,
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


void DM_AddThing(int x, int y, int h, int type, int angle, int options,
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


int DM_NumVertexes(void)
{
  return vertex_lump->GetSize() / sizeof(raw_vertex_t);
}

int DM_NumSectors(void)
{
  return sector_lump->GetSize() / sizeof(raw_sector_t);
}

int DM_NumSidedefs(void)
{
  return sidedef_lump->GetSize() / sizeof(raw_sidedef_t);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
