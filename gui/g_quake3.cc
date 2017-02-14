//------------------------------------------------------------------------
//  LEVEL building - QUAKE III format
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
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

#include "headers.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"

#include "lib_file.h"
#include "lib_util.h"
#include "lib_pak.h"
#include "lib_zip.h"

#include "main.h"
#include "m_cookie.h"

#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"
#include "q3_structs.h"

#include "csg_main.h"
#include "csg_quake.h"


#define LEAF_PADDING   4
#define NODE_PADDING   16
#define MODEL_PADDING  1.0

#define MODEL_LIGHT  64


static char *level_name;
static char *description;



//------------------------------------------------------------------------

static std::vector<dbrush3_t>     q3_brushes;
static std::vector<dbrushside3_t> q3_brush_sides;

static std::map<const csg_brush_c *, u16_t> brush_map;


static void Q3_ClearBrushes()
{
	q3_brushes.clear();
	q3_brush_sides.clear();

	brush_map.clear();
}


static void DoWriteBrushSide(int plane, int shader)
{
	dbrushside3_t side;

	side.planeNum  = LE_S32(plane);
	side.shaderNum = LE_S32(shader);

	q3_brush_sides.push_back(side);
}


static void DoWriteBrush(dbrush3_t & raw_brush)
{
	raw_brush.firstSide = LE_S32(raw_brush.firstSide);
	raw_brush.numSides  = LE_S32(raw_brush.numSides);

	raw_brush.shaderNum = LE_U32(raw_brush.shaderNum);

	q3_brushes.push_back(raw_brush);
}


static u16_t Q3_AddBrush(const csg_brush_c *A)
{
	// find existing brush
	if (brush_map.find(A) != brush_map.end())
	{
		return brush_map[A];
	}


	dbrush3_t raw_brush;

	raw_brush.firstSide = (int)q3_brush_sides.size();
	raw_brush.numSides  = 2;

	raw_brush.shaderNum = 1;  // FIXME !!!!


	int plane;


	// top
	plane = BSP_AddPlane(0, 0, A->t.z,  0, 0, +1);

	DoWriteBrushSide(plane, raw_brush.shaderNum);


	// bottom
	plane = BSP_AddPlane(0, 0, A->b.z,  0, 0, -1);

	DoWriteBrushSide(plane ^ 1, raw_brush.shaderNum);


	for (unsigned int k = 0 ; k < A->verts.size() ; k++)
	{
		bool flipped;

		brush_vert_c *v1 = A->verts[k];
		brush_vert_c *v2 = A->verts[(k+1) % A->verts.size()];

		plane = BSP_AddPlane(v1->x, v1->y, 0,
				(v2->y - v1->y), (v1->x - v2->x), 0,
				&flipped);

		if (flipped)
			plane ^= 1;

		DoWriteBrushSide(plane, raw_brush.shaderNum);

		raw_brush.numSides++;
	}


	u16_t index = q3_brushes.size();

	brush_map[A] = index;

	DoWriteBrush(raw_brush);

	return (u16_t) index;
}


static void Q3_WriteBrushes()
{
	qLump_c *lump  = BSP_NewLump(LUMP_BRUSHES);

	// FIXME: write separately, fix endianness as we go

	lump->Append(&q3_brushes[0], q3_brushes.size() * sizeof(dbrush3_t));

	qLump_c *sides = BSP_NewLump(LUMP_BRUSHSIDES);

	sides->Append(&q3_brush_sides[0], q3_brush_sides.size() * sizeof(dbrushside3_t));
}


//------------------------------------------------------------------------

static std::vector<dshader3_t> q3_shaders;

#define NUM_SHADER_HASH  128
static std::vector<int> * shader_hashtab[NUM_SHADER_HASH];


static void Q3_ClearShaders(void)
{
	q3_shaders.clear();

	for (int h = 0 ; h < NUM_SHADER_HASH ; h++)
	{
		delete shader_hashtab[h];
		shader_hashtab[h] = NULL;
	}
}


u16_t Q3_AddShader(const char *texture, int flags, int contents)
{
	if (! texture[0])
		texture = "error";

	// create shader structure, fix endianness
	dshader3_t raw_tex;

	memset(&raw_tex, 0, sizeof(raw_tex));

	if (strlen(texture)+1 >= sizeof(raw_tex.shader))
		Main_FatalError("Quake3 texture name too long: '%s'\n", texture);

	strcpy(raw_tex.shader, texture);

	raw_tex.surfaceFlags = LE_S32(flags);
	raw_tex.contentFlags = LE_S32(contents);


	// find an existing shader in the hash table
	int hash = (int)StringHash(texture) & (NUM_SHADER_HASH-1);

	SYS_ASSERT(hash >= 0);

	if (! shader_hashtab[hash])
		shader_hashtab[hash] = new std::vector<int>;

	std::vector<int> * hashtab = shader_hashtab[hash];

	for (unsigned int i = 0 ; i < hashtab->size() ; i++)
	{
		int index = (*hashtab)[i];

		SYS_ASSERT(index < (int)q3_shaders.size());

		if (memcmp(&raw_tex, &q3_shaders[index], sizeof(raw_tex)) == 0)
			return index;  // found it
	}


	// not found, so add new one
	u16_t new_index = q3_shaders.size();

	q3_shaders.push_back(raw_tex);

	hashtab->push_back(new_index);

	return new_index;
}


static void Q3_WriteShaders()
{
	if (q3_shaders.size() >= MAX_MAP_SHADERS)
		Main_FatalError("Quake3 build failure: exceeded limit of %d SHADERS\n",
				MAX_MAP_SHADERS);

	qLump_c *lump = BSP_NewLump(LUMP_SHADERS);

	lump->Append(&q3_shaders[0], q3_shaders.size() * sizeof(dshader3_t));
}


static void Q3_WriteFogs()
{
	BSP_NewLump(LUMP_FOGS);
}


//------------------------------------------------------------------------

#if 0
static void Q3_DummyVis()
{
	qLump_c *lump = BSP_NewLump(LUMP_VISIBILITY);

	dvis_t vis;

	vis.numclusters = LE_U32(1);

	vis.offsets[0][0] = LE_U32(sizeof(vis));
	vis.offsets[0][1] = LE_U32(sizeof(vis));

	lump->Append(&vis, sizeof(vis));

	byte dummy_v = 255;

	lump->Append(&dummy_v, 1);
	lump->Append(&dummy_v, 1);
	lump->Append(&dummy_v, 1);
	lump->Append(&dummy_v, 1);
}
#endif


#if 0
static void Q3_DummyLeafBrush()
{
	qLump_c *lump = BSP_NewLump(LUMP_LEAFBRUSHES);

	dbrush_t brush;

	brush.firstSide = 0;
	brush.numSides  = 0;

	brush.contents  = 0;

	lump->Append(&brush, sizeof(brush));
}
#endif


const byte oblige_pop[256] =
{
  175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175,
  175, 175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175,  62,  59,  58,  57, 221, 221,  59,  62, 175, 175, 175, 175,
  175, 175,  63,  59,  57,  57,  57, 221, 221,  57,  57,  57,  59,  63, 175, 175,
  175, 172,  58,  57,  57,  57,  57, 221, 221,  57,  57,  57,  57,  58, 172, 175,
  175,  59,  57,  57,  57,  61, 221, 221, 174,  63,  61,  57,  57,  57,  59, 175,
  175,  57,  57,  57, 171, 175, 221, 221, 221, 221, 221, 221,  57,  57,  57, 175,
  175,  57,  57,  57, 171, 221, 221, 221, 221, 221, 221, 171,  57,  57,  57, 175,
  175,  59,  57,  57,  57,  61,  63, 175, 174, 221, 221,  57,  57,  57,  59, 175,
  175, 172,  58,  57,  57,  57,  57,  57,  57,  57,  57,  57,  57,  58, 172, 175,
  175, 175,  63,  59,  57,  57,  57,  57,  57,  57,  57,  57,  59,  63, 175, 175,
  175, 175, 175, 175,  62,  59,  58,  57,  57,  58,  59,  62, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175, 175,
  175, 175, 175, 175, 175, 175, 175, 221, 175, 175, 175, 175, 175, 175, 175, 175
};


//------------------------------------------------------------------------

static qLump_c *q3_mark_surfs;  // LUMP_LEAFSURFACES
static qLump_c *q3_leaf_brushes;

static qLump_c *q3_surfaces;
static qLump_c *q3_leafs;
static qLump_c *q3_nodes;

static qLump_c *q3_models;

static int q3_total_mark_surfs;
static int q3_total_leaf_brushes;

static int q3_total_surfaces;
static int q3_total_leafs;
static int q3_total_nodes;


static void Q3_FreeStuff()
{
	Q3_ClearBrushes();
	Q3_ClearShaders();

	delete qk_world_model;
	qk_world_model = NULL;

	// bsp lumps are freed in q_common code

	q3_mark_surfs = NULL;
	q3_leaf_brushes = NULL;

	q3_surfaces = NULL;
	q3_leafs = NULL;
	q3_nodes = NULL;
	q3_models = NULL;
}



static void Q3_WriteLeafBrush(csg_brush_c *B)
{
	u16_t index = Q3_AddBrush(B);

	// fix endianness
	index = LE_U16(index);

	q3_leaf_brushes->Append(&index, sizeof(index));

	q3_total_leaf_brushes += 1;
}


static inline void DoWriteSurface(dsurface3_t & raw_surf)
{
	// fix endianness
	raw_surf.shaderNum   = LE_S32(raw_surf.shaderNum);
	raw_surf.fogNum      = LE_S32(raw_surf.fogNum);
	raw_surf.surfaceType = LE_S32(raw_surf.surfaceType);

	raw_surf.firstVert   = LE_S32(raw_surf.firstVert);
	raw_surf.numVerts    = LE_S32(raw_surf.numVerts);

	raw_surf.firstIndex  = LE_S32(raw_surf.firstIndex);
	raw_surf.numIndexes  = LE_S32(raw_surf.numIndexes);

	raw_surf.lightmapNum    = LE_S32(raw_surf.lightmapNum);
	raw_surf.lightmapX      = LE_S32(raw_surf.lightmapX);
	raw_surf.lightmapY      = LE_S32(raw_surf.lightmapY);
	raw_surf.lightmapWidth  = LE_S32(raw_surf.lightmapWidth);
	raw_surf.lightmapHeight = LE_S32(raw_surf.lightmapHeight);

	raw_surf.patchWidth  = LE_S32(raw_surf.patchWidth);
	raw_surf.patchHeight = LE_S32(raw_surf.patchHeight);

	q3_surfaces->Append(&raw_surf, sizeof(raw_surf));

	q3_total_surfaces += 1;
}


static void Q3_WriteSurface(quake_face_c *face)
{
	SYS_ASSERT(face->node);
	SYS_ASSERT(face->node_side >= 0);

	face->index = q3_total_surfaces;


	dsurface3_t raw_surf;

	memset(&raw_surf, 0, sizeof(raw_surf));

	raw_surf.fogNum = -1;


//??	bool flipped;

//??	raw_surf.planeNum = BSP_AddPlane(&face->node->plane, &flipped);

#if 0
	raw_surf.side = face->node_side ^ (flipped ? 1 : 0);


	unsigned int total_v = face->verts.size();

	for (unsigned int i = 0 ; i < total_v ; i++)
	{
		Q3_WriteEdge(face->verts[i], face->verts[(i+1) % total_v]);
	}
#endif


	// lighting and texture...

	if (face->lmap)
	{
		// FIXME : lightmap on surface

		///--- raw_surf.lightofs = face->lmap->CalcOffset();

		raw_surf.lightmapNum = -1;  /* NONE! */

		raw_surf.lightmapX = 0;
		raw_surf.lightmapY = 0;
		raw_surf.lightmapWidth  = 2;
		raw_surf.lightmapHeight = 2;
	}


	const char *texture = face->texture.c_str();

	int flags = 0;

/* FIXME
	if (face->flags & FACE_F_Sky)
		flags |= SURF_SKY;
	if (face->flags & FACE_F_Liquid)
		flags |= SURF_WARP | SURF_TRANS66;
*/

	int contents = 0;  // FIXME !!

	raw_surf.shaderNum = Q3_AddShader(texture, flags, contents);

	DoWriteSurface(raw_surf);
}


static void Q3_WriteMarkSurf(int index)
{
	SYS_ASSERT(index >= 0);

	// fix endianness
	u16_t raw_index = LE_U16(index);

	q3_mark_surfs->Append(&raw_index, sizeof(raw_index));

	q3_total_mark_surfs += 1;
}


static void DoWriteLeaf(dleaf3_t & raw_leaf)
{
	// fix endianness
	raw_leaf.cluster  = LE_S32(raw_leaf.cluster);
	raw_leaf.area     = LE_S32(raw_leaf.area);

	raw_leaf.firstLeafSurface  = LE_S32(raw_leaf.firstLeafSurface);
	raw_leaf.numLeafSurfaces   = LE_S32(raw_leaf.numLeafSurfaces);

	raw_leaf.firstLeafBrush    = LE_S32(raw_leaf.firstLeafBrush);
	raw_leaf.numLeafBrushes    = LE_S32(raw_leaf.numLeafBrushes);

	for (int b = 0 ; b < 3 ; b++)
	{
		raw_leaf.mins[b] = LE_Float32(raw_leaf.mins[b]);
		raw_leaf.maxs[b] = LE_Float32(raw_leaf.maxs[b]);
	}

	q3_leafs->Append(&raw_leaf, sizeof(raw_leaf));

	q3_total_leafs += 1;
}


static void Q3_WriteLeaf(quake_leaf_c *leaf)
{
	SYS_ASSERT(leaf->medium >= 0);
	SYS_ASSERT(leaf->medium <= MEDIUM_SOLID);

	if (leaf == qk_solid_leaf)
		return;


	dleaf3_t raw_leaf;

	memset(&raw_leaf, 0, sizeof(raw_leaf));

	raw_leaf.area = 0;

	if (leaf->medium == MEDIUM_SOLID)
	{
		raw_leaf.cluster = -1;
	}
	else
	{
		raw_leaf.cluster = leaf->cluster ? leaf->cluster->CalcID() : 0;
	}

	// create the 'mark surfs'
	raw_leaf.firstLeafSurface = q3_total_mark_surfs;
	raw_leaf.numLeafSurfaces  = 0;

	for (unsigned int i = 0 ; i < leaf->faces.size() ; i++)
	{
//!!!		Q3_WriteMarkSurf(leaf->faces[i]->index);

		raw_leaf.numLeafSurfaces += 1;
	}

	raw_leaf.firstLeafBrush = q3_total_leaf_brushes;
	raw_leaf.numLeafBrushes = 0;

	for (unsigned int k = 0 ; k < leaf->solids.size() ; k++)
	{
//!!!		Q3_WriteLeafBrush(leaf->solids[k]);

		raw_leaf.numLeafBrushes += 1;
	}

	for (int b = 0 ; b < 3 ; b++)
	{
		raw_leaf.mins[b] = leaf->bbox.mins[b] - LEAF_PADDING;
		raw_leaf.maxs[b] = leaf->bbox.maxs[b] + LEAF_PADDING;
	}

	DoWriteLeaf(raw_leaf);
}


static void Q3_WriteSolidLeaf(void)
{
	dleaf3_t raw_leaf;

	memset(&raw_leaf, 0, sizeof(raw_leaf));

	raw_leaf.cluster = LE_S32(-1);

	q3_leafs->Append(&raw_leaf, sizeof(raw_leaf));
}


static void DoWriteNode(dnode3_t & raw_node)
{
	// fix endianness
	raw_node.planeNum    = LE_S32(raw_node.planeNum);
	raw_node.children[0] = LE_S32(raw_node.children[0]);
	raw_node.children[1] = LE_S32(raw_node.children[1]);

	for (int b = 0 ; b < 3 ; b++)
	{
		raw_node.mins[b] = LE_S32(raw_node.mins[b]);
		raw_node.maxs[b] = LE_S32(raw_node.maxs[b]);
	}

	q3_nodes->Append(&raw_node, sizeof(raw_node));

	q3_total_nodes += 1;
}


static void Q3_WriteNode(quake_node_c *node)
{
	dnode3_t raw_node;

	bool flipped;

	raw_node.planeNum = BSP_AddPlane(&node->plane, &flipped);


	if (node->front_N)
		raw_node.children[0] = node->front_N->index;
	else
		raw_node.children[0] = (-1 - node->front_L->index);

	if (node->back_N)
		raw_node.children[1] = node->back_N->index;
	else
		raw_node.children[1] = (-1 - node->back_L->index);

	if (flipped)
	{
		std::swap(raw_node.children[0], raw_node.children[1]);
	}


	// FIXME : this is quite different in Q3
#if 0
	raw_node.firstface = q3_total_surfaces;
	raw_node.numfaces  = node->faces.size();

	if (raw_node.numfaces > 0)
	{
		for (unsigned int k = 0 ; k < node->faces.size() ; k++)
		{
			Q3_WriteSurface(node->faces[k]);
		}
	}
#endif


	for (int b = 0 ; b < 3 ; b++)
	{
		raw_node.mins[b] = (int)floor(node->bbox.mins[b] - NODE_PADDING);
		raw_node.maxs[b] = (int) ceil(node->bbox.maxs[b] + NODE_PADDING);
	}


	DoWriteNode(raw_node);


	// recurse now, AFTER adding the current node

	if (node->front_N)
		Q3_WriteNode(node->front_N);
	else
		Q3_WriteLeaf(node->front_L);

	if (node->back_N)
		Q3_WriteNode(node->back_N);
	else
		Q3_WriteLeaf(node->back_L);
}


static void Q3_WriteBSP()
{
	q3_total_nodes = 0;
	q3_total_leafs = 0;  // not including the solid leaf
	q3_total_surfaces = 0;

	q3_total_mark_surfs = 0;
	q3_total_leaf_brushes = 0;

	q3_nodes = BSP_NewLump(LUMP_NODES);
	q3_leafs = BSP_NewLump(LUMP_LEAFS);
	q3_surfaces = BSP_NewLump(LUMP_SURFACES);

	q3_mark_surfs   = BSP_NewLump(LUMP_LEAFSURFACES);
	q3_leaf_brushes = BSP_NewLump(LUMP_LEAFBRUSHES);


	// FIXME : need this??
	Q3_WriteSolidLeaf();

	Q3_WriteNode(qk_bsp_root);  


	if (q3_total_surfaces >= MAX_MAP_DRAW_SURFS)
		Main_FatalError("Quake3 build failure: exceeded limit of %d DRAW_SURFS\n", MAX_MAP_DRAW_SURFS);

	if (q3_total_leafs >= MAX_MAP_LEAFS)
		Main_FatalError("Quake3 build failure: exceeded limit of %d LEAFS\n", MAX_MAP_LEAFS);

	if (q3_total_nodes >= MAX_MAP_NODES)
		Main_FatalError("Quake3 build failure: exceeded limit of %d NODES\n", MAX_MAP_NODES);
}


//------------------------------------------------------------------------
//   MAP MODEL STUFF
//------------------------------------------------------------------------

#if 0  // FIXME !!

static void Q3_Model_Edge(float x1, float y1, float z1,
                          float x2, float y2, float z2)
{
	quake_vertex_c A(x1, y1, z1);
	quake_vertex_c B(x2, y2, z2);

	Q3_WriteEdge(A, B);
}


static void Q3_Model_Face(quake_mapmodel_c *model, int face, s16_t plane, bool flipped)
{
	dsurface3_t raw_surf;

//??	raw_surf.planeNum = plane;

	raw_surf.side = flipped ? 1 : 0;


	const char *texture = "error";

	float s[4] = { 0.0, 0.0, 0.0, 0.0 };
	float t[4] = { 0.0, 0.0, 0.0, 0.0 };


	// add the edges

	raw_surf.firstedge = q3_total_surf_edges;
	raw_surf.numedges  = 4;

	if (face < 2)  // PLANE_X
	{
		s[1] =  1;  // PLANE_X
		t[2] = -1;

		texture = model->x_face.getStr("tex", "missing");

		double x = (face==0) ? model->x1 : model->x2;
		double y1 = flipped  ? model->y2 : model->y1;
		double y2 = flipped  ? model->y1 : model->y2;

		// Note: this assumes the plane is positive
		Q3_Model_Edge(x, y1, model->z1, x, y1, model->z2);
		Q3_Model_Edge(x, y1, model->z2, x, y2, model->z2);
		Q3_Model_Edge(x, y2, model->z2, x, y2, model->z1);
		Q3_Model_Edge(x, y2, model->z1, x, y1, model->z1);
	}
	else if (face < 4)
	{
		s[0] =  1;  // PLANE_Y
		t[2] = -1;

		texture = model->y_face.getStr("tex", "missing");

		double y = (face==2) ? model->y1 : model->y2;
		double x1 = flipped  ? model->x1 : model->x2;
		double x2 = flipped  ? model->x2 : model->x1;

		Q3_Model_Edge(x1, y, model->z1, x1, y, model->z2);
		Q3_Model_Edge(x1, y, model->z2, x2, y, model->z2);
		Q3_Model_Edge(x2, y, model->z2, x2, y, model->z1);
		Q3_Model_Edge(x2, y, model->z1, x1, y, model->z1);
	}
	else
	{
		s[0] = 1;  // PLANE_Z
		t[1] = 1;

		texture = model->z_face.getStr("tex", "missing");

		double z = (face==5) ? model->z1 : model->z2;
		double x1 = flipped  ? model->x2 : model->x1;
		double x2 = flipped  ? model->x1 : model->x2;

		Q3_Model_Edge(x1, model->y1, z, x1, model->y2, z);
		Q3_Model_Edge(x1, model->y2, z, x2, model->y2, z);
		Q3_Model_Edge(x2, model->y2, z, x2, model->y1, z);
		Q3_Model_Edge(x2, model->y1, z, x1, model->y1, z);
	}



	// texture and lighting

	int flags = 0;

#if 0
	// using SURF_WARP to disable the check on extents
	// (trigger models are never rendered anyway)

	if (strstr(texture, "trigger") != NULL)
		flags |= SURF_NODRAW | SURF_WARP;
#endif
	int contents = 0;  // FIXME

	raw_surf.shaderNum = Q3_AddShader(texture, flags, contents);

///!!!	raw_surf.lightofs = QCOM_FlatLightOffset(MODEL_LIGHT);


	DoWriteBrushSide(raw_surf.planenum ^ raw_surf.side, raw_surf.texinfo);

	DoWriteSurface(raw_surf);
}


static void Q3_Model_Nodes(quake_mapmodel_c *model, float *mins, float *maxs)
{
	int face_base = q3_total_surfaces;
	int leaf_base = q3_total_leafs;
	int side_base = (int)q3_brush_sides.size();

	model->nodes[0] = q3_total_nodes;


	for (int face = 0 ; face < 6 ; face++)
	{
		dnode3_t raw_node;
		dleaf3_t raw_leaf;

		memset(&raw_leaf, 0, sizeof(raw_leaf));

		double v;
		double dir;

		bool flipped;

		if (face < 2)  // PLANE_X
		{
			v = (face==0) ? model->x1 : model->x2;
			dir = (face==0) ? -1 : 1;
			raw_node.planeNum = BSP_AddPlane(v,0,0, dir,0,0, &flipped);
		}
		else if (face < 4)  // PLANE_Y
		{
			v = (face==2) ? model->y1 : model->y2;
			dir = (face==2) ? -1 : 1;
			raw_node.planeNum = BSP_AddPlane(0,v,0, 0,dir,0, &flipped);
		}
		else  // PLANE_Z
		{
			v = (face==5) ? model->z1 : model->z2;
			dir = (face==5) ? -1 : 1;
			raw_node.planeNum = BSP_AddPlane(0,0,v, 0,0,dir, &flipped);
		}

		raw_node.children[0] = -(leaf_base + face + 2);
		raw_node.children[1] = (face == 5) ? -(leaf_base + 6 + 2) : (model->nodes[0] + face + 1);

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

		raw_leaf.contents = 0;  // EMPTY

		raw_leaf.first_leafface = q3_total_mark_surfs;
		raw_leaf.num_leaffaces  = 1;

		raw_leaf.first_leafbrush = 0;
		raw_leaf.num_leafbrushes = 0;

		Q3_Model_Surface(model, face, raw_node.planenum, flipped);

		Q3_WriteMarkSurf(q3_total_mark_surfs);

		DoWriteNode(raw_node);
		DoWriteLeaf(raw_leaf);
	}


	// create leaf for inner area of the cuboid (door etc)
	dleaf3_t inner_leaf;

	memset(&inner_leaf, 0, sizeof(inner_leaf));

	inner_leaf.contents = CONTENTS_SOLID;

	for (int b = 0 ; b < 3 ; b++)
	{
		inner_leaf.mins[b] = mins[b];
		inner_leaf.maxs[b] = maxs[b];
	}

	inner_leaf.first_leafbrush = q3_total_leaf_brushes;
	inner_leaf.num_leafbrushes = 1;

	DoWriteLeaf(inner_leaf);


	// leaf brush reference
	u16_t index = LE_U16(q3_brushes.size());

	q3_leaf_brushes->Append(&index, sizeof(index));

	q3_total_leaf_brushes += 1;


	// create brush for inner area of the cuboid (door etc)
	dbrush_t inner_brush;

	inner_brush.firstside = side_base;
	inner_brush.numsides  = 6;
	inner_brush.contents  = CONTENTS_SOLID;

	DoWriteBrush(inner_brush);
}
#endif


static void Q3_WriteModel(quake_mapmodel_c *model)
{
	dmodel3_t raw_model;

	memset(&raw_model, 0, sizeof(raw_model));

	raw_model.mins[0] = LE_Float32(model->x1 - MODEL_PADDING);
	raw_model.mins[1] = LE_Float32(model->y1 - MODEL_PADDING);
	raw_model.mins[2] = LE_Float32(model->z1 - MODEL_PADDING);

	raw_model.maxs[0] = LE_Float32(model->x2 + MODEL_PADDING);
	raw_model.maxs[1] = LE_Float32(model->y2 + MODEL_PADDING);
	raw_model.maxs[2] = LE_Float32(model->z2 + MODEL_PADDING);

	// raw_model.origin stays zero

	raw_model.firstSurface = LE_S32(model->firstface);
	raw_model.numSurfaces  = LE_S32(model->numfaces);

	// FIXME : firstBrush / numBrushes

	q3_models->Append(&raw_model, sizeof(raw_model));
}


static void Q3_WriteModels()
{
	q3_models = BSP_NewLump(LUMP_MODELS);

	// create the world model
	qk_world_model = new quake_mapmodel_c();

	qk_world_model->firstface = 0;
	qk_world_model->numfaces  = q3_total_surfaces;
	qk_world_model->numleafs  = q3_total_leafs;

	// bounds of map
	qk_world_model->x1 = qk_bsp_root->bbox.mins[0];
	qk_world_model->y1 = qk_bsp_root->bbox.mins[1];
	qk_world_model->y1 = qk_bsp_root->bbox.mins[2];

	qk_world_model->x2 = qk_bsp_root->bbox.maxs[0];
	qk_world_model->y2 = qk_bsp_root->bbox.maxs[1];
	qk_world_model->y2 = qk_bsp_root->bbox.maxs[2];

	Q3_WriteModel(qk_world_model);

	// handle the sub-models (doors etc)

#if 0  // FIXME

	for (unsigned int i = 0 ; i < qk_all_mapmodels.size() ; i++)
	{
		quake_mapmodel_c *model = qk_all_mapmodels[i];

		model->firstface = q3_total_surfaces;
		model->numfaces  = 6;
		model->numleafs  = 6;

		float mins[3], maxs[3];

		mins[0] = model->x1;
		mins[1] = model->y1;
		mins[2] = model->z1;

		maxs[0] = model->x2;
		maxs[1] = model->y2;
		maxs[2] = model->z2;

		Q3_Model_Nodes(model, mins, maxs);

		Q3_WriteModel(model);
	}
#endif
}


//------------------------------------------------------------------------

static void Q3_PackLighting()
{
	// FIXME !!!

	// leaving LUMP_LIGHTING empty for now -- engine can cope
}


static void Q3_SetGridLights()
{
	// FIXME !!!

	// leaving LUMP_LIGHTGRID empty for now -- engine can cope
}


static void Q3_LightWorld()
{
	if (main_win)
		main_win->build_box->Prog_Step("Light");

	QCOM_LightAllFaces();

	Q3_PackLighting();

	Q3_SetGridLights();
}


static void Q3_VisWorld()
{
	if (main_win)
		main_win->build_box->Prog_Step("Vis");

	// no need for numleafs, as Quake 3 uses clusters directly

/// FIXME : disabled for now, though it probably will work as-is
///	QCOM_Visibility(LUMP_VISIBILITY, MAX_MAP_VISIBILITY, 0);
}


static void Q3_CreateBSPFile(const char *name)
{
	qk_color_lighting = true;

	BSP_OpenLevel(name);

	CSG_QUAKE_Build();

	int num_node = 0;
	int num_leaf = 0;

	CSG_AssignIndexes(qk_bsp_root, &num_node, &num_leaf);

	QCOM_Fix_T_Junctions();

	Q3_VisWorld();
	Q3_LightWorld();

	Q3_WriteBSP();
	Q3_WriteModels();

	BSP_WritePlanes(LUMP_PLANES,   MAX_MAP_PLANES);

	Q3_WriteBrushes();
	Q3_WriteShaders();
	Q3_WriteFogs();

	BSP_WriteEntities(LUMP_ENTITIES, description);

	// this will free lots of stuff (lightmaps etc)
	BSP_CloseLevel();

	CSG_QUAKE_Free();

	Q3_FreeStuff();
}


//------------------------------------------------------------------------

class quake3_game_interface_c : public game_interface_c
{
private:
	const char *filename;

public:
	quake3_game_interface_c() : filename(NULL)
	{ }

	~quake3_game_interface_c()
	{ }

	bool Start();
	bool Finish(bool build_ok);

	void BeginLevel();
	void EndLevel();
	void Property(const char *key, const char *value);
};


bool quake3_game_interface_c::Start()
{
	qk_game = 3;
	qk_sub_format = 0;
	qk_lighting_quality = fast_lighting ? -1 : +1;

	if (batch_mode)
		filename = StringDup(batch_output_file);
	else
		filename = DLG_OutputFilename("pk3");

	if (! filename)
	{
		Main_ProgStatus(_("Cancelled"));
		return false;
	}

	if (create_backups)
		Main_BackupFile(filename, "old");

	if (! ZIPF_OpenWrite(filename))
	{
		Main_ProgStatus(_("Error (create file)"));
		return false;
	}

	BSP_AddInfoFile();

	if (main_win)
		main_win->build_box->Prog_Init(0, "CSG,BSP,Vis,Light");

	return true;
}


bool quake3_game_interface_c::Finish(bool build_ok)
{
	ZIPF_CloseWrite();

	// remove the file if an error occurred
	if (! build_ok)
		FileDelete(filename);
	else
		Recent_AddFile(RECG_Output, filename);

	return build_ok;
}


void quake3_game_interface_c::BeginLevel()
{
	level_name  = NULL;
	description = NULL;

	Q3_FreeStuff();

	CSG_QUAKE_Free();
}


void quake3_game_interface_c::Property(const char *key, const char *value)
{
	if (StringCaseCmp(key, "level_name") == 0)
	{
		level_name = StringDup(value);
	}
	else if (StringCaseCmp(key, "description") == 0)
	{
		description = StringDup(value);
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
	else
	{
		LogPrintf("WARNING: unknown QUAKE2 property: %s=%s\n", key, value);
	}
}


void quake3_game_interface_c::EndLevel()
{
	if (! level_name)
		Main_FatalError("Script problem: did not set level name!\n");

	if (strlen(level_name) >= 32)
		Main_FatalError("Script problem: level name too long: %s\n", level_name);

	char entry_in_pak[64];
	sprintf(entry_in_pak, "maps/%s.bsp", level_name);

	Q3_CreateBSPFile(entry_in_pak);

	StringFree(level_name);

	if (description)
		StringFree(description);
}


game_interface_c * Quake3_GameObject(void)
{
	return new quake3_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
