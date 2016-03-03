//------------------------------------------------------------------------
//  BSP files - Quake I and II
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2009 Andrew Apted
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


class quake_plane_c;
class quake_vertex_c;


typedef enum
{
  SUBFMT_Hexen2   = 1,
  SUBFMT_HalfLife = 2,
}
quake_subformat_e;


/***** CLASSES ****************/

class qLump_c
{
private:
	std::vector<u8_t> buffer;

	std::string name;

	// when true Printf() converts '\n' to CR/LF pair
	bool crlf;

public:
	qLump_c();
	~qLump_c();

	void Append(const void *data, u32_t len);
	void Append(qLump_c *other);

	void Prepend(const void *data, u32_t len);

	void Printf (const char *str, ...);
	void KeyPair(const char *key, const char *val, ...);
	void SetCRLF(bool enable);

	int GetSize() const;
	const u8_t *GetBuffer() const;

	void SetName(const char *_name);
	const char *GetName() const;

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


u16_t BSP_AddPlane(float x, float y, float z,
                   float nx, float ny, float nz, bool *flip_var = NULL);
u16_t BSP_AddPlane(const quake_plane_c *P, bool *flip_var = NULL);

u16_t BSP_AddVertex(float x, float y, float z);
u16_t BSP_AddVertex(const quake_vertex_c *V);

s32_t BSP_AddEdge(u16_t start, u16_t end);

void BSP_WritePlanes  (int lump_num, int max_planes);
void BSP_WriteVertices(int lump_num, int max_verts);
void BSP_WriteEdges   (int lump_num, int max_edges);

void BSP_WriteEntities(int lump_num, const char *description);


// utility function
int BSP_NiceMidwayPoint(float low, float extent);


// q_tjuncs.cc
void QCOM_Fix_T_Junctions();


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

} PACKEDATTR lump_t;

typedef struct
{
	s32_t version;
	lump_t lumps[Q1_HEADER_LUMPS];

} PACKEDATTR dheader_t;

typedef struct
{
	char   ident[4];
	s32_t  version;  

	lump_t lumps[Q2_HEADER_LUMPS];

} PACKEDATTR dheader2_t;


typedef struct
{
	float x, y, z;

} PACKEDATTR dvertex_t;

// note that edge 0 is never used, because negative edge nums are used for
// counterclockwise use of the edge in a face
typedef struct
{
	u16_t v[2]; // vertex numbers

} PACKEDATTR dedge_t;

typedef struct
{
	float normal[3];
	float dist;
	s32_t type; // PLANE_X - PLANE_ANYZ 

} PACKEDATTR dplane_t;

// 0-2 are axial planes
#define PLANE_X      0
#define PLANE_Y      1
#define PLANE_Z      2

// 3-5 are non-axial planes snapped to the nearest
#define PLANE_ANYX   3
#define PLANE_ANYY   4
#define PLANE_ANYZ   5


#define NUM_STYLES  4

typedef struct
{
	s16_t planenum;
	s16_t side;

	s32_t firstedge;    // we must support > 64k edges
	s16_t numedges;
	s16_t texinfo;

	// lighting info
	u8_t  styles[NUM_STYLES];

	s32_t lightofs;   // start of [numstyles*surfsize] samples

} PACKEDATTR dface_t;


#endif /* __OBLIGE_BSPOUT_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
