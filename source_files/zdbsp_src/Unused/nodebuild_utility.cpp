/*
    Various utility functions.
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

#include "zdbsp.h"
#include "nodebuild.h"
#include "templates.h"

static const int PO_LINE_START = 1;
static const int PO_LINE_EXPLICIT = 5;

#if 0
#define D(x) x
#else
#define D(x) do{}while(0)
#endif

#if 0
#define P(x) x
#define Printf printf
#else
#define P(x) do{}while(0)
#endif

void FNodeBuilder::FindUsedVertices (WideVertex *oldverts, int max)
{
	int *map = new int[max];
	int i;
	FPrivVert newvert;

	memset (&map[0], -1, sizeof(int)*max);

	for (i = 0; i < Level.NumLines(); ++i)
	{
		int v1 = Level.Lines[i].v1;
		int v2 = Level.Lines[i].v2;

		if (map[v1] == -1)
		{
			newvert.x = oldverts[v1].x;
			newvert.y = oldverts[v1].y;
			newvert.index = oldverts[v1].index;
			map[v1] = VertexMap->SelectVertexExact (newvert);
		}
		if (map[v2] == -1)
		{
			newvert.x = oldverts[v2].x;
			newvert.y = oldverts[v2].y;
			newvert.index = oldverts[v2].index;
			map[v2] = VertexMap->SelectVertexExact (newvert);
		}

		Level.Lines[i].v1 = map[v1];
		Level.Lines[i].v2 = map[v2];
	}
	InitialVertices = Vertices.Size ();
	Level.NumOrgVerts = (int)InitialVertices;
	delete[] map;
}

// For every sidedef in the map, create a corresponding seg.

void FNodeBuilder::MakeSegsFromSides ()
{
	int i, j;

	for (i = 0; i < Level.NumLines(); ++i)
	{
		if (Level.Lines[i].sidenum[0] != NO_INDEX)
		{
			CreateSeg (i, 0);
		}
		else
		{
			printf ("Linedef %d does not have a front side.\n", i);
		}

		if (Level.Lines[i].sidenum[1] != NO_INDEX)
		{
			j = CreateSeg (i, 1);
			if (Level.Lines[i].sidenum[0] != NO_INDEX)
			{
				Segs[j-1].partner = j;
				Segs[j].partner = j-1;
			}
		}
	}
}

int FNodeBuilder::CreateSeg (int linenum, int sidenum)
{
	FPrivSeg seg;
	DWORD backside;
	int segnum;

	seg.next = DWORD_MAX;
	seg.loopnum = 0;
	seg.offset = 0;
	seg.partner = DWORD_MAX;
	seg.hashnext = NULL;
	seg.planefront = false;
	seg.planenum = DWORD_MAX;
	seg.storedseg = DWORD_MAX;

	if (sidenum == 0)
	{ // front
		seg.v1 = Level.Lines[linenum].v1;
		seg.v2 = Level.Lines[linenum].v2;
	}
	else
	{ // back
		seg.v2 = Level.Lines[linenum].v1;
		seg.v1 = Level.Lines[linenum].v2;
	}
	seg.linedef = linenum;
	seg.sidedef = Level.Lines[linenum].sidenum[sidenum];
	backside = Level.Lines[linenum].sidenum[!sidenum];
	seg.frontsector = Level.Sides[seg.sidedef].sector;
	seg.backsector = backside != NO_INDEX ? Level.Sides[backside].sector : -1;
	seg.nextforvert = Vertices[seg.v1].segs;
	seg.nextforvert2 = Vertices[seg.v2].segs2;
	seg.angle = PointToAngle (Vertices[seg.v2].x-Vertices[seg.v1].x,
		Vertices[seg.v2].y-Vertices[seg.v1].y);

	segnum = (int)Segs.Push (seg);
	Vertices[seg.v1].segs = segnum;
	Vertices[seg.v2].segs2 = segnum;
	D(printf("Seg %4d: From line %d, side %s (%5d,%5d)-(%5d,%5d)  [%08x,%08x]-[%08x,%08x]\n", segnum, linenum, sidenum ? "back " : "front",
		Vertices[seg.v1].x>>16, Vertices[seg.v1].y>>16, Vertices[seg.v2].x>>16, Vertices[seg.v2].y>>16,
		Vertices[seg.v1].x, Vertices[seg.v1].y, Vertices[seg.v2].x, Vertices[seg.v2].y));

	return segnum;
}

// Group colinear segs together so that only one seg per line needs to be checked
// by SelectSplitter().

void FNodeBuilder::GroupSegPlanes ()
{
	const int bucketbits = 12;
	FPrivSeg *buckets[1<<bucketbits] = { 0 };
	int i, planenum;

	for (i = 0; i < (int)Segs.Size(); ++i)
	{
		FPrivSeg *seg = &Segs[i];
		seg->next = i+1;
		seg->hashnext = NULL;
	}

	Segs[Segs.Size()-1].next = DWORD_MAX;

	for (i = planenum = 0; i < (int)Segs.Size(); ++i)
	{
		FPrivSeg *seg = &Segs[i];
		fixed_t x1 = Vertices[seg->v1].x;
		fixed_t y1 = Vertices[seg->v1].y;
		fixed_t x2 = Vertices[seg->v2].x;
		fixed_t y2 = Vertices[seg->v2].y;
		angle_t ang = PointToAngle (x2 - x1, y2 - y1);

		if (ang >= 1u<<31)
			ang += 1u<<31;

		FPrivSeg *check = buckets[ang >>= 31-bucketbits];

		while (check != NULL)
		{
			fixed_t cx1 = Vertices[check->v1].x;
			fixed_t cy1 = Vertices[check->v1].y;
			fixed_t cdx = Vertices[check->v2].x - cx1;
			fixed_t cdy = Vertices[check->v2].y - cy1;
			if (PointOnSide (x1, y1, cx1, cy1, cdx, cdy) == 0 &&
				PointOnSide (x2, y2, cx1, cy1, cdx, cdy) == 0)
			{
				break;
			}
			check = check->hashnext;
		}
		if (check != NULL)
		{
			seg->planenum = check->planenum;
			const FSimpleLine *line = &Planes[seg->planenum];
			if (line->dx != 0)
			{
				if ((line->dx > 0 && x2 > x1) || (line->dx < 0 && x2 < x1))
				{
					seg->planefront = true;
				}
				else
				{
					seg->planefront = false;
				}
			}
			else
			{
				if ((line->dy > 0 && y2 > y1) || (line->dy < 0 && y2 < y1))
				{
					seg->planefront = true;
				}
				else
				{
					seg->planefront = false;
				}
			}
		}
		else
		{
			seg->hashnext = buckets[ang];
			buckets[ang] = seg;
			seg->planenum = planenum++;
			seg->planefront = true;

			FSimpleLine pline = { Vertices[seg->v1].x,
								  Vertices[seg->v1].y,
								  Vertices[seg->v2].x - Vertices[seg->v1].x,
								  Vertices[seg->v2].y - Vertices[seg->v1].y };
			Planes.Push (pline);
		}
	}

	D(printf ("%d planes from %d segs\n", planenum, Segs.Size()));

	PlaneChecked.Reserve ((planenum + 7) / 8);
}

// Find "loops" of segs surrounding polyobject's origin. Note that a polyobject's origin
// is not solely defined by the polyobject's anchor, but also by the polyobject itself.
// For the split avoidance to work properly, you must have a convex, complete loop of
// segs surrounding the polyobject origin. All the maps in hexen.wad have complete loops of
// segs around their polyobjects, but they are not all convex: The doors at the start of MAP01
// and some of the pillars in MAP02 that surround the entrance to MAP06 are not convex.
// Heuristic() uses some special weighting to make these cases work properly.

void FNodeBuilder::FindPolyContainers (TArray<FPolyStart> &spots, TArray<FPolyStart> &anchors)
{
	int loop = 1;

	for (unsigned int i = 0; i < spots.Size(); ++i)
	{
		FPolyStart *spot = &spots[i];
		fixed_t bbox[4];

		if (GetPolyExtents (spot->polynum, bbox))
		{
			FPolyStart *anchor;
			unsigned int j;

			for (j = 0; j < anchors.Size(); ++j)
			{
				anchor = &anchors[j];
				if (anchor->polynum == spot->polynum)
				{
					break;
				}
			}

			if (j < anchors.Size())
			{
				vertex_t mid;
				vertex_t center;

				mid.x = bbox[BOXLEFT] + (bbox[BOXRIGHT]-bbox[BOXLEFT])/2;
				mid.y = bbox[BOXBOTTOM] + (bbox[BOXTOP]-bbox[BOXBOTTOM])/2;

				center.x = mid.x - anchor->x + spot->x;
				center.y = mid.y - anchor->y + spot->y;

				// Scan right for the seg closest to the polyobject's center after it
				// gets moved to its start spot.
				fixed_t closestdist = FIXED_MAX;
				DWORD closestseg = 0;

				P(Printf ("start %d,%d -- center %d, %d\n", spot->x>>16, spot->y>>16, center.x>>16, center.y>>16));

				for (unsigned int j = 0; j < Segs.Size(); ++j)
				{
					FPrivSeg *seg = &Segs[j];
					FPrivVert *v1 = &Vertices[seg->v1];
					FPrivVert *v2 = &Vertices[seg->v2];
					fixed_t dy = v2->y - v1->y;

					if (dy == 0)
					{ // Horizontal, so skip it
						continue;
					}
					if ((v1->y < center.y && v2->y < center.y) || (v1->y > center.y && v2->y > center.y))
					{ // Not crossed
						continue;
					}

					fixed_t dx = v2->x - v1->x;

					if (PointOnSide (center.x, center.y, v1->x, v1->y, dx, dy) <= 0)
					{
						fixed_t t = DivScale30 (center.y - v1->y, dy);
						fixed_t sx = v1->x + MulScale30 (dx, t);
						fixed_t dist = sx - spot->x;

						if (dist < closestdist && dist >= 0)
						{
							closestdist = dist;
							closestseg = (long)j;
						}
					}
				}
				if (closestdist != FIXED_MAX)
				{
					loop = MarkLoop (closestseg, loop);
					P(Printf ("Found polyobj in sector %d (loop %d)\n", Segs[closestseg].frontsector,
						Segs[closestseg].loopnum));
				}
			}
		}
	}
}

int FNodeBuilder::MarkLoop (DWORD firstseg, int loopnum)
{
	int seg;
	int sec = Segs[firstseg].frontsector;

	if (Segs[firstseg].loopnum != 0)
	{ // already marked
		return loopnum;
	}

	seg = firstseg;

	do
	{
		FPrivSeg *s1 = &Segs[seg];

		s1->loopnum = loopnum;

		P(Printf ("Mark seg %d (%d,%d)-(%d,%d)\n", seg,
				Vertices[s1->v1].x>>16, Vertices[s1->v1].y>>16,
				Vertices[s1->v2].x>>16, Vertices[s1->v2].y>>16));

		DWORD bestseg = DWORD_MAX;
		DWORD tryseg = Vertices[s1->v2].segs;
		angle_t bestang = ANGLE_MAX;
		angle_t ang1 = s1->angle;

		while (tryseg != DWORD_MAX)
		{
			FPrivSeg *s2 = &Segs[tryseg];

			if (s2->frontsector == sec)
			{
				angle_t ang2 = s2->angle + ANGLE_180;
				angle_t angdiff = ang2 - ang1;

				if (angdiff < bestang && angdiff > 0)
				{
					bestang = angdiff;
					bestseg = tryseg;
				}
			}
			tryseg = s2->nextforvert;
		}

		seg = bestseg;
	} while (seg != (int)DWORD_MAX && Segs[seg].loopnum == 0);

	return loopnum + 1;
}

// Find the bounding box for a specific polyobject.

bool FNodeBuilder::GetPolyExtents (int polynum, fixed_t bbox[4])
{
	unsigned int i;

	bbox[BOXLEFT] = bbox[BOXBOTTOM] = FIXED_MAX;
	bbox[BOXRIGHT] = bbox[BOXTOP] = FIXED_MIN;

	// Try to find a polyobj marked with a start line
	for (i = 0; i < Segs.Size(); ++i)
	{
		if (Level.Lines[Segs[i].linedef].special == PO_LINE_START &&
			Level.Lines[Segs[i].linedef].args[0] == polynum)
		{
			break;
		}
	}

	if (i < Segs.Size())
	{
		vertex_t start;
		unsigned int vert;
		unsigned int count = Segs.Size();	// to prevent endless loops. Stop when this reaches the number of segs.

		vert = Segs[i].v1;

		start.x = Vertices[vert].x;
		start.y = Vertices[vert].y;

		do
		{
			AddSegToBBox (bbox, &Segs[i]);
			vert = Segs[i].v2;
			i = Vertices[vert].segs;
		} while (--count && i != DWORD_MAX && (Vertices[vert].x != start.x || Vertices[vert].y != start.y));

		return true;
	}

	// Try to find a polyobj marked with explicit lines
	bool found = false;

	for (i = 0; i < Segs.Size(); ++i)
	{
		if (Level.Lines[Segs[i].linedef].special == PO_LINE_EXPLICIT &&
			Level.Lines[Segs[i].linedef].args[0] == polynum)
		{
			AddSegToBBox (bbox, &Segs[i]);
			found = true;
		}
	}
	return found;
}

void FNodeBuilder::AddSegToBBox (fixed_t bbox[4], const FPrivSeg *seg)
{
	FPrivVert *v1 = &Vertices[seg->v1];
	FPrivVert *v2 = &Vertices[seg->v2];

	if (v1->x < bbox[BOXLEFT])		bbox[BOXLEFT] = v1->x;
	if (v1->x > bbox[BOXRIGHT])		bbox[BOXRIGHT] = v1->x;
	if (v1->y < bbox[BOXBOTTOM])	bbox[BOXBOTTOM] = v1->y;
	if (v1->y > bbox[BOXTOP])		bbox[BOXTOP] = v1->y;

	if (v2->x < bbox[BOXLEFT])		bbox[BOXLEFT] = v2->x;
	if (v2->x > bbox[BOXRIGHT])		bbox[BOXRIGHT] = v2->x;
	if (v2->y < bbox[BOXBOTTOM])	bbox[BOXBOTTOM] = v2->y;
	if (v2->y > bbox[BOXTOP])		bbox[BOXTOP] = v2->y;
}

FNodeBuilder::FVertexMap::FVertexMap (FNodeBuilder &builder,
	fixed_t minx, fixed_t miny, fixed_t maxx, fixed_t maxy)
	: MyBuilder(builder)
{
	MinX = minx;
	MinY = miny;
	BlocksWide = int(((double(maxx) - minx + 1) + (BLOCK_SIZE - 1)) / BLOCK_SIZE);
	BlocksTall = int(((double(maxy) - miny + 1) + (BLOCK_SIZE - 1)) / BLOCK_SIZE);
	MaxX = MinX + BlocksWide * BLOCK_SIZE - 1;
	MaxY = MinY + BlocksTall * BLOCK_SIZE - 1;
	VertexGrid = new TArray<int>[BlocksWide * BlocksTall];
}

FNodeBuilder::FVertexMap::~FVertexMap ()
{
	delete[] VertexGrid;
}

int FNodeBuilder::FVertexMap::SelectVertexExact (FNodeBuilder::FPrivVert &vert)
{
	TArray<int> &block = VertexGrid[GetBlock (vert.x, vert.y)];
	FPrivVert *vertices = &MyBuilder.Vertices[0];
	unsigned int i;

	for (i = 0; i < block.Size(); ++i)
	{
		if (vertices[block[i]].x == vert.x && vertices[block[i]].y == vert.y)
		{
			return block[i];
		}
	}

	// Not present: add it!
	return InsertVertex (vert);
}

int FNodeBuilder::FVertexMap::SelectVertexClose (FNodeBuilder::FPrivVert &vert)
{
	TArray<int> &block = VertexGrid[GetBlock (vert.x, vert.y)];
	FPrivVert *vertices = &MyBuilder.Vertices[0];
	unsigned int i;

	for (i = 0; i < block.Size(); ++i)
	{
#if VERTEX_EPSILON <= 1
		if (vertices[block[i]].x == vert.x && vertices[block[i]].y == vert.y)
#else
		if (abs(vertices[block[i]].x - vert.x) < VERTEX_EPSILON &&
			abs(vertices[block[i]].y - vert.y) < VERTEX_EPSILON)
#endif
		{
			return block[i];
		}
	}

	// Not present: add it!
	return InsertVertex (vert);
}

int FNodeBuilder::FVertexMap::InsertVertex (FNodeBuilder::FPrivVert &vert)
{
	int vertnum;

	vert.segs = DWORD_MAX;
	vert.segs2 = DWORD_MAX;
	vertnum = (int)MyBuilder.Vertices.Push (vert);

	// If a vertex is near a block boundary, then it will be inserted on
	// both sides of the boundary so that SelectVertexClose can find
	// it by checking in only one block.
	fixed_t minx = MAX (MinX, vert.x - VERTEX_EPSILON);
	fixed_t maxx = MIN (MaxX, vert.x + VERTEX_EPSILON);
	fixed_t miny = MAX (MinY, vert.y - VERTEX_EPSILON);
	fixed_t maxy = MIN (MaxY, vert.y + VERTEX_EPSILON);

	int blk[4] =
	{
		GetBlock (minx, miny),
		GetBlock (maxx, miny),
		GetBlock (minx, maxy),
		GetBlock (maxx, maxy)
	};
	unsigned int blkcount[4] =
	{
		VertexGrid[blk[0]].Size(),
		VertexGrid[blk[1]].Size(),
		VertexGrid[blk[2]].Size(),
		VertexGrid[blk[3]].Size()
	};
	for (int i = 0; i < 4; ++i)
	{
		if (VertexGrid[blk[i]].Size() == blkcount[i])
		{
			VertexGrid[blk[i]].Push (vertnum);
		}
	}

	return vertnum;
}
