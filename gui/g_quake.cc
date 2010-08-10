//------------------------------------------------------------------------
//  LEVEL building - QUAKE and HALFLIFE format
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
#include "lib_pak.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"
#include "q1_structs.h"

#include "csg_main.h"
#include "csg_local.h"
#include "csg_quake.h"

#include "ui_chooser.h"
#include "img_all.h"


#define LEAF_PADDING   4
#define NODE_PADDING   16
#define MODEL_PADDING  24.0


extern int Q1_ClippingHull(int hull, qLump_c *q1_clip);


int qk_sub_format;

static char *level_name;
static char *description;


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
  Q1_AddMipTex("o_carve"); // #2
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

  lump->Append(&mm_tex, sizeof(mm_tex));


  u8_t pixels[2] = { pix1, pix2 };

  size = 64;

  for (int i = 0; i < MIP_LEVELS; i++)
  {
    for (int y = 0; y < size; y++)
    for (int x = 0; x < size; x++)
    {
      lump->Append(pixels + (((x^y) & (size/4)) ? 1 : 0), 1);
    }

    size /= 2;
  }
}


static void CreateLogoMip(qLump_c *lump, const char *name, const byte *data)
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

  lump->Append(&mm_tex, sizeof(mm_tex));


  size = 64;
  int scale = 1;

  static byte colormap[8] =
  {
    // 0, 16, 97, 101, 105, 109, 243, 243
    16, 97, 103, 109, 243, 243, 243, 243
  };

  for (int i = 0; i < MIP_LEVELS; i++)
  {
    for (int y = 0; y < size; y++)
    for (int x = 0; x < size; x++)
    {
      byte pixel = colormap[data[(63-y*scale)*64 + x*scale] >> 5];

      lump->Append(&pixel, 1);
    }

    size  /= 2;
    scale *= 2;
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
  if (strcmp(name, "o_carve") == 0)  // TEMP STUFF !!!!
  {
    CreateLogoMip(lump, name, logo_RELIEF.data);
    return;
  }

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

      lump->Append(buffer, actual);

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


static void HL_WriteMipTex(qLump_c *lump)
{
  // count
  int num_miptex = (int)q1_miptexs.size();

  u32_t raw_count = LE_U32(num_miptex);

  lump->Append(&raw_count, sizeof(raw_count));

  // offsets
  miptex_t raw_mip;

  for (int m = 0 ; m < num_miptex ; m++)
  {
    u32_t offset = 4 + 4 * num_miptex + m * sizeof(raw_mip);

    offset = LE_U32(offset);

    lump->Append(&offset, sizeof(offset));
  }

  // miptex structures
  for (int m = 0 ; m < num_miptex ; m++)
  {
    memset(&raw_mip, 0, sizeof(raw_mip));

    raw_mip.width  = LE_U32(128);  ///!!!!!!! FIXME
    raw_mip.height = LE_U32(128);

    strcpy(raw_mip.name, q1_miptexs[m].c_str());

    lump->Append(&raw_mip, sizeof(raw_mip));
  }
}


static void Q1_WriteMipTex()
{
  qLump_c *lump = BSP_NewLump(LUMP_TEXTURES);

  if (qk_sub_format == SUBFMT_HalfLife)
  {
    HL_WriteMipTex(lump);
    return;
  }

  if (! WAD2_OpenRead("data/quake_tex.wd2"))
  {
    // FIXME: specified by a Lua function
    //        (do a check there, point user to website if not present)
    Main_FatalError("No such file: data/quake_tex.wd2");
    return; /* NOT REACHED */
  }

  u32_t num_miptex = q1_miptexs.size();
  u32_t dir_size = 4 * num_miptex + 4;

  SYS_ASSERT(num_miptex > 0);

  u32_t *offsets = new u32_t[num_miptex];

  for (unsigned int m = 0 ; m < q1_miptexs.size() ; m++)
  {
    offsets[m] = dir_size + (u32_t)lump->GetSize();

    TransferOneMipTex(lump, m, q1_miptexs[m].c_str());
  }

  WAD2_CloseRead();

  // create miptex directory
  // FIXME: endianness
  lump->Prepend(offsets, 4 * num_miptex);
  lump->Prepend(&num_miptex, 4);

  delete[] offsets;
}

#if 0  /* TEMP DUMMY STUFF */
static void DummyMipTex(void)
{
  // 0 = "error"
  // 1 = "gray"

  qLump_c *lump = BSP_NewLump(LUMP_TEXTURES);


  dmiptexlump_t mm_dir;

  mm_dir.num_miptex = LE_S32(2);

  mm_dir.data_ofs[0] = LE_S32(sizeof(mm_dir));
  mm_dir.data_ofs[1] = LE_S32(sizeof(mm_dir) + sizeof(miptex_t) + 85*4);

  lump->Append(&mm_dir, sizeof(mm_dir));


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

    lump->Append(&mm_tex, sizeof(mm_tex));


    u8_t pixels[2];

    pixels[0] = (mt == 0) ? 210 : 4;
    pixels[1] = (mt == 0) ? 231 : 12;

    size = 16;

    for (int i = 0; i < MIP_LEVELS; i++)
    {
      for (int y = 0; y < size; y++)
      for (int x = 0; x < size; x++)
      {
        lump->Append(pixels + (((x^y) & 2)/2), 1);
      }

      size = size / 2;
    }
  }
}
#endif


//------------------------------------------------------------------------

#define TEXINFO_HASH_SIZE  64

static std::vector<texinfo_t> q1_texinfos;

static std::vector<int> * texinfo_hashtab[TEXINFO_HASH_SIZE];


static void ClearTexInfo(void)
{
  q1_texinfos.clear();

  for (int h = 0 ; h < TEXINFO_HASH_SIZE ; h++)
  {
    delete texinfo_hashtab[h];
    texinfo_hashtab[h] = NULL;
  }
}


u16_t Q1_AddTexInfo(const char *texture, int flags, float *s3, float *t3)
{
  if (! texture[0])
    texture = "error";

  int miptex = Q1_AddMipTex(texture);

  // create texinfo structure, fix endianness
  texinfo_t raw_tex;

  for (int k = 0 ; k < 3 ; k++)
  {
    raw_tex.s[k] = LE_Float32(s3[k]);
    raw_tex.t[k] = LE_Float32(t3[k]);
  }

  raw_tex.s[4] = LE_Float32(0);
  raw_tex.t[4] = LE_Float32(0);

  raw_tex.miptex = LE_S32(miptex);
  raw_tex.flags  = LE_S32(flags);


  // find an existing texinfo.
  // For speed we use a hash-table.
  int hash = miptex & (TEXINFO_HASH_SIZE - 1);

  SYS_ASSERT(hash >= 0);

  if (! texinfo_hashtab[hash])
    texinfo_hashtab[hash] = new std::vector<int>;

  std::vector<int> * hashtab = texinfo_hashtab[hash];

  for (unsigned int i = 0 ; i < hashtab->size() ; i++)
  {
    int index = (*hashtab)[i];

    SYS_ASSERT(index < (int)q1_texinfos.size());

    if (memcmp(&raw_tex, &q1_texinfos[index], sizeof(raw_tex)) == 0)
      return index;  // found it
  }


  // not found, so add new one
  u16_t new_index = q1_texinfos.size();

  q1_texinfos.push_back(raw_tex);

  hashtab->push_back(new_index);

  return new_index;
}


static void Q1_WriteTexInfo(void)
{
  if (q1_texinfos.size() >= MAX_MAP_TEXINFO)
    Main_FatalError("Quake build failure: exceeded limit of %d TEXINFOS\n",
                    MAX_MAP_TEXINFO);

  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  // FIXME: write separately, fix endianness as we go
 
  lump->Append(&q1_texinfos[0], q1_texinfos.size() * sizeof(texinfo_t));
}


#if 0  /* TEMP DUMMY STUFF */
static void DummyTexInfo(void)
{
  // 0 = "error" on PLANE_X / PLANE_ANYX
  // 1 = "error" on PLANE_Y / PLANE_ANYY
  // 2 = "error" on PLANE_Z / PLANE_ANYZ
  //
  // 3 = "gray"  on PLANE_X / PLANE_ANYX
  // 4 = "gray"  on PLANE_Y / PLANE_ANYY
  // 5 = "gray"  on PLANE_Z / PLANE_ANYZ

  qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

  float scale = 2.0;

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

    lump->Append(&tex, sizeof(tex));
  }
}
#endif


//------------------------------------------------------------------------

static void Q1_GetExtents(quake_face_c *F, int *ext_W, int *ext_H)
{
  double min_s, min_t;
  double max_s, max_t;

  F->ST_Bounds(&min_s, &min_t, &max_s, &max_t);

  // -AJA- this matches the logic in the Quake engine.

  int bmin_s = (int)floor(min_s / 16.0);
  int bmin_t = (int)floor(min_t / 16.0);

  int bmax_s = (int)ceil(max_s / 16.0);
  int bmax_t = (int)ceil(max_t / 16.0);

  *ext_W = bmax_s - bmin_s + 1;
  *ext_H = bmax_t - bmin_t + 1;
}


static void Q1_CreateLightmaps()
{
  for (unsigned int i = 0 ; i < qk_all_faces.size() ; i++)
  {
    quake_face_c *F = qk_all_faces[i];    

    // FIXME  if (F->unlit) continue;

    int ext_W, ext_H;

    Q1_GetExtents(F, &ext_W, &ext_H);
    
    fprintf(stderr, "FACE %p  EXTENTS %d %d\n", F, ext_W, ext_H);

    F->lmap = BSP_NewLightmap(ext_W, ext_H, rand() & 127);
  }
}


static void Q1_Lighting()
{
  Q1_CreateLightmaps();

  ///  QCOM_Lighting();

  bool colored = (qk_sub_format == SUBFMT_HalfLife) ? true : false;

  int max_size = MAX_MAP_LIGHTING * (colored ? 2 : 1);

  BSP_BuildLightmap(LUMP_LIGHTING, max_size, colored);
}


//------------------------------------------------------------------------
//   BSP TREE OUTPUT
//------------------------------------------------------------------------

static qLump_c *q1_surf_edges;
static qLump_c *q1_mark_surfs;

static qLump_c *q1_faces;
static qLump_c *q1_leafs;
static qLump_c *q1_nodes;

static qLump_c *q1_models;
static qLump_c *q1_clip;

static int q1_total_surf_edges;
static int q1_total_mark_surfs;

static int q1_total_faces;
static int q1_total_leafs;
static int q1_total_nodes;


static void Q1_WriteEdge(const quake_vertex_c & A, const quake_vertex_c & B)
{
  u16_t v1 = BSP_AddVertex(A.x, A.y, A.z);
  u16_t v2 = BSP_AddVertex(B.x, B.y, B.z);

  if (v1 == v2)
  {
    Main_FatalError("INTERNAL ERROR: Q1 WriteEdge is zero length!\n");
  }

  s32_t index = BSP_AddEdge(v1, v2);

  // fix endianness
  index = LE_S32(index);

  q1_surf_edges->Append(&index, sizeof(index));

  q1_total_surf_edges += 1;
}


static int CalcTextureFlag(const char *tex_name)
{
  if (tex_name[0] == '*')
    return TEX_SPECIAL;

  if (strncmp(tex_name, "sky", 3) == 0)
    return TEX_SPECIAL;

  return 0;
}


static inline void DoWriteFace(dface_t & raw_face)
{
  // fix endianness
  raw_face.planenum  = LE_S16(raw_face.planenum);
  raw_face.side      = LE_S16(raw_face.side);
  raw_face.firstedge = LE_S32(raw_face.firstedge);
  raw_face.numedges  = LE_S16(raw_face.numedges);
  raw_face.texinfo   = LE_S16(raw_face.texinfo);
  raw_face.lightofs  = LE_S32(raw_face.lightofs);

  q1_faces->Append(&raw_face, sizeof(raw_face));

  q1_total_faces += 1;
}


static void Q1_WriteFace(quake_face_c *face)
{
  SYS_ASSERT(face->node);
  SYS_ASSERT(face->node_side >= 0);

  face->index = q1_total_faces;


  dface_t raw_face;

  memset(&raw_face, 0, sizeof(raw_face));


  bool flipped;

  raw_face.planenum = BSP_AddPlane(&face->node->plane, &flipped);

  raw_face.side = face->node_side ^ (flipped ? 1 : 0);


  unsigned int total_v = face->verts.size();

  raw_face.firstedge = q1_total_surf_edges;
  raw_face.numedges  = total_v;

  for (unsigned int i = 0 ; i < total_v ; i++)
  {
    Q1_WriteEdge(face->verts[i], face->verts[(i+1) % total_v]);
  }


  // texture and lighitng...

  const char *texture = face->texture.c_str();

  int flags = CalcTextureFlag(texture);

  raw_face.texinfo = Q1_AddTexInfo(texture, flags, face->s, face->t);


  raw_face.styles[0] = 0;
  raw_face.styles[1] = 0xFF;
  raw_face.styles[2] = 0xFF;
  raw_face.styles[3] = 0xFF;

  raw_face.lightofs = 0 + (rand() & 8188); //!!!!!! TEST CRUD

  if (face->lmap)
    raw_face.lightofs = face->lmap->CalcOffset();

  DoWriteFace(raw_face);
}


static void Q1_WriteMarkSurf(int index)
{
  SYS_ASSERT(index >= 0);

  // fix endianness
  u16_t raw_index = LE_U16(index);

  q1_mark_surfs->Append(&raw_index, sizeof(raw_index));

  q1_total_mark_surfs += 1;
}


static void DoWriteLeaf(dleaf_t & raw_leaf)
{
  // fix endianness
  raw_leaf.contents = LE_S32(raw_leaf.contents);
  raw_leaf.visofs   = LE_S32(raw_leaf.visofs);

  raw_leaf.first_marksurf = LE_U16(raw_leaf.first_marksurf);
  raw_leaf.num_marksurf   = LE_U16(raw_leaf.num_marksurf);

  for (int b = 0 ; b < 3 ; b++)
  {
    raw_leaf.mins[b] = LE_S16(raw_leaf.mins[b] - LEAF_PADDING);
    raw_leaf.maxs[b] = LE_S16(raw_leaf.maxs[b] + LEAF_PADDING);
  }

  q1_leafs->Append(&raw_leaf, sizeof(raw_leaf));

  q1_total_leafs += 1;
}


static void Q1_WriteLeaf(quake_leaf_c *leaf)
{
  if (leaf == qk_solid_leaf)
    return;


  dleaf_t raw_leaf;

  memset(&raw_leaf, 0, sizeof(raw_leaf));

  raw_leaf.contents = leaf->contents;
  raw_leaf.visofs   = -1;  // no visibility info


  // create the 'mark surfs'
  raw_leaf.first_marksurf = q1_total_mark_surfs;
  raw_leaf.num_marksurf   = 0;

  for (unsigned int i = 0 ; i < leaf->faces.size() ; i++)
  {
    Q1_WriteMarkSurf(leaf->faces[i]->index);

    raw_leaf.num_marksurf += 1;
  }

  for (int b = 0 ; b < 3 ; b++)
  {
    raw_leaf.mins[b] = I_ROUND(leaf->bbox.mins[b]);
    raw_leaf.maxs[b] = I_ROUND(leaf->bbox.maxs[b]);
  }

  DoWriteLeaf(raw_leaf);
}


static void Q1_WriteSolidLeaf(void)
{
  dleaf_t raw_leaf;

  memset(&raw_leaf, 0, sizeof(raw_leaf));

  raw_leaf.contents = LE_S32(CONTENTS_SOLID);
  raw_leaf.visofs   = LE_S32(-1);  // no visibility info

  q1_leafs->Append(&raw_leaf, sizeof(raw_leaf));
}


static void DoWriteNode(dnode_t & raw_node)
{
  // fix endianness
  raw_node.planenum    = LE_S32(raw_node.planenum);
  raw_node.children[0] = LE_S16(raw_node.children[0]);
  raw_node.children[1] = LE_S16(raw_node.children[1]);
  raw_node.firstface   = LE_U16(raw_node.firstface);
  raw_node.numfaces    = LE_U16(raw_node.numfaces);

  for (int b = 0 ; b < 3 ; b++)
  {
    raw_node.mins[b] = LE_S16(raw_node.mins[b] - NODE_PADDING);
    raw_node.maxs[b] = LE_S16(raw_node.maxs[b] + NODE_PADDING);
  }

  q1_nodes->Append(&raw_node, sizeof(raw_node));

  q1_total_nodes += 1;
}


static void Q1_WriteNode(quake_node_c *node)
{
  dnode_t raw_node;

  bool flipped;

  raw_node.planenum = BSP_AddPlane(&node->plane, &flipped);

  
  if (node->front_N)
    raw_node.children[0] = (u16_t) node->front_N->index;
  else
    raw_node.children[0] = (u16_t) node->front_L->index;

  if (node->back_N)
    raw_node.children[1] = (u16_t) node->back_N->index;
  else
    raw_node.children[1] = (u16_t) node->back_L->index;

  if (flipped)
  {
    std::swap(raw_node.children[0], raw_node.children[1]);
  }


  raw_node.firstface = q1_total_faces;
  raw_node.numfaces  = node->faces.size();

  if (raw_node.numfaces > 0)
  {
    for (unsigned int k = 0 ; k < node->faces.size() ; k++)
    {
      Q1_WriteFace(node->faces[k]);
    }
  }


  for (int b = 0 ; b < 3 ; b++)
  {
    raw_node.mins[b] = I_ROUND(node->bbox.mins[b]);
    raw_node.maxs[b] = I_ROUND(node->bbox.maxs[b]);
  }


  DoWriteNode(raw_node);


  // recurse now, AFTER adding the current node

  if (node->front_N)
    Q1_WriteNode(node->front_N);
  else
    Q1_WriteLeaf(node->front_L);

  if (node->back_N)
    Q1_WriteNode(node->back_N);
  else
    Q1_WriteLeaf(node->back_L);
}


static void Q1_WriteBSP()
{
  q1_total_nodes = 0;
  q1_total_leafs = 0;  // not including the solid leaf
  q1_total_faces = 0;

  q1_total_mark_surfs = 0;
  q1_total_surf_edges = 0;

  q1_nodes = BSP_NewLump(LUMP_NODES);
  q1_leafs = BSP_NewLump(LUMP_LEAFS);
  q1_faces = BSP_NewLump(LUMP_FACES);

  q1_mark_surfs = BSP_NewLump(LUMP_MARKSURFACES);
  q1_surf_edges = BSP_NewLump(LUMP_SURFEDGES);


  Q1_WriteSolidLeaf();

  Q1_WriteNode(qk_bsp_root);  


  if (q1_total_faces >= MAX_MAP_FACES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d FACES\n",
                    MAX_MAP_FACES);

  if (q1_total_leafs >= MAX_MAP_LEAFS)
    Main_FatalError("Quake1 build failure: exceeded limit of %d LEAFS\n",
                    MAX_MAP_LEAFS);

  if (q1_total_nodes >= MAX_MAP_NODES)
    Main_FatalError("Quake1 build failure: exceeded limit of %d NODES\n",
                    MAX_MAP_NODES);
}


static void DoWriteModel(dmodel_t & raw_model)
{
  // fix endianness
  raw_model.visleafs  = LE_S32(raw_model.visleafs);
  raw_model.firstface = LE_S32(raw_model.firstface);
  raw_model.numfaces  = LE_S32(raw_model.numfaces);

  for (int h = 0 ; h < 4 ; h++)
  {
    raw_model.headnode[h] = LE_S32(raw_model.headnode[h]);
  }

  for (int b = 0 ; b < 3 ; b++)
  {
    raw_model.mins[b] = LE_Float32(raw_model.mins[b] - MODEL_PADDING);
    raw_model.maxs[b] = LE_Float32(raw_model.maxs[b] + MODEL_PADDING);

    raw_model.origin[b] = LE_Float32(raw_model.origin[b]);
  }

  q1_models->Append(&raw_model, sizeof(raw_model));
}


static void Q1_WriteModel(int hull_1, int hull_2)
{
  q1_models = BSP_NewLump(LUMP_MODELS);

  dmodel_t raw_model;

  raw_model.headnode[0] = 0;
  raw_model.headnode[1] = hull_1;
  raw_model.headnode[2] = hull_2;
  raw_model.headnode[3] = 0;

  // -AJA- I don't think original Quake actually uses this value
  raw_model.visleafs  = q1_total_leafs;

  raw_model.firstface = 0;
  raw_model.numfaces  = q1_total_faces;

  for (int b = 0 ; b < 3 ; b++)
  {
    raw_model.mins[b] = qk_bsp_root->bbox.mins[b];
    raw_model.maxs[b] = qk_bsp_root->bbox.maxs[b];

    raw_model.origin[b] = 0;
  }

  DoWriteModel(raw_model);
}


//------------------------------------------------------------------------
//   MAP MODEL STUFF
//------------------------------------------------------------------------

static void MapModel_Edge(float x1, float y1, float z1,
                          float x2, float y2, float z2)
{
  quake_vertex_c A(x1, y1, z1);
  quake_vertex_c B(x2, y2, z2);

  Q1_WriteEdge(A, B);
}


static void MapModel_Face(quake_mapmodel_c *model, int face, s16_t plane, bool flipped)
{
  dface_t raw_face;

  raw_face.planenum = plane;
  raw_face.side = flipped ? 1 : 0;
 

  const char *texture = "error";

  float s[3] = { 0.0, 0.0, 0.0 };
  float t[3] = { 0.0, 0.0, 0.0 };


  // add the edges

  raw_face.firstedge = q1_total_surf_edges;
  raw_face.numedges  = 4;

  if (face < 2)  // PLANE_X
  {
    s[1] = 1;  // PLANE_X
    t[2] = 1;

    texture = model->x_face.getStr("tex", "missing");

    double x = (face==0) ? model->x1 : model->x2;
    double y1 = flipped  ? model->y2 : model->y1;
    double y2 = flipped  ? model->y1 : model->y2;

    // Note: this assumes the plane is positive
    MapModel_Edge(x, y1, model->z1, x, y1, model->z2);
    MapModel_Edge(x, y1, model->z2, x, y2, model->z2);
    MapModel_Edge(x, y2, model->z2, x, y2, model->z1);
    MapModel_Edge(x, y2, model->z1, x, y1, model->z1);
  }
  else if (face < 4)
  {
    s[0] = 1;  // PLANE_Y
    t[2] = 1;

    texture = model->y_face.getStr("tex", "missing");

    double y = (face==2) ? model->y1 : model->y2;
    double x1 = flipped  ? model->x1 : model->x2;
    double x2 = flipped  ? model->x2 : model->x1;

    MapModel_Edge(x1, y, model->z1, x1, y, model->z2);
    MapModel_Edge(x1, y, model->z2, x2, y, model->z2);
    MapModel_Edge(x2, y, model->z2, x2, y, model->z1);
    MapModel_Edge(x2, y, model->z1, x1, y, model->z1);
  }
  else
  {
    s[0] = 1;  // PLANE_Z
    t[1] = 1;

    texture = model->z_face.getStr("tex", "missing");

    double z = (face==5) ? model->z1 : model->z2;
    double x1 = flipped  ? model->x2 : model->x1;
    double x2 = flipped  ? model->x1 : model->x2;

    MapModel_Edge(x1, model->y1, z, x1, model->y2, z);
    MapModel_Edge(x1, model->y2, z, x2, model->y2, z);
    MapModel_Edge(x2, model->y2, z, x2, model->y1, z);
    MapModel_Edge(x2, model->y1, z, x1, model->y1, z);
  }


  // texture and lighting

  raw_face.texinfo = Q1_AddTexInfo(texture, 0, s, t);

  raw_face.styles[0] = 0;
  raw_face.styles[1] = 0xFF;
  raw_face.styles[2] = 0xFF;
  raw_face.styles[3] = 0xFF;

  raw_face.lightofs = 72*17*17;  // FIXME


  DoWriteFace(raw_face);
}


static void MapModel_Nodes(quake_mapmodel_c *model, float *mins, float *maxs)
{
  int face_base = q1_total_faces;
  int leaf_base = q1_total_leafs;

  model->nodes[0] = q1_total_nodes;

  for (int face = 0 ; face < 6 ; face++)
  {
    dnode_t raw_node;
    dleaf_t raw_leaf;

    memset(&raw_leaf, 0, sizeof(raw_leaf));

    double v;
    double dir;

    bool flipped;

    if (face < 2)  // PLANE_X
    {
      v = (face==0) ? model->x1 : model->x2;
      dir = (face==0) ? -1 : 1;
      raw_node.planenum = BSP_AddPlane(v,0,0, dir,0,0, &flipped);
    }
    else if (face < 4)  // PLANE_Y
    {
      v = (face==2) ? model->y1 : model->y2;
      dir = (face==2) ? -1 : 1;
      raw_node.planenum = BSP_AddPlane(0,v,0, 0,dir,0, &flipped);
    }
    else  // PLANE_Z
    {
      v = (face==5) ? model->z1 : model->z2;
      dir = (face==5) ? -1 : 1;
      raw_node.planenum = BSP_AddPlane(0,0,v, 0,0,dir, &flipped);
    }

    raw_node.children[0] = -(leaf_base + face + 2);
    raw_node.children[1] = (face == 5) ? -1 : (model->nodes[0] + face + 1);

    if (flipped)
    {
      std::swap(raw_node.children[0], raw_node.children[1]);
    }

    raw_node.firstface = face_base + face;
    raw_node.numfaces  = 1;

    for (int b = 0 ; b < 3 ; b++)
    {
      raw_leaf.mins[b] = raw_node.mins[b] = mins[b];
      raw_leaf.maxs[b] = raw_node.maxs[b] = maxs[b];
    }

    raw_leaf.contents = CONTENTS_EMPTY;
    raw_leaf.visofs = -1;

    raw_leaf.first_marksurf = q1_total_mark_surfs;
    raw_leaf.num_marksurf   = 1;

    MapModel_Face(model, face, raw_node.planenum, flipped);

    Q1_WriteMarkSurf(q1_total_mark_surfs);

    DoWriteNode(raw_node);
    DoWriteLeaf(raw_leaf);
  }
}


static void Q1_WriteSubModels()
{
  for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
  {
    quake_mapmodel_c *model = qk_all_mapmodels[i];

    dmodel_t raw_model;

    raw_model.firstface = q1_total_faces;
    raw_model.numfaces  = 6;
    raw_model.visleafs  = 6;

    // bbox
    raw_model.mins[0] = model->x1;
    raw_model.mins[1] = model->y1;
    raw_model.mins[2] = model->z1;

    raw_model.maxs[0] = model->x2;
    raw_model.maxs[1] = model->y2;
    raw_model.maxs[2] = model->z2;

    raw_model.origin[0] = 0;
    raw_model.origin[1] = 0;
    raw_model.origin[2] = 0;

    MapModel_Nodes(model, raw_model.mins, raw_model.maxs);

    for (int h = 0 ; h < 4 ; h++)
    {
      raw_model.headnode[h] = model->nodes[h];
    }

    DoWriteModel(raw_model);
  }
}


static void Q1_CreateBSPFile(const char *name)
{
  BSP_OpenLevel(name, 1);

  ClearMipTex();
  ClearTexInfo();

  CSG_QUAKE_Build();

  Q1_Lighting();

  ///  QCOM_Visibility();

  Q1_WriteBSP();

  q1_clip = BSP_NewLump(LUMP_CLIPNODES);

  int hull_1 = Q1_ClippingHull(1, q1_clip);
  int hull_2 = Q1_ClippingHull(2, q1_clip);

  Q1_WriteModel(hull_1, hull_2);

  Q1_WriteSubModels();

  BSP_WritePlanes  (LUMP_PLANES,   MAX_MAP_PLANES);
  BSP_WriteVertices(LUMP_VERTEXES, MAX_MAP_VERTS );
  BSP_WriteEdges   (LUMP_EDGES,    MAX_MAP_EDGES );

  Q1_WriteMipTex();
  Q1_WriteTexInfo();

  BSP_WriteEntities(LUMP_ENTITIES, description);

  BSP_CloseLevel();

  // FREE STUFF !!!!

}


//------------------------------------------------------------------------

class quake1_game_interface_c : public game_interface_c
{
private:
  const char *filename;

public:
  quake1_game_interface_c() : filename(NULL)
  { }

  ~quake1_game_interface_c()
  { }

  bool Start();
  bool Finish(bool build_ok);

  void BeginLevel();
  void EndLevel();
  void Property(const char *key, const char *value);
};


bool quake1_game_interface_c::Start()
{
  qk_sub_format = 0;

  filename = Select_Output_File("pak");

  if (! filename)
  {
    Main_ProgStatus("Cancelled");
    return false;
  }

  if (create_backups)
    Main_BackupFile(filename, "old");

  if (! PAK_OpenWrite(filename))
  {
    Main_ProgStatus("Error (create file)");
    return false;
  }

  BSP_AddInfoFile();

  if (main_win)
    main_win->build_box->Prog_Init(0, "CSG,BSP,Hull 1,Hull 2" /*Light,Vis*/);

  return true;
}


bool quake1_game_interface_c::Finish(bool build_ok)
{
  PAK_CloseWrite();

  // remove the file if an error occurred
  if (! build_ok)
    FileDelete(filename);

  return build_ok;
}


void quake1_game_interface_c::BeginLevel()
{
  level_name  = NULL;
  description = NULL;
}


void quake1_game_interface_c::Property(const char *key, const char *value)
{
  if (StringCaseCmp(key, "level_name") == 0)
  {
    level_name = StringDup(value);
  }
  else if (StringCaseCmp(key, "description") == 0)
  {
    description = StringDup(value);
  }
  else if (StringCaseCmp(key, "sub_format") == 0)
  {
    if (StringCaseCmp(value, "quake") == 0)
      qk_sub_format = 0;
    else if (StringCaseCmp(value, "hexen2") == 0)
      qk_sub_format = SUBFMT_Hexen2;
    else if (StringCaseCmp(value, "halflife") == 0)
      qk_sub_format = SUBFMT_HalfLife;
    else
      LogPrintf("WARNING: QUAKE1: unknown sub_format '%s'\n", value);
  }
  else
  {
    LogPrintf("WARNING: QUAKE1: unknown level prop: %s=%s\n", key, value);
  }
}


void quake1_game_interface_c::EndLevel()
{
  if (! level_name)
    Main_FatalError("Script problem: did not set level name!\n");

  if (strlen(level_name) >= 32)
    Main_FatalError("Script problem: level name too long: %s\n", level_name);

  char entry_in_pak[64];
  sprintf(entry_in_pak, "maps/%s.bsp", level_name);

  Q1_CreateBSPFile(entry_in_pak);

  StringFree(level_name);

  if (description)
    StringFree(description);
}


game_interface_c * Quake1_GameObject(void)
{
  return new quake1_game_interface_c();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
