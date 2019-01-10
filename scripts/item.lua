------------------------------------------------------------------------
--  ITEM SELECTION / PLACEMENT
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2017 Andrew Apted
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


--class HMODEL
--[[
    --
    -- This represents the weapons, health and ammo that a player has at
    -- a particular time.  When each room is visited, Player_give_room_stuff()
    -- updates the hmodel for the items in the room.  When placing items, we
    -- exclude stuff that the player already has.
    --
    -- There is one 'HMODEL' for each player class (in HEXEN there are three
    -- player classes).  So LEVEL.hmodels is indexed by the class name.
    --
    -- The GAME.PLAYER_MODEL table contains the initial model, especially the
    -- weapons that a player always holds.
    --

    weapons : table   -- what weapons the player has

    stats   : table   -- what health and ammo the player has
--]]


-- Doom flags
DOOM_FLAGS =
{
  EASY    = 1
  MEDIUM  = 2
  HARD    = 4
  DEAF    = 8
}

-- Hexen thing flags
HEXEN_FLAGS =
{
  FIGHTER = 32
  CLERIC  = 64
  MAGE    = 128

  DM      = 1024
}

-- Quake flags
QUAKE_FLAGS =
{
  DEAF       = 1

  NOT_EASY   = 256
  NOT_MEDIUM = 512
  NOT_HARD   = 1024
  NOT_DM     = 2048
}

-- Hexen2 flags  [NOT USED YET]
HEXEN2_FLAGS =
{
  NOT_PALADIN  = 256
  NOT_CLERIC   = 512
  NOT_NECRO    = 1024
  NOT_ASSASSIN = 2048

  NOT_EASY     = 4096
  NOT_MEDIUM   = 8192
  NOT_HARD     = 16384
  NOT_DM       = 32768
}


function Player_init()
  LEVEL.hmodels = table.deep_copy(GAME.PLAYER_MODEL)

  each CL,hmodel in LEVEL.hmodels do
    hmodel.class = CL
  end
end


function Player_give_weapon(weapon, only_CL)
  gui.printf("Giving weapon: %s\n", weapon)

  each CL,hmodel in LEVEL.hmodels do
    if not only_CL or (only_CL == CL) then
      hmodel.weapons[weapon] = 1
    end
  end
end


function Player_give_class_weapon(slot)
  each name,W in GAME.WEAPONS do
    each CL,hmodel in LEVEL.hmodels do
      if W.slot == slot and W.class == CL then
        hmodel.weapons[name] = 1
      end
    end
  end
end


function Player_give_map_stuff()
  if LEVEL.assume_weapons then
    each name,_ in LEVEL.assume_weapons do
          if name == "weapon2" then Player_give_class_weapon(2)
      elseif name == "weapon3" then Player_give_class_weapon(3)
      elseif name == "weapon4" then Player_give_class_weapon(4)
      else
        Player_give_weapon(name)
      end
    end
  end
end


function Player_give_room_stuff(R)
  -- give weapons, plus any ammo they come with
  if not PARAM.hexen_weapons then
    each name in R.weapons do
      Player_give_weapon(name)

      local weap = GAME.WEAPONS[name]
      if weap and weap.give then
        each CL,hmodel in LEVEL.hmodels do
          Player_give_stuff(hmodel, weap.give)
        end
      end

      EPISODE.seen_weapons[name] = 1
    end
  end

  -- take nice items into account too (except for secrets)
  if not R.is_secrets then
    each name in R.items do
      local info = GAME.NICE_ITEMS[name] or GAME.PICKUPS[name]
      if info and info.give then
        each CL,hmodel in LEVEL.hmodels do
          Player_give_stuff(hmodel, info.give)
        end
      end
    end
  end

  -- handle storage rooms too
  if R.storage_items then
    each pair in R.storage_items do
      local info = assert(pair.item)
      if info.give then
        each CL,hmodel in LEVEL.hmodels do
          Player_give_stuff(hmodel, info.give)
        end
      end
    end
  end
end


function Player_give_stuff(hmodel, give_list)
  each give in give_list do
    if give.health then
      gui.debugf("Giving [%s] health: %d\n",
                 hmodel.class, give.health)
      hmodel.stats.health = hmodel.stats.health + give.health

    elseif give.ammo then
      gui.debugf("Giving [%s] ammo: %dx %s\n",
                 hmodel.class, give.count, give.ammo)

      hmodel.stats[give.ammo] = (hmodel.stats[give.ammo] or 0) + give.count

    elseif give.weapon then
      gui.debugf("Giving [%s] weapon: %s\n",
                 hmodel.class, give.weapon)

      hmodel.weapons[give.weapon] = 1
    else
      error("Bad give item : not health, ammo or weapon")
    end
  end
end


function Player_firepower()
  -- The 'firepower' is (roughly) how much damage per second
  -- the player would normally do using their current set of
  -- weapons.
  --
  -- If there are different classes (Hexen) then the result
  -- will be an average of each class, as all classes face
  -- the same monsters.

  local function get_firepower(hmodel)
    local firepower = 0
    local divisor   = 0

    each weapon,_ in hmodel.weapons do
      local info = GAME.WEAPONS[weapon]

      if not info then
        error("Missing weapon info for: " .. weapon)
      end

      local dm = info.damage * info.rate
      if info.splash then dm = dm + info.splash[1] end

      -- melee attacks are hard to use, and
      -- projectiles miss more often than hitscan
      if info.attack == "melee" then
        dm = dm / 3.0
      elseif info.attack == "missile" then
        dm = dm / 1.3
      end

      local pref = info.pref or 1

---   gui.debugf("  weapon:%s dm:%1.1f pref:%1.1f\n", weapon, dm, pref)

      firepower = firepower + dm * pref
      divisor   = divisor + pref
    end

    if divisor == 0 then
      error("Player_firepower: no weapons???")
    end

    return firepower / divisor
  end

  ---| Player_firepower |---

  local fp_total  = 0
  local class_num = 0

  each CL,hmodel in LEVEL.hmodels do
    fp_total = fp_total + get_firepower(hmodel)
    class_num = class_num + 1
  end

  assert(class_num > 0)

  return fp_total / class_num
end


function Player_has_weapon(weap_needed)

  local function class_has_one(hmodel)
    each name,_ in hmodel.weapons do
      if weap_needed[name] then
        return true
      end
    end
    return false
  end

  --| Player_has_weapon |--

  -- we require a match for every class

  each CL,hmodel in LEVEL.hmodels do
    if not class_has_one(hmodel) then
      return false
    end
  end

  return true -- OK
end


function Player_max_damage()
  local result = 5

  each name,info in GAME.WEAPONS do
    local W_damage = info.rate * info.damage

    if W_damage > result and Player_has_weapon({ [name]=1 }) then
      result = W_damage
    end
  end

  return result
end


function Player_find_initial_weapons()
  -- find with weapons the player always owns
  local list = {}

  each CL,hmodel in LEVEL.hmodels do
    each name,_ in hmodel.weapons do
      list[name] = 1
    end
  end

  return list
end



function Player_find_zone_weapons(Z, list)
  each R in Z.rooms do
    each name in R.weapons do
      list[name] = 1
    end
  end
end



function Player_weapon_palettes()

  local Middle  = 1.00
  local High    = 2.20
  local Highest = 4.80
  local Low     = 0.44
  local Lowest  = 0.21


  local function insert_multiple(list, count, what)
    for i = 1, count do
      table.insert(list, what)
    end
  end


  local function decide_quantities(total)
    local list = {}

    -- Note: result is often longer than strictly required

    local num_low  = int(total / 2 + gui.random())
    local num_high = total - num_low

    insert_multiple(list, num_low,  Low)
    insert_multiple(list, num_high, High)

    if total >= 2 then
      local num_very = int(total / 6 + gui.random())

      insert_multiple(list, num_very, Lowest)
      insert_multiple(list, num_very, Highest)
    end

    assert(#list >= total)

    rand.shuffle(list)

    return list
  end


  local function apply_pref_table(pal, prefs)
    if not prefs then return end

    each name,factor in prefs do
      if pal[name] then
         pal[name] = pal[name] * factor
      end
    end
  end


  local function gen_palette(got_weaps)
    local total = table.size(got_weaps)

    -- TODO: support Hexen
    if total < 2 or PARAM.hexen_weapons then
      return {}
    end

    local pal = {}

    -- decide number of "normal" weapons : at least one!
    local normal_num = int(total / 3 + gui.random())
    if normal_num < 1 then normal_num = 1 end

    got_weaps = table.copy(got_weaps)

    for n = 1, normal_num do
      local name = rand.key_by_probs(got_weaps)

      pal[name] = Middle
      got_weaps[name] = nil
    end

    -- decide what to give everything else
    total = total - normal_num

    local quants = decide_quantities(total)

    each name,_ in got_weaps do
      pal[name] = table.remove(quants, 1)
    end

    -- apply level and theme preferences
    apply_pref_table(pal, LEVEL.weap_prefs)
    apply_pref_table(pal, THEME.weap_prefs)

    return pal
  end


  local function dump_palette(pal)
    each weap,qty in pal do
      gui.debugf("   %-9s* %1.2f\n", weap, qty)
    end
  end


  ---| Player_weapon_palettes |---

  -- Note: not using initial_weapons() here, they tend to be melee
  --       weapons and it sucks to promote them.
  local got_weaps = {}

  each Z in LEVEL.zones do
    Player_find_zone_weapons(Z, got_weaps)

    Z.weap_palette = gen_palette(got_weaps)

    gui.debugf("Weapon palette in ZONE_%d:\n", Z.id)
    dump_palette(Z.weap_palette)
  end
end


------------------------------------------------------------------------


function Item_simulate_battle(R)


  local function make_empty_stats()
    local stats = {}

    each CL,_ in GAME.PLAYER_MODEL do
      stats[CL] = {}
    end

    return stats
  end


  local function user_adjust_result(stats)
    -- apply the user's health/ammo adjustments here

    local heal_mul = HEALTH_FACTORS[OB_CONFIG.health]
    local ammo_mul =   AMMO_FACTORS[OB_CONFIG.ammo]

    heal_mul = heal_mul * (PARAM.health_factor or 1)
    ammo_mul = ammo_mul * (PARAM.ammo_factor or 1)

    -- give less ammo in later maps (to counter the build-up over an episode)
    if not PARAM.pistol_starts then
      local along = math.clamp(0, LEVEL.ep_along - 0.2, 0.8)
      local factor = 1.1 - along * 0.25

      ammo_mul = ammo_mul * factor
    end

    each name,qty in stats do
      if name == "health" then
        stats[name] = qty * heal_mul
      else
        stats[name] = qty * ammo_mul
      end
    end
  end


  local function subtract_stuff_we_have(stats, hmodel)
    each name,have_qty in hmodel.stats do
      local need_qty = stats[name] or 0
      if have_qty > 0 and need_qty > 0 then
        local min_q = math.min(have_qty, need_qty)

               stats[name] =        stats[name] - min_q
        hmodel.stats[name] = hmodel.stats[name] - min_q
      end
    end
  end


  local function give_monster_drops(hmodel, mon_list)
    each M in mon_list do
      if M.is_cage then continue end

      if M.info.give then
        Player_give_stuff(hmodel, M.info.give)
      end
    end
  end


  local function is_weapon_upgraded(name, list)
    each W in list do
      if W.info.upgrades == name then
        return true
      end
    end

    return false
  end


  local function collect_weapons(hmodel)
    local list = {}
    local seen = {}

    each name,_ in hmodel.weapons do
      local info = assert(GAME.WEAPONS[name])

      local factor = R.zone.weap_palette[name]

      if info.pref then
        table.insert(list, { info=info, factor=factor })
        seen[name] = true
      end
    end

    if not PARAM.pistol_starts then
      -- allow weapons from previous levels
      each name,_ in EPISODE.seen_weapons do
        if not seen[name] then
          local info = assert(GAME.WEAPONS[name])
          assert(info.pref)

          table.insert(list, { info=info, factor=0.5 })
        end
      end
    end

    if #list == 0 then
      error("No usable weapons???")
    end

    -- remove "upgraded" weapons (e.g. supershotgun > shotgun)

    for i = #list, 1, -1 do
      if is_weapon_upgraded(list[i].info.name, list) then
        table.remove(list, i)
      end
    end

    return list
  end


  local function battle_for_class(CL, hmodel)
    local mon_list = R.monster_list

    local weap_list = collect_weapons(hmodel)

    local stats = R.item_stats[CL]

    gui.debugf("Fight Simulator @ %s  class: %s\n", R.name, CL)

    gui.debugf("weapons = \n")
    each W in weap_list do
      gui.debugf("  %s\n", W.info.name)
    end

    Fight_Simulator(mon_list, weap_list, stats)

--  gui.debugf("raw result = \n%s\n", table.tostr(stats,1))

    user_adjust_result(stats)

--  gui.debugf("adjusted result = \n%s\n", table.tostr(stats,1))

    give_monster_drops(hmodel, mon_list)

    subtract_stuff_we_have(stats, hmodel)
  end


  ---| Item_simulate_battle |---

  assert(R.monster_list)

  R.item_stats = make_empty_stats()

  if #R.monster_list >= 1 then
    each CL,hmodel in LEVEL.hmodels do
      battle_for_class(CL, hmodel)
    end
  end
end



function Item_distribute_stats()
  --
  -- This distributes the item statistics (how much health and ammo to
  -- give to the player) into earlier rooms.
  --


  -- health mainly stays in same room (a reward for killing the monsters).
  -- ammo mainly goes back, to prepare player for the fight.
  local HEALTH_RATIO  = 0.35
  local AMMO_RATIO    = 0.90


  local function get_earlier_rooms(R)
    local list = {}

    local ratio = 1.0
    local total = 0.0

    local N = R

    while N.entry_conn do
      N = N.entry_conn:other_room(N)

      -- do not cross zones
      if N.zone != R.zone then break; end

      -- never move stuff into hallways
      if N.is_hallway then continue end

      -- give more in larger rooms
      local val = ratio * (N.svolume ^ 0.7)

      table.insert(list, { room=N, ratio=val })
      total = total + val

      ratio = ratio * 0.7
    end

    -- handle hallways that are entered from a different zone
    -- (i.e. via a keyed door).
    if R.is_hallway and table.empty(list) then
      N = R.entry_conn:other_room(N)

      table.insert(list, { room=N, ratio=1.0 })
      total = 1.0
    end

    -- adjust ratio values to be in range 0.0 - 1.0
    if total > 0 then
      each loc in list do
        loc.ratio = loc.ratio / total
      end
    end

    return list
  end


  local function distribute_to_room(R, N, ratio)
    -- ratio is a value between 0.0 and 1.0, based on the number
    -- and size of the earlier rooms (in the loc list).

    each CL,R_stats in R.item_stats do
      local N_stats = N.item_stats[CL]

      each stat,qty in R_stats do
        if qty <= 0 then continue end

        local value = qty * ratio

        -- apply a ratio based on type of item (on top of the room ratio)
        -- [ for hallways, we need EVERYTHING to go elsewhere ]
        if R.is_hallway then
          -- no change
        elseif stat == "health" then
          value = value * HEALTH_RATIO
        else
          value = value * AMMO_RATIO
        end

        N_stats[stat] = (N_stats[stat] or 0) + value
        R_stats[stat] =  R_stats[stat]       - value

--      gui.debugf("  distributing %s:%1.1f [%s]  %s --> %s\n",
--                 stat, value,  CL, R.name, N.name)
      end
    end
  end


  local function visit_room(R)
    -- no stats?
    if not R.item_stats then return end

    each loc in get_earlier_rooms(R) do
      distribute_to_room(R, loc.room, loc.ratio)
    end
  end


  local function dump_results()
    each R in LEVEL.rooms do
      if R.item_stats then
        gui.debugf("final result @ %s = \n%s\n", R.name,
                   table.tostr(R.item_stats, 2))
      end
    end
  end


  ---| Item_distribute_stats |---

  each R in LEVEL.rooms do
    visit_room(R)
  end

--DEBUG:
--  dump_results()
end



function Item_pickups_for_class(CL)
  --
  -- Once all monsters have been placed and all battles simulated
  -- (including cages and traps), then we can decide *what* pickups to add
  -- (the easy part) and *where* to place them (the hard part).
  --


  -- this accumulates excess stats
  -- e.g. if wanted health == 20 and we give a medikit, add 5 to excess["health"]
  local excess = {}


  local function grab_a_big_spot(R)
    local result = table.pick_best(R.big_spots,
            function(A, B) return A.score > B.score end, "remove")

    -- update remaining scores so next one chosen is far away
    each spot in R.big_spots do
      local dist = Monster_dist_between_spots(spot, result, 80) / 256

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
        local d = Monster_dist_between_spots(prev, spot)
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


  local function place_item_list(R, item_list)
    each pair in item_list do
      local item  = pair.item
      local count = pair.count

      -- big item?
      if ((item.rank or 0) >= 2 or pair.is_storage) and count == 1 and
         not table.empty(R.big_spots)
      then
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
      local prob = info.add_prob or 0

      if prob > 0 and
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
        bonus = 20 * HEALTH_FACTORS[OB_CONFIG.health]
      end
    end

    -- when getting a weapon, should get some ammo for it too
    if R.weapons then
      each name in R.weapons do
        local info = GAME.WEAPONS[name]

        if info.ammo and info.ammo == stat and info.bonus_ammo then
          bonus = bonus + info.bonus_ammo * AMMO_FACTORS[OB_CONFIG.ammo]
        end
      end
    end

    if OB_CONFIG.strength == "crazy" then
      bonus = bonus * 2
    end

    -- compensation for environmental hazards
    if stat == "health" and R.hazard_health then
      bonus = bonus + R.hazard_health * HEALTH_FACTORS[OB_CONFIG.health]
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


  local function select_pickups(R, item_list, stat, qty)
    assert(qty >= 0)

    if excess[stat] == nil then
       excess[stat] = 0
    end

    -- bonus stuff (e.g. ammo accompanying a weapon item)
    qty = qty + bonus_for_room(R, stat);

    if excess[stat] >= qty then
      -- excess ate it all, no pickups will be added for this stat
      excess[stat] = excess[stat] - qty
      return
    end

    -- TODO: extra health/ammo in every secret room

    qty = qty - excess[stat]
    assert(qty > 0)

    local excess_qty = do_select_pickups(R, item_list, stat, qty)

    -- there will usually be a small excess amount, since items come
    -- in discrete quantities.  accumulate it now.
    excess[stat] = excess[stat] + excess_qty
  end


  local function compare_items(A, B)
    local A_rank = A.item.rank or 0
    local B_rank = B.item.rank or 0

    if A_rank != B_rank then return A_rank > B_rank end

     return (A.count + A.random) > (B.count + B.random)
  end


  local function pickups_in_room(R)
    if table.empty(GAME.PICKUPS) then
      return
    end

    local stats = R.item_stats[CL]
    local item_list = {}

    each stat,qty in stats do
      select_pickups(R, item_list, stat, qty)

      gui.debugf("Item list for %s:%1.1f [%s] @ %s\n", stat,qty, CL, R.name)

      each pair in item_list do
        local item = pair.item
        gui.debugf("   %dx %s (%d)\n", pair.count, item.name,
                   item.give[1].health or item.give[1].count)
      end
    end

    rand.shuffle(R.item_spots)

    -- handle storage rooms
    if R.storage_items then
      place_item_list(R, R.storage_items)
    end

    -- sort items by rank
    -- also: place large clusters before small ones
    table.sort(item_list, compare_items)

    place_item_list(R, item_list)
  end


  ---| Item_pickups_for_class |---

  each R in LEVEL.rooms do
    pickups_in_room(R)
  end
end



function Item_add_pickups()

  gui.printf("\n--==| Item Pickups |==--\n\n")

  Item_distribute_stats()

  -- FIXME:
  -- 1. when no big item spots, convert important spots
  -- 2. when no small item spots, convert monster spots

  -- ensure item spots are fairly small
  each R in LEVEL.rooms do
    R.item_spots = Monster_split_spots(R.item_spots, 25)
  end

  each CL,_ in LEVEL.hmodels do
    Item_pickups_for_class(CL)
  end
end

