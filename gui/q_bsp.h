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

#ifndef __OBLIGE_BSPOUT_H__
#define __OBLIGE_BSPOUT_H__

// perhaps this should be elsewhere
#define Q_EPSILON  0.02


class qLump_c
{
/* !!!! */
public:

  std::vector<u8_t> buffer;

  // when true Printf() converts '\n' to CR/LF pair
  bool crlf;

///--- public: // access only in q_bsp.cc!
///---   u32_t offset;

public:
   qLump_c();
  ~qLump_c();

  void Append (const void *data, u32_t len);
  void Prepend(const void *data, u32_t len);

  void Printf (const char *str, ...);
  void KeyPair(const char *key, const char *val, ...);
  void SetCRLF(bool enable);

  int GetSize() const;

private:
  void RawPrintf(const char *str);
};


void BSP_BackupPAK(const char *filename);

bool BSP_OpenLevel(const char *entry_in_pak, int game /* 1 or 2 */);
bool BSP_CloseLevel();

qLump_c *BSP_NewLump(int entry);


void BSP_PreparePlanes(int lump, int max_planes);
void BSP_PrepareVertices(int lump, int max_verts);
void BSP_PrepareEdges(int lump, int max_edges);
void BSP_PrepareLightmap(int lump, int max_lightmap);

u16_t BSP_AddPlane(double x, double y, double z,
                   double nx, double ny, double nz, bool *flipped);
u16_t BSP_AddVertex(double x, double y, double z);
s32_t BSP_AddEdge(u16_t start, u16_t end);
s32_t BSP_AddLightBlock(int w, int h, u8_t *levels);

void BSP_WritePlanes(void);
void BSP_WriteVertices(void);
void BSP_WriteEdges(void);


/* ----- BSP lump directory ------------------------- */

#define Q1_HEADER_LUMPS  15
#define Q1_BSP_VERSION   29

#define Q2_HEADER_LUMPS  19
#define Q2_BSP_VERSION   38
#define Q2_IDENT_MAGIC   "IBSP"

typedef struct
{
  u32_t start;
  u32_t length;
}
lump_t;

typedef struct
{
  s32_t version;
  lump_t lumps[Q1_HEADER_LUMPS];
}
dheader_t;

typedef struct
{
  char   ident[4];
  s32_t  version;  

  lump_t lumps[Q2_HEADER_LUMPS];
}
dheader2_t;


typedef struct
{
  float x, y, z;
}
dvertex_t;

// note that edge 0 is never used, because negative edge nums are used for
// counterclockwise use of the edge in a face
typedef struct
{
  u16_t v[2]; // vertex numbers
}
dedge_t;

typedef struct
{
  float normal[3];
  float dist;
  s32_t type; // PLANE_X - PLANE_ANYZ 
}
dplane_t;

// 0-2 are axial planes
#define PLANE_X      0
#define PLANE_Y      1
#define PLANE_Z      2

// 3-5 are non-axial planes snapped to the nearest
#define PLANE_ANYX   3
#define PLANE_ANYY   4
#define PLANE_ANYZ   5


#endif /* __OBLIGE_BSPOUT_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
