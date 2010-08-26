//------------------------------------------------------------------------
//
//  Visibility Buffer
//
//  Copyright (C) 2009-2010 Andrew Apted
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
#include "main.h"

#include "vis_buffer.h"


Vis_Buffer::Vis_Buffer(int width, int height) :
      W(width), H(height), quick_mode(false),
    flip_x(0), flip_y(0)
{
  data = new short[W * H];

  Clear();
}

Vis_Buffer::~Vis_Buffer()
{
  delete[] data;
}


void Vis_Buffer::SetQuickMode(bool enable)
{
  quick_mode = enable;
}

void Vis_Buffer::Clear()
{
  memset(data, 0, sizeof(short) * W * H);
}

void Vis_Buffer::AddWall(int x, int y, int side)
{
  if (side == 6)
  {
    x++; side = 4;
  }

  if (side == 8)
  {
    y++; side = 2;
  }

  if (! isValid(x, y))
    return;

  if (side == 2)
    at(x, y) |= V_BOTTOM;
  else
    at(x, y) |= V_LEFT;
}

bool Vis_Buffer::TestWall(int x, int y, int side)
{
  side = Trans_Side(side);

  if (side == 6)
  {
    if (flip_x) x--; else x++;
    side = 4;
  }

  if (side == 8)
  {
    if (flip_y) y--; else y++;
    side = 2;
  }

  if (! isValid(x, y))
    return true;

  if (side == 2)
    return (at(x, y) & V_BOTTOM) ? true : false;
  else
    return (at(x, y) & V_LEFT) ? true : false;
}

void Vis_Buffer::ReadMap(const char *filename)
{
  FILE *fp = fopen(filename, "r");
  if (! fp)
    Main_FatalError("No such file: %s\n", filename);

  int x, y, side;

  while (fscanf(fp, " %d %d %d ", &x, &y, &side) == 3)
  {
    AddWall(x, y, side);
  }

  fclose(fp);
}


//------------------------------------------------------------------------

void Vis_Buffer::DoBasic(int dx, int dy, int side)
{
  int x = loc_x;
  int y = loc_y;

  int L = 0, R = 0;

  for (;;)
  {
    if (! isValid(x, y))
      return;

    if (TestWall(x, y, side))
      break;

    x += dx; y += dy;
  }

  for (;;)
  {
    while (isValid( x+dy*(L+1), y+dx*(L+1)) &&
         TestWall(x+dy*(L+1), y+dx*(L+1), side))
      L++;

    while (isValid( x-dy*(R+1), y-dx*(R+1)) &&
         TestWall(x-dy*(R+1), y-dx*(R+1), side))
      R++;

    x += dx; y += dy;

    if (! isValid(x, y))
      return;

    for (int j = -R; j <= L; j++)
      at(x+dy*j, y+dx*j) |= V_BASIC;
  }
}

void Vis_Buffer::DoFill()
{
  for (int dy = 0; dy < H; dy++)
  for (int dx = 0; dx < W; dx++)
  {
    // if (dx == 0 && dy == 0)
    //    continue;

    int sx = loc_x + dx;
    int sy = loc_y + dy;

    if (! isValid(loc_x, sy+1))
      return;
    if (! isValid(sx+1, loc_y))
      break;

    if (! (at(sx+1, sy+1) & V_ANY) &&
       ((at(sx+1, sy)   & V_ANY) || TestWall(sx+1, sy, 8)) &&
       ((at(sx,   sy+1) & V_ANY) || TestWall(sx, sy+1, 6))
       )
    {
      at(sx+1, sy+1) |= V_FILL;
    }
  }
}

void Vis_Buffer::AddStep(Stair_Steps& dest, int x, int y, int side)
{
  Stair_Pos pos;

  pos.x = x;
  pos.y = y;
  pos.side = side;

  dest.push_back(pos);
}

void Vis_Buffer::CopySteps(Stair_Steps& dest, const Stair_Steps& src)
{
  for (unsigned int i = 0; i < src.size(); i++)
    dest.push_back(src[i]);
}

void Vis_Buffer::MarkSteps(const Stair_Steps& steps)
{
  if (steps.size() < 2)
    return;

  // determine bounding box
  int lx = steps.front().x;
  int ly = steps.back().y;

  int ww = steps.back().x  - lx;
  int hh = steps.front().y - ly;

  if (steps.back().side == 2)
    ww++;

  if (steps.front().side == 4)
    hh++;

  // skip if too small
  if (lx > loc_x && ww <= 1 && ly > loc_y && hh <= 1)
    return;

  // fill in the "gaps" inside the bbox (behind the stair-step)
  for (unsigned int i = 0; i < steps.size(); i++)
  {
    if (steps[i].side == 4)
      for (int sx = steps[i].x; sx < lx+ww; sx++)
        at(sx, steps[i].y) |= V_LSHAPE;
  }

  // if stair-step covers whole quadrant, then we don't need
  // to look for other stair-steps behind the current one.
  if (lx == loc_x && ly == loc_y)
  {
    limit_x = lx + ww;
    limit_y = ly + hh;
  }

  if (quick_mode)
    return;

  // normal case : mark all squares in the quadrant which lie
  // in the shadow area cast by the stair-step's bounding box.

  double tx = lx - loc_x;
  double ty = ly - loc_y + hh - 1;

  double bx = lx - loc_x + ww - 1;
  double by = ly - loc_y;

  if (bx == 0 && ly > loc_y)
    return;

  for (int nx = loc_x; nx < loc_x+W; nx++)
  {
    if (! isValid(nx, loc_y))
      return;
  
    int y1 = loc_y;
    int y2 = loc_y+H;

    if (lx > loc_x)
    {
      double z = loc_y + 1 + (nx - loc_x) * ty / tx;
      y2 = (int)floor(z) - 1;
    }

    if (ly > loc_y)
    {
      double z = loc_y + (nx - loc_x) * by / bx;
      y1 = (int)ceil(z);
    }

    if (nx < lx + ww)
      y1 = MAX(y1, ly + hh);

    for (int ny = y1; ny <= y2 && isValid(nx, ny); ny++)
    {
      at(nx, ny) |= V_SPAN;
    }
  }
}

void Vis_Buffer::FollowStair(Stair_Steps& steps, int sx, int sy, int side)
{
  AddStep(steps, sx, sy, side);

  for (;;)
  {
    if (side == 2)
    {
      sx++;
      if (! isValid(sx, sy)) break;

      bool go_right = TestWall(sx, sy, 2);
      bool go_down  = (sy-1 >= loc_y) && TestWall(sx, sy-1, 4);

      // handle branches with recursion
      if (go_right && go_down)
      {
        Stair_Steps other;
        CopySteps(other, steps);

        FollowStair(other, sx, sy, 2);
        go_right = false;
      }

      if (go_right)
      {
        // OK
      }
      else if (go_down)
      {
        sy--;  // OK
        side = 4;
      }
      else
        break;
    }
    else
    {
      /// assert(side == 4);

      if (sy <= loc_y) break;

      bool go_right = TestWall(sx, sy, 2);
      bool go_down  = (sy-1 >= loc_y) && TestWall(sx, sy-1, 4);

      // handle branches with recursion
      if (go_right && go_down)
      {
        // recursive bit
        Stair_Steps other;
        CopySteps(other, steps);

        FollowStair(other, sx, sy, 2);
        go_right = false;
      }

      if (go_right)
      {
        side = 2;
      }
      else if (go_down)
      {
        sy--;  // OK
      }
      else
        break;
    }

    AddStep(steps, sx, sy, side);
  }

  MarkSteps(steps);
}

void Vis_Buffer::DoSteps(int quadrant)
{
  flip_x = (quadrant & 1);
  flip_y = (quadrant & 2);

  limit_x = W;
  limit_y = H;

  for (int dy = 0; dy < limit_y; dy++)
  for (int dx = 0; dx < limit_x; dx++)
  {
    int sx = loc_x + dx;
    int sy = loc_y + dy;

    if (! isValid(loc_x, sy))
      return;
    if (! isValid(sx, sy))
      break;

    if (  (dy > 0 && TestWall(sx, sy, 2)) &&
      ! (dx > 0 && TestWall(sx-1, sy, 2)) &&
      ! (dx > 0 && TestWall(sx, sy, 4)) )
    {
      Stair_Steps base;
      FollowStair(base, sx, sy, 2);
    }

    if (  (dx > 0 && TestWall(sx, sy, 4)) &&
      ! (          TestWall(sx-1, sy, 8)) &&
      ! (isValid(sx, sy+1) && TestWall(sx, sy+1, 4)) )
    {
      Stair_Steps base;
      FollowStair(base, sx, sy, 4);
    }
  }
}


//------------------------------------------------------------------------

void Vis_Buffer::ClearVis()
{
  int len = W * H;

  for (int i = 0; i < len; i++)
    data[i] &= 7;
}

void Vis_Buffer::ProcessVis(int x, int y)
{
  loc_x = x;
  loc_y = y;

  DoBasic(-1, 0, 4); DoBasic(0, -1, 2);
  DoBasic(+1, 0, 6); DoBasic(0, +1, 8);

  DoSteps(0); DoFill();
  DoSteps(1); DoFill();
  DoSteps(2); DoFill();
  DoSteps(3); DoFill();

  flip_x = flip_y = 0;
}

int Vis_Buffer::GetVis(int x, int y)
{
  short d = at(x, y);

  if (d & V_FILL)   return 4;
  if (d & V_LSHAPE) return 3;
  if (d & V_BASIC)  return 1;
  if (d & V_SPAN)   return 2;

  return 0;
}

//--- editor settings ---
// vi:ts=2:sw=2:expandtab
