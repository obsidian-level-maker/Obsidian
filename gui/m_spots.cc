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


#define GRID_SIZE  20


static int grid_min_x, grid_min_y;
static int grid_max_x, grid_max_y;

// number of grid squares (including padding)
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

  // padding : one square on each side
  grid_W += 2;
  grid_H += 2;

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


void SPOT_DumpGrid()
{
  DebugPrintf("Grid: (%d %d) .. (%d %d)\n",
              grid_min_x, grid_min_y, grid_max_x, grid_max_y);

  SYS_ASSERT(grid_W < 256);

  for (int y = grid_H-1 ; y >= 0 ; y--)
  {
    char buffer[256];
    
    for (int x = 0 ; x < grid_W ; x++)
      buffer[x] = spot_grid[x][y] ? '#' : '.';

    buffer[grid_W] = 0;

    DebugPrintf("   %s\n", buffer);
  }

  DebugPrintf("\n");
}



//------------------------------------------------------------------------
//  LUA INTERFACE
//------------------------------------------------------------------------


// LUA: spots_begin(min_x, min_y, max_x, max_y)
//
int SPOT_begin(lua_State *L)
{
  // TODO

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
  // TODO

  return 0;
}


//--- editor settings ---
// vi:ts=2:sw=2:expandtab
