//------------------------------------------------------------------------
//  ISLANDS
//------------------------------------------------------------------------
//
//  Oblige Level Maker (C) 2005 Andrew Apted
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

// this includes everything we need
#include "defs.h"


// TODO HERE:
//   -  sometimes just eliminate an island rather than find a link
//      for it.  Especially if the cost is high and the size is small
//      and number of islands is high.
//
//   -  small tunnels: enlarge existing area (don't make tunnel),
//      dist 1 -> 90%  dist 2 -> 50%  dist 3 -> 20%
//
//   -  sky ceiling mismatches : force CAVE tunnel
//

class xy_link_c
{
public:
	xy_link_c(int _index, int _sx, int _sy, int _dx, int _dy, bool void_and_lava) :
		index(_index), src_x(_sx), src_y(_sy), dest_x(_dx), dest_y(_dy),
		teleport(false)
	{
		SYS_ASSERT(src_x <= dest_x);
		SYS_ASSERT(src_y <= dest_y);

		/* compute cost */

		cost = MAX(dest_x - src_x, dest_y - src_y) * 10;

		if (void_and_lava)
			cost += 200;

		location_c& LS = the_world->Loc(src_x, src_y);
		location_c& LD = the_world->Loc(dest_x, dest_y);

		// XXX: give non-damaging Water at src/dest a penalty ?

		// XXX: give floor difference a penalty ?

		if (LS.env != LD.env)
			cost += (LS.Indoor() != LD.Indoor()) ? 4 : 2;

		if (LS.mat != LD.mat)
			cost += 1;
	}

	virtual ~xy_link_c()
	{ }

public:
	int index;

	// starting point to ending point.  Either horizontal or vertical.
	// Inclusive :- source and dest are valid (walkable) locations.
	int src_x, src_y;
	int dest_x, dest_y;

	int cost;

	bool teleport;

	inline void MakeTeleport() { teleport = true; }
	inline bool IsTeleport() const { return teleport; }

	inline area_c *src_A() const
	{
		return the_world->Area(the_world->Loc(src_x, src_y).area);
	}

	inline area_c *dest_A() const
	{
		return the_world->Area(the_world->Loc(dest_x, dest_y).area);
	}
	
	inline int src_island()  const { return src_A()->island;  }
	inline int dest_island() const { return dest_A()->island; }

	area_c *other_A(int this_island) const
	{
		if (src_island() == this_island)
			return dest_A();
		else if (dest_island() == this_island)
			return src_A();

		AssertFail("Linkage does not touch island %d (only %d,%d)\n",
					src_island(), dest_island());
		return NULL; /* NOT REACHED */
	}

	inline int other_island(int this_island) const
	{
		return other_A(this_island)->island;
	}

	inline int dx() const { return (src_x < dest_x) ? +1 : 0; }
	inline int dy() const { return (src_y < dest_y) ? +1 : 0; }

	int Length() const
	{
		return MAX(dest_x - src_x, dest_y - src_y) - 1;
	}

	bool Touches(const xy_link_c& other) const
	{
		return ! (src_x > other.dest_x+2 || src_y > other.dest_y+2 ||
		          other.src_x > dest_x+2 || other.src_y > dest_y+2);
	}
};

//------------------------------------------------------------------------

class island_c
{
public:
	island_c(int _index, area_c *_base) :
		index(_index), merge_index(_index), base(_base),
		links()
	{
		ComputeSize();

		merge_size = size;
	}

	virtual ~island_c()
	{ }

public:
	int index;
	int merge_index;

	area_c *base;

	std::vector<xy_link_c *> links;

	// number of squares for this island
	int size;

	// number of squares in the merged island group.
	// Only valid when merge_index == index.
	int merge_size;

public:
	void ComputeSize()
	{
		size = 0;

		FOR_AREA(A, a_idx)
		{
			if (A->island == index)
				size += A->total;
		}}
	}

	void TryAddLink(xy_link_c *K)
	{
		// check existing links, if the destination is new simply add it in.
		// If the destination already exists and the cost is lower, replace
		// that link.

		for (int n = 0; n < (int)links.size(); n++)
		{
			if (K->other_island(index) != links[n]->other_island(index))
				continue;

			if (K->cost >= links[n]->cost)
				return;

			links[n] = K;

			PrintDebug("# Improved link from %d --> %d : cost %d\n",
					index, K->other_island(index), K->cost);
			return;
		}

		PrintDebug("# Adding link from island %d --> %d : cost %d\n",
				index, K->other_island(index), K->cost);

		links.push_back(K);
	}

	void RemoveDeadLink(xy_link_c *K)
	{
		for (int n = 0; n < (int)links.size(); n++)
		{
			if (links[n] == K)
			{
				PrintDebug("#### Link from island %d -> %d removed\n",
						index, K->other_island(index));

				links[n] = NULL;
			}
		}
	}

	void Eliminate()
	{
		PrintDebug("# Eliminating island %d\n", index);

		FOR_AREA(A, a_idx)
		{
			if (A->island == index)
				A->MakeVoid();
		}}

		size = merge_size = 0;
	}
};


//------------------------------------------------------------------------


namespace island_build
{
/* private data */

std::vector<xy_link_c *> xy_links;
std::vector<island_c *>  Islands;
std::vector<xy_link_c *> final_links;


#define FOR_ISLAND(ptr_var, idx_var)  \
	for (int idx_var = 0; idx_var < (int)Islands.size(); idx_var++)  \
	{  \
		island_c *ptr_var = Islands[idx_var];  \
		if (! ptr_var) continue;

#define FOR_LINK(ptr_var, idx_var)  \
	for (int idx_var = 0; idx_var < (int)xy_links.size(); idx_var++)  \
	{  \
		xy_link_c *ptr_var = xy_links[idx_var];  \
		if (! ptr_var) continue;


// returns zero when no such island
int GetIslandSize(int island)
{
	int size = 0;

	FOR_AREA(A, ar_j)
	{
		if (A->island == island)
			size += A->total;
	}}

	return size;
}

int FindSeparateAreas(bool lava_bad, int *max_island)
{
	// step 1: assign integers to each area
	FOR_AREA(A, ar_idx)
	{
		if (A->IsDamage() && lava_bad)
			A->island = -1;
		else
			A->island = ar_idx;
	}}

	// step 2: iterate over areas, merging neighbours.
	for (;;)
	{
		bool changes = false;

		FOR_AREA(A, ar_j)
		{
			if (A->island < 0)
				continue;

			FOR_NEIGHBOUR_IN_AREA(B, N, nb_idx, A)
			{
				if (B->island < 0)
					continue;

				if (A->island > B->island)
				{
					A->island = B->island;
					changes = true;
				}
			}}
		}}

		if (! changes)
			break;
	}

	*max_island = 0;

	FOR_AREA(A, ar_j)
	{
		if (*max_island < A->island)
			*max_island = A->island;

		PrintDebug("AREA %d --> ISLAND %d (size %d)\n",
			A->index, A->island, A->total);
	}}

	PrintDebug("\n");

	int count = 0;

	for (int grp = 0; grp <= *max_island; grp++)
	{
		int size = GetIslandSize(grp);

		if (size > 0)
		{
			count++;

			PrintDebug("%s ISLAND %d: size %d\n",
					lava_bad ? "DAMAGING" : "VOID", grp, size);
		}
	}

	PrintDebug("\n");

	return count;
}

void Initial_Islands(int max_island)
{
	FOR_AREA(A, a_idx)
	{
		if (A->island < 0)
			continue;

		if (A->island >= (int)Islands.size())
		{
			int old_size = (int)Islands.size();

			Islands.resize(A->island + 1);

			while (old_size <= A->island)
				Islands[old_size++] = NULL;
		}

		if (! Islands[A->island])
		{
			Islands[A->island] = new island_c(A->island, A);

			PrintDebug("# Created island %d\n", A->island);
		}
	}}
}

#if 0
void PurgeHiddenLavaPool(int island)
{
	bool exists = false;

	FOR_AREA(A, a_idx)
	{
		if (A->island != island)
			continue;

		if (! A->IsDamage())  // island contains non-Lava
			return;

		exists = true;
	}};

	if (exists)
	{
		PrintDebug("Purging hidden lava pool (island %d)\n", island);

		FOR_AREA(A, a_idx)
		{
			if (A->island == island)
				A->MakeVoid();
		}}
	
		the_world->PurgeDeadAreas();
	}
}

void PurgeLavaOnly(int max_island)
{
	for (int j_idx = 0; j_idx <= max_island; j_idx++)
	{
		PurgeHiddenLavaPool(j_idx);
	}
}
#endif

//------------------------------------------------------------------------

bool CheckSidesClear(int src_x, int src_y, int dest_x, int dest_y, int dx, int dy)
{
	int S_area = the_world->Loc(src_x, src_y).area;
	int D_area = the_world->Loc(dest_x, dest_y).area;

	SYS_ASSERT(S_area >= 0);
	SYS_ASSERT(D_area >= 0);

	for (; (src_x <= dest_x && src_y <= dest_y); src_x += dx, src_y += dy)
	{
		SYS_ASSERT(the_world->Inside(src_x, src_y));

		// do both sides
		for (int sd = -2; sd <= +2; sd++)
		{
			if (sd == 0)
				continue;

			int x = src_x + sd * dy;
			int y = src_y + sd * dx;

			if (the_world->Outside(x, y))
				continue;	

			location_c& side = the_world->Loc(x, y);

			if (side.Void() || side.IsDamage())
				continue;

			if (side.area == S_area || side.area == D_area)
				continue;

			return false;  // found a blocker
		}
	}

	return true;  // all clear
}

void LookForXYLink(int x, int y, int dx, int dy)
{
	while (the_world->Inside(x+dx, y+dy))
	{
		location_c& S = the_world->Loc(x, y);
		location_c& N = the_world->Loc(x+dx, y+dy);

		if (S.Void() || S.Area()->island < 0 || ! (N.Void() || N.Area()->island < 0))
		{
			x += dx; y += dy; continue;
		}

		int src_x = x;
		int src_y = y;

		x += dx;
		y += dy;

		bool has_void = false;
		bool has_lava = false;

		for (;;)
		{
			if (the_world->Outside(x, y))
				break;

			location_c& D = the_world->Loc(x, y);

			if (D.Void() || D.Area()->island < 0)
			{
				if (D.Void())
					has_void = true;
				else
					has_lava = true;

				x += dx; y += dy; continue;
			}

			if (D.Area()->island == S.Area()->island)
				break;

			/* FOUND ONE */

			// make sure the sides don't touch another area
			if (! CheckSidesClear(src_x, src_y, x, y, dx, dy))
				break;

			xy_link_c *XY = new xy_link_c((int)xy_links.size(),
				 	src_x, src_y, x, y, has_void && has_lava);

			PrintDebug("### XY LINK %d: (%d,%d) -> (%d,%d) cost %d (%s, %s)\n",
					XY->index, src_x, src_y, x, y, XY->cost,
					has_void ? "VOID" : "no_void", has_lava ? "LAVA" : "no_lava");

			xy_links.push_back(XY);
			break;
		}
	}
}

void CreateXYLinks()
{
	for (int x = 0; x < the_world->w(); x++)
	{
		LookForXYLink(x, 0, 0, +1);
	}

	for (int y = 0; y < the_world->h(); y++)
	{
		LookForXYLink(0, y, +1, 0);
	}
}

void AddLinkToGraph(xy_link_c *K, area_c *A)
{
	SYS_ASSERT(A->island >= 0);

	island_c *J = Islands[A->island];

	SYS_ASSERT(J);

	// only "up-links" are stored (i.e. this island must have a lower
	// index than the other end).
	if (J->index < K->other_island(J->index))
	{
		J->TryAddLink(K);
	}
}

void MakeLinkageGraph()
{
	FOR_LINK(K, k_idx)
	{
		AddLinkToGraph(K, K->src_A());
		AddLinkToGraph(K, K->dest_A());
	}}
}

//------------------------------------------------------------------------

void DumpIslands()
{
	PrintDebug("{\n");

	FOR_ISLAND(J, j_idx)
	{
		if (J->index != J->merge_index)
			continue;

		PrintDebug("  Island %d (merge %d): base area %d @ (%d,%d), size %d (merged %d)\n",
				J->index, J->merge_index, J->base->index,
				J->base->MidX(), J->base->MidY(),
				J->size, J->merge_size);
	}}

	PrintDebug("}\n");
}

void RemoveDeadLink(xy_link_c *K)
{
	SYS_ASSERT(xy_links[K->index]);

	FOR_ISLAND(J, j_idx)
	{
		J->RemoveDeadLink(K);

		// Ideally we would rescan the XY-link list for a replacement
		// (the next best link).  But in practise this is rarely needed,
		// and an alternate route will always be made.
	}}

	delete xy_links[K->index];

	xy_links[K->index] = NULL;
}

void RemoveTouchingLinks(xy_link_c *T)
{
	FOR_LINK(K, k_idx)
	{
		if (T->Touches(*K))
		{
			PrintDebug("## Removing link %d which touches %d\n", k_idx, T->index);

			RemoveDeadLink(K);
		}
	}}
}

int CountMergedIslands()
{
	int count = 0;

	FOR_ISLAND(J, j_idx)
	{
		if (J->index == J->merge_index)
			count++;
#if 0
		bool exists = false;

		// FIXME: this sucks - OPTIMISE !
		FOR_ISLAND(J2, j2_idx)
		{
			if (J2->merge_index == j_idx)
			{
				exists = true;
				break;
			}
		}}

		if (exists)
			count++;
#endif
	}}

	return count;
}

xy_link_c *SelectBestLink()
{
	xy_link_c *best = NULL;
	int best_cost = (1 << 30);

	FOR_ISLAND(J, j_idx)
	{
		for (int n = 0; n < (int)J->links.size(); n++)
		{
			xy_link_c *K = J->links[n];
			if (! K) continue;

			island_c *S = Islands[K->src_island()];
			island_c *D = Islands[K->dest_island()];

			if (S->merge_index == D->merge_index)
				continue;

			if (! best || K->cost < best_cost)
			{
				best = K;
				best_cost = K->cost;
			}
		}
	}}

	return best;
}

void ConnectTwoIslands(xy_link_c *K)
{
	island_c *S = Islands[K->src_island()];
	island_c *D = Islands[K->dest_island()];

	PrintDebug("Connecting islands %d <-> %d via link %d (cost %d)\n",
			S->index, D->index, K->index, K->cost);

	SYS_ASSERT(S && D && S != D);
	SYS_ASSERT(S->merge_index != D->merge_index);

	// transfer link from xy_links[] to final_links[]
	xy_links[K->index] = NULL;

	final_links.push_back(K);

	RemoveTouchingLinks(K);

	/* perform merger */

	S = Islands[S->merge_index];
	D = Islands[D->merge_index];

	SYS_ASSERT(S && D && S != D);

	SYS_ASSERT(S->index == S->merge_index);
	SYS_ASSERT(D->index == D->merge_index);

	int old_index = MAX(S->merge_index, D->merge_index);
	int new_index = MIN(S->merge_index, D->merge_index);

	FOR_ISLAND(J, j_idx)
	{
		if (J->merge_index == old_index)
			J->merge_index =  new_index;
	}};

	S->merge_size = D->merge_size = (S->merge_size + D->merge_size);

	DumpIslands();
}

void HandleUnlinked()
{
	int best_merge = -1;

	FOR_ISLAND(J, j_idx)
	{
		if (best_merge < 0 ||
			Islands[best_merge]->merge_size < Islands[J->merge_index]->merge_size)
		{
			best_merge = J->merge_index;
		}
	}}

	PrintDebug("HandleUnlinked: best merge %d (size %d)\n",
			best_merge, best_merge < 0 ? -1 : Islands[best_merge]->merge_size);

	if (best_merge < 0)
		return;

	FOR_ISLAND(J, j_idx)
	{
		if (J->merge_index != best_merge)
			J->Eliminate();
	}}

	the_world->PurgeDeadAreas();
}

void ConnectIslands()
{
	DumpIslands();

	for (;;)
	{
		PrintDebug("Number of merged islands: %d\n", CountMergedIslands());

		xy_link_c *best = SelectBestLink();

		if (! best)
			break;

		ConnectTwoIslands(best);
	}

	PrintDebug("Final number of islands: %d\n", CountMergedIslands());

	// handle any outstanding (unlinked) islands.
	// Note: this happens extremely rarely, nothing more elaborate
	//       than simply removing them is needed.
	HandleUnlinked();

	PrintDebug("\n");
}

//------------------------------------------------------------------------

void SelectTeleporters()
{
	int L_num = (int)final_links.size();

	// compute maximum number of teleporters
	int T_max = 1 + the_world->dim() / 40;

	if (T_max > 1 + L_num / 2)
		T_max = 1 + L_num / 2;

	PrintDebug("SelectTeleporters: L_num %d  T_max %d\n", L_num, T_max);

	for (int f_idx = L_num - 1; f_idx >= 0; f_idx--)
	{
		xy_link_c *F = final_links[f_idx];
		SYS_ASSERT(F);

		// compute a percentage that we'll convert this link into
		// a teleporter.  A high cost link should be very likely,
		// and a low cost link should be very unlikely.

		int tele_chance = 0;

		if (F->cost >= 320)
			tele_chance = 100;
		else if (F->cost >= 20)
			tele_chance = 10 + (F->cost - 20) * 90 / (320 - 20);

		SYS_ASSERT(0 <= tele_chance && tele_chance <= 100);

		if (T_max > 0 && RandomPerc(tele_chance))
		{
			F->MakeTeleport();
			T_max--;
		}

		PrintDebug("|  Link %3d  %s :  cost %4d -> tele_chance %d\n",
				F->index, F->IsTeleport() ? "TELEPORT" : "tunnel  ",
				F->cost, tele_chance);
	}

	PrintDebug("+\n\n");
}

area_c *GoodTeleportOutArea(int island)
{
	FOR_AREA(A, a_idx)
	{
		if (A->island != island)
			continue;

		if (A->teleport)  // already taken ?
			continue;

		// FIXME: evaluate area for teleport

		return A;
	}}

	PrintDebug("Unable to find good Teleport Out area for island %d\n", island);
	return NULL;
}

bool AssignTeleport(xy_link_c *T)
{
	island_c *S = Islands[T->src_island()];
	island_c *D = Islands[T->dest_island()];

	if (S->size < D->size)
	{
		island_c *temp = S; S = D; D = temp;
	}

	area_c *SA = GoodTeleportOutArea(S->index);
	area_c *DA = GoodTeleportOutArea(D->index);

	if (! SA || ! DA)
		return false;

	SYS_ASSERT(SA && ! SA->teleport);
	SYS_ASSERT(DA && ! DA->teleport);

	SA->teleport = DA;
	DA->teleport = SA;

	PrintDebug("Assigned Teleport: area %d <--> %d\n",
		SA->index, DA->index);

	return true;  // was OK
}

//------------------------------------------------------------------------

void RehomeLavaAreas()
{
	// sometimes lava areas are overwritten by a tunnel.
	// This routine makes sure that the focal point is still valid.

	FOR_AREA(A, a_idx)
	{
		if (A->island >= 0)
			continue;

		if (A->Focal().area != A->index)
		{
			PrintDebug("Rehoming lava area %d\n", A->index);
			PrintDebug("|  old total: %d  old focal (%d,%d)\n",
					A->total, A->focal_x, A->focal_y);

			A->total = 0;  // also recompute new total

			FOR_LOC_IN_AREA(x, y, loc, A)
			{
				if (A->total == 0)
				{
					A->focal_x = x;
					A->focal_y = y;
				}

				A->total++;
			}}

			PrintDebug("|  new total: %d  new focal (%d,%d)\n",
					A->total, A->focal_x, A->focal_y);

			if (A->total == 0)
				FatalError("Damaging area %d disappeared!\n");
		}
	}}
}

int DigEdgeScore(xy_link_c *T, int edge, int dx, int dy)
{
	SYS_ASSERT(edge == -1 || edge == +1);

	int sx = T->src_x + dy * edge;
	int sy = T->src_y + dx * edge;

	int ex = T->dest_x + dy * edge;
	int ey = T->dest_y + dx * edge;

	if (the_world->Outside(sx, sy))
		return 0;  // not even possible

	SYS_ASSERT(the_world->Inside(ex, ey));

	// check the bounding boxes
	if (sx < T->src_A()->lo_x  || sx > T->src_A()->hi_x  ||
	    sy < T->src_A()->lo_y  || sy > T->src_A()->hi_y  ||
	    ex < T->dest_A()->lo_x || ex > T->dest_A()->hi_x ||
	    ey < T->dest_A()->lo_y || ey > T->dest_A()->hi_y)
	{
		return 0;
	}

	int score = 16;

	// check for a good match-up for this edge of the tunnel.
	// Ideally the tunnel is a perfect rectangle (two squares wide).

	location_c& LS1 = the_world->Loc(sx, sy);
	location_c& LE1 = the_world->Loc(ex, ey);

	if (! LS1.Void() && LS1.area == T->src_A()->index)  score += 30;
	if (! LE1.Void() && LE1.area == T->dest_A()->index) score += 30;

	location_c& LS2 = the_world->Loc(sx+dx, sy+dy);
	location_c& LE2 = the_world->Loc(ex-dx, ey-dy);

	if (LS2.Void() || LS2.IsDamage()) score += 12;
	if (LE2.Void() || LE2.IsDamage()) score += 12;

	return score;
}

void DigOneTunnel(xy_link_c *T)
{
	island_c *S = Islands[T->src_island()];
	island_c *D = Islands[T->dest_island()];

	PrintDebug("DIG TUNNEL: (%d,%d) -> (%d,%d) : island %d -> %d\n",
		T->src_x, T->src_y, T->dest_x, T->dest_y, S->index, D->index);

	int dx = T->dx();
	int dy = T->dy();

	// determine where the other plank will be (left, right, or none at all)
	int edge = 0;
	int edge_score = 0;
	{
		int left  = DigEdgeScore(T, -1, dx, dy);
		int right = DigEdgeScore(T, +1, dx, dy);

		edge_score = MAX(left, right);

		if (edge_score == 0 || edge_score <= 40 && RandomPerc(40))
		{
			edge = 0;
		}
		else if (left != right)
		{
			edge = (left > right) ? -1 : +1;
		}
		else
		{
			edge = RandomBool() ? -1 : +1;
		}

  		PrintDebug("## LEFT SCORE %3d, RIGHT SCORE %3d  -->  EDGE %+d\n",
  				left, right, edge);
	}

	SYS_ASSERT(T->Length() > 0);

	area_c *new_A = NULL;
	area_c *extend_A = NULL;

	// for small tunnels we should simply extend an existing area
	// rather than add a whole new area.  But a 2x2 tunnel between
	// land masses of different height could make a good lift...

	area_c *SA = T->src_A();
	area_c *DA = T->dest_A();

	char env_S = SA->Focal().env;
	char env_D = DA->Focal().env;

	if (T->Length() <= 4 && RandomPerc(100 - (T->Length()-1)*30))
	{
		if (env_S == ENV_Building && env_D == ENV_Building)
			extend_A = NULL;
		else if (env_S == ENV_Building)
			extend_A = DA;
		else if (env_D == ENV_Building)
			extend_A = SA;
		else if (env_S == env_D)
			extend_A = (SA->total < DA->total) ? SA : DA;
		else if (env_S == ENV_Water)
			extend_A = DA;
		else if (env_D == ENV_Water)
			extend_A = SA;
		else
			extend_A = (SA->total < DA->total) ? SA : DA;

		SA->NewNeighbour(DA->index, edge ? 2 : 1);
		DA->NewNeighbour(SA->index, edge ? 2 : 1);
	}

	char new_env = ENV_VOID;
	char new_mat = MAT_INVALID;

	if (extend_A)
	{
		new_env = extend_A->Focal().env;
		new_mat = extend_A->Focal().mat;

		PrintDebug("# Tunnel is extension of area %d (%s)\n", extend_A->index,
			area_build::NameForEnv(extend_A->Focal().env));
	}
	else
	{
		// figure out material, heights (etc) and create a new area

		//!!!! FIXME good environment & material & floor heights
		new_env = SA->Focal().Indoor() ? ENV_Cave : ENV_Land;
		new_mat = MAT_Sand;

		char floor_h = SA->Focal().floor_h;
		char ceil_h  = SA->Focal().ceil_h;

		if (new_env == ENV_Cave)
			ceil_h = floor_h+2;

		new_A = the_world->NewArea(the_world->NumAreas(),
					(T->src_x + T->dest_x) / 2,
					(T->src_y + T->dest_y) / 2);

		PrintDebug("NEW TUNNEL AREA %d : %s mat %d  hts %d..%d\n", new_A->index,
				area_build::NameForEnv(new_env), new_mat,
				new_A->floor_h, new_A->ceil_h);

		new_A->island = SA->island;

		new_A->floor_h = floor_h;
		new_A->ceil_h  = ceil_h;

		new_A->NewNeighbour(SA->index, edge ? 2 : 1);
		new_A->NewNeighbour(DA->index, edge ? 2 : 1);

		SA->NewNeighbour(new_A->index, edge ? 2 : 1);
		DA->NewNeighbour(new_A->index, edge ? 2 : 1);
	}

	SYS_ASSERT(new_env != ENV_VOID);
	SYS_ASSERT(new_env != MAT_INVALID);

	/* ------ dig baby ! ------ */

	for (int y = T->src_y; y <= T->dest_y; y++)
	for (int x = T->src_x; x <= T->dest_x; x++)
	for (int p = 0; p < (edge ? 2 : 1); p++)
	{
		int nx = x + (p ? dy * edge : 0);
		int ny = y + (p ? dx * edge : 0);

		if (the_world->Outside(nx, ny))
			break;

		location_c& loc = the_world->Loc(nx, ny);

		// ignore bits of the existing islands
		if (! (loc.Void() || loc.IsDamage()))
			continue;

		if (extend_A)
			extend_A->AddPoint(nx, ny);
		else
			new_A->AddPoint(nx, ny);

		loc.env = extend_A ? extend_A->Focal().env : new_env;
		loc.mat = extend_A ? extend_A->Focal().mat : new_mat;

		loc.floor_h = extend_A ? extend_A->floor_h : new_A->floor_h;
		loc.ceil_h  = extend_A ? extend_A->ceil_h  : new_A->ceil_h;
		loc.area = extend_A ? extend_A->index : new_A->index;

		loc.stru = STRU_Tunnel;
		loc.s_dir = dx ? (LOCDIR_N | LOCDIR_S) : (LOCDIR_E | LOCDIR_W);
	}
}

void DigTunnels()
{
	// dig all the tunnels first.
	// FIXME: then determine what island groups remain, and when
	//        selecting areas for teleporters, choose an area amongst
	//        the whole island group.

	for (int i = 0; i < (int)final_links.size(); i++)
	{
		xy_link_c *F = final_links[i];
		SYS_ASSERT(F);

		if (! F->IsTeleport())
			DigOneTunnel(F);
	}

	for (int i = 0; i < (int)final_links.size(); i++)
	{
		xy_link_c *F = final_links[i];

		if (F->IsTeleport())
		{
			// if the assignment fails, dig that tunnel!
			if (! AssignTeleport(F))
				DigOneTunnel(F);
		}
	}

	RehomeLavaAreas();
}


//------------------------------------------------------------------------
//  PUBLIC INTERFACE
//------------------------------------------------------------------------

void CreateIslands()
{
	int max_island;

#if 0
	FindSeparateAreas(false, &max_island);
	PurgeLavaOnly(max_island);
#endif

	if (FindSeparateAreas(true, &max_island) <= 1)
		return;

	Initial_Islands(max_island);
	CreateXYLinks();
	MakeLinkageGraph();

	ConnectIslands();
	SelectTeleporters();
	DigTunnels();
}

void Cleanup()
{
	int i;

	for (i = 0; i < (int)xy_links.size(); i++)
		delete xy_links[i];
	
	for (i = 0; i < (int)Islands.size(); i++)
		delete Islands[i];

	for (i = 0; i < (int)final_links.size(); i++)
		delete final_links[i];

	xy_links.resize(0);
	Islands.resize(0);
	final_links.resize(0);
}


} // namespace island_build

