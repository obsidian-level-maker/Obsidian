//------------------------------------------------------------------------
//  QUAKE VISIBILITY and TRACING
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
//  Tracing stuff based on Quake II lighting tool : q2rad/trace.c
//
//------------------------------------------------------------------------

#include "headers.h"

#include "lib_file.h"
#include "lib_util.h"
#include "main.h"

#include "q_common.h"
#include "q_light.h"
#include "q_vis.h"

#include "csg_main.h"
#include "csg_quake.h"

#include "vis_buffer.h"


//------------------------------------------------------------------------
//  RAY TRACING
//------------------------------------------------------------------------

#define T_EPSILON  0.1

#define PLANE_OTHER  -1

#define TRACE_EMPTY  -1
#define TRACE_SOLID  -2
#define TRACE_SKY    -3

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


  // FIXME: face should store flags (like FACE_F_SKY)
  bool is_sky = false;

  if (fabs(node->plane.nz) > 0.5 &&
      node->faces.size() == 1 &&
      strstr(node->faces[0]->texture.c_str(), "sky") != NULL)
  {
    is_sky = true;
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
    TN->children[side] = (node->front_L->medium == MEDIUM_SOLID) ?
          (is_sky ? TRACE_SKY : TRACE_SOLID) : TRACE_EMPTY;

  side ^= 1;

  if (node->back_N)
    TN->children[side] = ConvertTraceNode(node->back_N, index_var);
  else
    TN->children[side] = (node->back_L->medium == MEDIUM_SOLID) ?
          (is_sky ? TRACE_SKY : TRACE_SOLID) : TRACE_EMPTY;


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


static int RecursiveTestRay(int nodenum,
                            float x1, float y1, float z1,
                            float x2, float y2, float z2)
{
  for (;;)
  {
    if (nodenum < 0)
      return nodenum;

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

    int r = RecursiveTestRay(TN->children[side], x1,y1,z1, mx,my,mz);

    // -AJA- here is where my TRACE_SKY logic comes into play.
    //       It assumes the ray is cast from luxel to sun light
    //       (and won't work the other way around).
    if (r != TRACE_EMPTY)
      return r;

    // yes it was, so continue with the back half

    nodenum = TN->children[side ^ 1];

    x1 = mx;  y1 = my;  z1 = mz;
  }
}


bool QCOM_TraceRay(float x1, float y1, float z1,
                   float x2, float y2, float z2)
{
  int r = RecursiveTestRay(0, x1,y1,z1, x2,y2,z2);
  
  return (r != TRACE_SOLID);
}


//------------------------------------------------------------------------
//  CLUSTER MANAGEMENT
//------------------------------------------------------------------------

int cluster_X;
int cluster_Y;
int cluster_W;
int cluster_H;

qCluster_c ** qk_clusters;


qCluster_c::qCluster_c(int _x, int _y) : cx(_x), cy(_y), leafs()
{
  ambients[0] = ambients[1] = 0;
  ambients[2] = ambients[3] = 0;
}


qCluster_c::~qCluster_c()
{
  // nothing needed
}


void QCOM_CreateClusters(double min_x, double min_y, double max_x, double max_y)
{
  SYS_ASSERT(min_x < max_x);
  SYS_ASSERT(min_y < max_y);

  int cx1 = (int) floor(min_x / CLUSTER_SIZE);
  int cy1 = (int) floor(min_y / CLUSTER_SIZE);
  int cx2 = (int) ceil (max_x / CLUSTER_SIZE);
  int cy2 = (int) ceil (max_y / CLUSTER_SIZE);

  SYS_ASSERT(cx1 < cx2);
  SYS_ASSERT(cy1 < cy2);

  cluster_X = cx1;
  cluster_Y = cy1;
  cluster_W = cx2 - cx1;
  cluster_H = cy2 - cy1;

  LogPrintf("Cluster Size: %dx%d  (origin %+d %+d)\n", cluster_W, cluster_H,
            cluster_X, cluster_Y);

  qk_clusters = new qCluster_c* [cluster_W * cluster_H];

  for (int i = 0 ; i < cluster_W * cluster_H ; i++)
  {
    int cx = cluster_X + (i % cluster_W);
    int cy = cluster_Y + (i / cluster_W);

    qk_clusters[i] = new qCluster_c(cx, cy);
  }
}


void QCOM_FreeClusters()
{
  if (qk_clusters)
  {
    for (int i = 0 ; i < cluster_W * cluster_H ; i++)
      delete qk_clusters[i];

    delete[] qk_clusters;
    qk_clusters = NULL;
  }
}


//------------------------------------------------------------------------
//  VISIBILITY
//------------------------------------------------------------------------

static qLump_c *q_visibility;

static byte *v_write_buffer;

static int v_bytes_per_leaf;


static int WriteCompressedRow(const byte *src)
{
  // returns offset for the written data block
  int visofs = (int)q_visibility->GetSize();

  const byte *src_e = src + v_bytes_per_leaf;

  byte *dest = v_write_buffer;

  while (src < src_e)
  {
    if (*src)
    {
      *dest++ = *src++;
      continue;
    }

    *dest++ = *src++;

    byte repeat = 1;

    while (src < src_e && *src == 0 && repeat != 255)
    {
      src++; repeat++;
    }

    *dest++ = repeat;
  }

  q_visibility->Append(v_write_buffer, dest - v_write_buffer);

  return visofs;
}


void QCOM_Visibility(int lump, int max_size, int numleafs)
{
  LogPrintf("\nVisibility...\n");

  SYS_ASSERT(qk_clusters);

  // TODO: QCOM_Visibility

  q_visibility = BSP_NewLump(lump);

  v_bytes_per_leaf = (numleafs+7) >> 3;


  // FIXME: DO VIS STUFF !!!!


  // Todo: handle overflow better: store visdata in memory, and degrade
  //       clusters to a "see all" list at offset 0 (pick clusters which
  //       have the most ones).  Also pick clusters where player cannot go
  //       (scenic areas).

  if (q_visibility->GetSize() >= max_size)
    Main_FatalError("Quake build failure: exceeded VISIBILITY limit\n");

  QCOM_FreeClusters();
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
