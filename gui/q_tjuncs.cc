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
//    -  for each infinite line, collect all vertices, then sort them.
//    -  for each edge of each face, find it's line and see if any
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


class infinite_line_c
{
public:
  // origin
  float x, y, z;

  // normal vector
  float nx, ny, nz;

  std::vector<float> vertices;

public:
  infinite_line_c() : vertices()
  { }

  ~infinite_line_c()
  { }

  void AddVert(const quake_vertex_c & V)
  {
    // FIXME
  }

  void SortVerts()
  {
    // FIXME
  }
};


#define INF_LINE_HASH_SIZE  1024

static std::vector<infinite_line_c> infinite_lines;

static std::vector<int> * inf_line_hashtab[INF_LINE_HASH_SIZE];


static void TJ_InitHash()
{
  infinite_lines.clear();

  memset(inf_line_hashtab, 0, sizeof(inf_line_hashtab));
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

  int hash = 123;  // FIXME

  SYS_ASSERT(hash >= 0 && hash < INF_LINE_HASH_SIZE);

  if (! inf_line_hashtab[hash])
    inf_line_hashtab[hash] = new std::vector<int>;

  std::vector<int> * hashtab = inf_line_hashtab[hash];


  for (unsigned int i = 0 ; i < hashtab->size() ; i++)
  {
    int index = (*hashtab)[i];

    infinite_line_c *test = &infinite_lines[index];

    if (MATCHES)  // FIXME
      return test;
  }

  // not found, make new one

  int index = (int)infinite_lines.size();

  // yada yada

  infinite_lines.push_back(infinite_line_c());  // !!!!

  hashtab->push_back(index);

  return &infinite_lines.back();
}


static void TJ_AddEdge(const quake_vertex_c & A, const quake_vertex_c & B)
{
  infinite_line_c * L = TJ_HashLookup(A, B);

  L->AddVert(A);
  L->AddVert(B);
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
  // FIXME
}


static void TJ_FixOneFace(quake_face_c *F)
{
  // FIXME fix the fixer...
}


static void TJ_FixFaces(quake_node_c *node)
{
  for (unsigned int i = 0 ; i < node->faces.size() ; i++)
  {
    TJ_FixOneFace(node->faces[i]);
  }

  if (node->front_N) TJ_AddFaces(node->front_N);
  if (node-> back_N) TJ_AddFaces(node-> back_N);
}


void QCOM_Fix_T_Junctions()
{
  TJ_InitHash();

  TJ_AddFaces(qk_bsp_root);

  TJ_SortVertices();

  TJ_FixFaces(qk_bsp_root);

  TJ_FreeHash();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
