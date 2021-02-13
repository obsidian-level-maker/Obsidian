//------------------------------------------------------------------------
//
//  AJ-Polygonator (C) 2000-2013 Andrew Apted
//
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include "pl_local.h"


#define DEBUG_LOAD  0


namespace ajpoly
{

// per-level variables

sector_c * void_sector;

std::vector<  vertex_c *> all_vertices;
std::vector< linedef_c *> all_linedefs;
std::vector< sidedef_c *> all_sidedefs;
std::vector<  sector_c *> all_sectors;
std::vector<   thing_c *> all_things;

std::vector<  vertex_c *> all_splits;
std::vector<    edge_c *> all_edges;
std::vector< polygon_c *> all_polygons;
std::vector<wall_tip_c *> all_wall_tips;
std::vector< linedef_c *> all_ex_floors;

int num_vertices;
int num_linedefs;
int num_sidedefs;
int num_sectors;
int num_things;

int num_splits;
int num_edges;
int num_polygons;
int num_wall_tips;


// EDGE line specials for 3D floors
#define  SOLID_EXTRA_FLOOR  400
#define LIQUID_EXTRA_FLOOR  405


/* ------- access functions --------- */

vertex_c * Vertex(int index)
{
	if (index < 0 || index >= num_vertices)
		Appl_FatalError("No such vertex: #%d\n", index);

	return all_vertices[index];
}

linedef_c * Linedef(int index)
{
	if (index < 0 || index >= num_linedefs)
		Appl_FatalError("No such linedef: #%d\n", index);

	return all_linedefs[index];
}

sidedef_c * Sidedef(int index)
{
	if (index < 0 || index >= num_sidedefs)
		Appl_FatalError("No such sidedef: #%d\n", index);

	return all_sidedefs[index];
}

sector_c * Sector(int index)
{
	if (index < 0 || index >= num_sectors)
		Appl_FatalError("No such sector: #%d\n", index);

	return all_sectors[index];
}

thing_c * Thing(int index)
{
	if (index < 0 || index >= num_things)
		Appl_FatalError("No such thing: #%d\n", index);

	return all_things[index];
}

edge_c * Edge(int index)
{
	if (index < 0 || index >= num_edges)
		Appl_FatalError("No such edge: #%d\n", index);

	return all_edges[index];
}

polygon_c * Polygon(int index)
{
	if (index < 0 || index >= num_polygons)
		Appl_FatalError("No such polygon: #%d\n", index);

	return all_polygons[index];
}

inline sidedef_c * SafeSidedef(u16_t num)
{
	if (num == 0xFFFF)
		return NULL;

	if ((int)num >= num_sidedefs && (s16_t)(num) < 0)
		return NULL;

	return Sidedef(num);
}


linedef_c * sector_c::getExtraFloor(int index)
{
	if (index < 0 || index >= num_floors)
		return NULL;
	
	return all_ex_floors[floor_start + index];
}


/* ------- creation functions --------- */

vertex_c * NewVertex()
{
	vertex_c *p = new vertex_c;
	p->index = (int)all_vertices.size();
	all_vertices.push_back(p);
	num_vertices++;
	return p;
}

linedef_c * NewLinedef()
{
	linedef_c *p = new linedef_c;
	p->index = (int)all_linedefs.size();
	all_linedefs.push_back(p);
	num_linedefs++;
	return p;
}

sidedef_c * NewSidedef()
{
	sidedef_c *p = new sidedef_c;
	p->index = (int)all_sidedefs.size();
	all_sidedefs.push_back(p);
	num_sidedefs++;
	return p;
}

sector_c * NewSector()
{
	sector_c *p = new sector_c;
	p->index = (int)all_sectors.size();
	all_sectors.push_back(p);
	num_sectors++;
	return p;
}

thing_c * NewThing()
{
	thing_c *p = new thing_c;
	p->index = (int)all_things.size();
	all_things.push_back(p);
	num_things++;
	return p;
}

vertex_c * NewSplit()
{
	vertex_c *p = new vertex_c;
	p->index = SPLIT_VERTEX + (int)all_splits.size();
	all_splits.push_back(p);
	num_splits++;
	return p;
}

edge_c * NewEdge()
{
	edge_c *p = new edge_c;
	p->index = (int)all_edges.size();
	all_edges.push_back(p);
	num_edges++;
	return p;
}

polygon_c * NewPolygon()
{
	polygon_c *p = new polygon_c;
	p->index = (int)all_polygons.size();
	all_polygons.push_back(p);
	num_polygons++;
	return p;
}

wall_tip_c * NewWallTip()
{
	wall_tip_c *p = new wall_tip_c;
	all_wall_tips.push_back(p);
	num_wall_tips++;
	return p;
}


/* ----- loading functions ------------------------------ */


int load_level;


bool LoadVertices()
{
	int length;

	byte * data = the_wad->ReadLump("VERTEXES", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load VERTEXES lump");
		return false;
	}

	int count = length / sizeof(raw_vertex_t);

#if DEBUG_LOAD
	Appl_Printf("LoadVertices: num = %d\n", count);
#endif

	raw_vertex_t *raw = (raw_vertex_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		vertex_c *vert = NewVertex();

		vert->x = (double) LE_S16(raw->x);
		vert->y = (double) LE_S16(raw->y);
	}

	return true;  // OK
}


bool LoadSectors()
{
	int length;

	byte * data = the_wad->ReadLump("SECTORS", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load SECTORS lump");
		return false;
	}

	int count = length / sizeof(raw_sector_t);

#if DEBUG_LOAD
	Appl_Printf("LoadSectors: num = %d\n", count);
#endif

	raw_sector_t *raw = (raw_sector_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		sector_c *sector = NewSector();

		sector->floor_h = LE_S16(raw->floor_h);
		sector->ceil_h  = LE_S16(raw->ceil_h);

		memset(sector->floor_tex, 0, sizeof(sector->floor_tex));
		memset(sector-> ceil_tex, 0, sizeof(sector-> ceil_tex));

		memcpy(sector->floor_tex, raw->floor_tex, 8);
		memcpy(sector-> ceil_tex, raw-> ceil_tex, 8);

		sector->light   = LE_U16(raw->light);
		sector->special = LE_U16(raw->special);
		sector->tag     = LE_S16(raw->tag);
	}

	// create a fake sector to represent VOID space
	void_sector = NewSector();

	void_sector->index = VOID_SECTOR_IDX;

	return true;  // OK
}


bool LoadThings()
{
	int length;

	byte * data = the_wad->ReadLump("THINGS", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load THINGS lump");
		return false;
	}

	int count = length / sizeof(raw_thing_t);

#if DEBUG_LOAD
	Appl_Printf("LoadThings: num = %d\n", count);
#endif

	raw_thing_t *raw = (raw_thing_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		thing_c *thing = NewThing();

		thing->x = LE_S16(raw->x);
		thing->y = LE_S16(raw->y);

		thing->type    = LE_U16(raw->type);
		thing->options = LE_U16(raw->options);
		thing->angle   = LE_S16(raw->angle);
	}

	return true;  // OK
}


bool LoadThingsHexen()
{
	int length;

	byte * data = the_wad->ReadLump("THINGS", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load THINGS lump");
		return false;
	}

	int count = length / sizeof(raw_hexen_thing_t);

#if DEBUG_LOAD
	Appl_Printf("LoadThingsHexen: num = %d\n", count);
#endif

	raw_hexen_thing_t *raw = (raw_hexen_thing_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		thing_c *thing = NewThing();

		thing->x = LE_S16(raw->x);
		thing->y = LE_S16(raw->y);

		thing->type    = LE_U16(raw->type);
		thing->options = LE_U16(raw->options);
		thing->angle   = LE_S16(raw->angle);

		// FIXME: hexen stuff (args)
	}

	return true;  // OK
}


bool LoadSidedefs()
{
	int length;

	byte * data = the_wad->ReadLump("SIDEDEFS", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load SIDEDEFS lump");
		return false;
	}

	int count = length / sizeof(raw_sidedef_t);

#if DEBUG_LOAD
	Appl_Printf("LoadSidedefs: num = %d\n", count);
#endif

	raw_sidedef_t *raw = (raw_sidedef_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		sidedef_c *side = NewSidedef();

		if (LE_S16(raw->sector) == -1)
		{
			SetErrorMsg("Bad sector ref in sidedef #%d", i);
			return false;
		}

		side->sector = Sector(LE_U16(raw->sector));

		side->x_offset = LE_S16(raw->x_offset);
		side->y_offset = LE_S16(raw->y_offset);

		memset(side->upper_tex, 0, sizeof(side->upper_tex));
		memset(side->lower_tex, 0, sizeof(side->lower_tex));
		memset(side->mid_tex,   0, sizeof(side->mid_tex));

		memcpy(side->upper_tex, raw->upper_tex, 8);
		memcpy(side->lower_tex, raw->lower_tex, 8);
		memcpy(side->mid_tex,   raw->mid_tex,   8);
	}

	return true;  // OK
}


bool LoadLinedefs()
{
	int length;

	byte * data = the_wad->ReadLump("LINEDEFS", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load LINEDEFS lump");
		return false;
	}

	int count = length / sizeof(raw_linedef_t);

#if DEBUG_LOAD
	Appl_Printf("LoadLinedefs: num = %d\n", count);
#endif

	raw_linedef_t *raw = (raw_linedef_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		linedef_c *line = NewLinedef();

		vertex_c *start = Vertex(LE_U16(raw->start));
		vertex_c *end   = Vertex(LE_U16(raw->end));

		line->start = start;
		line->end   = end;

		start->ref_count++;
		  end->ref_count++;

		/* check for zero-length line */
		if ((fabs(start->x - end->x) < DIST_EPSILON) && 
			(fabs(start->y - end->y) < DIST_EPSILON) )
		{
			Appl_FatalError("Linedef #%d has zero length.\n", i);
		}

		line->flags   = LE_U16(raw->flags);
		line->special = LE_U16(raw->type);
		line->tag     = LE_S16(raw->tag);

		line->right = SafeSidedef(LE_U16(raw->sidedef1));
		line->left  = SafeSidedef(LE_U16(raw->sidedef2));
	}

	return true;  // OK
}


bool LoadLinedefsHexen()
{
	int length;

	byte * data = the_wad->ReadLump("LINEDEFS", &length, load_level);

	if (! data)
	{
		SetErrorMsg("Failed to load LINEDEFS lump");
		return false;
	}

	int count = length / sizeof(raw_hexen_linedef_t);

#if DEBUG_LOAD
	Appl_Printf("LoadLinedefsHexen: num = %d\n", count);
#endif

	raw_hexen_linedef_t *raw = (raw_hexen_linedef_t *) data;

	for (int i = 0 ; i < count ; i++, raw++)
	{
		linedef_c *line = NewLinedef();

		vertex_c *start = Vertex(LE_U16(raw->start));
		vertex_c *end   = Vertex(LE_U16(raw->end));

		line->start = start;
		line->end   = end;

		start->ref_count++;
		  end->ref_count++;

		/* check for zero-length line */
		if ((fabs(start->x - end->x) < DIST_EPSILON) && 
			(fabs(start->y - end->y) < DIST_EPSILON) )
		{
			Appl_FatalError("Linedef #%d has zero length.\n", i);
		}

		line->flags   = LE_U16(raw->flags);
		line->special = raw->type;
		line->tag     = 0;

		line->right = SafeSidedef(LE_U16(raw->sidedef1));
		line->left  = SafeSidedef(LE_U16(raw->sidedef2));

		for (int k = 0 ; k < 5 ; k++)
			line->args[k] = raw->specials[k];
	}

	return true;  // OK
}


//------------------------------------------------------------------------
//   ANALYZE
//------------------------------------------------------------------------


int limit_x1, limit_y1;
int limit_x2, limit_y2;


void DetermineMapLimits()
{
	int i;

	limit_x1 = +999999;
	limit_y1 = +999999;
	limit_x2 = -999999;
	limit_y2 = -999999;

	for (i = 0 ; i < num_linedefs ; i++)
	{
		linedef_c *L = Linedef(i);

		// ignore dummy sectors
		if (L->right && L->right->sector &&
			L->right->sector->is_dummy)
			continue;

		int x1 = (int)L->start->x;
		int y1 = (int)L->start->y;
		int x2 = (int)L->end->x;
		int y2 = (int)L->end->y;

		limit_x1 = MIN(limit_x1, MIN(x1, x2));
		limit_y1 = MIN(limit_y1, MIN(y1, y2));

		limit_x2 = MAX(limit_x2, MAX(x1, x2));
		limit_y2 = MAX(limit_y2, MAX(y1, y2));
	}

	Appl_Printf("Map goes from (%d,%d) to (%d,%d)\n",
				limit_x1, limit_y1, limit_x2, limit_y2);
}


void CheckSectorIsDummy(sector_c *sec)
{
	if (sec->index < 0 || sec->index == VOID_SECTOR_IDX)
		return;

	int line_count = 0;

	int bound_x1 = +999999;
	int bound_y1 = +999999;
	int bound_x2 = -999999;
	int bound_y2 = -999999;

	for (int k = 0 ; k < num_linedefs ; k++)
	{
		linedef_c *line = all_linedefs[k];

		// sector exists on back of a line?  disqualify...
		if (line->left && line->left->sector == sec)
			return;

		if (! line->right)
			continue;

		if (line->right->sector != sec)
			continue;

		// disqualify if sector contains a two-sided line
		if (line->left)
			return;

		line_count++;

		for (int pass = 0 ; pass < 2 ; pass++)
		{
			int x = pass ? line->end->x : line->start->x;
			int y = pass ? line->end->y : line->start->y;

			bound_x1 = MIN(bound_x1, x);
			bound_y1 = MIN(bound_y1, y);

			bound_x2 = MAX(bound_x2, x);
			bound_y2 = MAX(bound_y2, y);
		}
	}

	if (line_count < 3 || line_count > 4)
		return;

	if (bound_x2 - bound_x1 > 32) return;
	if (bound_y2 - bound_y1 > 32) return;

	// OK found one

	sec->is_dummy = 1;
}


void FindDummySectors()
{
	// Requirements for a dummy sector:
	//   1. total size <= 32 on each axis
	//   2. total # of lines <= 4
	//   3. does not touch any other sector
	//
	// Perform step 3 first to quickly rule out most candidates.
	//
	
	int i;

	if (num_sectors <= 1)
		return;

	byte *joined_secs = new byte[num_sectors];

	memset(joined_secs, 0, num_sectors);

	for (i = 0 ; i < num_linedefs ; i++)
	{
		linedef_c *line = all_linedefs[i];

		if (! (line->left && line->right))
			continue;

		// this line straddles two sectors
		// (or possible a single one -- that too rules it out)

		for (int pass = 0 ; pass < 2 ; pass++)
		{
			sector_c *sec = pass ? line->right->sector : line->left->sector;

			if (! sec || sec->index < 0 || sec->index == VOID_SECTOR_IDX)
				continue;

			joined_secs[sec->index] = 1;
		}
	}

	for (i = 0 ; i < num_sectors ; i++)
		if (! joined_secs[i])
			CheckSectorIsDummy(all_sectors[i]);

	delete[] joined_secs;
}


int CollectFloorsAtSector(sector_c *sec, bool count_only)
{
	int total = 0;

	for (int i = 0 ; i < num_linedefs ; i++)
	{
		linedef_c *line = all_linedefs[i];

		// line must be in a dummy sector
		if (! (line->right && line->right->sector &&
			   line->right->sector->is_dummy))
			continue;

		// special must be an extrafloor
		if (! (line->special == SOLID_EXTRA_FLOOR ||
			   line->special == LIQUID_EXTRA_FLOOR))
			continue;

		// tag must match this sector
		if (line->tag != sec->tag)
			continue;

		total++;

		if (! count_only)
			all_ex_floors.push_back(line);
	}

	return total;
}


void ProcessExtraFloors()
{
	for (int k = 0 ; k < num_sectors ; k++)
	{
		sector_c *sec = all_sectors[k];

		if (sec->index < 0 || sec->index == VOID_SECTOR_IDX)
			continue;

		if (sec->tag <= 0)
			continue;

		// skip dummy sectors too
		if (sec->is_dummy)
			continue;

		int total = CollectFloorsAtSector(sec, true /* count_only */);

		if (total == 0)
			continue;

		sec->num_floors  = total;
		sec->floor_start = (int) all_ex_floors.size();

		CollectFloorsAtSector(sec, false);

		// terminate the list with a NULL pointer
		all_ex_floors.push_back(NULL);
	}
}


int VertexCompare(const void *p1, const void *p2)
{
	int vert1 = ((const int *) p1)[0];
	int vert2 = ((const int *) p2)[0];

	vertex_c *A = all_vertices[vert1];
	vertex_c *B = all_vertices[vert2];

	if (vert1 == vert2)
		return 0;

	if ((int)A->x != (int)B->x)
		return (int)A->x - (int)B->x; 

	return (int)A->y - (int)B->y;
}


bool DetectDuplicateVertices()
{
	int i;
	int *array = new int[num_vertices + 1];

	// sort array of indices
	// FIXME: exclude unused vertices
	for (i = 0 ; i < num_vertices ; i++)
		array[i] = i;

	qsort(array, num_vertices, sizeof(int), VertexCompare);

	// now mark them off
	for (i = 0 ; i < num_vertices - 1 ; i++)
	{
		if (VertexCompare(array + i, array + i+1) != 0)
			continue;

		// found a duplicate !

		{
			vertex_c *A = all_vertices[array[i]];
			vertex_c *B = all_vertices[array[i+1]];

			// we only care if the vertices both belong to a linedef
			if (A->ref_count == 0 || B->ref_count == 0)
				continue;

			SetErrorMsg("Vertices #%d and #%d overlap", array[i], array[i+1]);
			return false;
		}
	}

	delete[] array;

	return true;
}


inline bool LineVertexLowest(const linedef_c *L)
{
	// returns the "lowest" vertex (normally the left-most, but if the
	// line is vertical, then the bottom-most) => 0 for start, 1 for end.

	return ((int)L->start->x < (int)L->end->x ||
			((int)L->start->x == (int)L->end->x && 
			 (int)L->start->y <  (int)L->end->y));
}

int LineStartCompare(const void *p1, const void *p2)
{
	int line1 = ((const int *) p1)[0];
	int line2 = ((const int *) p2)[0];

	linedef_c *A = all_linedefs[line1];
	linedef_c *B = all_linedefs[line2];

	vertex_c *C;
	vertex_c *D;

	if (line1 == line2)
		return 0;

	// determine left-most vertex of each line
	C = LineVertexLowest(A) ? A->end : A->start;
	D = LineVertexLowest(B) ? B->end : B->start;

	if ((int)C->x != (int)D->x)
		return (int)C->x - (int)D->x; 
	else
		return (int)C->y - (int)D->y;
}

int LineEndCompare(const void *p1, const void *p2)
{
	int line1 = ((const int *) p1)[0];
	int line2 = ((const int *) p2)[0];

	linedef_c *A = all_linedefs[line1];
	linedef_c *B = all_linedefs[line2];

	vertex_c *C;
	vertex_c *D;

	if (line1 == line2)
		return 0;

	// determine right-most vertex of each line
	C = LineVertexLowest(A) ? A->start : A->end;
	D = LineVertexLowest(B) ? B->start : B->end;

	if ((int)C->x != (int)D->x)
		return (int)C->x - (int)D->x; 
	else
		return (int)C->y - (int)D->y;
}


bool DetectOverlappingLines()
{
	// Algorithm:
	//   Sort all lines by left-most vertex.
	//   Overlapping lines will then be near each other in this set.
	//   Note: does not detect partially overlapping lines.

	int i;

	int *array = new int[num_linedefs + 1];

	// sort array of indices
	for (i = 0 ; i < num_linedefs ; i++)
		array[i] = i;

	qsort(array, num_linedefs, sizeof(int), LineStartCompare);

	for (i = 0 ; i < num_linedefs - 1 ; i++)
	{
		int k;

		for (k = i+1 ; k < num_linedefs ; k++)
		{
			if (LineStartCompare(array + i, array + k) != 0)
				break;

			if (LineEndCompare(array + i, array + k) == 0)
			{
				// found an overlap !
				SetErrorMsg("Linedefs #%d and #%d overlap", array[i], array[k]);
				return false;
			}
		}
	}

	delete[] array;

	return true;  // OK
}


/* ----- wall tip functions ------------------------------- */


void vertex_c::AddTip(double dx, double dy, sector_c *left, sector_c *right)
{
	wall_tip_c *tip = NewWallTip();

	tip->angle = ComputeAngle(dx, dy);
	tip->left  = left;
	tip->right = right;

	// find the correct place (order is increasing angle)
	wall_tip_c *after;

	for (after = tip_set ; after && after->next ; after = after->next)
	{ }

	while (after && tip->angle + ANG_EPSILON < after->angle) 
		after = after->prev;

	// link it in
	tip->next = after ? after->next : tip_set;
	tip->prev = after;

	if (after)
	{
		if (after->next)
			after->next->prev = tip;

		after->next = tip;
	}
	else
	{
		if (tip_set)
			tip_set->prev = tip;

		tip_set = tip;
	}
}


bool ValidateWallTip(const vertex_c *vert)
{
	const wall_tip_c *tip;
	const sector_c *first_right;

	if (! vert->tip_set)
		Appl_FatalError("INTERNAL ERROR: vertex #%d got no wall tips\n", vert->index);

	if (! vert->tip_set->next)
		Appl_FatalError("INTERNAL ERROR: vertex #%d only has one linedef\n", vert->index);

	first_right = vert->tip_set->right;

	for (tip = vert->tip_set ; tip ; tip = tip->next)
	{
		if (tip->next)
		{
			if (tip->left != tip->next->right)
			{
				Appl_FatalError("Sector #%d not closed at vertex #%d\n",
						tip->left ? tip->left->index :
						tip->right ? tip->right->index : -1,
						vert->index);
			}
		}
		else
		{
			if (tip->left != first_right)
			{
				Appl_FatalError("Sector #%d not closed at vertex #%d\n",
						tip->left ? tip->left->index :
						tip->right ? tip->right->index : -1,
						vert->index);
			}
		}
	}

	return true;  // OK
}


bool CalculateWallTips()
{
	int i;

	// create the wall tips

	for (i = 0 ; i < num_linedefs ; i++)
	{
		linedef_c *line = all_linedefs[i];

		double x1 = line->start->x;
		double y1 = line->start->y;
		double x2 = line->end->x;
		double y2 = line->end->y;

		sector_c *right = (line->right) ? line->right->sector : void_sector;
		sector_c *left  = (line->left)  ? line->left->sector  : (line->is_border ? NULL : void_sector);

		line->start->AddTip(x2 - x1, y2 - y1, left, right);
		line->end->  AddTip(x1 - x2, y1 - y2, right, left);
	}

	// now check them

	for (i = 0 ; i < num_linedefs ; i++)
	{
		const linedef_c *line = all_linedefs[i];

		if (! ValidateWallTip(line->start)) return false;
		if (! ValidateWallTip(line->end))   return false;
	}

#if DEBUG_LOAD
	for (i = 0 ; i < num_vertices ; i++)
	{
		vertex_c *vert = Vertex(i);
		wall_tip_c *tip;

		Appl_Printf("WallTips for vertex #%d :\n", i);

		for (tip = vert->tip_set ; tip ; tip = tip->next)
		{
			Appl_Printf("  angle=%1.1f left=%d right=%d\n", tip->angle,
						tip->left ? tip->left->index : -1,
						tip->right ? tip->right->index : -1);
		}
	}
#endif

	return true;  // OK
}


vertex_c * NewVertexFromSplit(edge_c *E, double x, double y)
{
	vertex_c *vert = NewSplit();

	vert->x = x;
	vert->y = y;

	// compute wall_tip info

	vert->AddTip(-E->pdx, -E->pdy, E->sector, 
			E->partner ? E->partner->sector : NULL);

	vert->AddTip(E->pdx, E->pdy,
			E->partner ? E->partner->sector : NULL, E->sector);

	// create a duplex vertex if needed

	return vert;
}


sector_c * vertex_c::CheckOpen(double dx, double dy) const
{
	wall_tip_c *tip;

	double angle = ComputeAngle(dx, dy);

	for (tip = tip_set ; tip ; tip = tip->next)
	{
		if (fabs(tip->angle - angle) < ANG_EPSILON ||
			fabs(tip->angle - angle) > (360.0 - ANG_EPSILON))
		{
			// hit a line -- hence not open
			return NULL;
		}
	}

	// OK, now just find the first wall_tip whose angle is greater than
	// the angle we're interested in.  Therefore we'll be on the RIGHT
	// side of that wall_tip.

	for (tip = tip_set ; tip ; tip = tip->next)
	{
		if (angle + ANG_EPSILON < tip->angle)
		{
			// found it
			return tip->right;
		}

		if (! tip->next)
		{
			// no more tips, thus we must be on the LEFT side of the tip
			// with the largest angle.

			return tip->left;
		}
	}

	/* cannot get here (in theory) */

	Appl_FatalError("INTERNAL ERROR: Bad wall tips at vertex #%d\n", index);
	return NULL;
}


bool VerifyOuterLines()
{
	int seen = 0;

	for (int i = 0 ; i < num_linedefs ; i++)
	{
		linedef_c *L = Linedef(i);

		int x1 = (int)L->start->x;
		int y1 = (int)L->start->y;
		int x2 = (int)L->end->x;
		int y2 = (int)L->end->y;

		if (L->left && L->right)
			continue;

		// ignore lines of dummy sectors
		if (L->right && L->right->sector &&
			L->right->sector->is_dummy)
			continue;

		if (x1 == limit_x1 && x2 == limit_x2 && y1 == limit_y2 && y2 == y1)
		{
			seen |= 0x0008; L->is_border = 1;
		}

		if (x1 == limit_x2 && x2 == limit_x1 && y1 == limit_y1 && y2 == y1)
		{
			seen |= 0x2000; L->is_border = 1;
		}

		if (x1 == limit_x1 && x2 == x1 && y1 == limit_y1 && y2 == limit_y2)
		{
			seen |= 0x0400; L->is_border = 1;
		}

		if (x1 == limit_x2 && x2 == x1 && y1 == limit_y2 && y2 == limit_y1)
		{
			seen |= 0x0060; L->is_border = 1;
		}
	}

	return (seen == 0x2468);
}


//------------------------------------------------------------------------
//   API FUNCTIONS
//------------------------------------------------------------------------


bool OpenMap(const char *level_name)
{
	if (! the_wad)
	{
		SetErrorMsg("No open wad file");
		return false;
	}

	CloseMap();

	load_level = the_wad->FindLevel(level_name);

	if (load_level < 0)
	{
		if (level_name[0] == '*')
			SetErrorMsg("No levels found in the wad");
		else
			SetErrorMsg("Level '%s' not found in the wad", level_name);

		return false;
	}

	// identify hexen mode by presence of BEHAVIOR lump
	bool doing_hexen = false;

	if (the_wad->ReadLump("BEHAVIOR", NULL, load_level))
		doing_hexen = true;

	if (! LoadVertices()) return false;
	if (! LoadSectors())  return false;
	if (! LoadSidedefs()) return false;

	if (doing_hexen)
	{
		if (! LoadLinedefsHexen()) return false;
		if (! LoadThingsHexen())   return false;
	}
	else
	{
		if (! LoadLinedefs()) return false;
		if (! LoadThings())   return false;
	}

	Appl_Printf("Loaded %d vertices, %d sectors, %d sides, %d lines, %d things\n", 
				num_vertices, num_sectors, num_sidedefs, num_linedefs, num_things);

	FindDummySectors();

	DetermineMapLimits();

	if (! DetectOverlappingLines())  return false;
	if (! DetectDuplicateVertices()) return false;

	if (! CalculateWallTips()) return false;

	ProcessExtraFloors();

	return true;  // OK
}


void CloseMap()
{
	all_vertices.clear();
	all_linedefs.clear();
	all_sidedefs.clear();
	all_sectors.clear();
	all_things.clear();

	all_splits.clear();
	all_edges.clear();
	all_polygons.clear();
	all_wall_tips.clear();
	all_ex_floors.clear();

	num_vertices = 0;
	num_linedefs = 0;
	num_sidedefs = 0;
	num_sectors  = 0;
	num_things   = 0;

	num_splits    = 0;
	num_edges     = 0;
	num_polygons  = 0;
	num_wall_tips = 0;
}


}  // namespace ajpoly

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
