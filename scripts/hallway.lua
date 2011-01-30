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


class SEGMENT
{
  nx, ny    -- place in network map

  sx1, sy1, sx2, sy2  -- seed range

  link[DIR] : SEGMENT     -- links to neighboring segments

  section[DIR] : SECTION  -- bordering sections

  vert, horiz, junction : BOOL   -- general shape

  used : BOOL  -- has been used in a hallway (cannot use again)
}


--------------------------------------------------------------]]

require 'defs'
require 'util'



function Hallway_place_em()

  -- Place hallways into the hallway channels.
  --
  -- First we setup a network of junctions and segments in the
  -- free hallway areas.  This includes what rooms / sections
  -- are bordering each segment.
  --
  -- Then we choose a starting place for a hallway and try to
  -- trace a valid hallway, stepping from junction to junction.
  -- If successful, the segments will be marked as used.

  local net_W
  local net_H
  local network


  local function is_valid(nx, ny)
    return (1 <= nx and nx <= net_W) and
           (1 <= ny and ny <= net_H)
  end


  local function is_free(sx1, sy1, sx2, sy2)
    for x = sx1,sx2 do for y = sy1,sy2 do
      local S = SEEDS[x][y]
      if S.room or S.hall then return false end
    end end

    return true
  end


  local function create_network()
    net_W = #LEVEL.network_X
    net_H = #LEVEL.network_Y

    network = table.array_2D(net_W, net_H)

    for nx = 1,net_W do for ny = 1,net_H do
      local XN = LEVEL.network_X[nx]
      local YN = LEVEL.network_Y[ny]

      if XN[2] > 0 and YN[2] > 0 and
         -- ignore section areas (an optimisation)
         ((not XN[3]) or (not YN[3]))
      then
        local sx1 = XN[1]
        local sy1 = YN[1]

        local sx2 = sx1 + XN[2] - 1
        local sy2 = sy1 + YN[2] - 1

        if is_free(sx1, sy1, sx2, sy2) then
          local SEG =
          {
            nx = nx, ny = ny,
            link = {}, section = {},
            sx1 = sx1, sy1 = sy1,
            sx2 = sx2, sy2 = sy2,
            horiz = (not YN[3]),
            vert  = (not XN[3]),
          }

          SEG.junction = SEG.horiz and SEG.vert

          network[nx][ny] = SEG
        end
      end
    end end
  end


  local function seg_to_char(SEG)
    if not SEG then return " " end
    if SEG.used then return "#" end
    if SEG.junction then return "+" end
    if SEG.vert then return "|" end
    if SEG.horiz then return "-" end
    return "?"
  end


  local function dump_network(title)
    gui.debugf(title or "Hall Network:\n")
    gui.debugf("\n")

    for ny = net_H,1,-1 do
      local line = " "
      for nx = 1,net_W do
        line = line .. seg_to_char(network[nx][ny])
      end
      gui.debugf("%s\n", line)
    end

    gui.debugf("\n")
  end


  local function section_neighbor(G, dir)
    local K

    -- check seeds
    local sx1, sy1, sx2, sy2 = geom.side_coords(dir, G.sx1, G.sy1, G.sx2, G.sy2)

    for sx = sx1,sx2 do for sy = sy1,sy2 do
      local S = SEEDS[sx][sy]

      -- require no empty seeds
      if not (S and S.section) then return nil end

      -- require same section (this test is probably unnecessary)
      if K and S.section ~= K then return nil end

      K = S.section
    end end

    return K
  end


  local function join_segments(G1, G2, dir)
    G1.link[dir]    = G2
    G2.link[10-dir] = G1
  end


  local function join_network()
    for nx = 1,net_W do for ny = 1,net_H do
      local G1 = network[nx][ny]

      for dir = 2,8,2 do
        local ox, oy = geom.nudge(nx, ny, dir)
        local G2

        if is_valid(ox, oy) then G2 = network[ox][oy] end
        
        if G1 and G2 then
          join_segments(G1, G2, dir)
        end

        if G1 and not G2 then
          G1.section[dir] = section_neighbor(G1, dir)
        end
      end
    end end
  end


  local function collect_starts()
    local starts = {}

    for nx = 1,net_W do for ny = 1,net_H do
      local G = network[nx][ny]
      if G then
        G.score = 0.5  -- FIXME

        table.insert(starts, G)
      end
    end end

    table.sort(starts, function(A,B) return A.score > B.score end)

    return starts
  end


  local function dump_path(hall)
    -- FIXME !!!
  end


  local function add_hall(hall)
    -- FIXME !!!

    for _,loc in ipairs(hall.path) do
      local G = loc.G

      -- mark segment as used
      assert(not G.used)
      G.used = true

      -- store hallway in seed map
      for sx = G.sx1,G.sx2 do for sy = G.sy1,G.sy2 do
        local S = SEEDS[sx][sy]
        assert(not S.room and not S.hall)
        S.hall = hall
      end end
    end
  end


  local function seg_in_path(path, G)
    for _,loc in ipairs(path) do
      if loc.G == G then return true end
    end

    return false
  end


  local function possible_terms(hall, G)
    return {} -- FIXME !!!
  end


  local function possible_juncs(hall, G)
    return {} -- FIXME !!!
  end


  local function try_trace_hall(hall)
    local G = hall.path[1]

    -- choose starting room (off the starting seg)
    local terms = possible_terms(G)

    if #terms == 0 then return false end

    local T = rand.pick(terms)

    local K1 = T.K
    local R1 = T.K.room


    -- make a path

    local TERMINATE_PROB = { 1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9 }

    while #hall.path < #TERMINATE_PROB do
      local terms = possible_terms(hall, G)
      local juncs = possible_juncs(hall, G)

      -- require at least one additional segment
      if #hall.path == 1 then terms = {} end

      -- nowhere to go?
      if #terms == 0 and #juncs == 0 then return false end

      if #terms > 0 and #juncs > 0 then
        if rand.odds(TERMINATE_PROB[#hall.path]) then
          juncs = {}
        else
          terms = {}
        end
      end

      if #terms > 0 then
        local T = rand.pick(terms)

        hall.dest = T.G

        -- FIXME : TERMINATING STUFF 

        return true
      end

      assert(#juncs > 0)

      -- pick a junction and continue the hallway
      local J = rand.picks(juncs)

      table.insert(hall.path, { G=J.G, dir=J.dir })

      G = J.G
    end

    -- too many segments
    return false
  end


  local function trace_hall(G)
    if G.used then return false end

    for loop = 1,15 do
      local hall =
      {
        path = { {G=G} }
      }

      if try_trace_hall(hall) then
        add_hall(hall)
        return true
      end
    end

    return false
  end


  ---| Hallway_place_em |---

  create_network()
  dump_network("Initial Hall Network:")
  join_network()

  local starts  = collect_starts()

  local count   = 0
  local max_num = 7  -- FIXME

  -- FIXME: try special stuff (half-surrounded, etc)

  for _,G in ipairs(starts) do
    if count >= max_num then break; end

    if trace_hall(G) then
      count = count + 1
    end
  end
end


--------------------------------------------------------------------


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

