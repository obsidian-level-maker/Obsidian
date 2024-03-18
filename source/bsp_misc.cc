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

#include <vector>

#include "AlmostEquals.h"
#include "bsp_local.h"
#include "bsp_utility.h"
#include "bsp_wad.h"
#include "dm_defs.h"
#include "sys_debug.h"
#include "sys_macro.h"
#define DEBUG_WALLTIPS  0
#define DEBUG_POLYOBJ   0
#define DEBUG_WINDOW_FX 0
#define DEBUG_OVERLAPS  0

static constexpr uint8_t kPolyObjectBoxSize = 10;

static int CheckLinedefInsideBox(int xmin, int ymin, int xmax, int ymax, int x1, int y1, int x2, int y2)
{
    int count = 2;
    int tmp;

    for (;;)
    {
        if (y1 > ymax)
        {
            if (y2 > ymax)
                return false;

            x1 = x1 + (int)((x2 - x1) * (double)(ymax - y1) / (double)(y2 - y1));
            y1 = ymax;

            count = 2;
            continue;
        }

        if (y1 < ymin)
        {
            if (y2 < ymin)
                return false;

            x1 = x1 + (int)((x2 - x1) * (double)(ymin - y1) / (double)(y2 - y1));
            y1 = ymin;

            count = 2;
            continue;
        }

        if (x1 > xmax)
        {
            if (x2 > xmax)
                return false;

            y1 = y1 + (int)((y2 - y1) * (double)(xmax - x1) / (double)(x2 - x1));
            x1 = xmax;

            count = 2;
            continue;
        }

        if (x1 < xmin)
        {
            if (x2 < xmin)
                return false;

            y1 = y1 + (int)((y2 - y1) * (double)(xmin - x1) / (double)(x2 - x1));
            x1 = xmin;

            count = 2;
            continue;
        }

        count--;

        if (count == 0)
            break;

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

namespace ajbsp
{

//------------------------------------------------------------------------
// ANALYZE : Analyzing level structures
//------------------------------------------------------------------------

/* ----- polyobj handling ----------------------------- */

void MarkPolyobjSector(Sector *sector)
{
    if (sector == nullptr)
        return;

#if DEBUG_POLYOBJ
    DebugPrintf("  Marking SECTOR %d\n", sector->index);
#endif

    /* already marked ? */
    if (sector->has_polyobject)
        return;

    // mark all lines of this sector as precious, to prevent (ideally)
    // the sector from being split.
    sector->has_polyobject = true;

    for (int i = 0; i < level_linedefs.size(); i++)
    {
        Linedef *L = level_linedefs[i];

        if ((L->right != nullptr && L->right->sector == sector) || (L->left != nullptr && L->left->sector == sector))
        {
            L->is_precious = true;
        }
    }
}

void MarkPolyobjPoint(double x, double y)
{
    int i;
    int inside_count = 0;

    double         best_dist  = 999999;
    const Linedef *best_match = nullptr;
    Sector        *sector     = nullptr;

    // -AJA- First we handle the "awkward" cases where the polyobj sits
    //       directly on a linedef or even a vertex.  We check all lines
    //       that intersect a small box around the spawn point.

    int bminx = (int)(x - kPolyObjectBoxSize);
    int bminy = (int)(y - kPolyObjectBoxSize);
    int bmaxx = (int)(x + kPolyObjectBoxSize);
    int bmaxy = (int)(y + kPolyObjectBoxSize);

    for (i = 0; i < level_linedefs.size(); i++)
    {
        const Linedef *L = level_linedefs[i];

        if (CheckLinedefInsideBox(bminx, bminy, bmaxx, bmaxy, (int)L->start->x_, (int)L->start->y_, (int)L->end->x_,
                                  (int)L->end->y_))
        {
#if DEBUG_POLYOBJ
            DebugPrintf("  Touching line was %d\n", L->index);
#endif

            if (L->left != nullptr)
                MarkPolyobjSector(L->left->sector);

            if (L->right != nullptr)
                MarkPolyobjSector(L->right->sector);

            inside_count++;
        }
    }

    if (inside_count > 0)
        return;

    // -AJA- Algorithm is just like in DEU: we cast a line horizontally
    //       from the given (x,y) position and find all linedefs that
    //       intersect it, choosing the one with the closest distance.
    //       If the point is sitting directly on a (two-sided) line,
    //       then we mark the sectors on both sides.

    for (i = 0; i < level_linedefs.size(); i++)
    {
        const Linedef *L = level_linedefs[i];

        double x1 = L->start->x_;
        double y1 = L->start->y_;
        double x2 = L->end->x_;
        double y2 = L->end->y_;

        /* check vertical range */
        if (fabs(y2 - y1) < kEpsilon)
            continue;

        if ((y > (y1 + kEpsilon) && y > (y2 + kEpsilon)) || (y < (y1 - kEpsilon) && y < (y2 - kEpsilon)))
            continue;

        double x_cut = x1 + (x2 - x1) * (y - y1) / (y2 - y1) - x;

        if (fabs(x_cut) < fabs(best_dist))
        {
            /* found a closer linedef */

            best_match = L;
            best_dist  = x_cut;
        }
    }

    if (best_match == nullptr)
    {
        LogPrintf("Bad polyobj thing at (%1.0f,%1.0f).\n", x, y);
        current_build_info.total_warnings++;
        return;
    }

    double y1 = best_match->start->y_;
    double y2 = best_match->end->y_;

#if DEBUG_POLYOBJ
    DebugPrintf("  Closest line was %d Y=%1.0f..%1.0f (dist=%1.1f)\n", best_match->index, y1, y2, best_dist);
#endif

    /* sanity check: shouldn't be directly on the line */
#if DEBUG_POLYOBJ
    if (fabs(best_dist) < kEpsilon)
    {
        DebugPrintf("  Polyobj FAILURE: directly on the line (%d)\n", best_match->index);
    }
#endif

    /* check orientation of line, to determine which side the polyobj is
     * actually on.
     */
    if ((y1 > y2) == (best_dist > 0))
        sector = best_match->right ? best_match->right->sector : nullptr;
    else
        sector = best_match->left ? best_match->left->sector : nullptr;

#if DEBUG_POLYOBJ
    DebugPrintf("  Sector %d contains the polyobj.\n", sector ? sector->index : -1);
#endif

    if (sector == nullptr)
    {
        LogPrintf("Invalid Polyobj thing at (%1.0f,%1.0f).\n", x, y);
        current_build_info.total_warnings++;
        return;
    }

    MarkPolyobjSector(sector);
}

//
// Based on code courtesy of Janis Legzdinsh.
//
void DetectPolyobjSectors(bool is_udmf)
{
    int i;

    // -JL- There's a conflict between Hexen polyobj thing types and Doom thing
    //      types. In Doom type 3001 is for Imp and 3002 for Demon. To solve
    //      this problem, first we are going through all lines to see if the
    //      level has any polyobjs. If found, we also must detect what polyobj
    //      thing types are used - Hexen ones or ZDoom ones. That's why we
    //      are going through all things searching for ZDoom polyobj thing
    //      types. If any found, we assume that ZDoom polyobj thing types are
    //      used, otherwise Hexen polyobj thing types are used.

    // -AJA- With UDMF there is an additional ambiguity, as line type 1 is a
    //       very common door in Doom and Heretic namespaces, but it is also
    //       the HEXTYPE_POLY_EXPLICIT special in Hexen and ZDoom namespaces.
    //
    //       Since the plain "Hexen" namespace is rare for UDMF maps, and ZDoom
    //       ports prefer their own polyobj things, we disable the Hexen polyobj
    //       things in UDMF maps.

    // -JL- First go through all lines to see if level contains any polyobjs
    for (i = 0; i < level_linedefs.size(); i++)
    {
        Linedef *L = level_linedefs[i];

        if (L->type == kHexenPolyobjectStart || L->type == kHexenPolyobjectExplicit)
            break;
    }

    if (i == level_linedefs.size())
    {
        // -JL- No polyobjs in this level
        return;
    }

    // -JL- Detect what polyobj thing types are used - Hexen ones or ZDoom ones
    bool hexen_style = true;

    if (is_udmf)
        hexen_style = false;

    for (i = 0; i < level_things.size(); i++)
    {
        Thing *T = level_things[i];

        if (T->type == kZDoomPolyobjectSpawnType || T->type == kZDoomPolyobjectSpawnCrushType)
        {
            // -JL- A ZDoom style polyobj thing found
            hexen_style = false;
            break;
        }
    }

#if DEBUG_POLYOBJ
    DebugPrintf("Using %s style polyobj things\n", hexen_style ? "HEXEN" : "ZDOOM");
#endif

    for (i = 0; i < level_things.size(); i++)
    {
        Thing *T = level_things[i];

        double x = (double)T->x;
        double y = (double)T->y;

        // ignore everything except polyobj start spots
        if (hexen_style)
        {
            // -JL- Hexen style polyobj things
            if (T->type != kPolyobjectSpawnType && T->type != kPolyobjectSpawnCrushType)
                continue;
        }
        else
        {
            // -JL- ZDoom style polyobj things
            if (T->type != kZDoomPolyobjectSpawnType && T->type != kZDoomPolyobjectSpawnCrushType)
                continue;
        }

#if DEBUG_POLYOBJ
        DebugPrintf("Thing %d at (%1.0f,%1.0f) is a polyobj spawner.\n", i, x, y);
#endif

        MarkPolyobjPoint(x, y);
    }
}

/* ----- analysis routines ----------------------------- */

bool Vertex::Overlaps(const Vertex *other) const
{
    double dx = fabs(other->x_ - x_);
    double dy = fabs(other->y_ - y_);

    return (dx < kEpsilon) && (dy < kEpsilon);
}

// cmpVertex and revised *Compare functions adapted from k8vavoom
static inline int cmpVertex(const Vertex *A, const Vertex *B)
{
    const double xdiff = (A->x_ - B->x_);
    if (fabs(xdiff) > 0.0001)
        return (xdiff < 0 ? -1 : 1);

    const double ydiff = (A->y_ - B->y_);
    if (fabs(ydiff) > 0.0001)
        return (ydiff < 0 ? -1 : 1);

    return 0;
}

static int VertexCompare(const void *p1, const void *p2)
{
    int vert1 = ((const uint32_t *)p1)[0];
    int vert2 = ((const uint32_t *)p2)[0];

    if (vert1 == vert2)
        return 0;

    Vertex *A = level_vertices[vert1];
    Vertex *B = level_vertices[vert2];

    return cmpVertex(A, B);
}

void DetectOverlappingVertices(void)
{
    int       i;
    uint32_t *array = (uint32_t *)UtilCalloc(level_vertices.size() * sizeof(uint32_t));

    // sort array of indices
    for (i = 0; i < level_vertices.size(); i++)
        array[i] = i;

    qsort(array, level_vertices.size(), sizeof(uint32_t), VertexCompare);

    // now mark them off
    for (i = 0; i < level_vertices.size() - 1; i++)
    {
        // duplicate ?
        if (VertexCompare(array + i, array + i + 1) == 0)
        {
            Vertex *A = level_vertices[array[i]];
            Vertex *B = level_vertices[array[i + 1]];

            // found an overlap !
            B->overlap_ = A->overlap_ ? A->overlap_ : A;
        }
    }

    UtilFree(array);

    // update the linedefs

    // update all in-memory linedefs.
    // DOES NOT affect the on-disk linedefs.
    // this is mainly to help the miniseg creation code.

    for (i = 0; i < level_linedefs.size(); i++)
    {
        Linedef *L = level_linedefs[i];

        while (L->start->overlap_)
        {
            L->start = L->start->overlap_;
        }

        while (L->end->overlap_)
        {
            L->end = L->end->overlap_;
        }
    }
}

void PruneVerticesAtEnd(void)
{
    int old_num = level_vertices.size();

    // scan all vertices.
    // only remove from the end, so stop when hit a used one.

    for (int i = level_vertices.size() - 1; i >= 0; i--)
    {
        Vertex *V = level_vertices[i];

        if (V->is_used_)
            break;

        UtilFree(V);

        level_vertices.pop_back();
    }

    int unused = old_num - level_vertices.size();

    if (unused > 0)
    {
        DebugPrintf("    Pruned %d unused vertices at end\n", unused);
    }

    num_old_vert = level_vertices.size();
}

static inline int LineVertexLowest(const Linedef *L)
{
    // returns the "lowest" vertex (normally the left-most, but if the
    // line is vertical, then the bottom-most) => 0 for start, 1 for end.

    return ((int)L->start->x_ < (int)L->end->x_ ||
            ((int)L->start->x_ == (int)L->end->x_ && (int)L->start->y_ < (int)L->end->y_))
               ? 0
               : 1;
}

static int LineStartCompare(const void *p1, const void *p2)
{
    int line1 = ((const int *)p1)[0];
    int line2 = ((const int *)p2)[0];

    if (line1 == line2)
        return 0;

    Linedef *A = level_linedefs[line1];
    Linedef *B = level_linedefs[line2];

    // determine left-most vertex of each line
    Vertex *C = LineVertexLowest(A) ? A->end : A->start;
    Vertex *D = LineVertexLowest(B) ? B->end : B->start;

    return cmpVertex(C, D);
}

static int LineEndCompare(const void *p1, const void *p2)
{
    int line1 = ((const int *)p1)[0];
    int line2 = ((const int *)p2)[0];

    if (line1 == line2)
        return 0;

    Linedef *A = level_linedefs[line1];
    Linedef *B = level_linedefs[line2];

    // determine right-most vertex of each line
    Vertex *C = LineVertexLowest(A) ? A->start : A->end;
    Vertex *D = LineVertexLowest(B) ? B->start : B->end;

    return cmpVertex(C, D);
}

void DetectOverlappingLines(void)
{
    // Algorithm:
    //   Sort all lines by left-most vertex.
    //   Overlapping lines will then be near each other in this set.
    //   Note: does not detect partially overlapping lines.

    int  i;
    int *array = (int *)UtilCalloc(level_linedefs.size() * sizeof(int));
    int  count = 0;

    // sort array of indices
    for (i = 0; i < level_linedefs.size(); i++)
        array[i] = i;

    qsort(array, level_linedefs.size(), sizeof(int), LineStartCompare);

    for (i = 0; i < level_linedefs.size() - 1; i++)
    {
        int j;

        for (j = i + 1; j < level_linedefs.size(); j++)
        {
            if (LineStartCompare(array + i, array + j) != 0)
                break;

            if (LineEndCompare(array + i, array + j) == 0)
            {
                // found an overlap !

                Linedef *A = level_linedefs[array[i]];
                Linedef *B = level_linedefs[array[j]];

                B->overlap = A->overlap ? A->overlap : A;

                count++;
            }
        }
    }

    UtilFree(array);
}

/* ----- vertex routines ------------------------------- */

void Vertex::AddWallTip(double dx, double dy, bool open_left, bool open_right)
{
    SYS_ASSERT(overlap_ == nullptr);

    WallTip *tip = NewWallTip();
    WallTip *after;

    tip->angle      = ComputeAngle(dx, dy);
    tip->open_left  = open_left;
    tip->open_right = open_right;

    // find the correct place (order is increasing angle)
    for (after = tip_set_; after && after->next; after = after->next)
    {
    }

    while (after && tip->angle + kEpsilon < after->angle)
        after = after->previous;

    // link it in
    tip->next     = after ? after->next : tip_set_;
    tip->previous = after;

    if (after)
    {
        if (after->next)
            after->next->previous = tip;

        after->next = tip;
    }
    else
    {
        if (tip_set_ != nullptr)
            tip_set_->previous = tip;

        tip_set_ = tip;
    }
}

void CalculateWallTips()
{
    for (int i = 0; i < level_linedefs.size(); i++)
    {
        const Linedef *L = level_linedefs[i];

        if (L->overlap || L->zero_length)
            continue;

        double x1 = L->start->x_;
        double y1 = L->start->y_;
        double x2 = L->end->x_;
        double y2 = L->end->y_;

        bool left  = (L->left != nullptr) && (L->left->sector != nullptr);
        bool right = (L->right != nullptr) && (L->right->sector != nullptr);

        // note that start->overlap and end->overlap should be nullptr
        // due to logic in DetectOverlappingVertices.

        L->start->AddWallTip(x2 - x1, y2 - y1, left, right);
        L->end->AddWallTip(x1 - x2, y1 - y2, right, left);
    }

#if DEBUG_WALLTIPS
    for (int k = 0; k < level_vertices.size(); k++)
    {
        Vertex *V = level_vertices[k];

        DebugPrintf("WallTips for vertex %d:\n", k);

        for (WallTip *tip = V->tip_set; tip; tip = tip->next)
        {
            DebugPrintf("  Angle=%1.1f left=%d right=%d\n", tip->angle, tip->open_left ? 1 : 0,
                        tip->open_right ? 1 : 0);
        }
    }
#endif
}

Vertex *NewVertexFromSplitSeg(Seg *seg, double x, double y)
{
    Vertex *vert = NewVertex();

    vert->x_ = x;
    vert->y_ = y;

    vert->is_new_  = true;
    vert->is_used_ = true;

    vert->index_ = num_new_vert;
    num_new_vert++;

    // compute wall-tip info
    if (seg->linedef_ == nullptr)
    {
        vert->AddWallTip(seg->pdx_, seg->pdy_, true, true);
        vert->AddWallTip(-seg->pdx_, -seg->pdy_, true, true);
    }
    else
    {
        const Sidedef *front = seg->side_ ? seg->linedef_->left : seg->linedef_->right;
        const Sidedef *back  = seg->side_ ? seg->linedef_->right : seg->linedef_->left;

        bool left  = (back != nullptr) && (back->sector != nullptr);
        bool right = (front != nullptr) && (front->sector != nullptr);

        vert->AddWallTip(seg->pdx_, seg->pdy_, left, right);
        vert->AddWallTip(-seg->pdx_, -seg->pdy_, right, left);
    }

    return vert;
}

Vertex *NewVertexDegenerate(Vertex *start, Vertex *end)
{
    // this is only called when rounding off the BSP tree and
    // all the segs are degenerate (zero length), hence we need
    // to create at least one seg which won't be zero length.

    double dx = end->x_ - start->x_;
    double dy = end->y_ - start->y_;

    double dlen = hypot(dx, dy);

    Vertex *vert = NewVertex();

    vert->is_new_  = false;
    vert->is_used_ = true;

    vert->index_ = num_old_vert;
    num_old_vert++;

    // compute new coordinates

    vert->x_ = start->x_;
    vert->y_ = start->x_;

    if (AlmostEquals(dlen, 0.0))
        ErrorPrintf("AJBSP: NewVertexDegenerate: bad delta!\n");

    dx /= dlen;
    dy /= dlen;

    while (RoundToInteger(vert->x_) == RoundToInteger(start->x_) &&
           RoundToInteger(vert->y_) == RoundToInteger(start->y_))
    {
        vert->x_ += dx;
        vert->y_ += dy;
    }

    return vert;
}

bool Vertex::CheckOpen(double dx, double dy) const
{
    const WallTip *tip;

    double angle = ComputeAngle(dx, dy);

    // first check whether there's a wall-tip that lies in the exact
    // direction of the given direction (which is relative to the
    // vertex).

    for (tip = tip_set_; tip; tip = tip->next)
    {
        if (fabs(tip->angle - angle) < kEpsilon || fabs(tip->angle - angle) > (360.0 - kEpsilon))
        {
            // found one, hence closed
            return false;
        }
    }

    // OK, now just find the first wall-tip whose angle is greater than
    // the angle we're interested in.  Therefore we'll be on the RIGHT
    // side of that wall-tip.

    for (tip = tip_set_; tip; tip = tip->next)
    {
        if (angle + kEpsilon < tip->angle)
        {
            // found it
            return tip->open_right;
        }

        if (!tip->next)
        {
            // no more tips, thus we must be on the LEFT side of the tip
            // with the largest angle.

            return tip->open_left;
        }
    }

    // usually won't get here
    return true;
}

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
