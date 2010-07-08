//------------------------------------------------------------------------
//  BSP files - Quake I and II
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

#include <algorithm>

#include "hdr_lua.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_pak.h"

#include "main.h"
#include "g_lua.h"

#include "q_bsp.h"


#define NORMAL_EPSILON  0.0001


qLump_c::qLump_c() : buffer(), crlf(false)
{ }

qLump_c::~qLump_c()
{ }


int qLump_c::GetSize() const
{
  return (int)buffer.size();
}

const u8_t * qLump_c::GetBuffer() const
{
  return & buffer[0];
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


void qLump_c::Append(qLump_c *other)
{
  if (other->buffer.size() > 0)
  {
    Append(& other->buffer[0], other->buffer.size());
  }
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
    const char *next = strchr(str, '\n');

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


void qLump_c::SetName(const char *_name)
{
  name = std::string(_name);
}

const char *qLump_c::GetName() const
{
  return name.c_str();
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

  PAK_AppendData(lump->GetBuffer(), len);

  // pad lumps to a multiple of four bytes
  u32_t padding = ALIGN_LEN(len) - len;

  SYS_ASSERT(0 <= padding && padding <= 3);

  if (padding > 0)
  {
    static u8_t zeros[4] = { 0,0,0,0 };

    PAK_AppendData(zeros, padding);
  }
}


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

    u32_t length = bsp_directory[L]->GetSize();

    raw_info.start  = LE_U32(offset);
    raw_info.length = LE_U32(length);

    PAK_AppendData(&raw_info, sizeof(raw_info));

    offset += (u32_t)ALIGN_LEN(length);
  }
}


bool BSP_CloseLevel()
{
  // FIXME: ASSERT(opened)

  BSP_WriteHeader();

  for (int L = 0; L < bsp_numlumps; L++)
    BSP_WriteLump(bsp_directory[L]);

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


qLump_c * BSP_CreateInfoLump()
{
  qLump_c *L = new qLump_c();

  L->SetCRLF(true);

  L->Printf("\n");
  L->Printf("-- Levels created by OBLIGE %s\n", OBLIGE_VERSION);
  L->Printf("-- " OBLIGE_TITLE " (C) 2006-2010 Andrew Apted\n");
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

  return L;
}


void BSP_AddInfoFile()
{
  qLump_c *info = BSP_CreateInfoLump();

  PAK_NewLump("oblige_dat.txt");
  BSP_WriteLump(info);
  PAK_FinishLump();

  delete info;
}



//------------------------------------------------------------------------

static int bsp_plane_lump;
static int bsp_max_planes;

static std::vector<dplane_t> bsp_planes;

#define NUM_PLANE_HASH  128
static std::vector<u16_t> * plane_hashtab[NUM_PLANE_HASH];

#define PLANE_NOT_FOUND  0xFFFF


static void BSP_ClearPlanes()
{
  bsp_planes.clear();

  for (int h = 0; h < NUM_PLANE_HASH; h++)
  {
    delete plane_hashtab[h];
    plane_hashtab[h] = NULL;
  }
}

void BSP_PreparePlanes(int lump, int max_planes)
{
  bsp_plane_lump = lump;
  bsp_max_planes = max_planes;

  BSP_ClearPlanes();
}


u16_t BSP_AddPlane(double x, double y, double z,
                   double nx, double ny, double nz,
                   bool *flipped)
{
  // NOTE: the 'flipped' parameter should only be provided for Quake1,
  //       and should be omitted for Quake2/3.

  bool did_flip = false;

  double len = sqrt(nx*nx + ny*ny + nz*nz);

  SYS_ASSERT(len > 0);

  nx /= len;
  ny /= len;
  nz /= len;

  double ax = fabs(nx);
  double ay = fabs(ny);
  double az = fabs(nz);

  // flip plane to make major axis positive
  if ( (-nx >= MAX(ay, az)) ||
       (-ny >= MAX(ax, az)) ||
       (-nz >= MAX(ax, ay)) )
  {
    did_flip = true;

    nx = -nx;
    ny = -ny;
    nz = -nz;
  }

  // distance to the origin (0,0,0)
  double dist = (x*nx + y*ny + z*nz);


  // create plane structure
  dplane_t dp;

  dp.normal[0] = nx;
  dp.normal[1] = ny;
  dp.normal[2] = nz;

  dp.dist = dist;

  if (ax > 1.0 - NORMAL_EPSILON)
    dp.type = PLANE_X;
  else if (ay > 1.0 - NORMAL_EPSILON)
    dp.type = PLANE_Y;
  else if (az > 1.0 - NORMAL_EPSILON)
    dp.type = PLANE_Z;
  else if (ax >= MAX(ay, az))
    dp.type = PLANE_ANYX;
  else if (ay >= MAX(ax, az))
    dp.type = PLANE_ANYY;
  else
    dp.type = PLANE_ANYZ;


  // find an existing matching plane.
  // For speed we use a hash-table based on nx/ny/nz/dist
  int hash = I_ROUND(dist / 8.0 + 0.333);
  hash = IntHash(hash ^ I_ROUND((nx+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((ny+1.0) * 8));
  hash = IntHash(hash ^ I_ROUND((nz+1.0) * 8));

  hash = hash & (NUM_PLANE_HASH-1);
  SYS_ASSERT(hash >= 0);

  if (! plane_hashtab[hash])
    plane_hashtab[hash] = new std::vector<u16_t>;
    
  std::vector<u16_t> *hashtab = plane_hashtab[hash];


  u16_t plane_idx = PLANE_NOT_FOUND;

  for (unsigned int i = 0; i < hashtab->size(); i++)
  {
    u16_t index = (*hashtab)[i];

    SYS_ASSERT(index < bsp_planes.size());

    dplane_t *test_p = &bsp_planes[index];

    // Note: we ignore the redundant 'type' field
    if (fabs(test_p->dist - dist)    < 0.001 &&
        fabs(test_p->normal[0] - nx) < NORMAL_EPSILON &&
        fabs(test_p->normal[1] - ny) < NORMAL_EPSILON &&
        fabs(test_p->normal[2] - nz) < NORMAL_EPSILON)
    {
      plane_idx = index; // found it
      break;
    }
  }


  if (plane_idx == PLANE_NOT_FOUND)
  {
    // not found, so add new one
    plane_idx = bsp_planes.size();

    if (plane_idx >= bsp_max_planes)
      Main_FatalError("Quake1 build failure: exceeded limit of %d PLANES\n",
                      bsp_max_planes);

    bsp_planes.push_back(dp);

    // Quake2/3 have pairs of planes (opposite directions)
    if (! flipped)
    {
      dp.normal[0] = -nx;
      dp.normal[1] = -ny;
      dp.normal[2] = -nz;

      dp.dist = -dist;

      bsp_planes.push_back(dp);
    }

//  fprintf(stderr, "ADDED PLANE (idx %d), count %d\n",
//                   (int)plane_idx, (int)bsp_planes.size());

    hashtab->push_back(plane_idx);
  }


  if (flipped)
  {
    // Quake1
    *flipped = did_flip;
    return plane_idx;
  }
  else
  {
    // Quake2/3
    return plane_idx + (did_flip ? 1 : 0);
  }
}


void BSP_WritePlanes(void)
{
  // fix endianness
  for (unsigned int i = 0; i < bsp_planes.size(); i++)
  {
    dplane_t& dp = bsp_planes[i];

    dp.normal[0] = LE_Float32(dp.normal[0]);
    dp.normal[1] = LE_Float32(dp.normal[1]);
    dp.normal[2] = LE_Float32(dp.normal[2]);

    dp.dist = LE_Float32(dp.dist);
  }

  qLump_c *lump = BSP_NewLump(bsp_plane_lump);

  lump->Append(&bsp_planes[0], bsp_planes.size() * sizeof(dplane_t));

  BSP_ClearPlanes();
}


//------------------------------------------------------------------------

static int bsp_vert_lump;
static int bsp_max_verts;

static std::vector<dvertex_t> bsp_vertices;

#define NUM_VERTEX_HASH  512
static std::vector<u16_t> * vert_hashtab[NUM_VERTEX_HASH];


static void BSP_ClearVertices()
{
  bsp_vertices.clear();

  for (int h = 0; h < NUM_VERTEX_HASH; h++)
  {
    delete vert_hashtab[h];
    vert_hashtab[h] = NULL;
  }
}

void BSP_PrepareVertices(int lump, int max_verts)
{
  bsp_vert_lump = lump;
  bsp_max_verts = max_verts;

  BSP_ClearVertices();

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

  // find existing vertex
  // for speed we use a hash-table
  int hash;
  hash = IntHash(       (I_ROUND(x+1.4) >> 7));
  hash = IntHash(hash ^ (I_ROUND(y+1.4) >> 7));

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
      return vert_idx; // found it!
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

  BSP_ClearVertices();
}


//------------------------------------------------------------------------

static int bsp_edge_lump;
static int bsp_max_edges;

static std::vector<dedge_t> bsp_edges;

static std::map<u32_t, s32_t> bsp_edge_map;


static void BSP_ClearEdges()
{
  bsp_edges.clear();
  bsp_edge_map.clear();
}

void BSP_PrepareEdges(int lump, int max_edges)
{
  bsp_edge_lump = lump;
  bsp_max_edges = max_edges;

  BSP_ClearEdges();

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

  BSP_ClearEdges();
}


//------------------------------------------------------------------------

struct Compare_Intersect_pred
{
  inline bool operator() (const intersect_t& A, const intersect_t& B) const
  {
    if (A.q_dist != B.q_dist)
      return A.q_dist < B.q_dist;

    return A.dir < B.dir;
  }
};


int BSP_NiceMidwayPoint(float low, float extent)
{
  int pow2 = 1;

  while (pow2 < extent/7)
  {
    pow2 = pow2 << 1;
  }

  int mid = I_ROUND((low + extent/2.0f) / pow2) * pow2;

  return mid;
}


void BSP_AddIntersection(std::vector<intersect_t> & cut_list,
                         double along, int dir)
{
  intersect_t new_cut;

  new_cut.along = along;
  new_cut.q_dist = I_ROUND(along * 21.6f);
  new_cut.dir = dir;
  new_cut.next_along = -1e30;

  cut_list.push_back(new_cut);
}


void BSP_MergeIntersections(std::vector<intersect_t> & cut_list)
{
  if (cut_list.empty())
    return;

  // move input vector contents into a temporary vector, which we
  // sort and iterate over.  Valid intersections then get pushed
  // back into the input vector.

  std::vector<intersect_t> temp_list;

  temp_list.swap(cut_list);

  std::sort(temp_list.begin(), temp_list.end(),
            Compare_Intersect_pred());

  std::vector<intersect_t>::iterator A, B;

  A = temp_list.begin();

  while (A != temp_list.end())
  {
    if (A->dir != +1)
    {
      A++; continue;
    }

    B = A; B++;

    if (B == temp_list.end())
      break;

    // this handles multiple +1 entries and also ensures
    // that the +2 "remove" entry kills a +1 entry.
    if (A->q_dist == B->q_dist)
    {
      A++; continue;
    }

    if (B->dir != -1)
    {
      DebugPrintf("WARNING: bad pair in intersection list\n");

      A = B; continue;
    }

    // found a viable intersection!
    A->next_along = B->along;

    cut_list.push_back(*A);

    B++; A = B; continue;
  }
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
