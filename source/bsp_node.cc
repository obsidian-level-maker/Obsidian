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

#include "AlmostEquals.h"
#include "bsp_local.h"
#include "bsp_utility.h"
#include "bsp_wad.h"
#include "sys_debug.h"
#include "sys_macro.h"

#define DEBUG_PICKNODE 0
#define DEBUG_SPLIT    0
#define DEBUG_CUTLIST  0

#define DEBUG_BUILDER 0
#define DEBUG_SORTER  0
#define DEBUG_SUBSEC  0

static constexpr uint8_t kPreciousCostMultiplier = 100;
static constexpr uint8_t kSegFastModeThreshold   = 200;

//
// To be able to divide the nodes down, this routine must decide which
// is the best Seg to use as a nodeline. It does this by selecting the
// line with least splits and has least difference of Segs on either
// side of it.
//
// Credit to Raphael Quinet and DEU, this routine is a copy of the
// nodeline picker used in DEU5beta. I am using this method because
// the method I originally used was not so good.
//
// Rewritten by Lee Killough to significantly improve performance,
// while not affecting results one bit in >99% of cases (some tiny
// differences due to roundoff error may occur, but they are
// insignificant).
//
// Rewritten again by Andrew Apted (-AJA-), 1999-2000.
//

namespace ajbsp
{

class EvalInfo
{
  public:
    double cost;
    int    splits;
    int    iffy;
    int    near_miss;

    int real_left;
    int real_right;
    int mini_left;
    int mini_right;

  public:
    void BumpLeft(const Linedef *linedef)
    {
        if (linedef != nullptr)
            real_left++;
        else
            mini_left++;
    }

    void BumpRight(const Linedef *linedef)
    {
        if (linedef != nullptr)
            real_right++;
        else
            mini_right++;
    }
};

std::vector<Intersection *> alloc_cuts;

Intersection *NewIntersection()
{
    Intersection *cut = new Intersection;

    alloc_cuts.push_back(cut);

    return cut;
}

void FreeIntersections(void)
{
    for (size_t i = 0; i < alloc_cuts.size(); i++)
        delete alloc_cuts[i];

    alloc_cuts.clear();
}

//
// Fill in the fields 'angle', 'len', 'pdx_', 'pdy_', etc...
//
void Seg::Recompute()
{
    psx_ = start_->x_;
    psy_ = start_->y_;
    pex_ = end_->x_;
    pey_ = end_->y_;
    pdx_ = pex_ - psx_;
    pdy_ = pey_ - psy_;

    p_length_ = hypot(pdx_, pdy_);

    if (p_length_ <= 0)
        ErrorPrintf("AJBSP: Seg %p has zero p_length_.\n", this);

    p_perp_ = psy_ * pdx_ - psx_ * pdy_;
    p_para_ = -psx_ * pdx_ - psy_ * pdy_;
}

//
// -AJA- Splits the given seg at the point (x,y).  The new seg is
//       returned.  The old seg is shortened (the original start
//       vertex is unchanged), whereas the new seg becomes the cut-off
//       tail (keeping the original end vertex).
//
//       If the seg has a partner_, than that partner_ is also split.
//       NOTE WELL: the new piece of the partner_ seg is inserted into
//       the same list as the partner_ seg (and after it) -- thus ALL
//       segs (except the one we are currently splitting) must exist
//       on a singly-linked list somewhere.
//
Seg *SplitSeg(Seg *old_seg, double x, double y)
{
#if DEBUG_SPLIT
    if (old_seg->linedef)
        DebugPrintf("Splitting Linedef %d (%p) at (%1.1f,%1.1f)\n", old_seg->linedef->index, old_seg, x, y);
    else
        DebugPrintf("Splitting Miniseg %p at (%1.1f,%1.1f)\n", old_seg, x, y);
#endif

    Vertex *new_vert = NewVertexFromSplitSeg(old_seg, x, y);
    Seg    *new_seg  = NewSeg();

    // copy seg info
    new_seg[0]     = old_seg[0];
    new_seg->next_ = nullptr;

    old_seg->end_   = new_vert;
    new_seg->start_ = new_vert;

    old_seg->Recompute();
    new_seg->Recompute();

#if DEBUG_SPLIT
    DebugPrintf("Splitting Vertex is %04X at (%1.1f,%1.1f)\n", new_vert->index, new_vert->x, new_vert->y);
#endif

    // handle partners

    if (old_seg->partner_)
    {
#if DEBUG_SPLIT
        DebugPrintf("Splitting partner %p\n", old_seg->partner_);
#endif

        new_seg->partner_ = NewSeg();

        // copy seg info
        // [ including the "next" field ]
        new_seg->partner_[0] = old_seg->partner_[0];

        // IMPORTANT: keep partner_ relationship valid.
        new_seg->partner_->partner_ = new_seg;

        old_seg->partner_->start_ = new_vert;
        new_seg->partner_->end_   = new_vert;

        old_seg->partner_->Recompute();
        new_seg->partner_->Recompute();

        // link it into list
        old_seg->partner_->next_ = new_seg->partner_;
    }

    return new_seg;
}

//
// -AJA- In the quest for slime-trail annihilation :->, this routine
//       calculates the intersection location between the current seg
//       and the partitioning seg, and takes advantage of some common
//       situations like horizontal/vertical lines.
//
inline void ComputeIntersection(Seg *seg, Seg *part, double perp_c, double perp_d, double *x, double *y)
{
    // horizontal partition against vertical seg
    if (AlmostEquals(part->pdy_, 0.0) && AlmostEquals(seg->pdx_, 0.0))
    {
        *x = seg->psx_;
        *y = part->psy_;
        return;
    }

    // vertical partition against horizontal seg
    if (AlmostEquals(part->pdx_, 0.0) && AlmostEquals(seg->pdy_, 0.0))
    {
        *x = part->psx_;
        *y = seg->psy_;
        return;
    }

    // 0 = start, 1 = end
    double ds = perp_c / (perp_c - perp_d);

    if (AlmostEquals(seg->pdx_, 0.0))
        *x = seg->psx_;
    else
        *x = seg->psx_ + (seg->pdx_ * ds);

    if (AlmostEquals(seg->pdy_, 0.0))
        *y = seg->psy_;
    else
        *y = seg->psy_ + (seg->pdy_ * ds);
}

void AddIntersection(Intersection **cut_list, Vertex *vert, Seg *part, bool self_ref)
{
    bool open_before = vert->CheckOpen(-part->pdx_, -part->pdy_);
    bool open_after  = vert->CheckOpen(part->pdx_, part->pdy_);

    double along_dist = part->ParallelDistance(vert->x_, vert->y_);

    Intersection *cut;
    Intersection *after;

    /* merge with any existing vertex? */
    for (cut = (*cut_list); cut; cut = cut->next)
    {
        if (vert->Overlaps(cut->vertex))
            return;
    }

    /* create new intersection */
    cut = NewIntersection();

    cut->vertex      = vert;
    cut->along_dist  = along_dist;
    cut->self_ref    = self_ref;
    cut->open_before = open_before;
    cut->open_after  = open_after;

    /* insert the new intersection into the list */

    for (after = (*cut_list); after && after->next; after = after->next)
    {
    }

    while (after && cut->along_dist < after->along_dist)
        after = after->prev;

    /* link it in */
    cut->next = after ? after->next : (*cut_list);
    cut->prev = after;

    if (after)
    {
        if (after->next)
            after->next->prev = cut;

        after->next = cut;
    }
    else
    {
        if (*cut_list)
            (*cut_list)->prev = cut;

        (*cut_list) = cut;
    }
}

//
// Returns true if a "bad seg" was found early.
//
bool EvalPartitionWorker(QuadTree *tree, Seg *part, double best_cost, EvalInfo *info)
{
    double split_cost = current_build_info.split_cost;

    // -AJA- this is the heart of the superblock idea, it tests the
    //       *whole* quad against the partition line to quickly handle
    //       all the segs within it at once.  Only when the partition
    //       line intercepts the box do we need to go deeper into it.

    int side = tree->OnLineSide(part);

    if (side < 0)
    {
        // LEFT

        info->real_left += tree->real_num_;
        info->mini_left += tree->mini_num_;

        return false;
    }
    else if (side > 0)
    {
        // RIGHT

        info->real_right += tree->real_num_;
        info->mini_right += tree->mini_num_;

        return false;
    }

    /* check partition against all Segs */

    for (Seg *check = tree->list_; check; check = check->next_)
    {
        // This is the heart of my pruning idea - it catches
        // bad segs early on. Killough

        if (info->cost > best_cost)
            return true;

        double qnty;

        double a = 0, fa = 0;
        double b = 0, fb = 0;

        /* get state of lines' relation to each other */
        if (check->source_line_ != part->source_line_)
        {
            a = part->PerpendicularDistance(check->psx_, check->psy_);
            b = part->PerpendicularDistance(check->pex_, check->pey_);

            fa = fabs(a);
            fb = fabs(b);
        }

        /* check for being on the same line */
        if (fa <= kEpsilon && fb <= kEpsilon)
        {
            // this seg runs along the same line as the partition.  Check
            // whether it goes in the same direction or the opposite.

            if (check->pdx_ * part->pdx_ + check->pdy_ * part->pdy_ < 0)
                info->BumpLeft(check->linedef_);
            else
                info->BumpRight(check->linedef_);

            continue;
        }

        // -AJA- check for passing through a vertex.  Normally this is fine
        //       (even ideal), but the vertex could on a sector that we
        //       DONT want to split, and the normal linedef-based checks
        //       may fail to detect the sector being cut in half.  Thanks
        //       to Janis Legzdinsh for spotting this obscure bug.

        if (fa <= kEpsilon || fb <= kEpsilon)
        {
            if (check->linedef_ != nullptr && check->linedef_->is_precious)
                info->cost += 40.0 * split_cost * kPreciousCostMultiplier;
        }

        /* check for right side */
        if (a > -kEpsilon && b > -kEpsilon)
        {
            info->BumpRight(check->linedef_);

            /* check for a near miss */
            if ((a >= kIffySegLength && b >= kIffySegLength) || (a <= kEpsilon && b >= kIffySegLength) ||
                (b <= kEpsilon && a >= kIffySegLength))
            {
                continue;
            }

            info->near_miss++;

            // -AJA- near misses are bad, since they have the potential to
            //       cause really short minisegs to be created in future
            //       processing.  Thus the closer the near miss, the higher
            //       the cost.

            if (a <= kEpsilon || b <= kEpsilon)
                qnty = kIffySegLength / OBSIDIAN_MAX(a, b);
            else
                qnty = kIffySegLength / OBSIDIAN_MIN(a, b);

            info->cost += 70.0 * split_cost * (qnty * qnty - 1.0);
            continue;
        }

        /* check for left side */
        if (a < kEpsilon && b < kEpsilon)
        {
            info->BumpLeft(check->linedef_);

            /* check for a near miss */
            if ((a <= -kIffySegLength && b <= -kIffySegLength) || (a >= -kEpsilon && b <= -kIffySegLength) ||
                (b >= -kEpsilon && a <= -kIffySegLength))
            {
                continue;
            }

            info->near_miss++;

            // the closer the miss, the higher the cost (see note above)
            if (a >= -kEpsilon || b >= -kEpsilon)
                qnty = kIffySegLength / -OBSIDIAN_MIN(a, b);
            else
                qnty = kIffySegLength / -OBSIDIAN_MAX(a, b);

            info->cost += 70.0 * split_cost * (qnty * qnty - 1.0);
            continue;
        }

        // When we reach here, we have a and b non-zero and opposite sign,
        // hence this seg will be split by the partition line.

        info->splits++;

        // If the linedef associated with this seg has a tag >= 900, treat
        // it as precious; i.e. don't split it unless all other options
        // are exhausted.  This is used to protect deep water and invisible
        // lifts/stairs from being messed up accidentally by splits.

        if (check->linedef_ && check->linedef_->is_precious)
            info->cost += 100.0 * split_cost * kPreciousCostMultiplier;
        else
            info->cost += 100.0 * split_cost;

        // -AJA- check if the split point is very close to one end, which
        //       is an undesirable situation (producing very short segs).
        //       This is perhaps _one_ source of those darn slime trails.
        //       Hence the name "IFFY segs", and a rather hefty surcharge.

        if (fa < kIffySegLength || fb < kIffySegLength)
        {
            info->iffy++;

            // the closer to the end, the higher the cost
            qnty = kIffySegLength / OBSIDIAN_MIN(fa, fb);
            info->cost += 140.0 * split_cost * (qnty * qnty - 1.0);
        }
    }

    /* handle sub-blocks recursively */

    for (int c = 0; c < 2; c++)
    {
        if (info->cost > best_cost)
            return true;

        if (tree->subs_[c] != nullptr && !tree->subs_[c]->Empty())
        {
            if (EvalPartitionWorker(tree->subs_[c], part, best_cost, info))
                return true;
        }
    }

    /* no "bad seg" was found */
    return false;
}

//
// -AJA- Evaluate a partition seg & determine the cost, taking into
//       account the number of splits, difference between left &
//       right, and linedefs that are tagged 'precious'.
//
// Returns the computed cost, or a negative value if the seg should be
// skipped altogether_.
//
double EvalPartition(QuadTree *tree, Seg *part, double best_cost)
{
    EvalInfo info;

    /* initialise info structure */
    info.cost      = 0;
    info.splits    = 0;
    info.iffy      = 0;
    info.near_miss = 0;

    info.real_left  = 0;
    info.real_right = 0;
    info.mini_left  = 0;
    info.mini_right = 0;

    if (EvalPartitionWorker(tree, part, best_cost, &info))
        return -1.0;

    /* make sure there is at least one real seg on each side */
    if (info.real_left == 0 || info.real_right == 0)
    {
#if DEBUG_PICKNODE
        DebugPrintf("Eval : No real segs on %s%sside\n", info.real_left ? "" : "left ",
                    info.real_right ? "" : "right ");
#endif

        return -1;
    }

    /* increase cost by the difference between left & right */
    info.cost += 100.0 * abs(info.real_left - info.real_right);

    // -AJA- allow miniseg counts to affect the outcome, but to a
    //       lesser degree than real segs.

    info.cost += 50.0 * abs(info.mini_left - info.mini_right);

    // -AJA- Another little twist, here we show a slight preference for
    //       partition lines that lie either purely horizontally or
    //       purely vertically.

    if (!AlmostEquals(part->pdx_, 0.0) && !AlmostEquals(part->pdy_, 0.0))
        info.cost += 25.0;

    return info.cost;
}

void EvaluateFastWorker(QuadTree *tree, Seg **best_H, Seg **best_V, int mid_x, int mid_y)
{
    for (Seg *part = tree->list_; part; part = part->next_)
    {
        /* ignore minisegs as partition candidates */
        if (part->linedef_ == nullptr)
            continue;

        /* ignore self-ref and polyobj stuff as partition candidates */
        if (part->linedef_->is_precious)
            continue;

        if (AlmostEquals(part->pdy_, 0.0))
        {
            // horizontal seg
            if (!*best_H)
            {
                *best_H = part;
            }
            else
            {
                double old_dist = fabs((*best_H)->psy_ - mid_y);
                double new_dist = fabs((part)->psy_ - mid_y);

                if (new_dist < old_dist)
                    *best_H = part;
            }
        }
        else if (AlmostEquals(part->pdx_, 0.0))
        {
            // vertical seg
            if (!*best_V)
            {
                *best_V = part;
            }
            else
            {
                double old_dist = fabs((*best_V)->psx_ - mid_x);
                double new_dist = fabs((part)->psx_ - mid_x);

                if (new_dist < old_dist)
                    *best_V = part;
            }
        }
    }

    /* handle sub-blocks recursively */

    for (int c = 0; c < 2; c++)
    {
        if (tree->subs_[c] != nullptr && !tree->subs_[c]->Empty())
        {
            EvaluateFastWorker(tree->subs_[c], best_H, best_V, mid_x, mid_y);
        }
    }
}

Seg *FindFastSeg(QuadTree *tree)
{
    Seg *best_H = nullptr;
    Seg *best_V = nullptr;

    int mid_x = (tree->x1_ + tree->x2_) / 2;
    int mid_y = (tree->y1_ + tree->y2_) / 2;

    EvaluateFastWorker(tree, &best_H, &best_V, mid_x, mid_y);

    double H_cost = -1.0;
    double V_cost = -1.0;

    if (best_H)
        H_cost = EvalPartition(tree, best_H, 1.0e99);

    if (best_V)
        V_cost = EvalPartition(tree, best_V, 1.0e99);

    if (H_cost < 0 && V_cost < 0)
        return nullptr;

    if (H_cost < 0)
        return best_V;
    if (V_cost < 0)
        return best_H;

    return (V_cost < H_cost) ? best_V : best_H;
}

/* returns false if cancelled */
bool PickNodeWorker(QuadTree *part_list, QuadTree *tree, Seg **best, double *best_cost)
{
    /* try each Seg as partition */
    for (Seg *part = part_list->list_; part; part = part->next_)
    {
#if DEBUG_PICKNODE
        DebugPrintf("PickNode:   %sSEG %p  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", part->linedef ? "" : "MINI", part,
                    part->start->x, part->start->y, part->end->x, part->end->y);
#endif

        /* ignore minisegs as partition candidates */
        if (part->linedef_ == nullptr)
            continue;

        double cost = EvalPartition(tree, part, *best_cost);

        /* seg unsuitable or too costly ? */
        if (cost < 0 || cost >= *best_cost)
            continue;

        /* we have a new better choice */
        (*best_cost) = cost;

        /* remember which Seg */
        (*best) = part;
    }

    /* recursively handle sub-blocks */

    for (int c = 0; c < 2; c++)
    {
        if (part_list->subs_[c] != nullptr && !part_list->subs_[c]->Empty())
        {
            if (!PickNodeWorker(part_list->subs_[c], tree, best, best_cost))
                return false;
        }
    }

    return true;
}

//
// Find the best seg in the seg_list to use as a partition line.
//
static Seg *PickNode(QuadTree *tree)
{
    Seg *best = nullptr;

    double best_cost = 1.0e99;

#if DEBUG_PICKNODE
    DebugPrintf("PickNode: BEGUN (depth %d)\n", depth);
#endif

    /* -AJA- here is the logic for "fast mode".  We look for segs which
     *       are axis-aligned and roughly divide the current group into
     *       two halves.  This can save *heaps* of times on large levels.
     */
    if (tree->real_num_ >= kSegFastModeThreshold)
    {
#if DEBUG_PICKNODE
        DebugPrintf("PickNode: Looking for Fast node...\n");
#endif

        best = FindFastSeg(tree);

        if (best != nullptr)
        {
#if DEBUG_PICKNODE
            DebugPrintf("PickNode: Using Fast node (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", best->start->x, best->start->y,
                        best->end->x, best->end->y);
#endif
            return best;
        }
    }

    if (!PickNodeWorker(tree, tree, &best, &best_cost))
    {
        /* hack here : BuildNodes will detect the cancellation */
        return nullptr;
    }

    return best;
}

//
// Apply the partition line to the given seg, taking the necessary
// action (moving it into either the left list, right list, or
// splitting it).
//
// -AJA- I have rewritten this routine based on the EvalPartition
//       routine above (which I've also reworked, heavily).  I think
//       it is important that both these routines follow the exact
//       same logic when determining which segs should go left, right
//       or be split.
//
static void DivideOneSeg(Seg *seg, Seg *part, Seg **left_list, Seg **right_list, Intersection **cut_list)
{
    /* get state of lines' relation to each other */
    double a = part->PerpendicularDistance(seg->psx_, seg->psy_);
    double b = part->PerpendicularDistance(seg->pex_, seg->pey_);

    bool self_ref = seg->linedef_ ? seg->linedef_->self_referencing : false;

    if (seg->source_line_ == part->source_line_)
        a = b = 0;

    /* check for being on the same line */
    if (fabs(a) <= kEpsilon && fabs(b) <= kEpsilon)
    {
        AddIntersection(cut_list, seg->start_, part, self_ref);
        AddIntersection(cut_list, seg->end_, part, self_ref);

        // this seg runs along the same line as the partition.  check
        // whether it goes in the same direction or the opposite.

        if (seg->pdx_ * part->pdx_ + seg->pdy_ * part->pdy_ < 0)
            ListAddSeg(left_list, seg);
        else
            ListAddSeg(right_list, seg);

        return;
    }

    /* check for right side */
    if (a > -kEpsilon && b > -kEpsilon)
    {
        if (a < kEpsilon)
            AddIntersection(cut_list, seg->start_, part, self_ref);
        else if (b < kEpsilon)
            AddIntersection(cut_list, seg->end_, part, self_ref);

        ListAddSeg(right_list, seg);
        return;
    }

    /* check for left side */
    if (a < kEpsilon && b < kEpsilon)
    {
        if (a > -kEpsilon)
            AddIntersection(cut_list, seg->start_, part, self_ref);
        else if (b > -kEpsilon)
            AddIntersection(cut_list, seg->end_, part, self_ref);

        ListAddSeg(left_list, seg);
        return;
    }

    // when we reach here, we have a and b non-zero and opposite sign,
    // hence this seg will be split by the partition line.

    double x, y;
    ComputeIntersection(seg, part, a, b, &x, &y);

    Seg *new_seg = SplitSeg(seg, x, y);

    AddIntersection(cut_list, seg->end_, part, self_ref);

    if (a < 0)
    {
        ListAddSeg(left_list, seg);
        ListAddSeg(right_list, new_seg);
    }
    else
    {
        ListAddSeg(right_list, seg);
        ListAddSeg(left_list, new_seg);
    }
}

static void SeparateSegs(QuadTree *tree, Seg *part, Seg **left_list, Seg **right_list, Intersection **cut_list)
{
    while (tree->list_ != nullptr)
    {
        Seg *seg    = tree->list_;
        tree->list_ = seg->next_;

        seg->quad_ = nullptr;
        DivideOneSeg(seg, part, left_list, right_list, cut_list);
    }

    // recursively handle sub-blocks
    if (tree->subs_[0] != nullptr)
    {
        SeparateSegs(tree->subs_[0], part, left_list, right_list, cut_list);
        SeparateSegs(tree->subs_[1], part, left_list, right_list, cut_list);
    }

    // this QuadTree is empty now
}

static void FindLimits2(Seg *list, BoundingBox *bbox)
{
    // empty list?
    if (list == nullptr)
    {
        bbox->minx = 0;
        bbox->miny = 0;
        bbox->maxx = 4;
        bbox->maxy = 4;
        return;
    }

    bbox->minx = bbox->miny = SHRT_MAX;
    bbox->maxx = bbox->maxy = SHRT_MIN;

    for (; list != nullptr; list = list->next_)
    {
        double x1 = list->start_->x_;
        double y1 = list->start_->y_;
        double x2 = list->end_->x_;
        double y2 = list->end_->y_;

        int lx = (int)floor(OBSIDIAN_MIN(x1, x2) - 0.2);
        int ly = (int)floor(OBSIDIAN_MIN(y1, y2) - 0.2);
        int hx = (int)ceil(OBSIDIAN_MAX(x1, x2) + 0.2);
        int hy = (int)ceil(OBSIDIAN_MAX(y1, y2) + 0.2);

        if (lx < bbox->minx)
            bbox->minx = lx;
        if (ly < bbox->miny)
            bbox->miny = ly;
        if (hx > bbox->maxx)
            bbox->maxx = hx;
        if (hy > bbox->maxy)
            bbox->maxy = hy;
    }
}

static void AddMinisegs(Intersection *cut_list, Seg *part, Seg **left_list, Seg **right_list)
{
    Intersection *cut, *next;

#if DEBUG_CUTLIST
    DebugPrintf("CUT LIST:\n");
    DebugPrintf("PARTITION: (%1.1f,%1.1f) += (%1.1f,%1.1f)\n", part->psx_, part->psy_, part->pdx_, part->pdy_);

    for (cut = cut_list; cut; cut = cut->next)
    {
        DebugPrintf("  Vertex %8X (%1.1f,%1.1f)  Along %1.2f  [%d/%d]  %s\n", cut->vertex->index, cut->vertex->x,
                    cut->vertex->y, cut->along_dist, cut->open_before ? 1 : 0, cut->open_after ? 1 : 0,
                    cut->self_ref ? "SELFREF" : "");
    }
#endif

    // find open gaps in the intersection list, convert to minisegs

    for (cut = cut_list; cut && cut->next; cut = cut->next)
    {
        next = cut->next;

        // sanity check
        double len = next->along_dist - cut->along_dist;
        if (len < -0.001)
        {
            ErrorPrintf("AJBSP: Bad order in intersect list: %1.3f > %1.3f\n", cut->along_dist, next->along_dist);
        }

        bool A = cut->open_after;
        bool B = next->open_before;

        // nothing possible when both ends are CLOSED
        if (!(A || B))
            continue;

        if (A != B)
        {
            // a mismatch indicates something wrong with level geometry.
            // warning about it is probably not worth it, so ignore it.
            continue;
        }

        // righteo, here we have definite open space.
        // create a miniseg pair_....

        Seg *seg   = NewSeg();
        Seg *buddy = NewSeg();

        seg->partner_   = buddy;
        buddy->partner_ = seg;

        seg->start_ = cut->vertex;
        seg->end_   = next->vertex;

        buddy->start_ = next->vertex;
        buddy->end_   = cut->vertex;

        seg->index_ = buddy->index_ = -1;
        seg->linedef_ = buddy->linedef_ = nullptr;
        seg->side_ = buddy->side_ = 0;

        seg->source_line_ = buddy->source_line_ = part->linedef_;

        seg->Recompute();
        buddy->Recompute();

        // add the new segs to the appropriate lists
        ListAddSeg(right_list, seg);
        ListAddSeg(left_list, buddy);

#if DEBUG_CUTLIST
        DebugPrintf("AddMiniseg: %p RIGHT  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", seg->start_->x, seg->start_->y,
                    seg->end_->x, seg->end_->y);

        DebugPrintf("AddMiniseg: %p LEFT   (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", buddy->start->x, buddy->start->y,
                    buddy->end->x, buddy->end->y);
#endif
    }
}

//------------------------------------------------------------------------
// NODE : Recursively create nodes and return the pointers.
//------------------------------------------------------------------------

//
// Split a list of segs into two using the method described at bottom
// of the file, this was taken from OBJECTS.C in the DEU5beta source.
//
// This is done by scanning all of the segs and finding the one that
// does the least splitting and has the least difference in numbers of
// segs on either side.
//
// If the ones on the left side make a SSector, then create another SSector
// else put the segs into lefts list.
// If the ones on the right side make a SSector, then create another SSector
// else put the segs into rights list.
//
// Rewritten by Andrew Apted (-AJA-), 1999-2000.
//

void Node::SetPartition(const Seg *part)
{
    SYS_ASSERT(part->linedef_);

    if (part->side_ == 0)
    {
        x_  = part->linedef_->start->x_;
        y_  = part->linedef_->start->y_;
        dx_ = part->linedef_->end->x_ - x_;
        dy_ = part->linedef_->end->y_ - y_;
    }
    else /* left side */
    {
        x_  = part->linedef_->end->x_;
        y_  = part->linedef_->end->y_;
        dx_ = part->linedef_->start->x_ - x_;
        dy_ = part->linedef_->start->y_ - y_;
    }

    /* check for very long partition (overflow of dx,dy in NODES) */

    if (fabs(dx_) > 32766 || fabs(dy_) > 32766)
    {
        // XGL3 nodes are 16.16 fixed point, hence we still need
        // to reduce the delta.
        dx_ = dx_ / 2.0;
        dy_ = dy_ / 2.0;
    }
}

//
// Returns -1 for left, +1 for right, or 0 for intersect.
//
int Seg::PointOnLineSide(double x, double y) const
{
    double perp = PerpendicularDistance(x, y);

    if (fabs(perp) <= kEpsilon)
        return 0;

    return (perp < 0) ? -1 : +1;
}

/* ----- quad-tree routines ------------------------------------ */

QuadTree::QuadTree(int x1, int y1, int x2, int y2)
    : x1_(x1), y1_(y1), x2_(x2), y2_(y2), real_num_(0), mini_num_(0), list_(nullptr)
{
    int dx = x2 - x1;
    int dy = y2 - y1;

    if (dx <= 320 && dy <= 320)
    {
        // leaf node
        subs_[0] = nullptr;
        subs_[1] = nullptr;
    }
    else if (dx >= dy)
    {
        subs_[0] = new QuadTree(x1, y1, x1 + dx / 2, y2);
        subs_[1] = new QuadTree(x1 + dx / 2, y1, x2, y2);
    }
    else
    {
        subs_[0] = new QuadTree(x1, y1, x2, y1 + dy / 2);
        subs_[1] = new QuadTree(x1, y1 + dy / 2, x2, y2);
    }
}

QuadTree::~QuadTree()
{
    if (subs_[0] != nullptr)
        delete subs_[0];
    if (subs_[1] != nullptr)
        delete subs_[1];
}

void QuadTree::AddSeg(Seg *seg)
{
    // update seg counts
    if (seg->linedef_ != nullptr)
        real_num_++;
    else
        mini_num_++;

    if (subs_[0] != nullptr)
    {
        double x_min = OBSIDIAN_MIN(seg->start_->x_, seg->end_->x_);
        double y_min = OBSIDIAN_MIN(seg->start_->y_, seg->end_->y_);

        double x_max = OBSIDIAN_MAX(seg->start_->x_, seg->end_->x_);
        double y_max = OBSIDIAN_MAX(seg->start_->y_, seg->end_->y_);

        if ((x2_ - x1_) >= (y2_ - y1_))
        {
            if (x_min > subs_[1]->x1_)
            {
                subs_[1]->AddSeg(seg);
                return;
            }
            else if (x_max < subs_[0]->x2_)
            {
                subs_[0]->AddSeg(seg);
                return;
            }
        }
        else
        {
            if (y_min > subs_[1]->y1_)
            {
                subs_[1]->AddSeg(seg);
                return;
            }
            else if (y_max < subs_[0]->y2_)
            {
                subs_[0]->AddSeg(seg);
                return;
            }
        }
    }

    // link into this node

    ListAddSeg(&list_, seg);

    seg->quad_ = this;
}

void QuadTree::AddList(Seg *new_list)
{
    while (new_list != nullptr)
    {
        Seg *seg = new_list;
        new_list = seg->next_;

        AddSeg(seg);
    }
}

void QuadTree::ConvertToList(Seg **list)
{
    while (list_ != nullptr)
    {
        Seg *seg = list_;
        list_    = seg->next_;

        ListAddSeg(list, seg);
    }

    if (subs_[0] != nullptr)
    {
        subs_[0]->ConvertToList(list);
        subs_[1]->ConvertToList(list);
    }

    // this quadtree is empty now
}

int QuadTree::OnLineSide(const Seg *part) const
{
    // expand bounds a bit, adds some safety and loses nothing
    double tx1 = (double)x1_ - 0.4;
    double ty1 = (double)y1_ - 0.4;
    double tx2 = (double)x2_ + 0.4;
    double ty2 = (double)y2_ + 0.4;

    int p1, p2;

    // handle simple cases (vertical & horizontal lines)
    if (AlmostEquals(part->pdx_, 0.0))
    {
        p1 = (tx1 > part->psx_) ? +1 : -1;
        p2 = (tx2 > part->psx_) ? +1 : -1;

        if (part->pdy_ < 0)
        {
            p1 = -p1;
            p2 = -p2;
        }
    }
    else if (AlmostEquals(part->pdy_, 0.0))
    {
        p1 = (ty1 < part->psy_) ? +1 : -1;
        p2 = (ty2 < part->psy_) ? +1 : -1;

        if (part->pdx_ < 0)
        {
            p1 = -p1;
            p2 = -p2;
        }
    }
    // now handle the cases of positive and negative slope
    else if (part->pdx_ * part->pdy_ > 0)
    {
        p1 = part->PointOnLineSide(tx1, ty2);
        p2 = part->PointOnLineSide(tx2, ty1);
    }
    else // NEGATIVE
    {
        p1 = part->PointOnLineSide(tx1, ty1);
        p2 = part->PointOnLineSide(tx2, ty2);
    }

    // line goes through or touches the box?
    if (p1 != p2)
        return 0;

    return p1;
}

Seg *CreateOneSeg(Linedef *line, Vertex *start, Vertex *end, Sidedef *side, int what_side)
{
    Seg *seg = NewSeg();

    // check for bad sidedef
    if (side->sector == nullptr)
    {
        LogPrintf("Bad sidedef on linedef #%d (Z_CheckHeap error)\n", line->index);
        current_build_info.total_warnings++;
    }

    // handle overlapping vertices, pick a nominal one
    if (start->overlap_)
        start = start->overlap_;
    if (end->overlap_)
        end = end->overlap_;

    seg->start_   = start;
    seg->end_     = end;
    seg->linedef_ = line;
    seg->side_    = what_side;
    seg->partner_ = nullptr;

    seg->source_line_ = seg->linedef_;
    seg->index_       = -1;

    seg->Recompute();

    return seg;
}

//
// Initially create all segs, one for each linedef.
//
Seg *CreateSegs()
{
    Seg *list = nullptr;

    for (int i = 0; i < level_linedefs.size(); i++)
    {
        Linedef *line = level_linedefs[i];

        Seg *left  = nullptr;
        Seg *right = nullptr;

        // ignore zero-length lines
        if (line->zero_length)
            continue;

        // ignore overlapping lines
        if (line->overlap != nullptr)
            continue;

        // check for extremely long lines
        if (hypot(line->start->x_ - line->end->x_, line->start->y_ - line->end->y_) >= 32000)
        {
            LogPrintf("Linedef #%d is VERY long, it may cause problems\n", line->index);
            current_build_info.total_warnings++;
        }

        if (line->right != nullptr)
        {
            right = CreateOneSeg(line, line->start, line->end, line->right, 0);
            ListAddSeg(&list, right);
        }
        else
        {
            LogPrintf("Linedef #%d has no right sidedef!\n", line->index);
            current_build_info.total_warnings++;
        }

        if (line->left != nullptr)
        {
            left = CreateOneSeg(line, line->end, line->start, line->left, 1);
            ListAddSeg(&list, left);

            if (right != nullptr)
            {
                // -AJA- partner_ segs.  These always maintain a one-to-one
                //       correspondence, so if one of the gets split, the
                //       other one must be split too.

                left->partner_  = right;
                right->partner_ = left;
            }
        }
        else
        {
            if (line->two_sided)
            {
                LogPrintf("Linedef #%d is 2s but has no left sidedef\n", line->index);
                current_build_info.total_warnings++;
                line->two_sided = false;
            }
        }
    }

    return list;
}

static QuadTree *TreeFromSegList(Seg *list, const BoundingBox *bounds)
{
    QuadTree *tree = new QuadTree(bounds->minx, bounds->miny, bounds->maxx, bounds->maxy);

    tree->AddList(list);

    return tree;
}

void Subsector::DetermineMiddle()
{
    mid_x_ = 0.0;
    mid_y_ = 0.0;

    int total = 0;

    // compute middle coordinates
    for (Seg *seg = seg_list_; seg; seg = seg->next_)
    {
        mid_x_ += seg->start_->x_ + seg->end_->x_;
        mid_y_ += seg->start_->y_ + seg->end_->y_;

        total += 2;
    }

    if (total > 0)
    {
        mid_x_ /= total;
        mid_y_ /= total;
    }
}

void Subsector::AddToTail(Seg *seg)
{
    seg->next_ = nullptr;

    if (seg_list_ == nullptr)
    {
        seg_list_ = seg;
        return;
    }

    Seg *tail = seg_list_;
    while (tail->next_ != nullptr)
        tail = tail->next_;

    tail->next_ = seg;
}

void Subsector::ClockwiseOrder()
{
    Seg *seg;

#if DEBUG_SUBSEC
    DebugPrintf("Subsec: Clockwising %d\n", index);
#endif

    std::vector<Seg *> array;

    for (seg = seg_list_; seg; seg = seg->next_)
    {
        // compute angles now
        seg->cmp_angle_ = ComputeAngle(seg->start_->x_ - mid_x_, seg->start_->y_ - mid_y_);

        array.push_back(seg);
    }

    // sort segs by angle (from the middle point to the start vertex).
    // the desired order (clockwise) means descending angles.
    // since # of segs is usually small, a bubble sort is fast enough.

    size_t i = 0;

    while (i + 1 < array.size())
    {
        Seg *A = array[i];
        Seg *B = array[i + 1];

        if (A->cmp_angle_ < B->cmp_angle_)
        {
            // swap 'em
            array[i]     = B;
            array[i + 1] = A;

            // bubble down
            if (i > 0)
                i--;
        }
        else
        {
            // bubble up
            i++;
        }
    }

    // choose the seg that will be first (the game engine will typically use
    // that to determine the sector).  In particular, we don't like self
    // referencing linedefs (they are often used for deep-water effects).
    int first = 0;
    int score = -1;

    for (i = 0; i < array.size(); i++)
    {
        int cur_score = 3;

        if (!array[i]->linedef_)
            cur_score = 0;
        else if (array[i]->linedef_->self_referencing)
            cur_score = 2;

        if (cur_score > score)
        {
            first = i;
            score = cur_score;
        }
    }

    // transfer sorted array back into sub
    seg_list_ = nullptr;

    for (i = 0; i < array.size(); i++)
    {
        size_t k = (first + i) % array.size();
        AddToTail(array[k]);
    }

#if DEBUG_SORTER
    DebugPrintf("Sorted SEGS around (%1.1f,%1.1f)\n", mid_x, mid_y);

    for (seg = seg_list; seg; seg = seg->next)
    {
        DebugPrintf("  Seg %p: Angle %1.6f  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", seg, seg->cmp_angle, seg->start_->x,
                    seg->start_->y, seg->end_->x, seg->end_->y);
    }
#endif
}

void Subsector::SanityCheckClosed() const
{
    int gaps  = 0;
    int total = 0;

    Seg *seg, *next;

    for (seg = seg_list_; seg; seg = seg->next_)
    {
        next = seg->next_ ? seg->next_ : seg_list_;

        double dx = seg->end_->x_ - next->start_->x_;
        double dy = seg->end_->y_ - next->start_->y_;

        if (fabs(dx) > kEpsilon || fabs(dy) > kEpsilon)
            gaps++;

        total++;
    }

    if (gaps > 0)
    {
        LogPrintf("Subsector #%d near (%1.1f,%1.1f) is not closed "
                  "(%d gaps, %d segs)\n",
                  index_, mid_x_, mid_y_, gaps, total);
        current_build_info.total_minor_issues++;

#if DEBUG_SUBSEC
        for (seg = seg_list; seg; seg = seg->next)
        {
            DebugPrintf("  SEG %p  (%1.1f,%1.1f) --> (%1.1f,%1.1f)\n", seg, seg->start_->x, seg->start_->y,
                        seg->end_->x, seg->end_->y);
        }
#endif
    }
}

void Subsector::SanityCheckHasRealSeg() const
{
    for (Seg *seg = seg_list_; seg; seg = seg->next_)
        if (seg->linedef_ != nullptr)
            return;

    ErrorPrintf("AJBSP: Subsector #%d near (%1.1f,%1.1f) has no real seg!\n", index_, mid_x_, mid_y_);
}

void Subsector::RenumberSegs(int &cur_seg_index)
{
#if DEBUG_SUBSEC
    DebugPrintf("Subsec: Renumbering %d\n", index);
#endif

    seg_count_ = 0;

    for (Seg *seg = seg_list_; seg; seg = seg->next_)
    {
        seg->index_ = cur_seg_index;
        cur_seg_index += 1;

        seg_count_++;

#if DEBUG_SUBSEC
        DebugPrintf("Subsec:   %d: Seg %p  Index %d\n", seg_count, seg, seg->index);
#endif
    }
}

//
// Create a subsector from a list of segs.
//
Subsector *CreateSubsec(QuadTree *tree)
{
    Subsector *sub = NewSubsec();

    // compute subsector's index
    sub->index_ = level_subsecs.size() - 1;

    // copy segs into subsector
    sub->seg_list_ = nullptr;
    tree->ConvertToList(&sub->seg_list_);

    sub->DetermineMiddle();

#if DEBUG_SUBSEC
    DebugPrintf("Subsec: Creating %d\n", sub->index);
#endif

    return sub;
}

int ComputeBspHeight(const Node *node)
{
    if (node == nullptr)
        return 1;

    int right = ComputeBspHeight(node->r_.node);
    int left  = ComputeBspHeight(node->l_.node);

    return OBSIDIAN_MAX(left, right) + 1;
}

#if DEBUG_BUILDER
void DebugShowSegs(const Seg *list)
{
    for (const Seg *seg = list; seg; seg = seg->next)
    {
        DebugPrintf("Build:   %sSEG %p  (%1.1f,%1.1f) -> (%1.1f,%1.1f)\n", seg->linedef ? "" : "MINI", seg,
                    seg->start_->x, seg->start_->y, seg->end_->x, seg->end_->y);
    }
}
#endif

BuildResult BuildNodes(Seg *list, int depth, BoundingBox *bounds /* output */, Node **N, Subsector **S)
{
    *N = nullptr;
    *S = nullptr;

#if DEBUG_BUILDER
    DebugPrintf("Build: BEGUN @ %d\n", depth);
    DebugShowSegs(list);
#endif

    // determine bounds of segs
    FindLimits2(list, bounds);

    QuadTree *tree = TreeFromSegList(list, bounds);

    /* pick partition line, NONE indicates convexicity */
    Seg *part = PickNode(tree);

    if (part == nullptr)
    {
#if DEBUG_BUILDER
        DebugPrintf("Build: CONVEX\n");
#endif

        *S = CreateSubsec(tree);
        delete tree;

        return kBuildOK;
    }

#if DEBUG_BUILDER
    DebugPrintf("Build: PARTITION %p (%1.0f,%1.0f) -> (%1.0f,%1.0f)\n", part, part->start->x, part->start->y,
                part->end->x, part->end->y);
#endif

    Node *node = NewNode();
    *N         = node;

    /* divide the segs into two lists: left & right */
    Seg          *lefts    = nullptr;
    Seg          *rights   = nullptr;
    Intersection *cut_list = nullptr;

    SeparateSegs(tree, part, &lefts, &rights, &cut_list);

    delete tree;
    tree = nullptr;

    /* sanity checks... */
    if (rights == nullptr)
        ErrorPrintf("AJBSP: Separated seg-list has empty RIGHT side\n");

    if (lefts == nullptr)
        ErrorPrintf("AJBSP: Separated seg-list has empty LEFT side\n");

    if (cut_list != nullptr)
        AddMinisegs(cut_list, part, &lefts, &rights);

    node->SetPartition(part);

#if DEBUG_BUILDER
    DebugPrintf("Build: Going LEFT\n");
#endif

    BuildResult ret;

    // recursively build the left side
    ret = BuildNodes(lefts, depth + 1, &node->l_.bounds, &node->l_.node, &node->l_.subsec);
    if (ret != kBuildOK)
        return ret;

#if DEBUG_BUILDER
    DebugPrintf("Build: Going RIGHT\n");
#endif

    // recursively build the right side
    ret = BuildNodes(rights, depth + 1, &node->r_.bounds, &node->r_.node, &node->r_.subsec);
    if (ret != kBuildOK)
        return ret;

#if DEBUG_BUILDER
    DebugPrintf("Build: DONE\n");
#endif

    return kBuildOK;
}

void ClockwiseBspTree()
{
    int cur_seg_index = 0;

    for (int i = 0; i < level_subsecs.size(); i++)
    {
        Subsector *sub = level_subsecs[i];

        sub->ClockwiseOrder();
        sub->RenumberSegs(cur_seg_index);

        // do some sanity checks
        sub->SanityCheckClosed();
        sub->SanityCheckHasRealSeg();
    }
}

void Subsector::Normalise()
{
    // use head + tail to maintain same order of segs
    Seg *new_head = NULL;
    Seg *new_tail = NULL;

#if DEBUG_SUBSEC
    DebugPrintf("Subsec: Normalising %d\n", index);
#endif

    while (seg_list_)
    {
        // remove head
        Seg *seg  = seg_list_;
        seg_list_ = seg->next_;

        // filter out minisegs
        if (seg->linedef_ == NULL)
        {
#if DEBUG_SUBSEC
            DebugPrintf("Subsec: Removing miniseg %p\n", seg);
#endif
            // this causes SortSegs() to remove the seg
            seg->index_ = kSegIsGarbage;
            continue;
        }

        // add it to the new list
        seg->next_ = NULL;

        if (new_tail)
            new_tail->next_ = seg;
        else
            new_head = seg;

        new_tail = seg;

        // this updated later
        seg->index_ = -1;
    }

    if (new_head == NULL)
        ErrorPrintf("AJBSP: Subsector %d normalised to being EMPTY\n", index_);

    seg_list_ = new_head;
}

void NormaliseBspTree()
{
    // unlinks all minisegs from each subsector

    int cur_seg_index = 0;

    for (int i = 0; i < level_subsecs.size(); i++)
    {
        Subsector *sub = level_subsecs[i];

        sub->Normalise();
        sub->RenumberSegs(cur_seg_index);
    }
}

void RoundOffVertices()
{
    for (int i = 0; i < level_vertices.size(); i++)
    {
        Vertex *vert = level_vertices[i];

        if (vert->is_new_)
        {
            vert->is_new_ = false;

            vert->index_ = num_old_vert;
            num_old_vert++;
        }
    }
}

void Subsector::RoundOff()
{
    // use head + tail to maintain same order of segs
    Seg *new_head = NULL;
    Seg *new_tail = NULL;

    Seg *seg;
    Seg *last_real_degen = NULL;

    int real_total  = 0;
    int degen_total = 0;

#if DEBUG_SUBSEC
    DebugPrintf("Subsec: Rounding off %d\n", index);
#endif

    // do an initial pass, just counting the degenerates
    for (seg = seg_list_; seg; seg = seg->next_)
    {
        // is the seg degenerate ?
        if (RoundToInteger(seg->start_->x_) == RoundToInteger(seg->end_->x_) &&
            RoundToInteger(seg->start_->y_) == RoundToInteger(seg->end_->y_))
        {
            seg->is_degenerate_ = true;

            if (seg->linedef_ != NULL)
                last_real_degen = seg;

            degen_total++;
            continue;
        }

        if (seg->linedef_ != NULL)
            real_total++;
    }

#if DEBUG_SUBSEC
    DebugPrintf("Subsec: degen=%d real=%d\n", degen_total, real_total);
#endif

    // handle the (hopefully rare) case where all of the real segs
    // became degenerate.
    if (real_total == 0)
    {
        if (last_real_degen == NULL)
            ErrorPrintf("AJBSP: Subsector %d rounded off with NO real segs\n", index_);

#if DEBUG_SUBSEC
        DebugPrintf("Degenerate before: (%1.2f,%1.2f) -> (%1.2f,%1.2f)\n", last_real_degen->start->x,
                    last_real_degen->start->y, last_real_degen->end->x, last_real_degen->end->y);
#endif

        // create a new vertex for this baby
        last_real_degen->end_ = NewVertexDegenerate(last_real_degen->start_, last_real_degen->end_);

#if DEBUG_SUBSEC
        DebugPrintf("Degenerate after:  (%d,%d) -> (%d,%d)\n", RoundToInteger(last_real_degen->start->x),
                    RoundToInteger(last_real_degen->start->y), RoundToInteger(last_real_degen->end->x),
                    RoundToInteger(last_real_degen->end->y));
#endif

        last_real_degen->is_degenerate_ = false;
    }

    // second pass, remove the blighters...
    while (seg_list_ != NULL)
    {
        // remove head
        seg       = seg_list_;
        seg_list_ = seg->next_;

        if (seg->is_degenerate_)
        {
#if DEBUG_SUBSEC
            cur_info->Debug("Subsec: Removing degenerate %p\n", seg);
#endif
            // this causes SortSegs() to remove the seg
            seg->index_ = kSegIsGarbage;
            continue;
        }

        // add it to new list
        seg->next_ = NULL;

        if (new_tail)
            new_tail->next_ = seg;
        else
            new_head = seg;

        new_tail = seg;

        // this updated later
        seg->index_ = -1;
    }

    if (new_head == NULL)
        ErrorPrintf("AJBSP: Subsector %d rounded off to being EMPTY\n", index_);

    seg_list_ = new_head;
}

void RoundOffBspTree()
{
    int cur_seg_index = 0;

    RoundOffVertices();

    for (int i = 0; i < level_subsecs.size(); i++)
    {
        Subsector *sub = level_subsecs[i];

        sub->RoundOff();
        sub->RenumberSegs(cur_seg_index);
    }
}

} // namespace ajbsp

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
