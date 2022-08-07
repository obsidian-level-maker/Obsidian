//------------------------------------------------------------------------
//  BSP files - Quake I, II and III
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

#include "q_common.h"

#include <algorithm>

#include "csg_main.h"
#include "csg_quake.h"
#include "fmt/format.h"
#include "hdr_lua.h"
#include "headers.h"
#include "lib_file.h"
#include "lib_pak.h"
#include "lib_util.h"
#include "lib_zip.h"
#include "m_lua.h"
#include "main.h"
#include "q_light.h"
#include "q_vis.h"

#define HL_BSP_VERSION 30

int qk_game;
int qk_sub_format;
int qk_worldtype;

qLump_c::qLump_c() : buffer(), crlf(false) {}

qLump_c::~qLump_c() {}

int qLump_c::GetSize() const { return (int)buffer.size(); }

const u8_t *qLump_c::GetBuffer() const {
    return buffer.empty() ? nullptr : &buffer[0];
}

void qLump_c::Append(const void *data, u32_t len) {
    if (len == 0) {
        return;
    }

    u32_t old_size = buffer.size();
    u32_t new_size = old_size + len;

    buffer.resize(new_size);

    memcpy(&buffer[old_size], data, len);
}

void qLump_c::Append(qLump_c *other) {
    if (other->buffer.size() > 0) {
        Append(&other->buffer[0], other->buffer.size());
    }
}

void qLump_c::Prepend(const void *data, u32_t len) {
    if (len == 0) {
        return;
    }

    u32_t old_size = buffer.size();
    u32_t new_size = old_size + len;

    buffer.resize(new_size);

    if (old_size > 0) {
        memmove(&buffer[len], &buffer[0], old_size);
    }
    memcpy(&buffer[0], data, len);
}

void qLump_c::AddByte(byte value) { Append(&value, 1); }

void qLump_c::RawPrintf(const char *str) {
    if (!crlf) {
        Append(str, strlen(str));
        return;
    }

    // convert each newline into CR/LF pair
    while (*str) {
        const char *next = strchr(str, '\n');

        Append(str, next ? (next - str) : strlen(str));

        if (!next) {
            break;
        }

        Append("\r\n", 2);

        str = next + 1;
    }
}

void qLump_c::Printf(const char *str, ...) {
    static char msg_buf[MSG_BUF_LEN];

    va_list args;

    va_start(args, str);
    vsnprintf(msg_buf, MSG_BUF_LEN - 1, str, args);
    va_end(args);

    msg_buf[MSG_BUF_LEN - 2] = 0;

    RawPrintf(msg_buf);
}

void qLump_c::KeyPair(const char *key, const char *val, ...) {
    static char v_buffer[MSG_BUF_LEN];

    va_list args;

    va_start(args, val);
    vsnprintf(v_buffer, MSG_BUF_LEN - 1, val, args);
    va_end(args);

    v_buffer[MSG_BUF_LEN - 2] = 0;

    RawPrintf("\"");
    RawPrintf(key);
    RawPrintf("\" \"");
    RawPrintf(v_buffer);
    RawPrintf("\"\n");
}

void qLump_c::SetCRLF(bool enable) { crlf = enable; }

//------------------------------------------------------------------------

#define PLANE_HASH_SIZE 128

static std::vector<dplane_t> bsp_planes;

static std::vector<int> *plane_hashtab[PLANE_HASH_SIZE];

static void BSP_ClearPlanes() {
    bsp_planes.clear();

    for (int h = 0; h < PLANE_HASH_SIZE; h++) {
        delete plane_hashtab[h];
        plane_hashtab[h] = NULL;
    }
}

static void BSP_PreparePlanes() { BSP_ClearPlanes(); }

static u16_t AddRawPlane(const dplane_t *plane, bool *was_new) {
    // copy it
    dplane_t raw_plane;

    memcpy(&raw_plane, plane, sizeof(dplane_t));

    // never use negative zero (minus zero) in normals
    // [ this prevents duplicate planes ]
    if (raw_plane.normal[0] == -0.0f) {
        raw_plane.normal[0] = +0.0f;
    }
    if (raw_plane.normal[1] == -0.0f) {
        raw_plane.normal[1] = +0.0f;
    }
    if (raw_plane.normal[2] == -0.0f) {
        raw_plane.normal[2] = +0.0f;
    }

    if (raw_plane.dist == -0.0f) {
        raw_plane.dist = +0.0f;
    }

    int hash = I_ROUND(raw_plane.dist * 1.1);

    hash = hash & (PLANE_HASH_SIZE - 1);

    // fix endianness
    raw_plane.normal[0] = LE_Float32(raw_plane.normal[0]);
    raw_plane.normal[1] = LE_Float32(raw_plane.normal[1]);
    raw_plane.normal[2] = LE_Float32(raw_plane.normal[2]);

    raw_plane.dist = LE_Float32(raw_plane.dist);
    raw_plane.type = LE_S32(raw_plane.type);

    // look for it in hash table...

    *was_new = false;

    if (!plane_hashtab[hash]) {
        plane_hashtab[hash] = new std::vector<int>;
    }

    std::vector<int> *hashtab = plane_hashtab[hash];

    for (unsigned int i = 0; i < hashtab->size(); i++) {
        int index = (*hashtab)[i];

        SYS_ASSERT(index < (int)bsp_planes.size());

        if (memcmp(&raw_plane, &bsp_planes[index], sizeof(raw_plane)) == 0) {
            return index;  // found it
        }
    }

    // not found, so add new one...

    u16_t new_index = bsp_planes.size();

    bsp_planes.push_back(raw_plane);

    hashtab->push_back(new_index);

#if 0  // DEBUG
fprintf(stderr, "ADDED PLANE #%d : %08x %08x %08x d:%08x tp:%08x\n",
(int)new_index,
*(u32_t *) &raw_plane.normal[0],
*(u32_t *) &raw_plane.normal[1],
*(u32_t *) &raw_plane.normal[2],
*(u32_t *) &raw_plane.dist,
(u32_t)     raw_plane.type);
#endif

    *was_new = true;

    return new_index;
}

u16_t BSP_AddPlane(float x, float y, float z, float nx, float ny, float nz,
                   bool *flip_var) {
    // NOTE: flip_var is only needed for Quake 1 / Hexen 2

    bool did_flip = false;

    double len = sqrt(nx * nx + ny * ny + nz * nz);

    SYS_ASSERT(len > 0);

    nx /= len;
    ny /= len;
    nz /= len;

    float ax = fabs(nx);
    float ay = fabs(ny);
    float az = fabs(nz);

    // flip plane to make major axis positive
    if ((-nx >= MAX(ay, az)) || (-ny >= MAX(ax, az)) || (-nz >= MAX(ax, ay))) {
        did_flip = true;

        nx = -nx;
        ny = -ny;
        nz = -nz;
    }

    // create plane structure
    dplane_t raw_plane;

    raw_plane.normal[0] = nx;
    raw_plane.normal[1] = ny;
    raw_plane.normal[2] = nz;

    // distance to the origin (0,0,0)
    raw_plane.dist = (x * nx + y * ny + z * nz);

    // determine 'type' field
    if (ax > 0.999) {
        raw_plane.type = PLANE_X;
    } else if (ay > 0.999) {
        raw_plane.type = PLANE_Y;
    } else if (az > 0.999) {
        raw_plane.type = PLANE_Z;
    } else if (ax >= MAX(ay, az)) {
        raw_plane.type = PLANE_ANYX;
    } else if (ay >= MAX(ax, az)) {
        raw_plane.type = PLANE_ANYY;
    } else {
        raw_plane.type = PLANE_ANYZ;
    }

    bool was_new;

    u16_t plane_idx = AddRawPlane(&raw_plane, &was_new);

    // Quake2/3 have pairs of planes (opposite directions)

    if (was_new && (qk_game >= 2 || qk_sub_format == SUBFMT_HalfLife)) {
        raw_plane.normal[0] = -nx;
        raw_plane.normal[1] = -ny;
        raw_plane.normal[2] = -nz;

        raw_plane.dist = -raw_plane.dist;

        AddRawPlane(&raw_plane, &was_new);
    }

    if (flip_var) {
        *flip_var = did_flip;
    }

    return plane_idx;
}

u16_t BSP_AddPlane(const quake_plane_c *P, bool *flip_var) {
    // NOTE: flip_var is only needed for Quake 1 / Hexen 2

    return BSP_AddPlane(P->x, P->y, P->z, P->nx, P->ny, P->nz, flip_var);
}

void BSP_WritePlanes(int lump_num, int max_planes) {
    qLump_c *lump = BSP_NewLump(lump_num);

    if (qk_game != 3) {
        lump->Append(&bsp_planes[0], bsp_planes.size() * sizeof(dplane_t));
    } else  // Quake 3 has simpler structure
    {
        for (unsigned int i = 0; i < bsp_planes.size(); i++) {
            dplane3_t pl;

            pl.normal[0] = bsp_planes[i].normal[0];
            pl.normal[1] = bsp_planes[i].normal[1];
            pl.normal[2] = bsp_planes[i].normal[2];
            pl.dist = bsp_planes[i].dist;

            lump->Append(&pl, sizeof(pl));
        }
    }

    if (lump->GetSize() >= max_planes) {
        Main::FatalError("Quake build failure: exceeded limit of {} PLANES\n",
                         max_planes);
    }

    BSP_ClearPlanes();
}

//------------------------------------------------------------------------

#define VERTEX_HASH_SIZE 512

static std::vector<dvertex_t> bsp_vertices;

static std::vector<int> *vert_hashtab[VERTEX_HASH_SIZE];

static void BSP_ClearVertices() {
    bsp_vertices.clear();

    for (int h = 0; h < VERTEX_HASH_SIZE; h++) {
        delete vert_hashtab[h];
        vert_hashtab[h] = NULL;
    }
}

static void BSP_PrepareVertices() {
    BSP_ClearVertices();

    // insert dummy vertex #0
    dvertex_t dummy;
    memset(&dummy, 0, sizeof(dummy));

    bsp_vertices.push_back(dummy);
}

u16_t BSP_AddVertex(float x, float y, float z) {
    int hash = I_ROUND(x * 1.1);

    hash = hash & (VERTEX_HASH_SIZE - 1);

    // create on-disk vertex, fixing endianness
    dvertex_t raw_vert;

    raw_vert.x = LE_Float32(x);
    raw_vert.y = LE_Float32(y);
    raw_vert.z = LE_Float32(z);

    // find existing vertex...
    // for speed we use a hash-table

    if (!vert_hashtab[hash]) {
        vert_hashtab[hash] = new std::vector<int>;
    }

    std::vector<int> *hashtab = vert_hashtab[hash];

    for (unsigned int i = 0; i < hashtab->size(); i++) {
        int index = (*hashtab)[i];

        if (memcmp(&raw_vert, &bsp_vertices[index], sizeof(raw_vert)) == 0) {
            return index;  // found it!
        }
    }

    // not found, so add new one...

    u16_t new_index = bsp_vertices.size();

    bsp_vertices.push_back(raw_vert);

    hashtab->push_back(new_index);

    return new_index;
}

u16_t BSP_AddVertex(const quake_vertex_c *V) {
    return BSP_AddVertex(V->x, V->y, V->z);
}

void BSP_WriteVertices(int lump_num, int max_verts) {
    if ((int)bsp_vertices.size() >= max_verts) {
        Main::FatalError("Quake build failure: exceeded limit of {} VERTEXES\n",
                         max_verts);
    }

    qLump_c *lump = BSP_NewLump(lump_num);

    lump->Append(&bsp_vertices[0], bsp_vertices.size() * sizeof(dvertex_t));

    BSP_ClearVertices();
}

//------------------------------------------------------------------------

static std::vector<dedge_t> bsp_edges;

static std::map<u32_t, s32_t> bsp_edge_map;

static void BSP_ClearEdges() {
    bsp_edges.clear();
    bsp_edge_map.clear();
}

static void BSP_PrepareEdges() {
    BSP_ClearEdges();

    // insert dummy edge #0
    dedge_t dummy;
    memset(&dummy, 0, sizeof(dummy));

    bsp_edges.push_back(dummy);
}

s32_t BSP_AddEdge(u16_t start, u16_t end) {
    bool flipped = false;

    if (start > end) {
        std::swap(start, end);

        flipped = true;
    }

    // find existing edge...
    u32_t key = (u32_t)start + (u32_t)(end << 16);

    if (bsp_edge_map.find(key) != bsp_edge_map.end()) {
        return bsp_edge_map[key] * (flipped ? -1 : 1);
    }

    // not found, so add new one...
    dedge_t raw_edge;

    raw_edge.v[0] = LE_U16(start);
    raw_edge.v[1] = LE_U16(end);

    int new_index = (int)bsp_edges.size();

    bsp_edges.push_back(raw_edge);

    bsp_edge_map[key] = new_index;

    return flipped ? -new_index : new_index;
}

void BSP_WriteEdges(int lump_num, int max_edges) {
    if ((int)bsp_edges.size() >= max_edges) {
        Main::FatalError("Quake build failure: exceeded limit of {} EDGES\n",
                         max_edges);
    }

    qLump_c *lump = BSP_NewLump(lump_num);

    lump->Append(&bsp_edges[0], bsp_edges.size() * sizeof(dedge_t));

    BSP_ClearEdges();
}

//------------------------------------------------------------------------

#define HEADER_LUMP_MAX 32

static int bsp_numlumps;
static int bsp_version;

static qLump_c *bsp_directory[HEADER_LUMP_MAX];

static void BSP_ClearLumps(void) {
    for (int i = 0; i < bsp_numlumps; i++) {
        if (bsp_directory[i]) {
            delete bsp_directory[i];
            bsp_directory[i] = NULL;
        }
    }
}

static void BSP_WriteLump(qLump_c *lump) {
    SYS_ASSERT(lump);

    int len = lump->GetSize();

    if (len == 0) {
        return;
    }

    if (qk_game == 3) {
        ZIPF_AppendData(lump->GetBuffer(), len);

        // no need for padding in PK3 files
        return;
    }

    PAK_AppendData(lump->GetBuffer(), len);

    // pad lumps to a multiple of four bytes
    u32_t padding = ALIGN_LEN(len) - len;

    SYS_ASSERT(0 <= padding && padding <= 3);

    if (padding > 0) {
        static u8_t zeros[4] = {0, 0, 0, 0};

        PAK_AppendData(zeros, padding);
    }
}

bool BSP_OpenLevel(const char *entry_in_pak) {
    // assumes that PAK_OpenWrite() has already been called.

    // begin the .BSP file
    if (qk_game == 3) {
        ZIPF_NewLump(entry_in_pak);
    } else {
        PAK_NewLump(entry_in_pak);
    }

    switch (qk_game) {
        case 1:
            bsp_version = Q1_BSP_VERSION;
            bsp_numlumps = Q1_HEADER_LUMPS;

            if (qk_sub_format == SUBFMT_HalfLife) {
                bsp_version = HL_BSP_VERSION;
            }
            break;

        case 2:
            bsp_version = Q2_BSP_VERSION;
            bsp_numlumps = Q2_HEADER_LUMPS;
            break;

        case 3:
            bsp_version = Q3_BSP_VERSION;
            bsp_numlumps = Q3_HEADER_LUMPS;
            break;

        default:
            Main::FatalError("INTERNAL ERROR: invalid qk_game {}\n", qk_game);
    }

    BSP_ClearLumps();

    BSP_PreparePlanes();
    BSP_PrepareVertices();
    BSP_PrepareEdges();

    QLIT_FreeLightmaps();

    return true;
}

static void BSP_WriteHeader() {
    u32_t offset = 0;

    if (qk_game == 2) {
        PAK_AppendData(Q2_IDENT_MAGIC, 4);
        offset += 4;
    } else if (qk_game == 3) {
        ZIPF_AppendData(Q3_IDENT_MAGIC, 4);
        offset += 4;
    }

    s32_t raw_version = LE_S32(bsp_version);

    if (qk_game == 3) {
        ZIPF_AppendData(&raw_version, 4);
    } else {
        PAK_AppendData(&raw_version, 4);
    }

    offset += 4;

    offset += sizeof(lump_t) * bsp_numlumps;

    for (int i = 0; i < bsp_numlumps; i++) {
        lump_t raw_info;

        // handle missing lumps : create an empty one
        if (!bsp_directory[i]) {
            bsp_directory[i] = new qLump_c();
        }

        u32_t length = bsp_directory[i]->GetSize();

        raw_info.start = LE_U32(offset);
        raw_info.length = LE_U32(length);

        if (qk_game == 3) {
            ZIPF_AppendData(&raw_info, sizeof(raw_info));

            offset += (u32_t)length;
        } else {
            PAK_AppendData(&raw_info, sizeof(raw_info));

            offset += (u32_t)ALIGN_LEN(length);
        }
    }
}

static csg_entity_c *FindObligeWorldspawn() {
    for (unsigned int k = 0; k < all_entities.size(); k++) {
        csg_entity_c *E = all_entities[k];

        if (strcmp(E->id.c_str(), "oblige_worldspawn") == 0) {
            return E;
        }
    }

    return NULL;
}

void BSP_WriteEntities(int lump_num, const char *description) {
    qLump_c *lump = BSP_NewLump(lump_num);

    /* add the worldspawn entity */

    lump->Printf("{\n");

    if (qk_game >= 3) {
        std::string obsidian_version_string =
            fmt::format("OBSIDIAN {} \"{}\" Build {}", OBSIDIAN_SHORT_VERSION,
                        OBSIDIAN_CODE_NAME, OBSIDIAN_VERSION);
        lump->KeyPair("_generated_by", obsidian_version_string.c_str());
    } else if (description) {
        lump->KeyPair("message", description);
    }

    // TODO : do this via oblige_worldspawn entity
    if (qk_game == 1) {
        std::string buffer = fmt::format("{}", qk_worldtype);

        lump->KeyPair("worldtype", buffer.c_str());
    }

#if 0  // REMOVE THIS, let Lua code supply these values
    if (qk_sub_format == SUBFMT_HalfLife)
    {
        lump->KeyPair("wad", "\\sierra\\half-life\\valve\\halflife.wad;");
        lump->KeyPair("mapversion", "220");
        lump->KeyPair("MaxRange", "4096");
        lump->KeyPair("sounds", "1");
    }
#endif

    csg_entity_c *ob_world = FindObligeWorldspawn();

    csg_property_set_c::iterator PI;

    if (ob_world) {
        for (PI = ob_world->props.begin(); PI != ob_world->props.end(); PI++) {
            lump->KeyPair(PI->first.c_str(), "%s", PI->second.c_str());
        }
    }

    lump->KeyPair("classname", "worldspawn");

    lump->Printf("}\n");

    // add everything else

    for (unsigned int i = 0; i < all_entities.size(); i++) {
        csg_entity_c *E = all_entities[i];

        const char *name = E->id.c_str();

        // this is mainly to skip broken map-models
        if (strcmp(name, "nothing") == 0) {
            continue;
        }

        // skip special (Oblige only) entities
        if (strncmp(name, "oblige_", 7) == 0) {
            continue;
        }

        // skip light entities for Quake3
        if (qk_game == 3 && strcmp(name, "light") == 0) {
            continue;
        }

        lump->Printf("{\n");

        // write entity properties
        for (PI = E->props.begin(); PI != E->props.end(); PI++) {
            lump->KeyPair(PI->first.c_str(), "%s", PI->second.c_str());
        }

        // skip origin when same as default value
        if ((I_ROUND(E->x) | I_ROUND(E->y) | I_ROUND(E->z)) != 0) {
            lump->KeyPair("origin", "%1.1f %1.1f %1.1f", E->x, E->y, E->z);
        }

        lump->KeyPair("classname", name);

        lump->Printf("}\n");
    }

    // add a trailing nul
    u8_t zero = 0;

    lump->Append(&zero, 1);
}

bool BSP_CloseLevel() {
    BSP_WriteHeader();

    for (int i = 0; i < bsp_numlumps; i++) {
        BSP_WriteLump(bsp_directory[i]);
    }

    // finish the .BSP file
    if (qk_game == 3) {
        ZIPF_FinishLump();
    } else {
        PAK_FinishLump();
    }

    // free all the memory
    BSP_ClearLumps();

    QLIT_FreeLightmaps();
    QVIS_FreeClusters();

    return true;
}

qLump_c *BSP_NewLump(int entry) {
    SYS_ASSERT(0 <= entry && entry < bsp_numlumps);

    if (bsp_directory[entry] != NULL) {
        Main::FatalError(
            "INTERNAL ERROR: BSP_NewLump: already created entry [{}]\n", entry);
    }

    bsp_directory[entry] = new qLump_c;

    return bsp_directory[entry];
}

qLump_c *BSP_CreateInfoLump() {
    qLump_c *L = new qLump_c();

    L->SetCRLF(true);

    L->Printf("\n");
    L->Printf("-- Levels created by OBSIDIAN %s \"%s\"\n",
              OBSIDIAN_SHORT_VERSION, OBSIDIAN_CODE_NAME.c_str());
    L->Printf("-- Build %s\n", OBSIDIAN_VERSION);
    L->Printf(
        "-- Based on the OBLIGE Level Maker (C) 2006-2017 Andrew Apted\n");
    L->Printf("-- %s\n", OBSIDIAN_WEBSITE);
    L->Printf("\n");

    std::vector<std::string> lines;

    ob_read_all_config(&lines, false /* need_full */);

    for (unsigned int i = 0; i < lines.size(); i++) {
        L->Printf("%s\n", lines[i].c_str());
    }

    L->Printf("\n\n\n");

    // terminate lump with ^Z and a NUL character
    static const byte terminator[2] = {26, 0};

    L->Append(terminator, 2);

    return L;
}

void BSP_AddInfoFile() {
    qLump_c *info = BSP_CreateInfoLump();

    if (qk_game == 3) {
        ZIPF_NewLump("oblige_dat.txt");
        BSP_WriteLump(info);
        ZIPF_FinishLump();
    } else {
        PAK_NewLump("oblige_dat.txt");
        BSP_WriteLump(info);
        PAK_FinishLump();
    }

    delete info;
}

//------------------------------------------------------------------------

int BSP_NiceMidwayPoint(float low, float extent) {
    int pow2 = 1;

    while (pow2 < extent / 7) {
        pow2 = pow2 << 1;
    }

    int mid = I_ROUND((low + extent / 2.0f) / pow2) * pow2;

    return mid;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
