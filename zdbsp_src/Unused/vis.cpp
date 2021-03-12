// An adaptation of the Quake vis utility.

#include <string.h>
#include <stdio.h>

#include "zdbsp.h"
#include "nodebuild.h"
#include "rejectbuilder.h"
#include "templates.h"

bool		FastVis=0;
bool		NoPassageVis=1;
bool		NoSort;

//=============================================================================

/*
=============
GetThreadWork

=============
*/
int	FRejectBuilder::GetThreadWork ()
{
	int	r;
	int	f;

	if (dispatch == workcount)
	{
		return -1;
	}

	if (pacifier)
	{
		if (dispatch >= workcount-1)
		{
			fprintf (stderr, "100%%\n");
		}
		else if (oldcount < 0 || dispatch - oldcount > 200)
		{
			oldcount = dispatch;
			f = 100*dispatch / workcount;
			if (f != oldf)
			{
				oldf = f;
				fprintf (stderr, "% 3d%%\b\b\b\b", f);
			}
		}
	}

	r = dispatch++;

	return r;
}
void FRejectBuilder::RunThreadsOnIndividual (int workcnt, bool showpacifier, void(FRejectBuilder::*func)(int))
{
	int work;

	pacifier = showpacifier;
	workcount = workcnt;
	dispatch = 0;
	oldf = -1;
	oldcount = -1;

	while (-1 != (work = GetThreadWork ()))
	{
		(this->*func) (work);
	}
}

//=============================================================================

/*
=============
SortPortals

Sorts the portals from the least complex, so the later ones can reuse
the earlier information.
=============
*/
int FRejectBuilder::PComp (const void *a, const void *b)
{
	return (*(VPortal **)a)->nummightsee - (*(VPortal **)b)->nummightsee;
}
void FRejectBuilder::SortPortals ()
{
	for (int i = 0; i < numportals; i++)
	{
		sorted_portals[i] = &portals[i];
	}

	if (!NoSort)
	{
		qsort (sorted_portals, numportals, sizeof(sorted_portals[0]), PComp);
	}
}


/*
==============
LeafVectorFromPortalVector
==============
*/
int FRejectBuilder::LeafVectorFromPortalVector (BYTE *portalbits, BYTE *leafbits)
{
	int			i, j, leafnum;
	VPortal		*p;
	int			c_leafs;


	for (i = 0; i < numportals; i++)
	{
		if (portalbits[i>>3] & (1<<(i&7)) )
		{
			p = portals+i;
			leafbits[p->leaf>>3] |= (1<<(p->leaf&7));
			//printf ("pleaf: from %d to %d\n", i, p->leaf);
		}
	}

	for (j = 0; j < portalclusters; j++)
	{
		leafnum = j;
		while (leafs[leafnum].merged >= 0)
		{
			leafnum = leafs[leafnum].merged;
		}
		//if the merged leaf is visible then the original leaf is visible
		if (leafbits[leafnum>>3] & (1<<(leafnum&7)))
		{
			leafbits[j>>3] |= (1<<(j&7));
		}
	}

	c_leafs = CountBits (leafbits, portalclusters);

	return c_leafs;
}


/*
===============
ClusterMerge

Merges the portal visibility for a leaf
===============
*/
void FRejectBuilder::ClusterMerge (int leafnum)
{
	FLeaf		*leaf;
	BYTE		portalvector[MAX_PORTALS/8];
	BYTE		uncompressed[MAX_MAP_LEAFS/8];
	int			i, j;
	int			numvis, mergedleafnum;
	VPortal		*p;
	int			pnum;

	// OR together all the portalvis bits

	mergedleafnum = leafnum;
	while (leafs[mergedleafnum].merged >= 0)
	{
		mergedleafnum = leafs[mergedleafnum].merged;
	}

	memset (portalvector, 0, portalbytes);
	leaf = &leafs[mergedleafnum];
	for (i = 0; i < leaf->numportals; i++)
	{
		p = leaf->portals[i];
		if (p->removed)
			continue;

		if (p->status != STAT_Done)
		{
			throw exception("portal not done");
		}
		for (j = 0; j < portallongs; j++)
		{
			((long *)portalvector)[j] |= ((long *)p->portalvis)[j];
		}
		pnum = p - portals;
		portalvector[pnum>>3] |= 1<<(pnum&7);
	}

	memset (uncompressed, 0, leafbytes);

	// convert portal bits to leaf bits
	uncompressed[mergedleafnum>>3] |= (1<<(mergedleafnum&7));
	numvis = LeafVectorFromPortalVector (portalvector, uncompressed);

	totalvis += numvis;

	//printf ("cluster %4i : %4i visible\n", leafnum, numvis);

	memcpy (visBytes + leafnum*leafbytes, uncompressed, leafbytes);
}


/*
==================
CalcPortalVis
==================
*/
void FRejectBuilder::CalcPortalVis ()
{
#ifdef MREDEBUG
	_printf("%6d portals out of %d", 0, numportals);
	//get rid of the counter
	RunThreadsOnIndividual (numportals, false, PortalFlow);
#else
	RunThreadsOnIndividual (numportals, true, PortalFlow);
#endif

}

/*
==================
CalcPassagePortalVis
==================
*/

void FRejectBuilder::CalcPassagePortalVis ()
{
	PassageMemory();

#ifdef MREDEBUG
	_printf("%6d portals out of %d", 0, numportals);
	RunThreadsOnIndividual (numportals, false, CreatePassages);
	_printf("\n");
	_printf("%6d portals out of %d", 0, numportals);
	RunThreadsOnIndividual (numportals, false, PassagePortalFlow);
	_printf("\n");
#else
	RunThreadsOnIndividual (numportals, true, CreatePassages);
	printf (" Vis 3: ");
	RunThreadsOnIndividual (numportals, true, PassagePortalFlow);
#endif
}

/*
==================
CalcFastVis
==================
*/
void FRejectBuilder::CalcFastVis ()
{
	// fastvis just uses mightsee for a very loose bound
	for (int i = 0; i < numportals; i++)
	{
		portals[i].portalvis = portals[i].portalflood;
		portals[i].status = STAT_Done;
	}
}

/*
==================
CalcVis
==================
*/
void FRejectBuilder::CalcVis ()
{
	printf (" Vis 1: ");
	RunThreadsOnIndividual (numportals, true, BasePortalVis);

//	RunThreadsOnIndividual (numportals, true, BetterPortalVis);

	SortPortals ();

	printf (" Vis 2: ");
	if (FastVis)
		CalcFastVis();
	else if (NoPassageVis)
		CalcPortalVis ();
	else
		CalcPassagePortalVis();
	//
	// assemble the leaf vis lists by oring and compressing the portal lists
	//
	printf ("creating leaf vis...\n");
	for (int i = 0; i < portalclusters; i++)
	{
		ClusterMerge (i);
	}
		
	printf ("Average clusters visible: %i\n", totalvis / portalclusters);
}

/*
=============
Winding_PlanesConcave
=============
*/
bool FRejectBuilder::Winding_PlanesConcave (const FWinding *w1, const FWinding *w2,
											const FLine &line1, const FLine &line2)
{
	// check if one of the points of winding 1 is at the front of the line of winding 2
	if (PointOnSide (w1->points[0], line2) < 0 ||
		PointOnSide (w1->points[1], line2) < 0)
	{
		return true;
	}

	// check if one of the points of winding 2 is at the front of the line of winding 1
	if (PointOnSide (w2->points[0], line1) < 0 ||
		PointOnSide (w2->points[1], line1) < 0)
	{
		return true;
	}

	return false;
}

/*
============
TryMergeLeaves
============
*/
bool FRejectBuilder::TryMergeLeaves (int l1num, int l2num)
{
	int i, j, numportals;
	FLeaf *l1, *l2;
	VPortal *p1, *p2;
	VPortal *portals[MAX_PORTALS_ON_LEAF];

	l1 = &leafs[l1num];
	for (i = 0; i < l1->numportals; i++)
	{
		p1 = l1->portals[i];
		if (p1->leaf == l2num) continue;
		l2 = &leafs[l2num];
		for (j = 0; j < l2->numportals; j++)
		{
			p2 = l2->portals[j];
			if (p2->leaf == l1num) continue;
			//
			if (Winding_PlanesConcave (&p1->winding, &p2->winding, p1->line, p2->line))
				return false;
		}
	}
	l1 = &leafs[l1num];
	l2 = &leafs[l2num];
	numportals = 0;
	//the leaves can be merged now
	for (i = 0; i < l1->numportals; i++)
	{
		p1 = l1->portals[i];
		if (p1->leaf == l2num)
		{
			p1->removed = true;
			continue;
		}
		portals[numportals++] = p1;
	}
	for (j = 0; j < l2->numportals; j++)
	{
		p2 = l2->portals[j];
		if (p2->leaf == l1num)
		{
			p2->removed = true;
			continue;
		}
		portals[numportals++] = p2;
	}
	delete[] l1->portals;
	l1->portals = NULL;
	l1->numportals = 0;
	delete[] l2->portals;
	l2->portals = new VPortal *[numportals];
	for (i = 0; i < numportals; i++)
	{
		l2->portals[i] = portals[i];
	}
	l2->numportals = numportals;
	l1->merged = l2num;
	return true;
}

/*
============
UpdatePortals
============
*/
void FRejectBuilder::UpdatePortals ()
{
	int i;
	VPortal *p;

	for (i = 0; i < numportals; i++)
	{
		p = &portals[i];
		if (!p->removed)
		{
			while (leafs[p->leaf].merged >= 0)
			{
				p->leaf = leafs[p->leaf].merged;
			}
		}
	}
}

/*
============
MergeLeaves

try to merge leaves but don't merge through hint splitters
============
*/
void FRejectBuilder::MergeLeaves ()
{
	int i, j, nummerges, totalnummerges;
	FLeaf *leaf;
	VPortal *p;

	totalnummerges = 0;
	do
	{
		printf (".");
		nummerges = 0;
		for (i = 0; i < portalclusters; i++)
		{
			leaf = &leafs[i];
			//if this leaf is merged already
			if (leaf->merged >= 0)
				continue;
			//
			for (j = 0; j < leaf->numportals; j++)
			{
				p = leaf->portals[j];
				//
				if (p->removed)
					continue;
				//never merge through hint portals
				if (p->hint)
					continue;
				if (TryMergeLeaves(i, p->leaf))
				{
					UpdatePortals();
					nummerges++;
					break;
				}
			}
		}
		totalnummerges += nummerges;
	} while (nummerges);
	printf("\r%6d leaves merged\n", totalnummerges);
}

/*
============
TryMergeWinding
============
*/

FRejectBuilder::FWinding *FRejectBuilder::TryMergeWinding (FWinding *f1, FWinding *f2, const FLine &line)
{
	static FWinding result;
	int i, j;

	//
	// find a common point
	//
	for (i = 0; i < 2; ++i)
	{
		for (j = 0; j < 2; ++j)
		{
			if (f1->points[i].x == f2->points[j].x &&
				f1->points[i].y == f2->points[j].y)
			{
				goto found;
			}
		}
	}

	// no shared point
	return NULL;

found:
	//
	// if the lines are colinear, the point can be removed
	//
	if (PointOnSide (f2->points[0], line) != 0 ||
		PointOnSide (f2->points[1], line) != 0)
	{ // not colinear
		return NULL;
	}

	//
	// build the new segment
	//
	if (i == 0)
	{
		result.points[0] = f2->points[!j];
		result.points[1] = f1->points[1];
	}
	else
	{
		result.points[0] = f1->points[0];
		result.points[1] = f2->points[!j];
	}
	return &result;
}

/*
============
MergeLeafPortals
============
*/
void FRejectBuilder::MergeLeafPortals ()
{
	int i, j, k, nummerges, hintsmerged;
	FLeaf *leaf;
	VPortal *p1, *p2;
	FWinding *w;

	nummerges = 0;
	hintsmerged = 0;
	for (i = 0; i < portalclusters; i++)
	{
		leaf = &leafs[i];
		if (leaf->merged >= 0) continue;
		for (j = 0; j < leaf->numportals; j++)
		{
			p1 = leaf->portals[j];
			if (p1->removed)
				continue;
			for (k = j+1; k < leaf->numportals; k++)
			{
				p2 = leaf->portals[k];
				if (p2->removed)
					continue;
				if (p1->leaf == p2->leaf)
				{
					w = TryMergeWinding (&p1->winding, &p2->winding, p1->line);
					if (w)
					{
						p1->winding = *w;
						if (p1->hint && p2->hint)
							hintsmerged++;
						p1->hint |= p2->hint;
						p2->removed = true;
						nummerges++;
						i--;
						break;
					}
				}
			}
			if (k < leaf->numportals)
				break;
		}
	}
	printf("%6d portals merged\n", nummerges);
	printf("%6d hint portals merged\n", hintsmerged);
}

/*
============
CountActivePortals
============
*/
int FRejectBuilder::CountActivePortals ()
{
	int num, hints, j;
	VPortal *p;

	num = 0;
	hints = 0;
	for (j = 0; j < numportals; j++)
	{
		p = portals + j;
		if (p->removed)
			continue;
		if (p->hint)
			hints++;
		num++;
	}
	printf("%6d of %d active portals\n", num, numportals);
	printf("%6d hint portals\n", hints);
	return num;
}
