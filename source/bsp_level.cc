//------------------------------------------------------------------------
//
//  AJ-BSP  Copyright (C) 2000-2023  Andrew Apted, et al
//          Copyright (C) 1994-1998  Colin Reed
//          Copyright (C) 1997-1998  Lee Killough
//
//  Originally based on the program 'BSP', version 2.3.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 3
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include <algorithm>

#include "bsp_local.h"
#include "bsp_utility.h"
#include "bsp_wad.h"
#include "dm_defs.h"
#include "lib_parse.h"
#include "lib_util.h"
#include "miniz.h"
#include "sys_debug.h"
#include "sys_endian.h"
#include "sys_macro.h"

#define DEBUG_BLOCKMAP 0
#define DEBUG_REJECT   0

#define DEBUG_LOAD 0
#define DEBUG_BSP  0

namespace ajbsp
{

enum UDMFTypes
{
    kUDMFThing   = 1,
    kUDMFVertex  = 2,
    kUDMFSector  = 3,
    kUDMFSidedef = 4,
    kUDMFLinedef = 5
};

WadFile *cur_wad;

static int block_x, block_y;
static int block_w, block_h;
static int block_count;

static int block_mid_x = 0;
static int block_mid_y = 0;

static uint16_t **block_lines;

static uint16_t *block_ptrs;
static uint16_t *block_dups;

static int block_compression;
static int block_overflowed;

static constexpr uint16_t kBlockLimit     = 16000;
static constexpr uint16_t kDummyDuplicate = 0xFFFF;

void GetBlockmapBounds(int *x, int *y, int *w, int *h)
{
    *x = block_x;
    *y = block_y;
    *w = block_w;
    *h = block_h;
}

int CheckLinedefInsideBox(int xmin, int ymin, int xmax, int ymax, int x1,
                          int y1, int x2, int y2)
{
    int count = 2;
    int tmp;

    for (;;)
    {
        if (y1 > ymax)
        {
            if (y2 > ymax) return false;

            x1 =
                x1 + (int)((x2 - x1) * (double)(ymax - y1) / (double)(y2 - y1));
            y1 = ymax;

            count = 2;
            continue;
        }

        if (y1 < ymin)
        {
            if (y2 < ymin) return false;

            x1 =
                x1 + (int)((x2 - x1) * (double)(ymin - y1) / (double)(y2 - y1));
            y1 = ymin;

            count = 2;
            continue;
        }

        if (x1 > xmax)
        {
            if (x2 > xmax) return false;

            y1 =
                y1 + (int)((y2 - y1) * (double)(xmax - x1) / (double)(x2 - x1));
            x1 = xmax;

            count = 2;
            continue;
        }

        if (x1 < xmin)
        {
            if (x2 < xmin) return false;

            y1 =
                y1 + (int)((y2 - y1) * (double)(xmin - x1) / (double)(x2 - x1));
            x1 = xmin;

            count = 2;
            continue;
        }

        count--;

        if (count == 0) break;

        // swap end points
        tmp = x1;
        x1  = x2;
        x2  = tmp;
        tmp = y1;
        y1  = y2;
        y2  = tmp;
    }

    // linedef touches block
    return true;
}

/* ----- create blockmap ------------------------------------ */

#define BK_NUM   0
#define BK_MAX   1
#define BK_XOR   2
#define BK_FIRST 3

#define BK_QUANTUM 32

static void BlockAdd(int blk_num, int line_index)
{
    uint16_t *cur = block_lines[blk_num];

#if DEBUG_BLOCKMAP
    DebugPrintf("Block %d has line %d\n", blk_num, line_index);
#endif

    if (blk_num < 0 || blk_num >= block_count)
        ErrorPrintf("BlockAdd: bad block number %d\n", blk_num);

    if (!cur)
    {
        // create empty block
        block_lines[blk_num] = cur =
            (uint16_t *)UtilCalloc(BK_QUANTUM * sizeof(uint16_t));
        cur[BK_NUM] = 0;
        cur[BK_MAX] = BK_QUANTUM;
        cur[BK_XOR] = 0x1234;
    }

    if (BK_FIRST + cur[BK_NUM] == cur[BK_MAX])
    {
        // no more room, so allocate some more...
        cur[BK_MAX] += BK_QUANTUM;

        block_lines[blk_num] = cur =
            (uint16_t *)UtilRealloc(cur, cur[BK_MAX] * sizeof(uint16_t));
    }

    // compute new checksum
    cur[BK_XOR] =
        (uint16_t)(((cur[BK_XOR] << 4) | (cur[BK_XOR] >> 12)) ^ line_index);

    cur[BK_FIRST + cur[BK_NUM]] = AlignedLittleEndianU16(line_index);
    cur[BK_NUM]++;
}

static void BlockAddLine(const Linedef *L)
{
    int x1 = (int)L->start->x_;
    int y1 = (int)L->start->y_;
    int x2 = (int)L->end->x_;
    int y2 = (int)L->end->y_;

    int bx1 = (std::min(x1, x2) - block_x) / 128;
    int by1 = (std::min(y1, y2) - block_y) / 128;
    int bx2 = (std::max(x1, x2) - block_x) / 128;
    int by2 = (std::max(y1, y2) - block_y) / 128;

    int bx, by;
    int line_index = L->index;

#if DEBUG_BLOCKMAP
    DebugPrintf("BlockAddLine: %d (%d,%d) -> (%d,%d)\n", line_index, x1, y1, x2,
                y2);
#endif

    // handle truncated blockmaps
    if (bx1 < 0) bx1 = 0;
    if (by1 < 0) by1 = 0;
    if (bx2 >= block_w) bx2 = block_w - 1;
    if (by2 >= block_h) by2 = block_h - 1;

    if (bx2 < bx1 || by2 < by1) return;

    // handle simple case #1: completely horizontal
    if (by1 == by2)
    {
        for (bx = bx1; bx <= bx2; bx++)
        {
            int blk_num = by1 * block_w + bx;
            BlockAdd(blk_num, line_index);
        }
        return;
    }

    // handle simple case #2: completely vertical
    if (bx1 == bx2)
    {
        for (by = by1; by <= by2; by++)
        {
            int blk_num = by * block_w + bx1;
            BlockAdd(blk_num, line_index);
        }
        return;
    }

    // handle the rest (diagonals)

    for (by = by1; by <= by2; by++)
        for (bx = bx1; bx <= bx2; bx++)
        {
            int blk_num = by * block_w + bx;

            int minx = block_x + bx * 128;
            int miny = block_y + by * 128;
            int maxx = minx + 127;
            int maxy = miny + 127;

            if (CheckLinedefInsideBox(minx, miny, maxx, maxy, x1, y1, x2, y2))
            {
                BlockAdd(blk_num, line_index);
            }
        }
}

static void CreateBlockmap(void)
{
    block_lines = (uint16_t **)UtilCalloc(block_count * sizeof(uint16_t *));

    for (int i = 0; i < level_linedefs.size(); i++)
    {
        const Linedef *L = level_linedefs[i];

        // ignore zero-length lines
        if (L->zero_length) continue;

        BlockAddLine(L);
    }
}

static int BlockCompare(const void *p1, const void *p2)
{
    int blk_num1 = ((const uint16_t *)p1)[0];
    int blk_num2 = ((const uint16_t *)p2)[0];

    const uint16_t *A = block_lines[blk_num1];
    const uint16_t *B = block_lines[blk_num2];

    if (A == B) return 0;

    if (A == NULL) return -1;
    if (B == NULL) return +1;

    if (A[BK_NUM] != B[BK_NUM]) { return A[BK_NUM] - B[BK_NUM]; }

    if (A[BK_XOR] != B[BK_XOR]) { return A[BK_XOR] - B[BK_XOR]; }

    return memcmp(A + BK_FIRST, B + BK_FIRST, A[BK_NUM] * sizeof(uint16_t));
}

static void CompressBlockmap(void)
{
    int i;
    int cur_offset;
    int dup_count = 0;

    int orig_size, new_size;

    block_ptrs = (uint16_t *)UtilCalloc(block_count * sizeof(uint16_t));
    block_dups = (uint16_t *)UtilCalloc(block_count * sizeof(uint16_t));

    // sort duplicate-detecting array.  After the sort, all duplicates
    // will be next to each other.  The duplicate array gives the order
    // of the blocklists in the BLOCKMAP lump.

    for (i = 0; i < block_count; i++) block_dups[i] = (uint16_t)i;

    qsort(block_dups, block_count, sizeof(uint16_t), BlockCompare);

    // scan duplicate array and build up offset array

    cur_offset = 4 + block_count + 2;

    orig_size = 4 + block_count;
    new_size  = cur_offset;

    for (i = 0; i < block_count; i++)
    {
        int blk_num = block_dups[i];
        int count;

        // empty block ?
        if (block_lines[blk_num] == NULL)
        {
            block_ptrs[blk_num] = (uint16_t)(4 + block_count);
            block_dups[i]       = kDummyDuplicate;

            orig_size += 2;
            continue;
        }

        count = 2 + block_lines[blk_num][BK_NUM];

        // duplicate ?  Only the very last one of a sequence of duplicates
        // will update the current offset value.

        if (i + 1 < block_count &&
            BlockCompare(block_dups + i, block_dups + i + 1) == 0)
        {
            block_ptrs[blk_num] = (uint16_t)cur_offset;
            block_dups[i]       = kDummyDuplicate;

            // free the memory of the duplicated block
            UtilFree(block_lines[blk_num]);
            block_lines[blk_num] = NULL;

            dup_count++;

            orig_size += count;
            continue;
        }

        // OK, this block is either the last of a series of duplicates, or
        // just a singleton.

        block_ptrs[blk_num] = (uint16_t)cur_offset;

        cur_offset += count;

        orig_size += count;
        new_size += count;
    }

    if (cur_offset > 65535)
    {
        block_overflowed = true;
        return;
    }

#if DEBUG_BLOCKMAP
    DebugPrintf("Blockmap: Last ptr = %d  duplicates = %d\n", cur_offset,
                dup_count);
#endif

    block_compression = (orig_size - new_size) * 100 / orig_size;

    // there's a tiny chance of new_size > orig_size
    if (block_compression < 0) block_compression = 0;
}

static int CalcBlockmapSize()
{
    // compute size of final BLOCKMAP lump.
    // it does not need to be exact, but it *does* need to be bigger
    // (or equal) to the actual size of the lump.

    // header + null_block + a bit extra
    int size = 20;

    // the pointers (offsets to the line lists)
    size = size + block_count * 2;

    // add size of each block
    for (int i = 0; i < block_count; i++)
    {
        int blk_num = block_dups[i];

        // ignore duplicate or empty blocks
        if (blk_num == kDummyDuplicate) continue;

        uint16_t *blk = block_lines[blk_num];
        SYS_ASSERT(blk);

        size += (1 + (int)(blk[BK_NUM]) + 1) * 2;
    }

    return size;
}

static void WriteBlockmap(void)
{
    int i;

    int max_size = CalcBlockmapSize();

    Lump *lump = CreateLevelLump("BLOCKMAP", max_size);

    uint16_t null_block[2] = {0x0000, 0xFFFF};
    uint16_t m_zero        = 0x0000;
    uint16_t m_neg1        = 0xFFFF;

    // fill in header
    RawBlockmapHeader header;

    header.x_origin = AlignedLittleEndianU16(block_x);
    header.y_origin = AlignedLittleEndianU16(block_y);
    header.x_blocks = AlignedLittleEndianU16(block_w);
    header.y_blocks = AlignedLittleEndianU16(block_h);

    lump->Write(&header, sizeof(header));

    // handle pointers
    for (i = 0; i < block_count; i++)
    {
        uint16_t ptr = AlignedLittleEndianU16(block_ptrs[i]);

        if (ptr == 0) ErrorPrintf("WriteBlockmap: offset %d not set.\n", i);

        lump->Write(&ptr, sizeof(uint16_t));
    }

    // add the null block which *all* empty blocks will use
    lump->Write(null_block, sizeof(null_block));

    // handle each block list
    for (i = 0; i < block_count; i++)
    {
        int blk_num = block_dups[i];

        // ignore duplicate or empty blocks
        if (blk_num == kDummyDuplicate) continue;

        uint16_t *blk = block_lines[blk_num];
        SYS_ASSERT(blk);

        lump->Write(&m_zero, sizeof(uint16_t));
        lump->Write(blk + BK_FIRST, blk[BK_NUM] * sizeof(uint16_t));
        lump->Write(&m_neg1, sizeof(uint16_t));
    }

    lump->Finish();
}

static void FreeBlockmap(void)
{
    for (int i = 0; i < block_count; i++)
    {
        if (block_lines[i]) UtilFree(block_lines[i]);
    }

    UtilFree(block_lines);
    UtilFree(block_ptrs);
    UtilFree(block_dups);
}

static void FindBlockmapLimits(BoundingBox *bbox)
{
    double mid_x = 0;
    double mid_y = 0;

    bbox->minx = bbox->miny = SHRT_MAX;
    bbox->maxx = bbox->maxy = SHRT_MIN;

    for (int i = 0; i < level_linedefs.size(); i++)
    {
        const Linedef *L = level_linedefs[i];

        if (!L->zero_length)
        {
            double x1 = L->start->x_;
            double y1 = L->start->y_;
            double x2 = L->end->x_;
            double y2 = L->end->y_;

            int lx = (int)floor(std::min(x1, x2));
            int ly = (int)floor(std::min(y1, y2));
            int hx = (int)ceil(std::max(x1, x2));
            int hy = (int)ceil(std::max(y1, y2));

            if (lx < bbox->minx) bbox->minx = lx;
            if (ly < bbox->miny) bbox->miny = ly;
            if (hx > bbox->maxx) bbox->maxx = hx;
            if (hy > bbox->maxy) bbox->maxy = hy;

            // compute middle of cluster
            mid_x += (lx + hx) / 2;
            mid_y += (ly + hy) / 2;
        }
    }

    if (level_linedefs.size() > 0)
    {
        block_mid_x = RoundToInteger(mid_x / (double)level_linedefs.size());
        block_mid_y = RoundToInteger(mid_y / (double)level_linedefs.size());
    }

#if DEBUG_BLOCKMAP
    DebugPrintf("Blockmap lines centered at (%d,%d)\n", block_mid_x,
                block_mid_y);
#endif
}

void InitBlockmap()
{
    BoundingBox map_bbox;

    // find limits of linedefs, and store as map limits
    FindBlockmapLimits(&map_bbox);

    LogPrintf("    Map limits: (%d,%d) to (%d,%d)\n", map_bbox.minx,
              map_bbox.miny, map_bbox.maxx, map_bbox.maxy);

    block_x = map_bbox.minx - (map_bbox.minx & 0x7);
    block_y = map_bbox.miny - (map_bbox.miny & 0x7);

    block_w = ((map_bbox.maxx - block_x) / 128) + 1;
    block_h = ((map_bbox.maxy - block_y) / 128) + 1;

    block_count = block_w * block_h;
}

void PutBlockmap()
{
    if (!current_build_info.do_blockmap || level_linedefs.size() == 0)
    {
        // just create an empty blockmap lump
        CreateLevelLump("BLOCKMAP")->Finish();
        return;
    }

    block_overflowed = false;

    // initial phase: create internal blockmap containing the index of
    // all lines in each block.

    CreateBlockmap();

    // -AJA- second phase: compress the blockmap.  We do this by sorting
    //       the blocks, which is a typical way to detect duplicates in
    //       a large list.  This also detects BLOCKMAP overflow.

    CompressBlockmap();

    // final phase: write it out in the correct format

    if (block_overflowed)
    {
        // leave an empty blockmap lump
        CreateLevelLump("BLOCKMAP")->Finish();

        LogPrintf("Blockmap overflowed (lump will be empty)\n");
    }
    else
    {
        WriteBlockmap();

        LogPrintf("    Blockmap size: %dx%d (compression: %d%%)\n", block_w,
                  block_h, block_compression);
    }

    FreeBlockmap();
}

//------------------------------------------------------------------------
// REJECT : Generate the reject table
//------------------------------------------------------------------------

static uint8_t *reject_matrix;
static int      reject_total_size;  // in bytes

//
// Allocate the matrix, init sectors into individual groups.
//
static void Reject_Init()
{
    reject_total_size = (level_sectors.size() * level_sectors.size() + 7) / 8;

    reject_matrix = new uint8_t[reject_total_size];
    memset(reject_matrix, 0, reject_total_size);

    for (int i = 0; i < level_sectors.size(); i++)
    {
        Sector *sec = level_sectors[i];

        sec->reject_group = i;
        sec->reject_next = sec->reject_previous = sec;
    }
}

static void Reject_Free()
{
    delete[] reject_matrix;
    reject_matrix = NULL;
}

//
// Algorithm: Initially all sectors are in individual groups.
// Now we scan the linedef list.  For each two-sectored line,
// merge the two sector groups into one.  That's it !
//
static void Reject_GroupSectors()
{
    for (int i = 0; i < level_linedefs.size(); i++)
    {
        const Linedef *line = level_linedefs[i];

        if (!line->right || !line->left) continue;

        Sector *sec1 = line->right->sector;
        Sector *sec2 = line->left->sector;
        Sector *tmp;

        if (!sec1 || !sec2 || sec1 == sec2) continue;

        // already in the same group ?
        if (sec1->reject_group == sec2->reject_group) continue;

        // swap sectors so that the smallest group is added to the biggest
        // group.  This is based on the assumption that sector numbers in
        // wads will generally increase over the set of linedefs, and so
        // (by swapping) we'll tend to add small groups into larger groups,
        // thereby minimising the updates to 'reject_group' fields when merging.

        if (sec1->reject_group > sec2->reject_group)
        {
            tmp  = sec1;
            sec1 = sec2;
            sec2 = tmp;
        }

        // update the group numbers in the second group

        sec2->reject_group = sec1->reject_group;

        for (tmp = sec2->reject_next; tmp != sec2; tmp = tmp->reject_next)
            tmp->reject_group = sec1->reject_group;

        // merge 'em baby...

        sec1->reject_next->reject_previous = sec2;
        sec2->reject_next->reject_previous = sec1;

        tmp               = sec1->reject_next;
        sec1->reject_next = sec2->reject_next;
        sec2->reject_next = tmp;
    }
}

#if DEBUG_REJECT
static void Reject_DebugGroups()
{
    // Note: this routine is destructive to the group numbers

    for (int i = 0; i < level_sectors.size(); i++)
    {
        Sector *sec = level_sectors[i];
        Sector *tmp;

        int group = sec->reject_group;
        int num   = 0;

        if (group < 0) continue;

        sec->reject_group = -1;
        num++;

        for (tmp = sec->reject_next; tmp != sec; tmp = tmp->reject_next)
        {
            tmp->reject_group = -1;
            num++;
        }

        DebugPrintf("Group %d  Sectors %d\n", group, num);
    }
}
#endif

static void Reject_ProcessSectors()
{
    for (int view = 0; view < level_sectors.size(); view++)
    {
        for (int target = 0; target < view; target++)
        {
            Sector *view_sec = level_sectors[view];
            Sector *targ_sec = level_sectors[target];

            if (view_sec->reject_group == targ_sec->reject_group) continue;

            // for symmetry, do both sides at same time

            int p1 = view * level_sectors.size() + target;
            int p2 = target * level_sectors.size() + view;

            reject_matrix[p1 >> 3] |= (1 << (p1 & 7));
            reject_matrix[p2 >> 3] |= (1 << (p2 & 7));
        }
    }
}

static void Reject_WriteLump()
{
    Lump *lump = CreateLevelLump("REJECT", reject_total_size);

    lump->Write(reject_matrix, reject_total_size);
    lump->Finish();
}

//
// For now we only do very basic reject processing, limited to
// determining all isolated groups of sectors (islands that are
// surrounded by void space).
//
void PutReject()
{
    if (!current_build_info.do_reject || level_sectors.size() == 0)
    {
        // just create an empty reject lump
        CreateLevelLump("REJECT")->Finish();
        return;
    }

    Reject_Init();
    Reject_GroupSectors();
    Reject_ProcessSectors();

#if DEBUG_REJECT
    Reject_DebugGroups();
#endif

    Reject_WriteLump();
    Reject_Free();

    LogPrintf("    Reject size: %d\n", reject_total_size);
}

//------------------------------------------------------------------------
// LEVEL : Level structure read/write functions.
//------------------------------------------------------------------------

// Note: ZDoom format support based on code (C) 2002,2003 Randy Heit

// per-level variables

const char *level_current_name;

int level_current_idx;
int level_current_start;

MapFormat level_format;

bool level_long_name;
bool level_force_v5;
bool level_force_xnod;
bool level_overflows;

// objects of loaded level, and stuff we've built
std::vector<Vertex *>  level_vertices;
std::vector<Linedef *> level_linedefs;
std::vector<Sidedef *> level_sidedefs;
std::vector<Sector *>  level_sectors;
std::vector<Thing *>   level_things;

std::vector<Seg *>       level_segs;
std::vector<Subsector *> level_subsecs;
std::vector<Node *>      level_nodes;
std::vector<WallTip *>   level_walltips;

int num_old_vert   = 0;
int num_new_vert   = 0;
int num_real_lines = 0;

/* ----- allocation routines ---------------------------- */

Vertex *NewVertex()
{
    Vertex *V = (Vertex *)UtilCalloc(sizeof(Vertex));
    V->index_ = (int)level_vertices.size();
    level_vertices.push_back(V);
    return V;
}

Linedef *NewLinedef()
{
    Linedef *L = (Linedef *)UtilCalloc(sizeof(Linedef));
    L->index   = (int)level_linedefs.size();
    level_linedefs.push_back(L);
    return L;
}

Sidedef *NewSidedef()
{
    Sidedef *S = (Sidedef *)UtilCalloc(sizeof(Sidedef));
    S->index   = (int)level_sidedefs.size();
    level_sidedefs.push_back(S);
    return S;
}

Sector *NewSector()
{
    Sector *S = (Sector *)UtilCalloc(sizeof(Sector));
    S->index  = (int)level_sectors.size();
    level_sectors.push_back(S);
    return S;
}

Thing *NewThing()
{
    Thing *T = (Thing *)UtilCalloc(sizeof(Thing));
    T->index = (int)level_things.size();
    level_things.push_back(T);
    return T;
}

Seg *NewSeg()
{
    Seg *S = (Seg *)UtilCalloc(sizeof(Seg));
    level_segs.push_back(S);
    return S;
}

Subsector *NewSubsec()
{
    Subsector *S = (Subsector *)UtilCalloc(sizeof(Subsector));
    level_subsecs.push_back(S);
    return S;
}

Node *NewNode()
{
    Node *N = (Node *)UtilCalloc(sizeof(Node));
    level_nodes.push_back(N);
    return N;
}

WallTip *NewWallTip()
{
    WallTip *WT = (WallTip *)UtilCalloc(sizeof(WallTip));
    level_walltips.push_back(WT);
    return WT;
}

/* ----- free routines ---------------------------- */

void FreeVertices()
{
    for (unsigned int i = 0; i < level_vertices.size(); i++)
        UtilFree((void *)level_vertices[i]);

    level_vertices.clear();
}

void FreeLinedefs()
{
    for (unsigned int i = 0; i < level_linedefs.size(); i++)
        UtilFree((void *)level_linedefs[i]);

    level_linedefs.clear();
}

void FreeSidedefs()
{
    for (unsigned int i = 0; i < level_sidedefs.size(); i++)
        UtilFree((void *)level_sidedefs[i]);

    level_sidedefs.clear();
}

void FreeSectors()
{
    for (unsigned int i = 0; i < level_sectors.size(); i++)
        UtilFree((void *)level_sectors[i]);

    level_sectors.clear();
}

void FreeThings()
{
    for (unsigned int i = 0; i < level_things.size(); i++)
        UtilFree((void *)level_things[i]);

    level_things.clear();
}

void FreeSegs()
{
    for (unsigned int i = 0; i < level_segs.size(); i++)
        UtilFree((void *)level_segs[i]);

    level_segs.clear();
}

void FreeSubsecs()
{
    for (unsigned int i = 0; i < level_subsecs.size(); i++)
        UtilFree((void *)level_subsecs[i]);

    level_subsecs.clear();
}

void FreeNodes()
{
    for (unsigned int i = 0; i < level_nodes.size(); i++)
        UtilFree((void *)level_nodes[i]);

    level_nodes.clear();
}

void FreeWallTips()
{
    for (unsigned int i = 0; i < level_walltips.size(); i++)
        UtilFree((void *)level_walltips[i]);

    level_walltips.clear();
}

/* ----- reading routines ------------------------------ */

static const char *GetLevelName(int level_index)
{
    SYS_ASSERT(cur_wad != nullptr);

    int lump_idx = cur_wad->LevelHeader(level_index);

    return cur_wad->GetLump(lump_idx)->Name();
}

static Vertex *SafeLookupVertex(int num)
{
    if (num >= level_vertices.size())
        ErrorPrintf("AJBSP: illegal vertex number #%d\n", num);

    return level_vertices[num];
}

static Sector *SafeLookupSector(uint16_t num)
{
    if (num == 0xFFFF) return nullptr;

    if (num >= level_sectors.size())
        ErrorPrintf("AJBSP: illegal sector number #%d\n", (int)num);

    return level_sectors[num];
}

static inline Sidedef *SafeLookupSidedef(uint16_t num)
{
    if (num == 0xFFFF) return nullptr;

    // silently ignore illegal sidedef numbers
    if (num >= (unsigned int)level_sidedefs.size()) return nullptr;

    return level_sidedefs[num];
}

void GetVertices()
{
    int count = 0;

    Lump *lump = FindLevelLump("VERTEXES");

    if (lump) count = lump->Length() / (int)sizeof(RawVertex);

#if DEBUG_LOAD
    DebugPrintf("GetVertices: num = %d\n", count);
#endif

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to vertices.\n");

    for (int i = 0; i < count; i++)
    {
        RawVertex raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading vertices.\n");

        Vertex *vert = NewVertex();

        vert->x_ = (double)AlignedLittleEndianS16(raw.x);
        vert->y_ = (double)AlignedLittleEndianS16(raw.y);
    }

    num_old_vert = level_vertices.size();
}

void GetSectors()
{
    int count = 0;

    Lump *lump = FindLevelLump("SECTORS");

    if (lump) count = lump->Length() / (int)sizeof(RawSector);

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to sectors.\n");

#if DEBUG_LOAD
    DebugPrintf("GetSectors: num = %d\n", count);
#endif

    for (int i = 0; i < count; i++)
    {
        RawSector raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading sectors.\n");

        Sector *sector = NewSector();

        (void)sector;
    }
}

void GetThings()
{
    int count = 0;

    Lump *lump = FindLevelLump("THINGS");

    if (lump) count = lump->Length() / (int)sizeof(RawThing);

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to things.\n");

#if DEBUG_LOAD
    DebugPrintf("GetThings: num = %d\n", count);
#endif

    for (int i = 0; i < count; i++)
    {
        RawThing raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading things.\n");

        Thing *thing = NewThing();

        thing->x    = AlignedLittleEndianS16(raw.x);
        thing->y    = AlignedLittleEndianS16(raw.y);
        thing->type = AlignedLittleEndianU16(raw.type);
    }
}

void GetThingsHexen()
{
    int count = 0;

    Lump *lump = FindLevelLump("THINGS");

    if (lump) count = lump->Length() / (int)sizeof(RawHexenThing);

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to things.\n");

#if DEBUG_LOAD
    DebugPrintf("GetThingsHexen: num = %d\n", count);
#endif

    for (int i = 0; i < count; i++)
    {
        RawHexenThing raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading things.\n");

        Thing *thing = NewThing();

        thing->x    = AlignedLittleEndianS16(raw.x);
        thing->y    = AlignedLittleEndianS16(raw.y);
        thing->type = AlignedLittleEndianU16(raw.type);
    }
}

void GetSidedefs()
{
    int count = 0;

    Lump *lump = FindLevelLump("SIDEDEFS");

    if (lump) count = lump->Length() / (int)sizeof(RawSidedef);

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to sidedefs.\n");

#if DEBUG_LOAD
    DebugPrintf("GetSidedefs: num = %d\n", count);
#endif

    for (int i = 0; i < count; i++)
    {
        RawSidedef raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading sidedefs.\n");

        Sidedef *side = NewSidedef();

        side->sector = SafeLookupSector(AlignedLittleEndianS16(raw.sector));
    }
}

void GetLinedefs()
{
    int count = 0;

    Lump *lump = FindLevelLump("LINEDEFS");

    if (lump) count = lump->Length() / (int)sizeof(RawLinedef);

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to linedefs.\n");

#if DEBUG_LOAD
    DebugPrintf("GetLinedefs: num = %d\n", count);
#endif

    for (int i = 0; i < count; i++)
    {
        RawLinedef raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading linedefs.\n");

        Linedef *line;

        Vertex *start = SafeLookupVertex(AlignedLittleEndianU16(raw.start));
        Vertex *end   = SafeLookupVertex(AlignedLittleEndianU16(raw.end));

        start->is_used_ = true;
        end->is_used_   = true;

        line = NewLinedef();

        line->start = start;
        line->end   = end;

        // check for zero-length line
        line->zero_length = (fabs(start->x_ - end->x_) < kEpsilon) &&
                            (fabs(start->y_ - end->y_) < kEpsilon);

        line->type     = AlignedLittleEndianU16(raw.type);
        uint16_t flags = AlignedLittleEndianU16(raw.flags);
        int16_t  tag   = AlignedLittleEndianS16(raw.tag);

        line->two_sided = (flags & kLineFlagTwoSided) != 0;
        line->is_precious =
            (tag >= 900 &&
             tag < 1000);  // Why is this the case? Need to investigate - Dasho

        line->right = SafeLookupSidedef(AlignedLittleEndianU16(raw.right));
        line->left  = SafeLookupSidedef(AlignedLittleEndianU16(raw.left));

        if (line->right || line->left) num_real_lines++;

        line->self_referencing = (line->left && line->right &&
                                  (line->left->sector == line->right->sector));

        if (line->self_referencing) line->is_precious = true;
    }
}

void GetLinedefsHexen()
{
    int count = 0;

    Lump *lump = FindLevelLump("LINEDEFS");

    if (lump) count = lump->Length() / (int)sizeof(RawHexenLinedef);

    if (lump == nullptr || count == 0) return;

    if (!lump->Seek(0)) ErrorPrintf("AJBSP: Error seeking to linedefs.\n");

#if DEBUG_LOAD
    DebugPrintf("GetLinedefsHexen: num = %d\n", count);
#endif

    for (int i = 0; i < count; i++)
    {
        RawHexenLinedef raw;

        if (!lump->Read(&raw, sizeof(raw)))
            ErrorPrintf("AJBSP: Error reading linedefs.\n");

        Linedef *line;

        Vertex *start = SafeLookupVertex(AlignedLittleEndianU16(raw.start));
        Vertex *end   = SafeLookupVertex(AlignedLittleEndianU16(raw.end));

        start->is_used_ = true;
        end->is_used_   = true;

        line = NewLinedef();

        line->start = start;
        line->end   = end;

        // check for zero-length line
        line->zero_length = (fabs(start->x_ - end->x_) < kEpsilon) &&
                            (fabs(start->y_ - end->y_) < kEpsilon);

        line->type     = (uint8_t)raw.type;
        uint16_t flags = AlignedLittleEndianU16(raw.flags);

        // -JL- Added missing twosided flag handling that caused a broken reject
        line->two_sided = (flags & kLineFlagTwoSided) != 0;

        line->right = SafeLookupSidedef(AlignedLittleEndianU16(raw.right));
        line->left  = SafeLookupSidedef(AlignedLittleEndianU16(raw.left));

        if (line->right || line->left) num_real_lines++;

        line->self_referencing = (line->left && line->right &&
                                  (line->left->sector == line->right->sector));

        if (line->self_referencing) line->is_precious = true;
    }
}

static inline int VanillaSegDist(const Seg *seg)
{
    double lx = seg->side_ ? seg->linedef_->end->x_ : seg->linedef_->start->x_;
    double ly = seg->side_ ? seg->linedef_->end->y_ : seg->linedef_->start->y_;

    // use the "true" starting coord (as stored in the wad)
    double sx = round(seg->start_->x_);
    double sy = round(seg->start_->y_);

    return (int)floor(hypot(sx - lx, sy - ly) + 0.5);
}

static inline int VanillaSegAngle(const Seg *seg)
{
    // compute the "true" delta
    double dx = round(seg->end_->x_) - round(seg->start_->x_);
    double dy = round(seg->end_->y_) - round(seg->start_->y_);

    double angle = ComputeAngle(dx, dy);

    if (angle < 0) angle += 360.0;

    int result = (int)floor(angle * 65536.0 / 360.0 + 0.5);

    return (result & 0xFFFF);
}

/* ----- UDMF reading routines ------------------------- */

void ParseThingField(Thing *thing, const std::string &key,
                     const std::string &value)
{
    if (StringCaseCompareASCII(key, "x") == 0)
        thing->x = RoundToInteger(ajparse::LexDouble(value));
    else if (StringCaseCompareASCII(key, "y") == 0)
        thing->y = RoundToInteger(ajparse::LexDouble(value));
    else if (StringCaseCompareASCII(key, "type") == 0)
        thing->type = ajparse::LexInteger(value);
}

void ParseVertexField(Vertex *vertex, const std::string &key,
                      const std::string &value)
{
    if (StringCaseCompareASCII(key, "x") == 0)
        vertex->x_ = ajparse::LexDouble(value);
    else if (StringCaseCompareASCII(key, "y") == 0)
        vertex->y_ = ajparse::LexDouble(value);
}

void ParseSidedefField(Sidedef *side, const std::string &key,
                       const std::string &value)
{
    if (StringCaseCompareASCII(key, "sector") == 0)
    {
        int num = ajparse::LexInteger(value);

        if (num < 0 || num >= level_sectors.size())
            ErrorPrintf("AJBSP: illegal sector number #%d\n", (int)num);

        side->sector = level_sectors[num];
    }
}

void ParseLinedefField(Linedef *line, const std::string &key,
                       const std::string &value)
{
    if (StringCaseCompareASCII(key, "v1") == 0)
        line->start = SafeLookupVertex(ajparse::LexInteger(value));
    else if (StringCaseCompareASCII(key, "v2") == 0)
        line->end = SafeLookupVertex(ajparse::LexInteger(value));
    else if (StringCaseCompareASCII(key, "special") == 0)
        line->type = ajparse::LexInteger(value);
    else if (StringCaseCompareASCII(key, "twosided") == 0)
        line->two_sided = ajparse::LexBoolean(value);
    else if (StringCaseCompareASCII(key, "sidefront") == 0)
    {
        int num = ajparse::LexInteger(value);

        if (num < 0 || num >= (int)level_sidedefs.size())
            line->right = nullptr;
        else
            line->right = level_sidedefs[num];
    }
    else if (StringCaseCompareASCII(key, "sideback") == 0)
    {
        int num = ajparse::LexInteger(value);

        if (num < 0 || num >= (int)level_sidedefs.size())
            line->left = nullptr;
        else
            line->left = level_sidedefs[num];
    }
}

void ParseUDMF_Block(ajparse::Lexer &lex, int cur_type)
{
    Vertex  *vertex = nullptr;
    Thing   *thing  = nullptr;
    Sidedef *side   = nullptr;
    Linedef *line   = nullptr;

    switch (cur_type)
    {
        case kUDMFVertex:
            vertex = NewVertex();
            break;
        case kUDMFThing:
            thing = NewThing();
            break;
        case kUDMFSector:
            NewSector();  // We don't use the returned pointer in this function
            break;
        case kUDMFSidedef:
            side = NewSidedef();
            break;
        case kUDMFLinedef:
            line = NewLinedef();
            break;
        default:
            break;
    }

    for (;;)
    {
        if (lex.Match("}")) break;

        std::string key;
        std::string value;

        ajparse::TokenKind tok = lex.Next(key);

        if (tok == ajparse::kTokenEOF)
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump: unclosed block\n");

        if (tok != ajparse::kTokenIdentifier)
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump: missing key\n");

        if (!lex.Match("="))
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump: missing '='\n");

        tok = lex.Next(value);

        if (tok == ajparse::kTokenEOF || tok == ajparse::kTokenError ||
            value == "}")
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump: missing value\n");

        if (!lex.Match(";"))
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump: missing ';'\n");

        switch (cur_type)
        {
            case kUDMFVertex:
                ParseVertexField(vertex, key, value);
                break;
            case kUDMFThing:
                ParseThingField(thing, key, value);
                break;
            case kUDMFSidedef:
                ParseSidedefField(side, key, value);
                break;
            case kUDMFLinedef:
                ParseLinedefField(line, key, value);
                break;
            case kUDMFSector:
            default: /* just skip it */
                break;
        }
    }

    // validate stuff

    if (line != nullptr)
    {
        if (line->start == nullptr || line->end == nullptr)
            ErrorPrintf("AJBSP: Linedef #%d is missing a vertex!\n",
                        line->index);

        if (line->right || line->left) num_real_lines++;

        line->self_referencing = (line->left && line->right &&
                                  (line->left->sector == line->right->sector));

        if (line->self_referencing) line->is_precious = true;
    }
}

void ParseUDMF_Pass(const std::string &data, int pass)
{
    // pass = 1 : vertices, sectors, things
    // pass = 2 : sidedefs
    // pass = 3 : linedefs

    ajparse::Lexer lex(data);

    for (;;)
    {
        std::string        section;
        ajparse::TokenKind tok = lex.Next(section);

        if (tok == ajparse::kTokenEOF) return;

        if (tok != ajparse::kTokenIdentifier)
        {
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump.\n");
            return;
        }

        // ignore top-level assignments
        if (lex.Match("="))
        {
            lex.Next(section);
            if (!lex.Match(";"))
                ErrorPrintf("AJBSP: Malformed TEXTMAP lump: missing ';'\n");
            continue;
        }

        if (!lex.Match("{"))
            ErrorPrintf("AJBSP: Malformed TEXTMAP lump: missing '{'\n");

        int cur_type = 0;

        if (StringCaseCompareASCII(section, "thing") == 0)
        {
            if (pass == 1) cur_type = kUDMFThing;
        }
        else if (StringCaseCompareASCII(section, "vertex") == 0)
        {
            if (pass == 1) cur_type = kUDMFVertex;
        }
        else if (StringCaseCompareASCII(section, "sector") == 0)
        {
            if (pass == 1) cur_type = kUDMFSector;
        }
        else if (StringCaseCompareASCII(section, "sidedef") == 0)
        {
            if (pass == 2) cur_type = kUDMFSidedef;
        }
        else if (StringCaseCompareASCII(section, "linedef") == 0)
        {
            if (pass == 3) cur_type = kUDMFLinedef;
        }

        // process the block
        ParseUDMF_Block(lex, cur_type);
    }
}

void ParseUDMF()
{
    Lump *lump = FindLevelLump("TEXTMAP");

    if (lump == nullptr || !lump->Seek(0))
        ErrorPrintf("AJBSP: Error finding TEXTMAP lump.\n");

    // load the lump into this string
    std::string data(lump->Length(), 0);
    if (!lump->Read(data.data(), lump->Length()))
        ErrorPrintf("AJBSP: Error reading TEXTMAP lump.\n");

    // now parse it...

    // the UDMF spec does not require objects to be in a dependency order.
    // for example: sidedefs may occur *after* the linedefs which refer to
    // them.  hence we perform multiple passes over the TEXTMAP data.

    ParseUDMF_Pass(data, 1);
    ParseUDMF_Pass(data, 2);
    ParseUDMF_Pass(data, 3);

    num_old_vert = level_vertices.size();
}

/* ----- writing routines ------------------------------ */

static const uint8_t *level_v2_magic = (uint8_t *)"gNd2";
static const uint8_t *level_v5_magic = (uint8_t *)"gNd5";

static inline uint16_t VertexIndex16Bit(const Vertex *v)
{
    if (v->is_new_) return (uint16_t)(v->index_ | 0x8000U);

    return (uint16_t)v->index_;
}

static inline uint32_t VertexIndexV5(const Vertex *v)
{
    if (v->is_new_) return (uint32_t)(v->index_ | 0x80000000U);

    return (uint32_t)v->index_;
}

static void PutVertices(const char *name)
{
    int count, i;

    // this size is worst-case scenario
    int size = level_vertices.size() * (int)sizeof(RawVertex);

    Lump *lump = CreateLevelLump(name, size);

    for (i = 0, count = 0; i < level_vertices.size(); i++)
    {
        RawVertex raw;

        const Vertex *vert = level_vertices[i];

        if (0 != (vert->is_new_ ? 1 : 0)) { continue; }

        raw.x = AlignedLittleEndianS16(RoundToInteger(vert->x_));
        raw.y = AlignedLittleEndianS16(RoundToInteger(vert->y_));

        lump->Write(&raw, sizeof(raw));

        count++;
    }

    lump->Finish();

    if (count != num_old_vert)
        ErrorPrintf("PutVertices miscounted (%d != %d)\n", count, num_old_vert);

    if (count > 65534)
    {
        LogPrintf("Number of vertices has overflowed.\n");
        level_overflows = true;
    }
}

static void PutGLVertices(int do_v5)
{
    int count, i;

    // this size is worst-case scenario
    int size = 4 + level_vertices.size() * (int)sizeof(RawV2Vertex);

    Lump *lump = CreateLevelLump("GL_VERT", size);

    if (do_v5)
        lump->Write(level_v5_magic, 4);
    else
        lump->Write(level_v2_magic, 4);

    for (i = 0, count = 0; i < level_vertices.size(); i++)
    {
        RawV2Vertex raw;

        const Vertex *vert = level_vertices[i];

        if (!vert->is_new_) continue;

        raw.x = AlignedLittleEndianS32(RoundToInteger(vert->x_ * 65536.0));
        raw.y = AlignedLittleEndianS32(RoundToInteger(vert->y_ * 65536.0));

        lump->Write(&raw, sizeof(raw));

        count++;
    }

    lump->Finish();

    if (count != num_new_vert)
        ErrorPrintf("AJBSP: PutGLVertices miscounted (%d != %d)\n", count,
                    num_new_vert);
}

static void PutSegs()
{
    // this size is worst-case scenario
    int size = level_segs.size() * (int)sizeof(RawSeg);

    Lump *lump = CreateLevelLump("SEGS", size);

    for (int i = 0; i < level_segs.size(); i++)
    {
        RawSeg raw;

        const Seg *seg = level_segs[i];

        raw.start   = AlignedLittleEndianU16(VertexIndex16Bit(seg->start_));
        raw.end     = AlignedLittleEndianU16(VertexIndex16Bit(seg->end_));
        raw.angle   = AlignedLittleEndianU16(VanillaSegAngle(seg));
        raw.linedef = AlignedLittleEndianU16(seg->linedef_->index);
        raw.flip    = AlignedLittleEndianU16(seg->side_);
        raw.dist    = AlignedLittleEndianU16(VanillaSegDist(seg));

        lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
        DebugPrintf(
            "PUT SEG: %04X  Vert %04X->%04X  Line %04X %s  "
            "Angle %04X  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
            seg->index, AlignedLittleEndianU16(raw.start),
            AlignedLittleEndianU16(raw.end),
            AlignedLittleEndianU16(raw.linedef), seg->side ? "L" : "R",
            AlignedLittleEndianU16(raw.angle), seg->start->x, seg->start->y,
            seg->end->x, seg->end->y);
#endif
    }

    lump->Finish();

    if (level_segs.size() > 65534)
    {
        LogPrintf("Number of segs has overflowed.\n");
        level_overflows = true;
    }
}

static void PutGLSegsV2()
{
    // should not happen (we should have upgraded to V5)
    SYS_ASSERT(level_segs.size() <= 65534);

    // this size is worst-case scenario
    int size = level_segs.size() * (int)sizeof(RawGLSeg);

    Lump *lump = CreateLevelLump("GL_SEGS", size);

    for (int i = 0; i < level_segs.size(); i++)
    {
        RawGLSeg raw;

        const Seg *seg = level_segs[i];

        raw.start = AlignedLittleEndianU16(VertexIndex16Bit(seg->start_));
        raw.end   = AlignedLittleEndianU16(VertexIndex16Bit(seg->end_));
        raw.side  = AlignedLittleEndianU16(seg->side_);

        if (seg->linedef_ != NULL)
            raw.linedef = AlignedLittleEndianU16(seg->linedef_->index);
        else
            raw.linedef = AlignedLittleEndianU16(0xFFFF);

        if (seg->partner_ != NULL)
            raw.partner = AlignedLittleEndianU16(seg->partner_->index_);
        else
            raw.partner = AlignedLittleEndianU16(0xFFFF);

        lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
        DebugPrintf(
            "PUT GL SEG: %04X  Line %04X %s  Partner %04X  "
            "(%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
            seg->index, AlignedLittleEndianU16(raw.linedef),
            seg->side ? "L" : "R", AlignedLittleEndianU16(raw.partner),
            seg->start->x, seg->start->y, seg->end->x, seg->end->y);
#endif
    }

    lump->Finish();
}

static void PutGLSegsV5()
{
    // this size is worst-case scenario
    int size = level_segs.size() * (int)sizeof(RawV5Seg);

    Lump *lump = CreateLevelLump("GL_SEGS", size);

    for (int i = 0; i < level_segs.size(); i++)
    {
        RawV5Seg raw;

        const Seg *seg = level_segs[i];

        raw.start = AlignedLittleEndianU32(VertexIndexV5(seg->start_));
        raw.end   = AlignedLittleEndianU32(VertexIndexV5(seg->end_));
        raw.side  = AlignedLittleEndianU16(seg->side_);

        if (seg->linedef_ != NULL)
            raw.linedef = AlignedLittleEndianU16(seg->linedef_->index);
        else
            raw.linedef = AlignedLittleEndianU16(0xFFFF);

        if (seg->partner_ != NULL)
            raw.partner = AlignedLittleEndianU32(seg->partner_->index_);
        else
            raw.partner = AlignedLittleEndianU32(0xFFFFFFFF);

        lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
        DebugPrintf(
            "PUT V3 SEG: %06X  Line %04X %s  Partner %06X  "
            "(%1.1f,%1.1f) -> (%1.1f,%1.1f)\n",
            seg->index, AlignedLittleEndianU16(raw.linedef),
            seg->side ? "L" : "R", AlignedLittleEndianU32(raw.partner),
            seg->start->x, seg->start->y, seg->end->x, seg->end->y);
#endif
    }

    lump->Finish();
}

void PutSubsecs(const char *name, int do_gl)
{
    int size = level_subsecs.size() * (int)sizeof(RawSubsector);

    Lump *lump = CreateLevelLump(name, size);

    for (int i = 0; i < level_subsecs.size(); i++)
    {
        RawSubsector raw;

        const Subsector *sub = level_subsecs[i];

        raw.first = AlignedLittleEndianU16(sub->seg_list_->index_);
        raw.num   = AlignedLittleEndianU16(sub->seg_count_);

        lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
        DebugPrintf("PUT SUBSEC %04X  First %04X  Num %04X\n", sub->index,
                    AlignedLittleEndianU16(raw.first),
                    AlignedLittleEndianU16(raw.num));
#endif
    }

    if (level_subsecs.size() > 32767)
    {
        LogPrintf("Number of %s has overflowed.\n",
                  do_gl ? "GL subsectors" : "subsectors");
        level_overflows = true;
    }

    lump->Finish();
}

void PutGLSubsecsV5()
{
    int size = level_subsecs.size() * (int)sizeof(RawV5Subsector);

    Lump *lump = CreateLevelLump("GL_SSECT", size);

    for (int i = 0; i < level_subsecs.size(); i++)
    {
        RawV5Subsector raw;

        const Subsector *sub = level_subsecs[i];

        raw.first = AlignedLittleEndianU32(sub->seg_list_->index_);
        raw.num   = AlignedLittleEndianU32(sub->seg_count_);

        lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
        DebugPrintf("PUT V3 SUBSEC %06X  First %06X  Num %06X\n", sub->index,
                    AlignedLittleEndianU32(raw.first),
                    AlignedLittleEndianU32(raw.num));
#endif
    }

    lump->Finish();
}

static int node_current_index;

static void PutOneNode(Node *node, Lump *lump)
{
    if (node->r_.node) PutOneNode(node->r_.node, lump);

    if (node->l_.node) PutOneNode(node->l_.node, lump);

    node->index_ = node_current_index++;

    RawNode raw;

    // note that x/y/dx/dy are always integral in non-UDMF maps
    raw.x  = AlignedLittleEndianS16(RoundToInteger(node->x_));
    raw.y  = AlignedLittleEndianS16(RoundToInteger(node->y_));
    raw.dx = AlignedLittleEndianS16(RoundToInteger(node->dx_));
    raw.dy = AlignedLittleEndianS16(RoundToInteger(node->dy_));

    raw.b1.minx = AlignedLittleEndianS16(node->r_.bounds.minx);
    raw.b1.miny = AlignedLittleEndianS16(node->r_.bounds.miny);
    raw.b1.maxx = AlignedLittleEndianS16(node->r_.bounds.maxx);
    raw.b1.maxy = AlignedLittleEndianS16(node->r_.bounds.maxy);

    raw.b2.minx = AlignedLittleEndianS16(node->l_.bounds.minx);
    raw.b2.miny = AlignedLittleEndianS16(node->l_.bounds.miny);
    raw.b2.maxx = AlignedLittleEndianS16(node->l_.bounds.maxx);
    raw.b2.maxy = AlignedLittleEndianS16(node->l_.bounds.maxy);

    if (node->r_.node)
        raw.right = AlignedLittleEndianU16(node->r_.node->index_);
    else if (node->r_.subsec)
        raw.right = AlignedLittleEndianU16(node->r_.subsec->index_ | 0x8000);
    else
        ErrorPrintf("AJBSP: Bad right child in node %d\n", node->index_);

    if (node->l_.node)
        raw.left = AlignedLittleEndianU16(node->l_.node->index_);
    else if (node->l_.subsec)
        raw.left = AlignedLittleEndianU16(node->l_.subsec->index_ | 0x8000);
    else
        ErrorPrintf("AJBSP: Bad left child in node %d\n", node->index_);

    lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
    DebugPrintf(
        "PUT NODE %04X  Left %04X  Right %04X  "
        "(%d,%d) -> (%d,%d)\n",
        node->index, AlignedLittleEndianU16(raw.left),
        AlignedLittleEndianU16(raw.right), node->x, node->y, node->x + node->dx,
        node->y + node->dy);
#endif
}

static void PutOneNodeV5(Node *node, Lump *lump)
{
    if (node->r_.node) PutOneNodeV5(node->r_.node, lump);

    if (node->l_.node) PutOneNodeV5(node->l_.node, lump);

    node->index_ = node_current_index++;

    RawV5Node raw;

    raw.x  = AlignedLittleEndianS16(RoundToInteger(node->x_));
    raw.y  = AlignedLittleEndianS16(RoundToInteger(node->y_));
    raw.dx = AlignedLittleEndianS16(RoundToInteger(node->dx_));
    raw.dy = AlignedLittleEndianS16(RoundToInteger(node->dy_));

    raw.b1.minx = AlignedLittleEndianS16(node->r_.bounds.minx);
    raw.b1.miny = AlignedLittleEndianS16(node->r_.bounds.miny);
    raw.b1.maxx = AlignedLittleEndianS16(node->r_.bounds.maxx);
    raw.b1.maxy = AlignedLittleEndianS16(node->r_.bounds.maxy);

    raw.b2.minx = AlignedLittleEndianS16(node->l_.bounds.minx);
    raw.b2.miny = AlignedLittleEndianS16(node->l_.bounds.miny);
    raw.b2.maxx = AlignedLittleEndianS16(node->l_.bounds.maxx);
    raw.b2.maxy = AlignedLittleEndianS16(node->l_.bounds.maxy);

    if (node->r_.node)
        raw.right = AlignedLittleEndianU32(node->r_.node->index_);
    else if (node->r_.subsec)
        raw.right =
            AlignedLittleEndianU32(node->r_.subsec->index_ | 0x80000000U);
    else
        ErrorPrintf("AJBSP: Bad right child in V5 node %d\n", node->index_);

    if (node->l_.node)
        raw.left = AlignedLittleEndianU32(node->l_.node->index_);
    else if (node->l_.subsec)
        raw.left =
            AlignedLittleEndianU32(node->l_.subsec->index_ | 0x80000000U);
    else
        ErrorPrintf("AJBSP: Bad left child in V5 node %d\n", node->index_);

    lump->Write(&raw, sizeof(raw));

#if DEBUG_BSP
    DebugPrintf(
        "PUT V5 NODE %08X  Left %08X  Right %08X  "
        "(%d,%d) -> (%d,%d)\n",
        node->index, AlignedLittleEndianU32(raw.left),
        AlignedLittleEndianU32(raw.right), node->x, node->y, node->x + node->dx,
        node->y + node->dy);
#endif
}

void PutNodes(const char *name, int do_v5, Node *root)
{
    int struct_size = do_v5 ? (int)sizeof(RawV5Node) : (int)sizeof(RawNode);

    // this can be bigger than the actual size, but never smaller
    int max_size = (level_nodes.size() + 1) * struct_size;

    Lump *lump = CreateLevelLump(name, max_size);

    node_current_index = 0;

    if (root != NULL)
    {
        if (do_v5)
            PutOneNodeV5(root, lump);
        else
            PutOneNode(root, lump);
    }

    lump->Finish();

    if (node_current_index != level_nodes.size())
        ErrorPrintf("AJBSP: PutNodes miscounted (%d != %d)\n",
                    node_current_index, level_nodes.size());

    if (!do_v5 && node_current_index > 32767)
    {
        LogPrintf("Number of nodes has overflowed.\n");
        level_overflows = true;
    }
}

static inline uint32_t VertexIndexXNOD(const Vertex *v)
{
    if (v->is_new_) return (uint32_t)(num_old_vert + v->index_);

    return (uint32_t)v->index_;
}

void CheckLimits()
{
    // this could potentially be 65536, since there are no reserved values
    // for sectors, but there may be source ports or tools treating 0xFFFF
    // as a special value, so we are extra cautious here (and in some of
    // the other checks below, like the vertex counts).
    if (level_sectors.size() > 65535)
    {
        LogPrintf("AJBSP: Map has too many sectors.\n");
        level_overflows = true;
    }

    // the sidedef 0xFFFF is reserved to mean "no side" in DOOM map format
    if (level_sidedefs.size() > 65535)
    {
        LogPrintf("AJBSP: Map has too many sidedefs.\n");
        level_overflows = true;
    }

    // the linedef 0xFFFF is reserved for minisegs in GL nodes
    if (level_linedefs.size() > 65535)
    {
        LogPrintf("AJBSP: Map has too many linedefs.\n");
        level_overflows = true;
    }

    if (current_build_info.build_gl_nodes && !current_build_info.force_v5_nodes)
    {
        if (num_old_vert > 32767 || num_new_vert > 32767 ||
            level_segs.size() > 65535 || level_nodes.size() > 32767)
        {
            DebugPrintf("AJBSP: Forcing V5 of GL-Nodes due to overflows.\n");
            level_force_v5 = true;
        }
    }

    if (!current_build_info.force_xnod_format)
    {
        if (num_old_vert > 32767 || num_new_vert > 32767 ||
            level_segs.size() > 32767 || level_nodes.size() > 32767)
        {
            DebugPrintf("AJBSP: Forcing XNOD format nodes due to overflows.\n");
            level_force_xnod = true;
        }
    }
}

struct CompareSegPredicate
{
    inline bool operator()(const Seg *A, const Seg *B) const
    {
        return A->index_ < B->index_;
    }
};

void SortSegs()
{
    // do a sanity check
    for (int i = 0; i < level_segs.size(); i++)
        if (level_segs[i]->index_ < 0)
            ErrorPrintf("AJBSP: Seg %p never reached a subsector!\n", i);

    // sort segs into ascending index
    std::sort(level_segs.begin(), level_segs.end(), CompareSegPredicate());

    // remove unwanted segs
    while (level_segs.size() > 0 && level_segs.back()->index_ == kSegIsGarbage)
    {
        UtilFree((void *)level_segs.back());
        level_segs.pop_back();
    }
}

/* ----- ZDoom format writing --------------------------- */

static const uint8_t *level_XNOD_magic = (uint8_t *)"XNOD";
static const uint8_t *level_ZNOD_magic = (uint8_t *)"ZNOD";
static const uint8_t *level_XGL3_magic = (uint8_t *)"XGL3";
static const uint8_t *level_ZGL3_magic = (uint8_t *)"ZGL3";

void PutZVertices()
{
    int count, i;

    uint32_t orgverts = AlignedLittleEndianU32(num_old_vert);
    uint32_t newverts = AlignedLittleEndianU32(num_new_vert);

    ZLibAppendLump(&orgverts, 4);
    ZLibAppendLump(&newverts, 4);

    for (i = 0, count = 0; i < level_vertices.size(); i++)
    {
        RawV2Vertex raw;

        const Vertex *vert = level_vertices[i];

        if (!vert->is_new_) continue;

        raw.x = AlignedLittleEndianS32(RoundToInteger(vert->x_ * 65536.0));
        raw.y = AlignedLittleEndianS32(RoundToInteger(vert->y_ * 65536.0));

        ZLibAppendLump(&raw, sizeof(raw));

        count++;
    }

    if (count != num_new_vert)
        ErrorPrintf("AJBSP: PutZVertices miscounted (%d != %d)\n", count,
                    num_new_vert);
}

void PutZSubsecs()
{
    uint32_t Rawnum = AlignedLittleEndianU32(level_subsecs.size());
    ZLibAppendLump(&Rawnum, 4);

    int cur_seg_index = 0;

    for (int i = 0; i < level_subsecs.size(); i++)
    {
        const Subsector *sub = level_subsecs[i];

        Rawnum = AlignedLittleEndianU32(sub->seg_count_);
        ZLibAppendLump(&Rawnum, 4);

        // sanity check the seg index values
        int count = 0;
        for (const Seg *seg = sub->seg_list_; seg;
             seg            = seg->next_, cur_seg_index++)
        {
            if (cur_seg_index != seg->index_)
                ErrorPrintf(
                    "AJBSP: PutZSubsecs: seg index mismatch in sub %d (%d != "
                    "%d)\n",
                    i, cur_seg_index, seg->index_);

            count++;
        }

        if (count != sub->seg_count_)
            ErrorPrintf(
                "AJBSP: PutZSubsecs: miscounted segs in sub %d (%d != %d)\n", i,
                count, sub->seg_count_);
    }

    if (cur_seg_index != level_segs.size())
        ErrorPrintf("AJBSP: PutZSubsecs miscounted segs (%d != %d)\n",
                    cur_seg_index, level_segs.size());
}

void PutZSegs()
{
    uint32_t Rawnum = AlignedLittleEndianU32(level_segs.size());
    ZLibAppendLump(&Rawnum, 4);

    for (int i = 0; i < level_segs.size(); i++)
    {
        const Seg *seg = level_segs[i];

        if (seg->index_ != i)
            ErrorPrintf("AJBSP: PutZSegs: seg index mismatch (%d != %d)\n",
                        seg->index_, i);

        uint32_t v1 = AlignedLittleEndianU32(VertexIndexXNOD(seg->start_));
        uint32_t v2 = AlignedLittleEndianU32(VertexIndexXNOD(seg->end_));

        uint16_t line = AlignedLittleEndianU16(seg->linedef_->index);
        uint8_t  side = (uint8_t)seg->side_;

        ZLibAppendLump(&v1, 4);
        ZLibAppendLump(&v2, 4);
        ZLibAppendLump(&line, 2);
        ZLibAppendLump(&side, 1);
    }
}

void PutXGL3Segs()
{
    uint32_t Rawnum = AlignedLittleEndianU32(level_segs.size());
    ZLibAppendLump(&Rawnum, 4);

    for (int i = 0; i < level_segs.size(); i++)
    {
        const Seg *seg = level_segs[i];

        if (seg->index_ != i)
            ErrorPrintf("AJBSP: PutXGL3Segs: seg index mismatch (%d != %d)\n",
                        seg->index_, i);

        uint32_t v1 = AlignedLittleEndianU32(VertexIndexXNOD(seg->start_));
        uint32_t partner =
            AlignedLittleEndianU32(seg->partner_ ? seg->partner_->index_ : -1);
        uint32_t line =
            AlignedLittleEndianU32(seg->linedef_ ? seg->linedef_->index : -1);
        uint8_t side = (uint8_t)seg->side_;

        ZLibAppendLump(&v1, 4);
        ZLibAppendLump(&partner, 4);
        ZLibAppendLump(&line, 4);
        ZLibAppendLump(&side, 1);

#if DEBUG_BSP
        fprintf(stderr, "SEG[%d] v1=%d partner=%d line=%d side=%d\n", i, v1,
                partner, line, side);
#endif
    }
}

static void PutOneZNode(Node *node, bool do_xgl3)
{
    RawV5Node raw;

    if (node->r_.node) PutOneZNode(node->r_.node, do_xgl3);

    if (node->l_.node) PutOneZNode(node->l_.node, do_xgl3);

    node->index_ = node_current_index++;

    if (do_xgl3)
    {
        uint32_t x = AlignedLittleEndianS32(RoundToInteger(node->x_ * 65536.0));
        uint32_t y = AlignedLittleEndianS32(RoundToInteger(node->y_ * 65536.0));
        uint32_t dx =
            AlignedLittleEndianS32(RoundToInteger(node->dx_ * 65536.0));
        uint32_t dy =
            AlignedLittleEndianS32(RoundToInteger(node->dy_ * 65536.0));

        ZLibAppendLump(&x, 4);
        ZLibAppendLump(&y, 4);
        ZLibAppendLump(&dx, 4);
        ZLibAppendLump(&dy, 4);
    }
    else
    {
        raw.x  = AlignedLittleEndianS16(RoundToInteger(node->x_));
        raw.y  = AlignedLittleEndianS16(RoundToInteger(node->y_));
        raw.dx = AlignedLittleEndianS16(RoundToInteger(node->dx_));
        raw.dy = AlignedLittleEndianS16(RoundToInteger(node->dy_));

        ZLibAppendLump(&raw.x, 2);
        ZLibAppendLump(&raw.y, 2);
        ZLibAppendLump(&raw.dx, 2);
        ZLibAppendLump(&raw.dy, 2);
    }

    raw.b1.minx = AlignedLittleEndianS16(node->r_.bounds.minx);
    raw.b1.miny = AlignedLittleEndianS16(node->r_.bounds.miny);
    raw.b1.maxx = AlignedLittleEndianS16(node->r_.bounds.maxx);
    raw.b1.maxy = AlignedLittleEndianS16(node->r_.bounds.maxy);

    raw.b2.minx = AlignedLittleEndianS16(node->l_.bounds.minx);
    raw.b2.miny = AlignedLittleEndianS16(node->l_.bounds.miny);
    raw.b2.maxx = AlignedLittleEndianS16(node->l_.bounds.maxx);
    raw.b2.maxy = AlignedLittleEndianS16(node->l_.bounds.maxy);

    ZLibAppendLump(&raw.b1, sizeof(raw.b1));
    ZLibAppendLump(&raw.b2, sizeof(raw.b2));

    if (node->r_.node)
        raw.right = AlignedLittleEndianU32(node->r_.node->index_);
    else if (node->r_.subsec)
        raw.right =
            AlignedLittleEndianU32(node->r_.subsec->index_ | 0x80000000U);
    else
        ErrorPrintf("AJBSP: Bad right child in V5 node %d\n", node->index_);

    if (node->l_.node)
        raw.left = AlignedLittleEndianU32(node->l_.node->index_);
    else if (node->l_.subsec)
        raw.left =
            AlignedLittleEndianU32(node->l_.subsec->index_ | 0x80000000U);
    else
        ErrorPrintf("AJBSP: Bad left child in V5 node %d\n", node->index_);

    ZLibAppendLump(&raw.right, 4);
    ZLibAppendLump(&raw.left, 4);

#if DEBUG_BSP
    DebugPrintf(
        "PUT Z NODE %08X  Left %08X  Right %08X  "
        "(%d,%d) -> (%d,%d)\n",
        node->index, AlignedLittleEndianU32(raw.left),
        AlignedLittleEndianU32(raw.right), node->x, node->y, node->x + node->dx,
        node->y + node->dy);
#endif
}

void PutZNodes(Node *root, bool do_xgl3)
{
    uint32_t Rawnum = AlignedLittleEndianU32(level_nodes.size());
    ZLibAppendLump(&Rawnum, 4);

    node_current_index = 0;

    if (root) PutOneZNode(root, do_xgl3);

    if (node_current_index != level_nodes.size())
        ErrorPrintf("AJBSP: PutZNodes miscounted (%d != %d)\n",
                    node_current_index, level_nodes.size());
}

static int CalcZDoomNodesSize()
{
    // compute size of the ZDoom format nodes.
    // it does not need to be exact, but it *does* need to be bigger
    // (or equal) to the actual size of the lump.

    int size = 32;  // header + a bit extra

    size += 8 + level_vertices.size() * 8;
    size += 4 + level_subsecs.size() * 4;
    size += 4 + level_segs.size() * 11;
    size += 4 + level_nodes.size() * sizeof(RawV5Node);

    if (current_build_info.compress_nodes)
    {
        // according to RFC1951, the zlib compression worst-case
        // scenario is 5 extra bytes per 32KB (0.015% increase).
        // we are significantly more conservative!

        size += ((size + 255) >> 5);
    }

    return size;
}

static void SaveZDFormat(Node *root_node)
{
    // leave SEGS and SSECTORS empty
    CreateLevelLump("SEGS")->Finish();
    CreateLevelLump("SSECTORS")->Finish();

    int max_size = CalcZDoomNodesSize();

    Lump *lump = CreateLevelLump("NODES", max_size);

    if (current_build_info.compress_nodes)
        lump->Write(level_ZNOD_magic, 4);
    else
        lump->Write(level_XNOD_magic, 4);

    // the ZLibXXX functions do no compression for XNOD format
    ZLibBeginLump(lump);

    PutZVertices();
    PutZSubsecs();
    PutZSegs();
    PutZNodes(root_node, false);

    ZLibFinishLump();
}

void SaveXGL3Format(Lump *lump, Node *root_node)
{
    // WISH : compute a max_size

    if (current_build_info.compress_nodes)
        lump->Write(level_ZGL3_magic, 4);
    else
        lump->Write(level_XGL3_magic, 4);

    ZLibBeginLump(lump);

    PutZVertices();
    PutZSubsecs();
    PutXGL3Segs();
    PutZNodes(root_node, true);

    ZLibFinishLump();
}

/* ----- whole-level routines --------------------------- */

void LoadLevel()
{
    Lump *LEV = cur_wad->GetLump(level_current_start);

    level_current_name = LEV->Name();
    level_long_name    = false;

    num_new_vert   = 0;
    num_real_lines = 0;

    if (level_format == kMapFormatUDMF) { ParseUDMF(); }
    else
    {
        GetVertices();
        GetSectors();
        GetSidedefs();

        if (level_format == kMapFormatHexen)
        {
            GetLinedefsHexen();
            GetThingsHexen();
        }
        else
        {
            GetLinedefs();
            GetThings();
        }

        // always prune vertices at end of lump, otherwise all the
        // unused vertices from seg splits would keep accumulating.
        PruneVerticesAtEnd();
    }

    DebugPrintf(
        "    Loaded %d vertices, %d sectors, %d sides, %d lines, %d things\n",
        level_vertices.size(), level_sectors.size(), level_sidedefs.size(),
        level_linedefs.size(), level_things.size());

    DetectOverlappingVertices();
    DetectOverlappingLines();

    CalculateWallTips();

    // -JL- Find sectors containing polyobjs
    switch (level_format)
    {
        case kMapFormatHexen:
            DetectPolyobjSectors(false);
            break;
        case kMapFormatUDMF:
            DetectPolyobjSectors(true);
            break;
        default:
            break;
    }
}

void FreeLevel()
{
    FreeVertices();
    FreeSidedefs();
    FreeLinedefs();
    FreeSectors();
    FreeThings();
    FreeSegs();
    FreeSubsecs();
    FreeNodes();
    FreeWallTips();
    FreeIntersections();
}

static uint32_t CalculateGLChecksum(void)
{
    uint32_t crc;

    Adler32Begin(&crc);

    Lump *lump = FindLevelLump("VERTEXES");

    if (lump && lump->Length() > 0)
    {
        uint8_t *data = new uint8_t[lump->Length()];

        if (!lump->Seek(0) || !lump->Read(data, lump->Length()))
            ErrorPrintf("AJBSP: Error reading vertices (for checksum).\n");

        Adler32AddBlock(&crc, data, lump->Length());
        delete[] data;
    }

    lump = FindLevelLump("LINEDEFS");

    if (lump && lump->Length() > 0)
    {
        uint8_t *data = new uint8_t[lump->Length()];

        if (!lump->Seek(0) || !lump->Read(data, lump->Length()))
            ErrorPrintf("Error reading linedefs (for checksum).\n");

        Adler32AddBlock(&crc, data, lump->Length());
        delete[] data;
    }

    return crc;
}

void UpdateGLMarker(Lump *marker)
{
    // this is very conservative, around 4 times the actual size
    const int max_size = 512;

    // we *must* compute the checksum BEFORE (re)creating the lump
    // [ otherwise we write data into the wrong part of the file ]
    uint32_t crc = CalculateGLChecksum();

    cur_wad->RecreateLump(marker, max_size);

    if (level_long_name) { marker->Printf("LEVEL=%s\n", level_current_name); }

    marker->Printf("BUILDER=AJBSP\n");
    marker->Printf("CHECKSUM=0x%08x\n", crc);

    marker->Finish();
}

static void AddMissingLump(const char *name, const char *after)
{
    if (cur_wad->LevelLookupLump(level_current_idx, name) >= 0) return;

    int exist = cur_wad->LevelLookupLump(level_current_idx, after);

    // if this happens, the level structure is very broken
    if (exist < 0)
    {
        LogPrintf("Missing %s lump -- level structure is broken\n", after);

        exist = cur_wad->LevelLastLump(level_current_idx);
    }

    cur_wad->InsertPoint(exist + 1);

    cur_wad->AddLump(name)->Finish();
}

BuildResult SaveLevel(Node *root_node)
{
    // Note: root_node may be NULL

    cur_wad->BeginWrite();

    // remove any existing GL-Nodes
    cur_wad->RemoveGLNodes(level_current_idx);

    // ensure all necessary level lumps are present
    AddMissingLump("SEGS", "VERTEXES");
    AddMissingLump("SSECTORS", "SEGS");
    AddMissingLump("NODES", "SSECTORS");
    AddMissingLump("REJECT", "SECTORS");
    AddMissingLump("BLOCKMAP", "REJECT");

    // user preferences
    level_force_v5   = current_build_info.force_v5_nodes;
    level_force_xnod = current_build_info.force_xnod_format;

    // check for overflows...
    // this sets the force_xxx vars if certain limits are breached
    CheckLimits();

    /* --- GL Nodes --- */

    Lump *gl_marker = NULL;

    if (current_build_info.build_gl_nodes && num_real_lines > 0)
    {
        // this also removes minisegs and degenerate segs
        SortSegs();

        // create empty marker now, flesh it out later
        gl_marker = CreateGLMarker();

        PutGLVertices(level_force_v5);

        if (level_force_v5)
            PutGLSegsV5();
        else
            PutGLSegsV2();

        if (level_force_v5)
            PutGLSubsecsV5();
        else
            PutSubsecs("GL_SSECT", true);

        PutNodes("GL_NODES", level_force_v5, root_node);

        // -JL- Add empty PVS lump
        CreateLevelLump("GL_PVS")->Finish();
    }

    /* --- Normal nodes --- */

    // remove all the mini-segs from subsectors
    NormaliseBspTree();

    if (level_force_xnod && num_real_lines > 0)
    {
        SortSegs();
        SaveZDFormat(root_node);
    }
    else
    {
        // reduce vertex precision for classic DOOM nodes.
        // some segs can become "degenerate" after this, and these
        // are removed from subsectors.
        RoundOffBspTree();

        SortSegs();

        PutVertices("VERTEXES");

        PutSegs();
        PutSubsecs("SSECTORS", false);
        PutNodes("NODES", false, root_node);
    }

    PutBlockmap();
    PutReject();

    // keyword support (v5.0 of the specs).
    // must be done *after* doing normal nodes, for proper checksum.
    if (gl_marker) { UpdateGLMarker(gl_marker); }

    cur_wad->EndWrite();

    if (level_overflows)
    {
        // no message here
        // [ in verbose mode, each overflow already printed a message ]
        // [ in normal mode, we don't want any messages at all ]

        return kBuildOverflow;
    }

    return kBuildOK;
}

BuildResult SaveUDMF(Node *root_node)
{
    cur_wad->BeginWrite();

    // remove any existing ZNODES lump
    cur_wad->RemoveZNodes(level_current_idx);

    Lump *lump = CreateLevelLump("ZNODES", -1);

    if (num_real_lines == 0) { lump->Finish(); }
    else
    {
        SortSegs();
        SaveXGL3Format(lump, root_node);
    }

    cur_wad->EndWrite();

    return kBuildOK;
}

//----------------------------------------------------------------------

static Lump *zout_lump;

static z_stream zout_stream;
static Bytef    zout_buffer[1024];

void ZLibBeginLump(Lump *lump)
{
    zout_lump = lump;

    if (!current_build_info.compress_nodes) return;

    zout_stream.zalloc = (alloc_func)0;
    zout_stream.zfree  = (free_func)0;
    zout_stream.opaque = (voidpf)0;

    if (Z_OK != deflateInit(&zout_stream, Z_DEFAULT_COMPRESSION))
        ErrorPrintf("AJBSP: Trouble setting up zlib compression\n");

    zout_stream.next_out  = zout_buffer;
    zout_stream.avail_out = sizeof(zout_buffer);
}

void ZLibAppendLump(const void *data, int length)
{
    if (!current_build_info.compress_nodes)
    {
        zout_lump->Write(data, length);
        return;
    }

    zout_stream.next_in  = (Bytef *)data;  // const override
    zout_stream.avail_in = length;

    while (zout_stream.avail_in > 0)
    {
        int err = deflate(&zout_stream, Z_NO_FLUSH);

        if (err != Z_OK)
            ErrorPrintf("AJBSP: Trouble compressing %d bytes (zlib)\n", length);

        if (zout_stream.avail_out == 0)
        {
            zout_lump->Write(zout_buffer, sizeof(zout_buffer));

            zout_stream.next_out  = zout_buffer;
            zout_stream.avail_out = sizeof(zout_buffer);
        }
    }
}

void ZLibFinishLump(void)
{
    if (!current_build_info.compress_nodes)
    {
        zout_lump->Finish();
        zout_lump = nullptr;
        return;
    }

    int left_over;

    // ASSERT(zout_stream.avail_out > 0)

    zout_stream.next_in  = Z_NULL;
    zout_stream.avail_in = 0;

    for (;;)
    {
        int err = deflate(&zout_stream, Z_FINISH);

        if (err == Z_STREAM_END) break;

        if (err != Z_OK)
            ErrorPrintf("AJBSP: Trouble finishing compression (zlib)\n");

        if (zout_stream.avail_out == 0)
        {
            zout_lump->Write(zout_buffer, sizeof(zout_buffer));

            zout_stream.next_out  = zout_buffer;
            zout_stream.avail_out = sizeof(zout_buffer);
        }
    }

    left_over = sizeof(zout_buffer) - zout_stream.avail_out;

    if (left_over > 0) zout_lump->Write(zout_buffer, left_over);

    deflateEnd(&zout_stream);

    zout_lump->Finish();
    zout_lump = nullptr;
}

/* ---------------------------------------------------------------- */

Lump *FindLevelLump(const char *name)
{
    int idx = cur_wad->LevelLookupLump(level_current_idx, name);

    if (idx < 0) return nullptr;

    return cur_wad->GetLump(idx);
}

Lump *CreateLevelLump(const char *name, int max_size)
{
    // look for existing one
    Lump *lump = FindLevelLump(name);

    if (lump) { cur_wad->RecreateLump(lump, max_size); }
    else
    {
        int last_idx = cur_wad->LevelLastLump(level_current_idx);

        // in UDMF maps, insert before the ENDMAP lump, otherwise insert
        // after the last known lump of the level.
        if (level_format != kMapFormatUDMF) last_idx += 1;

        cur_wad->InsertPoint(last_idx);

        lump = cur_wad->AddLump(name, max_size);
    }

    return lump;
}

Lump *CreateGLMarker(void)
{
    char name_buf[64];

    if (strlen(level_current_name) <= 5)
    {
        sprintf(name_buf, "GL_%s", level_current_name);

        level_long_name = false;
    }
    else
    {
        // support for level names longer than 5 letters
        strcpy(name_buf, "GL_LEVEL");

        level_long_name = true;
    }

    int last_idx = cur_wad->LevelLastLump(level_current_idx);

    cur_wad->InsertPoint(last_idx + 1);

    Lump *marker = cur_wad->AddLump(name_buf);

    marker->Finish();

    return marker;
}

//------------------------------------------------------------------------
// MAIN STUFF
//------------------------------------------------------------------------

BuildInfo current_build_info;

void SetInfo(const BuildInfo &info)
{
    current_build_info.total_minor_issues = 0;
    current_build_info.total_warnings     = 0;
    current_build_info.split_cost         = kSplitCostDefault;
    current_build_info.compress_nodes     = info.compress_nodes;
    current_build_info.build_gl_nodes     = info.build_gl_nodes;
    current_build_info.force_v5_nodes     = info.force_v5_nodes;
    current_build_info.force_xnod_format  = info.force_xnod_format;
    current_build_info.do_blockmap        = info.do_blockmap;
    current_build_info.do_reject          = info.do_reject;
}

void OpenWad(std::filesystem::path filename)
{
    cur_wad = WadFile::Open(filename, 'a');
    if (cur_wad == nullptr)
        ErrorPrintf("AJBSP: Cannot open file: %s\n",
                    filename.u8string().c_str());
    if (cur_wad->IsReadOnly())
    {
        delete cur_wad;
        cur_wad = nullptr;

        ErrorPrintf("AJBSP: File is read only: %s\n",
                    filename.u8string().c_str());
    }
}

void CloseWad()
{
    if (cur_wad != nullptr)
    {
        // this closes the file
        delete cur_wad;
        cur_wad = nullptr;
    }
}

int LevelsInWad()
{
    if (cur_wad == nullptr) return 0;

    return cur_wad->LevelCount();
}

/* ----- build nodes for a single level ----- */

BuildResult BuildLevel(int level_index)
{
    Node      *root_node = nullptr;
    Subsector *root_sub  = nullptr;

    level_current_idx   = level_index;
    level_current_start = cur_wad->LevelHeader(level_index);
    level_format        = cur_wad->LevelFormat(level_index);

    LoadLevel();

    InitBlockmap();

    BuildResult ret = kBuildOK;

    if (num_real_lines > 0)
    {
        BoundingBox dummy;

        // create initial segs
        Seg *list = CreateSegs();

        // recursively create nodes
        ret = BuildNodes(list, 0, &dummy, &root_node, &root_sub);
    }

    if (ret == kBuildOK)
    {
        DebugPrintf("    Built %d NODES, %d SSECTORS, %d SEGS, %d VERTEXES\n",
                    level_nodes.size(), level_subsecs.size(), level_segs.size(),
                    num_old_vert + num_new_vert);

        if (root_node != nullptr)
        {
            DebugPrintf("    Heights of subtrees: %d / %d\n",
                        ComputeBspHeight(root_node->r_.node),
                        ComputeBspHeight(root_node->l_.node));
        }

        ClockwiseBspTree();

        if (level_format == kMapFormatUDMF)
            ret = SaveUDMF(root_node);
        else
            ret = SaveLevel(root_node);
    }

    FreeLevel();

    return ret;
}

}  // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
