//------------------------------------------------------------------------
//  QUAKE LIGHT TRACING
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C)      2010 Andrew Apted
//  Copyright (C) 2005-2006 Peter Brett
//  Copyright (C) 1994-2001 iD Software
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
//  Based on code from Quake II lighting tool : q2rad/trace.c
//
//------------------------------------------------------------------------

#include "headers.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"

#include "csg_main.h"
#include "csg_quake.h"


#define T_EPSILON  0.1


#define TRACE_SOLID  -1
#define TRACE_EMPTY  -2

typedef struct
{
  int type;      // PLANE_X .. PLANE_Z
  float normal[3];
  float dist;

  int children[2];  // tnode index, or TRACE_XXX value
}
tnode_t;


static tnode_t *trace_nodes;


static int ConvertTraceNode(quake_node_c *node, int & index_var)
{
  int this_idx = index_var;

  tnode_t *TN = &trace_nodes[index_var];

  index_var += 1;


  TN->normal[0] = node->plane.nx;
  TN->normal[1] = node->plane.ny;
  TN->normal[2] = node->plane.nz;

  TN->dist = node->plane.CalcDist();

  float fx = fabs(TN->normal[0]);
  float fy = fabs(TN->normal[1]);
  float fz = fabs(TN->normal[2]);

  if (fx > fy && fx > fz)
    TN->type = PLANE_X;
  else if (fy > fx && fy > fz)
    TN->type = PLANE_Y;
  else
    TN->type = PLANE_Z;


  if (node->front_N)
    TN->children[0] = ConvertTraceNode(node->front_N, index_var);
  else
    TN->children[0] = (node->front_L->medium == MEDIUM_SOLID) ? TRACE_SOLID : TRACE_EMPTY;
  
  if (node->back_N)
    TN->children[1] = ConvertTraceNode(node->back_N, index_var);
  else
    TN->children[1] = (node->back_L->medium == MEDIUM_SOLID) ? TRACE_SOLID : TRACE_EMPTY;


  return this_idx;
}


void QCOM_MakeTraceNodes()
{
  int total = qk_bsp_root->CountNodes();

  trace_nodes = new tnode_t[total];

  int cur_node = 0;

  ConvertTraceNode(qk_bsp_root, cur_node);
}


void QCOM_FreeTraceNodes()
{
  if (trace_nodes)
  {
    delete[] trace_nodes;
    trace_nodes = NULL;
  }
}


bool QCOM_TraceRay(float x1, float y1, float z1,
                   float x2, float y2, float z2)
{
  // TODO
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
