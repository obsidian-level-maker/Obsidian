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

#include "csg_main.h"
#include "csg_quake.h"

#include "g_image.h"

#include "q1_main.h"
#include "q1_pakfile.h"
#include "q1_structs.h"

#include "main.h"



static FILE *bsp_fp;

static qLump_c * bsp_directory[HEADER_LUMPS + 1];
// NB: the extra lump (+1) stores the Oblige information


#define LUMP_OBLIGE_INFO  HEADER_LUMPS


static int write_errors_seen;
static int seek_errors_seen;


extern void BSP_CreateModel(void);


//------------------------------------------------------------------------
//  BSP-FILE OUTPUT
//------------------------------------------------------------------------

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

void Q1_Prepend(qLump_c *lump, const void *data, u32_t len)
{
  if (len > 0)
  {
    u32_t old_size = lump->size();
    u32_t new_size = old_size + len;

    lump->resize(new_size);

    if (old_size > 0)
    {
      memmove(& (*lump)[len], & (*lump)[0], old_size);
    }
    memcpy(& (*lump)[0], data, len);
  }
}


void Q1_Printf(qLump_c *lump, int crlf, const char *str, ...)
{
  static char buffer[MSG_BUF_LEN];

  va_list args;

  va_start(args, str);
  vsnprintf(buffer, MSG_BUF_LEN-1, str, args);
  va_end(args);

  buffer[MSG_BUF_LEN-2] = 0;

  if (! crlf)
  {
    Q1_Append(lump, buffer, strlen(buffer));
    return;
  }

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


void ENT_KeyPair(qLump_c *lump, const char *key, const char *val)
{
  Q1_Printf(lump,0, "\"%s\" \"%s\"\n", key, val);
}


void BSP_CreateEntities(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_ENTITIES);

  /* add the worldspawn entity */

  Q1_Printf(lump,0, "{\n");

  ENT_KeyPair(lump,  "_generated_by", OBLIGE_TITLE " " OBLIGE_VERSION " (c) Andrew Apted");
  ENT_KeyPair(lump,  "_oblige_seed",  main_win->game_box->get_Seed());
  // TODO: more oblige config stuff...

  ENT_KeyPair(lump,  "message",   "level created by Oblige");
  ENT_KeyPair(lump,  "worldtype", "0");
//ENT_KeyPair(lump,  "origin",    "0 0 0");
  ENT_KeyPair(lump,  "classname", "worldspawn");

  Q1_Printf(lump,0, "}\n");

  // add everything else

  for (unsigned int j = 0; j < all_entities.size(); j++)
  {
    entity_info_c *E = all_entities[j];

    char orig_buf[80];
    sprintf(orig_buf, "%1.1f %1.1f %1.1f", E->x, E->y, E->z);

    Q1_Printf(lump,0, "{\n");

    // TODO: other models (doors etc) --> "model" "*45"

    // FIXME: other entity properties

    ENT_KeyPair(lump,  "origin",    orig_buf);
    ENT_KeyPair(lump,  "classname", E->name.c_str());

    Q1_Printf(lump,0, "}\n");
  }

  // add a trailing nul
  u8_t zero = 0;

  Q1_Append(lump, &zero, 1);
}


void BSP_CreateInfoLump()
{
  // fake 16th lump in file
  qLump_c *lump = Q1_NewLump(LUMP_OBLIGE_INFO);

  Q1_Printf(lump,1, "\n\n\n\n");

  Q1_Printf(lump,1, "-- Map created by OBLIGE %s\n", OBLIGE_VERSION);
  Q1_Printf(lump,1, "-- " OBLIGE_TITLE " (C) 2006-2008 Andrew Apted\n");
  Q1_Printf(lump,1, "-- http://oblige.sourceforge.net/\n");
  Q1_Printf(lump,1, "\n");

 
  Q1_Printf(lump,1, "-- Game Settings --\n");
  Q1_Printf(lump,1, "%s\n", main_win->game_box->GetAllValues());

  Q1_Printf(lump,1, "-- Level Architecture --\n");
  Q1_Printf(lump,1, "%s\n", main_win->level_box->GetAllValues());

  Q1_Printf(lump,1, "-- Playing Style --\n");
  Q1_Printf(lump,1, "%s\n", main_win->play_box->GetAllValues());

//Q1_Printf(lump,1, "-- Custom Mods --\n");
//Q1_Printf(lump,1, "%s\n", main_win->mod_box->GetAllValues());

//Q1_Printf(lump,1, "-- Custom Options --\n");
//Q1_Printf(lump,1, "%s\n", main_win->option_box->GetAllValues());

  Q1_Printf(lump,1, "\n\n\n\n\n\n");

  // terminate lump with ^Z and a NUL character
  static const byte terminator[2] = { 26, 0 };

  Q1_Append(lump, terminator, 2);
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
                  bool *flipped)
{
  *flipped = false;

  double len = sqrt(dx*dx + dy*dy + dz*dz);

  SYS_ASSERT(len > 0);

  dx /= len;
  dy /= len;
  dz /= len;

  double ax = fabs(dx);
  double ay = fabs(dy);
  double az = fabs(dz);

  // flip plane to make major axis positive
  if ( (-dx >= MAX(ay, az)) ||
       (-dy >= MAX(ax, az)) ||
       (-dz >= MAX(ax, ay)) )
  {
    *flipped = true;

    dx = -dx;
    dy = -dy;
    dz = -dz;
  }

  SYS_ASSERT(! (dx < -1.0 + EPSILON));
  SYS_ASSERT(! (dy < -1.0 + EPSILON));
  SYS_ASSERT(! (dz < -1.0 + EPSILON));

  // distance to the origin (0,0,0)
  double dist = (x*dx + y*dy + z*dz);


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
        fabs(test_p->normal[0] - dp.normal[0]) > EPSILON ||
        fabs(test_p->normal[1] - dp.normal[1]) > EPSILON ||
        fabs(test_p->normal[2] - dp.normal[2]) > EPSILON)
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
fprintf(stderr, "ADDED PLANE (idx %d), count %d\n",
                 (int)plane_idx, (int)q1_planes.size());

  hashtab->push_back(plane_idx);

  return plane_idx;
}

static void BSP_CreatePlanes(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_PLANES);

  // FIXME: write separately, fix endianness as we go

  Q1_Append(lump, &q1_planes[0], q1_planes.size() * sizeof(dplane_t));
}


//------------------------------------------------------------------------

std::vector<dvertex_t> q1_vertices;


static void ClearVertices(void)
{
  q1_vertices.clear();
}

u16_t Q1_AddVertex(double x, double y, double z)
{
  dvertex_t vert;

  vert.x = x;
  vert.y = y;
  vert.z = z;


  // find existing vertex
  // FIXME: OPTIMISE THIS

  for (u16_t i = 0; i < q1_vertices.size(); i++)
  {
    dvertex_t *test = &q1_vertices[i];

    if (fabs(test->x - x) < Q_EPSILON &&
        fabs(test->y - y) < Q_EPSILON &&
        fabs(test->z - z) < Q_EPSILON)
    {
      return i;  // found it
    }
  }


  // not found, so add new one
  u16_t vert_idx = q1_vertices.size();

  if (vert_idx >= MAX_MAP_VERTS)
    Main_FatalError("Quake1 build failure: exceeded limit of %d VERTEXES\n",
                    MAX_MAP_VERTS);

  q1_vertices.push_back(vert);

  return vert_idx;
}

static void BSP_CreateVertexes(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_VERTEXES);

  Q1_Append(lump, &q1_vertices[0], q1_vertices.size() * sizeof(dvertex_t));
}


//------------------------------------------------------------------------

std::vector<dedge_t> q1_edges;


static void ClearEdges(void)
{
  q1_edges.clear();

  // insert dummy edge #0
  dedge_t dummy;

  dummy.v[0] = dummy.v[1] = 0;

  q1_edges.push_back(dummy);
}


s32_t Q1_AddEdge(u16_t start, u16_t end)
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


  // find existing edge
  // FIXME: OPTIMISE THIS !!!!

  for (int i = 1; i < (int)q1_edges.size(); i++)
  {
    dedge_t *test = &q1_edges[i];

    if (test->v[0] == start && test->v[1] == end)
      return flipped ? -i : i;
  }


  // not found, so add new one
  int edge_idx = q1_edges.size();

  if (edge_idx >= MAX_MAP_EDGES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d EDGES\n",
                    MAX_MAP_EDGES);

  q1_edges.push_back(edge);

  return flipped ? -edge_idx : edge_idx;
}

static void BSP_CreateEdges(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_EDGES);

  Q1_Append(lump, &q1_edges[0], q1_edges.size() * sizeof(dedge_t));
}


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

  Q1_Append(lump, &mm_tex, sizeof(mm_tex));


  u8_t pixels[2] = { pix1, pix2 };

  size = 64;

  for (int i = 0; i < MIP_LEVELS; i++)
  {
    for (int y = 0; y < size; y++)
    for (int x = 0; x < size; x++)
    {
      Q1_Append(lump, pixels + (((x^y) & (size/4)) ? 1 : 0), 1);
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

      Q1_Append(lump, buffer, actual);

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

static void BSP_CreateMipTex(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_TEXTURES);

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
    offsets[m] = dir_size + lump->size();

    TransferOneMipTex(lump, m, q1_miptexs[m].c_str());
  }

  WAD2_CloseRead();

  // create miptex directory
  // FIXME: endianness
  Q1_Prepend(lump, offsets, 4 * num_miptex);
  Q1_Prepend(lump, &num_miptex, 4);

  delete[] offsets;
}

static void DummyMipTex(void)
{
  /* TEMP DUMMY STUFF */

  // 0 = "error"
  // 1 = "gray"

  qLump_c *lump = Q1_NewLump(LUMP_TEXTURES);


  dmiptexlump_t mm_dir;

  mm_dir.num_miptex = LE_S32(2);

  mm_dir.data_ofs[0] = LE_S32(sizeof(mm_dir));
  mm_dir.data_ofs[1] = LE_S32(sizeof(mm_dir) + sizeof(miptex_t) + 85*4);

  Q1_Append(lump, &mm_dir, sizeof(mm_dir));


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

    Q1_Append(lump, &mm_tex, sizeof(mm_tex));


    u8_t pixels[2];

    pixels[0] = (mt == 0) ? 210 : 4;
    pixels[1] = (mt == 0) ? 231 : 12;

    size = 16;

    for (int i = 0; i < MIP_LEVELS; i++)
    {
      for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++)
      {
        Q1_Append(lump, pixels + (((x^y) & 2)/2), 1);
      }

      size = size / 2;
    }
  }
}

//------------------------------------------------------------------------

std::vector<texinfo_t> q1_texinfos;

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

static void BSP_CreateTexInfo(void)
{
  qLump_c *lump = Q1_NewLump(LUMP_TEXINFO);

  // FIXME: write separately, fix endianness as we go
 
  Q1_Append(lump, &q1_texinfos[0], q1_texinfos.size() * sizeof(texinfo_t));
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

  qLump_c *lump = Q1_NewLump(LUMP_TEXINFO);

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

    Q1_Append(lump, &tex, sizeof(tex));
  }
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
fprintf(stderr, "Q1_end_level\n");

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

  ClearPlanes();
  ClearVertices();
  ClearEdges();
  ClearMipTex();
  ClearTexInfo();

  ClearLumps();

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

  BSP_CreateEntities();
  BSP_CreateInfoLump();

  BSP_CreateModel();

  BSP_CreatePlanes();
  BSP_CreateVertexes();
  BSP_CreateEdges();
  BSP_CreateMipTex();
  BSP_CreateTexInfo();


  // WRITE FAKE HEADER
  dheader_t header;
  memset(&header, 0, sizeof(header));

  BSP_RawWrite(&header, sizeof(header));


  // WRITE ALL LUMPS

  header.version = LE_U32(0x1D); 

  BSP_WriteLump(LUMP_OBLIGE_INFO, &header.lumps[LUMP_OBLIGE_INFO]);

  for (int L = 0; L < HEADER_LUMPS; L++)
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
