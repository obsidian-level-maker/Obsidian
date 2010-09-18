//------------------------------------------------------------------------
//  SPOTS for MONSTERS / ITEMS
//------------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C) 2010 Andrew Apted
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

#include "headers.h"
#include "hdr_lua.h"

#include "lib_argv.h"
#include "lib_util.h"

#include "main.h"


#define GRID_SIZE  24

#define MAX_GRID_DIM  256


static int grid_min_x, grid_min_y;
static int grid_max_x, grid_max_y;

// number of grid squares
static int grid_W, grid_H;

static byte ** spot_grid;


void SPOT_CreateGrid(int min_x, int min_y, int max_x, int max_y)
{
  grid_min_x = min_x;
  grid_min_y = min_y;

  grid_max_x = max_x;
  grid_max_y = max_y;

  grid_W = (grid_max_x - grid_min_x + GRID_SIZE - 1) / GRID_SIZE;
  grid_H = (grid_max_y - grid_min_y + GRID_SIZE - 1) / GRID_SIZE;

  SYS_ASSERT(grid_W >= 1);
  SYS_ASSERT(grid_H >= 1);

#if 0
  // padding : one square on each side
  grid_W += 2;
  grid_H += 2;
#endif

  SYS_ASSERT(grid_W <= MAX_GRID_DIM);
  SYS_ASSERT(grid_H <= MAX_GRID_DIM);

  spot_grid = new byte* [grid_W];
  
  for (int x = 0 ; x < grid_W ; x++)
  {
    spot_grid[x] = new byte[grid_H];

    memset(spot_grid[x], 0, grid_H);
  }
}


void SPOT_FreeGrid()
{
  if (spot_grid)
  {
    for (int x = 0 ; x < grid_W ; x++)
      delete[] spot_grid[x];

    delete[] spot_grid;

    spot_grid = NULL;
  }
}


void SPOT_DumpGrid(const char *info)
{
  DebugPrintf("Grid %s: (%d %d) .. (%d %d)\n", info,
              grid_min_x, grid_min_y, grid_max_x, grid_max_y);

  for (int y = grid_H-1 ; y >= 0 ; y--)
  {
    char buffer[MAX_GRID_DIM+2];
    
    for (int x = 0 ; x < grid_W ; x++)
      buffer[x] = spot_grid[x][y] ? '#' : '.';

    buffer[grid_W] = 0;

    DebugPrintf("   %s\n", buffer);
  }

  DebugPrintf("\n");
}


class grid_point_c
{
public:
  int x, y;

public:
  grid_point_c()
  { }

  grid_point_c(int _x, int _y) : x(_x), y(_y)
  { }

  ~grid_point_c()
  { }
};


#define ADD_ACTIVE(x, y)  actives.push_back(grid_point_c(x, y))


void SPOT_FloodOutside()
{
  int w2 = grid_W-1;
  int h2 = grid_H-1;

  std::list<grid_point_c> actives;

  for (int x = 0 ; x < grid_W ; x++)
  {
    if (! spot_grid[x][0])  ADD_ACTIVE(x, 0);
    if (! spot_grid[x][h2]) ADD_ACTIVE(x, h2);
  } 

  for (int y = 0 ; y < grid_H ; y++)
  {
    if (! spot_grid[0 ][y]) ADD_ACTIVE(0,  y);
    if (! spot_grid[w2][y]) ADD_ACTIVE(w2, y);
  } 

  while (! actives.empty())
  {
    int x = actives.front().x;
    int y = actives.front().y;

    actives.pop_front();

    if (! spot_grid[x][y])
    {
      spot_grid[x][y] = 1;

      if (x > 0  && ! spot_grid[x-1][y]) ADD_ACTIVE(x-1, y);
      if (x < w2 && ! spot_grid[x+1][y]) ADD_ACTIVE(x+1, y);

      if (y > 0  && ! spot_grid[x][y-1]) ADD_ACTIVE(x, y-1);
      if (y < h2 && ! spot_grid[x][y+1]) ADD_ACTIVE(x, y+1);
    }
  }
}


//------------------------------------------------------------------------

static int grid_lefties[MAX_GRID_DIM];
static int grid_righties[MAX_GRID_DIM];


static void clear_rows()
{
  for (int y = 0 ; y < grid_H ; y++)
  {
    grid_lefties[y]  = 99999;
    grid_righties[y] = -1;
  }
}


static void raw_pixel(int gx, int gy)
{
  if (gy < 0 || gy >= grid_H)
    return;

  grid_lefties[gy]  = MIN(grid_lefties[gy],  gx);
  grid_righties[gy] = MAX(grid_righties[gy], gx);
}


static void draw_line(int x1, int y1, int x2, int y2)
{
  x1 -= grid_min_x;  y1 -= grid_min_y;
  x2 -= grid_min_x;  y2 -= grid_min_y;


  // TODO: clip to bounding box


  int px1 = x1 / GRID_SIZE;
  int px2 = x2 / GRID_SIZE;

  int py1 = y1 / GRID_SIZE;
  int py2 = y2 / GRID_SIZE;

  int h2 = grid_H-1;

  // same row ?
  if (py1 == py2)
  {
    if (py1 < 0 || py1 > h2)
      return;

    raw_pixel(px1, py1);
    raw_pixel(px2, py1);

    return;
  }

  py1 = MAX(0,  py1);
  py2 = MIN(h2, py2);

  // same column ?
  if (px1 == px2)
  {
    for ( ; py1 <= py2 ; py1++)
      raw_pixel(px1, py1);

    return;
  }

  // general case

  double slope = (x2 - x1) / (double)(y2 - y1);

  for (int py = py1 ; py <= py2 ; py++)
  {
    // compute intersection of current row
    int sy = (py == py1) ? y1 : GRID_SIZE * py;
    int ey = (py == py2) ? y2 : GRID_SIZE * (py+1);

    int sx = x1 + (int)((sy - y1) * slope);
    int ex = x1 + (int)((ey - y1) * slope);

    int psx = sx / GRID_SIZE;
    int pex = ex / GRID_SIZE;

    raw_pixel(psx, py);
    raw_pixel(pex, py);
  }
}


static void fill_rows()
{
  // FIXME remember minimum/maximum Y coord

  int w2 = grid_W-1;

  for (int y = 0 ; y < grid_H ; y++)
  {
    if (grid_righties[y] < 0)
      continue;

    int low_x  = MAX(0,  grid_lefties[y]);
    int high_x = MIN(w2, grid_righties[y]);

    for (int x = low_x ; x <= high_x ; x++)
      spot_grid[x][y] = 1;
  }
}


void SPOT_FillPolygon(const grid_point_c *points, int count)
{
  // Algorithm:
  //   rather simplistic, draw each edge of the polygon and
  //   keep track of the minimum and maximum X coordinates,
  //   later fill in the intermediate squares in each row.

  clear_rows();

  for (int i = 0 ; i < count ; i++)
  {
    int k = (i + 1) % count;

    draw_line(points[i].x, points[i].y, points[k].x, points[k].y);
  }

  fill_rows();
}


//------------------------------------------------------------------------
//  LUA INTERFACE
//------------------------------------------------------------------------


// LUA: spots_begin(min_x, min_y, max_x, max_y)
//
int SPOT_begin(lua_State *L)
{
  int min_x = (int)floor(luaL_checknumber(L, 1));
  int min_y = (int)floor(luaL_checknumber(L, 2));

  int max_x = (int)ceil(luaL_checknumber(L, 3));
  int max_y = (int)ceil(luaL_checknumber(L, 4));

  SPOT_CreateGrid(min_x, min_y, max_x, max_y);

  return 0;
}


// LUA: spots_fill_poly(coords)
//
int SPOT_fill_poly(lua_State *L)
{
  // TODO

  return 0;
}


// LUA: spots_end(mons, items)
//
// mons and items are tables where the monster and item spots
// will be placed.
//
int SPOT_end(lua_State *L)
{
  SPOT_DumpGrid("Before");

  SPOT_FloodOutside();

  SPOT_DumpGrid("After");

  // TODO collect the spots

  return 0;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
