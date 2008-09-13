//------------------------------------------------------------------------
//  BSP files - Quake I and II
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

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_pakfile.h"
#include "q_bsp.h"



qLump_c::qLump_c() : buffer(), crlf(false)
{ }

qLump_c::~qLump_c()
{ }


int qLump_c::GetSize() const
{
  return (int)buffer.size();
}


void qLump_c::Append(const void *data, u32_t len)
{
  if (len == 0)
    return;

  u32_t old_size = buffer.size();
  u32_t new_size = old_size + len;

  buffer.resize(new_size);

  memcpy(& buffer[old_size], data, len);
}


void qLump_c::Prepend(const void *data, u32_t len)
{
  if (len == 0)
    return;

  u32_t old_size = buffer.size();
  u32_t new_size = old_size + len;

  buffer.resize(new_size);

  if (old_size > 0)
  {
    memmove(& buffer[len], & buffer[0], old_size);
  }
  memcpy(& buffer[0], data, len);
}


void qLump_c::RawPrintf(const char *str)
{
  if (! crlf)
  {
    Append(str, strlen(str));
    return;
  }

  // convert each newline into CR/LF pair
  while (*str)
  {
    char *next = strchr(str, '\n');

    Append(str, next ? (next - str) : strlen(str));

    if (! next)
      break;

    Append("\r\n", 2);

    str = next+1;
  }
}


void qLump_c::Printf(const char *str, ...)
{
  static char msg_buf[MSG_BUF_LEN];

  va_list args;

  va_start(args, str);
  vsnprintf(msg_buf, MSG_BUF_LEN-1, str, args);
  va_end(args);

  msg_buf[MSG_BUF_LEN-2] = 0;

  RawPrintf(msg_buf);
}


void qLump_c::KeyPair(const char *key, const char *val, ...)
{
  static char v_buffer[MSG_BUF_LEN];

  va_list args;

  va_start(args, val);
  vsnprintf(v_buffer, MSG_BUF_LEN-1, val, args);
  va_end(args);

  v_buffer[MSG_BUF_LEN-2] = 0;

  RawPrintf("\"");
  RawPrintf(key);
  RawPrintf("\" \"");
  RawPrintf(v_buffer);
  RawPrintf("\"\n");
}


void qLump_c::SetCRLF(bool enable)
{
  crlf = enable;
}


//------------------------------------------------------------------------


#define HEADER_LUMP_MAX  32

static int bsp_game;  // 1 for Quake1, 2 for Quake2  [make enum if more!]
static int bsp_numlumps;
static int bsp_version;

static qLump_c * bsp_directory[HEADER_LUMP_MAX];


#if 0  // OLD STUFF (writing to a FILE)
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
#endif


static void BSP_ClearLumps(void)
{
  for (int i = 0; i < bsp_numlumps; i++)
  {
    if (bsp_directory[i])
    {
      delete bsp_directory[i];
      bsp_directory[i] = NULL;
    }
  }
}


static void BSP_WriteLump(qLump_c *lump)
{
  SYS_ASSERT(lump);

  int len = lump->GetSize();

  if (len == 0)
    return;

  PAK_AppendData(& lump->buffer[0], len);

  // pad lumps to a multiple of four bytes
  u32_t padding = AlignLen(len) - len;

  SYS_ASSERT(0 <= padding && padding <= 3);

  if (padding > 0)
  {
    static u8_t zeros[4] = { 0,0,0,0 };

    PAK_AppendData(zeros, padding);
  }
}


#if 0  // OLD CODE
bool BSP_CloseWrite(void)
{

  // WRITE FAKE HEADER
  dheader_t header;
  memset(&header, 0, sizeof(header));

  BSP_RawWrite(&header, sizeof(header));


  // WRITE ALL LUMPS

  header.version = LE_U32(0x1D); 

  for (int L = 0; L < bsp_numlumps; L++)
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
#endif


bool BSP_OpenLevel(const char *entry_in_pak, int game)
{
  // assumes that PAK_OpenWrite() has already been called.

  // FIXME: ASSERT(!already opened)

  PAK_NewLump(entry_in_pak);

  bsp_game = game;

  switch (game)
  {
    case 1:
      bsp_version  = Q1_BSP_VERSION;
      bsp_numlumps = Q1_HEADER_LUMPS;
      break;

    case 2:
      bsp_version  = Q2_BSP_VERSION;
      bsp_numlumps = Q2_HEADER_LUMPS;
      break;

    default:
      Main_FatalError("INTERNAL ERROR: BSP_OpenLevel: unknown game %d\n", game);
      return false; // NOT REACHED
  }

  BSP_ClearLumps();

  return true;
}


static void BSP_WriteHeader()
{
  u32_t offset = 0;

  if (bsp_game == 2)
  {
    PAK_AppendData(Q2_IDENT_MAGIC, 4);
    offset += 4;
  }

  s32_t raw_version = LE_S32(bsp_version);
  PAK_AppendData(&raw_version, 4);
  offset += 4;

  offset += sizeof(lump_t) * bsp_numlumps;

  for (int L = 0; L < bsp_numlumps; L++)
  {
    lump_t raw_info;

    // handle missing lumps : create an empty one
    if (! bsp_directory[L])
      bsp_directory[L] = new qLump_c();

    u32_t length = bsp_directory[L]->buffer.size();

    raw_info.start  = LE_U32(offset);
    raw_info.length = LE_U32(length);

    PAK_AppendData(&raw_info, sizeof(raw_info));

    offset += (u32_t)AlignLen(length);
  }
}


bool BSP_CloseLevel()
{
  // FIXME: ASSERT(opened)

  BSP_WriteHeader();

  for (int L = 0; L < bsp_numlumps; L++)
  {
    BSP_WriteLump(bsp_directory[L]);
  }

  PAK_FinishLump();

  // free all the memory
  BSP_ClearLumps();

  return true;
}


qLump_c *BSP_NewLump(int entry)
{
  SYS_ASSERT(0 <= entry && entry < bsp_numlumps);

  if (bsp_directory[entry] != NULL)
    Main_FatalError("INTERNAL ERROR: BSP_NewLump: already created entry [%d]\n", entry);

  bsp_directory[entry] = new qLump_c;

  return bsp_directory[entry];
}


void BSP_BackupPAK(const char *filename)
{
  if (FileExists(filename))
  {
    LogPrintf("Backing up existing file: %s\n", filename);

    char *backup_name = ReplaceExtension(filename, "old");

    if (! FileCopy(filename, backup_name))
      LogPrintf("WARNING: unable to create backup: %s\n", backup_name);

    StringFree(backup_name);
  }
}


//------------------------------------------------------------------------

static int bsp_vert_lump;
static int bsp_max_verts;

std::vector<dvertex_t> bsp_vertices;

#define NUM_VERTEX_HASH  512
static std::vector<u16_t> * vert_hashtab[NUM_VERTEX_HASH];


void BSP_ClearVertices(int lump, int max_verts)
{
  bsp_vert_lump = lump;
  bsp_max_verts = max_verts;

  bsp_vertices.clear();

  for (int h = 0; h < NUM_VERTEX_HASH; h++)
  {
    delete vert_hashtab[h];
    vert_hashtab[h] = NULL;
  }

  // insert dummy vertex #0
  dvertex_t dummy;
  memset(&dummy, 0, sizeof(dummy));

  bsp_vertices.push_back(dummy);
}


u16_t BSP_AddVertex(double x, double y, double z)
{
  dvertex_t vert;

  vert.x = x;
  vert.y = y;
  vert.z = z;

  // find existing vertex.  For speed we use a hash-table.
  int hash;
  hash = IntHash(       I_ROUND((x+1.4) / 128.0));
  hash = IntHash(hash ^ I_ROUND((y+1.4) / 128.0));

  hash = hash & (NUM_VERTEX_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! vert_hashtab[hash])
    vert_hashtab[hash] = new std::vector<u16_t>;

  std::vector<u16_t> *hashtab = vert_hashtab[hash];

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t vert_idx = (*hashtab)[i];
 
    dvertex_t *test = &bsp_vertices[vert_idx];

    if (fabs(test->x - x) < Q_EPSILON &&
        fabs(test->y - y) < Q_EPSILON &&
        fabs(test->z - z) < Q_EPSILON)
    {
      return vert_idx; // found it
    }
  }

  // not found, so add new one
  u16_t vert_idx = bsp_vertices.size();

  if (vert_idx >= bsp_max_verts)
    Main_FatalError("Quake build failure: exceeded limit of %d VERTEXES\n",
                    bsp_max_verts);

  bsp_vertices.push_back(vert);

  hashtab->push_back(vert_idx);

  return vert_idx;
}


void BSP_WriteVertices(void)
{
  // fix endianness
  for (unsigned int i = 0; i < bsp_vertices.size(); i++)
  {
    dvertex_t& v = bsp_vertices[i];

    v.x = LE_Float32(v.x);
    v.y = LE_Float32(v.y);
    v.z = LE_Float32(v.z);
  }

  qLump_c *lump = BSP_NewLump(bsp_vert_lump);

  lump->Append(&bsp_vertices[0], bsp_vertices.size() * sizeof(dvertex_t));
}


//------------------------------------------------------------------------

static int bsp_edge_lump;
static int bsp_max_edges;

std::vector<dedge_t> bsp_edges;

std::map<u32_t, s32_t> bsp_edge_map;


void BSP_ClearEdges(int lump, int max_edges)
{
  bsp_edges.clear();
  bsp_edge_map.clear();

  // insert dummy edge #0
  dedge_t dummy;
  memset(&dummy, 0, sizeof(dummy));

  bsp_edges.push_back(dummy);
}


s32_t BSP_AddEdge(u16_t start, u16_t end)
{
  bool flipped = false;

  if (start > end)
  {
    flipped = true;
    u16_t tmp = start; start = end; end = tmp;
  }

  dedge_t edge;

  edge.v[0] = start;
  edge.v[1] = end;

  u32_t key = (u32_t)start + (u32_t)(end << 16);


  // find existing edge
  if (bsp_edge_map.find(key) != bsp_edge_map.end())
    return bsp_edge_map[key] * (flipped ? -1 : 1);


  // not found, so add new one
  int edge_idx = bsp_edges.size();

  if (edge_idx >= bsp_max_edges)
    Main_FatalError("Quake build failure: exceeded limit of %d EDGES\n",
                    bsp_max_edges);

  bsp_edges.push_back(edge);

  bsp_edge_map[key] = edge_idx;

  return flipped ? -edge_idx : edge_idx;
}


void BSP_WriteEdges(void)
{
  // fix endianness
  for (unsigned int i = 0; i < bsp_edges.size(); i++)
  {
    dedge_t& e = bsp_edges[i];

    e.v[0] = LE_U16(e.v[0]);
    e.v[1] = LE_U16(e.v[1]);
  }

  qLump_c *lump = BSP_NewLump(bsp_edge_lump);

  lump->Append(&bsp_edges[0], bsp_edges.size() * sizeof(dedge_t));
}


//------------------------------------------------------------------------

static int bsp_light_lump;
static int bsp_max_lightmap;

static qLump_c *bsp_lightmap;


void BSP_ClearLightmap(int lump, int max_lightmap)
{
  bsp_light_lump = lump;
  bsp_max_lightmap = max_lightmap;

  bsp_lightmap = BSP_NewLump(lump);

  // tis the season to be jolly
  const char *info = "Lightmap created by " OBLIGE_TITLE " " OBLIGE_VERSION;

  bsp_lightmap->Append(info, strlen(info));

  // quake II needs all offsets to be divisible by 3
  const byte zeros[4] = { 0,0,0,0 };

  int count = 3 - (bsp_lightmap->GetSize() % 3);

  bsp_lightmap->Append(zeros, count);
}


s32_t BSP_AddLightBlock(int w, int h, u8_t *levels)
{
  s32_t offset = bsp_lightmap->GetSize();

  if (bsp_game == 2)
  {
    // QuakeII has RGB lightmaps (but this is just greyscale)
    for (int i = 0; i < w*h; i++)
    {
      bsp_lightmap->Append(&levels, 1);
      bsp_lightmap->Append(&levels, 1);
      bsp_lightmap->Append(&levels, 1);
    }
  }
  else
  {
    for (int i = 0; i < w*h; i++)
      bsp_lightmap->Append(&levels, 1);
  }

  if ((int)bsp_lightmap->GetSize() >= bsp_max_lightmap)
    Main_FatalError("Quake build failure: exceeded lightmap limit of %d\n",
                    bsp_max_lightmap);

  return offset;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
