//------------------------------------------------------------------------
//  CSG : QUAKE I and II
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2006-2010 Andrew Apted
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

#ifndef __OBLIGE_CSG_QUAKE_H__
#define __OBLIGE_CSG_QUAKE_H__


/***** CLASSES ****************/

class quake_node_c;


class quake_vertex_c
{
public:
  float x, y, z;

public:
  quake_vertex_c() : x(0), y(0), z(0)
  { }

  quake_vertex_c(float _x, float _y, float _z) : x(_x), y(_y), z(_z)
  { }

  ~quake_vertex_c()
  { }
};


class quake_plane_c
{
public:
  float x, y, z;  // any point on the plane

  float nx, ny, nz;  // normal

public:
  quake_plane_c()
  { }

  ~quake_plane_c()
  { }

  void Normalize();
};


class quake_face_c
{
public:
  // the node this face sits on
  quake_node_c *node;

  int node_side;  // 0 = front, 1 = back

  std::vector<quake_vertex_c> verts;

  std::string texture;

  // texturing matrix
  float s[3];
  float t[3];

  qLightmap_c *lmap;

  int index;

public:
  quake_face_c() : node(NULL), node_side(-1),
                   verts(), texture(), lmap(NULL), index(-1)
  { }

  ~quake_face_c()
  { }

  void AddVert(float x, float y, float z);

  void CopyWinding(const std::vector<quake_vertex_c> winding,
                   const quake_plane_c *plane, bool reverse);

  void SetupMatrix(const quake_plane_c *plane);

  void ST_Bounds(double *min_s, double *min_t,
                 double *max_s, double *max_t);
};


class quake_bbox_c
{
public:
  float mins[3];
  float maxs[3];

public:
  quake_bbox_c()
  { }

  ~quake_bbox_c()
  { }

  void Begin();
  void End();

  void Add_X(float x);
  void Add_Y(float y);
  void Add_Z(float z);

  void AddPoint(float x, float y, float z);
  void Merge(const quake_bbox_c& other);
};


class quake_leaf_c
{
public:
  int contents;

  std::vector<quake_face_c *> faces;

  int cluster;

  quake_bbox_c bbox;

  int index;

public:
  quake_leaf_c(int _cont) : contents(_cont), faces(),
                            cluster(-1), index(-1)
  { }

  ~quake_leaf_c()
  { }

  void AddFace(quake_face_c *F);
};


class quake_node_c
{
public:
  quake_plane_c plane;

  quake_node_c *front_N;
  quake_leaf_c *front_L;

  quake_node_c *back_N;
  quake_leaf_c *back_L;

  std::vector<quake_face_c *> faces;

  quake_bbox_c bbox;

  int index;

public:
  quake_node_c() : front_N(NULL), front_L(NULL),
                    back_N(NULL),  back_L(NULL),
                   faces(), index(-1)
  { }

  quake_node_c(const quake_plane_c& P);

  ~quake_node_c()
  { }

  void ComputeBBox();

  void AddFace(quake_face_c *F);
};


class quake_mapmodel_c
{
public:
  float x1, y1, z1;
  float x2, y2, z2;

  csg_property_set_c x_face;
  csg_property_set_c y_face;
  csg_property_set_c z_face;

  s32_t nodes[6];

  int firstface;
  int numfaces;
  int numleafs;

public:
   quake_mapmodel_c();
  ~quake_mapmodel_c();
};


/***** VARIABLES ****************/

extern quake_node_c * qk_bsp_root;
extern quake_leaf_c * qk_solid_leaf;

extern std::vector<quake_face_c *>     qk_all_faces;
extern std::vector<quake_mapmodel_c *> qk_all_mapmodels;


/***** FUNCTIONS ****************/

void CSG_QUAKE_Build();

#endif /* __OBLIGE_CSG_QUAKE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
