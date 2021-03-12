// The old code used the same algorithm as DoomBSP:
//
//   Represent each sector by its bounding box. Then for each pair of
//   sectors, see if any chains of one-sided lines can walk from one
//   side of the convex hull for that pair to the other side.
//
//   It works, but it's far from being perfect. It's quite easy for
//   this algorithm to consider two sectors as being visible from
//   each other when they are really not. But it won't erroneously
//   flag two sectors as obstructed when they're really not, and that's
//   the only thing that really matters when building a REJECT lump.
//
// Because that was next to useless, I scrapped that code and adapted
// Quake's vis utility to work in a 2D world. Since this is basically vis,
// it depends on GL nodes being present to function. As the usefulness
// of a REJECT lump is debatable, I have chosen to not compile this module
// in with ZDBSP. Save yourself some space and run ZDBSP with the -r option.

#include <string.h>
#include <stdio.h>

#include "zdbsp.h"
#include "nodebuild.h"
#include "rejectbuilder.h"
#include "templates.h"

bool		MergeVis=1;

FRejectBuilder::FRejectBuilder (FLevel &level)
	: Level (level), testlevel (2), totalvis (0)
{
	LoadPortals ();

	if (MergeVis)
	{
		MergeLeaves ();
		MergeLeafPortals ();
	}

	CountActivePortals ();
	CalcVis ();

	BuildReject ();
}

FRejectBuilder::~FRejectBuilder ()
{
}

BYTE *FRejectBuilder::GetReject ()
{
	WORD *sectormap;
	int i, j; 

	int rejectSize = (Level.NumSectors*Level.NumSectors + 7) / 8;
	BYTE *reject = new BYTE[rejectSize];
	memset (reject, 0xff, rejectSize);

	int pvs_size = (Level.NumGLSubsectors * Level.NumGLSubsectors) + 7 / 8;
	Level.GLPVS = new BYTE[pvs_size];
	Level.GLPVSSize = pvs_size;
	memset (Level.GLPVS, 0, pvs_size);

	sectormap = new WORD[Level.NumGLSubsectors];
	for (i = 0; i < Level.NumGLSubsectors; ++i)
	{
		const MapSegGLEx *seg = &Level.GLSegs[Level.GLSubsectors[i].firstline];
		sectormap[i] = Level.Sides[Level.Lines[seg->linedef].sidenum[seg->side]].sector;
	}

	for (i = 0; i < Level.NumGLSubsectors; ++i)
	{
		int rowpvs = i*Level.NumGLSubsectors;
		int rowrej = sectormap[i]*Level.NumSectors;
		BYTE *bytes = visBytes + i*leafbytes;
		for (j = 0; j < Level.NumGLSubsectors; ++j)
		{
			if (bytes[j>>3] & (1<<(j&7)))
			{
				int mark = rowpvs + j;
				Level.GLPVS[mark>>3] |= 1<<(mark&7);

				mark = rowrej + sectormap[j];
				reject[mark>>3] &= ~(1<<(mark&7));
			}
		}
	}

	return reject;
}

void FRejectBuilder::BuildReject ()
{
}

inline const WideVertex *FRejectBuilder::GetVertex (WORD vertnum)
{
	return &Level.Vertices[vertnum];
}

FRejectBuilder::FLeaf::FLeaf ()
	: numportals (0), merged (-1), portals (NULL)
{
}

FRejectBuilder::FLeaf::~FLeaf ()
{
	if (portals != NULL)
	{
		delete[] portals;
	}
}

int FRejectBuilder::PointOnSide (const FPoint &point, const FLine &line)
{
	return FNodeBuilder::PointOnSide (point.x, point.y, line.x, line.y, line.dx, line.dy);
}

void FRejectBuilder::LoadPortals ()
{
	WORD		*segleaf;
	int			i, j, k, max;
	VPortal		*p;
	FLeaf		*l;
	FWinding	*w;
	
	portalclusters = Level.NumGLSubsectors;

	for (numportals = 0, i = 0; i < Level.NumGLSegs; ++i)
	{
		if (Level.GLSegs[i].partner != DWORD_MAX)
		{
			++numportals;
		}
	}

	// these counts should take advantage of 64 bit systems automatically
	leafbytes = ((portalclusters+63)&~63)>>3;
	leaflongs = leafbytes/sizeof(long);

	portalbytes = ((numportals+63)&~63)>>3;
	portallongs = portalbytes/sizeof(long);

	portals = new VPortal[numportals];
	memset (portals, 0, numportals*sizeof(VPortal));
	
	leafs = new FLeaf[portalclusters];

	numVisBytes = portalclusters*leafbytes;
	visBytes = new BYTE[numVisBytes];

	segleaf = new WORD[Level.NumGLSegs];
	for (i = 0; i < Level.NumGLSubsectors; ++i)
	{
		j = Level.GLSubsectors[i].firstline;
		max = j + Level.GLSubsectors[i].numlines;

		for (; j < max; ++j)
		{
			segleaf[j] = i;
		}
	}

	p = portals;
	l = leafs;
	for (i = 0; i < Level.NumGLSubsectors; ++i, ++l)
	{
		j = Level.GLSubsectors[i].firstline;
		max = j + Level.GLSubsectors[i].numlines;

		// Count portals in this leaf
		for (; j < max; ++j)
		{
			if (Level.GLSegs[j].partner != DWORD_MAX)
			{
				++l->numportals;
			}
		}

		if (l->numportals == 0)
		{
			continue;
		}

		l->portals = new VPortal *[l->numportals];

		for (k = 0, j = Level.GLSubsectors[i].firstline; j < max; ++j)
		{
			const MapSegGLEx *seg = &Level.GLSegs[j];

			if (seg->partner == DWORD_MAX)
			{
				continue;
			}

			// create portal from seg
			l->portals[k++] = p;
			
			w = &p->winding;
			w->points[0] = GetVertex (seg->v1);
			w->points[1] = GetVertex (seg->v2);

			p->hint = seg->linedef != NO_INDEX;
			p->line.x = w->points[1].x;
			p->line.y = w->points[1].y;
			p->line.dx = w->points[0].x - p->line.x;
			p->line.dy = w->points[0].y - p->line.y;
			p->leaf = segleaf[seg->partner];

			p++;
		}
	}

	delete[] segleaf;
}
