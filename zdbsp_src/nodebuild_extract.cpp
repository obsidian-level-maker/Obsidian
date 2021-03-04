/*
    Routines for extracting usable data from the new BSP tree.
    Copyright (C) 2002-2006 Randy Heit

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

*/
#include <string.h>
#include <stdio.h>
#include <float.h>

#include "zdbsp.h"
#include "nodebuild.h"
#include "templates.h"

#if 0
#define D(x) x
#define DD 1
#else
#define D(x) do{}while(0)
#undef DD
#endif

void FNodeBuilder::GetGLNodes (MapNodeEx *&outNodes, int &nodeCount,
	MapSegGLEx *&outSegs, int &segCount,
	MapSubsectorEx *&outSubs, int &subCount)
{
	TArray<MapSegGLEx> segs (Segs.Size()*5/4);
	int i, j, k;

	nodeCount = Nodes.Size ();
	outNodes = new MapNodeEx[nodeCount];
	for (i = 0; i < nodeCount; ++i)
	{
		const node_t *orgnode = &Nodes[i];
		MapNodeEx *newnode = &outNodes[i];

		newnode->x = orgnode->x;
		newnode->y = orgnode->y;
		newnode->dx = orgnode->dx;
		newnode->dy = orgnode->dy;

		for (j = 0; j < 2; ++j)
		{
			for (k = 0; k < 4; ++k)
			{
				newnode->bbox[j][k] = orgnode->bbox[j][k] >> FRACBITS;
			}
			newnode->children[j] = orgnode->intchildren[j];
		}
	}

	subCount = Subsectors.Size();
	outSubs = new MapSubsectorEx[subCount];
	for (i = 0; i < subCount; ++i)
	{
		int numsegs = CloseSubsector (segs, i);
		outSubs[i].numlines = numsegs;
		outSubs[i].firstline = segs.Size() - numsegs;
	}

	segCount = segs.Size ();
	outSegs = new MapSegGLEx[segCount];
	memcpy (outSegs, &segs[0], segCount*sizeof(MapSegGLEx));

	for (i = 0; i < segCount; ++i)
	{
		if (outSegs[i].partner != DWORD_MAX)
		{
			outSegs[i].partner = Segs[outSegs[i].partner].storedseg;
		}
	}

	D(DumpNodes(outNodes, nodeCount));
}

int FNodeBuilder::CloseSubsector (TArray<MapSegGLEx> &segs, int subsector)
{
	FPrivSeg *seg, *prev;
	angle_t prevAngle;
	double accumx, accumy;
	fixed_t midx, midy;
	int i, j, first, max, count, firstVert;
	bool diffplanes;
	int firstplane;

	first = Subsectors[subsector].firstline;
	max = first + Subsectors[subsector].numlines;
	count = 0;

	accumx = accumy = 0.0;
	diffplanes = false;
	firstplane = Segs[SegList[first].SegNum].planenum;

	// Calculate the midpoint of the subsector and also check for degenerate subsectors.
	// A subsector is degenerate if it exists in only one dimension, which can be
	// detected when all the segs lie in the same plane. This can happen if you have
	// outward-facing lines in the void that don't point toward any sector. (Some of the
	// polyobjects in Hexen are constructed like this.)
	for (i = first; i < max; ++i)
	{
		seg = &Segs[SegList[i].SegNum];
		accumx += double(Vertices[seg->v1].x) + double(Vertices[seg->v2].x);
		accumy += double(Vertices[seg->v1].y) + double(Vertices[seg->v2].y);
		if (firstplane != seg->planenum)
		{
			diffplanes = true;
		}
	}

	midx = fixed_t(accumx / (max - first) / 2);
	midy = fixed_t(accumy / (max - first) / 2);

	seg = &Segs[SegList[first].SegNum];
	prevAngle = PointToAngle (Vertices[seg->v1].x - midx, Vertices[seg->v1].y - midy);
	seg->storedseg = PushGLSeg (segs, seg);
	count = 1;
	prev = seg;
	firstVert = seg->v1;

#ifdef DD
	printf("--%d--\n", subsector);
	for (j = first; j < max; ++j)
	{
		seg = &Segs[SegList[j].SegNum];
		angle_t ang = PointToAngle (Vertices[seg->v1].x - midx, Vertices[seg->v1].y - midy);
		printf ("%d%c %5d(%5d,%5d)->%5d(%5d,%5d) - %3.5f  %d,%d  [%08x,%08x]-[%08x,%08x]\n", j,
			seg->linedef == -1 ? '+' : ':',
			seg->v1, Vertices[seg->v1].x>>16, Vertices[seg->v1].y>>16,
			seg->v2, Vertices[seg->v2].x>>16, Vertices[seg->v2].y>>16,
			double(ang/2)*180/(1<<30),
			seg->planenum, seg->planefront,
			Vertices[seg->v1].x, Vertices[seg->v1].y,
			Vertices[seg->v2].x, Vertices[seg->v2].y);
	}
#endif

	if (diffplanes)
	{ // A well-behaved subsector. Output the segs sorted by the angle formed by connecting
	  // the subsector's center to their first vertex.

		D(printf("Well behaved subsector\n"));
		for (i = first + 1; i < max; ++i)
		{
			angle_t bestdiff = ANGLE_MAX;
			FPrivSeg *bestseg = NULL;
			int bestj = -1;
			for (j = first; j < max; ++j)
			{
				seg = &Segs[SegList[j].SegNum];
				angle_t ang = PointToAngle (Vertices[seg->v1].x - midx, Vertices[seg->v1].y - midy);
				angle_t diff = prevAngle - ang;
				if (seg->v1 == prev->v2)
				{
					bestdiff = diff;
					bestseg = seg;
					bestj = j;
					break;
				}
				if (diff < bestdiff && diff > 0)
				{
					bestdiff = diff;
					bestseg = seg;
					bestj = j;
				}
			}
			if (bestseg != NULL)
			{
				seg = bestseg;
			}
			if (prev->v2 != seg->v1)
			{
				// Add a new miniseg to connect the two segs
				PushConnectingGLSeg (subsector, segs, prev->v2, seg->v1);
				count++;
			}
#ifdef DD
			printf ("+%d\n", bestj);
#endif
			prevAngle -= bestdiff;
			seg->storedseg = PushGLSeg (segs, seg);
			count++;
			prev = seg;
			if (seg->v2 == firstVert)
			{
				prev = seg;
				break;
			}
		}
#ifdef DD
		printf ("\n");
#endif
	}
	else
	{ // A degenerate subsector. These are handled in three stages:
	  // Stage 1. Proceed in the same direction as the start seg until we
	  //          hit the seg furthest from it.
	  // Stage 2. Reverse direction and proceed until we hit the seg
	  //          furthest from the start seg.
	  // Stage 3. Reverse direction again and insert segs until we get
	  //          to the start seg.
	  // A dot product serves to determine distance from the start seg.

		D(printf("degenerate subsector\n"));

		// Stage 1. Go forward.
		count += OutputDegenerateSubsector (segs, subsector, true, 0, prev);

		// Stage 2. Go backward.
		count += OutputDegenerateSubsector (segs, subsector, false, DBL_MAX, prev);

		// Stage 3. Go forward again.
		count += OutputDegenerateSubsector (segs, subsector, true, -DBL_MAX, prev);
	}

	if (prev->v2 != firstVert)
	{
		PushConnectingGLSeg (subsector, segs, prev->v2, firstVert);
		count++;
	}
#ifdef DD
	printf ("Output GL subsector %d:\n", subsector);
	for (i = segs.Size() - count; i < (int)segs.Size(); ++i)
	{
		printf ("  Seg %5d%c(%5d,%5d)-(%5d,%5d)  [%08x,%08x]-[%08x,%08x]\n", i,
			segs[i].linedef == NO_INDEX ? '+' : ' ',
			Vertices[segs[i].v1].x>>16,
			Vertices[segs[i].v1].y>>16,
			Vertices[segs[i].v2].x>>16,
			Vertices[segs[i].v2].y>>16,
			Vertices[segs[i].v1].x,
			Vertices[segs[i].v1].y,
			Vertices[segs[i].v2].x,
			Vertices[segs[i].v2].y);
	}
#endif

	return count;
}

int FNodeBuilder::OutputDegenerateSubsector (TArray<MapSegGLEx> &segs, int subsector, bool bForward, double lastdot, FPrivSeg *&prev)
{
	static const double bestinit[2] = { -DBL_MAX, DBL_MAX };
	FPrivSeg *seg;
	int i, j, first, max, count;
	double dot, x1, y1, dx, dy, dx2, dy2;
	bool wantside;

	first = Subsectors[subsector].firstline;
	max = first + Subsectors[subsector].numlines;
	count = 0;

	seg = &Segs[SegList[first].SegNum];
	x1 = Vertices[seg->v1].x;
	y1 = Vertices[seg->v1].y;
	dx = Vertices[seg->v2].x - x1;
	dy = Vertices[seg->v2].y - y1;
	wantside = seg->planefront ^ !bForward;

	for (i = first + 1; i < max; ++i)
	{
		double bestdot = bestinit[bForward];
		FPrivSeg *bestseg = NULL;
		for (j = first + 1; j < max; ++j)
		{
			seg = &Segs[SegList[j].SegNum];
			if (seg->planefront != wantside)
			{
				continue;
			}
			dx2 = Vertices[seg->v1].x - x1;
			dy2 = Vertices[seg->v1].y - y1;
			dot = dx*dx2 + dy*dy2;

			if (bForward)
			{
				if (dot < bestdot && dot > lastdot)
				{
					bestdot = dot;
					bestseg = seg;
				}
			}
			else
			{
				if (dot > bestdot && dot < lastdot)
				{
					bestdot = dot;
					bestseg = seg;
				}
			}
		}
		if (bestseg != NULL)
		{
			if (prev->v2 != bestseg->v1)
			{
				PushConnectingGLSeg (subsector, segs, prev->v2, bestseg->v1);
				count++;
			}
			seg->storedseg = PushGLSeg (segs, bestseg);
			count++;
			prev = bestseg;
			lastdot = bestdot;
		}
	}
	return count;
}

DWORD FNodeBuilder::PushGLSeg (TArray<MapSegGLEx> &segs, const FPrivSeg *seg)
{
	MapSegGLEx newseg;

	newseg.v1 = seg->v1;
	newseg.v2 = seg->v2;
	newseg.linedef = seg->linedef;

	// Just checking the sidedef to determine the side is insufficient.
	// When a level is sidedef compressed both sides may well have the same sidedef.

	if (newseg.linedef != NO_INDEX)
	{
		IntLineDef *ld = &Level.Lines[newseg.linedef];

		if (ld->sidenum[0] == ld->sidenum[1])
		{
			// When both sidedefs are the same a quick check doesn't work so this
			// has to be done by comparing the distances of the seg's end point to
			// the line's start.
			WideVertex *lv1 = &Level.Vertices[ld->v1];
			WideVertex *sv1 = &Level.Vertices[seg->v1];
			WideVertex *sv2 = &Level.Vertices[seg->v2];

			double dist1sq = double(sv1->x-lv1->x)*(sv1->x-lv1->x) + double(sv1->y-lv1->y)*(sv1->y-lv1->y);
			double dist2sq = double(sv2->x-lv1->x)*(sv2->x-lv1->x) + double(sv2->y-lv1->y)*(sv2->y-lv1->y);

			newseg.side = dist1sq < dist2sq ? 0 : 1;
		}
		else
		{
			newseg.side = ld->sidenum[1] == seg->sidedef ? 1 : 0;
		}
	}
	else
	{
		newseg.side = 0;
	}

	newseg.partner = seg->partner;
	return segs.Push (newseg);
}

void FNodeBuilder::PushConnectingGLSeg (int subsector, TArray<MapSegGLEx> &segs, int v1, int v2)
{
	MapSegGLEx newseg;

	Warn ("Unclosed subsector %d, from (%d,%d) to (%d,%d)\n", subsector,
		Vertices[v1].x >> FRACBITS, Vertices[v1].y >> FRACBITS,
		Vertices[v2].x >> FRACBITS, Vertices[v2].y >> FRACBITS);

	newseg.v1 = v1;
	newseg.v2 = v2;
	newseg.linedef = NO_INDEX;
	newseg.side = 0;
	newseg.partner = DWORD_MAX;
	segs.Push (newseg);
}

void FNodeBuilder::GetVertices (WideVertex *&verts, int &count)
{
	count = Vertices.Size ();
	verts = new WideVertex[count];

	for (int i = 0; i < count; ++i)
	{
		verts[i].x = Vertices[i].x;
		verts[i].y = Vertices[i].y;
		verts[i].index = Vertices[i].index;
	}
}

void FNodeBuilder::GetNodes (MapNodeEx *&outNodes, int &nodeCount,
	MapSegEx *&outSegs, int &segCount,
	MapSubsectorEx *&outSubs, int &subCount)
{
	short bbox[4];
	TArray<MapSegEx> segs (Segs.Size());

	// Walk the BSP and create a new BSP with only the information
	// suitable for a standard tree. At a minimum, this means removing
	// all minisegs. As an optional step, I also recompute all the
	// nodes' bounding boxes so that they only bound the real segs and
	// not the minisegs.

	nodeCount = Nodes.Size ();
	outNodes = new MapNodeEx[nodeCount];

	subCount = Subsectors.Size ();
	outSubs = new MapSubsectorEx[subCount];

	RemoveMinisegs (outNodes, segs, outSubs, Nodes.Size() - 1, bbox);

	segCount = segs.Size ();
	outSegs = new MapSegEx[segCount];
	memcpy (outSegs, &segs[0], segCount*sizeof(MapSegEx));

	D(DumpNodes(outNodes, nodeCount));
#ifdef DD
	for (int i = 0; i < segCount; ++i)
	{
		printf("Seg %d: v1(%d) -> v2(%d)\n", i, outSegs[i].v1, outSegs[i].v2);
	}
#endif
}

int FNodeBuilder::RemoveMinisegs (MapNodeEx *nodes,
	TArray<MapSegEx> &segs, MapSubsectorEx *subs, int node, short bbox[4])
{
	if (node & NFX_SUBSECTOR)
	{
		int subnum = node == -1 ? 0 : node & ~NFX_SUBSECTOR;
		int numsegs = StripMinisegs (segs, subnum, bbox);
		subs[subnum].numlines = numsegs;
		subs[subnum].firstline = segs.Size() - numsegs;
		return NFX_SUBSECTOR | subnum;
	}
	else
	{
		const node_t *orgnode = &Nodes[node];
		MapNodeEx *newnode = &nodes[node];

		int child0 = RemoveMinisegs (nodes, segs, subs, orgnode->intchildren[0], newnode->bbox[0]);
		int child1 = RemoveMinisegs (nodes, segs, subs, orgnode->intchildren[1], newnode->bbox[1]);


		newnode->x = orgnode->x;
		newnode->y = orgnode->y;
		newnode->dx = orgnode->dx;
		newnode->dy = orgnode->dy;
		newnode->children[0] = child0;
		newnode->children[1] = child1;

		bbox[BOXTOP] = MAX(newnode->bbox[0][BOXTOP], newnode->bbox[1][BOXTOP]);
		bbox[BOXBOTTOM] = MIN(newnode->bbox[0][BOXBOTTOM], newnode->bbox[1][BOXBOTTOM]);
		bbox[BOXLEFT] = MIN(newnode->bbox[0][BOXLEFT], newnode->bbox[1][BOXLEFT]);
		bbox[BOXRIGHT] = MAX(newnode->bbox[0][BOXRIGHT], newnode->bbox[1][BOXRIGHT]);

		return node;
	}
}

int FNodeBuilder::StripMinisegs (TArray<MapSegEx> &segs, int subsector, short bbox[4])
{
	int count, i, max;

	// The bounding box is recomputed to only cover the real segs and not the
	// minisegs in the subsector.
	bbox[BOXTOP] = -32768;
	bbox[BOXBOTTOM] = 32767;
	bbox[BOXLEFT] = 32767;
	bbox[BOXRIGHT] = -32768;

	i = Subsectors[subsector].firstline;
	max = Subsectors[subsector].numlines + i;

	for (count = 0; i < max; ++i)
	{
		const FPrivSeg *org = &Segs[SegList[i].SegNum];

		// Because of the ordering guaranteed by SortSegs(), all mini segs will
		// be at the end of the subsector, so once one is encountered, we can
		// stop right away.
		if (org->linedef == -1)
		{
			break;
		}
		else
		{
			MapSegEx newseg;

			AddSegToShortBBox (bbox, org);

			newseg.v1 = org->v1;
			newseg.v2 = org->v2;
			newseg.angle = org->angle >> 16;
			newseg.offset = org->offset >> FRACBITS;
			newseg.linedef = org->linedef;

			// Just checking the sidedef to determine the side is insufficient.
			// When a level is sidedef compressed both sides may well have the same sidedef.

			IntLineDef * ld = &Level.Lines[newseg.linedef];

			if (ld->sidenum[0]==ld->sidenum[1])
			{
				// When both sidedefs are the same a quick check doesn't work so this
				// has to be done by comparing the distances of the seg's end point to
				// the line's start.
				WideVertex * lv1 = &Level.Vertices[ld->v1];
				WideVertex * sv1 = &Level.Vertices[org->v1];
				WideVertex * sv2 = &Level.Vertices[org->v2];

				double dist1sq = double(sv1->x-lv1->x)*(sv1->x-lv1->x) + double(sv1->y-lv1->y)*(sv1->y-lv1->y);
				double dist2sq = double(sv2->x-lv1->x)*(sv2->x-lv1->x) + double(sv2->y-lv1->y)*(sv2->y-lv1->y);

				newseg.side = dist1sq<dist2sq? 0:1;

			}
			else
			{
				newseg.side = ld->sidenum[1] == org->sidedef ? 1 : 0;
			}

			segs.Push (newseg);
			++count;
		}
	}
	return count;
}

void FNodeBuilder::AddSegToShortBBox (short bbox[4], const FPrivSeg *seg)
{
	const FPrivVert *v1 = &Vertices[seg->v1];
	const FPrivVert *v2 = &Vertices[seg->v2];

	short v1x = v1->x >> FRACBITS;
	short v1y = v1->y >> FRACBITS;
	short v2x = v2->x >> FRACBITS;
	short v2y = v2->y >> FRACBITS;

	if (v1x < bbox[BOXLEFT])	bbox[BOXLEFT] = v1x;
	if (v1x > bbox[BOXRIGHT])	bbox[BOXRIGHT] = v1x;
	if (v1y < bbox[BOXBOTTOM])	bbox[BOXBOTTOM] = v1y;
	if (v1y > bbox[BOXTOP])		bbox[BOXTOP] = v1y;

	if (v2x < bbox[BOXLEFT])	bbox[BOXLEFT] = v2x;
	if (v2x > bbox[BOXRIGHT])	bbox[BOXRIGHT] = v2x;
	if (v2y < bbox[BOXBOTTOM])	bbox[BOXBOTTOM] = v2y;
	if (v2y > bbox[BOXTOP])		bbox[BOXTOP] = v2y;
}

void FNodeBuilder::DumpNodes(MapNodeEx *outNodes, int nodeCount)
{
	for (unsigned int i = 0; i < Nodes.Size(); ++i)
	{
		printf("Node %d:  Splitter[%08x,%08x] [%08x,%08x]\n", i,
			outNodes[i].x, outNodes[i].y, outNodes[i].dx, outNodes[i].dy);
		for (int j = 1; j >= 0; --j)
		{
			if (outNodes[i].children[j] & NFX_SUBSECTOR)
			{
				printf("  subsector %d\n", outNodes[i].children[j] & ~NFX_SUBSECTOR);
			}
			else
			{
				printf("  node %d\n", outNodes[i].children[j]);
			}
		}
	}
}
