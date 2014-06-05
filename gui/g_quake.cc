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
#include "lib_wad.h"

#include "main.h"
#include "m_cookie.h"

#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"
#include "q1_structs.h"

#include "csg_main.h"
#include "csg_local.h"
#include "csg_quake.h"

#include "img_all.h"


/*
 *  Differences between HALF-LIFE and QUAKE
 *  ---------------------------------------
 *
 *   1. third clipping hull for crouching
 *   2. lighting is colored (3 bytes per luxel)
 *   3. planes are paired (as per Quake II)
 *   4. miptex lump can omit the image data
 *   5. mip-textures have a palette appended (256 triples)
 *   6. some special fields in the worldspawn entity
 *
 */

#define HL_MAX_MAP_LIGHTING  0x200000

#define MODEL_LIGHT  64


#define LEAF_PADDING   4
#define NODE_PADDING   16
#define MODEL_PADDING  1.0


extern void Q1_ClippingHull(int hull);


static char *level_name;
static char *description;
static char *qk_texture_wad;

quake_mapmodel_c *qk_world_model;


//------------------------------------------------------------------------

static std::vector<std::string>   q1_miptexs;
static std::map<std::string, int> q1_miptex_map;

static int num_custom_tex = 0;

s32_t Q1_AddMipTex(const char *name);


static void Q1_ClearMipTex(void)
{
	q1_miptexs.clear();
	q1_miptex_map.clear();

	// built-in textures
	Q1_AddMipTex("error");   // #0
	Q1_AddMipTex("missing"); // #1
	Q1_AddMipTex("o_carve"); // #2
	Q1_AddMipTex("o_bolt");  // #3

	num_custom_tex = 4;
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

	for (int i = 0 ; i < MIP_LEVELS ; i++)
	{
		mm_tex.offsets[i] = LE_U32(offset);

		offset += (size * size);
		size /= 2;
	}

	lump->Append(&mm_tex, sizeof(mm_tex));


	u8_t pixels[2] = { pix1, pix2 };

	size = 64;

	for (int i = 0 ; i < MIP_LEVELS ; i++)
	{
		for (int y = 0 ; y < size ; y++)
			for (int x = 0 ; x < size ; x++)
			{
				lump->Append(pixels + (((x^y) & (size/4)) ? 1 : 0), 1);
			}

		size /= 2;
	}
}


static void CreateLogoMip(qLump_c *lump, const char *name, const byte *data,
		const byte *colors)
{
	SYS_ASSERT(strlen(name) < 16);

	miptex_t mm_tex;

	strcpy(mm_tex.name, name);

	int size = 64;

	mm_tex.width  = LE_U32(size);
	mm_tex.height = LE_U32(size);

	int offset = sizeof(mm_tex);

	for (int i = 0 ; i < MIP_LEVELS ; i++)
	{
		mm_tex.offsets[i] = LE_U32(offset);

		offset += (size * size);
		size /= 2;
	}

	lump->Append(&mm_tex, sizeof(mm_tex));

	size = 64;
	int scale = 1;

	for (int i = 0 ; i < MIP_LEVELS ; i++)
	{
		for (int y = 0 ; y < size ; y++)
		for (int x = 0 ; x < size ; x++)
		{
			byte pixel = colors[data[(y*scale)*64 + x*scale] >> 5];

			lump->Append(&pixel, 1);
		}

		size  /= 2;
		scale *= 2;
	}
}


static void TransferOneMipTex(qLump_c *lump, unsigned int m, const char *name)
{
	static byte relief_colors[8] =  // yellow range
	{
		207, 205, 203, 201, 199, 197, 195, 193
	};

	static byte bolt_colors[8] =  // blue range
	{
		0, 223, 222, 221, 219, 217, 214, 211
	};

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
		CreateLogoMip(lump, name, logo_RELIEF.data, relief_colors);
		return;
	}
	if (strcmp(name, "o_bolt") == 0)  // TEMP STUFF !!!!
	{
		CreateLogoMip(lump, name, logo_BOLT.data, bolt_colors);
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

	if (! qk_texture_wad)
	{
		Main_FatalError("Lua code failed to set the texture wad\n");
		return; /* NOT REACHED */
	}

	if (! WAD2_OpenRead(qk_texture_wad))
	{
		// should not happen, Lua code has checked that the file exists
		Main_FatalError("Missing wad file: %s\n", qk_texture_wad);
		return; /* NOT REACHED */
	}

	u32_t num_miptex = q1_miptexs.size();
	u32_t dir_size = 4 * num_miptex + 4;

	SYS_ASSERT(num_miptex > 0);

	u32_t *offsets = new u32_t[num_miptex];

	for (unsigned int m = 0 ; m < num_miptex ; m++)
	{
		offsets[m] = dir_size + (u32_t)lump->GetSize();
		offsets[m] = LE_U32(offsets[m]);

		TransferOneMipTex(lump, m, q1_miptexs[m].c_str());
	}

	WAD2_CloseRead();

	// create miptex directory
	num_miptex = LE_S32(num_miptex);

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

#define TEXINFO_HASH_SIZE  128

static std::vector<texinfo_t> q1_texinfos;

static std::vector<int> * texinfo_hashtab[TEXINFO_HASH_SIZE];


static void Q1_ClearTexInfo(void)
{
	q1_texinfos.clear();

	for (int h = 0 ; h < TEXINFO_HASH_SIZE ; h++)
	{
		delete texinfo_hashtab[h];
		texinfo_hashtab[h] = NULL;
	}
}


u16_t Q1_AddTexInfo(const char *texture, int flags, float *s4, float *t4)
{
	if (! texture[0])
		texture = "error";

	int miptex = Q1_AddMipTex(texture);

	// create texinfo structure, fix endianness
	texinfo_t raw_tex;

	for (int k = 0 ; k < 4 ; k++)
	{
		raw_tex.s[k] = LE_Float32(s4[k]);
		raw_tex.t[k] = LE_Float32(t4[k]);
	}

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

	lump->Append(&q1_texinfos[0], q1_texinfos.size() * sizeof(texinfo_t));
}


#if 0  /* TEMP STUFF */
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
//   BSP TREE OUTPUT
//------------------------------------------------------------------------

static qLump_c *q1_surf_edges;
static qLump_c *q1_mark_surfs;

static qLump_c *q1_faces;
static qLump_c *q1_leafs;
static qLump_c *q1_nodes;

static qLump_c *q1_models;

static int q1_total_surf_edges;
static int q1_total_mark_surfs;

static int q1_total_faces;
static int q1_total_leafs;
static int q1_total_nodes;

qLump_c *q1_clip;

int q1_total_clip;


static int q1_medium_table[5] =
{
	CONTENTS_EMPTY,
	CONTENTS_WATER,
	CONTENTS_SLIME,
	CONTENTS_LAVA,
	CONTENTS_SOLID
};

static byte q1_ambient_levels[4][8] =
{
	{ 255, 208, 176, 144, 112, 80, 48, 16 },  // Water
	{ 255, 160, 128,  96,  64, 32,  0,  0 },  // Sky
	{ 255, 208, 176, 144, 112, 80, 48, 16 },  // Slime (unused)
	{ 255, 208, 176, 144, 112, 80, 48, 16 },  // Lava
};


static void Q1_FreeStuff()
{
	Q1_ClearMipTex();
	Q1_ClearTexInfo();

	delete qk_world_model;
	qk_world_model = NULL;

	// lumps are handled (freed) in q_common code
	q1_surf_edges = NULL;
	q1_mark_surfs = NULL;

	q1_faces = NULL;
	q1_leafs = NULL;
	q1_nodes = NULL;

	q1_models = NULL;
	q1_clip   = NULL;
}


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


	// lighting and texture...

	raw_face.lightofs = -1;

	memset(raw_face.styles, 255, 4);

	if (face->lmap)
	{
		raw_face.lightofs = face->lmap->CalcOffset();

		for (int n = 0 ; n < 4 ; n++)
			raw_face.styles[n] = face->lmap->styles[n];
	}


	const char *texture = face->texture.c_str();

	int flags = 0;

	if ((face->flags & (FACE_F_Sky | FACE_F_Liquid)) ||
			texture[0] == '*' || raw_face.lightofs < 0)
	{
		flags |= TEX_SPECIAL;
	}

	raw_face.texinfo = Q1_AddTexInfo(texture, flags, face->s, face->t);


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
	SYS_ASSERT(leaf->medium >= 0);
	SYS_ASSERT(leaf->medium <= MEDIUM_SOLID);

	if (leaf == qk_solid_leaf)
		return;


	dleaf_t raw_leaf;

	memset(&raw_leaf, 0, sizeof(raw_leaf));

	raw_leaf.contents = q1_medium_table[leaf->medium];


	// visibility and ambient sounds come from the cluster
	raw_leaf.visofs = -1;

	if (leaf->cluster)
	{
		raw_leaf.visofs = leaf->cluster->visofs;

		for (int k = 0 ; k < 4 ; k++)
		{
			int dist = leaf->cluster->ambient_dists[k];

			raw_leaf.ambient_level[k] = (dist < 8) ? q1_ambient_levels[k][dist] : 0;
		}
	}


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
		raw_node.children[0] = (u16_t) (-1 - node->front_L->index);

	if (node->back_N)
		raw_node.children[1] = (u16_t) node->back_N->index;
	else
		raw_node.children[1] = (u16_t) (-1 - node->back_L->index);

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


//------------------------------------------------------------------------
//   MAP MODEL STUFF
//------------------------------------------------------------------------

#define H2_MAX_HULLS  8

typedef struct
{
	float mins[3], maxs[3];
	float origin[3];

	s32_t headnode[H2_MAX_HULLS];

	s32_t numleafs;
	s32_t firstface, numfaces;
}
h2_dmodel_t;


static void H2_WriteModel(quake_mapmodel_c *model)
{
	h2_dmodel_t raw_model;

	memset(&raw_model, 0, sizeof(raw_model));

	raw_model.mins[0] = LE_Float32(model->x1 - MODEL_PADDING);
	raw_model.mins[1] = LE_Float32(model->y1 - MODEL_PADDING);
	raw_model.mins[2] = LE_Float32(model->z1 - MODEL_PADDING);

	raw_model.maxs[0] = LE_Float32(model->x2 + MODEL_PADDING);
	raw_model.maxs[1] = LE_Float32(model->y2 + MODEL_PADDING);
	raw_model.maxs[2] = LE_Float32(model->z2 + MODEL_PADDING);

	// origin stays zero

	for (int n = 0 ; n < 6 ; n++)
	{
		raw_model.headnode[n] = LE_S32(model->nodes[n]);
	}

	raw_model.numleafs  = LE_S32(model->numleafs);
	raw_model.firstface = LE_S32(model->firstface);
	raw_model.numfaces  = LE_S32(model->numfaces);

	q1_models->Append(&raw_model, sizeof(raw_model));
}


static void Q1_WriteModel(quake_mapmodel_c *model)
{
	if (qk_sub_format == SUBFMT_Hexen2)
	{
		H2_WriteModel(model);
		return;
	}

	dmodel_t raw_model;

	memset(&raw_model, 0, sizeof(raw_model));

	raw_model.mins[0] = LE_Float32(model->x1 - MODEL_PADDING);
	raw_model.mins[1] = LE_Float32(model->y1 - MODEL_PADDING);
	raw_model.mins[2] = LE_Float32(model->z1 - MODEL_PADDING);

	raw_model.maxs[0] = LE_Float32(model->x2 + MODEL_PADDING);
	raw_model.maxs[1] = LE_Float32(model->y2 + MODEL_PADDING);
	raw_model.maxs[2] = LE_Float32(model->z2 + MODEL_PADDING);

	// raw_model.origin stays zero

	for (int n = 0 ; n < 4 ; n++)
	{
		raw_model.headnode[n] = LE_S32(model->nodes[n]);
	}

	raw_model.numleafs  = LE_S32(model->numleafs);
	raw_model.firstface = LE_S32(model->firstface);
	raw_model.numfaces  = LE_S32(model->numfaces);

	q1_models->Append(&raw_model, sizeof(raw_model));
}


static void MapModel_Edge(float x1, float y1, float z1,
                          float x2, float y2, float z2)
{
	quake_vertex_c A(x1, y1, z1);
	quake_vertex_c B(x2, y2, z2);

	Q1_WriteEdge(A, B);
}


static void MapModel_TexCoord(float *scale, float *offset,
                              double low, double high,
                              csg_property_set_c & face,
                              const char *l_field, const char *h_field,
                              bool invert)
{
	*scale  = 1;
	*offset = 0;

	if (face.getStr(l_field))
	{
		double u1 = face.getDouble(l_field);

		if (face.getStr(h_field))
		{
			double u2 = face.getDouble(h_field);

			*scale = (u2 - u1) / (high - low);
		}

		*offset = u1 - low * (*scale);
	}

	if (invert)
	{
		*scale  *= -1;
		*offset *= -1;
	}
}


static void MapModel_Face(quake_mapmodel_c *model, int face, s16_t plane, bool flipped)
{
	dface_t raw_face;

	raw_face.planenum = plane;
	raw_face.side = flipped ? 1 : 0;


	const char *texture = "error";

	float s[4] = { 0.0, 0.0, 0.0, 0.0 };
	float t[4] = { 0.0, 0.0, 0.0, 0.0 };


	// add the edges

	raw_face.firstedge = q1_total_surf_edges;
	raw_face.numedges  = 4;

	if (face < 2)  // PLANE_X
	{
		texture = model->x_face.getStr("tex", "missing");

		double x = (face==0) ? model->x1 : model->x2;
		double y1 = flipped  ? model->y2 : model->y1;
		double y2 = flipped  ? model->y1 : model->y2;

		// Note: this assumes the plane is positive
		MapModel_Edge(x, y1, model->z1, x, y1, model->z2);
		MapModel_Edge(x, y1, model->z2, x, y2, model->z2);
		MapModel_Edge(x, y2, model->z2, x, y2, model->z1);
		MapModel_Edge(x, y2, model->z1, x, y1, model->z1);

		MapModel_TexCoord(s+1, s+3, model->y1, model->y2, model->x_face, "u1", "u2", false);
		MapModel_TexCoord(t+2, t+3, model->z1, model->z2, model->x_face, "v1", "v2", true);
	}
	else if (face < 4)  // PLANE_Y
	{
		texture = model->y_face.getStr("tex", "missing");

		double y = (face==2) ? model->y1 : model->y2;
		double x1 = flipped  ? model->x1 : model->x2;
		double x2 = flipped  ? model->x2 : model->x1;

		MapModel_Edge(x1, y, model->z1, x1, y, model->z2);
		MapModel_Edge(x1, y, model->z2, x2, y, model->z2);
		MapModel_Edge(x2, y, model->z2, x2, y, model->z1);
		MapModel_Edge(x2, y, model->z1, x1, y, model->z1);

		MapModel_TexCoord(s+0, s+3, model->x1, model->x2, model->y_face, "u1", "u2", false);
		MapModel_TexCoord(t+2, t+3, model->z1, model->z2, model->y_face, "v1", "v2", true);
	}
	else  // PLANE_Z
	{
		texture = model->z_face.getStr("tex", "missing");

		double z = (face==5) ? model->z1 : model->z2;
		double x1 = flipped  ? model->x2 : model->x1;
		double x2 = flipped  ? model->x1 : model->x2;

		MapModel_Edge(x1, model->y1, z, x1, model->y2, z);
		MapModel_Edge(x1, model->y2, z, x2, model->y2, z);
		MapModel_Edge(x2, model->y2, z, x2, model->y1, z);
		MapModel_Edge(x2, model->y1, z, x1, model->y1, z);

		MapModel_TexCoord(s+0, s+3, model->x1, model->x2, model->z_face, "u1", "u2", false);
		MapModel_TexCoord(t+1, t+3, model->y1, model->y2, model->z_face, "v1", "v2", false);
	}


	// texture and lighting

	int flags = 0;

	if (strstr(texture, "trigger") != NULL)
		flags |= TEX_SPECIAL;

	raw_face.texinfo = Q1_AddTexInfo(texture, flags, s, t);

	raw_face.styles[0] = 0;
	raw_face.styles[1] = 0xFF;
	raw_face.styles[2] = 0xFF;
	raw_face.styles[3] = 0xFF;

	raw_face.lightofs = QCOM_FlatLightOffset(MODEL_LIGHT);


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


static void Q1_ClipModels()
{
	qk_world_model = new quake_mapmodel_c();

	qk_world_model->firstface = 0;
	qk_world_model->numfaces  = q1_total_faces;
	qk_world_model->numleafs  = q1_total_leafs;

	// bounds of map
	qk_world_model->x1 = qk_bsp_root->bbox.mins[0];
	qk_world_model->y1 = qk_bsp_root->bbox.mins[1];
	qk_world_model->y1 = qk_bsp_root->bbox.mins[2];

	qk_world_model->x2 = qk_bsp_root->bbox.maxs[0];
	qk_world_model->y2 = qk_bsp_root->bbox.maxs[1];
	qk_world_model->y2 = qk_bsp_root->bbox.maxs[2];

	q1_clip = BSP_NewLump(LUMP_CLIPNODES);
	q1_total_clip = 0;

	for (int hull = 1 ; hull < 6 ; hull++)
	{
		Q1_ClippingHull(hull);
	}
}


static void Q1_WriteModels()
{
	q1_models = BSP_NewLump(LUMP_MODELS);

	Q1_WriteModel(qk_world_model);

	for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
	{
		quake_mapmodel_c *model = qk_all_mapmodels[i];

		model->firstface = q1_total_faces;
		model->numfaces  = 6;
		model->numleafs  = 6;

		float mins[3], maxs[3];

		mins[0] = model->x1;
		mins[1] = model->y1;
		mins[2] = model->z1;

		maxs[0] = model->x2;
		maxs[1] = model->y2;
		maxs[2] = model->z2;

		MapModel_Nodes(model, mins, maxs);

		Q1_WriteModel(model);
	}
}


//------------------------------------------------------------------------

static void Q1_LightWorld()
{
	if (main_win)
		main_win->build_box->Prog_Step("Light");

	QCOM_LightAllFaces();

	int max_size = MAX_MAP_LIGHTING;

	if (qk_sub_format == SUBFMT_HalfLife)
		max_size = HL_MAX_MAP_LIGHTING;

	QCOM_BuildLightingLump(LUMP_LIGHTING, max_size);
}


static void Q1_VisWorld(int base_leafs)
{
	if (main_win)
		main_win->build_box->Prog_Step("Vis");

	// take the solid leaf into account
	int numleafs = 1 + base_leafs;

	// add in the map models
	for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
	{
		numleafs += 6; ///TODO  qk_all_mapmodels->PredictLeafs();
	}

	QCOM_Visibility(LUMP_VISIBILITY, MAX_MAP_VISIBILITY, numleafs);
}


static void Q1_CreateBSPFile(const char *name)
{
	qk_color_lighting = false;

	if (qk_sub_format == SUBFMT_HalfLife)
		qk_color_lighting = true;

	BSP_OpenLevel(name);

	CSG_QUAKE_Build();

	int num_node = 0;
	int num_leaf = 0;

	CSG_AssignIndexes(qk_bsp_root, &num_node, &num_leaf);

	QCOM_Fix_T_Junctions();

	Q1_VisWorld(num_leaf);
	Q1_LightWorld();

	Q1_WriteBSP();

	Q1_ClipModels();
	Q1_WriteModels();

	BSP_WritePlanes  (LUMP_PLANES,   MAX_MAP_PLANES);
	BSP_WriteVertices(LUMP_VERTEXES, MAX_MAP_VERTS );
	BSP_WriteEdges   (LUMP_EDGES,    MAX_MAP_EDGES );

	Q1_WriteMipTex();
	Q1_WriteTexInfo();

	BSP_WriteEntities(LUMP_ENTITIES, description);

	// this will free lots of stuff (lightmaps etc)
	BSP_CloseLevel();

	CSG_QUAKE_Free();

	Q1_FreeStuff();
}


//------------------------------------------------------------------------

int Q1_add_tex_wad(lua_State *L)
{
	// LUA: q1_add_tex_wad(filename)
	//
	// Note: filename must be relative (no path)

	const char *name = luaL_checkstring(L, 1);

	// TODO: support more than one

	if (qk_texture_wad)
		StringFree(qk_texture_wad);

	qk_texture_wad = StringDup(name);

	return 1;
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

private:
	const char *StepsForGame(int sub)
	{
		switch (sub)
		{
		case SUBFMT_HalfLife:
			return "CSG,BSP,Vis,Light,Hull 1,Hull 2,Hull 3";

		case SUBFMT_Hexen2:
			return "CSG,BSP,Vis,Light,Hull 1,Hull 2,Hull 3,Hull 4,Hull 5";

		default:
			return "CSG,BSP,Vis,Light,Hull 1,Hull 2";
		}
	}
};


bool quake1_game_interface_c::Start()
{
	qk_game = 1;
	qk_sub_format = 0;
	qk_lighting_quality = fast_lighting ? -1 : +1;

	if (batch_mode)
		filename = StringDup(batch_output_file);
	else
		filename = DLG_OutputFilename("pak");

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
		main_win->build_box->Prog_Init(0, StepsForGame(0));

	return true;
}


bool quake1_game_interface_c::Finish(bool build_ok)
{
	PAK_CloseWrite();

	// remove the file if an error occurred
	if (! build_ok)
		FileDelete(filename);
	else
		Recent_AddFile(RECG_Output, filename);

	return build_ok;
}


void quake1_game_interface_c::BeginLevel()
{
	level_name  = NULL;
	description = NULL;
	qk_texture_wad = NULL;

	Q1_FreeStuff();

	CSG_QUAKE_Free();
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
			LogPrintf("WARNING: unknown QUAKE1 sub_format '%s'\n", value);

		// this assumes the sub_format is only set once at the start
		if (main_win)
			main_win->build_box->Prog_Init(0, StepsForGame(qk_sub_format));
	}
	else if (StringCaseCmp(key, "lighting_quality") == 0)
	{
		if (StringCaseCmp(value, "low") == 0)
			qk_lighting_quality = -1;
		else if (StringCaseCmp(value, "high") == 0)
			qk_lighting_quality = +1;
		else
			qk_lighting_quality = 0;
	}
	else if (StringCaseCmp(key, "worldtype") == 0)
	{
		qk_worldtype = atoi(value);
	}
	else
	{
		LogPrintf("WARNING: unknown QUAKE1 property: %s=%s\n", key, value);
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

	if (qk_texture_wad)
		StringFree(qk_texture_wad);
}


game_interface_c * Quake1_GameObject(void)
{
	return new quake1_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
