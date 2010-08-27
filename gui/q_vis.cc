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

#define VIS_EPSILON  0.01

int cluster_X;
int cluster_Y;
int cluster_W;
int cluster_H;

qCluster_c ** qk_clusters;

static Vis_Buffer * qk_visbuf;


qCluster_c::qCluster_c(int _x, int _y) : cx(_x), cy(_y), leafs(),
                                         visofs(-1), hearofs(-1)
{
  ambients[0] = ambients[1] = 0;
  ambients[2] = ambients[3] = 0;
}

qCluster_c::~qCluster_c()
{
  // nothing needed
}


void qCluster_c::AddLeaf(quake_leaf_c *leaf)
{
  leaf->cluster = this;

  leafs.push_back(leaf);
}


int qCluster_c::CalcID() const
{
  if (leafs.empty())
    return -1;

  return (cy * cluster_W) + cx;
}


void QCOM_CreateClusters(double min_x, double min_y, double max_x, double max_y)
{
  SYS_ASSERT(min_x < max_x);
  SYS_ASSERT(min_y < max_y);

  int cx1 = (int) floor(min_x / CLUSTER_SIZE + VIS_EPSILON);
  int cy1 = (int) floor(min_y / CLUSTER_SIZE + VIS_EPSILON);
  int cx2 = (int) ceil (max_x / CLUSTER_SIZE - VIS_EPSILON);
  int cy2 = (int) ceil (max_y / CLUSTER_SIZE - VIS_EPSILON);

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
    int cx = (i % cluster_W) /* + cluster_X */;
    int cy = (i / cluster_W) /* + cluster_Y */;

    qk_clusters[i] = new qCluster_c(cx, cy);
  }

  qk_visbuf = new Vis_Buffer(cluster_W, cluster_H);

  // TODO: if (some_option_name)
  //         qk_visbuf->SetQuickMode(true);
}


void QCOM_FreeClusters()
{
  if (qk_clusters)
  {
    for (int i = 0 ; i < cluster_W * cluster_H ; i++)
      delete qk_clusters[i];

    delete[] qk_clusters;
    qk_clusters = NULL;

    delete qk_visbuf;
    qk_visbuf = NULL;
  }
}


void QCOM_VisMarkWall(int cx, int cy, int side)
{
  SYS_ASSERT(qk_visbuf);

  if (side & 1)
    qk_visbuf->AddDiagonal(cx, cy, side);
  else
    qk_visbuf->AddWall(cx, cy, side);

  // debugging
#if 0
  fprintf(stderr, "@@@ %d %d %d\n", cx, cy, side);
#endif
}


static void MarkSolidClusters()
{
  // any cluster without a leaf must be totally solid

  for (int cy = 0 ; cy < cluster_H ; cy++)
  for (int cx = 0 ; cx < cluster_W ; cx++)
  {
    qCluster_c *cluster = qk_clusters[cy * cluster_W + cx];

    if (cluster->leafs.empty())
    {
      for (int side = 2 ; side <= 8 ; side += 2)
        QCOM_VisMarkWall(cx, cy, side);
    }
  }
}


static byte DiminishVolume(int kind, byte orig)
{
  // TODO: this works well for SKY, but may need different for liquids

  if (orig > 128) return 128;
  if (orig >  96) return  96;
  if (orig >  64) return  64;
  if (orig >  32) return  32;

  return 0;
}


static void FloodAmbientSounds()
{
  for (int pass = 0 ; pass < 6 ; pass++)
  for (int cy = 0 ; cy < cluster_H ; cy++)
  for (int cx = 0 ; cx < cluster_W ; cx++)
  {
    qCluster_c *S = qk_clusters[cy * cluster_W + cx];

    if (S->leafs.empty())
      continue;

    for (int side = 2 ; side <= 8 ; side += 2)
    {
      if (qk_visbuf->TestWall(cx, cy, side))
        continue;

      int nx = (side == 4) ? -1 : (side == 6 ) ? +1 : 0;
      int ny = (side == 2) ? -1 : (side == 8 ) ? +1 : 0;

      nx += cx;  ny += cy;

      if (nx < 0 || nx >= cluster_W || ny < 0 || ny >= cluster_H)
        continue;

      qCluster_c *N = qk_clusters[ny * cluster_W + nx];

      for (int k = 0 ; k < 4 ; k++)
      {
        byte src  = S->ambients[k];
        byte dest = N->ambients[k];

        if (src == 0)
          continue;

        src = DiminishVolume(k, src);

        N->ambients[k] = MAX(src, dest);
      }
    }
  }
}


//------------------------------------------------------------------------
//  VISIBILITY
//------------------------------------------------------------------------

static qLump_c *q_visibility;

static byte *v_row_buffer;
static byte *v_compress_buffer;

static int v_row_bits;  // number of leafs or clusters
static int v_bytes_per_row;


static int WriteCompressedRow()
{
  // returns offset for the written data block
  int visofs = (int)q_visibility->GetSize();

  const byte *src   = v_row_buffer;
  const byte *s_end = src + v_bytes_per_row;

  byte *dest = v_compress_buffer;

  while (src < s_end)
  {
    if (*src)
    {
      *dest++ = *src++;
      continue;
    }

    *dest++ = *src++;

    byte repeat = 1;

    while (src < s_end && *src == 0 && repeat != 255)
    {
      src++; repeat++;
    }

    *dest++ = repeat;
  }

  q_visibility->Append(v_compress_buffer, dest - v_compress_buffer);

  // TODO: compression statistics

  return visofs;
}


static void CollectRowData(int src_x, int src_y)
{
  // initial state : everything visible
  memset(v_row_buffer, 0xFF, v_bytes_per_row);

  unsigned int blocked = 0; // statistics

  for (int cy = 0 ; cy < cluster_H ; cy++)
  for (int cx = 0 ; cx < cluster_W ; cx++)
  {
    if ((cx == src_x && cy == src_y) || qk_visbuf->CanSee(cx, cy))
      continue;

    qCluster_c *cluster = qk_clusters[cy * cluster_W + cx];

    if (qk_game == 2)  // Quake II
    {
      int index = cy * cluster_W + cx;

      SYS_ASSERT(index >= 0);
      SYS_ASSERT((index >> 3) < v_bytes_per_row);

      v_row_buffer[index >> 3] &= ~ (1 << (index & 7));

      blocked++;
    }
    else  // original Quake, data is indexed by leaf number
    {
      unsigned int total = cluster->leafs.size();

      blocked += total;

      // mark all the leafs in destination cluster as blocked

      for (unsigned int k = 0 ; k < total ; k++)
      {
        int index = cluster->leafs[k]->index;

        index--;  // skip the solid leaf

        SYS_ASSERT(index >= 0);
        SYS_ASSERT((index >> 3) < v_bytes_per_row);

        v_row_buffer[index >> 3] &= ~ (1 << (index & 7));
      }
    }
  }

#if 0
fprintf(stderr, "cluster: %2d %2d  blocked: %d = %1.2f%%   \n",
        src_x, src_y, blocked, blocked * 100.0 / v_row_bits);
#endif

  // !!! FIXME: statistics  (blocked / v_row_bits)

  
#if 0  // DEBUGGING : invert the map
  for (int n = 0 ; n < v_bytes_per_row ; n++)
    v_row_buffer[n] ^= 0xFF;
#endif
}


static void Build_PVS()
{
  int done = 0;

  for (int cy = 0 ; cy < cluster_H ; cy++)
  for (int cx = 0 ; cx < cluster_W ; cx++)
  {
    qCluster_c *cluster = qk_clusters[cy * cluster_W + cx];

    if (cluster->leafs.empty())
      continue;

    qk_visbuf->ClearVis();
    qk_visbuf->ProcessVis(cx, cy);

    CollectRowData(cx, cy);

    cluster->visofs = WriteCompressedRow();

    if (qk_game == 2)
    {
      // Quake II's Potentially Hearable Set
      //
      // 1. start off with the PVS set
      // 2. flood fill for a few passes
      // 3. truncate it based on distance

      qk_visbuf->FloodFill(4);
      qk_visbuf->Truncate(8);

      CollectRowData(cx, cy);

      cluster->hearofs = WriteCompressedRow();
    }

    //FIXME if (User_Cancel) return;

    if (done % 80 == 0)
      Main_Ticker();

    done++;
  }
}


static void Q2_PrependOffsets(int num_clusters)
{
  int header_size = 4 + 8 * num_clusters;

  s32_t *header = new s32_t[1 + num_clusters * 2];

  header[0] = LE_S32(num_clusters);

  for (int i = 0 ; i < num_clusters ; i++)
  {
    qCluster_c *cluster = qk_clusters[i];

    // dummy offset for unused clusters
    if (cluster->visofs  < 0) cluster->visofs  = 0;
    if (cluster->hearofs < 0) cluster->hearofs = 0;

    // fix endianness too

    header[i*2 + 1] = LE_S32(header_size + cluster->visofs);
    header[i*2 + 2] = LE_S32(header_size + cluster->hearofs);
  }

  q_visibility->Prepend(header, header_size);
}


void QCOM_Visibility(int lump, int max_size, int numleafs)
{
  LogPrintf("\nVisibility...\n");

  SYS_ASSERT(qk_clusters);

  int num_clusters = cluster_W * cluster_H;

  MarkSolidClusters();

  if (qk_game == 1)
    FloodAmbientSounds();


  if (qk_game == 2)
    v_row_bits = num_clusters;
  else
    v_row_bits = numleafs;

  v_bytes_per_row = (v_row_bits+7) >> 3;

  LogPrintf("bits per row: %d --> bytes: %d\n", v_row_bits, v_bytes_per_row);

  v_row_buffer = new byte[1 + v_bytes_per_row];

  // the worst case scenario for compression is 50% larger
  v_compress_buffer = new byte[1 + 2 * v_bytes_per_row];


  q_visibility = BSP_NewLump(lump);

  Build_PVS();

  if (qk_game == 2)
    Q2_PrependOffsets(num_clusters);


  // TODO: handle overflow: store visdata in memory, and "merge" the
  //       clusters into pairs or 2x2 contiguous pieces.
  //       For Quake II, degrade the PHS before the PVS.

  if (q_visibility->GetSize() >= max_size)
    Main_FatalError("Quake build failure: exceeded VISIBILITY limit\n");

  delete[] v_row_buffer;
  delete[] v_compress_buffer;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
