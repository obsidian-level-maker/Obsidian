----------------------------------------------------------------
--  DECK THE HALLS
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2011 Andrew Apted
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
----------------------------------------------------------------

--[[ *** CLASS INFORMATION ***

class HALLWAY
{
  start : SEED   -- the starting seed (in a room)
  dest  : SEED   -- destination seed  (in a room)

  start_dir  --  direction from start --> hallway
  dest_dir   --  direction from hallway --> dest

  path : list  -- the path between the start and the destination
               -- (not including either start or dest).
               -- each element holds the seed and direction.

  sub_halls   -- number of hallways branching off this one
              -- (normally zero)
}


--------------------------------------------------------------]]

require 'defs'
require 'util'


function Hallway_construct(hall)

  -- FIXME FIXME VERY TEMP SHITE !!!
  local function build_seed(P)
    local S = P.S

    local sdx = S.sx - SECTIONS[1][1].sx1
    local sdy = S.sy - SECTIONS[1][1].sy1

    local x1 = SECTIONS[1][1].x1 + sdx * SEED_SIZE
    local y1 = SECTIONS[1][1].y1 + sdy * SEED_SIZE

    local x2 = x1 + SEED_SIZE
    local y2 = y1 + SEED_SIZE

    gui.add_brush(
    {
      { m="solid" },
      { x=x1, y=y1, tex="SILVER1" },
      { x=x2, y=y1, tex="SILVER1" },
      { x=x2, y=y2, tex="SILVER1" },
      { x=x1, y=y2, tex="SILVER1" },
      { b=176, tex="FLAT22", special=9 },
    })

    gui.add_brush(
    {
      { m="solid" },
      { x=x1, y=y1, tex="COMPBLUE" },
      { x=x2, y=y1, tex="COMPBLUE" },
      { x=x2, y=y2, tex="COMPBLUE" },
      { x=x1, y=y2, tex="COMPBLUE" },
      { t=48, tex="FWATER1" },
    })

    for side = 2,8,2 do
      if not P.exits[side] then
        local bx1, by1, bx2, by2 = x1,y1, x2,y2
        if side == 2 then by2 = by1 + 36 end
        if side == 8 then by1 = by2 - 36 end
        if side == 4 then bx2 = bx1 + 36 end
        if side == 6 then bx1 = bx2 - 36 end

        gui.add_brush(
        {
          { m="solid" },
          { x=bx1, y=by1, tex="COMPSPAN" },
          { x=bx2, y=by1, tex="COMPSPAN" },
          { x=bx2, y=by2, tex="COMPSPAN" },
          { x=bx1, y=by2, tex="COMPSPAN" },
        })
      end
    end

    gui.add_entity({ id="2001", x=x1+96, y=y1+96, z=0 })
  end


  ---| Hallway_construct |---

  -- determine which sides of each seed are an exit
  for index,P in ipairs(hall.path) do
    if not P.exits then P.exits = {} end
    P.exits[P.dir] = 1

    if index > 1 then
      P.exits[10 - hall.path[index-1].dir] = 1
    else
      P.exits[10 - hall.start_dir] = 1
    end
  end

  for _,P in ipairs(hall.path) do
    build_seed(P)
  end
end

