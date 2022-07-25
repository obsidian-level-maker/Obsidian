//------------------------------------------------------------------------
//  LEVEL building - QUAKE III format
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

#include <algorithm>
#include "csg_main.h"
#include "csg_quake.h"
#include "fmt/format.h"
#include "hdr_fltk.h"
#include "hdr_lua.h"
#include "hdr_ui.h"
#include "headers.h"
#include "lib_file.h"
#include "lib_pak.h"
#include "lib_util.h"
#include "lib_zip.h"
#include "m_cookie.h"
#include "main.h"
#include "q3_structs.h"
#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"

#define LEAF_PADDING 2
#define NODE_PADDING 4
#define MODEL_PADDING 4

#define MODEL_LIGHT 64

#define RT_DEFAULT_RADIUS 200

#define MAX_BRUSH_PLANES 100
#define MAX_FACE_VERTS 100

#define SHADER_COMMON_SOLID 0
#define SHADER_COMMON_CLIP 1
#define SHADER_COMMON_SKY 2
#define SHADER_COMMON_TRIGGER 3

#define SHADER_COMMON_WATER 4
#define SHADER_COMMON_SLIME 5
#define SHADER_COMMON_LAVA 6

static std::string level_name;
static std::string description;

static std::string water_shader;
static std::string slime_shader;
static std::string lava_shader;

extern double q3_default_tex_scale;

//------------------------------------------------------------------------

static std::vector<dbrush3_t> q3_brushes;
static std::vector<dbrushside3_t> q3_brush_sides;

static std::map<const csg_brush_c *, s32_t> brush_map;

static void Q3_ClearBrushes() {
    q3_brushes.clear();
    q3_brush_sides.clear();

    brush_map.clear();
}

static int GetBrushSidePlane(float px, float py, float pz, float nx, float ny,
                             float nz, int *axial) {
    // returns planeNum, and sets 'axial' parameter to 0..5 or -1
    // when the plane is NOT an axial plane.
    //
    // axial numbers:
    //    0 = negative X   (the "left" side)
    //    1 = positive X   (the "right" side)
    //    2 = negative Y   (the "near" side)
    //    3 = positive Y   (the "far" side)
    //    4 = negative Z   (the "bottom" side)
    //    5 = positive Z   (the "top" side)

    int plane;
    bool flipped;

    double len = sqrt(nx * nx + ny * ny + nz * nz);
    SYS_ASSERT(len > 0);

    nx /= len;
    ny /= len;
    nz /= len;

    plane = BSP_AddPlane(px, py, pz, nx, ny, nz, &flipped);

    if (flipped) {
        plane ^= 1;
    }

    *axial = -1;

    if (nx < -0.999) {
        *axial = 0;
    }
    if (nx > +0.999) {
        *axial = 1;
    }
    if (ny < -0.999) {
        *axial = 2;
    }
    if (ny > +0.999) {
        *axial = 3;
    }
    if (nz < -0.999) {
        *axial = 4;
    }
    if (nz > +0.999) {
        *axial = 5;
    }

    return plane;
}

static void DoAddBrushPlane(int *planes, float px, float py, float pz, float nx,
                            float ny, float nz) {
    int i;

    int axial;
    int plane = GetBrushSidePlane(px, py, pz, nx, ny, nz, &axial);

    // store axial plane in the corresponding slot
    if (axial >= 0) {
        planes[axial] = plane;
        return;
    }

    // otherwise find a free slot (above the axial slots)
    for (i = 6; i < MAX_BRUSH_PLANES; i++) {
        if (planes[i] < 0) {
            planes[i] = plane;
            return;
        }
    }

    Main::FatalError("Quake3 build failure: brush with more than {} planes\n",
                     MAX_BRUSH_PLANES);
}

static void DoAddBrushPlane(int *planes, const brush_plane_c &BP, float nz) {
    if (BP.slope) {
        DoAddBrushPlane(planes, BP.slope->x, BP.slope->y, BP.slope->z,
                        BP.slope->nx, BP.slope->ny, BP.slope->nz);
    } else {
        DoAddBrushPlane(planes, 0, 0, BP.z, 0, 0, nz);
    }
}

static void DoWriteBrushSide(int plane, int shader) {
    dbrushside3_t side;

    side.planeNum = LE_S32(plane);
    side.shaderNum = LE_S32(shader);

    q3_brush_sides.push_back(side);
}

static void DoWriteBrush(dbrush3_t &raw_brush) {
    raw_brush.firstSide = LE_S32(raw_brush.firstSide);
    raw_brush.numSides = LE_S32(raw_brush.numSides);

    raw_brush.shaderNum = LE_U32(raw_brush.shaderNum);

    q3_brushes.push_back(raw_brush);
}

static s32_t Q3_AddBrush(const csg_brush_c *A) {
    // the logic here is a bit complicated, since the Quake3 engine
    // requires axial planes (aka "brush bevels") as the first six
    // planes of the brush, in a particular order too (X before Y
    // before Z, negative normals before positive ones).

    std::array<int, MAX_BRUSH_PLANES> planes;
    int i;

    // find existing brush
    if (brush_map.find(A) != brush_map.end()) {
        return brush_map[A];
    }

    // clear the used planes
    for (i = 0; i < MAX_BRUSH_PLANES; i++) {
        planes[i] = -1;
    }

    // prepare the brush structure
    dbrush3_t raw_brush;

    raw_brush.firstSide = (int)q3_brush_sides.size();
    raw_brush.numSides = 0;

    // use the "common/solid" shader
    raw_brush.shaderNum = SHADER_COMMON_SOLID;

    std::string medium = A->props.getStr("medium", "");

    if (!medium.empty()) {
        if (StringCaseCmp(medium, "slime") == 0) {
            raw_brush.shaderNum = SHADER_COMMON_SLIME;
        } else if (StringCaseCmp(medium, "lava") == 0) {
            raw_brush.shaderNum = SHADER_COMMON_LAVA;
        } else if (StringCaseCmp(medium, "trigger") == 0) {
            raw_brush.shaderNum = SHADER_COMMON_TRIGGER;
        } else {
            raw_brush.shaderNum = SHADER_COMMON_WATER;
        }
    } else if (A->bflags & BFLAG_NoDraw) {
        raw_brush.shaderNum = SHADER_COMMON_CLIP;
    } else if ((A->t.face.getStr("tex", "")).find("skies/") !=
               std::string::npos) {
        raw_brush.shaderNum = SHADER_COMMON_SKY;
    }

    // add all the brush planes

    // top
    DoAddBrushPlane(planes.data(), A->t, +1);

    // bottom
    DoAddBrushPlane(planes.data(), A->b, -1);

    // sides
    for (unsigned int k = 0; k < A->verts.size(); k++) {
        brush_vert_c *v1 = A->verts[k];
        brush_vert_c *v2 = A->verts[(k + 1) % A->verts.size()];

        float nx = (v2->y - v1->y);
        float ny = (v1->x - v2->x);

        DoAddBrushPlane(planes.data(), v1->x, v1->y, 0, nx, ny, 0);
    }

    // if some of our planes were not axial, we need to fill in
    // the missing axial planes.

    if (planes[0] < 0) {
        DoAddBrushPlane(planes.data(), A->min_x, 0, 0, -1, 0, 0);
    }
    SYS_ASSERT(planes[0] >= 0);

    if (planes[1] < 0) {
        DoAddBrushPlane(planes.data(), A->max_x, 0, 0, +1, 0, 0);
    }
    SYS_ASSERT(planes[1] >= 0);

    if (planes[2] < 0) {
        DoAddBrushPlane(planes.data(), 0, A->min_y, 0, 0, -1, 0);
    }
    SYS_ASSERT(planes[2] >= 0);

    if (planes[3] < 0) {
        DoAddBrushPlane(planes.data(), 0, A->max_y, 0, 0, +1, 0);
    }
    SYS_ASSERT(planes[3] >= 0);

    if (planes[4] < 0) {
        DoAddBrushPlane(planes.data(), 0, 0, A->b.z, 0, 0, -1);
    }
    SYS_ASSERT(planes[4] >= 0);

    if (planes[5] < 0) {
        DoAddBrushPlane(planes.data(), 0, 0, A->t.z, 0, 0, +1);
    }
    SYS_ASSERT(planes[5] >= 0);

    // write the planes
    for (i = 0; i < MAX_BRUSH_PLANES; i++) {
        if (planes[i] >= 0) {
            DoWriteBrushSide(planes[i], raw_brush.shaderNum);

            raw_brush.numSides++;
        }
    }

    SYS_ASSERT(raw_brush.numSides >= 6);

    // add the brush
    s32_t index = q3_brushes.size();

    brush_map[A] = index;

    DoWriteBrush(raw_brush);

    return index;
}

static void Q3_WriteBrushes() {
    qLump_c *lump = BSP_NewLump(LUMP_BRUSHES);

    lump->Append(&q3_brushes[0], q3_brushes.size() * sizeof(dbrush3_t));

    qLump_c *sides = BSP_NewLump(LUMP_BRUSHSIDES);

    sides->Append(&q3_brush_sides[0],
                  q3_brush_sides.size() * sizeof(dbrushside3_t));
}

//------------------------------------------------------------------------

static std::vector<dshader3_t> q3_shaders;

#define NUM_SHADER_HASH 128
static std::array<std::vector<int> *, NUM_SHADER_HASH> shader_hashtab;

static void Q3_ClearShaders(void) {
    q3_shaders.clear();

    for (int h = 0; h < NUM_SHADER_HASH; h++) {
        delete shader_hashtab[h];
        shader_hashtab[h] = NULL;
    }
}

s32_t Q3_AddShader(const char *texture, u32_t flags, u32_t contents) {
    if (!texture[0]) {
        texture = "error";
    }

    // create shader structure, fix endianness
    dshader3_t raw_tex;

    memset(&raw_tex, 0, sizeof(raw_tex));

    // add texture/ prefix to every texture
    std::string shader = fmt::format("textures/{}", texture);
    std::copy(shader.begin(), shader.end(), raw_tex.shader.begin());

    raw_tex.surfaceFlags = LE_U32(flags);
    raw_tex.contentFlags = LE_U32(contents);

    // find an existing shader in the hash table
    int hash = (int)StringHash(texture) & (NUM_SHADER_HASH - 1);

    SYS_ASSERT(hash >= 0);

    if (!shader_hashtab[hash]) {
        shader_hashtab[hash] = new std::vector<int>;
    }

    std::vector<int> *hashtab = shader_hashtab[hash];

    for (unsigned int i = 0; i < hashtab->size(); i++) {
        int index = (*hashtab)[i];

        SYS_ASSERT(index < (int)q3_shaders.size());

        // only check the shader name, ignore differences in flags
        if (memcmp(&raw_tex.shader, &q3_shaders[index].shader,
                   sizeof(raw_tex.shader)) == 0) {
            return index;  // found it
        }
    }

    // not found, so add new one
    s32_t new_index = q3_shaders.size();

    q3_shaders.push_back(raw_tex);

    hashtab->push_back(new_index);

    return new_index;
}

static void Q3_WriteShaders() {
    if (q3_shaders.size() >= MAX_MAP_SHADERS) {
        Main::FatalError("Quake3 build failure: exceeded limit of {} SHADERS\n",
                         MAX_MAP_SHADERS);
    }

    qLump_c *lump = BSP_NewLump(LUMP_SHADERS);

    lump->Append(&q3_shaders[0], q3_shaders.size() * sizeof(dshader3_t));
}

static void Q3_WriteFogs() { BSP_NewLump(LUMP_FOGS); }

//------------------------------------------------------------------------

static qLump_c *q3_leaf_surfs;  // LUMP_LEAFSURFACES
static qLump_c *q3_leaf_brushes;

static qLump_c *q3_leafs;
static qLump_c *q3_nodes;

static qLump_c *q3_surfaces;
static qLump_c *q3_drawverts;
static qLump_c *q3_indexes;

static qLump_c *q3_models;

static int q3_total_leaf_surfs;
static int q3_total_leaf_brushes;

static int q3_total_leafs;
static int q3_total_nodes;
static int q3_total_models;

static int q3_total_surfaces;
static int q3_total_drawverts;
static int q3_total_indexes;

static void Q3_FreeStuff() {
    Q3_ClearBrushes();
    Q3_ClearShaders();

    // bsp lumps are freed in q_common code

    q3_leaf_surfs = NULL;
    q3_leaf_brushes = NULL;

    q3_surfaces = NULL;
    q3_leafs = NULL;
    q3_nodes = NULL;
    q3_models = NULL;
}

static void Q3_WriteLeafBrush(csg_brush_c *B) {
    s32_t index = Q3_AddBrush(B);

    // fix endianness
    index = LE_S32(index);

    q3_leaf_brushes->Append(&index, sizeof(index));

    q3_total_leaf_brushes += 1;
}

static inline bool IsTriangleDegenerate(quake_face_c *face, int a, int b,
                                        int c) {
    // this logic is duplicated from q3map.c

    std::array<float, 3> d;
    std::array<float, 3> e;
    std::array<float, 3> f;

    d[0] = face->verts[b].x - face->verts[a].x;
    d[1] = face->verts[b].y - face->verts[a].y;
    d[2] = face->verts[b].z - face->verts[a].z;

    e[0] = face->verts[c].x - face->verts[a].x;
    e[1] = face->verts[c].y - face->verts[a].y;
    e[2] = face->verts[c].z - face->verts[a].z;

    // compute the cross-product
    f[0] = d[1] * e[2] - d[2] * e[1];
    f[1] = d[2] * e[0] - d[0] * e[2];
    f[2] = d[0] * e[1] - d[1] * e[0];

    float len_sqr = f[0] * f[0] + f[1] * f[1] + f[2] * f[2];

    return fabs(len_sqr) < 3.0;
}

static bool FaceHasDegenTriangle(quake_face_c *face) {
    int total_v = (int)face->verts.size();

    for (int i = 2; i < total_v; i++) {
        if (IsTriangleDegenerate(face, 0, i - 1, i)) {
            return true;
        }
    }

    return false;
}

static void Q3_CreateDrawVert(quake_face_c *face, quake_vertex_c *V,
                              ddrawvert3_t *out) {
    memset(out, 0, sizeof(ddrawvert3_t));

    out->xyz[0] = V->x;
    out->xyz[1] = V->y;
    out->xyz[2] = V->z;

    face->GetNormal(out->normal);

    out->st[0] = face->Calc_S(V);
    out->st[1] = face->Calc_T(V);

    if (face->lmap) {
        bool is_dark = face->lmap->isDark();

        if (is_dark) {
            // middle of the top-left 2x2 block
            out->lightmap[0] = 1.0 / 128.0;
            out->lightmap[1] = 1.0 / 128.0;
        } else {
            out->lightmap[0] = face->lmap->lm_mat->Calc_S(V->x, V->y, V->z);
            out->lightmap[1] = face->lmap->lm_mat->Calc_T(V->x, V->y, V->z);
        }

        // this is cruddy, but better than nothing
        // [ I don't plan to properly support vertex lighting mode ]
        rgb_color_t avg_col = face->lmap->CalcAverage();

        out->color[0] = RGB_RED(avg_col);
        out->color[1] = RGB_GREEN(avg_col);
        out->color[2] = RGB_BLUE(avg_col);
    }
}

static void Q3_AverageDrawVert(const ddrawvert3_t *in, int count,
                               ddrawvert3_t *out) {
    SYS_ASSERT(count >= 1);

    double sum_x = 0;
    double sum_y = 0;
    double sum_z = 0;

    double sum_s = 0;
    double sum_t = 0;

    double sum_lm0 = 0;
    double sum_lm1 = 0;

    int sum_r = 0;
    int sum_g = 0;
    int sum_b = 0;

    for (int i = 0; i < count; i++) {
        sum_x += in[i].xyz[0];
        sum_y += in[i].xyz[1];
        sum_z += in[i].xyz[2];

        sum_s += in[i].st[0];
        sum_t += in[i].st[1];

        sum_lm0 += in[i].lightmap[0];
        sum_lm1 += in[i].lightmap[1];

        sum_r += in[i].color[0];
        sum_g += in[i].color[1];
        sum_b += in[i].color[2];
    }

    out->xyz[0] = sum_x / (double)count;
    out->xyz[1] = sum_y / (double)count;
    out->xyz[2] = sum_z / (double)count;

    out->st[0] = sum_s / (double)count;
    out->st[1] = sum_t / (double)count;

    out->lightmap[0] = sum_lm0 / (double)count;
    out->lightmap[1] = sum_lm1 / (double)count;

    out->color[0] = sum_r / count;
    out->color[1] = sum_g / count;
    out->color[2] = sum_b / count;

    // assume normals are all the same
    out->normal[0] = in[0].normal[0];
    out->normal[1] = in[0].normal[1];
    out->normal[2] = in[0].normal[2];
}

static void Q3_WriteDrawVert(ddrawvert3_t *vert) {
    // fix endianness
    vert->xyz[0] = LE_Float32(vert->xyz[0]);
    vert->xyz[1] = LE_Float32(vert->xyz[1]);
    vert->xyz[2] = LE_Float32(vert->xyz[2]);

    vert->st[0] = LE_Float32(vert->st[0]);
    vert->st[1] = LE_Float32(vert->st[1]);

    vert->lightmap[0] = LE_Float32(vert->lightmap[0]);
    vert->lightmap[1] = LE_Float32(vert->lightmap[1]);

    vert->normal[0] = LE_Float32(vert->normal[0]);
    vert->normal[1] = LE_Float32(vert->normal[1]);
    vert->normal[2] = LE_Float32(vert->normal[2]);

    q3_drawverts->Append(vert, sizeof(ddrawvert3_t));

    q3_total_drawverts += 1;
}

static void Q3_WriteDrawIndex(int index) {
    SYS_ASSERT(index >= 0);

    // fix endianness
    s32_t raw_index = LE_S32(index);

    q3_indexes->Append(&raw_index, sizeof(raw_index));

    q3_total_indexes += 1;
}

static void Q3_TriangulateSurface(quake_face_c *face, dsurface3_t *raw_surf) {
    // check if any of the triangles would be degenerate.
    // if so, we must create a triangle fan using a new
    // vertex at the center of the surface.

    // TODO: this logic can be improved, e.g. a single degenerate
    //       triangle can be handled by using its middle vertex
    //       as the starting one.

    bool has_degen = FaceHasDegenTriangle(face);

    std::array<ddrawvert3_t, MAX_FACE_VERTS> raw_verts;

    raw_surf->firstVert = q3_total_drawverts;
    raw_surf->numVerts = (int)face->verts.size();

    if (raw_surf->numVerts + 2 > MAX_FACE_VERTS) {
        Main::FatalError("Quake3 build failure: face with more than {} verts\n",
                         MAX_FACE_VERTS);
    }

    // create the usual drawverts

    for (int i = 0; i < raw_surf->numVerts; i++) {
        Q3_CreateDrawVert(face, &face->verts[i], &raw_verts[i]);
    }

    if (has_degen) {
        // create a middle point
        Q3_AverageDrawVert(raw_verts.data(), raw_surf->numVerts,
                           &raw_verts[raw_surf->numVerts]);

        raw_surf->firstIndex = q3_total_indexes;

        for (int i = 0; i < raw_surf->numVerts; i++) {
            Q3_WriteDrawIndex(raw_surf->numVerts);
            Q3_WriteDrawIndex((i == 0) ? raw_surf->numVerts - 1 : (i - 1));
            Q3_WriteDrawIndex(i);

            raw_surf->numIndexes += 3;
        }

        raw_surf->numVerts++;
    } else {
        /* triangulate the polygon, produce indexes */

        // use the shared triangulation when possible
        if (face->verts.size() == 3) {
            raw_surf->firstIndex = 0;
            raw_surf->numIndexes = 3;
        } else if (face->verts.size() == 4) {
            raw_surf->firstIndex = 0;
            raw_surf->numIndexes = 6;
        } else {
            raw_surf->firstIndex = q3_total_indexes;

            for (int i = 2; i < raw_surf->numVerts; i++) {
                Q3_WriteDrawIndex(0);
                Q3_WriteDrawIndex(i - 1);
                Q3_WriteDrawIndex(i);

                raw_surf->numIndexes += 3;
            }
        }
    }

    // now write all the drawvert data

    for (int i = 0; i < raw_surf->numVerts; i++) {
        Q3_WriteDrawVert(&raw_verts[i]);
    }
}

static inline void DoWriteSurface(dsurface3_t &raw_surf) {
    // fix endianness
    raw_surf.shaderNum = LE_S32(raw_surf.shaderNum);
    raw_surf.fogNum = LE_S32(raw_surf.fogNum);
    raw_surf.surfaceType = LE_S32(raw_surf.surfaceType);

    raw_surf.firstVert = LE_S32(raw_surf.firstVert);
    raw_surf.numVerts = LE_S32(raw_surf.numVerts);

    raw_surf.firstIndex = LE_S32(raw_surf.firstIndex);
    raw_surf.numIndexes = LE_S32(raw_surf.numIndexes);

    raw_surf.lightmapNum = LE_S32(raw_surf.lightmapNum);

    // note: these four seem to never be used by the engine
    raw_surf.lightmapX = LE_S32(raw_surf.lightmapX);
    raw_surf.lightmapY = LE_S32(raw_surf.lightmapY);
    raw_surf.lightmapWidth = LE_S32(raw_surf.lightmapWidth);
    raw_surf.lightmapHeight = LE_S32(raw_surf.lightmapHeight);

    raw_surf.patchWidth = LE_S32(raw_surf.patchWidth);
    raw_surf.patchHeight = LE_S32(raw_surf.patchHeight);

    q3_surfaces->Append(&raw_surf, sizeof(raw_surf));

    q3_total_surfaces += 1;
}

static void Q3_AddSurface(quake_face_c *face) {
    // already added?
    if (face->index >= 0) {
        return;
    }

    face->index = q3_total_surfaces;

    const char *texture = face->texture.c_str();

    dsurface3_t raw_surf;

    memset(&raw_surf, 0, sizeof(raw_surf));

    raw_surf.fogNum = -1;
    raw_surf.surfaceType = MST_PLANAR;

    Q3_TriangulateSurface(face, &raw_surf);

    // lighting and texture...

    raw_surf.lightmapNum = LIGHTMAP_BY_VERTEX;

    if (face->lmap && face->lmap->offset >= 0) {
        raw_surf.lightmapNum = face->lmap->offset;
    }

    face->GetNormal(raw_surf.lightmapVecs[2]);

    // TODO : ability to specify flags and contents
    int flags = 0;
    int contents = CONTENTS_SOLID;

    if (strstr(texture, "skies/") != NULL) {
        flags |= SURF_NOIMPACT | SURF_NOMARKS | SURF_NOLIGHTMAP |
                 SURF_NODLIGHT | SURF_NOSTEPS;

    } else if (strstr(texture, "liquids/") != NULL) {
        flags |= SURF_NOIMPACT | SURF_NOMARKS | SURF_NOLIGHTMAP |
                 SURF_NODLIGHT | SURF_NOSTEPS;
    }

    raw_surf.shaderNum = Q3_AddShader(texture, flags, contents);

    DoWriteSurface(raw_surf);
}

static void Q3_WriteLeafSurf(int index) {
    SYS_ASSERT(index >= 0);

    // fix endianness
    s32_t raw_index = LE_S32(index);

    q3_leaf_surfs->Append(&raw_index, sizeof(raw_index));

    q3_total_leaf_surfs += 1;
}

static void DoWriteLeaf(dleaf3_t &raw_leaf) {
    // fix endianness
    raw_leaf.cluster = LE_S32(raw_leaf.cluster);
    raw_leaf.area = LE_S32(raw_leaf.area);

    raw_leaf.firstLeafSurface = LE_S32(raw_leaf.firstLeafSurface);
    raw_leaf.numLeafSurfaces = LE_S32(raw_leaf.numLeafSurfaces);

    raw_leaf.firstLeafBrush = LE_S32(raw_leaf.firstLeafBrush);
    raw_leaf.numLeafBrushes = LE_S32(raw_leaf.numLeafBrushes);

    for (int b = 0; b < 3; b++) {
        raw_leaf.mins[b] = LE_Float32(raw_leaf.mins[b]);
        raw_leaf.maxs[b] = LE_Float32(raw_leaf.maxs[b]);
    }

    q3_leafs->Append(&raw_leaf, sizeof(raw_leaf));

    q3_total_leafs += 1;
}

static void Q3_WriteLeaf(quake_leaf_c *leaf) {
    SYS_ASSERT(leaf->medium >= 0);
    SYS_ASSERT(leaf->medium <= MEDIUM_SOLID);

    SYS_ASSERT(leaf != qk_solid_leaf);

    dleaf3_t raw_leaf;

    memset(&raw_leaf, 0, sizeof(raw_leaf));

    if (leaf->medium == MEDIUM_SOLID) {
        raw_leaf.cluster = -1;
        raw_leaf.area = -1;
    } else {
        raw_leaf.cluster = leaf->cluster ? leaf->cluster->CalcID() : 0;
        raw_leaf.area = 0;
    }

    // create the 'mark surfs'

    // NOTE : currently surfaces are NEVER shared between leafs
    //        [ but the Q3 format allows this ]

    raw_leaf.firstLeafSurface = q3_total_leaf_surfs;
    raw_leaf.numLeafSurfaces = 0;

    for (unsigned int i = 0; i < leaf->faces.size(); i++) {
        Q3_AddSurface(leaf->faces[i]);

        Q3_WriteLeafSurf(leaf->faces[i]->index);

        raw_leaf.numLeafSurfaces += 1;
    }

    raw_leaf.firstLeafBrush = q3_total_leaf_brushes;
    raw_leaf.numLeafBrushes = 0;

    for (unsigned int k = 0; k < leaf->brushes.size(); k++) {
        Q3_WriteLeafBrush(leaf->brushes[k]);

        raw_leaf.numLeafBrushes += 1;
    }

    for (int b = 0; b < 3; b++) {
        raw_leaf.mins[b] = leaf->bbox.mins[b] - LEAF_PADDING;
        raw_leaf.maxs[b] = leaf->bbox.maxs[b] + LEAF_PADDING;
    }

    DoWriteLeaf(raw_leaf);
}

static void Q3_WriteDummyLeaf(void) {
    dleaf3_t raw_leaf;

    memset(&raw_leaf, 0, sizeof(raw_leaf));

    raw_leaf.cluster = LE_S32(-1);
    raw_leaf.area = LE_S32(-1);

    q3_leafs->Append(&raw_leaf, sizeof(raw_leaf));
}

static void DoWriteNode(dnode3_t &raw_node) {
    // fix endianness
    raw_node.planeNum = LE_S32(raw_node.planeNum);
    raw_node.children[0] = LE_S32(raw_node.children[0]);
    raw_node.children[1] = LE_S32(raw_node.children[1]);

    for (int b = 0; b < 3; b++) {
        raw_node.mins[b] = LE_S32(raw_node.mins[b]);
        raw_node.maxs[b] = LE_S32(raw_node.maxs[b]);
    }

    q3_nodes->Append(&raw_node, sizeof(raw_node));

    q3_total_nodes += 1;
}

static void Q3_WriteNode(quake_node_c *node) {
    dnode3_t raw_node;

    bool flipped;

    raw_node.planeNum = BSP_AddPlane(&node->plane, &flipped);

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

    for (int b = 0; b < 3; b++) {
        raw_node.mins[b] = (int)floor(node->bbox.mins[b] - NODE_PADDING);
        raw_node.maxs[b] = (int)ceil(node->bbox.maxs[b] + NODE_PADDING);
    }

    DoWriteNode(raw_node);

    // recurse now, AFTER adding the current node

    if (node->front_N) {
        Q3_WriteNode(node->front_N);
    } else {
        Q3_WriteLeaf(node->front_L);
    }

    if (node->back_N) {
        Q3_WriteNode(node->back_N);
    } else {
        Q3_WriteLeaf(node->back_L);
    }
}

static void Q3_WriteBSP() {
    q3_total_nodes = 0;
    q3_total_leafs = 0;  // not including the solid leaf
    q3_total_models = 0;

    q3_total_surfaces = 0;
    q3_total_drawverts = 0;
    q3_total_indexes = 0;

    q3_total_leaf_surfs = 0;
    q3_total_leaf_brushes = 0;

    q3_nodes = BSP_NewLump(LUMP_NODES);
    q3_leafs = BSP_NewLump(LUMP_LEAFS);

    q3_surfaces = BSP_NewLump(LUMP_SURFACES);
    q3_drawverts = BSP_NewLump(LUMP_DRAWVERTS);
    q3_indexes = BSP_NewLump(LUMP_DRAWINDEXES);

    q3_leaf_surfs = BSP_NewLump(LUMP_LEAFSURFACES);
    q3_leaf_brushes = BSP_NewLump(LUMP_LEAFBRUSHES);

    // create a triangulation for all non-degen quads
    Q3_WriteDrawIndex(0);
    Q3_WriteDrawIndex(1);
    Q3_WriteDrawIndex(2);

    Q3_WriteDrawIndex(0);
    Q3_WriteDrawIndex(2);
    Q3_WriteDrawIndex(3);

    // we create a unused leaf, like q3map2 does
    Q3_WriteDummyLeaf();

    Q3_WriteNode(qk_bsp_root);

    if (q3_total_surfaces >= MAX_MAP_DRAW_SURFS) {
        Main::FatalError(
            "Quake3 build failure: exceeded limit of {} DRAW_SURFS\n",
            MAX_MAP_DRAW_SURFS);
    }

    if (q3_total_leafs >= MAX_MAP_LEAFS) {
        Main::FatalError("Quake3 build failure: exceeded limit of {} LEAFS\n",
                         MAX_MAP_LEAFS);
    }

    if (q3_total_nodes >= MAX_MAP_NODES) {
        Main::FatalError("Quake3 build failure: exceeded limit of {} NODES\n",
                         MAX_MAP_NODES);
    }
}

//------------------------------------------------------------------------
//   MAP MODEL STUFF
//------------------------------------------------------------------------

static void Q3_WriteModel(dmodel3_t *model) {
    // fix endianness
    for (int b = 0; b < 3; b++) {
        model->mins[b] = LE_Float32(model->mins[b]);
        model->maxs[b] = LE_Float32(model->maxs[b]);
    }

    model->firstSurface = LE_S32(model->firstSurface);
    model->numSurfaces = LE_S32(model->numSurfaces);

    model->firstBrush = LE_S32(model->firstBrush);
    model->numBrushes = LE_S32(model->numBrushes);

    q3_models->Append(model, sizeof(dmodel3_t));

    q3_total_models += 1;
}

static void Q3_CreateSubModel(quake_leaf_c *L) {
    dmodel3_t raw_model;

    memset(&raw_model, 0, sizeof(raw_model));

    raw_model.firstSurface = q3_total_surfaces;
    raw_model.firstBrush = (int)q3_brushes.size();

    for (unsigned int i = 0; i < L->faces.size(); i++) {
        Q3_AddSurface(L->faces[i]);

        raw_model.numSurfaces += 1;
    }

    for (unsigned int k = 0; k < L->brushes.size(); k++) {
        Q3_AddBrush(L->brushes[k]);

        raw_model.numBrushes += 1;
    }

    // bounding box...
    for (int b = 0; b < 3; b++) {
        raw_model.mins[b] = L->bbox.mins[b];
        raw_model.maxs[b] = L->bbox.maxs[b];
    }

    // update the entity

    csg_entity_c *E = L->link_ent;
    SYS_ASSERT(E);

    // create the important "model" keyword
    std::string model_name = fmt::format("*{}", q3_total_models);

    E->props.Add("model", model_name.c_str());

    Q3_WriteModel(&raw_model);
}

static void Q3_WriteModels() {
    q3_models = BSP_NewLump(LUMP_MODELS);

    // create the world model
    dmodel3_t raw_model;

    memset(&raw_model, 0, sizeof(raw_model));

    raw_model.firstSurface = 0;
    raw_model.numSurfaces = q3_total_surfaces;

    raw_model.firstBrush = 0;
    raw_model.numBrushes = (int)q3_brushes.size();

    // bounds of map
    for (int b = 0; b < 3; b++) {
        raw_model.mins[b] = qk_bsp_root->bbox.mins[b];
        raw_model.maxs[b] = qk_bsp_root->bbox.maxs[b];
    }

    Q3_WriteModel(&raw_model);

    // handle all the sub-models (doors etc)

    for (unsigned int k = 0; k < qk_all_detail_models.size(); k++) {
        Q3_CreateSubModel(qk_all_detail_models[k]);
    }
}

//------------------------------------------------------------------------

static void Q3_SetGridLights() {
    // FIXME !!!

    // leaving LUMP_LIGHTGRID empty for now -- engine can cope
}

static void Q3_LightWorld() {
    if (main_win) {
        main_win->build_box->Prog_Step("Light");
    }

    QLIT_LightAllFaces();

    QLIT_BuildQ3Lighting(LUMP_LIGHTMAPS, MAX_MAP_LIGHTING);

    Q3_SetGridLights();
}

static void Q3_VisWorld() {
    if (main_win) {
        main_win->build_box->Prog_Step("Vis");
    }

    // Quake 3 uses clusters directly

    QVIS_Visibility(LUMP_VISIBILITY, MAX_MAP_VISIBILITY, 0);
}

static void AddCommonShaders() {
    // SHADER_COMMON_SOLID
    Q3_AddShader("common/solid", 0, CONTENTS_SOLID);

    // SHADER_COMMON_CLIP
    Q3_AddShader("common/clip",
                 SURF_NONSOLID | SURF_NODRAW | SURF_NOIMPACT | SURF_NOMARKS |
                     SURF_NOLIGHTMAP | SURF_NODLIGHT,
                 CONTENTS_PLAYERCLIP);

    // SHADER_COMMON_SKY
    Q3_AddShader("common/sky",
                 SURF_NOIMPACT | SURF_NOMARKS | SURF_NOLIGHTMAP | SURF_NODLIGHT,
                 CONTENTS_SOLID);

    // SHADER_COMMON_TRIGGER
    Q3_AddShader("common/trigger",
                 SURF_NODRAW | SURF_NOMARKS | SURF_NOLIGHTMAP | SURF_NODLIGHT,
                 CONTENTS_TRIGGER);

    int liquid_flags = SURF_NOIMPACT | SURF_NOMARKS | SURF_NOLIGHTMAP |
                       SURF_NODLIGHT | SURF_NOSTEPS;

    // SHADER_COMMON_WATER
    Q3_AddShader(water_shader.c_str(), liquid_flags, CONTENTS_WATER);

    // SHADER_COMMON_SLIME
    Q3_AddShader(slime_shader.c_str(), liquid_flags, CONTENTS_SLIME);

    // SHADER_COMMON_LAVA
    Q3_AddShader(lava_shader.c_str(), liquid_flags, CONTENTS_LAVA);
}

static void Q3_CreateBSPFile(const char *name) {
    BSP_OpenLevel(name);

    CSG_QUAKE_Build();

    int num_node = 0;
    int num_leaf = 0;

    CSG_AssignIndexes(qk_bsp_root, &num_node, &num_leaf);

    QCOM_Fix_T_Junctions();

    Q3_VisWorld();
    Q3_LightWorld();

    // standard shaders (for collision brushes)
    AddCommonShaders();

    Q3_WriteBSP();
    Q3_WriteModels();

    BSP_WritePlanes(LUMP_PLANES, MAX_MAP_PLANES);

    Q3_WriteBrushes();
    Q3_WriteShaders();
    Q3_WriteFogs();

    BSP_WriteEntities(LUMP_ENTITIES, description.c_str());

    // this will free lots of stuff (lightmaps etc)
    BSP_CloseLevel();

    CSG_QUAKE_Free();

    Q3_FreeStuff();
}

static void DP_CreateRTLights(const char *entry_in_pak) {
    // we don't create the file when there are no RT lights
    bool has_file = false;

    static std::string buffer;

    for (unsigned int i = 0; i < all_entities.size(); i++) {
        csg_entity_c *E = all_entities[i];

        if (strcmp(E->id.c_str(), "oblige_rtlight") != 0) {
            continue;
        }

        if (!has_file) {
            ZIPF_NewLump(entry_in_pak);
            has_file = true;
        }

        if (E->props.getInt("noshadow") > 0) {
            ZIPF_AppendData("!", 1);
        }

        rgb_color_t color = QLIT_ParseColorString(E->props.getStr("color"));

        double r = E->props.getDouble("r", RGB_RED(color) / 255.0);
        double g = E->props.getDouble("g", RGB_GREEN(color) / 255.0);
        double b = E->props.getDouble("b", RGB_BLUE(color) / 255.0);

        buffer = fmt::format(
            "{:1.3} {:1.3} {:1.3} {:1.3} {:1.5} {:1.5} {:1.5} {}\n", E->x, E->y,
            E->z, E->props.getDouble("radius", RT_DEFAULT_RADIUS), r, g, b,
            E->props.getInt("style", 0));

        ZIPF_AppendData(buffer.c_str(), buffer.size());
    }

    if (has_file) {
        ZIPF_FinishLump();
    }
}

//------------------------------------------------------------------------

class quake3_game_interface_c : public game_interface_c {
   private:
    std::filesystem::path filename;

   public:
    quake3_game_interface_c() : filename(NULL) {}

    ~quake3_game_interface_c() {}

    bool Start(const char *preset);
    bool Finish(bool build_ok);

    void BeginLevel();
    void EndLevel();
    void Property(std::string key, std::string value);
};

bool quake3_game_interface_c::Start(const char *preset) {
    qk_game = 3;
    qk_sub_format = 0;

    CLUSTER_SIZE = 128.0;

    QLIT_InitProperties();

    q3_default_tex_scale = 1.0 / 128.0;

    // this is not used here
    qk_world_model = NULL;

    if (water_shader.empty()) {
        water_shader = "liquids/water";
    }
    if (slime_shader.empty()) {
        slime_shader = "liquids/slime";
    }
    if (lava_shader.empty()) {
        lava_shader = "liquids/lava";
    }

    if (batch_mode) {
        filename = batch_output_file;
    } else {
        filename = DLG_OutputFilename("pk3");
    }

    if (filename.empty()) {
        Main::ProgStatus(_("Cancelled"));
        return false;
    }

    if (create_backups) {
        Main::BackupFile(filename, "old");
    }

    if (!ZIPF_OpenWrite(filename)) {
        Main::ProgStatus(_("Error (create file)"));
        return false;
    }

    BSP_AddInfoFile();

    if (main_win) {
        main_win->build_box->Prog_Init(0, "CSG,BSP,Vis,Light");
    }

    return true;
}

bool quake3_game_interface_c::Finish(bool build_ok) {
    ZIPF_CloseWrite();

    // remove the file if an error occurred
    if (!build_ok) {
        std::filesystem::remove(filename);
    } else {
        Recent_AddFile(RECG_Output, filename.c_str());
    }

    return build_ok;
}

void quake3_game_interface_c::BeginLevel() {
    level_name.clear();
    description.clear();

    Q3_FreeStuff();

    CSG_QUAKE_Free();
}

void quake3_game_interface_c::Property(std::string key, std::string value) {
    if (StringCaseCmp(key, "level_name") == 0) {
        level_name = value.c_str();
    } else if (StringCaseCmp(key, "description") == 0) {
        description = value.c_str();
    } else if (StringCaseCmp(key, "default_tex_scale") == 0) {
        q3_default_tex_scale = StringToDouble(value);
    } else if (StringCaseCmp(key, "water_shader") == 0) {
        water_shader = value.c_str();
    } else if (StringCaseCmp(key, "slime_shader") == 0) {
        slime_shader = value.c_str();
    } else if (StringCaseCmp(key, "lava_shader") == 0) {
        lava_shader = value.c_str();
    } else {
        LogPrintf("WARNING: unknown QUAKE3 property: {}={}\n", key, value);
    }
}

void quake3_game_interface_c::EndLevel() {
    if (level_name.empty()) {
        Main::FatalError("Script problem: did not set level name!\n");
    }

    if (level_name.size() >= 32) {
        Main::FatalError("Script problem: level name too long: {}\n",
                         level_name);
    }

    std::string entry_in_pak = fmt::format("maps/{}.bsp", level_name);

    Q3_CreateBSPFile(entry_in_pak.c_str());

    entry_in_pak = fmt::format("maps/{}.rtlights", level_name);

    DP_CreateRTLights(entry_in_pak.c_str());
}

game_interface_c *Quake3_GameObject(void) {
    return new quake3_game_interface_c();
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
