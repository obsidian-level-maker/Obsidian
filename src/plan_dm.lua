----------------------------------------------------------------
-- PLANNER : DeathMatch
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006 Andrew Apted
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


DM_WEAPON_LIST = { saw=10, shotty=60, super=40, chain=20,
  launch=40, plasma=30, bfg=5 }


function show_dm_links(p)

  local function show_cell(c,ky)

    local function chk(kx)
      if not c then return " " end

      local side = (ky-1)*3 + kx
      local link = c.link[side]

      if not link then return " " end

      local dx, dy = dir_to_delta(side)

      if dx < 0 then return "<" end
      if dx > 0 then return ">" end

      if dy < 0 then return "v" end
      if dy > 0 then return "^" end

      return "?"
    end

    for kx = 1,3 do
      io.stderr:write(chk(kx))
    end
    io.stderr:write("|")
  end

  local function divider(len)
    for i = len,1,-1 do
      io.stderr:write("---+")
    end
    io.stderr:write("\n")
  end

  -- BEGIN show_dm_links --

  divider(p.w)

	local x, y
	for y = p.h,1,-1 do
    for row = 3,1,-1 do
      for x = 1,p.w do
        show_cell(p.cells[x][y], row)
      end
      io.stderr:write("\n")
	  end
    divider(p.w)
	end
end


function plan_dm_arena()

	local p = get_base_plan(PL_W, PL_H)

  p.deathmatch = true


  local function insert_link(c, dir)
    local dx, dy = dir_to_delta(dir)
    local other = p.cells[c.x+dx][c.y+dy]

    create_link(p, c, other, dir)
  end

  local function initial_links()
    for x = 1,p.w do
      for y = 1,p.h do
        if x < p.w then insert_link(p.cells[x][y], 6) end
        if y < p.h then insert_link(p.cells[x][y], 8) end
      end
    end
  end

  local function test_coverage()
    local visited = array_2D(p.w, p.h)
    local count

    visited[1][1] = true  -- seed point
    
    for loop = 1,(p.w + p.h + 10) do
      count = 0

      -- flood-fill type algorithm
      for x = 1,p.w do
        for y = 1,p.h do
          local c = p.cells[x][y]
          if visited[x][y] then
            count = count + 1
            for dir = 2,8,2 do
              if c.link[dir] then
                local other = link_other(c.link[dir], c)
                visited[other.x][other.y] = true
                assert(other.link[10 - dir] == c.link[dir])
              end
            end
          end
        end
      end
    end
io.stderr:write("COVERAGE: ", count, "\n")
    return count == (p.w * p.h)
  end

  local function remove_dm_links(num)
    initial_links()

    local coords = {}
    local index = 1
    rand_shuffle(coords, p.w * p.h * 2)

    local x, y, dir

    local function decode_next()
      if index > #coords then return false end

      x = coords[index] - 1
      index = index + 1

      dir = ((x % 2) == 0) and 6 or 8
      x = math.floor(x / 2)
      
      y = 1 + math.floor(x / p.w)
      x = 1 + (x % p.w)

      return true
    end

    local function remove_one_link()
      while decode_next() do
        if (x == p.w and dir == 6) or
           (y == p.h and dir == 8) then
          -- ignore the invalid links
        else
          local c = p.cells[x][y]

          if c.link[dir] then
            other = link_other(c.link[dir], c)

            if links_in_cell(c) > 2 and links_in_cell(other) > 2 then
              c.link[dir] = nil
              other.link[10 - dir] = nil
              return
            end
          end
        end
      end
    end

    for idx = 1,num do
      remove_one_link()
    end

    return test_coverage()
  end

  local function empty_dm_loc()
    for loop = 1,999 do
      local x,y = random_cell(p)
      if p.cells[x][y] and
         not p.cells[x][y].dm_player and
         not p.cells[x][y].dm_weapon then return x, y
      end
    end
  end

  local function assign_dm_players()
    con.ticker();

    local num_spots = math.floor(p.w * p.h * 0.4)

    if num_spots < 4 then num_spots = 4 end

    for zzz = 1,num_spots do
      local x,y = empty_dm_loc()
      if not x then error("No place for DM player!") end
      p.cells[x][y].dm_player = true
    end
  end

  local function choose_weapon()
    local wp_names = {}
    local wp_probs = {}

    for name,prob in pairs(DM_WEAPON_LIST) do
      local used_count = p.used_items[name] or 0

      table.insert(wp_names, name)
      table.insert(wp_probs, prob / (1 + used_count))
    end

    local idx = rand_index_by_probs(wp_probs)
    local name = wp_names[idx]

    -- increase usage count
    p.used_items[name] = 1 + (p.used_items[name] or 0)
    return name
  end

  local function assign_dm_weapons()
    con.ticker();

    local chance = 90
    if p.w == 4 then chance = 80 end
    if p.w == 5 then chance = 70 end
    
    for x = 1,p.w do
      for y = 1,p.h do
        if not rand_odds(chance) then
          -- tough titties
        elseif not p.cells[x][y].dm_player then
          p.cells[x][y].dm_weapon = choose_weapon()
io.stderr:write("WEAPON === ", p.cells[x][y].dm_weapon, "\n")
        end
      end
    end
  end

  local function unused_theme_pos()
    for loop = 1,999 do
      local x,y = random_cell(p)
      if not p.cells[x][y].theme then return x, y end
    end
  end

  local function grow_dm_themes()
    local x_order = {}
    local y_order = {}
    local dir_order = { 2,4,6,8 }

    rand_shuffle(x_order, p.w)
    rand_shuffle(y_order, p.h)
    rand_shuffle(dir_order)

    for zz1,cx in ipairs(x_order) do
      for zz2,cy in ipairs(y_order) do
        for zz3,dir in ipairs(dir_order) do
          local dx, dy = dir_to_delta(dir)
          local c = p.cells[cx][cy]
          assert(c)

          if c.theme and valid_cell(p, cx+dx,cy+dy) then
            local other = p.cells[cx+dx][cy+dy]
            if not other.theme then
              other.theme = c.theme
            end
          end
        end
        rand_shuffle(dir_order)
      end
      rand_shuffle(y_order)
    end
  end

  local function choose_dm_themes()
    -- how many themes?
    local min_t = 1
    if p.h >= 4 then min_t = 2 end
    if p.w >= 6 then min_t = 3 end

    local num_themes = math.random(min_t, p.h)
    assert(num_themes <= #ALL_THEMES)
io.stderr:write("NUMBER of THEMES: ", num_themes, "\n")

    local theme_list = {}
    rand_shuffle(theme_list, #ALL_THEMES)

    -- place themes at random spots on the plan,
    -- then "grow" them until all cells are themed.
    for i =1,num_themes do
      local cx, cy = unused_theme_pos()
      if cx then
        p.cells[cx][cy].theme = ALL_THEMES[theme_list[i]]
      end
    end

    for pass = 1,(p.w+p.h+4) do
      grow_dm_themes()
      con.ticker();
    end
  end

  ---=== plan_dm_arena ===---

  local W = rand_index_by_probs{ 0,0,70,90,50,20 }
  local H = W

  -- occasionally create very small maps (3x2 and 4x2)
  if H > 3 and rand_odds(30) then H = H - 1 end
  if H > 2 and rand_odds( 3) then H = H - 1 end

  assert(W <= p.w and H <= p.h)

  p.w, p.h = W, H

  local min_links = W * H
  local max_links = W * (H-1) + H * (W-1)

  -- dummy quest
  p.quests[1] =
  {
    level = 1, kind = "frag_fest", path = {}
  }

  for y = 1,H do
    for x = 1,W do
      -- note: dummy along and theme values
      create_cell(p, x, y, p.quests[1], 1, nil)
    end
  end

  choose_dm_themes()

  for tries = 1,99 do
    local num_links = math.random(min_links, max_links)

    io.stderr:write(string.format("TRYING: %d <= %d <= %d\n", min_links, num_links, max_links))

    if remove_dm_links(max_links - num_links) then break end

    if tries >= 99 then
      error("FAILED TRYING TO CREATING LINKS")
    end
  end

  assign_dm_players()
  assign_dm_weapons()

-- !!!!  select_heights()
  shuffle_build_sites(p)
  compute_height_minmax(p);

  con.ticker();

  return p
end

