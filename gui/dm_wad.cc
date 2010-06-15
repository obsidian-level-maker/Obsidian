//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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
#include "ui_chooser.h"
#include "csg_main.h"

#include "dm_extra.h"
#include "dm_glbsp.h"
#include "dm_wad.h"
#include "q_bsp.h"  // qLump_c


extern void DM_WriteDoom(void);
extern void DM_FreeLevelStuff(void);

static char *level_name;

bool wad_hexen;  // FIXME: not global (next 3 too)

extern int solid_exfloor;    // disabled if <= 0
extern int liquid_exfloor;

static qLump_c *thing_lump;
static qLump_c *vertex_lump;
static qLump_c *sector_lump;
static qLump_c *sidedef_lump;
static qLump_c *linedef_lump;

static int errors_seen;

typedef std::vector<qLump_c *> lump_bag_t;

typedef enum
{
  SECTION_Patches = 0,
  SECTION_Sprites,
  SECTION_Colormaps,
  SECTION_ZDoomTex,
  SECTION_Flats,

  NUM_SECTIONS
}
wad_section_e;

static lump_bag_t * sections[NUM_SECTIONS];

static const char * section_markers[NUM_SECTIONS * 2] =
{
  "PP_START", "PP_END",
  "SS_START", "SS_END",
  "C_START",  "C_END",
  "TX_START", "TX_END",

  // flats must end with F_END (a single 'F') to be vanilla compatible
  "FF_START", "F_END"
};


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

void DM_WriteLump(const char *name, const void *data, u32_t len)
{
  SYS_ASSERT(strlen(name) <= 8);

  WAD_NewLump(name);

  if (len > 0)
  {
    if (! WAD_AppendData(data, len))
    {
      errors_seen++;
    }
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


static void ClearSections()
{
  for (int k = 0; k < NUM_SECTIONS; k++)
  {
    if (! sections[k])
      sections[k] = new lump_bag_t;

    for (unsigned int i = 0; i < sections[k]->size(); i++)
    {
      delete sections[k]->at(i);
      sections[k]->at(i) = NULL;
    }

    sections[k]->clear();
  }
}

void DM_AddSectionLump(char ch, const char *name, qLump_c *lump)
{
  int k;
  switch (ch)
  {
    case 'P': k = SECTION_Patches;   break;
    case 'S': k = SECTION_Sprites;   break;
    case 'C': k = SECTION_Colormaps; break;
    case 'T': k = SECTION_ZDoomTex;  break;
    case 'F': k = SECTION_Flats;     break;

    default: 
      Main_FatalError("DM_AddSectionLump: bad section '%c'\n", ch);
      return; /* NOT REACHED */
  }

  lump->SetName(name);

  sections[k]->push_back(lump);
}

static void WriteSections()
{
  for (int k = 0; k < NUM_SECTIONS; k++)
  {
    if (sections[k]->size() == 0)
      continue;

    DM_WriteLump(section_markers[k*2], NULL, 0);

    for (unsigned int i = 0; i < sections[k]->size(); i++)
    {
      qLump_c *lump = sections[k]->at(i);

      DM_WriteLump(lump->GetName(), lump);
    }

    DM_WriteLump(section_markers[k*2+1], NULL, 0);
  }
}


bool DM_StartWAD(const char *filename)
{
  if (! WAD_OpenWrite(filename))
  {
    DLG_ShowError("Unable to create wad file:\n%s", strerror(errno));
    return false;
  }

  errors_seen = 0;

  wad_hexen = false;

  ClearSections();

  qLump_c *info = BSP_CreateInfoLump();
  DM_WriteLump("OBLIGDAT", info);
  delete info;

  return true; //OK
}


bool DM_EndWAD(void)
{
  WriteSections();
  ClearSections();

  WAD_CloseWrite();

  return (errors_seen == 0);
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


//------------------------------------------------------------------------


class doom_game_interface_c : public game_interface_c
{
private:
  const char *filename;

public:
  doom_game_interface_c() : filename(NULL)
  { }

  ~doom_game_interface_c()
  {
    StringFree(filename);
  }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);

private:
  bool BuildNodes();

///  bool CheckDirectory(const char *filename);
};


#if 0  // UNUSED
bool doom_game_interface_c::CheckDirectory(const char *filename)
{
  char *dir_name = StringDup(filename);

  // remove the base filename to get the plain directory
  const char *base = FindBaseName(filename);

  dir_name[base - filename] = 0;

  if (strlen(dir_name) == 0)
    return true;

  // this badly-named function checks the directory exists
  bool result = fl_filename_isdir(dir_name);

  if (! result)
    DLG_ShowError("The specified folder does not exist:\n\n  %s", dir_name);

  StringFree(dir_name);

  return result;
}
#endif


bool doom_game_interface_c::Start()
{
  filename = Select_Output_File("wad");

  if (! filename)
  {
    Main_ProgStatus("Cancelled");
    return false;
  }

  if (create_backups)
    Main_BackupFile(filename, "bak");

  if (! DM_StartWAD(filename))
  {
    Main_ProgStatus("Error (create file)");
    return false;
  }

  if (main_win)
    main_win->build_box->Prog_Init(25, "Lua,CSG");

  return true;
}


bool doom_game_interface_c::BuildNodes()
{
  char *temp_name = ReplaceExtension(filename, "tmp");

  FileDelete(temp_name);

  if (! FileRename(filename, temp_name))
  {
    LogPrintf("WARNING: could not rename file to .TMP!\n");
    StringFree(temp_name);
    return false;
  }
  
  bool result = DM_BuildNodes(temp_name, filename);

  FileDelete(temp_name);
  StringFree(temp_name);

  return result;
}


bool doom_game_interface_c::Finish(bool build_ok)
{
  // TODO: handle write errors
  DM_EndWAD();

  if (build_ok)
  {
    build_ok = BuildNodes();
  }

  if (! build_ok)
  {
    // remove the WAD if an error occurred
    FileDelete(filename);
  }

  return build_ok;
}


void doom_game_interface_c::BeginLevel()
{
  DM_FreeLevelStuff();
}


void doom_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else if (StringCaseCmp(key, "description") == 0)
  {
    // ignored (for now)
    // [another mechanism sets the description via BEX/DDF]
  }
  else if (StringCaseCmp(key, "hexen_format") == 0)
  {
    if (value[0] == '0' || tolower(value[0]) == 'f')
      wad_hexen = false;
    else
      wad_hexen = true;
  }
  else if (StringCaseCmp(key, "solid_exfloor") == 0)
  {
    solid_exfloor = atoi(value);
  }
  else if (StringCaseCmp(key, "liquid_exfloor") == 0)
  {
    liquid_exfloor = atoi(value);
  }
  else
  {
    LogPrintf("WARNING: unknown DOOM property: %s=%s\n", key, value);
  }
}


void doom_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  DM_BeginLevel();

  CSG2_MergeAreas();
  CSG2_MakeMiniMap();

  DM_WriteDoom();

  DM_EndLevel(level_name);

  StringFree(level_name);
  level_name = NULL;
}


game_interface_c * Doom_GameObject()
{
  return new doom_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
