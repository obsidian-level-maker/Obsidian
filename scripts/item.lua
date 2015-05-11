------------------------------------------------------------------------
--  ITEM SELECTION / PLACEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
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
------------------------------------------------------------------------


function Item_simulate_battles()
  -- TODO
end



function Item_distribute_stats()
  --|
  --| this distributes the fight statistics (which represent how much
  --| health and ammo the player needs) into earlier rooms and storage
  --| rooms in the same zone.
  --|

  -- health mainly stays in same room (a reward for killing the monsters)
  -- ammo mainly goes back, to prepare player for the fight
  local health_factor = 0.25
  local ammo_factor   = 0.65

  local function get_previous_locs(room)
    local list = {}

    -- find previous rooms
    local R = room

    while R.entry_conn do
      R = R.entry_conn:neighbor(R)

      if R.kind != "hallway" then
        local ratio = rand.irange(3,7) / (2.0 ^ #list)
        table.insert(list, { room=R, ratio=ratio })
      end
    end

    -- add storage rooms
    -- FIXME !!!!
--[[
    if room.zone.storage_rooms then
      each R in room.zone.storage_rooms do
        local ratio = rand.irange(3,7) / 2.0
        table.insert(list, { room=R, ratio=ratio })
      end
    end
--]]

    return list
  end


  local function distribute(R, N, ratio)
    each CL,R_stats in R.fight_stats do
      local N_stats = N.fight_stats[CL]

      each stat,count in R_stats do
        if count <= 0 then continue end

        local value

        if stat == "health" then
          value = count * health_factor * ratio
        else 
          value = count * ammo_factor * ratio
        end

        N_stats[stat] = (N_stats[stat] or 0) + value
        R_stats[stat] =  R_stats[stat]       - value

        gui.debugf("Distributing %s:%1.1f [%s]  %s --> %s\n",
                   stat, value,  CL, R:tostr(), N:tostr())
      end
    end
  end


  local function distribute_to_list(R, list)
    local total = 0

    each loc in list do
      total = total + loc.ratio
    end

    each loc in list do
      distribute(R, loc.room, loc.ratio / total)
    end
  end


  ---| Item_distribute_stats |---

  -- Note: we don't distribute to or from hallways

  each R in LEVEL.rooms do
    if R.is_storage then continue end

    if R.fight_stats then
      distribute_to_list(R, get_previous_locs(R))
    end
  end

  each R in LEVEL.rooms do
    if R.fight_stats then
      gui.debugf("final result @ %s = \n%s\n", R:tostr(),
                 table.tostr(R.fight_stats, 2))
    end
  end
end



function Item_add_pickups()
  --
  -- Once all monsters have been chosen and all battles have been
  -- simulated (including cages and traps), then we can decide *what*
  -- pickups to add (the easy part) and *where* to place them (the
  -- hard part).
  --

  local function grab_a_big_spot(R)
    local result = table.pick_best(R.big_spots,
            function(A, B) return A.score > B.score end, "remove")

    -- update remaining scores so next one chosen is far away
    each spot in R.big_spots do
      local dist = Monsters_dist_between_spots(spot, result, 80) / 256

      spot.score = spot.score + dist
    end

    return result
  end


  local function place_item(item_name, x, y, z)
    local props = {}

    if PARAM.use_spawnflags then
      -- no change
    else
      props.flags = DOOM_FLAGS.EASY + DOOM_FLAGS.MEDIUM + DOOM_FLAGS.HARD
    end

    Trans.entity(item_name, x, y, z, props)
  end


  local function place_item_in_spot(item_name, spot)
    local x, y = geom.box_mid(spot.x1, spot.y1, spot.x2, spot.y2)

    place_item(item_name, x, y, spot.z1)
  end


  local function find_cluster_spot(R, prev_spots, item_name)
    if #prev_spots == 0 then
      local spot = table.remove(R.item_spots, 1)
      table.insert(prev_spots, spot)
      return spot
    end

    local best_idx
    local best_dist

    -- FIXME: optimise this!
    for index = 1,#R.item_spots do
      local spot = R.item_spots[index]
      local dist = 9e9

      each prev in prev_spots do
        local d = Monsters_dist_between_spots(prev, spot)
        dist = math.min(dist, d)
      end

      -- prefer closest row to a wall
      if spot.wall_dist then
        dist = dist + spot.wall_dist * 200
      end

      -- avoid already used spots
      if spot.used then dist = dist + 100000 end

      if not best_idx or dist < best_dist then
        best_idx  = index
        best_dist = dist
      end
    end

    assert(best_idx)

    local spot = table.remove(R.item_spots, best_idx)

    if #prev_spots >= 3 then
      table.remove(prev_spots, 1)
    end

    table.insert(prev_spots, spot)

    return spot
  end


  local function place_item_list(R, item_list, CL)
    each pair in item_list do
      local item  = pair.item
      local count = pair.count

      -- big item?
      if (item.rank or 0) >= 2 and count == 1 and not table.empty(R.big_spots) then
        local spot = grab_a_big_spot(R)
        place_item_in_spot(item.name, spot)
        continue
      end

      -- keep track of a limited number of previously chosen spots.
      -- when making clusters, this is used to find the next spot.
      local prev_spots = {}

      for i = 1,count do
        if table.empty(R.item_spots) then
          gui.printf("Unable to place items: %s x %d\n", item.name, count+1-i)
          break;
        end

        local spot = find_cluster_spot(R, prev_spots, item.name)

        place_item_in_spot(item.name, spot)

        -- reuse spots if they run out
        spot.used = true
        table.insert(R.item_spots, spot)
      end
    end
  end


  local function decide_pickup(R, stat, qty)
    local item_tab = {}

    each name,info in GAME.PICKUPS do
      -- compatibilty crud...
      local prob = info.add_prob or info.prob

      if prob and
         (stat == "health" and info.give[1].health) or
         (info.give[1].ammo == stat)
      then
        item_tab[name] = prob

        if R.is_start and info.start_prob then
          item_tab[name] = info.start_prob
        end
      end
    end

    assert(not table.empty(item_tab))

    local name = rand.key_by_probs(item_tab)
    local info = GAME.PICKUPS[name]

    local count = 1
    
    if info.cluster then
      local each_qty = info.give[1].health or info.give[1].count
      local min_num  = info.cluster[1]
      local max_num  = info.cluster[2]

      assert(max_num <= 9)

      --- count = rand.irange(min_num, max_num)

      if min_num * each_qty >= qty then
        count = min_num
      elseif max_num * each_qty <= qty then
        count = max_num - rand.sel(20,1,0)
      else
        count = 1 + int(qty / each_qty)
      end
    end

    return GAME.PICKUPS[name], count
  end


  local function bonus_for_room(R, stat)
    local bonus = 0

    -- more stuff in start room
    if R.is_start then
      if stat == "health" then
        bonus = 20
      end
    end

    -- when getting a weapon, should get some ammo for it too
    if R.weapons then
      each name in R.weapons do
        local info = GAME.WEAPONS[name]

        if info.ammo and info.ammo == stat and info.bonus_ammo then
          bonus = bonus + info.bonus_ammo
        end
      end
    end

    if OB_CONFIG.strength == "crazy" then
      bonus = bonus * 2
    end

    -- compensation for environmental hazards
    if stat == "health" and R.hazard_health then
      bonus = bonus + R.hazard_health
    end

    return bonus
  end


  local function do_select_pickups(R, item_list, stat, qty)
    assert(qty >= 0)

    while qty > 0 do
      local item, count = decide_pickup(R, stat, qty)
      table.insert(item_list, { item=item, count=count, random=gui.random() })

      if stat == "health" then
        qty = qty - item.give[1].health * count
      else
        assert(item.give[1].ammo)
        qty = qty - item.give[1].count * count
      end
    end

    -- return the excess amount
    return (-qty)
  end


  local function select_pickups(R, item_list, stat, qty, hmodel)
    assert(qty >= 0)

    local held_qty = hmodel.stats[stat] or 0

    local actual_qty = 0

    -- when the player is already holding more than required, simply
    -- reduce the hmodel (don't place any items).
    if held_qty >= qty then
      hmodel.stats[stat] = held_qty - qty
    else
      hmodel.stats[stat] = 0
      actual_qty = qty - held_qty
    end

    -- bonus stuff : this is _not_ applied to the hmodel
    -- (otherwise future rooms would get less of it).
    actual_qty = actual_qty + bonus_for_room(R, stat)

    local excess = do_select_pickups(R, item_list, stat, actual_qty)

    -- there will usually be a small excess amount, since items come
    -- in discrete quantities.  accumulate it into the hmodel...
    hmodel.stats[stat] = hmodel.stats[stat] + excess
  end


  local function compare_items(A, B)
    local A_rank = A.item.rank or 0
    local B_rank = B.item.rank or 0

    if A_rank != B_rank then return A_rank > B_rank end

     return (A.count + A.random) > (B.count + B.random)
  end


  local function pickups_for_hmodel(R, CL, hmodel)
    if table.empty(GAME.PICKUPS) then
      return
    end

    local stats = R.fight_stats[CL]
    local item_list = {}

    each stat,qty in stats do
      -- this updates the hmodel too
      select_pickups(R, item_list, stat, qty, hmodel)

      gui.debugf("Item list for %s:%1.1f [%s] @ %s\n", stat,qty, CL, R:tostr())

      each pair in item_list do
        local item = pair.item
        gui.debugf("   %dx %s (%d)\n", pair.count, item.name,
                   item.give[1].health or item.give[1].count)
      end
    end

    rand.shuffle(R.item_spots)

    -- sort items by rank
    -- also: place large clusters before small ones
    table.sort(item_list, compare_items)

    place_item_list(R, item_list, CL)
  end


  local function pickups_in_room(R)
    R.item_spots = Monsters_split_spots(R.item_spots, 25)

    each CL,hmodel in LEVEL.hmodels do
      pickups_for_hmodel(R, CL, hmodel)
    end
  end


  ---| Item_add_pickups |---

  gui.printf("\n--==| Item Pickups |==--\n\n")

  Item_distribute_stats()

  each R in LEVEL.rooms do
    pickups_in_room(R)
  end
end

