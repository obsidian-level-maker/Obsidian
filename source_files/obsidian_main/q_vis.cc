//------------------------------------------------------------------------
//  QUAKE VISIBILITY and TRACING
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2010-2017 Andrew Apted
//  Copyright (C) 2005-2006 Peter Brett
//  Copyright (C) 1994-2001 iD Software
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
//
//  Tracing stuff based on Quake II lighting tool : q2rad/trace.c
//
//------------------------------------------------------------------------

#include "q_vis.h"

#include "csg_main.h"
#include "csg_quake.h"
#include "headers.h"

#include "lib_util.h"
#include "main.h"
#include "q_common.h"
#include "q_light.h"
#include "vis_buffer.h"

//------------------------------------------------------------------------
//  RAY TRACING
//------------------------------------------------------------------------

#define T_EPSILON 0.1

#define PLANE_OTHER -1

#define TRACE_EMPTY -1
#define TRACE_SOLID -2
#define TRACE_SKY -3

typedef struct {
    int type;  // PLANE_X .. PLANE_Z
    float normal[3];
    float dist;

    int children[2];  // tnode index, or TRACE_XXX value
} tnode_t;

static tnode_t *trace_nodes;

static int ConvertTraceLeaf(quake_leaf_c *leaf) {
    if (leaf->medium != MEDIUM_SOLID) {
        return TRACE_EMPTY;
    }

    // look for sky ceiling, require all brushes to be "sky"
    if (leaf->brushes.size() > 0) {
        for (unsigned int k = 0; k < leaf->brushes.size(); k++) {
            if (!(leaf->brushes[k]->bflags & BFLAG_Sky)) {
                return TRACE_SOLID;
            }
        }

        return TRACE_SKY;
    }

    return TRACE_SOLID;
}

static int ConvertTraceNode(quake_node_c *node, int &index_var) {
    int this_idx = index_var;

    tnode_t *TN = &trace_nodes[index_var];

    index_var += 1;

    float nx = node->plane.nx;
    float ny = node->plane.ny;
    float nz = node->plane.nz;

    float fx = fabs(nx);
    float fy = fabs(ny);
    float fz = fabs(nz);

    TN->normal[0] = nx;
    TN->normal[1] = ny;
    TN->normal[2] = nz;

    TN->dist = node->plane.CalcDist();

    int side = 0;

    // ensure tnode planes are positive
    if ((-nx >= MAX(fy, fz)) || (-ny >= MAX(fx, fz)) || (-nz >= MAX(fx, fy))) {
        side = 1;

        TN->normal[0] = -nx;
        TN->normal[1] = -ny;
        TN->normal[2] = -nz;

        TN->dist = -TN->dist;
    }

    if (fx > 0.9999) {
        TN->type = PLANE_X;
    } else if (fy > 0.9999) {
        TN->type = PLANE_Y;
    } else if (fz > 0.9999) {
        TN->type = PLANE_Z;
    } else {
        TN->type = PLANE_OTHER;
    }

    if (node->front_N) {
        TN->children[side] = ConvertTraceNode(node->front_N, index_var);
    } else {
        TN->children[side] = ConvertTraceLeaf(node->front_L);
    }

    side ^= 1;

    if (node->back_N) {
        TN->children[side] = ConvertTraceNode(node->back_N, index_var);
    } else {
        TN->children[side] = ConvertTraceLeaf(node->back_L);
    }

    return this_idx;
}

void QVIS_MakeTraceNodes() {
    int total = qk_bsp_root->CountNodes();

    trace_nodes = new tnode_t[total];

    int cur_node = 0;

    ConvertTraceNode(qk_bsp_root, cur_node);
}

void QVIS_FreeTraceNodes() {
    if (trace_nodes) {
        delete[] trace_nodes;
        trace_nodes = NULL;
    }
}

static int RecursiveTestRay(int nodenum, float x1, float y1, float z1, float x2,
                            float y2, float z2) {
    for (;;) {
        if (nodenum < 0) {
            return nodenum;
        }

        tnode_t *TN = &trace_nodes[nodenum];

        float dist1;
        float dist2;

        switch (TN->type) {
            case PLANE_X:
                dist1 = x1;
                dist2 = x2;
                break;

            case PLANE_Y:
                dist1 = y1;
                dist2 = y2;
                break;

            case PLANE_Z:
                dist1 = z1;
                dist2 = z2;
                break;

            default:
                dist1 = x1 * TN->normal[0] + y1 * TN->normal[1] +
                        z1 * TN->normal[2];
                dist2 = x2 * TN->normal[0] + y2 * TN->normal[1] +
                        z2 * TN->normal[2];
                break;
        }

        dist1 -= TN->dist;
        dist2 -= TN->dist;

        if (dist1 >= -T_EPSILON && dist2 >= -T_EPSILON) {
            nodenum = TN->children[0];
            continue;
        }

        if (dist1 < T_EPSILON && dist2 < T_EPSILON) {
            nodenum = TN->children[1];
            continue;
        }

        // the ray crosses the node plane.

        int side = (dist1 < 0) ? 1 : 0;

        double frac = dist1 / (double)(dist1 - dist2);

        float mx = x1 + (x2 - x1) * frac;
        float my = y1 + (y2 - y1) * frac;
        float mz = z1 + (z2 - z1) * frac;

        // check if front half of the ray is OK

        int r = RecursiveTestRay(TN->children[side], x1, y1, z1, mx, my, mz);

        // -AJA- here is where my TRACE_SKY logic comes into play.
        //       It assumes the ray is cast from luxel to sun light
        //       (and won't work the other way around).
        if (r != TRACE_EMPTY) {
            return r;
        }

        // yes it was, so continue with the back half

        nodenum = TN->children[side ^ 1];

        x1 = mx;
        y1 = my;
        z1 = mz;
    }
}

static int RecursiveTestDetail(quake_node_c *N, quake_leaf_c *L, float x1,
                               float y1, float z1, float x2, float y2,
                               float z2) {
    for (;;) {
        // hit a leaf?
        if (L) {
            for (unsigned int k = 0; k < L->faces.size(); k++) {
                quake_face_c *F = L->faces[k];

                if (!(F->flags & FACE_F_Detail)) {
                    continue;
                }

                if (F->flags & FACE_F_NoShadow) {
                    continue;
                }

                if (F->IntersectRay(x1, y1, z1, x2, y2, z2)) {
                    return TRACE_SOLID;
                }
            }

            return TRACE_EMPTY;
        }

        float dist1 = N->plane.PointDist(x1, y1, z1);
        float dist2 = N->plane.PointDist(x2, y2, z2);

        if (dist1 >= -T_EPSILON && dist2 >= -T_EPSILON) {
            L = N->front_L;
            N = N->front_N;
            continue;
        }

        if (dist1 < T_EPSILON && dist2 < T_EPSILON) {
            L = N->back_L;
            N = N->back_N;
            continue;
        }

        // the ray crosses the node plane.

        int side = (dist1 < 0) ? 1 : 0;

        double frac = dist1 / (double)(dist1 - dist2);

        float mx = x1 + (x2 - x1) * frac;
        float my = y1 + (y2 - y1) * frac;
        float mz = z1 + (z2 - z1) * frac;

        // check if front half of the ray is OK

        quake_leaf_c *L0 = side ? N->back_L : N->front_L;
        quake_node_c *N0 = side ? N->back_N : N->front_N;

        int r = RecursiveTestDetail(N0, L0, x1, y1, z1, mx, my, mz);

        if (r != TRACE_EMPTY) {
            return r;
        }

        // yes it was, so continue with the back half

        L = side ? N->front_L : N->back_L;
        N = side ? N->front_N : N->back_N;

        x1 = mx;
        y1 = my;
        z1 = mz;
    }
}

bool QVIS_TraceRay(float x1, float y1, float z1, float x2, float y2, float z2) {
    int r = RecursiveTestRay(0, x1, y1, z1, x2, y2, z2);

    if (r == TRACE_SOLID) {
        return false;
    }

    // check for detail faces *after* the main trace

    r = RecursiveTestDetail(qk_bsp_root, NULL, x1, y1, z1, x2, y2, z2);

    if (r == TRACE_SOLID) {
        return false;
    }

    return true;
}

static int RecursiveTestPoint(int nodenum, float x, float y, float z) {
    for (;;) {
        if (nodenum < 0) {
            return nodenum;
        }

        tnode_t *TN = &trace_nodes[nodenum];

        float dist;

        switch (TN->type) {
            case PLANE_X:
                dist = x;
                break;

            case PLANE_Y:
                dist = y;
                break;

            case PLANE_Z:
                dist = z;
                break;

            default:
                dist =
                    x * TN->normal[0] + y * TN->normal[1] + z * TN->normal[2];
                break;
        }

        dist -= TN->dist;

        if (dist > 0.0001) {
            nodenum = TN->children[0];
            continue;
        }

        if (dist < -0.0001) {
            nodenum = TN->children[1];
            continue;
        }

        // point is sitting ON the node, we must test both sides
        // [ in order to produce a consistent result ]

        int A = RecursiveTestPoint(TN->children[0], x, y, z);
        int B = RecursiveTestPoint(TN->children[1], x, y, z);

        // we treat sky brushes as solid here

        if (A == TRACE_EMPTY && B == TRACE_EMPTY) {
            return TRACE_EMPTY;
        }

        return TRACE_SOLID;
    }
}

bool QVIS_TracePoint(float x, float y, float z) {
    int r = RecursiveTestPoint(0, x, y, z);

    return (r == TRACE_EMPTY);
}

//------------------------------------------------------------------------
//  CLUSTER MANAGEMENT
//------------------------------------------------------------------------

#define VIS_EPSILON 0.01

int cluster_X;
int cluster_Y;
int cluster_W;
int cluster_H;

qCluster_c **qk_clusters;

static Vis_Buffer *qk_visbuf;

qCluster_c::qCluster_c(int _x, int _y)
    : cx(_x), cy(_y), leafs(), visofs(-1), hearofs(-1) {
    ambient_dists[0] = ambient_dists[1] = 255;
    ambient_dists[2] = ambient_dists[3] = 255;
}

qCluster_c::~qCluster_c() {
    // nothing needed
}

void qCluster_c::AddLeaf(quake_leaf_c *leaf) {
    leaf->cluster = this;

    leafs.push_back(leaf);
}

int qCluster_c::CalcID() const {
    if (leafs.empty()) {
        return -1;
    }

    return (cy * cluster_W) + cx;
}

void qCluster_c::MarkAmbient(int kind) {
    // set distance to zero
    ambient_dists[kind] = 0;
}

void QVIS_CreateClusters(double min_x, double min_y, double max_x,
                         double max_y) {
    SYS_ASSERT(min_x < max_x);
    SYS_ASSERT(min_y < max_y);

    int cx1 = (int)floor(min_x / CLUSTER_SIZE + VIS_EPSILON);
    int cy1 = (int)floor(min_y / CLUSTER_SIZE + VIS_EPSILON);
    int cx2 = (int)ceil(max_x / CLUSTER_SIZE - VIS_EPSILON);
    int cy2 = (int)ceil(max_y / CLUSTER_SIZE - VIS_EPSILON);

    SYS_ASSERT(cx1 < cx2);
    SYS_ASSERT(cy1 < cy2);

    cluster_X = cx1;
    cluster_Y = cy1;
    cluster_W = cx2 - cx1;
    cluster_H = cy2 - cy1;

    LogPrintf("Cluster Size: %d %d  (origin %+d %+d)\n", cluster_W, cluster_H,
              cluster_X, cluster_Y);

    qk_clusters = new qCluster_c *[cluster_W * cluster_H];

    for (int i = 0; i < cluster_W * cluster_H; i++) {
        int cx = (i % cluster_W);
        int cy = (i / cluster_W);

        qk_clusters[i] = new qCluster_c(cx, cy);
    }

    qk_visbuf = new Vis_Buffer(cluster_W, cluster_H);
}

void QVIS_FreeClusters() {
    if (qk_clusters) {
        for (int i = 0; i < cluster_W * cluster_H; i++) {
            delete qk_clusters[i];
        }

        delete[] qk_clusters;
        qk_clusters = NULL;

        delete qk_visbuf;
        qk_visbuf = NULL;
    }
}

void QVIS_MarkWall(int cx, int cy, int side) {
    SYS_ASSERT(qk_visbuf);

    if (side & 1) {
        qk_visbuf->AddDiagonal(cx, cy, side);
    } else {
        qk_visbuf->AddWall(cx, cy, side);
    }

// debugging
#if 0
    fprintf(stderr, "@@@ %d %d %d\n", cx, cy, side);
#endif
}

static void MarkSolidClusters() {
    // any cluster without a leaf must be totally solid

    for (int cy = 0; cy < cluster_H; cy++) {
        for (int cx = 0; cx < cluster_W; cx++) {
            qCluster_c *cluster = qk_clusters[cy * cluster_W + cx];

            if (cluster->leafs.empty()) {
                for (int side = 2; side <= 8; side += 2) {
                    QVIS_MarkWall(cx, cy, side);
                }
            }
        }
    }
}

static void FloodAmbientSounds() {
    for (int pass = 0; pass < 8; pass++) {
        for (int cy = 0; cy < cluster_H; cy++) {
            for (int cx = 0; cx < cluster_W; cx++) {
                qCluster_c *S = qk_clusters[cy * cluster_W + cx];

                if (S->leafs.empty()) {
                    continue;
                }

                for (int side = 2; side <= 8; side += 2) {
                    if (qk_visbuf->TestWall(cx, cy, side)) {
                        continue;
                    }

                    int nx = (side == 4) ? -1 : (side == 6) ? +1 : 0;
                    int ny = (side == 2) ? -1 : (side == 8) ? +1 : 0;

                    nx += cx;
                    ny += cy;

                    if (nx < 0 || nx >= cluster_W || ny < 0 ||
                        ny >= cluster_H) {
                        continue;
                    }

                    qCluster_c *N = qk_clusters[ny * cluster_W + nx];

                    for (int k = 0; k < 4; k++) {
                        uint8_t src = S->ambient_dists[k];
                        uint8_t dest = N->ambient_dists[k];

                        if (src == 255) {
                            continue;
                        }

                        src++;

                        N->ambient_dists[k] = MIN(src, dest);
                    }
                }
            }
        }
    }
}

//------------------------------------------------------------------------
//  VISIBILITY
//------------------------------------------------------------------------

static qLump_c *q_visibility;

static uint8_t *v_row_buffer;
static uint8_t *v_compress_buffer;

static int v_row_bits;  // number of leafs or clusters
static int v_bytes_per_row;

// statistic stuff
struct vis_statistics_t {
    int uncompressed;
    int compressed;

    float best;
    float worst;

    double average;
    int total;

   public:
    void Start() {
        uncompressed = compressed = 0;

        best = 99.9;
        worst = 0.0;
        average = 0;
        total = 0;
    }

    void AddValue(float perc) {
        if (perc < best) {
            best = perc;
        }
        if (perc > worst) {
            worst = perc;
        }

        average += perc;
        total += 1;
    }

    void Finish() {
        if (total > 0) {
            average /= total;
        }
    }

    float CalcRatio() const {
        int saved = (uncompressed - compressed);

        return MAX(0, saved) * 100.0 / (float)MAX(1, uncompressed);
    }
};

static vis_statistics_t pvs_stats;
static vis_statistics_t phs_stats;

static int WriteCompressedRow(bool PHS) {
    // returns offset for the written data block
    int visofs = (int)q_visibility->GetSize();

    const uint8_t *src = v_row_buffer;
    const uint8_t *s_end = src + v_bytes_per_row;

    uint8_t *dest = v_compress_buffer;

    while (src < s_end) {
        if (*src) {
            *dest++ = *src++;
            continue;
        }

        *dest++ = *src++;

        uint8_t repeat = 1;

        while (src < s_end && *src == 0 && repeat != 255) {
            src++;
            repeat++;
        }

        *dest++ = repeat;
    }

    int length = (dest - v_compress_buffer);

    q_visibility->Append(v_compress_buffer, length);

    if (PHS) {
        phs_stats.uncompressed += v_bytes_per_row;
        phs_stats.compressed += length;
    } else {
        pvs_stats.uncompressed += v_bytes_per_row;
        pvs_stats.compressed += length;
    }

    return visofs;
}

static void WriteUncompressedRow() {
    int length = v_bytes_per_row;

    q_visibility->Append(v_row_buffer, length);
}

static void CollectRowData(int src_x, int src_y, bool PHS) {
    // initial state : everything visible
    memset(v_row_buffer, 0xFF, v_bytes_per_row);

    unsigned int blocked = 0;  // statistics

    for (int cy = 0; cy < cluster_H; cy++) {
        for (int cx = 0; cx < cluster_W; cx++) {
            if ((cx == src_x && cy == src_y) || qk_visbuf->CanSee(cx, cy)) {
                continue;
            }

            qCluster_c *cluster = qk_clusters[cy * cluster_W + cx];

            if (qk_game == 2)
            {
                int index = cy * cluster_W + cx;

                SYS_ASSERT(index >= 0);
                SYS_ASSERT((index >> 3) < v_bytes_per_row);

                v_row_buffer[index >> 3] &= ~(1 << (index & 7));

                blocked++;
            } else  // original Quake, data is indexed by leaf number
            {
                unsigned int total = cluster->leafs.size();

                blocked += total;

                // mark all the leafs in destination cluster as blocked

                for (unsigned int k = 0; k < total; k++) {
                    int index = cluster->leafs[k]->index;

                    index--;  // skip the solid leaf

                    SYS_ASSERT(index >= 0);
                    SYS_ASSERT((index >> 3) < v_bytes_per_row);

                    v_row_buffer[index >> 3] &= ~(1 << (index & 7));
                }
            }
        }
    }

#if 0
    fprintf(stderr, "cluster: %2d %2d  blocked: %d = %1.2f%%   \n",
            src_x, src_y, blocked, blocked * 100.0 / v_row_bits);
#endif

    // update statistics
    float perc = (v_row_bits - blocked) * 100.0 / (float)MAX(1, v_row_bits);

    if (PHS) {
        phs_stats.AddValue(perc);
    } else {
        pvs_stats.AddValue(perc);
    }

#ifdef DEBUG_INVERT_MAP
    for (int n = 0; n < v_bytes_per_row; n++) v_row_buffer[n] ^= 0xFF;
#endif
}

static void Build_PVS() {
    qk_visbuf->SimplifySolid();

    int done = 0;

    for (int cy = 0; cy < cluster_H; cy++) {
        for (int cx = 0; cx < cluster_W; cx++) {
            qCluster_c *cluster = qk_clusters[cy * cluster_W + cx];

            if (cluster->leafs.empty()) {
                continue;
            }

            qk_visbuf->ClearVis();
            qk_visbuf->ProcessVis(cx, cy);

            CollectRowData(cx, cy, false);

            cluster->visofs = WriteCompressedRow(false);

            if (qk_game == 2) {
                // Quake II's Potentially Hearable Set
                //
                // 1. start off with the PVS set
                // 2. flood fill for a few passes
                // 3. truncate it based on distance

                qk_visbuf->FloodFill(4);
                qk_visbuf->Truncate(8);

                CollectRowData(cx, cy, true);

                cluster->hearofs = WriteCompressedRow(true);
            }

            if (done % 80 == 0) {
                return;
            }

            done++;
        }
    }
}

static void Q2_PrependOffsets(int num_clusters) {
    int header_size = 4 + 8 * num_clusters;

    int32_t *header = new int32_t[1 + num_clusters * 2];

    header[0] = LE_S32(num_clusters);

    for (int i = 0; i < num_clusters; i++) {
        qCluster_c *cluster = qk_clusters[i];

        // dummy offset for unused clusters
        if (cluster->visofs < 0) {
            cluster->visofs = 0;
        }
        if (cluster->hearofs < 0) {
            cluster->hearofs = 0;
        }

        // fix endianness too

        header[i * 2 + 1] = LE_S32(header_size + cluster->visofs);
        header[i * 2 + 2] = LE_S32(header_size + cluster->hearofs);
    }

    q_visibility->Prepend(header, header_size);

    delete[] header;
}

static void ShowVisStats() {
    pvs_stats.Finish();
    phs_stats.Finish();

    LogPrintf("pvs compression ratio %1.0f%% (%d bytes --> %d)\n",
        pvs_stats.CalcRatio(), pvs_stats.uncompressed,
        pvs_stats.compressed);

    if (qk_game == 2) {
        LogPrintf("phs compression ratio %1.0f%% (%d bytes --> %d)\n",
                  phs_stats.CalcRatio(), phs_stats.uncompressed,
                  phs_stats.compressed);

        LogPrintf(
            "average hearability: %1.0f%%  best:%1.0f%%  worst:%1.0f%%\n",
            phs_stats.average, phs_stats.best, phs_stats.worst);
    }

    LogPrintf("average visibility: %1.0f%%  best:%1.0f%%  worst:%1.0f%%\n",
              pvs_stats.average, pvs_stats.best, pvs_stats.worst);
}

void QVIS_Visibility(int lump, int max_size, int numleafs) {
    LogPrintf("\nVisibility...\n");

    SYS_ASSERT(qk_clusters);

    // setup statistics
    pvs_stats.Start();
    phs_stats.Start();

    int num_clusters = cluster_W * cluster_H;

    MarkSolidClusters();

    FloodAmbientSounds();

    if (qk_game == 2) {
        v_row_bits = num_clusters;
    } else {
        v_row_bits = numleafs;
    }

    v_bytes_per_row = (v_row_bits + 7) >> 3;

    LogPrintf("bits per row: %d --> bytes: %d\n", v_row_bits, v_bytes_per_row);

    v_row_buffer = new uint8_t[1 + v_bytes_per_row];

    // the worst case scenario for compression is 50% larger
    v_compress_buffer = new uint8_t[1 + 2 * v_bytes_per_row];

    q_visibility = BSP_NewLump(lump);

    Build_PVS();

    ShowVisStats();

    if (qk_game == 2) {
        Q2_PrependOffsets(num_clusters);
    }

    // TODO: handle overflow: store visdata in memory, and "merge" the
    //       clusters into pairs or 2x2 contiguous pieces.

    if (q_visibility->GetSize() >= max_size) {
        Main::FatalError(
            "Quake build failure: exceeded VISIBILITY limit\n");
    }

    delete[] v_row_buffer;
    delete[] v_compress_buffer;
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
