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

#define PLANE_OTHER  -1

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


  float nx = node->plane.nx;
  float ny = node->plane.ny;
  float nz = node->plane.nz;

  float fx = fabs(nx);
  float fy = fabs(ny);
  float fz = fabs(nz);


  TN->normal[0] = nx;
  TN->normal[1] = ny;
  TN->normal[2] = nz;

  TN->dist = node->plane.CalcDist();


  int side = 0;

  // ensure tnode planes are positive
  if ( (-nx >= MAX(fy, fz)) ||
       (-ny >= MAX(fx, fz)) ||
       (-nz >= MAX(fx, fy)) )
  {
    side = 1;

    TN->normal[0] = -nx;
    TN->normal[1] = -ny;
    TN->normal[2] = -nz;

    TN->dist = -TN->dist;
  }


  if (fx > 0.9999)
    TN->type = PLANE_X;
  else if (fy > 0.9999)
    TN->type = PLANE_Y;
  else if (fz > 0.9999)
    TN->type = PLANE_Z;
  else
    TN->type = PLANE_OTHER;


  if (node->front_N)
    TN->children[side] = ConvertTraceNode(node->front_N, index_var);
  else
    TN->children[side] = (node->front_L->medium == MEDIUM_SOLID) ? TRACE_SOLID : TRACE_EMPTY;

  side ^= 1;

  if (node->back_N)
    TN->children[side] = ConvertTraceNode(node->back_N, index_var);
  else
    TN->children[side] = (node->back_L->medium == MEDIUM_SOLID) ? TRACE_SOLID : TRACE_EMPTY;


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


static bool RecursiveTestRay(int nodenum,
                             float x1, float y1, float z1,
                             float x2, float y2, float z2)
{
  for (;;)
  {
    if (nodenum < 0)
    {
      return (nodenum == TRACE_EMPTY);  // ray passed
    }

    tnode_t *TN = &trace_nodes[nodenum];

    float dist1;
    float dist2;

    switch (TN->type)
    {
      case PLANE_X:
        dist1 = x1;
        dist2 = x2;
        break;

      case PLANE_Y:
        dist1 = y1;
        dist2 = y2;
        break;

      case PLANE_Z:
        dist1 = z1;
        dist2 = z2;
        break;

      default:
        dist1 = x1 * TN->normal[0] + y1 * TN->normal[1] + z1 * TN->normal[2];
        dist2 = x2 * TN->normal[0] + y2 * TN->normal[1] + z2 * TN->normal[2];
        break;
    }

    dist1 -= TN->dist;
    dist2 -= TN->dist;

    if (dist1 >= -T_EPSILON && dist2 >= -T_EPSILON)
    {
      nodenum = TN->children[0];
      continue;
    }

    if (dist1 < T_EPSILON && dist2 < T_EPSILON)
    {
      nodenum = TN->children[1];
      continue;
    }

    // the ray crosses the node plane.

    int side = (dist1 < 0) ? 1 : 0;

    double frac = dist1 / (double)(dist1 - dist2);

    float mx = x1 + (x2 - x1) * frac;
    float my = y1 + (y2 - y1) * frac;
    float mz = z1 + (z2 - z1) * frac;

    // check if front half of the ray is OK

    if (! RecursiveTestRay(TN->children[side], x1,y1,z1, mx,my,mz))
      return false;

    // yes it was, so continue with the back half

    nodenum = TN->children[side ^ 1];

    x1 = mx;  y1 = my;  z1 = mz;
  }
}


bool QCOM_TraceRay(float x1, float y1, float z1,
                   float x2, float y2, float z2)
{
  return RecursiveTestRay(0, x1,y1,z1, x2,y2,z2);
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
