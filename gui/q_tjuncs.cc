//------------------------------------------------------------------------
//  T-JUNCTION FIXING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C)      2010 Andrew Apted
//  Copyright (C) 1996-1997 Id Software, Inc.
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
//
//  This employs same method as in Quake's qbsp tool:
//
//    -  use hash table to track 'infinite lines' which edges sit on.
//    -  for each infinite line, collect all vertices, remove dups.
//    -  for each edge of each face, find its line and see if any
//       vertices would split the edge.
//
//------------------------------------------------------------------------

#include "headers.h"

#include <algorithm>

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"

#include "csg_main.h"
#include "csg_quake.h"


#define ALONG_EPSILON   0.01
#define NORMAL_EPSILON  0.001


class infinite_line_c
{
public:
	// the closest point to (0,0,0)
	float x, y, z;

	// normal vector
	float nx, ny, nz;

	std::vector<float> vertices;

public:
	infinite_line_c() : vertices()
	{ }

	~infinite_line_c()
	{ }

	void Set(const quake_vertex_c & A, const quake_vertex_c & B)
	{
		nx = B.x - A.x;
		ny = B.y - A.y;
		nz = B.z - A.z;

		double len = sqrt(nx*nx + ny*ny + nz*nz);

		if (len < 0.0001)
			Main_FatalError("Fix TJunc: face has zero length edge!\n");

		nx /= len;  ny /= len;  nz /= len;

		// determine point closest to (0,0,0), given by:
		//
		//    a + n * ((p - a) . n)
		// 
		// where p = (0,0,0) and '.' means dot-product 

		float t = A.x * nx + A.y * ny + A.z * nz;

		x = A.x - t * nx;
		y = A.y - t * ny;
		z = A.z - t * nz;
	}

	void Flip()
	{
		nx = -nx;  ny = -ny;  nz = -nz;
	}

	// make sure the normal faces a consistent direction
	void MakeConsistent()
	{
		if (nx >  NORMAL_EPSILON) return;
		if (nx < -NORMAL_EPSILON) { Flip(); return; }

		nx = 0;

		if (ny >  NORMAL_EPSILON) return;
		if (ny < -NORMAL_EPSILON) { Flip(); return; }

		ny = 0;

		if (nz >  NORMAL_EPSILON) return;
		if (nz < -NORMAL_EPSILON) { Flip(); return; }

		nz = 0;
	}

	int CalcHash() const
	{
		int hash;

		hash = IntHash(I_ROUND(x * 1.4));
		hash = IntHash(I_ROUND(y * 1.4) ^ hash);
		hash = IntHash(I_ROUND(z * 1.4) ^ hash);

		return hash;
	}

	bool Match(const infinite_line_c & other) const
	{
		if (fabs( x - other.x ) > NORMAL_EPSILON ||
				fabs( y - other.y ) > NORMAL_EPSILON ||
				fabs( z - other.z ) > NORMAL_EPSILON)
		{
			return false;
		}

		if (fabs(nx - other.nx) > NORMAL_EPSILON ||
				fabs(ny - other.ny) > NORMAL_EPSILON ||
				fabs(nz - other.nz) > NORMAL_EPSILON)
		{
			return false;
		}

		return true;
	}

	float CalcAlong(const quake_vertex_c & V) const
	{
		return (V.x - x) * nx + (V.y - y) * ny + (V.z - z) * nz;
	}

	void AddVert(const quake_vertex_c & V)
	{
		vertices.push_back(CalcAlong(V));
	}

	void GetCoord(quake_vertex_c & V, float along) const
	{
		V.x = x + nx * along;
		V.y = y + ny * along;
		V.z = z + nz * along;
	}

	void SortVerts()
	{
		if (vertices.empty())
			return;

		std::sort(vertices.begin(), vertices.end());

		// remove any duplicates

		unsigned int s = 1;
		unsigned int d = 1;
		unsigned int total = vertices.size();

		for ( ; s < total ; s++)
		{
			if (fabs(vertices[s] - vertices[s-1]) < ALONG_EPSILON)
				continue;

			vertices[d++] = vertices[s];
		}

		if (d < s)
			vertices.resize(d);
	}
};


#define INF_LINE_HASH_SIZE  1024

static std::vector<infinite_line_c> infinite_lines;

static std::vector<int> * inf_line_hashtab[INF_LINE_HASH_SIZE];

static int tjunc_count;


static void TJ_InitHash()
{
	infinite_lines.clear();

	memset(inf_line_hashtab, 0, sizeof(inf_line_hashtab));

	tjunc_count = 0;
}


static void TJ_FreeHash()
{
	infinite_lines.clear();

	for (unsigned int i = 0 ; i < INF_LINE_HASH_SIZE ; i++)
	{
		delete inf_line_hashtab[i];
		inf_line_hashtab[i] = NULL;
	}
}


static infinite_line_c * TJ_HashLookup(const quake_vertex_c & A,
                                       const quake_vertex_c & B)
{
	// this will create the infinite line when not already present

	infinite_line_c IL;

	IL.Set(A, B);
	IL.MakeConsistent();

	int hash = IL.CalcHash() & (INF_LINE_HASH_SIZE - 1);

	if (! inf_line_hashtab[hash])
		inf_line_hashtab[hash] = new std::vector<int>;

	std::vector<int> * hashtab = inf_line_hashtab[hash];


	for (unsigned int i = 0 ; i < hashtab->size() ; i++)
	{
		int index = (*hashtab)[i];

		infinite_line_c *test = &infinite_lines[index];

		if (test->Match(IL))
			return test;
	}

	// not found, make new one

/// fprintf(stderr, "INF HASH %04d: (%1.6f %1.6f %1.6f) + (%1.6f %1.6f %1.6f)\n",
///         hash,  IL.x, IL.y, IL.z,  IL.nx, IL.ny, IL.nz);

	int index = (int)infinite_lines.size();

	infinite_lines.push_back(IL);

	hashtab->push_back(index);

	return &infinite_lines.back();
}


static void TJ_AddEdge(const quake_vertex_c & A, const quake_vertex_c & B)
{
	infinite_line_c * IL = TJ_HashLookup(A, B);

	IL->AddVert(A);
	IL->AddVert(B);
}


static void TJ_AddFaces(quake_node_c *node)
{
	for (unsigned int i = 0 ; i < node->faces.size() ; i++)
	{
		quake_face_c *F = node->faces[i];

		unsigned int numverts = F->verts.size();

		for (unsigned int k = 0 ; k < numverts ; k++)
		{
			TJ_AddEdge(F->verts[k], F->verts[(k+1) % numverts]);
		}
	}

	if (node->front_N) TJ_AddFaces(node->front_N);
	if (node-> back_N) TJ_AddFaces(node-> back_N);
}


static void TJ_SortVertices()
{
	for (unsigned int i = 0 ; i < infinite_lines.size() ; i++)
	{
		infinite_lines[i].SortVerts();    
	}
}


static bool TJ_FixOneFace(quake_face_c *F)
{
	// returns true if the face is OK, or false if it was modified.
	// when it was modified we need to repeat the process again,
	// since we can only fix one edge at a time.

	bool changed = false;

	// iterate over a swapped-out version of the face's vertices
	std::vector<quake_vertex_c> local_verts;

	local_verts.swap(F->verts);

	unsigned int numverts = local_verts.size();

	for (unsigned int k = 0 ; k < numverts ; k++)
	{
		const quake_vertex_c & A = local_verts[k];
		const quake_vertex_c & B = local_verts[(k+1) % numverts];

		F->verts.push_back(A);

		infinite_line_c * IL = TJ_HashLookup(A, B);

		float along_A = IL->CalcAlong(A);
		float along_B = IL->CalcAlong(B);

		if (along_A > along_B)
		{
			std::swap(along_A, along_B);
		}

		for (unsigned int n = 0 ; n < IL->vertices.size() ; n++)
		{
			float along_N = IL->vertices[n];

			if (along_N < along_A + ALONG_EPSILON)
				continue;

			if (along_N > along_B - ALONG_EPSILON)
				break;

			// we have found a T-junction folks!
			tjunc_count++;

			quake_vertex_c new_vert;

			IL->GetCoord(new_vert, along_N);

			F->verts.push_back(new_vert);

			// stop now, as the next intersecting vertex may be in the
			// wrong order for the face's winding.
			changed = true;
			break;
		}
	}

	return !changed;  // OK if not changed
}


static void TJ_FixFaces(quake_node_c *node)
{
	for (unsigned int i = 0 ; i < node->faces.size() ; i++)
	{
		for (int loop = 0 ; loop < 16 ; loop++)
		{
			if (TJ_FixOneFace(node->faces[i]))
				break;
		}
	}

	if (node->front_N) TJ_FixFaces(node->front_N);
	if (node-> back_N) TJ_FixFaces(node-> back_N);
}


void QCOM_Fix_T_Junctions()
{
	TJ_InitHash();
	TJ_AddFaces(qk_bsp_root);
	TJ_SortVertices();
	TJ_FixFaces(qk_bsp_root);
	TJ_FreeHash();

	LogPrintf("Fixed %d T-Junctions\n", tjunc_count);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
