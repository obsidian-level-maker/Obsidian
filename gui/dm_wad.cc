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

#include "main.h"
#include "ui_chooser.h"

#include "g_image.h"
#include "g_lua.h"

#include "csg_main.h"
#include "csg_quake.h"

#include "dm_level.h"
#include "dm_wad.h"
#include "dm_glbsp.h"


//!!!!!!!
#include "q1_main.h"
extern int Q1_end_level(lua_State *L);
extern s32_t Quake1_CreateClipHull(int which, qLump_c *q1_clip);

extern void CSG2_Doom_TestAreas(void);
extern void CSG2_Doom_TestRegions(void);


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

static void WAD_RawSeek(u32_t pos)
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

static void WAD_RawWrite(const void *data, u32_t len)
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

static void WAD_WriteLump(const char *name, const void *data, u32_t len)
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

static void WAD_WriteLump(const char *name, lump_c *lump)
{
  WAD_WriteLump(name, &(*lump)[0], lump->size());
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
  WAD_Printf(L, "-- " OBLIGE_TITLE " (C) 2006-2008 Andrew Apted\n");
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

void add_vertex(int x, int y)
{
  raw_vertex_t vert;

  vert.x = LE_S16(x);
  vert.y = LE_S16(y);

  WAD_Append(vertex_lump, &vert, sizeof(vert));
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

  WAD_Append(sector_lump, &sec, sizeof(sec));
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

  WAD_Append(sidedef_lump, &side, sizeof(side));
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

  Image_Setup();

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



class doom_game_interface_c : public game_interface_c
{
private:
  int sub_type;

  const char *filename;

public:
  doom_game_interface_c(int _st) : sub_type(_st), filename(NULL)
  { }

  ~doom_game_interface_c()
  {
    StringFree(filename);
  }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void LevelProp(const char *key, const char *value);
  void EndLevel();
};


bool doom_game_interface_c::Start()
{
  filename = Select_Output_File();

  if (! filename)  // cancelled
    return false;

  return Doom_Start(sub_type == DMSUB_Hexen);
}

bool doom_game_interface_c::Finish(bool build_ok)
{
  if (! build_ok)
    return false;

  if (! Doom_Finish())
    return false;

  if (! Doom_Nodes(filename))
    return false;

  Doom_Tidy();

  return true;
}

void doom_game_interface_c::BeginLevel()
{
  thing_lump   = new lump_c();
  vertex_lump  = new lump_c();
  sector_lump  = new lump_c();
  linedef_lump = new lump_c();
  sidedef_lump = new lump_c();
}

void doom_game_interface_c::LevelProp(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else
  {
    fprintf(stderr, "WARNING: Doom: unknown level prop: %s=%s\n", key, value);
  }
}

void doom_game_interface_c::EndLevel()
{
  CSG2_WriteDoom();

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

  if (sub_type == DMSUB_Hexen)
    WAD_WriteBehavior();

  // free data
  delete thing_lump;   thing_lump   = NULL;
  delete sector_lump;  sector_lump  = NULL;
  delete vertex_lump;  vertex_lump  = NULL;
  delete sidedef_lump; sidedef_lump = NULL;
  delete linedef_lump; linedef_lump = NULL;

  StringFree(level_name);
  level_name = NULL;
}


game_interface_c * Doom_GameObject(int subtype)
{
  return new doom_game_interface_c(subtype);
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
