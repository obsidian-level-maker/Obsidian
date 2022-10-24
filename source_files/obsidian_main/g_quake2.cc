//------------------------------------------------------------------------
//  LEVEL building - QUAKE II format
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

#include "csg_main.h"
#include "csg_quake.h"
#include "fmt/format.h"
#ifndef CONSOLE_ONLY
#include "hdr_fltk.h"
#include "hdr_ui.h"
#endif
#include "hdr_lua.h"
#include "headers.h"
#include "lib_file.h"
#include "lib_pak.h"
#include "lib_util.h"
#include "m_cookie.h"
#include "main.h"
#include "q2_structs.h"
#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"

#define LEAF_PADDING 4
#define NODE_PADDING 16
#define MODEL_PADDING 1.0

#define MODEL_LIGHT 64

extern std::filesystem::path BestDirectory();

static std::string level_name;
static std::string description;

// IMPORTANT!! Quake II assumes axis-aligned node planes are positive

static std::array<int, 5> q2_medium_table = {0 /* EMPTY */, CONTENTS_WATER,
                                             CONTENTS_SLIME, CONTENTS_LAVA,
                                             CONTENTS_SOLID};

//------------------------------------------------------------------------

static std::vector<dbrush_t> q2_brushes;
static std::vector<dbrushside_t> q2_brush_sides;

static std::map<const csg_brush_c *, u16_t> brush_map;

static void Q2_ClearBrushes() {
    q2_brushes.clear();
    q2_brush_sides.clear();

    brush_map.clear();
}

static void DoWriteBrushSide(int plane, int texinfo) {
    dbrushside_t side;

    side.planenum = LE_U16(plane);
    side.texinfo = LE_U16(texinfo);

    q2_brush_sides.push_back(side);
}

static void DoWriteBrush(dbrush_t &raw_brush) {
    raw_brush.firstside = LE_S32(raw_brush.firstside);
    raw_brush.numsides = LE_S32(raw_brush.numsides);

    raw_brush.contents = LE_U32(raw_brush.contents);

    q2_brushes.push_back(raw_brush);
}

static u16_t Q2_AddBrush(const csg_brush_c *A) {
    // find existing brush
    if (brush_map.find(A) != brush_map.end()) {
        return brush_map[A];
    }

    dbrush_t raw_brush;

    raw_brush.firstside = (int)q2_brush_sides.size();
    raw_brush.numsides = 2;
    raw_brush.contents = CONTENTS_SOLID;

    int plane;
    int texinfo = 1;  // FIXME !!!!!

    // top
    plane = BSP_AddPlane(0, 0, A->t.z, 0, 0, +1);

    DoWriteBrushSide(plane, texinfo);

    // bottom
    plane = BSP_AddPlane(0, 0, A->b.z, 0, 0, -1);

    DoWriteBrushSide(plane ^ 1, texinfo);

    for (unsigned int k = 0; k < A->verts.size(); k++) {
        bool flipped;

        brush_vert_c *v1 = A->verts[k];
        brush_vert_c *v2 = A->verts[(k + 1) % A->verts.size()];

        plane = BSP_AddPlane(v1->x, v1->y, 0, (v2->y - v1->y), (v1->x - v2->x),
                             0, &flipped);

        if (flipped) {
            plane ^= 1;
        }

        DoWriteBrushSide(plane, texinfo);

        raw_brush.numsides++;
    }

    u16_t index = q2_brushes.size();

    brush_map[A] = index;

    DoWriteBrush(raw_brush);

    return (u16_t)index;
}

static void Q2_WriteBrushes() {
    qLump_c *lump = BSP_NewLump(LUMP_BRUSHES);

    // FIXME: write separately, fix endianness as we go

    lump->Append(&q2_brushes[0], q2_brushes.size() * sizeof(dbrush_t));

    qLump_c *sides = BSP_NewLump(LUMP_BRUSHSIDES);

    sides->Append(&q2_brush_sides[0],
                  q2_brush_sides.size() * sizeof(dbrushside_t));
}

//------------------------------------------------------------------------

static std::vector<texinfo2_t> q2_texinfos;

#define NUM_TEXINFO_HASH 128
static std::array<std::vector<int> *, NUM_TEXINFO_HASH> texinfo_hashtab;

static void Q2_ClearTexInfo(void) {
    q2_texinfos.clear();

    for (int h = 0; h < NUM_TEXINFO_HASH; h++) {
        delete texinfo_hashtab[h];
        texinfo_hashtab[h] = NULL;
    }
}

u16_t Q2_AddTexInfo(std::string texture, int flags, int value, float *s4,
                    float *t4) {
    if (!texture[0]) {
        texture = "error";
    }

    // create texinfo structure, fix endianness
    texinfo2_t raw_tex;

    memset(&raw_tex, 0, sizeof(raw_tex));

    if (texture.size() + 1 >= sizeof(raw_tex.texture)) {
        Main::FatalError("Quake2 texture name too long: '{}'\n", texture);
    }

    // strcpy(raw_tex.texture, texture);
    std::copy(texture.data(), texture.data() + texture.size(), raw_tex.texture);

    for (int k = 0; k < 4; k++) {
        raw_tex.s[k] = LE_Float32(s4[k]);
        raw_tex.t[k] = LE_Float32(t4[k]);
    }

    raw_tex.flags = LE_S32(flags);
    raw_tex.value = LE_S32(value);

    raw_tex.anim_next = LE_S32(0);  // TODO

    // find an existing texinfo in the hash table
    int hash = (int)StringHash(texture) & (NUM_TEXINFO_HASH - 1);

    SYS_ASSERT(hash >= 0);

    if (!texinfo_hashtab[hash]) {
        texinfo_hashtab[hash] = new std::vector<int>;
    }

    std::vector<int> *hashtab = texinfo_hashtab[hash];

    for (unsigned int i = 0; i < hashtab->size(); i++) {
        int index = (*hashtab)[i];

        SYS_ASSERT(index < (int)q2_texinfos.size());

        if (memcmp(&raw_tex, &q2_texinfos[index], sizeof(raw_tex)) == 0) {
            return index;  // found it
        }
    }

    // not found, so add new one
    u16_t new_index = q2_texinfos.size();

    q2_texinfos.push_back(raw_tex);

    hashtab->push_back(new_index);

    return new_index;
}

static void Q2_WriteTexInfo() {
    if (q2_texinfos.size() >= MAX_MAP_TEXINFO) {
        Main::FatalError(
            "Quake2 build failure: exceeded limit of {} TEXINFOS\n",
            MAX_MAP_TEXINFO);
    }

    qLump_c *lump = BSP_NewLump(LUMP_TEXINFO);

    lump->Append(&q2_texinfos[0], q2_texinfos.size() * sizeof(texinfo2_t));
}

//------------------------------------------------------------------------

static void Q2_DummyArea() {
    /* TEMP DUMMY STUFF */

    qLump_c *lump = BSP_NewLump(LUMP_AREAS);

    darea_t area;

    area.num_portals = LE_U32(0);
    area.first_portal = LE_U32(0);

    lump->Append(&area, sizeof(area));
    lump->Append(&area, sizeof(area));
}

#if 0
static void Q2_DummyVis()
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
static void Q2_DummyLeafBrush()
{
    qLump_c *lump = BSP_NewLump(LUMP_LEAFBRUSHES);

    dbrush_t brush;

    brush.firstside = 0;
    brush.numsides  = 0;

    brush.contents  = 0;

    lump->Append(&brush, sizeof(brush));
}
#endif

/* const byte oblige_pop[256] =
{
  175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175,
175, 175, 175, 175, 175, 221, 221, 221, 221, 221, 221, 221, 175, 175, 175, 175,
175, 175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175,
175, 175, 175, 175, 175,  62,  59,  58,  57, 221, 221,  59,  62, 175, 175, 175,
175, 175, 175,  63,  59,  57,  57,  57, 221, 221,  57,  57,  57,  59,  63, 175,
175, 175, 172,  58,  57,  57,  57,  57, 221, 221,  57,  57,  57,  57,  58, 172,
175, 175,  59,  57,  57,  57,  61, 221, 221, 174,  63,  61,  57,  57,  57,  59,
175, 175,  57,  57,  57, 171, 175, 221, 221, 221, 221, 221, 221,  57,  57,  57,
175, 175,  57,  57,  57, 171, 221, 221, 221, 221, 221, 221, 171,  57,  57,  57,
175, 175,  59,  57,  57,  57,  61,  63, 175, 174, 221, 221,  57,  57,  57,  59,
175, 175, 172,  58,  57,  57,  57,  57,  57,  57,  57,  57,  57,  57,  58, 172,
175, 175, 175,  63,  59,  57,  57,  57,  57,  57,  57,  57,  57,  59,  63, 175,
175, 175, 175, 175, 175,  62,  59,  58,  57,  57,  58,  59,  62, 175, 175, 175,
175, 175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175,
175, 175, 175, 175, 175, 175, 175, 175, 221, 221, 175, 175, 175, 175, 175, 175,
175, 175, 175, 175, 175, 175, 175, 175, 221, 175, 175, 175, 175, 175, 175, 175,
175
}; */

//------------------------------------------------------------------------

static qLump_c *q2_surf_edges;
static qLump_c *q2_mark_surfs;  // LUMP_LEAFFACES
static qLump_c *q2_leaf_brushes;

static qLump_c *q2_faces;
static qLump_c *q2_leafs;
static qLump_c *q2_nodes;

static qLump_c *q2_models;

static int q2_total_surf_edges;
static int q2_total_mark_surfs;
static int q2_total_leaf_brushes;

static int q2_total_faces;
static int q2_total_leafs;
static int q2_total_nodes;

static void Q2_FreeStuff() {
    Q2_ClearBrushes();
    Q2_ClearTexInfo();

    delete qk_world_model;
    qk_world_model = NULL;

    // lumps are handled (freed) in q_common code
    q2_surf_edges = NULL;
    q2_mark_surfs = NULL;
    q2_leaf_brushes = NULL;

    q2_faces = NULL;
    q2_leafs = NULL;
    q2_nodes = NULL;
    q2_models = NULL;
}

static void Q2_WriteEdge(const quake_vertex_c &A, const quake_vertex_c &B) {
    u16_t v1 = BSP_AddVertex(A.x, A.y, A.z);
    u16_t v2 = BSP_AddVertex(B.x, B.y, B.z);

    if (v1 == v2) {
        Main::FatalError("INTERNAL ERROR: Q2 WriteEdge is zero length!\n");
    }

    s32_t index = BSP_AddEdge(v1, v2);

    // fix endianness
    index = LE_S32(index);

    q2_surf_edges->Append(&index, sizeof(index));

    q2_total_surf_edges += 1;
}

static void Q2_WriteLeafBrush(csg_brush_c *B) {
    u16_t index = Q2_AddBrush(B);

    // fix endianness
    index = LE_U16(index);

    q2_leaf_brushes->Append(&index, sizeof(index));

    q2_total_leaf_brushes += 1;
}

static inline void DoWriteFace(dface_t &raw_face) {
    // fix endianness
    raw_face.planenum = LE_S16(raw_face.planenum);
    raw_face.side = LE_S16(raw_face.side);
    raw_face.firstedge = LE_S32(raw_face.firstedge);
    raw_face.numedges = LE_S16(raw_face.numedges);
    raw_face.texinfo = LE_S16(raw_face.texinfo);
    raw_face.lightofs = LE_S32(raw_face.lightofs);

    q2_faces->Append(&raw_face, sizeof(raw_face));

    q2_total_faces += 1;
}

static void Q2_WriteFace(quake_face_c *face) {
    SYS_ASSERT(face->node);
    SYS_ASSERT(face->node_side >= 0);

    face->index = q2_total_faces;

    dface_t raw_face;

    memset(&raw_face, 0, sizeof(raw_face));

    bool flipped;

    raw_face.planenum = BSP_AddPlane(&face->node->plane, &flipped);

    raw_face.side = face->node_side ^ (flipped ? 1 : 0);

    unsigned int total_v = face->verts.size();

    raw_face.firstedge = q2_total_surf_edges;
    raw_face.numedges = total_v;

    for (unsigned int i = 0; i < total_v; i++) {
        Q2_WriteEdge(face->verts[i], face->verts[(i + 1) % total_v]);
    }

    // lighting and texture...

    raw_face.lightofs = -1;

    memset(raw_face.styles, 255, 4);

    if (face->lmap) {
        raw_face.lightofs = face->lmap->offset;

        for (int n = 0; n < 4; n++) {
            raw_face.styles[n] = face->lmap->styles[n];
        }
    }

    const char *texture = face->texture.c_str();

    int flags = 0;

    if (face->flags & FACE_F_Sky) {
        flags |= SURF_SKY;
    }
    if (face->flags & FACE_F_Liquid) {
        flags |= SURF_WARP | SURF_TRANS66;
    }

    raw_face.texinfo =
        Q2_AddTexInfo(texture, flags, 0, face->uv_mat.s, face->uv_mat.t);

    DoWriteFace(raw_face);
}

static void Q2_WriteMarkSurf(int index) {
    SYS_ASSERT(index >= 0);

    // fix endianness
    u16_t raw_index = LE_U16(index);

    q2_mark_surfs->Append(&raw_index, sizeof(raw_index));

    q2_total_mark_surfs += 1;
}

static void DoWriteLeaf(dleaf2_t &raw_leaf) {
    // fix endianness
    raw_leaf.contents = LE_S32(raw_leaf.contents);
    raw_leaf.cluster = LE_S16(raw_leaf.cluster);
    raw_leaf.area = LE_S16(raw_leaf.area);

    raw_leaf.first_leafface = LE_U16(raw_leaf.first_leafface);
    raw_leaf.first_leafbrush = LE_U16(raw_leaf.first_leafbrush);
    raw_leaf.num_leaffaces = LE_U16(raw_leaf.num_leaffaces);
    raw_leaf.num_leafbrushes = LE_U16(raw_leaf.num_leafbrushes);

    for (int b = 0; b < 3; b++) {
        raw_leaf.mins[b] = LE_S16(raw_leaf.mins[b] - LEAF_PADDING);
        raw_leaf.maxs[b] = LE_S16(raw_leaf.maxs[b] + LEAF_PADDING);
    }

    q2_leafs->Append(&raw_leaf, sizeof(raw_leaf));

    q2_total_leafs += 1;
}

static void Q2_WriteLeaf(quake_leaf_c *leaf) {
    SYS_ASSERT(leaf->medium >= 0);
    SYS_ASSERT(leaf->medium <= MEDIUM_SOLID);

    SYS_ASSERT(leaf != qk_solid_leaf);

    dleaf2_t raw_leaf;

    memset(&raw_leaf, 0, sizeof(raw_leaf));

    raw_leaf.contents = q2_medium_table[leaf->medium];

    if (leaf->medium == MEDIUM_SOLID) {
        raw_leaf.cluster = -1;
        raw_leaf.area = 0;
    } else {
        raw_leaf.cluster = leaf->cluster ? leaf->cluster->CalcID() : 0;
        raw_leaf.area = 1;
    }

    // create the 'mark surfs'
    raw_leaf.first_leafface = q2_total_mark_surfs;
    raw_leaf.num_leaffaces = 0;

    for (unsigned int i = 0; i < leaf->faces.size(); i++) {
        Q2_WriteMarkSurf(leaf->faces[i]->index);

        raw_leaf.num_leaffaces += 1;
    }

    raw_leaf.first_leafbrush = q2_total_leaf_brushes;
    raw_leaf.num_leafbrushes = 0;

    for (unsigned int k = 0; k < leaf->brushes.size(); k++) {
        Q2_WriteLeafBrush(leaf->brushes[k]);

        raw_leaf.num_leafbrushes += 1;
    }

    for (int b = 0; b < 3; b++) {
        raw_leaf.mins[b] = I_ROUND(leaf->bbox.mins[b]);
        raw_leaf.maxs[b] = I_ROUND(leaf->bbox.maxs[b]);
    }

    DoWriteLeaf(raw_leaf);
}

static void Q2_WriteSolidLeaf(void) {
    dleaf2_t raw_leaf;

    memset(&raw_leaf, 0, sizeof(raw_leaf));

    raw_leaf.contents = LE_S32(CONTENTS_SOLID);
    raw_leaf.cluster = LE_S32(-1);

    q2_leafs->Append(&raw_leaf, sizeof(raw_leaf));
}

static void DoWriteNode(dnode2_t &raw_node) {
    // fix endianness
    raw_node.planenum = LE_S32(raw_node.planenum);
    raw_node.children[0] = LE_S32(raw_node.children[0]);
    raw_node.children[1] = LE_S32(raw_node.children[1]);
    raw_node.firstface = LE_U16(raw_node.firstface);
    raw_node.numfaces = LE_U16(raw_node.numfaces);

    for (int b = 0; b < 3; b++) {
        raw_node.mins[b] = LE_S16(raw_node.mins[b] - NODE_PADDING);
        raw_node.maxs[b] = LE_S16(raw_node.maxs[b] + NODE_PADDING);
    }

    q2_nodes->Append(&raw_node, sizeof(raw_node));

    q2_total_nodes += 1;
}

static void Q2_WriteNode(quake_node_c *node) {
    dnode2_t raw_node;

    bool flipped;

    raw_node.planenum = BSP_AddPlane(&node->plane, &flipped);

    if (node->front_N) {
        raw_node.children[0] = node->front_N->index;
    } else {
        raw_node.children[0] = (-1 - node->front_L->index);
    }

    if (node->back_N) {
        raw_node.children[1] = node->back_N->index;
    } else {
        raw_node.children[1] = (-1 - node->back_L->index);
    }

    if (flipped) {
        int node0 = raw_node.children[0];
        int node1 = raw_node.children[1];
        raw_node.children[0] = node1;
        raw_node.children[1] = node0;
        //        std::swap(raw_node.children[0], raw_node.children[1]);
    }

    raw_node.firstface = q2_total_faces;
    raw_node.numfaces = node->faces.size();

    if (raw_node.numfaces > 0) {
        for (unsigned int k = 0; k < node->faces.size(); k++) {
            Q2_WriteFace(node->faces[k]);
        }
    }

    for (int b = 0; b < 3; b++) {
        raw_node.mins[b] = I_ROUND(node->bbox.mins[b]);
        raw_node.maxs[b] = I_ROUND(node->bbox.maxs[b]);
    }

    DoWriteNode(raw_node);

    // recurse now, AFTER adding the current node

    if (node->front_N) {
        Q2_WriteNode(node->front_N);
    } else {
        Q2_WriteLeaf(node->front_L);
    }

    if (node->back_N) {
        Q2_WriteNode(node->back_N);
    } else {
        Q2_WriteLeaf(node->back_L);
    }
}

static void Q2_WriteBSP() {
    q2_total_nodes = 0;
    q2_total_leafs = 0;  // not including the solid leaf
    q2_total_faces = 0;

    q2_total_surf_edges = 0;
    q2_total_mark_surfs = 0;
    q2_total_leaf_brushes = 0;

    q2_nodes = BSP_NewLump(LUMP_NODES);
    q2_leafs = BSP_NewLump(LUMP_LEAFS);
    q2_faces = BSP_NewLump(LUMP_FACES);

    q2_surf_edges = BSP_NewLump(LUMP_SURFEDGES);
    q2_mark_surfs = BSP_NewLump(LUMP_LEAFFACES);
    q2_leaf_brushes = BSP_NewLump(LUMP_LEAFBRUSHES);

    Q2_WriteSolidLeaf();

    Q2_WriteNode(qk_bsp_root);

    if (q2_total_faces >= MAX_MAP_FACES) {
        Main::FatalError("Quake2 build failure: exceeded limit of {} FACES\n",
                         MAX_MAP_FACES);
    }

    if (q2_total_leafs >= MAX_MAP_LEAFS) {
        Main::FatalError("Quake2 build failure: exceeded limit of {} LEAFS\n",
                         MAX_MAP_LEAFS);
    }

    if (q2_total_nodes >= MAX_MAP_NODES) {
        Main::FatalError("Quake2 build failure: exceeded limit of {} NODES\n",
                         MAX_MAP_NODES);
    }
}

//------------------------------------------------------------------------
//   MAP MODEL STUFF
//------------------------------------------------------------------------

static void Q2_Model_Edge(float x1, float y1, float z1, float x2, float y2,
                          float z2) {
    quake_vertex_c A(x1, y1, z1);
    quake_vertex_c B(x2, y2, z2);

    Q2_WriteEdge(A, B);
}

static void Q2_Model_Face(quake_mapmodel_c *model, int face, s16_t plane,
                          bool flipped) {
    dface_t raw_face;

    raw_face.planenum = plane;
    raw_face.side = flipped ? 1 : 0;

    std::string texture = "error";

    std::array<float, 4> s = {0.0, 0.0, 0.0, 0.0};
    std::array<float, 4> t = {0.0, 0.0, 0.0, 0.0};

    // add the edges

    raw_face.firstedge = q2_total_surf_edges;
    raw_face.numedges = 4;

    if (face < 2)  // PLANE_X
    {
        s[1] = 1;  // PLANE_X
        t[2] = -1;

        texture = model->x_face.getStr("tex", "missing");

        double x = (face == 0) ? model->x1 : model->x2;
        double y1 = flipped ? model->y2 : model->y1;
        double y2 = flipped ? model->y1 : model->y2;

        // Note: this assumes the plane is positive
        Q2_Model_Edge(x, y1, model->z1, x, y1, model->z2);
        Q2_Model_Edge(x, y1, model->z2, x, y2, model->z2);
        Q2_Model_Edge(x, y2, model->z2, x, y2, model->z1);
        Q2_Model_Edge(x, y2, model->z1, x, y1, model->z1);
    } else if (face < 4) {
        s[0] = 1;  // PLANE_Y
        t[2] = -1;

        texture = model->y_face.getStr("tex", "missing");

        double y = (face == 2) ? model->y1 : model->y2;
        double x1 = flipped ? model->x1 : model->x2;
        double x2 = flipped ? model->x2 : model->x1;

        Q2_Model_Edge(x1, y, model->z1, x1, y, model->z2);
        Q2_Model_Edge(x1, y, model->z2, x2, y, model->z2);
        Q2_Model_Edge(x2, y, model->z2, x2, y, model->z1);
        Q2_Model_Edge(x2, y, model->z1, x1, y, model->z1);
    } else {
        s[0] = 1;  // PLANE_Z
        t[1] = 1;

        texture = model->z_face.getStr("tex", "missing");

        double z = (face == 5) ? model->z1 : model->z2;
        double x1 = flipped ? model->x2 : model->x1;
        double x2 = flipped ? model->x1 : model->x2;

        Q2_Model_Edge(x1, model->y1, z, x1, model->y2, z);
        Q2_Model_Edge(x1, model->y2, z, x2, model->y2, z);
        Q2_Model_Edge(x2, model->y2, z, x2, model->y1, z);
        Q2_Model_Edge(x2, model->y1, z, x1, model->y1, z);
    }

    // texture and lighting

    int flags = 0;

    // using SURF_WARP to disable the check on extents
    // (trigger models are never rendered anyway)

    if (texture.find("trigger") != std::string::npos) {
        flags |= SURF_NODRAW | SURF_WARP;
    }

    raw_face.texinfo = Q2_AddTexInfo(texture, flags, 0, s.data(), t.data());

    raw_face.styles[0] = 0;
    raw_face.styles[1] = 0xFF;
    raw_face.styles[2] = 0xFF;
    raw_face.styles[3] = 0xFF;

    raw_face.lightofs = 0;  // a shared lightmap at very start

    DoWriteBrushSide(raw_face.planenum ^ raw_face.side, raw_face.texinfo);

    DoWriteFace(raw_face);
}

static void Q2_Model_Nodes(quake_mapmodel_c *model, float *mins, float *maxs) {
    int face_base = q2_total_faces;
    int leaf_base = q2_total_leafs;
    int side_base = (int)q2_brush_sides.size();

    model->nodes[0] = q2_total_nodes;

    for (int face = 0; face < 6; face++) {
        dnode2_t raw_node;
        dleaf2_t raw_leaf;

        memset(&raw_leaf, 0, sizeof(raw_leaf));

        double v;
        double dir;

        bool flipped;

        if (face < 2)  // PLANE_X
        {
            v = (face == 0) ? model->x1 : model->x2;
            dir = (face == 0) ? -1 : 1;
            raw_node.planenum = BSP_AddPlane(v, 0, 0, dir, 0, 0, &flipped);
        } else if (face < 4)  // PLANE_Y
        {
            v = (face == 2) ? model->y1 : model->y2;
            dir = (face == 2) ? -1 : 1;
            raw_node.planenum = BSP_AddPlane(0, v, 0, 0, dir, 0, &flipped);
        } else  // PLANE_Z
        {
            v = (face == 5) ? model->z1 : model->z2;
            dir = (face == 5) ? -1 : 1;
            raw_node.planenum = BSP_AddPlane(0, 0, v, 0, 0, dir, &flipped);
        }

        raw_node.children[0] = -(leaf_base + face + 2);
        raw_node.children[1] =
            (face == 5) ? -(leaf_base + 6 + 2) : (model->nodes[0] + face + 1);

        if (flipped) {
            int node0 = raw_node.children[0];
            int node1 = raw_node.children[1];
            raw_node.children[0] = node1;
            raw_node.children[1] = node0;
            //            std::swap(raw_node.children[0],
            // raw_node.children[1]);
        }

        raw_node.firstface = face_base + face;
        raw_node.numfaces = 1;

        for (int b = 0; b < 3; b++) {
            raw_leaf.mins[b] = raw_node.mins[b] = mins[b];
            raw_leaf.maxs[b] = raw_node.maxs[b] = maxs[b];
        }

        raw_leaf.contents = 0;  // EMPTY

        raw_leaf.first_leafface = q2_total_mark_surfs;
        raw_leaf.num_leaffaces = 1;

        raw_leaf.first_leafbrush = 0;
        raw_leaf.num_leafbrushes = 0;

        Q2_Model_Face(model, face, raw_node.planenum, flipped);

        Q2_WriteMarkSurf(q2_total_mark_surfs);

        DoWriteNode(raw_node);
        DoWriteLeaf(raw_leaf);
    }

    // create leaf for inner area of the cuboid (door etc)
    dleaf2_t inner_leaf;

    memset(&inner_leaf, 0, sizeof(inner_leaf));

    inner_leaf.contents = CONTENTS_SOLID;

    for (int b = 0; b < 3; b++) {
        inner_leaf.mins[b] = mins[b];
        inner_leaf.maxs[b] = maxs[b];
    }

    inner_leaf.first_leafbrush = q2_total_leaf_brushes;
    inner_leaf.num_leafbrushes = 1;

    DoWriteLeaf(inner_leaf);

    // leaf brush reference
    u16_t index = LE_U16(q2_brushes.size());

    q2_leaf_brushes->Append(&index, sizeof(index));

    q2_total_leaf_brushes += 1;

    // create brush for inner area of the cuboid (door etc)
    dbrush_t inner_brush;

    inner_brush.firstside = side_base;
    inner_brush.numsides = 6;
    inner_brush.contents = CONTENTS_SOLID;

    DoWriteBrush(inner_brush);
}

static void Q2_WriteModel(quake_mapmodel_c *model) {
    dmodel2_t raw_model;

    memset(&raw_model, 0, sizeof(raw_model));

    raw_model.mins[0] = LE_Float32(model->x1 - MODEL_PADDING);
    raw_model.mins[1] = LE_Float32(model->y1 - MODEL_PADDING);
    raw_model.mins[2] = LE_Float32(model->z1 - MODEL_PADDING);

    raw_model.maxs[0] = LE_Float32(model->x2 + MODEL_PADDING);
    raw_model.maxs[1] = LE_Float32(model->y2 + MODEL_PADDING);
    raw_model.maxs[2] = LE_Float32(model->z2 + MODEL_PADDING);

    // raw_model.origin stays zero

    raw_model.headnode = LE_S32(model->nodes[0]);

    raw_model.firstface = LE_S32(model->firstface);
    raw_model.numfaces = LE_S32(model->numfaces);

    q2_models->Append(&raw_model, sizeof(raw_model));
}

static void Q2_WriteModels() {
    q2_models = BSP_NewLump(LUMP_MODELS);

    // create the world model
    qk_world_model = new quake_mapmodel_c();

    qk_world_model->firstface = 0;
    qk_world_model->numfaces = q2_total_faces;
    qk_world_model->numleafs = q2_total_leafs;

    // bounds of map
    qk_world_model->x1 = qk_bsp_root->bbox.mins[0];
    qk_world_model->y1 = qk_bsp_root->bbox.mins[1];
    qk_world_model->y1 = qk_bsp_root->bbox.mins[2];

    qk_world_model->x2 = qk_bsp_root->bbox.maxs[0];
    qk_world_model->y2 = qk_bsp_root->bbox.maxs[1];
    qk_world_model->y2 = qk_bsp_root->bbox.maxs[2];

    Q2_WriteModel(qk_world_model);

    // handle the sub-models (doors etc)

    for (unsigned int i = 0; i < qk_all_mapmodels.size(); i++) {
        quake_mapmodel_c *model = qk_all_mapmodels[i];

        model->firstface = q2_total_faces;
        model->numfaces = 6;
        model->numleafs = 6;

        std::array<float, 3> mins, maxs;

        mins[0] = model->x1;
        mins[1] = model->y1;
        mins[2] = model->z1;

        maxs[0] = model->x2;
        maxs[1] = model->y2;
        maxs[2] = model->z2;

        Q2_Model_Nodes(model, mins.data(), maxs.data());

        Q2_WriteModel(model);
    }
}

//------------------------------------------------------------------------

static void Q2_LightWorld() {
#ifndef CONSOLE_ONLY
    if (main_win) {
        main_win->build_box->Prog_Step("Light");
    }
#endif

    QLIT_LightAllFaces();

    QLIT_BuildLightingLump(LUMP_LIGHTING, MAX_MAP_LIGHTING);
}

static void Q2_VisWorld() {
#ifndef CONSOLE_ONLY
    if (main_win) {
        main_win->build_box->Prog_Step("Vis");
    }
#endif

    // no need for numleafs, as Quake II uses clusters directly

    QVIS_Visibility(LUMP_VISIBILITY, MAX_MAP_VISIBILITY, 0);
}

static void Q2_CreateBSPFile(const char *name) {
    BSP_OpenLevel(name);

    Q2_DummyArea();

    CSG_QUAKE_Build();

    int num_node = 0;
    int num_leaf = 0;

    CSG_AssignIndexes(qk_bsp_root, &num_node, &num_leaf);

    QCOM_Fix_T_Junctions();

    Q2_VisWorld();
    Q2_LightWorld();

    Q2_WriteBSP();
    Q2_WriteModels();

    BSP_WritePlanes(LUMP_PLANES, MAX_MAP_PLANES);
    BSP_WriteVertices(LUMP_VERTEXES, MAX_MAP_VERTS);
    BSP_WriteEdges(LUMP_EDGES, MAX_MAP_EDGES);

    Q2_WriteBrushes();
    Q2_WriteTexInfo();

    BSP_WriteEntities(LUMP_ENTITIES, description.c_str());

    // this will free lots of stuff (lightmaps etc)
    BSP_CloseLevel();

    CSG_QUAKE_Free();

    Q2_FreeStuff();
}

//------------------------------------------------------------------------

class quake2_game_interface_c : public game_interface_c {
   private:
    std::filesystem::path filename;

   public:
    quake2_game_interface_c() : filename(NULL) {}

    ~quake2_game_interface_c() {}

    bool Start(const char *preset);
    bool Finish(bool build_ok);

    void BeginLevel();
    void EndLevel();
    void Property(std::string key, std::string value);
    std::filesystem::path Filename();
};

bool quake2_game_interface_c::Start(const char *preset) {
    qk_game = 2;
    qk_sub_format = 0;

    CLUSTER_SIZE = 128.0;

    QLIT_InitProperties();

    if (batch_mode) {
        if (batch_output_file.is_absolute()) {
            filename = batch_output_file;
        } else {
            filename = Resolve_DefaultOutputPath() / batch_output_file;
        }
    } else {
#ifndef CONSOLE_ONLY
        if (!mid_batch) {
            filename = DLG_OutputFilename("pak", preset);
        } else {
            filename = BestDirectory() / preset;
        }
#endif
    }

    if (filename.empty()) {
        Main::ProgStatus(_("Cancelled"));
        return false;
    }

    if (create_backups) {
        Main::BackupFile(filename);
    }

    if (!PAK_OpenWrite(filename)) {
        Main::ProgStatus(_("Error (create file)"));
        return false;
    }

    BSP_AddInfoFile();

#ifndef CONSOLE_ONLY
    if (main_win) {
        main_win->build_box->Prog_Init(0, "CSG,BSP,Vis,Light");
    }
#endif

    return true;
}

bool quake2_game_interface_c::Finish(bool build_ok) {
    PAK_CloseWrite();

    // remove the file if an error occurred
    if (!build_ok) {
        std::filesystem::remove(filename);
    } else {
        Recent_AddFile(RECG_Output, filename.c_str());
    }

    return build_ok;
}

void quake2_game_interface_c::BeginLevel() {
    level_name.clear();
    description.clear();
    Q2_FreeStuff();

    CSG_QUAKE_Free();
}

void quake2_game_interface_c::Property(std::string key, std::string value) {
    if (StringCaseCmp(key, "level_name") == 0) {
        level_name = !value.empty() ? value.c_str() : "";
    } else if (StringCaseCmp(key, "description") == 0) {
        description = !value.empty() ? value.c_str() : "";
    } else {
        LogPrintf("WARNING: unknown QUAKE2 property: {}={}\n", key, value);
    }
}

std::filesystem::path quake2_game_interface_c::Filename() {
    return filename;
}

void quake2_game_interface_c::EndLevel() {
    if (level_name.empty()) {
        Main::FatalError("Script problem: did not set level name!\n");
    }

    if (level_name.size() >= 32) {
        Main::FatalError("Script problem: level name too long: {}\n",
                         level_name);
    }

    std::string entry_in_pak = fmt::format("maps/{}.bsp", level_name);

    Q2_CreateBSPFile(entry_in_pak.c_str());
}

game_interface_c *Quake2_GameObject(void) {
    return new quake2_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
