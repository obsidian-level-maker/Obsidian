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

#include "csg_poly.h"
#include "csg_doom.h"
#include "csg_quake.h"

#include "g_image.h"

#include "q1_main.h"
#include "q1_structs.h"

#include "main.h"



static FILE *bsp_fp;

static qLump_c * bsp_directory[HEADER_LUMPS + 1];
// NB: the extra lump (+1) stores the Oblige information


#define LUMP_OBLIGE_INFO  HEADER_LUMPS


static int write_errors_seen;
static int seek_errors_seen;


//------------------------------------------------------------------------
//  BSP-FILE OUTPUT
//------------------------------------------------------------------------

static u32_t AlignLen(u32_t len)
{
  return ((len + 3) & ~3);
}

static void BSP_RawSeek(u32_t pos)
{
  fflush(bsp_fp);

  if (fseek(bsp_fp, pos, SEEK_SET) < 0)
  {
    if (seek_errors_seen < 10)
    {
      LogPrintf("Failure seeking in bsp file! (offset %u)\n", pos);

      seek_errors_seen += 1;
    }
  }
}

static void BSP_RawWrite(const void *data, u32_t len)
{
  SYS_ASSERT(bsp_fp);

  if (1 != fwrite(data, len, 1, bsp_fp))
  {
    if (write_errors_seen < 10)
    {
      LogPrintf("Failure writing to bsp file! (%u bytes)\n", len);

      write_errors_seen += 1;
    }
  }
}

static void BSP_WriteLump(int entry, lump_t *info)
{
  qLump_c *lump = bsp_directory[entry];

  if (! lump)
  {
    info->start  = 0;
    info->length = 0;

    return;
  }


  int len = (int)lump->size();

  info->start  = LE_S32((u32_t)ftell(bsp_fp));
  info->length = LE_S32(len);


  if (len > 0)
  {
    BSP_RawWrite(& (*lump)[0], len);

    // pad lumps to a multiple of four bytes
    u32_t padding = AlignLen(len) - len;

    SYS_ASSERT(0 <= padding && padding <= 3);

    if (padding > 0)
    {
      static u8_t zeros[4] = { 0,0,0,0 };

      BSP_RawWrite(zeros, padding);
    }
  }
}


qLump_c *Q1_NewLump(int entry)
{
  SYS_ASSERT(0 <= entry && entry < HEADER_LUMPS+1);

  if (bsp_directory[entry] != NULL)
    Main_FatalError("INTERNAL ERROR: Q1_NewLump: already created entry [%d]\n", entry);

  bsp_directory[entry] = new qLump_c;

  return bsp_directory[entry];
}


void Q1_Append(qLump_c *lump, const void *data, u32_t len)
{
  if (len > 0)
  {
    u32_t old_size = lump->size();
    u32_t new_size = old_size + len;

    lump->resize(new_size);

    memcpy(& (*lump)[old_size], data, len);
  }
}


void Q1_Printf(qLump_c *lump, const char *str, ...)
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

    Q1_Append(lump, pos, next ? (next - pos) : strlen(pos));

    if (! next)
      break;

    Q1_Append(lump, "\r\n", 2);

    pos = next+1;
  }
}


void BSP_CreateInfoLump()
{
  // fake 16th lump in file
  qLump_c *L = Q1_NewLump(LUMP_OBLIGE_INFO);

  Q1_Printf(L, "\n\n\n\n");

  Q1_Printf(L, "-- Map created by OBLIGE %s\n", OBLIGE_VERSION);
  Q1_Printf(L, "-- " OBLIGE_TITLE " (C) 2006-2008 Andrew Apted\n");
  Q1_Printf(L, "-- http://oblige.sourceforge.net/\n");
  Q1_Printf(L, "\n");

 
  Q1_Printf(L, "-- Game Settings --\n");
  Q1_Printf(L, "%s\n", main_win->game_box->GetAllValues());

  Q1_Printf(L, "-- Level Architecture --\n");
  Q1_Printf(L, "%s\n", main_win->level_box->GetAllValues());

  Q1_Printf(L, "-- Playing Style --\n");
  Q1_Printf(L, "%s\n", main_win->play_box->GetAllValues());

//Q1_Printf(L, "-- Custom Mods --\n");
//Q1_Printf(L, "%s\n", main_win->mod_box->GetAllValues());

//Q1_Printf(L, "-- Custom Options --\n");
//Q1_Printf(L, "%s\n", main_win->option_box->GetAllValues());

  Q1_Printf(L, "\n\n\n\n\n\n");

  // terminate lump with ^Z and a NUL character
  static const byte terminator[2] = { 26, 0 };

  Q1_Append(L, terminator, 2);
}


//------------------------------------------------------------------------

std::vector<dplane_t> q1_planes;

#define NUM_PLANE_HASH  128
static std::vector<u16_t> * plane_hashtab[NUM_PLANE_HASH];


static void ClearPlanes(void)
{
  q1_planes.clear();

  for (int h = 0; h < NUM_PLANE_HASH; h++)
  {
    delete plane_hashtab[h];
    plane_hashtab[h] = NULL;
  }
}

u16_t Q1_AddPlane(double x, double y, double z,
                  double dx, double dy, double dz,
                  int *flipped)
{
  *flipped = false;

  double len = sqrt(dx*dx + dy*dy + dz*dz);

  SYS_ASSERT(len > 0);

  dx /= len;
  dy /= len;
  dz /= len;

  // distance to the origin (0,0,0)
  double dist = - (x*dx + y*dy + z*dz);

  double ax = fabs(dx);
  double ay = fabs(dy);
  double az = fabs(dz);

  // flip plane to make major axis positive
  if ( (-dx >= MAX(ay, az)) ||
       (-dy >= MAX(ax, az)) ||
       (-dz >= MAX(ax, ay)) )
  {
    *flipped = true;

    dx = -dx;  dy = -dy;  dz = -dz;
    dist = -dist;
  }

  SYS_ASSERT(! (dx < -1.0 + EPSILON));
  SYS_ASSERT(! (dy < -1.0 + EPSILON));
  SYS_ASSERT(! (dz < -1.0 + EPSILON));


  // create plane structure
  dplane_t dp;

  dp.normal[0] = dx;
  dp.normal[1] = dy;
  dp.normal[2] = dz;

  dp.dist = dist;

  if (dx > 1.0 - EPSILON)
    dp.type = PLANE_X;
  else if (dy > 1.0 - EPSILON)
    dp.type = PLANE_Y;
  else if (dz > 1.0 - EPSILON)
    dp.type = PLANE_Z;
  else if (ax >= MAX(ay, az))
    dp.type = PLANE_ANYX;
  else if (ay >= MAX(ax, az))
    dp.type = PLANE_ANYY;
  else
    dp.type = PLANE_ANYZ;


  // find an existing matching plane.
  // For speed we use a hash-table based on dx/dy/dz/dist
  int hash = I_ROUND(dist / 8.0);
  hash = IntHash(hash ^ I_ROUND((dx+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((dy+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((dz+1.0) * 8));

  hash = hash & (NUM_PLANE_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! plane_hashtab[hash])
    plane_hashtab[hash] = new std::vector<u16_t>;
    
  std::vector<u16_t> *hashtab = plane_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t plane_idx = (*hashtab)[i];

    SYS_ASSERT(plane_idx < q1_planes.size());

    dplane_t *test_p = &q1_planes[plane_idx];

    // Note: ignore the 'type' field because it was generated
    //       from (completely depends on) the plane normal.
    if (fabs(test_p->dist - dist) > Q_EPSILON ||
        fabs(test_p->normal[0] - dp.normal[0]) > Q_EPSILON ||
        fabs(test_p->normal[1] - dp.normal[1]) > Q_EPSILON ||
        fabs(test_p->normal[2] - dp.normal[2]) > Q_EPSILON)
    {
      continue;
    }

    return plane_idx; // found it
  }


  // not found, so add new one
  u16_t plane_idx = q1_planes.size();

  if (plane_idx >= MAX_MAP_PLANES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d PLANES\n",
                    MAX_MAP_PLANES);

  q1_planes.push_back(dp);

  hashtab->push_back(plane_idx);

  return plane_idx;
}


//------------------------------------------------------------------------

static void ClearLumps(void)
{
  for (int i = 0; i < HEADER_LUMPS+1; i++)
  {
    if (bsp_directory[i])
    {
      delete bsp_directory[i];

      bsp_directory[i] = NULL;
    }
  }
}

int Q1_begin_level(lua_State *L)
{
  CSG2_BeginLevel();

  return 0;
}

int Q1_end_level(lua_State *L)
{
//  CSG2_TestQuake();

//!!!!! FIXME  SYS_ASSERT(level_name);

  CSG2_MergeAreas();

  Quake1_BuildBSP();

  CSG2_EndLevel();

  return 0;
}


//------------------------------------------------------------------------

void Quake1_Init(void)
{

}

bool Quake1_Start(const char *target_file)
{
  write_errors_seen = 0;
  seek_errors_seen  = 0;

  ClearLumps();
  ClearPlanes();

  bsp_fp = fopen(target_file, "wb");

  if (! bsp_fp)
  {
    DLG_ShowError("Unable to create bsp file:\n%s", strerror(errno));
    return false;
  }

  return true; //OK
}


bool Quake1_Finish(void)
{
  // yada yada

  BSP_CreateInfoLump();


  // WRITE FAKE HEADER
  dheader_t header;
  memset(&header, 0, sizeof(header));

  BSP_RawWrite(&header, sizeof(header));


  // WRITE ALL LUMPS

  header.version = LE_U32(0x1D); 

  for (int L = 0; L < HEADER_LUMPS+1; L++)
  {
    BSP_WriteLump(L, &header.lumps[L]);
  }


  // FSEEK, WRITE REAL HEADER

  BSP_RawSeek(0);
  BSP_RawWrite(&header, sizeof(header));

  fclose(bsp_fp);
  bsp_fp = NULL;

  return (write_errors_seen == 0) && (seek_errors_seen == 0);
}


static void Quake1_Backup(const char *filename)
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

bool Quake1_Nodes(const char *target_file)
{
  DebugPrintf("TARGET FILENAME: [%s]\n", target_file);

  Quake1_Backup(target_file);

  // ... TODO

  return true;
}


void Quake1_Tidy(void)
{
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
