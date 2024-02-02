//------------------------------------------------------------------------
//  QUAKE VISIBILITY and TRACING
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2010-2017 Andrew Apted
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

#ifndef __QUAKE_VIS_H__
#define __QUAKE_VIS_H__

#include <cstdint>
#include <vector>

// Quake 1 ambient sounds
#define AMBIENT_WATER 0
#define AMBIENT_SKY 1
#define AMBIENT_SLIME 2
#define AMBIENT_LAVA 3

class quake_leaf_c;

class qCluster_c {
   public:
    // cluster coordinate (starts at 0)
    int cx, cy;

    std::vector<quake_leaf_c *> leafs;

    uint8_t ambient_dists[4];

    // offset into LUMP_VISIBILITY
    int visofs;
    int hearofs;  // Quake 2 only

   public:
    qCluster_c(int _x, int _y);

    ~qCluster_c();

    void AddLeaf(quake_leaf_c *leaf);

    // for Quake II, get the ID of the cluster (-1 for unused ones)
    int CalcID() const;

    void MarkAmbient(int kind);
};

/***** VARIABLES **********/

extern int cluster_X, cluster_Y;
extern int cluster_W, cluster_H;

extern qCluster_c **qk_clusters;

/***** FUNCTIONS **********/

void QVIS_MakeTraceNodes();
void QVIS_FreeTraceNodes();

// returns true if OK, false if blocked
bool QVIS_TraceRay(float x1, float y1, float z1, float x2, float y2, float z2);

// returns true if point is in air, false for solid or sky
bool QVIS_TracePoint(float x, float y, float z);

void QVIS_CreateClusters(double min_x, double min_y, double max_x,
                         double max_y);
void QVIS_FreeClusters();

void QVIS_MarkWall(int cx, int cy, int side);

void QVIS_Visibility(int lump, int max_size, int numleafs);

#endif /* __QUAKE_VIS_H__ */

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
