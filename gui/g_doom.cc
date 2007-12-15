//------------------------------------------------------------------------
//  LEVEL building - DOOM format
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

#include "csg_poly.h"
#include "csg_doom.h"
#include "csg_quake.h"

#include "g_doom.h"
#include "g_glbsp.h"
#include "g_image.h"
#include "g_lua.h"

#include "main.h"


//!!!! TEMP
extern void CSG2_DumpSegmentsToWAD(void);


#define TEMP_FILENAME    "TEMP.wad"

typedef std::vector<u8_t> lump_c;

typedef std::vector<raw_dir_entry_t> directory_c;


static FILE *wad_fp;

static directory_c wad_dir;
static bool wad_hexen;

static char *level_name;

static lump_c *thing_lump;
static lump_c *vertex_lump;
static lump_c *sector_lump;
static lump_c *sidedef_lump;
static lump_c *linedef_lump;

static int write_errors_seen;
static int seek_errors_seen;


//------------------------------------------------------------------------
//  WAD OUTPUT
//------------------------------------------------------------------------

static u32_t AlignLen(u32_t len)
{
  return ((len + 3) & ~3);
}

void WAD_RawSeek(u32_t pos)
{
  fflush(wad_fp);

  if (fseek(wad_fp, pos, SEEK_SET) < 0)
  {
    if (seek_errors_seen < 10)
    {
      LogPrintf("Failure seeking in wad file! (offset %u)\n", pos);

      seek_errors_seen += 1;
    }
  }
}

void WAD_RawWrite(const void *data, u32_t len)
{
  SYS_ASSERT(wad_fp);

  if (1 != fwrite(data, len, 1, wad_fp))
  {
    if (write_errors_seen < 10)
    {
      LogPrintf("Failure writing to wad file! (%u bytes)\n", len);

      write_errors_seen += 1;
    }
  }
}

void WAD_WriteLump(const char *name, const void *data, u32_t len)
{
  SYS_ASSERT(strlen(name) <= 8);

  // create entry for directory (written out later)
  raw_dir_entry_t entry;

  entry.start  = LE_U32((u32_t)ftell(wad_fp));
  entry.length = LE_U32(len);

  strncpy(entry.name, name, 8);

  wad_dir.push_back(entry);

  if (len > 0)
  {
    WAD_RawWrite(data, len);

    // pad lumps to a multiple of four bytes
    u32_t padding = AlignLen(len) - len;

    SYS_ASSERT(0 <= padding && padding <= 3);

    if (padding > 0)
    {
      static u8_t zeros[4] = { 0,0,0,0 };

      WAD_RawWrite(zeros, padding);
    }
  }
}

void WAD_WriteLump(const char *name, lump_c *lump)
{
  WAD_WriteLump(name, &(*lump)[0], lump->size());
}

void WAD_WriteBehavior()
{
  raw_behavior_header_t behavior;

  strncpy(behavior.marker, "ACS", 4);

  behavior.offset   = LE_U32(8);
  behavior.func_num = 0;
  behavior.str_num  = 0;

  WAD_WriteLump("BEHAVIOR", &behavior, sizeof(behavior));
}

void WAD_WritePatches()
{
  WAD_WriteLump("PP_START", NULL, 0);

  static const char *patch_names[3][2] =
  {
    { "WALL52_1", "WALL53_1" },  // Doom    : CEMENT1,  CEMENT2
    { "WALL00",   "WALL42"   },  // Heretic : GRSKULL2, CHAINSD
    { "W_320",    "W_321"    }   // Hexen   : BRASS3,   BRASS4
  };

  const char *game_str = main_win->game_box->get_Game();
  
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

void WAD_Append(lump_c *lump, const void *data, u32_t len)
{
  if (len > 0)
  {
    u32_t old_size = lump->size();
    u32_t new_size = old_size + len;

    lump->resize(new_size);

    memcpy(& (*lump)[old_size], data, len);
  }
}

void WAD_Printf(lump_c *lump, const char *str, ...)
{
  static char buffer[MSG_BUF_LEN];

  va_list args;

  va_start(args, str);
  vsnprintf(buffer, MSG_BUF_LEN-1, str, args);
  va_end(args);

  buffer[MSG_BUF_LEN-2] = 0;

  // convert each newline into CR/LF pair

  char *pos = buffer;
  char *next;

  while (*pos)
  {
    next = strchr(pos, '\n');

    WAD_Append(lump, pos, next ? (next - pos) : strlen(pos));

    if (! next)
      break;

    WAD_Append(lump, "\r\n", 2);

    pos = next+1;
  }
}

void WAD_CreateInfoLump()
{
  lump_c *L = new lump_c();

  WAD_Printf(L, "\n");
  WAD_Printf(L, "-- Levels created by OBLIGE %s\n", OBLIGE_VERSION);
  WAD_Printf(L, "-- " OBLIGE_TITLE " (C) 2006,2007 Andrew Apted\n");
  WAD_Printf(L, "-- http://oblige.sourceforge.net/\n");
  WAD_Printf(L, "\n");

 
  WAD_Printf(L, "-- Game Settings --\n");
  WAD_Printf(L, "%s\n", main_win->game_box->GetAllValues());

  WAD_Printf(L, "-- Level Architecture --\n");
  WAD_Printf(L, "%s\n", main_win->level_box->GetAllValues());

  WAD_Printf(L, "-- Playing Style --\n");
  WAD_Printf(L, "%s\n", main_win->play_box->GetAllValues());

//WAD_Printf(L, "-- Custom Mods --\n");
//WAD_Printf(L, "%s\n", main_win->mod_box->GetAllValues());

//WAD_Printf(L, "-- Custom Options --\n");
//WAD_Printf(L, "%s\n", main_win->option_box->GetAllValues());

  WAD_Printf(L, "\n\n\n\n\n\n");

  // terminate lump with ^Z and a NUL character
  static const byte terminator[2] = { 26, 0 };

  WAD_Append(L, terminator, 2);

  WAD_WriteLump("OBLIGDAT", L);

  delete L;
}

int Hexen_GrabArgs(lua_State *L, u8_t *args, int stack_pos)
{
  memset(args, 0, 5);

  int what = lua_type(L, stack_pos);

  if (what == LUA_TNONE || what == LUA_TNIL)
    return 0;

  if (what != LUA_TTABLE)
    return luaL_argerror(L, stack_pos, "expected a table");

  for (int i = 0; i < 5; i++)
  {
    lua_pushinteger(L, i+1);
    lua_gettable(L, stack_pos);

    if (lua_isnumber(L, -1))
    {
      args[i] = lua_tointeger(L, -1);
    }

    lua_pop(L, 1);
  }

  return 0;
}


//------------------------------------------------------------------------

namespace wad
{

// LUA: begin_level(name)
//
int begin_level(lua_State *L)
{
  const char *name = luaL_checkstring(L,1);

  level_name = strdup(name);

  thing_lump   = new lump_c();
  vertex_lump  = new lump_c();
  sector_lump  = new lump_c();
  linedef_lump = new lump_c();
  sidedef_lump = new lump_c();

  CSG2_BeginLevel();

  return 0;
}

// LUA: end_level()
//
int end_level(lua_State *L)
{
//  CSG2_TestQuake();
//  CSG2_TestDoom();

CSG2_MergeAreas();
CSG2_DumpSegmentsToWAD();

  CSG2_EndLevel();


  SYS_ASSERT(level_name);

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

  delete level_name; level_name = NULL;

  return 0;
}


// LUA: add_thing(x, y, h, type, angle, flags, tid, special, args)
//
int add_thing(lua_State *L)
{
  if (! wad_hexen)
  {
    raw_thing_t thing;

    thing.x = LE_S16(luaL_checkint(L,1));
    thing.y = LE_S16(luaL_checkint(L,2));

    thing.type    = LE_U16(luaL_checkint(L,4));
    thing.angle   = LE_S16(luaL_checkint(L,5));
    thing.options = LE_U16(luaL_checkint(L,6));

    WAD_Append(thing_lump, &thing, sizeof(thing));
  }
  else  // Hexen format
  {
    raw_hexen_thing_t thing;

    // clear unused fields (tid, specials)
    memset(&thing, 0, sizeof(thing));

    thing.x = LE_S16(luaL_checkint(L,1));
    thing.y = LE_S16(luaL_checkint(L,2));

    thing.height  = LE_S16(luaL_checkint(L,3));
    thing.type    = LE_U16(luaL_checkint(L,4));
    thing.angle   = LE_S16(luaL_checkint(L,5));
    thing.options = LE_U16(luaL_checkint(L,6));

    thing.tid     = LE_S16(luaL_checkint(L,7));
    thing.special = luaL_checkint(L,8);  // 8 bits

    Hexen_GrabArgs(L, thing.args, 9);

    WAD_Append(thing_lump, &thing, sizeof(thing));
  }

  return 0;
}

// LUA: add_vertex(x, y)
//
int add_vertex(lua_State *L)
{
  raw_vertex_t vert;

  vert.x = LE_S16(luaL_checkint(L,1));
  vert.y = LE_S16(luaL_checkint(L,2));

  WAD_Append(vertex_lump, &vert, sizeof(vert));

  return 0;
}

// C++ version
void add_vertex(int x, int y)
{
  raw_vertex_t vert;

  vert.x = LE_S16(x);
  vert.y = LE_S16(y);

  WAD_Append(vertex_lump, &vert, sizeof(vert));
}


// LUA: add_sector(f_h, c_h, f_tex, c_tex, light, type, tag)
//   
int add_sector(lua_State *L)
{
  raw_sector_t sec;

  sec.floor_h = LE_S16(luaL_checkint(L,1));
  sec.ceil_h  = LE_S16(luaL_checkint(L,2));

  strncpy(sec.floor_tex, luaL_checkstring(L,3), 8);
  strncpy(sec.ceil_tex,  luaL_checkstring(L,4), 8);

  sec.light   = LE_U16(luaL_checkint(L,5));
  sec.special = LE_U16(luaL_checkint(L,6));
  sec.tag     = LE_S16(luaL_checkint(L,7));

  WAD_Append(sector_lump, &sec, sizeof(sec));

  return 0;
}

// C++ version
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

  WAD_Append(sector_lump, &sec, sizeof(sec));
}


// LUA: add_sidedef(sec, lower, mid, upper, x, y)
//   
int add_sidedef(lua_State *L)
{
  raw_sidedef_t side;

  side.sector = LE_S16(luaL_checkint(L,1));

  strncpy(side.lower_tex, luaL_checkstring(L,2), 8);
  strncpy(side.mid_tex,   luaL_checkstring(L,3), 8);
  strncpy(side.upper_tex, luaL_checkstring(L,4), 8);

  side.x_offset = LE_S16(luaL_checkint(L,5));
  side.y_offset = LE_S16(luaL_checkint(L,6));

  WAD_Append(sidedef_lump, &side, sizeof(side));

  return 0;
}

// C++ version
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

  WAD_Append(sidedef_lump, &side, sizeof(side));
}


// LUA: add_linedef(vert1, vert2, side1, side2, type, flags, tag, args)
//
int add_linedef(lua_State *L)
{
  if (! wad_hexen)
  {
    raw_linedef_t line;

    line.start = LE_U16(luaL_checkint(L,1));
    line.end   = LE_U16(luaL_checkint(L,2));

    int side1 = luaL_checkint(L,3);
    int side2 = luaL_checkint(L,4);
    
    line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
    line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

    line.type  = LE_U16(luaL_checkint(L,5));
    line.flags = LE_U16(luaL_checkint(L,6));
    line.tag   = LE_S16(luaL_checkint(L,7));

    WAD_Append(linedef_lump, &line, sizeof(line));
  }
  else  // Hexen format
  {
    raw_hexen_linedef_t line;

    // clear unused fields (specials)
    memset(&line, 0, sizeof(line));

    line.start = LE_U16(luaL_checkint(L,1));
    line.end   = LE_U16(luaL_checkint(L,2));

    int side1 = luaL_checkint(L,3);
    int side2 = luaL_checkint(L,4);
      
    line.sidedef1 = side1 < 0 ? 0xFFFF : LE_U16(side1);
    line.sidedef2 = side2 < 0 ? 0xFFFF : LE_U16(side2);

    line.special = luaL_checkint(L,5); // 8 bits
    line.flags = LE_U16(luaL_checkint(L,6));

    // tag value is UNUSED

    Hexen_GrabArgs(L, line.args, 8);

    WAD_Append(linedef_lump, &line, sizeof(line));
  }

  return 0;
}

// C++ version
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

    WAD_Append(linedef_lump, &line, sizeof(line));
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

    WAD_Append(linedef_lump, &line, sizeof(line));
  }
}


int num_vertexes(void)
{
  return vertex_lump->size() / sizeof(raw_vertex_t);
}
int num_sectors(void)
{
  return sector_lump->size() / sizeof(raw_sector_t);
}
int num_sidedefs(void)
{
  return sidedef_lump->size() / sizeof(raw_sidedef_t);
}

} // namespace wad


//------------------------------------------------------------------------

static const luaL_Reg wad_funcs[] =
{
  { "begin_level", wad::begin_level },
  { "end_level",   wad::end_level   },

  { "add_thing",   wad::add_thing   },
  { "add_vertex",  wad::add_vertex  },
  { "add_sector",  wad::add_sector  },
  { "add_sidedef", wad::add_sidedef },
  { "add_linedef", wad::add_linedef },

  { NULL, NULL } // the end
};


void Doom_Init(void)
{
  Script_RegisterLib("wad", wad_funcs);

  Image_Setup();
}

bool Doom_Start(bool is_hexen)
{
  wad_fp = fopen(TEMP_FILENAME, "wb");

  if (! wad_fp)
  {
    DLG_ShowError("Unable to create wad file:\n%s", strerror(errno));
    return false;
  }

  write_errors_seen = 0;
  seek_errors_seen  = 0;

  wad_dir.clear();
  wad_hexen = is_hexen;

  // dummy header
  raw_wad_header_t header;

  strncpy(header.type, "XWAD", 4);

  header.dir_start   = 0;
  header.num_entries = 0;

  WAD_RawWrite(&header, sizeof(header));

  WAD_CreateInfoLump();

  return true; //OK
}

bool Doom_Finish(void)
{
  WAD_WritePatches();
 
  // compute *real* header 
  raw_wad_header_t header;

  strncpy(header.type, "PWAD", 4);

  header.dir_start   = LE_U32((u32_t)ftell(wad_fp));
  header.num_entries = LE_U32(wad_dir.size());


  // WRITE DIRECTORY
  directory_c::iterator D;

  for (D = wad_dir.begin(); D != wad_dir.end(); D++)
  {
    WAD_RawWrite(& *D, sizeof(raw_dir_entry_t));
  }

  // FSEEK, WRITE HEADER

  WAD_RawSeek(0);
  WAD_RawWrite(&header, sizeof(header));

  fclose(wad_fp);
  wad_fp = NULL;

  return (write_errors_seen == 0) && (seek_errors_seen == 0);
}


static void Doom_Backup(const char *filename)
{
  if (FileExists(filename))
  {
    LogPrintf("Backing up existing file: %s\n", filename);

    char *backup_name = ReplaceExtension(filename, "bak");

    if (! FileCopy(filename, backup_name))
      LogPrintf("WARNING: unable to create backup: %s\n", backup_name);

    StringFree(backup_name);
  }
}

bool Doom_Nodes(const char *target_file)
{
  DebugPrintf("TARGET FILENAME: [%s]\n", target_file);

  Doom_Backup(target_file);

  return GB_BuildNodes(TEMP_FILENAME, target_file);
}

void Doom_Tidy(void)
{
  FileDelete(TEMP_FILENAME);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
