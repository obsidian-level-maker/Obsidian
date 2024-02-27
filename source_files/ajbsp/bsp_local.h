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

#pragma once

#include <vector>

#include "bsp.h"
namespace ajbsp
{

class Lump;
class WadFile;

// storage of node building parameters

extern BuildInfo current_build_info;

//------------------------------------------------------------------------
// LEVEL : Level structures & read/write functions.
//------------------------------------------------------------------------

class Node;
struct Sector;
class QuadTree;

// a wall-tip is where a wall meets a vertex
struct WallTip
{
    // link in list.  List is kept in ANTI-clockwise order.
    WallTip *next;
    WallTip *previous;

    // angle that line makes at vertex (degrees).
    double angle;

    // whether each side of wall is OPEN or CLOSED.
    // left is the side of increasing angles, whereas
    // right is the side of decreasing angles.
    bool open_left;
    bool open_right;
};

class Vertex
{
   public:
    // coordinates
    double x_, y_;

    // vertex index.  Always valid after loading and pruning of unused
    // vertices has occurred.
    int index_;

    // vertex is newly created (from a seg split)
    bool is_new_;

    // when building normal nodes, unused vertices will be pruned.
    bool is_used_;

    // usually nullptr, unless this vertex occupies the same location as a
    // previous vertex.
    Vertex *overlap_;

    // list of wall-tips
    WallTip *tip_set_;

   public:
    // check whether a line with the given delta coordinates from this
    // vertex is open or closed.  If there exists a walltip at same
    // angle, it is closed, likewise if line is in void space.
    bool CheckOpen(double dx, double dy) const;

    void AddWallTip(double dx, double dy, bool open_left, bool open_right);

    bool Overlaps(const Vertex *other) const;
};

struct Sector
{
    // sector index.  Always valid after loading & pruning.
    int index;

    // most info (floor_h, floor_tex, etc) omitted.  We don't need to
    // write the SECTORS lump, only read it.

    // -JL- non-zero if this sector contains a polyobj.
    bool has_polyobject;

    // used when building REJECT table.  Each set of sectors that are
    // isolated from other sectors will have a different group number.
    // Thus: on every 2-sided linedef, the sectors on both sides will be
    // in the same group.  The rej_next, rej_prev fields are a link in a
    // RING, containing all sectors of the same group.
    int reject_group;

    Sector *reject_next;
    Sector *reject_previous;
};

struct Sidedef
{
    // adjacent sector.  Can be nullptr (invalid sidedef)
    Sector *sector;

    // sidedef index.  Always valid after loading & pruning.
    int index;
};

struct Linedef
{
    // link for list
    Linedef *next;

    Vertex *start;  // from this vertex...
    Vertex *end;    // ... to this vertex

    Sidedef *right;  // right sidedef
    Sidedef *left;   // left sidede, or nullptr if none

    int type;

    // line is marked two-sided
    bool two_sided;

    // prefer not to split
    bool is_precious;

    // zero length (line should be totally ignored)
    bool zero_length;

    // sector is the same on both sides
    bool self_referencing;

    // normally nullptr, except when this linedef directly overlaps an earlier
    // one (a rarely-used trick to create higher mid-masked textures).
    // No segs should be created for these overlapping linedefs.
    Linedef *overlap;

    // linedef index.  Always valid after loading & pruning of zero
    // length lines has occurred.
    int index;
};

struct Thing
{
    int x, y;
    int type;

    // other info (angle, and hexen stuff) omitted.  We don't need to
    // write the THINGS lump, only read it.

    // Always valid (thing indices never change).
    int index;
};

class Seg
{
   public:
    // link for list
    Seg *next_;

    Vertex *start_;  // from this vertex...
    Vertex *end_;    // ... to this vertex

    // linedef that this seg goes along, or nullptr if miniseg
    Linedef *linedef_;

    // 0 for right, 1 for left
    int side_;

    // seg on other side, or nullptr if one-sided.  This relationship is
    // always one-to-one -- if one of the segs is split, the partner seg
    // must also be split.
    Seg *partner_;

    // seg index.  Only valid once the seg has been added to a
    // subsector.  A negative value means it is invalid -- there
    // shouldn't be any of these once the BSP tree has been built.
    int index_;

    // when true, this seg has become zero length (integer rounding of the
    // start and end vertices produces the same location).  It should be
    // ignored when writing the SEGS or V1 GL_SEGS lumps.  [Note: there
    // won't be any of these when writing the V2 GL_SEGS lump].
    bool is_degenerate_;

    // the quad-tree node that contains this seg, or nullptr if the seg
    // is now in a subsector.
    QuadTree *quad_;

    // precomputed data for faster calculations
    double psx_, psy_;
    double pex_, pey_;
    double pdx_, pdy_;

    double p_length_;
    double p_para_;
    double p_perp_;

    // linedef that this seg initially comes from.  For "real" segs,
    // this is just the same as the 'linedef' field above.  For
    // "minisegs", this is the linedef of the partition line.
    Linedef *source_line_;

    // this only used by ClockwiseOrder()
    double cmp_angle_;

   public:
    // compute the seg private info (psx/y, pex/y, pdx/y, etc).
    void Recompute();

    int PointOnLineSide(double x, double y) const;

    // compute the parallel and perpendicular distances from a partition
    // line to a point.
    inline double ParallelDistance(double x, double y) const
    {
        return (x * pdx_ + y * pdy_ + p_para_) / p_length_;
    }

    inline double PerpendicularDistance(double x, double y) const
    {
        return (x * pdy_ - y * pdx_ + p_perp_) / p_length_;
    }
};

// a seg with this index is removed by SortSegs().
// it must be a very high value.
constexpr uint32_t kSegIsGarbage = (1 << 29);

class Subsector
{
   public:
    // list of segs
    Seg *seg_list_;

    // count of segs -- only valid after RenumberSegs() is called
    int seg_count_;

    // subsector index.  Always valid, set when the subsector is
    // initially created.
    int index_;

    // approximate middle point
    double mid_x_;
    double mid_y_;

   public:
    void AddToTail(Seg *seg);

    void DetermineMiddle();
    void ClockwiseOrder();
    void RenumberSegs(int &cur_seg_index);

    void RoundOff();
    void Normalise();

    void SanityCheckClosed() const;
    void SanityCheckHasRealSeg() const;
};

struct BoundingBox
{
    int minx, miny;
    int maxx, maxy;
};

struct Child
{
    // child node or subsector (one must be nullptr)
    Node      *node;
    Subsector *subsec;

    // child bounding box
    BoundingBox bounds;
};

class Node
{
   public:
    // these coordinates are high precision to support UDMF.
    // in non-UDMF maps, they will actually be integral since a
    // partition line *always* comes from a normal linedef.

    double x_, y_;    // starting point
    double dx_, dy_;  // offset to ending point

    // right & left children
    Child r_;
    Child l_;

    // node index.  Only valid once the NODES or GL_NODES lump has been
    // created.
    int index_;

   public:
    void SetPartition(const Seg *part);
};

class QuadTree
{
    // NOTE: not a real quadtree, division is always binary.

   public:
    // coordinates on map for this block, from lower-left corner to
    // upper-right corner.  Fully inclusive, i.e (x,y) is inside this
    // block when x1 < x < x2 and y1 < y < y2.
    int x1_, y1_;
    int x2_, y2_;

    // sub-trees.  nullptr for leaf nodes.
    // [0] has the lower coordinates, and [1] has the higher coordinates.
    // Division of a square always occurs horizontally (e.g. 512x512 ->
    // 256x512).
    QuadTree *subs_[2];

    // count of real/mini segs contained in this node AND ALL CHILDREN.
    int real_num_;
    int mini_num_;

    // list of segs completely contained in this node.
    Seg *list_;

   public:
    QuadTree(int _x1, int _y1, int _x2, int _y2);
    ~QuadTree();

    void AddSeg(Seg *seg);
    void AddList(Seg *list);

    inline bool Empty() const { return (real_num_ + mini_num_) == 0; }

    void ConvertToList(Seg **list);

    // check relationship between this box and the partition line.
    // returns -1 or +1 if box is definitively on a particular side,
    // or 0 if the line intersects or touches the box.
    int OnLineSide(const Seg *part) const;
};

/* ----- Level data arrays ----------------------- */

extern std::vector<Vertex *>  level_vertices;
extern std::vector<Linedef *> level_linedefs;
extern std::vector<Sidedef *> level_sidedefs;
extern std::vector<Sector *>  level_sectors;
extern std::vector<Thing *>   level_things;

extern std::vector<Seg *>       level_segs;
extern std::vector<Subsector *> level_subsecs;
extern std::vector<Node *>      level_nodes;
extern std::vector<WallTip *>   level_walltips;

extern int num_old_vert;
extern int num_new_vert;

/* ----- function prototypes ----------------------- */

// allocation routines
Vertex  *NewVertex();
Linedef *NewLinedef();
Sidedef *NewSidedef();
Sector  *NewSector();
Thing   *NewThing();

Seg       *NewSeg();
Subsector *NewSubsec();
Node      *NewNode();
WallTip   *NewWallTip();

Lump *FindLevelLump(const char *name);
Lump *CreateLevelLump(const char *name, int max_size = -1);
Lump *CreateGLMarker(void);

// Zlib compression support
void ZLibBeginLump(Lump *lump);
void ZLibAppendLump(const void *data, int length);
void ZLibFinishLump(void);

//------------------------------------------------------------------------
// ANALYZE : Analyzing level structures
//------------------------------------------------------------------------

// detection routines
void DetectOverlappingVertices(void);
void DetectOverlappingLines(void);
void DetectPolyobjSectors(bool is_udmf);

// pruning routines
void PruneVerticesAtEnd(void);

// computes the wall tips for all of the vertices
void CalculateWallTips(void);

// return a new vertex (with correct wall-tip info) for the split that
// happens along the given seg at the given location.
Vertex *NewVertexFromSplitSeg(Seg *seg, double x, double y);

// return a new end vertex to compensate for a seg that would end up
// being zero-length (after integer rounding).  Doesn't compute the wall-tip
// info (thus this routine should only be used *after* node building).
Vertex *NewVertexDegenerate(Vertex *start, Vertex *end);

//------------------------------------------------------------------------
// SEG : Choose the best Seg to use for a node line.
//------------------------------------------------------------------------

constexpr float kIffySegLength = 4.0f;

// smallest distance between two points before being considered equal
// also used for smallest degree between two angles
constexpr double kEpsilon = (1.0 / 1024.0);

inline void ListAddSeg(Seg **list_ptr, Seg *seg)
{
    seg->next_ = *list_ptr;
    *list_ptr  = seg;
}

// an "intersection" remembers the vertex that touches a BSP divider
// line (especially a new vertex that is created at a seg split).

struct Intersection
{
    // link in list.  The intersection list is kept sorted by
    // along_dist, in ascending order.
    Intersection *next;
    Intersection *prev;

    // vertex in question
    Vertex *vertex;

    // how far along the partition line the vertex is.  Zero is at the
    // partition seg's start point, positive values move in the same
    // direction as the partition's direction, and negative values move
    // in the opposite direction.
    double along_dist;

    // true if this intersection was on a self-referencing linedef
    bool self_ref;

    // status of each side of the vertex (along the partition),
    // true if OPEN and false if CLOSED.
    bool open_before;
    bool open_after;
};

/* -------- functions ---------------------------- */

void FreeIntersections(void);

//------------------------------------------------------------------------
// NODE : Recursively create nodes and return the pointers.
//------------------------------------------------------------------------

// scan all the linedef of the level and convert each sidedef into a
// seg (or seg pair).  Returns the list of segs.
Seg *CreateSegs(void);

// takes the seg list and determines if it is convex.  When it is, the
// segs are converted to a subsector, and '*S' is the new subsector
// (and '*N' is set to nullptr).  Otherwise the seg list is divided into
// two halves, a node is created by calling this routine recursively,
// and '*N' is the new node (and '*S' is set to nullptr).  Normally
// returns kBuildOK, or BUILD_Cancelled if user stopped it.
BuildResult BuildNodes(Seg *list, int depth, BoundingBox *bounds /* output */,
                       Node **N, Subsector **S);

// compute the height of the bsp tree, starting at 'node'.
int ComputeBspHeight(const Node *node);

// put all the segs in each subsector into clockwise order, and renumber
// the seg indices.
//
// [ This cannot be done DURING BuildNodes() since splitting a seg with
//   a partner will insert another seg into that partner's list, usually
//   in the wrong place order-wise. ]
void ClockwiseBspTree();

// traverse the BSP tree and do whatever is necessary to convert the
// node information from GL standard to normal standard (for example,
// removing minisegs).
void NormaliseBspTree();

// traverse the BSP tree, doing whatever is necessary to round
// vertices to integer coordinates (for example, removing segs whose
// rounded coordinates degenerate to the same point).
void RoundOffBspTree();

}  // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
