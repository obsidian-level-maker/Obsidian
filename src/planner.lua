----------------------------------------------------------------
-- PLANNER : Single Player
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

require 'defs'
require 'util'
require 'a_star'

require 'th_doom'


QUEST_MAP =
{
  key    = KEY_LIST,
  switch = SWITCH_LIST,
  weapon = WEAPON_LIST,
  item   = ITEM_LIST,
  exit   = EXIT_LIST
}


function show_quests(p)
  if p.deathmatch then
    io.stderr:write("Deathmatch Quest: frag fest!\n")
    return
  end

  local function display_quest(idx, Q)
    io.stderr:write(string.format(
      "Quest %d: Find %s (%s) Len %d\n",
        Q.level, Q.kind, Q.item, Q.want_len))
  end

  local function display_mini_quest(idx, Q)
    io.stderr:write(string.format(
      "  Mini-Quest %d.%d: Find %s (%s) Len %d\n",
        Q.level, Q.sub_level, Q.kind, Q.item, Q.want_len))
  end

  for q_idx,Q in ipairs(p.quests) do
    display_quest(q_idx, Q)
    for r_idx,R in ipairs(Q.children) do
      display_mini_quest(r_idx, R)
    end
  end
end


function show_path(p)

  local function show_cell(c)
    if (c == nil) then
      io.stderr:write("    |")
    else
      local kind, L, R = " ", " ", " "

          if c.dm_player then kind = "P"
      elseif c.dm_weapon then kind = "W"
      elseif c.scenic    then kind = "C"
      elseif c.is_depot  then kind = "D"
      elseif c.along == 1 then kind = "S"
      elseif c.along < #c.quest.path then
        if c.quest.mini then kind = "q" else kind = "p" end
      elseif c.quest.kind == "exit" then kind = "E"
      elseif c.quest.kind == "item" or
             c.quest.kind == "weapon" then kind = "W"
      elseif c.quest.kind == "switch" or
             c.quest.kind == "key" then kind = "K"
      else kind = "?"
      end
          if c.exit_dir == 2 then R = "v"
      elseif c.exit_dir == 8 then R = "^"
      elseif c.exit_dir == 4 then R = "<"
      elseif c.exit_dir == 6 then R = ">"
      end

      if c.along == 2 then
            if c.entry_dir == 2 then L = "v"
        elseif c.entry_dir == 8 then L = "^"
        elseif c.entry_dir == 4 then L = "<"
        elseif c.entry_dir == 6 then L = ">"
        end
      end
      if R == "<" or L == ">" then L,R = R,L end

      io.stderr:write(L .. kind .. c.quest.level .. R .. "|")
    end
  end

  local function divider(len)
    for i = len,1,-1 do
      io.stderr:write("----+")
    end
    io.stderr:write("\n")
  end

  -- BEGIN show_path --

  divider(p.w)

	for y = p.h,1,-1 do
	  for x = 1,p.w do
	    show_cell(p.cells[x][y])
	  end
	  io.stderr:write("\n")
    divider(p.w)
	end
end


function show_chunks(p)

  local function show_cell(c,ky)

    local function chk(kx)
      if not c or not c.chunks then return " " end

      local K = c.chunks[kx][ky]

      if not K then return " " end

      if K.closet then return "c" end
      if K.void   then return "." end
      if K.room   then return "/" end

      --[[
      if K.weapon then return "w" end
      if K.player then return "p" end
      if K.quest  then return "t" end
      --]]

      if K.link then
-- if K.link.build == c then return "/" end
-- if K.link.src.floor_h == K.link.dest.floor_h then return "/" end

        if K.link == c.link[2] then return "2" end
        if K.link == c.link[8] then return "8" end
        if K.link == c.link[4] then return "4" end
        if K.link == c.link[6] then return "6" end
      end

      return "?"
    end

    for x = 1,KW do
      io.stderr:write(chk(x))
    end
    io.stderr:write("|")
  end

  local function divider(len)
    for i = len,1,-1 do
      for x = 1,KW do
        io.stderr:write("-")
      end
      io.stderr:write("+")
    end
    io.stderr:write("\n")
  end

  -- BEGIN show_cell --

  divider(p.w)

	for y = p.h,1,-1 do
    for row = KH,1,-1 do
      for x = 1,p.w do
        show_cell(p.cells[x][y], row)
      end
      io.stderr:write("\n")
	  end
    divider(p.w)
	end
end


function random_cell(p)
  return rand_irange(1, p.w), rand_irange(1, p.h)
end

function valid_cell(p, cx, cy)
  return not (cx < 1 or cy < 1 or cx > p.w or cy > p.h)
end

function empty_loc(p)  ---### UNUSED
  for loop = 1,999 do
    local x,y = random_cell(p)
    if not p.cells[x][y] then return x, y end
  end
end


function link_other(link, cell)
  if link.src  == cell then return link.dest end
  if link.dest == cell then return link.src end
  return nil
end


function links_in_cell(c)
  local count = 0
  for dir = 2,8,2 do
    if c.link[dir] then count = count + 1 end
  end
  return count
end


function get_base_plan(cw, ch)
  local PLAN =
  {
    w = cw,
    h = ch,

    blk_w = BORDER_BLK*2 + cw * (BW+1) + 1,
    blk_h = BORDER_BLK*2 + ch * (BH+1) + 1,

	  cells = array_2D(cw, ch),
    quests = {},

    all_cells  = {},
    all_depots = {},
    all_links  = {},
    all_things = {},

    f_min = 5*64,
    f_max = 5*64,

    used_items = {},
    things = {},

    free_tag = 10,
    mark = 1,
  }

  PLAN.blocks = array_2D(PLAN.blk_w, PLAN.blk_h)

  return PLAN
end
 
function allocate_tag(p)
  p.free_tag = p.free_tag + 1
  return p.free_tag
end

function allocate_mark(p)
  p.mark = p.mark + 1
  return p.mark
end

function create_cell(p, x, y, quest, along, theme, is_depot)
  local CELL =
  {
    x = x, y = y, quest = quest, along = along,
    link = {}, border = {}, window = {}, closet = {},
    theme = theme,
    is_depot = is_depot,
    liquid = quest.liquid,
    floor_h = 0, ceil_h  = 256, -- dummy values
    monsters = {}
  }

  p.cells[x][y] = CELL

  if is_depot then
    table.insert(p.all_depots, CELL)
  else
    table.insert(p.all_cells, CELL)
  end

  return CELL
end

function create_link(p, c, other, dir)
  local LINK =
  {
    src  = c,
    dest = other,
    kind = "arch",  -- updated later
    build = c,    -- updated later
    long = 2,      -- ditto
    deep = 1,
  }

  c.link[dir] = LINK
  other.link[10-dir] = LINK

  table.insert(p.all_links, LINK)

  return LINK
end

function choose_liquid()
  local probs = {}
  for zzz,info in ipairs(TH_LIQUIDS) do
    table.insert(probs, info.prob or 50)
  end

  local idx = rand_index_by_probs(probs)
  return TH_LIQUIDS[idx]
end

function find_liquid(name)
  if not name then return nil end

  for zzz,info in ipairs(TH_LIQUIDS) do
    if info.name == name then return info end
  end

  error("Unknown liquid: " .. name)
end


function shuffle_build_sites(p)

  local function builds_in_cell(c)
    local count = 0
    for dir = 2,8,2 do
      if c.link[dir] and c.link[dir].build == c then count = count + 1 end
    end
    return count
  end

  for zzz,link in ipairs(p.all_links) do

    con.ticker();

    local SL = links_in_cell(link.src)
    local DL = links_in_cell(link.dest)

    local chance = 50

        if DL > SL then chance = 50 - DL * 10
    elseif SL > DL then chance = 50 + SL * 10
    end

    -- this ensures we see a metallic wall outside
    -- (rather than a rocky wall inside)
    if link.dest.theme.outdoor and not link.src.theme.outdoor then chance =  1 end
    if link.src.theme.outdoor and not link.dest.theme.outdoor then chance = 99 end

    if link.kind == "falloff" then chance = 0 end

    if rand_odds(chance) then
      link.build = link.dest
    end
  end

---###  -- make sure cells are never "full" of build sites
---###  -- (Note: in reality this happens only very rarely)
---###  for loop = 1,9 do
---###    local modified = false
---###    for zzz,c in ipairs(p.all_cells) do
---###      if builds_in_cell(c) == 4 then
---###        local dir = math.random(1,4) * 2
---###        c.link[dir].build = link_other(c.link[dir], c)
---###        modified = true
---###      end
---###    end
---###    con.ticker();
---###    if not modified then break end
---###  end
end

function compute_height_minmax(p)

  for zzz,c in ipairs(p.all_cells) do
    c.f_min = c.floor_h
    c.f_max = c.floor_h
    c.c_min = c.ceil_h
    c.c_max = c.ceil_h

    for dir = 2,8,2 do
      if c.link[dir] then
        local link = c.link[dir]
        local other = link_other(link, c)
        if link.build ~= c then
          c.f_min = math.min(c.f_min, other.floor_h)
          c.f_max = math.max(c.f_max, other.floor_h)
          c.c_min = math.min(c.c_min, other.ceil_h)
          c.c_max = math.max(c.c_max, other.ceil_h)
        end
      end
    end
  end
end



function plan_sp_level(is_coop)  -- returns Plan

	local p = get_base_plan(PL_W, PL_H)

  local function travel_cost(cells, cx, cy, nx, ny)
    if cells[nx][ny] then return -1 end -- impassible
    return 5
  end


  local function valid_and_empty(cx, cy)
    return valid_cell(p, cx, cy) and not p.cells[cx][cy]
  end

  local function get_quest_item(quest)
    local tab = QUEST_MAP[quest]
    assert(tab)

    local t_items = {}
    local t_probs = {}

    for item,prob in pairs(tab) do
      if not p.used_items[item] then
        table.insert(t_items, item)
        table.insert(t_probs, prob)
      end
    end

    assert(#t_items > 0) -- decide_quest() guarantees this
    assert(#t_probs == #t_items)

    local item = t_items[rand_index_by_probs(t_probs)]

    p.used_items[item] = 1
    return item
  end

  local FB_BACK_PROBS = { 20, 90, 70, 50, 30, 10 }

  local function branch_spot_score(c, Q)
    -- make sure we have somewhere to go
    if not (valid_and_empty(c.x-1,c.y) or valid_and_empty(c.x+1,c.y) or
            valid_and_empty(c.x,c.y-1) or valid_and_empty(c.x,c.y+1)) then
      return 0
    end

    -- mini quests *always* connect to their parent
    if Q.mini then
      if Q.parent == c.quest then return 90 end
      if Q.parent == c.quest.parent then return 60 end
      return 0.3
    end

    -- first main quest always joins the initial room
    if Q.level == 1 then return 100 end

    -- usually we fork off the previous quest, but
    -- give a chance for other quests
    local quest_d = Q.level - c.quest.level
    assert(quest_d >= 1)

    -- how much backtracking (avoid forking off key room)
    -- Need to handle a mini branching off a mini...
    local where = c
    while where.quest.mini do
      where = where.quest.path[1]
    end
    local back_d = #where.quest.path - where.along

    -- doesn't matter when branching off non-parent ancestor
    if quest_d >= 2 then back_d = 1 end

    if back_d < 1 then return 0.01 end

    if back_d > #FB_BACK_PROBS then
       back_d = #FB_BACK_PROBS
    end

    -- less chance for main quest branching off a mini
    if c.quest.mini then quest_d = quest_d + 1.4 end

    return FB_BACK_PROBS[back_d] / quest_d / quest_d
  end

  local function find_branch_spot(Q)
    local b_cells = {}  
    local b_probs = {}

--io.stderr:write(Q.mini and "MINI-Q: " or "QUEST: ", Q.level, "\n")
    for x = 1,p.w do for y = 1,p.h do
      local c = p.cells[x][y]
      if c then
        local prob = branch_spot_score(c, Q)

        if prob > 0 then
--io.stderr:write("  ",c.x, ",", c.y, " prob= ",prob,"\n")
          table.insert(b_cells, c)
          table.insert(b_probs, prob)
        end
      end
    end end

    if #b_cells == 0 then
      error("Unable to find branch spot for quest " .. Q.level)
    end

    assert(#b_cells == #b_probs)

    return b_cells[rand_index_by_probs(b_probs)]
  end

  local MATCH_SCORES =
  {
    100, 70, 20, 2
  }

  local function where_now(x, y, path_dirs)
    
    local function dir_score(dir)
      local dx, dy = dir_to_delta(dir)

      if not valid_and_empty(x+dx, y+dy) then return 0 end

      local matches = 0
      if path_dirs[#path_dirs]   == dir then matches = matches+1 end
      if path_dirs[#path_dirs-1] == dir then matches = matches+1 end
      if path_dirs[#path_dirs-2] == dir then matches = matches+1 end

      return MATCH_SCORES[1 + matches]
    end

    local poss_dirs = { 0,0,0,0, 0,0,0,0 }

    poss_dirs[2] = dir_score(2)
    poss_dirs[4] = dir_score(4)
    poss_dirs[6] = dir_score(6)
    poss_dirs[8] = dir_score(8)

    local dir = rand_index_by_probs(poss_dirs)

    if dir then
      assert(poss_dirs[dir] > 0)
      local dx, dy = dir_to_delta(dir)
      return x+dx, y+dy, dir
    end
  end

  local function liquid_for_quest(Q)
    if rand_odds(50) then
      return nil
    end

    if Q.theme.bad_liquid == p.liquid.name then
      return find_liquid(Q.theme.good_liquid)
    end

    if Q.theme.good_liquid and dual_odds(Q.mini, 15, 66) then
      return find_liquid(Q.theme.good_liquid)
    end

    if Q.mini then
      return Q.parent.liquid
    end

    return p.liquid
  end

  function make_quest_path(Q)
 
    -- TODO: better system for choosing themes
    local theme
    if Q.mini then theme = Q.parent.theme
    else theme = rand_element(ALL_THEMES)
    end

    Q.theme = theme
    assert(theme)

    -- decide liquid
    Q.liquid = liquid_for_quest(Q)

    -- add very first room
    if not Q.mini and Q.level == 1 then
      local x, y = random_cell(p)
      create_cell(p, x, y, Q, 1, theme)
    end


    local cur = find_branch_spot(Q)
--io.stderr:write("  BRANCH SPOT --> ", cur.x, ",", cur.y, "\n")

    table.insert(Q.path, cur)

    local along = 2
    local path_dirs = {}

    while along <= Q.want_len do

      -- figure out where to go next
      local nx, ny, dir = where_now(cur.x, cur.y, path_dirs)

      if not nx then break end


      local nextc = create_cell(p, nx, ny, Q, along, theme)

      nextc.entry_dir = 10 - dir
      if not cur.exit_dir then cur.exit_dir = dir end

      create_link(p, cur, nextc, dir)

      table.insert(Q.path, nextc)
      table.insert(path_dirs, dir)

      cur = nextc
      along = along + 1
    end

    Q.first = Q.path[1]
    Q.last  = Q.path[#Q.path]
  end


  local function decide_links()
    for zzz,link in ipairs(p.all_links) do
      local c = link.src
      local d = link.dest

      if link.src.quest.level == link.dest.quest.level then

        local door_chance = 15
        if c.theme.outdoor ~= d.theme.outdoor then door_chance = 70
        elseif c.theme ~= d.theme then door_chance = 40
        elseif c.theme.outdoor then door_chance = 5
        end

        if rand_odds(door_chance) then link.kind = "door" end

      else -- need a locked door

        local lock_level = math.max(c.quest.level, d.quest.level) - 1
        assert(lock_level >= 1 and lock_level < #p.quests)

        link.quest = p.quests[lock_level]
        link.kind  = "door"
      end

      if link.kind == "door" then link.long = 3 end
    end
  end


  local function select_heights()

    -- FIXME: TEMP JUNK
    for zzz,c in ipairs(p.all_cells) do
      -- c.floor_h = 128 - (5-c.quest.level) * 128
      c.floor_h = rand_index_by_probs{ 3,1,5,1,4 } * 32 - 32
      if c.is_exit then c.ceil_h = c.floor_h + 128 end
    end
  end

--[[
  local function old_select_heights()

    local function calc_floor(c, prev)
      if c.floor_h then return end -- already done

      if not prev[1] then
        c.floor_h = p.f_min
        return
      end

      -- the real delta = (index - 5) * 64
      local poss_delta = { 6,0,60,80,160,80,60,0,6 }

      if p.deathmatch then
        poss_delta[4] = 100
        poss_delta[5] = 40
        poss_delta[6] = 100

      else
        -- try to avoid changing direction
        if prev[2] and not c.theme.outdoor then
          if prev[2] < prev[1] then
            for i = 2,4 do poss_delta[i] = poss_delta[i] / 4 end
          elseif prev[2] > prev[1] then
            for i = 6,8 do poss_delta[i] = poss_delta[i] / 4 end
          end
        end

        -- but we would like some variation
        if prev[2] and prev[2] == prev[1] then
          poss_delta[5] = 80
          if prev[3] == prev[2] then
            poss_delta[5] = 30
          end
        end
      end

      local mul = 64
      if rand_odds(30) then mul = 32 end

      c.floor_h = prev[1] + (rand_index_by_probs(poss_delta) - 5) * mul
    end

    local function calc_ceil(c, calc_new)

      local function try_link(link)
        if not link then return end

        local other = link_other(link, c)
        if not other then return end

        local need = 64
        if c.outdoor then need = 96 end

        if c.ceil_h < other.floor_h + need then
           c.ceil_h = other.floor_h + need
        end

        if c.theme.outdoor and not calc_new then
          if other.theme.outdoor then
            c.ceil_h = math.max(c.ceil_h, other.ceil_h)
          else
            c.ceil_h = math.max(c.ceil_h, other.ceil_h + 24)
          end
        end
      end

      --| calc_ceil |--
     
      if calc_new then
        c.ceil_h = c.floor_h + 128
        if rand_irange(1,100) < 20 then
          c.ceil_h = c.ceil_h + 64
        end

        -- FIXME
        -- if cave_theme and rand_odds(30) then c.ceil_h = c.ceil_h - 64  end
      
      else
        for tdir = 2,8,2 do
          try_link(c.link[tdir])
        end
      end
    end

    -- BEGIN old_select_heights --

    local prev_floors = {}

    if not p.deathmatch then
      for zzz,stage in ipairs(p.stages) do
        for xxx,cell in ipairs(stage.path) do
          calc_floor(cell, prev_floors)
          table.insert(prev_floors, 1, cell.floor_h)
        end
      end
    else  -- DEATHMATCH
      for y = 1,p.h do
        for x = 1,p.w do

          if y > 1 then
            table.insert(prev_floors, 1, p.cells[x][y-1].floor_h)
          end
          if x > 1 then
            table.insert(prev_floors, 1, p.cells[x-1][y].floor_h)
          end

          calc_floor(p.cells[x][y], prev_floors)
        end
      end
    end

    for yyy,cell in ipairs(p.all_cells) do
      if p.f_min > cell.floor_h then
         p.f_min = cell.floor_h
      end
      if p.f_max < cell.floor_h then
         p.f_max = cell.floor_h
      end
    end

    for loop=1,16 do
      for xxx,cell in ipairs(p.all_cells) do
        calc_ceil(cell, loop == 1)
      end
    end
  end    -- END old_select_heights --
--]]
  
  local function decide_quests()
    
    local function is_mini_quest(kind)
      return kind == "weapon" or kind == "item" or
             kind == "secret_exit"
    end
    
    local function quest_score(qlist)
      -- higher (worse) score when the same type of quest
      -- appears multiple times in a row.
      -- also checks for how many mini-quests per quest.

      local total = { 0, 0, 0, 0 }

      local rep  = 0
      local mini = 0

      -- Note that we go ONE PAST the end
      for i = 1, #qlist+1 do

        if qlist[i-1] == qlist[i] then
          rep = math.min(4, rep + 1)
        else
          if rep > 0 then total[rep] = total[rep] + 1 end
          rep = 1
        end

        if is_mini_quest(qlist[i]) then
          mini = math.min(4, mini + 1)
        else
          if mini > 0 then total[mini] = total[mini] + 1.8 end
          mini = 0
        end
      end

      return total[4]*100 + total[3]*40 + total[2]*10 
    end

    local function find_main_quest(qlist)
      for idx,kind in ipairs(qlist) do
        if not is_mini_quest(kind) then
          return idx
        end
      end
      error("find_main_quest: not found!")
    end

    -- probability tables for length of quests
    local LEN_PROB_TAB =
    {
      key    = {  5, 25, 50, 90, 70, 30, 10, 5, 1, 1 },
      exit   = {  5, 25, 50, 90, 70, 30, 10, 5, 1, 1 },
      switch = { 15, 90, 90, 50, 10, 1 },
      weapon = { 15, 90, 50, 10, 1 },
      item   = { 15, 70, 70, 10, 1 }
    }

    local function add_quest(kind, is_mini)
      
      local parent
      if is_mini then
        parent = p.quests[#p.quests]
        assert(parent)
      end

      local QUEST =
      {
        kind = kind,
        item = get_quest_item(kind),
        path = {},

        mini = is_mini,
        parent = parent,
        children = {},

        tag = allocate_tag(p)
      }

      if parent then
        table.insert(parent.children, QUEST)
        QUEST.level = parent.level
        QUEST.sub_level = #parent.children
      else
        table.insert(p.quests, QUEST)
        QUEST.level = #p.quests
      end

      local len_probs = LEN_PROB_TAB[kind]
      assert(len_probs)

      -- add '1' for starting square (minimum len == 2)
      QUEST.want_len = 1 + rand_index_by_probs(len_probs)

      -- exit quests have minimum of 3, so that exit doors
      -- are never locked -- FIXME
      if QUEST.kind == "exit" then
        QUEST.want_len = QUEST.want_len + 1
      end
    end

    ---- decide_quests ----
    
    local keys, switches, weapons, items, total, ratio
    local k_max, sw_max, wp_max, it_max;

    k_max  = math.min(3, count_entries(QUEST_MAP.key))
    sw_max = math.min(3, count_entries(QUEST_MAP.switch))
    wp_max = math.min(4, count_entries(QUEST_MAP.weapon))
    it_max = math.min(2, count_entries(QUEST_MAP.item))

    repeat
      keys     = rand_irange(1, k_max)
      switches = rand_irange(0, sw_max)
      weapons  = rand_irange(1, wp_max)
      items    = rand_irange(0, it_max)

      total    = keys + switches + weapons + items
      ratio    = (keys + switches) / (weapons + items)
    until (3 <= total and total <= 8 and
           0.35 <= ratio and ratio <= 2.0)

    assert(keys + switches >= 1)

    io.stderr:write(
      string.format("Keys %d, Switches %d, Weapons %d, Items %d\n",
        keys, switches, weapons, items))

    local qlist = {}
    for i = 1,20 do
      if (i <= keys)     then table.insert(qlist, "key") end
      if (i <= switches) then table.insert(qlist, "switch") end
      if (i <= weapons)  then table.insert(qlist, "weapon") end
      if (i <= items)    then table.insert(qlist, "item") end
    end

    -- try and get a good order (we don't try too hard!)
    for zzz,score in ipairs { 30, 60, 100 } do
      local found = false
      for loop = 1,10 do
        rand_shuffle(qlist)
        if quest_score(qlist) < score then found = true break end
      end
      con.ticker();
      if found then break end
    end

    io.stderr:write("Final Score: " .. quest_score(qlist) .. "\n")

    -- find each main quest, pull it out, then all the
    -- mini-quests at the beginning of the list become
    -- assocatied with that main quest.

    while #qlist > 0 do
      local m = find_main_quest(qlist)

      add_quest(qlist[m], nil)
      table.remove(qlist, m)

      while is_mini_quest(qlist[1]) do
        add_quest(qlist[1], "mini")
        table.remove(qlist, 1)
      end
    end

    add_quest("exit", nil)

    -- FIXME
    if p.secret_exit then
      add_quest("exit", "mini")
    end

    con.ticker();
  end

  local function setup_exit_room()
    -- FIXME: handle secret exits too
    local c = p.quests[#p.quests].last

    c.theme = TH_EXITROOM
    c.is_exit = true
    c.light = 192

    for dir = 2,8,2 do
      if c.link[dir] then
        local link = c.link[dir]
        if link.kind == "arch" or link.kind == "door" then
          link.kind = "door"
          link.build = c
          link.is_exit = true
        end
      end
    end

    con.ticker();
  end
  
  local function add_scenic_cells()
    -- these cells improve the outdoor environment.
    -- When a outdoor->indoor transition occurs and a
    -- nearby cell is empty, it looks bad (as if the
    -- building has a paper front and no side).

    local function test_flat_front(x, y)
      local empties = {}
      local innies  = {}
      local outies  = {}

      for dx = 0,1 do
        for dy = 0,1 do
          local c = p.cells[x+dx][y+dy]
          if not c then
            table.insert(empties, { x=x+dx, y=y+dy })
          elseif c.theme.outdoor then
            table.insert(outies, c)
          else
            table.insert(innies, c)
          end
        end
      end

      if #empties ~= 1 or #innies ~= 1 or #outies ~= 2 then return end

      if (outies[1].x ~= outies[2].x) and
         (outies[1].y ~= outies[2].y) then return end

      local c = create_cell(p, empties[1].x, empties[1].y,
        outies[1].quest, outies[1].along, outies[1].theme)

      c.scenic = true
io.stderr:write("CREATED SCENIC AT ", c.x, ",", c.y, "\n")
    end

    --- add_scenic_cells ---

    for x = 1, p.w-1 do
      for y = 1, p.h-1 do
        test_flat_front(x, y)
      end
    end
  end

  local function add_bridges()
    --[[
    for zzz,c in ipairs(p.all_cells) do
      for dir = 2,8,2 do
        local pdir = rotate_cw(dir)
        if c.link[dir].switch and
        if c.link[dir] and c.link[10-dir] and
           not c.link[pdir] and not c.link[10-pdir]
      end
    end
    --]]
  end

  local function add_falloffs()
    
    local function can_make_falloff(a, b, dir)
      
      if b.is_depot or b.is_bridge or b.scenic then return false end
      if a.is_exit or b.is_exit then return false end

      local aq = a.quest.parent or a.quest
      local bq = b.quest.parent or b.quest

      if aq.level <  bq.level then return false end
      if aq.level == bq.level and a.along < b.along then return false end

      if a.f_min < (b.f_max + 64) then return false end
      if (b.ceil_h - a.floor_h) < 64 then return false end
      
      if a.theme.outdoor and b.theme.outdoor and a.ceil_h ~= b.ceil_h then return false end
      if a.theme.outdoor and not b.theme.outdoor and a.ceil_h <= b.ceil_h then return false end
      if b.theme.outdoor and not a.theme.outdoor and b.ceil_h <= a.ceil_h then return false end

      return true
    end

    for zzz,c in ipairs(p.all_cells) do
      for dir = 2,8,2 do
        local dx, dy = dir_to_delta(dir)
        local other = valid_cell(p, c.x+dx, c.y+dy) and p.cells[c.x+dx][c.y+dy]

        if other and not c.link[dir] and
           can_make_falloff(c, other, dir) and
           rand_odds(90) then
 
io.stderr:write("FALL-OFF @ (", c.x, ",", c.y, ") dir ", dir, "\n")
--print("SRC_MIN ", c.f_min, "  DEST_MAX", other.f_max)
--print("SRC_CEIL ", c.ceil_h, "  DEST_CEIL", other.ceil_h)

          local L = create_link(p, c, other, dir)
          L.kind = "falloff"
        end
      end
    end
  end
  
  local function add_windows()
    
    local function can_make_window(a, b)

---###   local aq = a.quest.parent or a.quest
---###   local bq = b.quest.parent or b.quest
---###
---###   if aq.level <  bq.level then return false end
---###   if aq.level == bq.level and a.along < b.along then return false end
      
      if b.is_depot or b.is_bridge then return false end
      if (a.is_exit or b.is_exit) and rand_odds(90) then return false end

      local cc = math.min(a.ceil_h, b.ceil_h) - 32
      local ff = math.max(a.f_max, b.f_max) + 32

      if (cc - ff) < 32 then return false end

---###   if a.f_min < (b.f_max + 64) then return false end
---###   if (b.ceil_h - a.floor_h) < 64 then return false end
      
      if a.theme.outdoor and b.theme.outdoor and a.ceil_h ~= b.ceil_h then return false end
--!!      if a.theme.outdoor and not b.theme.outdoor and b.ceil_h > b.ceil_h + 32 then return false end
--!!      if b.theme.outdoor and not a.theme.outdoor and a.ceil_h > a.ceil_h + 32 then return false end

      return true
    end

    for zzz,c in ipairs(p.all_cells) do
      for dir = 6,8,2 do
        local dx, dy = dir_to_delta(dir)
        local other = valid_cell(p, c.x+dx, c.y+dy) and p.cells[c.x+dx][c.y+dy]

        if other and
           can_make_window(c, other) and
           rand_odds(85)
        then
          c.window[dir] = "window"
          other.window[10-dir] = "dest"
        end
      end
    end
  end


  local function add_surprises()

    local function add_closet(Q)

      -- FIXME: prioritise
      local locs  = {}

      for idx,c in ipairs(Q.path) do
        local side = rand_irange(1,4) * 2
        
        if c.link[side] then side = rand_irange(1,4) * 2 end

        if idx >= 2 and not c.link[side] then
          table.insert(locs, {c=c, side=side})
        end
      end

      if #locs == 0 then return end

      local L = rand_element(locs)

      local trig_c  = Q.path[#Q.path]

      con.printf("ADDING CLOSET IN (%d,%d), TRIGGERED IN (%d,%d)\n",
          L.c.x, L.c.y, trig_c.x, trig_c.y)
      print(" QUEST", Q.level, Q.sub_level or 0)
      print(" ALONG", L.c.along);
      print(" Q", Q, "c.quest", L.c.quest)

      L.c.closet[L.side] = true

--##      Q.closet_build = L.c
--##      Q.closet_trig  = trig_c
--##      Q.closet_tag   = allocate_tag(p)
--##      Q.closet_side  = L.side

      local SURPRISE =
      {
        trigger_cell = Q.last,
        door_tag = allocate_tag(p),

        places =
        {
          { c = L.c, side = L.side, tag = allocate_tag(p) }
        }
      }

      Q.closet = SURPRISE
    end

    local function add_depot(Q)

      local pos_x, pos_y
      local best_score = -999

      local start = p.quests[1].first

      for x = 1,p.w do for y = 1,p.h do
        if not p.cells[x][y] then
          local score = dist(x, y, start.x, start.y)
          if score > best_score then
            best_score = score
            pos_x, pos_y = x, y
          end
        end
      end end

      if not pos_x then return end

      con.printf("CREATING DEPOT @ %d,%d\n", pos_x, pos_y)

      local CELL = create_cell(p, pos_x, pos_y, Q, 1, TH_EXITROOM, "depot")

      local SURPRISE =
      {
        trigger_cell = Q.last,
        depot_cell = CELL,
        door_tag = allocate_tag(p),

        places =
        {
          { c = Q.last, tag = allocate_tag(p) },
          { c = Q.last, tag = allocate_tag(p) },
          { c = Q.last, tag = allocate_tag(p) },
          { c = Q.last, tag = allocate_tag(p) },
        }
      }

      Q.depot = SURPRISE

---##      Q.depot_trig  = Q.path[#Q.path]
---##      Q.depot_dest  = Q.depot_trig   --!!!! FIXME
---##      Q.depot_cell  = c
---##      Q.depot_tags  = { allocate_tag(p), allocate_tag(p), allocate_tag(p), allocate_tag(p) }
    end

    local function try_add_surprise(Q)
      if Q.kind == "exit" then return end
      
      if Q.mini then  -- FIXME: better selection
        add_closet(Q)
      else
        add_depot(Q)
      end
    end

    --- add_surprises ---

    for zzz,Q in ipairs(p.quests) do
      try_add_surprise(Q)

      for xxx,R in ipairs(Q.children) do
        try_add_surprise(R)
      end
    end
  end


  local function toughen_it_up()
    
    local function toughen_quest(Q)
      
      local peak = 180 + #Q.path * 5
      local skip = 0

      peak = peak + 15 * (Q.sub_level or 0)
      peak = peak * (Q.level ^ 0.7) * (1 + rand_skew()/5)

      if p.coop then
        peak = peak * p.coop_toughness
      end

      -- go backwards from quest cell to start cell
      for i = #Q.path,1,-1 do
        local cell = Q.path[i]
        if not cell.toughness then
          if skip > 0 or cell.is_exit or cell.along == 1 then
            cell.toughness = (1 + rand_skew()) * peak / 3.3
            skip = skip - 1
          else
            cell.toughness = peak
            peak = peak * 0.75
            skip = rand_index_by_probs { 50, 70, 10 }
          end
        end
      end

      for j = 1,#Q.path do
        io.stdout:write(string.format("%d%s",
          Q.path[j].toughness or -789,
          sel(j < #Q.path, ",", "\n")))
      end
    end

    -- toughen_it_up --

    for zzz,Q in ipairs(p.quests) do
      toughen_quest(Q)

      for yyy,R in ipairs(Q.children) do
        toughen_quest(R)
      end
    end
  end


  ---=== plan_sp_level ===---

  p.models = initial_models()
  p.liquid = choose_liquid()

print("LIQUID:", p.liquid)

  if is_coop then
    p.coop = true
    p.coop_toughness = rand_range(1.5, 2.5)
    print("coop_toughness =", p.coop_toughness);
  end

  decide_quests()

  for zzz,Q in ipairs(p.quests) do
    make_quest_path(Q)

    for yyy,R in ipairs(Q.children) do
      make_quest_path(R)
    end

    con.ticker();
  end

  decide_links()
  setup_exit_room()

  for loop = 1,2 do
    add_scenic_cells()
    con.ticker();
  end

  select_heights()
  shuffle_build_sites(p)  -- this affects f_max

  compute_height_minmax(p)

  toughen_it_up()

-- FIXME add_bridges()

  add_falloffs()
  add_surprises()
  add_windows()

  return p
end

