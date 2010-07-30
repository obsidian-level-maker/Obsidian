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

class quake_plane_c
{
public:
  float nx, ny, nz;  // normal

  float dist;

public:
  quake_plane_c()
  { }

  ~quake_plane_c()
  { }
};



class quake_face_c
{
public:
  quake_plane_c plane;

  // TODO

public:
  quake_face_c()
  { }

  ~quake_face_c()
  { }
};


class quake_leaf_c
{
public:
  int contents;

  std::vector<quake_face_c *> faces;

public:
  quake_leaf_c()
  { }

  ~quake_leaf_c()
  { }
};


class quake_node_c
{
public:
  quake_plane_c plane;

  quake_node_c *front_N;
  quake_leaf_c *front_L;

  quake_node_c *back_N;
  quake_leaf_c *back_L;

public:
  quake_node_c()
  { }

  ~quake_node_c()
  { }
};


/***** VARIABLES ****************/


/***** FUNCTIONS ****************/

void CSG_QUAKE_Build();

#endif /* __OBLIGE_CSG_QUAKE_H__ */

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
