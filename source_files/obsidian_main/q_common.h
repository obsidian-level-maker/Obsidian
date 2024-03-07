//------------------------------------------------------------------------
//  BSP files - Quake I and II
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
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

#ifndef Q_COMMON_H_
#define Q_COMMON_H_

#include <stdint.h>
#include <string>
#include <vector>

// perhaps this should be elsewhere
constexpr double Q_EPSILON = 0.02;

class quake_plane_c;
class quake_vertex_c;

enum quake_subformat_e {
    SUBFMT_Hexen2 = 1,
    SUBFMT_HalfLife = 2,
};

/***** CLASSES ****************/

class qLump_c {
   public:
    std::string name;

   private:
    std::vector<uint8_t> buffer;

    // when true Printf() converts '\n' to CR/LF pair
    bool crlf;

   public:
    qLump_c();
    ~qLump_c();

    void Append(const void *data, uint32_t len);
    void Append(qLump_c *other);

    void Prepend(const void *data, uint32_t len);

    void AddByte(uint8_t value);

    void Printf(const char *str, ...);
    void KeyPair(const char *key, const char *val, ...);
    void SetCRLF(bool enable);

    int GetSize() const;
    const uint8_t *GetBuffer() const;

   private:
    void RawPrintf(const char *str);
};

/***** VARIABLES ****************/

extern int qk_game;
extern int qk_sub_format;
extern int qk_worldtype;

/***** FUNCTIONS ****************/

bool BSP_OpenLevel(const char *entry_in_pak);
bool BSP_CloseLevel();

qLump_c *BSP_NewLump(int entry);

void BSP_AddInfoFile();
qLump_c *BSP_CreateInfoLump();

uint16_t BSP_AddPlane(float x, float y, float z, float nx, float ny, float nz,
                   bool *flip_var = NULL);
uint16_t BSP_AddPlane(const quake_plane_c *P, bool *flip_var = NULL);

uint16_t BSP_AddVertex(float x, float y, float z);
uint16_t BSP_AddVertex(const quake_vertex_c *V);

int32_t BSP_AddEdge(uint16_t start, uint16_t end);

void BSP_WritePlanes(int lump_num, int max_planes);
void BSP_WriteVertices(int lump_num, int max_verts);
void BSP_WriteEdges(int lump_num, int max_edges);

void BSP_WriteEntities(int lump_num, const char *description);

// utility function
int BSP_NiceMidwayPoint(float low, float extent);

// q_tjuncs.cc
void QCOM_Fix_T_Junctions();

/* ----- BSP lump directory ------------------------- */

constexpr int Q1_HEADER_LUMPS = 15;
constexpr int Q1_BSP_VERSION = 29;

constexpr int Q2_HEADER_LUMPS = 19;
constexpr int Q2_BSP_VERSION = 38;
constexpr const char *Q2_IDENT_MAGIC = "IBSP";

#pragma pack(push, 1)
struct lump_t {
    uint32_t start;
    uint32_t length;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dheader_t {
    int32_t version;
    lump_t lumps[Q1_HEADER_LUMPS];
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dheader2_t {
    char ident[4];
    int32_t version;

    lump_t lumps[Q2_HEADER_LUMPS];
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dvertex_t {
    float x, y, z;
};
#pragma pack(pop)

// note that edge 0 is never used, because negative edge nums are used for
// counterclockwise use of the edge in a face
#pragma pack(push, 1)
struct dedge_t {
    uint16_t v[2];  // vertex numbers
};
#pragma pack(pop)

#pragma pack(push, 1)
struct dplane_t {
    float normal[3];
    float dist;
    int32_t type;  // PLANE_X - PLANE_ANYZ
};
#pragma pack(pop)

enum {
    // 0-2 are axial planes
    PLANE_X,
    PLANE_Y,
    PLANE_Z,

    // 3-5 are non-axial planes snapped to the nearest
    PLANE_ANYX,
    PLANE_ANYY,
    PLANE_ANYZ,
};

constexpr int NUM_STYLES = 4;

#pragma pack(push, 1)
struct dface_t {
    int16_t planenum;
    int16_t side;

    int32_t firstedge;  // we must support > 64k edges
    int16_t numedges;
    int16_t texinfo;

    // lighting info
    uint8_t styles[NUM_STYLES];

    int32_t lightofs;  // start of [numstyles*surfsize] samples
};
#pragma pack(pop)

#endif /* __OBLIGE_BSPOUT_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
