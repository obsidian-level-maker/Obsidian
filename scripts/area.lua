----------------------------------------------------------------
--  AREAS Within Rooms
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2010-2013 Andrew Apted
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

class LINK
{
  dir  -- direction from K1 to K2

  conn : CONN   -- optional (not used for crossovers)
}


--------------------------------------------------------------]]


function Area_decide_picture(K)
  if (not LEVEL.has_logo) or rand.odds(sel(A.room.has_logo, 10, 30)) then
    K.pic_name = assert(K.room.zone.logo_name)

    K.room.has_logo = true
     LEVEL.has_logo = true

    return
  end

  local prob = style_sel("pictures", 0, 50, 85, 99)

  if K.room.zone.pictures and rand.odds(prob) then
    K.pic_name = rand.key_by_probs(K.room.zone.pictures)
  end
end


----------------------------------------------------------------


X_MIRROR_CHARS =
{
  ['<'] = '>', ['>'] = '<',
  ['/'] = '%', ['%'] = '/',
  ['Z'] = 'N', ['N'] = 'Z',
  ['L'] = 'J', ['J'] = 'L',
  ['F'] = 'T', ['T'] = 'F',
}

Y_MIRROR_CHARS =
{
  ['v'] = '^', ['^'] = 'v',
  ['/'] = '%', ['%'] = '/',
  ['Z'] = 'N', ['N'] = 'Z',
  ['L'] = 'F', ['F'] = 'L',
  ['J'] = 'T', ['T'] = 'J',
}

TRANSPOSE_DIRS = { 1,4,7,2,5,8,3,6,9 }

TRANSPOSE_CHARS =
{
  ['<'] = 'v', ['v'] = '<',
  ['>'] = '^', ['^'] = '>',
  ['/'] = 'Z', ['Z'] = '/',
  ['%'] = 'N', ['N'] = '%',
  ['-'] = '|', ['|'] = '-',
  ['!'] = '=', ['='] = '!',
  ['F'] = 'J', ['J'] = 'F',
}

STAIR_DIRS =
{
  ['<'] = 4, ['>'] = 6,
  ['v'] = 2, ['^'] = 8,
}


----------------------------------------------------------------


function Areas_handle_connections()


  local function link_them(K1, dir, K2, conn)
    assert(K1)
    assert(K2)

    gui.debugf("link_them: %s --> %s\n", K1:tostr(), K2:tostr())

    local LINK =
    {
      dir = dir
      conn = conn
    }

    if K1.hall then
       K1.link[dir] = LINK
       LINK.K1 = K1
    end

    if K2.hall then
       K2.link[10 - dir] = LINK
       LINK.K2 = K2
    end
  end


  local function create_portal(D, L)
    -- determine place (in seeds)
    local K, dir
    local sx1, sy1, sx2, sy2

    if D.L1 == L then
      K   = D.K1
      dir = D.dir1
    else
      K   = D.K2
      dir = D.dir2
    end

    sx1, sy1, sx2, sy2 = geom.side_coords(dir, K.sx1, K.sy1, K.sx2, K.sy2)

    -- except for joiners, connections are usually 1 seed wide
    local is_wide = (D.L1.is_joiner or D.L2.is_joiner)

    if (sx2 > sx1 or sy2 > sy1) and not is_wide then
      if sx2 > sx1 then
        assert(sx2 == sx1 + 2)
        sx1 = sx1 + 1
        sx2 = sx1
      else
        assert(sy2 == sy1 + 2)
        sy1 = sy1 + 1
        sy2 = sy1
      end
    end


    local PORTAL =
    {
      kind = "walk"
      sx1  = sx1, sy1 = sy1
      sx2  = sx2, sy2 = sy2
      section = K
      side = dir
      conn = D
    }

    Portal_install(PORTAL)

    return PORTAL
  end


  local function lock_portals(D)
    local portal = D.portal1 or D.portal2

    -- prefer the door in the indoor room.
    -- in street mode, prefer the door in the non-street room.

    if D.portal1 and D.portal2 then
      if (D.L1.is_outdoor and not D.L2.is_outdoor) or
          D.L1.is_street
      then
        portal = D.portal2
      end
    end

    portal.lock = D.lock
    portal.door_kind = "door"
  end


  local function handle_conn(D)
    assert(D.K1 and D.dir1)
    assert(D.K2 and D.dir2)

    local is_double = (D.kind == "double_L" or D.kind == "double_R")


    if D.L1.kind != "hallway" then
       D.portal1 = create_portal(D, D.L1)
    end

    if D.L2.kind != "hallway" then
       D.portal2 = create_portal(D, D.L2)
    end

    if D.portal1 and D.portal2 then
      D.portal1.peer = D.portal2
      D.portal2.peer = D.portal1
    end


    link_them(D.K1, D.dir1, D.K2, D)

    if D.lock then
      if D.L1.is_joiner or D.L2.is_joiner then
        -- do nothing for joiners
      else
        lock_portals(D)

        D.L1.has_a_door = true
        D.L2.has_a_door = true
      end
    end
  end


  local function handle_crossover(H)
--[[
    -- create the chunks in the room for the bridge / channel
    each K in H.sections do
      if K.room then
        chunk_for_crossover(H, K)
      end
    end

    -- link these chunks with the hallway outside of the room
    each K1 in H.sections do
      if not K1.room then continue end

      each dir,_ in K1.hall_link do
        local K2 = K1:neighbor(dir)

        if not K2.hall then continue end

        local C1 = chunk_for_section_side(K1,    dir, K2, false)
        local C2 = chunk_for_section_side(K2, 10-dir, K1, false)

        link_chunks(C1, dir, C2, nil)
      end
    end
--]]
  end


  ---| Areas_handle_connections |---

  each D in LEVEL.conns do
    -- teleporters are done elsewhere (as an "important")
    if D.kind != "teleporter" then
      handle_conn(D)
    end
  end

  each H in LEVEL.halls do
    if H.crossover then
      handle_crossover(H)
    end
  end

end


----------------------------------------------------------------


function Areas_place_importants(R)
  --|
  --| this places the "important" stuff (keys, switches, teleporters)
  --| into the rooms.  It requires "goal spots" (except for caves).
  --|
  --| for caves, this is done before the room is laid out, since the
  --| cave code needs to know a-priori where the importants will go
  --| (so it can ensure there is walkable space at those places).
  --|
  --| NOTE: closets are done elsewhere...

  local cave_mode

  local function dir_for_spot(T)
    local S = Seed_from_coord(T.x1 + 32, T.y1 + 32)

    local best_dir
    local best_dist

    for dir = 2,8,2 do
      local dist = R:dist_to_edge(S, dir)

      dist = dist + gui.random() / 10

      if not best_dist or dist > best_dist then
        best_dir  = dir
        best_dist = dist
      end
    end

    return best_dir

  --[[ OLD STUFF
    local R = C.room

    -- check which sides of chunk are against a wall or liquid
    local edges = {}

    local num_wall = 0
    local num_same = 0
    local num_diff = 0
    local num_liq  = 0

    for dir = 2,8,2 do
      edges[dir] = C:classify_edge(dir)

          if edges[dir] == "wall"   then num_wall = num_wall + 1
      elseif edges[dir] == "same"   then num_same = num_same + 1
      elseif edges[dir] == "diff"   then num_diff = num_diff + 1
      elseif edges[dir] == "liquid" then num_liq  = num_liq  + 1
      end
    end

    -- prefer direction which is in the same area
    if num_same == 1 then
      for dir = 2,8,2 do
        if edges[dir] == "same" then return dir end
      end
    end

    if num_same == 0 and num_diff == 1 then
      for dir = 2,8,2 do
        if edges[dir] == "diff" then return dir end
      end
    end

    -- handle corners
    local hemmed

    if edges[4] == "wall" and edges[6] == "wall" then hemmed = true end
    if edges[2] == "wall" and edges[8] == "wall" then hemmed = true end

    if num_wall == 2 and not hemmed and num_liq == 0 then
      if R.sh > R.sw then
        return (edges[2] == "wall" ? 8 ; 2)
      else
        return (edges[4] == "wall" ? 6 ; 4)
      end
    end

    -- find a wall to face away from
    for dir = 2,8,2 do
      if edges[10 - dir] == "wall" and edges[dir] == "same" then
        return dir
      end
    end

    -- otherwise use position in room
    local dir1 = ((C.sx1 + C.sx2) < (R.sx1 + R.sx2) ? 6 ; 4)
    local dir2 = ((C.sy1 + C.sy2) < (R.sy1 + R.sy2) ? 8 ; 2)

    if R.sh > R.sw then dir1, dir2 = dir2, dir1 end

    if edges[dir1] != "liquid" then return dir1 end
    if edges[dir2] != "liquid" then return dir2 end

    -- find any direction which does not face liquid
    for dir = 2,8,2 do
      if edges[dir] != "liquid" then return dir end
    end

    return 2
--]]
  end


  local function nearest_wall(T)
    -- get the wall_dist from seed containing the spot

    local S = Seed_from_coord(T.x1 + 32, T.y1 + 32)

    -- sanity check
    if S.room != R then return nil end

    return assert(S.wall_dist)
  end


  local function nearest_portal(T)
    local dist

    each D in R.conns do
      local portal = D.portal1 or D.portal2  -- doesn't matter which

      if portal then
        local d = geom.box_dist(T.x1, T.y1, T.x2, T.y2,
                                Seed_group_edge_coords(portal, portal.side, 0))
        d = d / SEED_SIZE
        if not dist or d < dist then
          dist = d
        end
      end
    end

    return dist
  end


  local function nearest_goal(T)
    local dist

    each G in R.goals do
      local d = geom.box_dist(T.x1, T.y1, T.x2, T.y2,
                              G.x1, G.y1, G.x2, G.y2)
      d = d / SEED_SIZE
      if not dist or d < dist then
        dist = d
      end
    end

    return dist
  end


  local function evaluate_spot(spot)
    -- Factors we take into account:
    --   1. distance from walls
    --   2. distance from entrance / exits
    --   3. distance from other goals
    --   4. rank value from prefab

    local   wall_dist = nearest_wall(spot)   or 20
    local portal_dist = nearest_portal(spot) or 20
    local   goal_dist = nearest_goal(spot)   or 20

    -- combine portal_dist and goal_dist
    local score = math.min(goal_dist, portal_dist * 1.2)

    -- now combine with wall_dist.
    -- in caves we need the spot to be away from the edges of the room
    if cave_mode then
      if wall_dist >= 1.2 then score = score + 100 end
    else
      score = score + wall_dist / 5
    end

    -- apply the skill bits from prefab
    if spot.rank then
      score = score + (spot.rank - 1) * 5 
    end
 
    -- tie breaker
    score = score + 2.0 * gui.random() ^ 2

--[[
if R.id == 2 then --- R.purpose == "START" then
local S = Seed_from_coord(spot.x1 + 32, spot.y1 + 32)
gui.printf("  %s : wall:%1.1f portal:%1.1f goal:%1.1f --> score:%1.2f\n",
    S:tostr(), wall_dist, portal_dist, goal_dist, score)
end
--]]
    return score
  end


  local function spot_for_wotsit(kind, not_essential)
    if table.empty(R.goal_spots) then
      -- disaster!
      if not_essential then return nil end
      error("NO SPOT FOR " .. kind)
    end

    each spot in R.goal_spots do
      spot.score = evaluate_spot(spot)
    end

    table.sort(R.goal_spots,
        function(A, B) return A.score > B.score end)

    local G = table.remove(R.goal_spots, 1)

    G.content = {}
    G.spot_dir = dir_for_spot(G)

    table.insert(R.goals, G)

    return G
  end


  local function add_purpose(R)
    if R.purpose_is_done then return end

    local G = spot_for_wotsit("PURPOSE")

    G.content.kind = R.purpose

    -- no monsters near start spot, please
    if R.purpose == "START" then
      R:add_exclusion_zone("empty",     G.x1, G.y1, G.x2, G.y2, 144)
      R:add_exclusion_zone("nonfacing", G.x1, G.y1, G.x2, G.y2, 768)
    end

    if R.purpose == "SOLUTION" then
      local lock = assert(R.purpose_lock)

      G.content.lock = lock

      if lock.kind == "KEY" or lock.kind == "SWITCH" then
        G.content.kind = lock.kind
      else
        error("UNKNOWN LOCK KIND")
      end

      if lock.kind == "KEY" then
        G.content.key = assert(lock.key)
      end
    end

    --- Hexen stuff ---

    -- NOTE: arg1 of the player things is used to select which spot
    --       the hub gate takes you to.  We set it to the local_map
    --       number of the OTHER map.

    if R.purpose == "EXIT" and LEVEL.hub_key then
      -- goal of branch level is just a key
      G.content.kind = "KEY"
      G.content.key  = LEVEL.hub_key
    
    elseif R.purpose == "EXIT" and LEVEL.hub_links then
      -- goal of chain levels is gate to next level
      local chain_link = Hub_find_link("EXIT")

      if chain_link and chain_link.kind == "chain" then
        G.content.kind = "GATE"
        G.content.source_id = chain_link.dest.local_map
        G.content.dest_id   = chain_link.src .local_map
        G.content.dest_map  = chain_link.dest.map
      end
    end

    if R.purpose == "START" and LEVEL.hub_links then
      -- beginning of each level (except start) is a hub gate
      local from_link = Hub_find_link("START")

      if from_link then
        G.content.kind = "GATE"
        G.content.source_id = from_link.src .local_map
        G.content.dest_id   = from_link.dest.local_map
        G.content.dest_map  = from_link.src .map
      end
    end
  end


  local function add_weapon(R, weapon)
    local G = spot_for_wotsit("WEAPON", "not_essential")

    -- this is bad, but not a show-stopper
    if not G then
      gui.printf("\nWARNING: NO SPOT FOR WEAPON (%s)\n\n", weapon)
      return
    end

    G.content.kind = "WEAPON"
    G.content.weapon = weapon
  end


  local function add_teleporter(R)
    if R.has_teleporter_closet then return end

    local conn = R:get_teleport_conn()
    
    local G = spot_for_wotsit("TELEPORTER")

    G.content.kind = "TELEPORTER"
    G.content.teleporter = conn  -- FIXME?

--[[ FIXME
        if conn.L1 == R then conn.C1 = C
    elseif conn.L2 == R then conn.C2 = C
    else   error("add_teleporter failure (bad conn?)")
    end
--]]

    -- prevent monsters being close to it (in target room)
    if R == conn.L2 then
      R:add_exclusion_zone("empty",     G.x1, G.y1, G.x2, G.y2, 224)
      R:add_exclusion_zone("nonfacing", G.x1, G.y1, G.x2, G.y2, 768)

      conn.L2:entry_coord_from_spot(G, 64)
    end
  end


  local function add_hub_gate(R, link)
    assert(link)

    -- FIXME
    if link.dest.kind == "SECRET" then
      gui.debugf("Skipping hub gate to secret level\n")
      return
    end

    local G = spot_for_wotsit("GATE")
    
    G.content.kind = "GATE"
    G.content.source_id = link.dest.local_map
    G.content.dest_id   = link.src .local_map
    G.content.dest_map  = link.dest.map
  end


  local function place_importants()
    R.goals = {}

    if R.purpose then add_purpose(R) end

    if R:has_teleporter() then add_teleporter(R) end

    each link in R.gates do
      add_hub_gate(R, link)
    end

    if R.weapons then
      each name in R.weapons do
        add_weapon(R, name)
      end
    end
  end


  local function extra_stuff()

    -- this function is meant to ensure good traversibility in a room.
    -- e.g. put a nice item in sections without any connections or
    -- importants, or if the exit is close to the entrance then make
    -- the exit door require a far-away switch to open it.

    -- TODO
  end


  local function fake_goal_spots()
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R then
        local SPOT =
        {
          x1 = S.x1 + 64
          y1 = S.y1 + 64
          x2 = S.x2 - 64
          y2 = S.y2 - 64
          z1 = 0
          z2 = 128
        }
        table.insert(R.goal_spots, SPOT)
      end
    end  -- sx, sy
    end
  end


  ---| Areas_place_importants |---

  if R.kind == "cave" or rand.odds(15) then
    cave_mode = true
  end

  if R.kind == "cave" then
    fake_goal_spots()
  end

  place_importants()

  extra_stuff()
end


----------------------------------------------------------------


function Areas_add_wall(R, kind, sx1, sy1, sx2, sy2, side, floor_h, conn)
  local WALL =
  {
    kind = kind
    sx1  = sx1, sy1 = sy1
    sx2  = sx2, sy2 = sy2
    side = side
    conn = conn
    floor_h = floor_h
  }

  table.insert(R.walls, WALL)

  -- put in seeds too

  sx1, sy1, sx2, sy2 = geom.side_coords(side, sx1, sy1, sx2, sy2)

  for sx = sx1, sx2 do
  for sy = sy1, sy2 do
    local S = SEEDS[sx][sy]

    S.walls[side] = WALL
  end
  end
end



function Areas_layout_with_prefabs(R)

  local skin2 =
  {
    wall  = R.wall_mat
    floor = R.floor_mat or R.wall_mat
    ceil  = R.ceil_mat  or R.wall_mat
  }


  local function convert_dir(dir, rot)
    if rot == 2 then return dir end
    if rot == 8 then return 10 - dir end

    if rot == 4 then return geom.LEFT [dir] end
    if rot == 6 then return geom.RIGHT[dir] end
  end


  local function convert_coord(sdx, sdy, skin, rot)
    --| sdx and sdy begin at _zero_

    local px, py

    if rot == 2 then
      px = 1 + sdx
      py = 1 + sdy

    elseif rot == 8 then
      px = skin.seed_w - sdx
      py = skin.seed_h - sdy

    elseif rot == 4 then
      px = skin.seed_w - sdy
      py = 1 + sdx

    elseif rot == 6 then
      px = 1 + sdy
      py = skin.seed_h - sdx
    end

    assert(1 <= px and px <= skin.seed_w)
    assert(1 <= py and py <= skin.seed_h)

    return px, py
  end


  local function new_floor_portal(kind, K, sx1, sy1, sx2, sy2, side)

    local PORTAL =
    {
      kind = kind
      sx1  = sx1, sy1 = sy1
      sx2  = sx2, sy2 = sy2
      side = side
      section = K
    }

    Portal_install(PORTAL)

    return PORTAL
  end


  local function add_exit_portals(K, dir, skin, rot)
    each exit in K.exits do
      if exit.dir != dir then continue end

      -- choose a single seed on this side
      -- !!! FIXME: check the edge map for walkable/solid parts
      -- TODO: support "wide" portals
      local mx = rand.irange(K.sx1, K.sx2)
      local my = rand.irange(K.sy1, K.sy2)

      local sx, sy = mx, my

      if dir == 4 then sx = K.sx1 end
      if dir == 6 then sx = K.sx2 end
      if dir == 2 then sy = K.sy1 end
      if dir == 8 then sy = K.sy2 end

      local S = SEEDS[sx][sy]
      local N = S:neighbor(dir)
      local K2 = N.section

      -- create a pair of portals
      -- (slightly overkill, but keeps things consistent)

      local po1 = new_floor_portal("floor_out", K,  S.sx, S.sy, S.sx, S.sy, dir)
      local po2 = new_floor_portal("floor_in",  K2, N.sx, N.sy, N.sx, N.sy, 10 - dir)

      po1.peer = po2
      po2.peer = po1

      exit.po1 = po1
      exit.po2 = po2
    end
  end


  local function process_edges(K, skin, rot, base_h)
    local map
    local fake_edge

    if skin then
      R.min_floor_h = math.min(R.min_floor_h, base_h)
      R.max_floor_h = math.max(R.max_floor_h, base_h + skin.max_floor_h)

      Fab_parse_edges(skin)

      map = assert(skin._seed_map)
    else
      fake_edge = { f_h=0 }
    end

    for dir = 2,8,2 do
      add_exit_portals(K, dir, skin, rot)      

      local sx1, sy1, sx2, sy2 = geom.side_coords(dir, K.sx1, K.sy1, K.sx2, K.sy2)

      for sx = sx1, sx2 do
      for sy = sy1, sy2 do
        local edge

        if skin then
          -- get coordinate in the prefab space
          local px, py = convert_coord(sx - K.sx1, sy - K.sy1, skin, rot)
          local pdir   = convert_dir(dir, rot)
--[[
stderrf("sx: %d (%d .. %d)\n", sx, K.sx1, K.sx2)
stderrf("sy: %d (%d .. %d)\n", sy, K.sy1, K.sy2)
stderrf("--> pcoord %d, %d\n", px, py)
stderrf("dir: %d ---> pdir: %d\n", dir, pdir)
stderrf("MAP =\n%s\n", table.tostr(map, 4))
--stderrf("portal: %s (%s)\n", tostring(portal), tostring(portal and portal.kind))
--]]
          edge = map[px][py].edges[pdir]
        else
          edge = fake_edge
        end

        local S = SEEDS[sx][sy]

        -- handles portals (entry and exit ways) : set floor_h
        local portal = S.portals[dir]

        if portal then
          local P = portal

          assert(edge and edge.f_h)

          if not P.floor_h then
            Portal_set_floor(P, base_h + edge.f_h)
          end

          if P.door_kind and not P.added_door then
            Areas_add_wall(R, P.door_kind, P.sx1, P.sy1, P.sx2, P.sy2, P.side, P.floor_h, P.conn)
            portal.added_door = true
          end

          continue
        end


        -- create walls
        if R.kind == "outdoor" then continue end

        local N = S:neighbor(dir)

        if N and N.room == R then continue end

        -- the room ends here, check if prefab was walkable

        if edge and edge.f_h then
          Areas_add_wall(R, "wall", sx, sy, sx, sy, dir, base_h + edge.f_h, nil)
        end

      end -- sx, sy
      end
    end -- dir
  end


  local function test_edges(K, skin, rot)
    --| check whether the edges of this prefab fit with connections

    local map = assert(skin._seed_map)

    -- this maps a portal --> relative height.  Trying to add two
    -- different heights to the same portal indicates a mismatch.
    local portal_heights = {}

    for dir = 2,8,2 do
      local sx1, sy1, sx2, sy2 = geom.side_coords(dir, K.sx1, K.sy1, K.sx2, K.sy2)

      for sx = sx1, sx2 do
      for sy = sy1, sy2 do
        -- get coordinate in the prefab space
        local px, py = convert_coord(sx - K.sx1, sy - K.sy1, skin, rot)
        local pdir   = convert_dir(dir, rot)

        local edge = map[px][py].edges[pdir]

        local S = SEEDS[sx][sy]

        local portal = S.portals[dir]

        if not portal then continue end  -- TODO: ignore windows

        -- there is a walkable portal here : require walkability in prefab
        if not (edge and edge.f_h) then return false end

        local exist_h = portal_heights[portal]

        if exist_h and math.abs(exist_h - edge.f_h) > 8 then return false end

        portal_heights[portal] = edge.f_h

      end -- sx, sy
      end
    end -- dir

    return true  -- OK
  end


  local function try_add_corner(S, dir)
    local dir_L = geom. LEFT_45[dir]
    local dir_R = geom.RIGHT_45[dir]

    local wall_L = S.walls[dir_L]
    local wall_R = S.walls[dir_R]

--[[
    if S:same_room(dir) or
       S:same_room(dir_L) or
       S:same_room(dir_R)
    then return end
--]]

    if not (wall_L and wall_R) then return end

    -- OK found a corner

    local CORNER =
    {
      kind = "corner"
      sx1 = S.sx, sy1 = S.sy
      sx2 = S.sx, sy2 = S.sy
      side = dir
      wall_L = wall_L
      wall_R = wall_R
    }

    table.insert(R.corners, CORNER)

    -- update WALL objects with the touching corner
    if wall_L then
      assert(not wall_L.corner_R)
      wall_L.corner_R = CORNER
    end

    if wall_R then
      assert(not wall_R.corner_L)
      wall_R.corner_L = CORNER
    end
  end


  local function try_add_outie(S, dir)
    -- this is for 270 degree corners
    local dir_L = geom. LEFT_45[dir]
    local dir_R = geom.RIGHT_45[dir]

    local NL = S:neighbor(dir_L)
    local NR = S:neighbor(dir_R)

    if not (NL and NL.room == R) then return end
    if not (NR and NR.room == R) then return end

    local wall_L = NL.walls[dir_R]
    local wall_R = NR.walls[dir_L]

    if not (wall_L and wall_R) then return end

    -- OK found an outie corner

    local CORNER =
    {
      kind = "outie"
      sx1 = S.sx, sy1 = S.sy
      sx2 = S.sx, sy2 = S.sy
      side = dir
      wall_L = wall_L
      wall_R = wall_R
    }

    table.insert(R.corners, CORNER)

    -- update WALL objects with the touching corner
    assert(not wall_L.corner_R)
    assert(not wall_R.corner_L)

    wall_L.corner_R = CORNER
    wall_R.corner_L = CORNER
  end


  local function find_corners()
    for sx = R.sx1, R.sx2 do
    for sy = R.sy1, R.sy2 do
      local S = SEEDS[sx][sy]

      if S.room == R then
        each dir in geom.DIAGONALS do
          try_add_corner(S, dir)
          try_add_outie (S, dir)
        end
      end

    end -- sx, sy
    end
  end


  local function debug_arrow(S, dir, f_h)
    local mx = math.i_mid(S.x1, S.x2)
    local my = math.i_mid(S.y1, S.y2)

    local dx, dy = geom.delta(dir)
    local ax, ay = geom.delta(geom.RIGHT[dir])

    mx = mx + dx * 20
    my = my + dy * 20

    local brush =
    {
      { x = mx - ax * 30, y = my - ay * 30, tex = "COMPBLUE" }
      { x = mx + ax * 30, y = my + ay * 30, tex = "COMPBLUE" }
      { x = mx + dx * 90, y = my + dy * 90, tex = "COMPBLUE" }
      { t = f_h, tex = "FWATER1" }
    }

    brush_helper(brush)
  end

  
  local function recurse_find_path(K, from_dir)
    K.visited_for_path = true

    K.exits = {}

    local mx = math.i_mid(K.sx1, K.sx2)
    local my = math.i_mid(K.sy1, K.sy2)

    each dir in rand.dir_list() do
      if dir == from_dir then continue end

      local sx, sy = mx, my

      if dir == 4 then sx = K.sx1 end
      if dir == 6 then sx = K.sx2 end
      if dir == 2 then sy = K.sy1 end
      if dir == 8 then sy = K.sy2 end

      local S = SEEDS[sx][sy]

      assert(S and S.section == K)

      local N = S:neighbor(dir)

      if not (N and N.room == R) then continue end

      local K2 = N.section
      assert(K2 != K)
      assert(K2.room == R)

      if K2.visited_for_path then continue end

      --- debug_arrow(S, dir, R.entry_h + 8)

      table.insert(K.exits, { dir=dir, neighbor=K2 })

      recurse_find_path(K2, 10 - dir)
    end
  end


  local function path_through_room()
    --| recursively visit sections to define the path through the
    --| room, stored in the entry and exit fields in each section.

    --| TODO: probably just do this DURING recurse_make_stuff
    --|       (otherwise: explain why separate pass is needed)

    local D = R.entry_conn

    local start_K
    local start_side
    local start_portal

    if D and D.kind != "teleporter" then
      if D.L1 == R then
        start_K = D.K1
        start_side = D.dir1
        start_portal = D.portal1
      elseif D.L2 == R then
        start_K = D.K2
        start_side = D.dir2
        start_portal = D.portal2
      else
        error("path_through_room: cannot find entry section")
      end

    else
      -- TODO: pick section furthest from any connections
      start_K = rand.pick(R.sections)
      start_side = 5  -- "middle"
      -- no start portal
    end

    R.start_K      = assert(start_K)
    R.start_side   = assert(start_side)
    R.start_portal = start_portal

    recurse_find_path(start_K, start_side)

    each K in R.sections do
      assert(K.visited_for_path)
    end

--[[  TEMP CRUD
    if start_side != 5 then
      local x1, y1, x2, y2 = start_K:get_coords()
      local mx, my = start_K:mid_point()
      x1, y1, x2, y2 = geom.side_coords(start_side, x1,y1, x2,y2)
      mx = (mx + (x1 + x2) * 2) / 5
      my = (my + (y1 + y2) * 2) / 5
      R.entry_coord = { x=mx, y=my, z=R.entry_h }
    end
--]]
  end


  local function test_prefab(K, skin, mode, rot)
    --| rot is the direction 2/4/6/8 where the south end of the prefab
    --| will be place.  So rot == 2 means no rotation.
    --|
    --| result is a relative probability (higher is better).

    -- test that this rotation fits
    local rw = skin.seed_w
    local rh = skin.seed_h

    if geom.is_horiz(rot) then
      rw, rh = rh, rw
    end

    if (rw != K.sw) then return 0 end
    if (rh != K.sh) then return 0 end

    -- test that the prefab connects with its environment
    -- (especially connections in/out of the room)

    if mode == "floor" then
      if not test_edges(K, skin, rot) then return 0 end
    end

    return 50
  end


  local function prefab_entry_diff(K, from_portal, skin, rot)
    if not from_portal then return 0 end

    -- Note: assumes portal is a single seed
    local side = from_portal.side

    local sx = from_portal.sx1
    local sy = from_portal.sy1

    if side == 8 then sy = from_portal.sy2 end


    local S = SEEDS[sx][sy]
    local N = S:neighbor(side)


    local px, py = convert_coord(sx - K.sx1, sy - K.sy1, skin, rot)
    local pdir   = convert_dir(side, rot)

    local edge = skin._seed_map[px][py].edges[pdir]

    assert(edge)
    assert(edge.f_h)

    return edge.f_h
  end


  local function try_build_prefab(K, skin, mode, from_portal)
    --| mode can be "floor" or "ceiling"

    Fab_parse_edges(skin)

    local rot_probs = {}

    for rot = 2,8,2 do
      local prob = test_prefab(K, skin, mode, rot)

      if prob > 0 then
        rot_probs[rot] = prob
      end
    end

    if table.empty(rot_probs) then return false end

    local rot = rand.key_by_probs(rot_probs)


    local diff_h = prefab_entry_diff(K, from_portal, skin, rot)

    K.floor_h = K.floor_h - diff_h

    local T = Trans.section_transform(K, rot)

    Fabricate_at(R, skin, T, { skin, skin2 })

    process_edges(K, skin, rot, K.floor_h)

    return true
  end


  local function build_floor(K, from_portal)
    local env =
    {
      seed_w = math.max(K.sw, K.sh)
      seed_h = math.min(K.sw, K.sh)

      room = R.kind
    }

    local reqs1 =
    {
      kind = "floor"
    }

    local req_list = { reqs1 }

    if R.kind != "outdoor" then
      local reqs2 =
      {
        kind = "room"
      }
      table.insert(req_list, reqs2)
    end


    local list = Room_match_skins(env, req_list)

    -- this "NONE" value is here to handle a small number of possible
    -- prefabs, especially when they have low probs.
    list["NONE"] = 90

    -- cf. this stopping logic is to handle large numbers of prefabs,
    -- where we want to sometimes have nothing at all, but also limit
    -- the amount of prefabs we try (for performance reasons).
    local stop_prob = 20

    while not table.empty(list) do
      if rand.odds(stop_prob) then return false end
      stop_prob = stop_prob + 10

      local skin_name = rand.key_by_probs(list)
      list[skin_name] = nil

      if skin_name == "NONE" then return false end

      local skin = assert(GAME.SKINS[skin_name])

      if try_build_prefab(K, skin, "floor", from_portal) then
        if skin.kind == "room" or (not skin.kind and string.match(skin.file, "^room")) then
          K.whole_room = true
        end

        K.floor_complexity = skin.complexity or 1

        return true  -- YES!!
      end
    end

    return false  -- nothing worked
  end


  local function try_build_ceiling_fab(K, skin, from_portal)
    local rot

    -- pick a usable rotation
    if K.sw == K.sh then
      rot = rand.dir()
    elseif (K.sw == skin.seed_w) and (K.sh == skin.seed_h) then
      rot = rand.sel(50, 2, 8)
    else
      rot = rand.sel(50, 4, 6)
    end

    local T = Trans.section_transform(K, rot)
    T.add_z = K.ceil_h

    Fabricate_at(R, skin, T, { skin, skin2 })

    return true
  end


  local function build_ceiling(K, from_portal)
    -- never have ceiling prefabs in outdoor rooms
    if R.kind == "outdoor" then return false end

    local env =
    {
      seed_w = math.max(K.sw, K.sh)
      seed_h = math.min(K.sw, K.sh)

      room = R.kind
    }

    local reqs =
    {
      kind = "ceiling"

      max_complexity = 3 - K.floor_complexity
    }

    local list = Room_match_skins(env, { reqs })


    -- see 'build_floor' for a description of this stopping logic
    list["NONE"] = 90

    local stop_prob = 10

    while not table.empty(list) do
      if rand.odds(stop_prob) then return false end
      stop_prob = stop_prob + 20

      local skin_name = rand.key_by_probs(list)
      list[skin_name] = nil

      if skin_name == "NONE" then return false end

      local skin = assert(GAME.SKINS[skin_name])

      if try_build_ceiling_fab(K, skin, from_portal) then
        return true  -- YES!!
      end
    end

    return false  -- nothing worked
  end


  local function fallback_floor_piece(skin, sx1, sy1, sx2, sy2, floor_h)
    local S1 = SEEDS[sx1][sy1]
    local S2 = SEEDS[sx2][sy2]

    local T = Trans.box_transform(S1.x1, S1.y1, S2.x2, S2.y2, floor_h, 2)

    Fabricate_at(R, skin, T, { skin, skin2 })
  end


  local function fallback_floor(K)
---    skin2.floor = K.floor_mat

    local env =
    {
      seed_w = 1
      seed_h = 1

      room = R.kind
    }

    local reqs =
    {
      kind = "plain_floor"
    }

    local whole = false

    if K.sw == 3 and K.sh == 3 then
      whole = true
      env.seed_w = 3
      env.seed_h = 3
    end

    local skin = Room_pick_skin(env, { reqs })

    if whole then
      fallback_floor_piece(skin, K.sx1, K.sy1, K.sx2, K.sy2, K.floor_h)
    else
      for sx = K.sx1, K.sx2 do
      for sy = K.sy1, K.sy2 do
        fallback_floor_piece(skin, sx, sy, sx, sy, K.floor_h)
      end
      end
    end

    process_edges(K, nil, 2, K.floor_h)

    K.floor_complexity = 0
  end


  local function fallback_ceil_piece(S, ceil_h)
    if R.kind == "outdoor" then
      local rect =
      {
        x1 = S.x1, y1 = S.y1
        x2 = S.x2, y2 = S.y2
      }

      table.insert(R.sky_rects, rect)
    else
      local brush = Brush_new_quad(S.x1, S.y1, S.x2, S.y2, ceil_h, nil)

      Brush_set_mat(brush, skin2.ceil, skin2.ceil)

      brush_helper(brush)
    end
  end


  local function fallback_ceiling(K)
    for sx = K.sx1, K.sx2 do
    for sy = K.sy1, K.sy2 do
      fallback_ceil_piece(SEEDS[sx][sy], K.ceil_h)
    end
    end
  end


  local function ambush_focus_for_section(K, floor_h, from_portal)
    -- usually happens only for START room
    if not from_portal then return nil end

    local dir = 10 - from_portal.side
    local angle = geom.ANGLES[dir]

    local mx, my = Portal_mid_point(from_portal)
    local dx, dy = geom.delta(dir)

    mx = mx + dx * 70
    my = my + dy * 70

    return { x=mx, y=my, z=floor_h + 40, angle=angle }
  end


  local function can_reuse_ambush_focus(last_K, A)
    if not last_K then return false end
    if not last_K.ambush_focus then return false end

    local B = last_K.ambush_focus

    if geom.dist(A.x, A.y, B.x, B.y) >= 800 then return false end

    if math.abs(A.z - B.z) >= 96 then return false end

    return true
  end


  local function build_section(K, floor_h, from_portal, last_K)
    K.floor_h = floor_h
    K.ceil_h  = floor_h + 192 ---- rand.pick({128,192,192,256})

    R.min_floor_h = math.min(R.min_floor_h, floor_h)
    R.max_floor_h = math.max(R.max_floor_h, floor_h)

    if not build_floor(K, from_portal) then
      fallback_floor(K)
    end

    if not K.whole_room then
      if not build_ceiling(K, from_portal) then
        fallback_ceiling(K)
      end
    end

    -- decide ambush focus point
    local amb = ambush_focus_for_section(K, floor_h, from_portal)

    if not amb and not last_K then return end

    if not amb or can_reuse_ambush_focus(last_K, amb) then
      assert(last_K)
      K.ambush_focus = last_K.ambush_focus  -- may be NIL
    else
      K.ambush_focus = amb
--!!!!! FIXME
stderrf("new ambush focus @ %s : (%d %d)\n", K:tostr(), amb.x, amb.y)
      entity_helper("skull_rock", amb.x, amb.y, amb.z, { angle=amb.angle })
    end
  end


  local function recurse_make_stuff(K, floor_h, from_portal, last_K)
    build_section(K, floor_h, from_portal, last_K)

    each exit in K.exits do
      -- get the one inside the neighbor
      local portal = exit.po2

      assert(portal.floor_h)

      recurse_make_stuff(portal.section, portal.floor_h, portal, K)
    end
  end


  ---| Areas_layout_with_prefabs |---

  path_through_room()

local mats = { "FLAT1", "FLAT10", "CEIL1_1", "CEIL1_2",
               "FLAT1_1", "DEM1_5", "FLAT4", "FLAT5_3",
               "FLAT20", "FLAT5_6", "MFLR8_3", "RROCK19" }
each K in R.sections do
  K.floor_mat = mats[1 + _index % 12]
end

  recurse_make_stuff(R.start_K, R.entry_h, R.start_portal)

  if R.kind != "outdoor" then
    find_corners()
  end
end



function Areas_build_walls(R)

  local THICK = 32


  local function do_wall(info)
    -- determine room on other side
    local L2

    if info.conn then
      L2 = info.conn:neighbor(R)
    else
      local nx, ny = geom.nudge(info.sx1, info.sy1, info.side)

      if Seed_valid(nx, ny) then
        local S = SEEDS[nx][ny]

        if S then
          L2 = S.room or S.hall
        end

        -- sanity check
        if L2 == R then L2 = nil end
      end
    end


    --- select prefab ---

    local env =
    {
      room = R.kind
    }

    if L2 then
      env.neighbor = L2.kind
    end

    local reqs =
    {
      kind  = info.kind
      where = "edge"
    }

    if info.kind == "arch" then
      reqs.group = LEVEL.hall_group
    end


    local lock = info.conn and info.conn.lock

    if lock then
      reqs.key    = lock.key
      reqs.switch = lock.switch
    end

    
    local skin = Room_pick_skin(env, { reqs })


    --- texturing ---

    local skin2 =
    {
      wall  = R.wall_mat
      floor = R.floor_mat or R.wall_mat
      ceil  = R.ceil_mat  or R.wall_mat
    }

    if L2 then
      skin2.outer = L2.wall_mat

      if  R.is_outdoor then skin2.wall  = L2.zone.facade_mat end
      if L2.is_outdoor then skin2.outer =  R.zone.facade_mat end
    end

    if lock and lock.kind == "SWITCH" then
      skin2.tag_1 = lock.tag
      skin2.targetname = string.format("switch%d", lock.tag)
    
    elseif lock and lock.kind == "KEY" then
      -- Quake II bits
      skin2.keyname = lock.key
      skin2.targetname = "door" .. Plan_alloc_id("door")
    end


    --- determine coords ---

    local S1 = SEEDS[info.sx1][info.sy1]
    local S2 = SEEDS[info.sx2][info.sy2]

    local x1, y1, x2, y2 = S1.x1, S1.y1, S2.x2, S2.y2

    local thick = assert(skin.deep)

    if info.side == 2 then y2 = y1 + thick end
    if info.side == 8 then y1 = y2 - thick end
    if info.side == 4 then x2 = x1 + thick end
    if info.side == 6 then x1 = x2 - thick end

    -- adjust for nearby corner
    local dir_L = geom. LEFT[info.side]
    local dir_R = geom.RIGHT[info.side]

    if info.corner_L and info.corner_L.kind != "outie" then
      local thick = assert(info.corner_L.deep)
      if dir_L == 2 then y1 = y1 + 64 end
      if dir_L == 8 then y2 = y2 - 64 end
      if dir_L == 4 then x1 = x1 + 64 end
      if dir_L == 6 then x2 = x2 - 64 end
    end

    if info.corner_R and info.corner_R.kind != "outie" then
      local thick = assert(info.corner_R.deep)
      if dir_R == 2 then y1 = y1 + 64 end
      if dir_R == 8 then y2 = y2 - 64 end
      if dir_R == 4 then x1 = x1 + 64 end
      if dir_R == 6 then x2 = x2 - 64 end
    end

    assert(info.floor_h)

    local T = Trans.box_transform(x1, y1, x2, y2, info.floor_h, info.side)

    
    --- build it ---

    Fabricate_at(R, skin, T, { skin, skin2 })

    R:clip_spots(x1, y1, x2, y2)
  end


  local function do_corner(info)

    --- texturing ---

    local skin2 =
    {
      wall  = R.wall_mat
      floor = R.floor_mat or R.wall_mat
      ceil  = R.ceil_mat  or R.wall_mat
    }

    -- determine coords
    local S = SEEDS[info.sx1][info.sy1]

    local x1, y1 = S.x1, S.y1
    local x2, y2 = S.x2, S.y2

    info.deep = sel(info.kind == "outie", 1, 2) * THICK;

    if info.side == 1 or info.side == 3 then
      y2 = y1 + info.deep
    else
      y1 = y2 - info.deep
    end

    if info.side == 1 or info.side == 7 then
      x2 = x1 + info.deep
    else
      x1 = x2 - info.deep
    end

    local dir = geom.LEFT_45[info.side]

    local floor_h = 0  -- FIXME

    local T = Trans.box_transform(x1, y1, x2, y2, floor_h, dir)

    local skin1

    -- FIXME: pick prefab properly !!!!
    if info.kind == "outie" then
      skin1 = assert(GAME.SKINS["Corner_curved_o"])
    else
      skin1 = assert(GAME.SKINS["Corner_support"])
    end

    Fabricate_at(R, skin1, T, { skin1, skin2 })

    R:clip_spots(x1, y1, x2, y2)
  end


  ---| Areas_build_walls |---

  -- must build corners first since their size can vary, and the walls
  -- will need to know what size was actually used.

  each info in R.corners do
    do_corner(info)
  end

  each info in R.walls do
    do_wall(info)
  end
end



function Areas_flesh_out()
  --|
  --| this creates the actual walkable areas in each room, making sure
  --| that ensures the player can traverse the room, i.e. reach all the
  --| connections and importants.  It also adds in scenic stuff like
  --| liquids, thick walls, pillars (etc).
  --|

  local pass_h = GAME.ENTITIES.player1.h + (PARAM.step_height or 16) + 8


  --
  -- CROSS-OVER NOTES:
  --
  -- +  when a room has a visited crossover, limit area heights
  --    (e.g. bridge : max_h, channel : min_h) and the entry
  --    hallway must account for that too.
  --
  -- +  when a room has unvisited crossover, determine height
  --    using room's min/max floor_h and the entry hallway of the
  --    crossover must account for that when reached.
  --

  local function initial_height(R)
-- stderrf("initial_height in %s\n", R:tostr())

    local entry_h
    
    if R.entry_conn and R.entry_conn.kind != "teleporter" then
      local portal = R.entry_conn.portal1 or R.entry_conn.portal2
      assert(portal)
      entry_h = assert(portal.floor_h)
    else
      entry_h = rand.pick({ -128, -64, 0, 0, 0, 64, 128 })
    end

    if not R:in_floor_limit(entry_h) then
      gui.debugf("WARNING !!!! entry_h not in floor_limit\n")

      if entry_h < R.floor_limit[1] then
         entry_h = R.floor_limit[1]
      else
         entry_h = R.floor_limit[2]
      end
    -- !!!! FIXME: entry hallway will need to compensate (have a stair or whatever)
    end

    R.entry_h = entry_h

    R.min_floor_h = R.entry_h
    R.max_floor_h = R.entry_h
  end


  local function pick_floor_tex(R, A)
    local source = R.theme.floors or THEME.floors

    if not source then
      error("missing floor materials in theme")
    end
    
    local tab = table.copy(source)

    A.floor_mat = rand.key_by_probs(tab)
  end


  local function crossover_room(R)
    local hall = R.crossover_hall

    if not hall then return end

    -- already visited?
    if hall.done_heights then return end

    -- TODO: analyse nearby chunks to get min/max floor_h
    local min_h = R.min_floor_h
    local max_h = R.max_floor_h

    local diff = hall:cross_diff()

    if hall.cross_mode == "bridge" then
      hall.cross_limit = { max_h + diff, 9999 }
    else
      hall.cross_limit = { -9999, min_h - (PARAM.jump_height or 32) - 40 }
    end
  end


  local function outgoing_heights(L)
    each D in L.conns do
      local portal = D.portal1 or D.portal2

      if D.L1 == L and D.L2.kind == "hallway" and D.kind != "double_R" then
        assert(portal)
        assert(portal.floor_h)

        local hall = D.L2

        -- cycles hallways are done after everything else
        if not hall.is_cycle then
          hall:floor_stuff(D)
        end

        -- recursively handle hallway networks
        outgoing_heights(hall)
      end

      -- for direct room-to-room connections (Street mode, Closets)
      if D.L1 == L and D.kind != "teleporter" and
         L.kind != "hallway" and D.L2.kind != "hallway"
      then
        assert(portal)
        assert(portal.floor_h)
      end
    end
  end


  local function outgoing_cycles(L)
    each D in L.conns do
      if D.L1 == L and D.L2.kind == "hallway" and D.L2.is_cycle then
        local hall = D.L2

        hall:floor_stuff(D)
      end
    end
  end


  local function calc_entry_coord(R)
    local D = R.entry_conn

    if not D or not R.entry_h then return end

    -- teleporters are done elsewhere
    if R.entry_conn.kind == "teleporter" then return end

    if R.entry_coord then return end

    local start_K
    local start_dir

    if D.L1 == R then
      start_K = D.K1
      start_side = D.dir1
    else
      start_K = D.K2
      start_side = D.dir2
    end

    if not start_K then return end

    R:entry_coord_from_section_side(start_K, start_side)
  end


  local function floor_stuff(R)
-- stderrf("AREA floor_stuff @ %s\n", R:tostr())

    R:compute_wall_dists()

    initial_height(R)

    if R.kind == "cave" then
      Areas_place_importants(R)

      Simple_cave_or_maze(R)
    else
      Areas_layout_with_prefabs(R)
    end

    R.done_heights = true

    if R.kind != "cave" then
      --?? floor_textures(R)

      Areas_place_importants(R)

      R:exclude_monsters_in_zones()
    end

    calc_entry_coord(R)
    outgoing_heights(R)
    crossover_room(R)
  end


  local function finish_up_room(R)

    -- TODO add "area" prefabs now (e.g. crates, cages, bookcases)

--[[  ???
    each A in R.areas do
      A:decide_picture()
      A.use_fence = rand.odds(80)
    end
--]]
  end


  local function prepare_ceiling(R)
    local h = R.crossover_max_h or R.max_floor_h

    h = h + rand.pick { 192, 256, 320 }

    if R.is_outdoor then
      R.sky_group.h = math.max(R.sky_group.h or -768, h)
    else
      R.ceil_h = h
    end
  end


  local function ceiling_stuff(R)
    prepare_ceiling(R)
  end


  local function can_make_window(K, dir)
    local N = K:neighbor(dir)

    if not N then return false end

    if N.room == K.room then return false end

    -- fixme?
  end


  local function try_add_window(R, dir, quota)
    each K in R.sections do
      if can_make_window(K, dir) then
        add_window(K, dir)
      end
    end
  end


  local function decide_windows(R)
    if STYLE.windows == "none" then return end

    local quota = style_sel("windows", 0, 20, 40, 80)

    each dir in rand.dir_list() do
      try_add_window(R, dir, quota)
    end
  end


  ---| Areas_flesh_out |---

  each R in LEVEL.rooms do floor_stuff(R) end
  each R in LEVEL.rooms do outgoing_cycles(R) end

  Room_decide_fences()

  each R in LEVEL.rooms do Areas_build_walls(R) end

--each R in LEVEL.rooms do decide_windows(R) end
  each R in LEVEL.rooms do ceiling_stuff(R) end

  each R in LEVEL.rooms do finish_up_room(R) end
end


----------------------------------------------------------------


function Areas_kick_the_goals(L)

  local function mid_point(G)
    return geom.box_mid(G.x1, G.y1, G.x2, G.y2)
  end


  local function do_big_item(G, item_name)
    local env = { room = L.kind }

    local reqs =
    {
      kind  = "item"
      where = "middle"
    }

    local skin1 = Room_pick_skin(env, { reqs })

    local skin2 = { item = item_name }
    local skin0 = { wall = L.wall_mat }

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, G.spot_dir)

    Fabricate_at(L, skin1, T, { skin0, skin1, skin2 })
  end


  local function content_start(G)
    local env = { room = L.kind }

    local reqs =
    {
      kind  = "start"
      where = "middle"
    }

    local skin1 = Room_pick_skin(env, { reqs })
    local skin2 = { }

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, 10 - G.spot_dir)

    Fabricate_at(L, skin1, T, { skin1, skin2 })
  end


  local function content_exit(G)
    local env = { room = L.kind }

    local reqs =
    {
      kind  = "exit"
      where = "middle"
    }

    local skin1 = Room_pick_skin(env, { reqs })

    local skin0 = { wall = L.wall_mat }
    local skin2 = { next_map = LEVEL.next_map, targetname = "exit" }

    -- Hexen: on last map, exit will end the game
    if OB_CONFIG.game == "hexen" and not LEVEL.next_map then
      skin2.special = 75
    end

    -- FIXME: hack for secret exits (assumes DOOM/HERETIC)
    if G.content.kind == "SECRET_EXIT" then
      skin2.special = 51
    end

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, G.spot_dir)

    Fabricate_at(L, skin1, T, { skin0, skin1, skin2 })
  end


  local function content_key(G)
    do_big_item(G, assert(G.content.key))
  end


  local function content_switch(G)
    local lock = G.content.lock

    assert(lock)
    assert(lock.switch)

    local env = { room = L.kind }

    local reqs =
    {
      kind  = "switch"
      where = "middle"
      key   = lock.key
      switch = lock.switch
    }

    local skin1 = Room_pick_skin(env, { reqs })

    local skin2 = { tag_1=lock.tag }
    
    skin2.target = string.format("switch%d", skin2.tag_1)

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, G.spot_dir)

    Fabricate_at(L, skin1, T, { skin1, skin2 })
  end


  local function content_teleporter(G)
    local env = { room = L.kind }

    local reqs =
    {
      kind  = "teleporter"
      where = "middle"
    }

    local skin1 = Room_pick_skin(env, { reqs })

    local skin0 = { wall = L.wall_mat }
    local skin2 = {}

    local conn = assert(G.content.teleporter)

    if conn.L1 == L then
      skin2. in_tag = conn.tele_tag2
      skin2.out_tag = conn.tele_tag1
    else
      skin2. in_tag = conn.tele_tag1
      skin2.out_tag = conn.tele_tag2
    end

    skin2. in_target = string.format("tele%d", skin2. in_tag)
    skin2.out_target = string.format("tele%d", skin2.out_tag)

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, 10 - G.spot_dir)

    Fabricate_at(L, skin1, T, { skin0, skin1, skin2 })

  --[[ TRIGGER TEST

    local brush = Brush_new_quad(mx - 140, my + 96, mx + 642, my + 128)

    brush[1].special = 1001
    brush[1].tag = 2002

    table.insert(brush, 1, { m="trigger" })

    brush_helper(brush)
  --]]
  end


  local function content_hub_gate(G)
    local env = { room = L.kind }

    local reqs  =
    {
      kind  = "hub_gate"
      where = "middle"
    }

    local skin1 = Room_pick_skin(env, { reqs })

    local skin0 = { wall = G.wall_mat }
    local skin2 = {}

    skin2.source_id  = G.content.source_id
    skin2.  dest_id  = G.content.dest_id
    skin2.  dest_map = G.content.dest_map

  -- stderrf("content_hub_gate: to map %d : %d --> %d\n", skin2.dest_map, skin2.source_id, skin2.dest_id)

  ---FIXME Hexen II and Quake II support
  ---??  skin2. in_target = string.format("tele%d", skin2. in_tag)
  ---??  skin2.out_target = string.format("tele%d", skin2.out_tag)

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, 10 - G.spot_dir)

    Fabricate_at(L, skin1, T, { skin0, skin1, skin2 })
  end


  local function do_hexen_triple(G)

    -- FIXME: this is temp hack !!!
    local skin_map =
    {
      weapon2 = "Weapon2_Set"
      weapon3 = "Weapon3_Set"

      piece1  = "Piece1_Set"
      piece2  = "Piece2_Set"
      piece3  = "Piece3_Set"
    }

    local name  = assert(skin_map[G.content.weapon])
    local skin1 = assert(GAME.SKINS[name])

    local skin0 = { wall = L.wall_mat }
    local skin2 = { }

    local mx, my = mid_point(G)

    local T = Trans.spot_transform(mx, my, G.z1, G.spot_dir)

    Fabricate_at(L, skin1, T, { skin0, skin1, skin2 })
  end


  local function content_weapon(G)
    -- Hexen stuff
    local weapon = G.content.weapon

    if OB_CONFIG.game == "hexen" and
       (weapon == "weapon2" or weapon == "weapon3" or
        weapon == "piece1" or weapon == "piece2" or weapon == "piece3")
    then
      do_hexen_triple(G)
    else
      do_big_item(G, weapon)
    end
  end


  local function do_content(G)
    local kind = G.content.kind

    if not kind then return end

    if kind == "START" then
      content_start(G)

    elseif kind == "EXIT" or kind == "SECRET_EXIT" then
      content_exit(G)

    elseif kind == "KEY" then
      content_key(G)

    elseif kind == "SWITCH" then
      content_switch(G)

    elseif kind == "WEAPON" then
      content_weapon(G)

    elseif kind == "TELEPORTER" then
      content_teleporter(G)

    elseif kind == "GATE" then
      content_hub_gate(G)

    else
      error("Unknown goal kind: " .. tostring(kind))
    end
  end


  ---| Areas_kick_the_goals |---

  if not L.goals then return end

  each G in L.goals do
    do_content(G)

    -- ensure monsters or items won't be placed here
    if L.kind != "hallway" then
      L:clip_spots(G.x1, G.y1, G.x2, G.y2)
    end
  end
end

