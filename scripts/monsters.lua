----------------------------------------------------------------
--  MONSTERS/HEALTH/AMMO
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2010 Andrew Apted
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


--[[

MONSTER SELECTION
=================

Main usages:
(a) free-range
(b) guarding something [keys]
(c) cages
(d) traps (triggered closets, teleport in)
(e) surprises (behind entry door, closets on back path)


IDEAS:

Free range monsters make up the bulk of the level, and are
subject to the palette.  The palette applies to a fair size
of a map, on "small" setting --> 1 palette only, upto 2 on
"regular", between 2-3 on "large" maps.

Trap and Surprise monsters can use any monster (actually
better when different from palette and different from
previous traps/surprises).

Cages and Guarding monsters should have a smaller and
longer-term palette, changing about 4 times less often
than the free-range palette.  MORE PRECISELY: palette
evolves about same rate IN TERMS OF # MONSTERS ADDED.

--------------------------------------------------------------]]

require 'defs'
require 'util'


-- Doom flags
DOOM_FLAGS =
{
  EASY    = 1,
  MEDIUM  = 2,
  HARD    = 4,
  AMBUSH  = 8,
}

-- Quake flags
QUAKE_FLAGS =
{
  AMBUSH     = 1,
  NOT_EASY   = 256,
  NOT_MEDIUM = 512,
  NOT_HARD   = 1024,
  NOT_DM     = 2048,
}


function Player_init()
  LEVEL.hmodels = {}

  for _,SK in ipairs(SKILLS) do
    local hm_set = table.deep_copy(GAME.PLAYER_MODEL)

    for CL,hmodel in pairs(hm_set) do
      hmodel.skill = SK
      hmodel.class = CL
    end -- for CL

    LEVEL.hmodels[SK] = hm_set
  end -- for SK
end


function Player_give_weapon(weapon, to_CL)
  gui.debugf("Giving weapon: %s\n", weapon)

  for _,SK in ipairs(SKILLS) do
    for CL,hmodel in pairs(LEVEL.hmodels[SK]) do
      if not to_CL or (to_CL == CL) then
        hmodel.weapons[weapon] = 1
      end
    end -- for CL
  end -- for SK
end


function Player_give_stuff(hmodel, give_list)
  for _,give in ipairs(give_list) do
    if give.health then
      gui.debugf("Giving [%s/%s] health: %d\n",
                 hmodel.class, hmodel.skill, give.health)
      hmodel.stats.health = hmodel.stats.health + give.health

    elseif give.ammo then
      gui.debugf("Giving [%s/%s] ammo: %dx %s\n",
                 hmodel.class, hmodel.skill, give.count, give.ammo)

      local count = assert(hmodel.stats[give.ammo])
      hmodel.stats[give.ammo] = count + give.count

    elseif give.weapon then
      gui.debugf("Giving [%s/%s] weapon: %s\n",
                 hmodel.class, hmodel.skill, give.weapon)

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
  -- We assume all skills have the same weapons.
  --
  -- If there are different classes (Hexen) then the result
  -- will be an average of each class, as all classes face
  -- the same monsters.

  local function get_firepower(hmodel)
    local firepower = 0 
    local divisor   = 0

    for weapon,_ in pairs(hmodel.weapons) do
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

  local SK = SKILLS[1]

  for CL,hmodel in pairs(LEVEL.hmodels[SK]) do
    fp_total = fp_total + get_firepower(hmodel)
    class_num = class_num + 1
  end -- for CL

  assert(class_num > 0)

  return fp_total / class_num
end


function Monsters_init()
  table.name_up(GAME.MONSTERS)
  table.name_up(GAME.WEAPONS)
  table.name_up(GAME.PICKUPS)

  for name,info in pairs(GAME.MONSTERS) do
    info.ent = GAME.ENTITIES[name]
    if not info.ent then
      error(string.format("Monster '%s' lacks entry in ENTITIES table", name))
    end
  end

  LEVEL.mon_stats = {}

  local low  = (MONSTER_QUANTITIES.scarce + MONSTER_QUANTITIES.less) / 2
  local high =  MONSTER_QUANTITIES.more

  LEVEL.prog_mons_qty    = low + LEVEL.ep_along * (high - low)
  LEVEL.mixed_mons_qty   = rand.range(low, high)

  -- build replacement table --

  LEVEL.mon_replacement = {}

  local dead_ones = {}

  for name,info in pairs(GAME.MONSTERS) do
    local orig = info.replaces
    if orig then
      assert(info.replace_prob)
      if not GAME.MONSTERS[orig] then
        dead_ones[name] = true
      else
        if not LEVEL.mon_replacement[orig] then
          -- the basic replacement table allows the monster to
          -- pick itself at the time of replacement.
          LEVEL.mon_replacement[orig] = { [orig]=70 }
        end
        LEVEL.mon_replacement[orig][name] = info.replace_prob
      end
    end
  end

  -- remove a replacement monster if the monster it replaces
  -- does not exist (e.g. stealth_gunner in DOOM 1 mode).
  for name,_ in pairs(dead_ones) do
    GAME.MONSTERS[name] = nil
  end
end


function Monsters_global_palette()
  -- Decides which monsters we will use on this level.
  -- Easiest way is to pick some monsters NOT to use.

  if not LEVEL.monster_prefs then
    LEVEL.monster_prefs = {}
  end

  LEVEL.global_palette = {}

  local max_level = (LEVEL.mon_along or 0) * 10

  max_level = math.clamp(1, max_level, 10)

stderrf("---------------> %1.3f\n", max_level)

  for name,info in pairs(GAME.MONSTERS) do
    if info.prob and info.prob > 0 and
       (info.level or 1) <= max_level
    then
      LEVEL.global_palette[name] = 1
    end
  end

  do return end


  --- OLD OLD:  FIXME

  -- is there enough monsters to actually bother?
  if #list <= 2 then return end

  rand.shuffle(list)

  -- sometimes promote a particular monster
  if rand.odds(30) then
    local promote = list[#list]
    local M = GAME.MONSTERS[promote]
    if not M.never_promote then
      gui.debugf("Promoting monster: %s\n", promote)
      LEVEL.monster_prefs[promote] = 3.5
      table.remove(list, #list)
    end
  end

  if PARAM.skip_monsters then
    local skip_list = {}
    local skip_total = 0

    for _,name in ipairs(list) do
      local M = GAME.MONSTERS[name]
      local prob = M.skip_prob or 50
      if prob > 0 then
        -- NOTE: we _could_ adjust probability based on Strength setting.
        -- _BUT_ it is probably better not to, otherwise we would just be
        -- skipping monsters which would not have been added anyway.

        -- adjust skip chance based on monster_prefs
        if LEVEL.monster_prefs then
          prob = prob / (LEVEL.monster_prefs[name] or 1)
        end
        if THEME.monster_prefs then
          prob = prob / (THEME.monster_prefs[name] or 1)
        end

        skip_list[name] = prob
gui.debugf("skip_list %s = %1.0f\n", name, prob)
        skip_total = skip_total + 1
      end
    end

    local perc  = rand.range(PARAM.skip_monsters[1], PARAM.skip_monsters[2])
    local count = int(#list * perc / 100 + gui.random())

    if count >= skip_total then count = skip_total - 1 end

    for i = 1,count do
      if table.empty(skip_list) then break; end

      local name = rand.key_by_probs(skip_list)
      skip_list[name] = nil

      gui.debugf("Skipping monster: %s\n", name)
      LEVEL.global_skip[name] = 1
    end
  end
end


function Monsters_do_pickups()

  local function distribute(R, qty, D)  -- Dest
    for _,SK in ipairs(SKILLS) do
      for CL,stats in pairs(R.fight_stats[SK]) do
        local dest_am = D.fight_stats[SK][CL]

        for stat,count in pairs(stats) do
          if count > 0 then
            dest_am[stat] = (dest_am[stat] or 0) + count * qty
            stats[stat]   = count * (1-qty)

            gui.debugf("Distributing %s:%1.1f  [%s/%s]  ROOM_%d --> ROOM_%d\n",
                       stat, count*qty,  CL, SK,  R.id, D.id)
          end
        end
      end -- for CL
    end -- for SK
  end


  local function get_storage_prefs(arena)
    local ratios = {}

    for i = 1, #arena.storage_rooms do
      ratios[i] = rand.irange(2,5)
    end

    return ratios, arena.storage_rooms
  end


  local function get_previous_prefs(R)
    local room_list = {}
    local ratios = {}

    local PREV = R

    while PREV.entry_conn and #room_list < 4 do
      PREV = PREV.entry_conn:neighbor(PREV)

      local qty = rand.irange(3,5) / (1 + #room_list)

      table.insert(room_list, PREV)
      table.insert(ratios, qty)
    end

    return ratios, room_list
  end


  local function distribute_to_list(R, qty, ratios, room_list)
    assert(#ratios == #room_list)

    local total = 0

    for i = 1,#ratios do
      total = total + ratios[i]
    end

    for i = 1,#ratios do
      distribute(R, qty * ratios[i] / total, room_list[i])
    end
  end


  local function distribute_fight_stats(R)
    if R.is_storage then return end

    do
      distribute_to_list(R, 0.50, get_previous_prefs(R))
---!!!      distribute_to_list(R, 0.30, get_storage_prefs(R.arena))
    end
  end


  local function sort_spots(R)
    rand.shuffle(R.item_spots)
  end


  local function decide_pickup(R, stat, qty)
    local item_tab = {}

    for name,info in pairs(GAME.PICKUPS) do
      if info.prob and
         (stat == "health" and info.give[1].health) or
         (info.give[1].ammo == stat)
      then
        item_tab[name] = info.prob

        if R.purpose == "START" and info.start_prob then
          item_tab[name] = info.start_prob
        end

---###    local each_qty = info.give[1].health or info.give[1].count
---###    local min_num  = (info.cluster and info.cluster[1]) or 1
---###    local max_num  = (info.cluster and info.cluster[2]) or 1
---###    if each_qty * max_num > qty then prob = prob / 20 end
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


  local function select_pickups(R, item_list, stat, qty, hmodel)
gui.debugf("Initial %s = %1.1f\n", stat, hmodel.stats[stat])

    -- subtract any previous gotten stuff
    qty = qty - hmodel.stats[stat]
    hmodel.stats[stat] = 0

    -- more ammo in start room
    local excess = 0

    if stat == R.weapon_ammo then
      if qty > 0 then
        excess = sel(OB_CONFIG.strength == "crazy", 1.2, 0.6) * qty
      end

      if GAME.AMMOS and GAME.AMMOS[stat] then
        excess = math.max(excess, GAME.AMMOS[stat].start_bonus)
      end
      gui.debugf("Bonus %s = %1.1f\n", stat, excess)
    end

    qty = qty + excess

    while qty > 0 do
      local item, count = decide_pickup(R, stat, qty)
      table.insert(item_list, { item=item, count=count, SK=hmodel.skill, random=gui.random() })
      
      if stat == "health" then
        qty = qty - item.give[1].health * count
      else
        assert(item.give[1].ammo)
        qty = qty - item.give[1].count * count
      end
    end

    excess = excess + (-qty)

    -- accumulate any excess quantity into the hmodel

    if excess > 0 then
gui.debugf("Excess %s = %1.1f\n", stat, excess)
      hmodel.stats[stat] = assert(hmodel.stats[stat]) + excess
    end
  end


  local function place_item(item_name, x, y, z, SK)
    local props = {}

    if PARAM.use_spawnflags then
      if SK == "easy" then
        props.spawnflags = QUAKE_FLAGS.NOT_MEDIUM + QUAKE_FLAGS.NOT_HARD
      elseif SK == "medium" then
        props.spawnflags = QUAKE_FLAGS.NOT_EASY + QUAKE_FLAGS.NOT_HARD
      elseif SK == "hard" then
        props.spawnflags = QUAKE_FLAGS.NOT_EASY + QUAKE_FLAGS.NOT_MEDIUM
      end
    else
      if SK == "easy" then
        props.flags = DOOM_FLAGS.EASY
      elseif SK == "medium" then
        props.flags = DOOM_FLAGS.MEDIUM
      elseif SK == "hard" then
        props.flags = DOOM_FLAGS.HARD
      end
    end

    Trans.entity(item_name, x, y, z, props)
  end


  local function place_big_item(spot, item, SK)
    local x, y = spot.x, spot.y

    -- assume big spots will sometimes run out (and be reused),
    -- so don't put multiple items at exactly the same place.
    x = x + rand.irange(-16, 16)
    y = y + rand.irange(-16, 16)

    place_item(item, x, y, spot.z, SK)
  end


  local function OLD__place_small_item(spot, item, count, SK)
    local x1, y1 = spot.x, spot.y
    local x2, y2 = spot.x, spot.y

    if count == 1 then
      place_item(spot.S, item, x1,y1, SK)
      return
    end

    local away = sel(count == 2, 20, 40)
    local dir  = spot.dir

    if geom.is_vert(dir) then
      y1, y2 = y1-away, y2+away
    elseif geom.is_horiz(dir) then
      x1, x2 = x1-away, x2+away
    elseif dir == 1 or dir == 9 then
      x1, y1 = x1-away, y1-away
      x2, y2 = x2+away, y2+away
    elseif dir == 3 or dir == 7 then
      x1, y1 = x1-away, y1+away
      x2, y2 = x2+away, y2-away
    else
      error("place_small_item: bad dir: " .. tostring(dir))
    end

    for i = 1,count do
      local x = x1 + (x2 - x1) * (i-1) / (count-1)
      local y = y1 + (y2 - y1) * (i-1) / (count-1)

      place_item(spot.S, item, x, y, SK)
    end
  end


  local function place_item_list(R, item_list, SK, CL)
    for _,pair in ipairs(item_list) do
      local item  = pair.item
      local count = pair.count
      local spot

      if item.big_item and not table.empty(R.big_item_spots) then
        assert(count == 1)

        spot = table.remove(R.big_item_spots)
        spot.x, spot.y = geom.box_mid(spot.x1, spot.y1, spot.x2, spot.y2)
        spot.z = spot.z1

        place_big_item(spot, item.name, SK, CL)
      else
        for i = 1,count do
          spot = table.remove(R.item_spots, 1)
          table.insert(R.item_spots, spot)

          place_item(item.name, spot.x, spot.y, spot.z, SK)
        end
      end
    end
  end


  local function pickups_for_hmodel(R, SK, CL, hmodel)
    if table.empty(GAME.PICKUPS) then
      return
    end

    local item_list = {}

    local stats = R.fight_stats[SK][CL]

    for stat,qty in pairs(stats) do
      if qty > 0 then
        select_pickups(R, item_list, stat, qty, hmodel)

        gui.debugf("Item list for %s:%1.1f [%s/%s] @ %s\n", stat,qty, CL,SK, R:tostr())
        for _,pair in ipairs(item_list) do
          local item = pair.item
          gui.debugf("   %dx %s (%d) @ %s\n", pair.count, item.name,
                     item.give[1].health or item.give[1].count, SK)
        end
      end
    end

    sort_spots(R)

    -- place large clusters before small ones
    table.sort(item_list, function(A,B) return (A.count + A.random) > (B.count + B.random) end)

    -- FIXME: place weapon in layout code
    if R.weapon then
      table.insert(item_list, 1, { item={ name=R.weapon, big_item=true }, count=1, SK=SK})
    end

    place_item_list(R, item_list, SK, CL)
  end


  local function pickups_in_room(R)
gui.debugf("Weapon_ammo @ %s --> %s\n", R:tostr(), tostring(R.weapon_ammo))

      for _,SK in ipairs(SKILLS) do
        for CL,hmodel in pairs(LEVEL.hmodels[SK]) do
          pickups_for_hmodel(R, SK, CL, hmodel)
        end -- for CL
      end -- for SK

  end


  ---| Monsters_do_pickups |---

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.kind ~= "stairwell" and R.kind ~= "smallexit" then
      distribute_fight_stats(R)
    end
  end

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.kind ~= "stairwell" and R.kind ~= "smallexit" then
      pickups_in_room(R)
    end
  end
end


function Monsters_fill_room(R)

  local function is_big(mon)
    return GAME.ENTITIES[mon].r > 30
  end

  local function is_huge(mon)
    return GAME.ENTITIES[mon].r > 60
  end


  local function calc_toughness()
    -- determine a "toughness" value, where 1.0 is easy and
    -- higher values produces tougher monsters.

    -- each level gets progressively tougher
    local toughness = LEVEL.episode + LEVEL.ep_along * 4

    -- spice it up
    local spice = gui.random()
    toughness = toughness + spice * spice

    if R.quest.id == 1 and #LEVEL.all_quests > 1 then
      -- be kinder around the starting area
      toughness = toughness * 0.7
    elseif R:is_near_exit() then
      -- give the player greater resistance near the exit
      toughness = toughness + 3
    elseif R.hallway then
      -- don't fill hallways with big beasts
      toughness = rand.range(1.0, 2.0)
    end

    gui.debugf("Toughness = %1.3f\n", toughness)

    return toughness
  end


  local function calc_quantity()
    local qty

    if LEVEL.quantity then
      qty = LEVEL.quantity

    elseif OB_CONFIG.mons == "mixed" then
      qty = LEVEL.mixed_mons_qty

    elseif OB_CONFIG.mons == "prog" then
      qty = LEVEL.prog_mons_qty

    else
      qty = MONSTER_QUANTITIES[OB_CONFIG.mons]
    end

    assert(qty);

    if OB_CONFIG.mode == "coop" then
      qty = qty * COOP_MON_FACTOR
    end

    gui.debugf("Quantity = %1.0f\n", qty)
    return qty
  end


  local function prob_for_mon(info, fp, toughness)
    local name = info.name
    local prob = info.prob

    if THEME.force_mon_probs then
      prob = THEME.force_mon_probs[name] or
             THEME.force_mon_probs._else
      if prob then return prob end
    end

    if not LEVEL.global_palette[name] then
      return 0
    end

    prob = prob or 0

    -- TODO: merge THEME.monster_prefs into LEVEL.monster_prefs
    if LEVEL.monster_prefs then
      prob = prob * (LEVEL.monster_prefs[name] or 1)
    end
    if THEME.monster_prefs then
      prob = prob * (THEME.monster_prefs[name] or 1)
    end

    if R.room_type and R.room_type.monster_prefs then
      prob = prob * (R.room_type.theme.monster_prefs[name] or 1)
    end

    if prob == 0 then return 0 end


    local time   = info.health / fp
    local damage = info.damage * time

    if info.attack == "melee" then
      damage = damage / 4.0
    elseif info.attack == "missile" then
      damage = damage / 1.5
    end

    if toughness > 1 then
      time = time / math.sqrt(toughness)
    end

    damage = damage / toughness

    if PARAM.time_factor then
      time = time * PARAM.time_factor
    end
    if PARAM.damage_factor then
      damage = damage * PARAM.damage_factor
    end

    gui.debugf("  %s --> damage:%1.1f   time:%1.2f\n", name, damage, time)


    -- would the monster take too long to kill?
    local max_time = MONSTER_MAX_TIME[OB_CONFIG.strength] or 15

    if time >= max_time then return 0 end

    if time > max_time/2 then
      local factor = (max_time - time) / (max_time/2)
      prob = prob * factor
    end


    -- would the monster inflict too much damage on the player?
    local max_damage = MONSTER_MAX_DAMAGE[OB_CONFIG.strength] or 200
    local low_damage = MONSTER_LOW_DAMAGE[OB_CONFIG.strength] or 1

    if damage >= max_damage then return 0 end

    if damage > max_damage/2 then
      local factor = (max_damage - damage) / (max_damage/2)
      prob = prob * factor
    end

    if damage < low_damage then
      local factor = 0.5 ---  damage / low_damage
      prob = prob * factor
    end

    if R.outdoor then
      prob = prob * (info.outdoor_factor or 1)
    end

    return prob
  end


  local function number_of_kinds(fp)
    local size = (R.tw or R.sw) + (R.th or R.sh)
    local num  = int(size / 5.0 + 0.55 + gui.random())

    if num < 1 then num = 1 end
    if num > 4 then num = 4 end

    local ONE_MORE_CHANCES = { normal=30, more=50, heaps=80 }

    local bump_prob = ONE_MORE_CHANCES[OB_CONFIG.mons] or 20

    if rand.odds(bump_prob) then
      num = num + 1
    end

    return num
  end


  local function crazy_palette()
    local size = (R.tw or R.sw) + (R.th or R.sh)
    local num_kinds = int(size / 2)

    local list = {}

    for name,info in pairs(GAME.MONSTERS) do
      local prob = info.crazy_prob or info.prob or 0

---      if not LEVEL.global_palette[name] then
---        prob = 0
---      end

      if THEME.force_mon_probs then
        prob = THEME.force_mon_probs[name] or
               THEME.force_mon_probs._else or prob  
      end

      if prob > 0 and LEVEL.monster_prefs then
        prob = prob * (LEVEL.monster_prefs[name] or 1)
        if info.replaces then
          prob = prob * (LEVEL.monster_prefs[info.replaces] or 1)
        end
      end

      if prob > 0 then
        list[name] = prob
      end
    end

    local palette = {}

    gui.debugf("Monster palette: (%d kinds, %d actual)\n", num_kinds, table.size(list))

    for i = 1,num_kinds do
      if table.empty(list) then break; end

      local mon = rand.key_by_probs(list)
      palette[mon] = list[mon]

      gui.debugf("  #%d %s\n", i, mon)
      LEVEL.mon_stats[mon] = (LEVEL.mon_stats[mon] or 0) + 1

      list[mon] = nil
    end

    return palette
  end


  local function select_monsters(toughness)
    if OB_CONFIG.strength == "crazy" then
      return crazy_palette()
    end

    local fp = Player_firepower()
    gui.debugf("Firepower = %1.3f\n", fp)
    
    local list = {}
    gui.debugf("Monster list:\n")

    for name,info in pairs(GAME.MONSTERS) do
      local prob = prob_for_mon(info, fp, toughness)

      if prob > 0 then
        list[name] = prob
        gui.debugf("  %s --> prob:%1.1f\n", name, prob)
      end
    end

    local num_kinds = number_of_kinds(fp)

    local palette = {}

    gui.debugf("Monster palette: (%d kinds, %d actual)\n", num_kinds, table.size(list))

    for i = 1,num_kinds do
      if table.empty(list) then break; end

      local mon  = rand.key_by_probs(list)
      local prob = list[mon]
      list[mon] = nil

      -- sometimes replace it completely (e.g. all demons become spectres)
      if rand.odds(25) and LEVEL.mon_replacement[mon] then
        mon = rand.key_by_probs(LEVEL.mon_replacement[mon])
      end

      palette[mon] = prob

      gui.debugf("  #%d %s\n", i, mon)
      LEVEL.mon_stats[mon] = (LEVEL.mon_stats[mon] or 0) + 1
    end

    return palette
  end


  local function FIXME__monster_fits(S, mon, info)
    if S.usage or S.no_monster or not S.floor_h then
      return false
    end

    -- keep entryway clear
    if R.entry_conn and S:has_conn(R.entry_conn) then
      return false
    end

    -- check seed kind
    -- (floating monsters can go in more places)
    if S.kind == "walk" or (S.kind == "liquid" and info.float) then
      -- OK
    else
      return false
    end

    -- check if fits vertically
    local ceil_h = S.ceil_h or R.ceil_h or SKY_H
    local ent = assert(GAME.ENTITIES[mon])

    if ent.h >= (ceil_h - S.floor_h - 1) then
      return false
    end

    if is_huge(mon) and S.solid_corner then
      return false
    end

    return true
  end


  local function try_occupy_spot(spot, mon, totals)
    local info = GAME.MONSTERS[mon]
    local ent  = GAME.ENTITIES[mon]

    if ent.r * 2 > (spot.x2 - spot.x1 - 4) then return false end
    if ent.r * 2 > (spot.y2 - spot.y1 - 4) then return false end

    if ent.h > (spot.z2 - spot.z1 - 2) then return false end

    spot.monster = mon
    spot.info    = info

    totals[mon] = totals[mon] + 1
    return true
  end


  local function create_monster_map(palette)

    -- adjust probs in palette to account for monster size,
    -- e.g. we can fit 4 revenants in the same space as a mancubus.

    local pal2 = {}

    for mon,prob in pairs(palette) do
      pal2[mon] = prob

      if is_big(mon) then
        pal2[mon] = pal2[mon] * 3
      end
    end

    return pal2
  end


  local function monster_angle(S)
    -- TODO: sometimes make all monsters (or a certain type) face
    --       the same direction, or look towards the entrance, or
    --       towards the guard_spot.

    if rand.odds(20) then
      return rand.irange(0,7) * 45
    end

    local delta = rand.irange(-1,1) * 45

    if R.sh > R.sw then
      if S.sy > (R.sy1 + R.sy2) / 2 then 
        return 270 + delta
      else
        return 90 + delta
      end
    else
      if S.sx > (R.sx1 + R.sx2) / 2 then 
        return 180 + delta
      else
        return sel(delta < 0, 315, delta)
      end
    end
  end


  local function add_to_list(SK, info)
    if not R.monster_list[SK] then
      R.monster_list[SK] = {}
    end

    table.insert(R.monster_list[SK], info)
  end


  local function calc_min_skill()
    if not LEVEL.mon_dither then
      LEVEL.mon_dither = 0
    end

    -- bump the dither, but have some randomness here too
    if rand.odds(80) then
      LEVEL.mon_dither = LEVEL.mon_dither + 1
    end

    -- skill 3 (hard) is always added
    -- skill 2 (medium) alternates between 100% and 50% chance
    -- skill 1 (easy) is always 50% chance of adding

    if (LEVEL.mon_dither % 2) == 0 then
      return rand.sel(50, 1, 2)
    else
      return rand.sel(50, 1, 3)
    end
  end


  local function place_monster(mon, x, y, z)
    local angle  = 0 --!!!!! FIXME spot.angle or monster_angle(spot.S)
    local ambush = rand.sel(92, 1, 0)

    local info = GAME.MONSTERS[mon]

    -- handle replacements
    if LEVEL.mon_replacement[mon] and not R.no_replacement then
      mon  = rand.key_by_probs(LEVEL.mon_replacement[mon])
      info = assert(GAME.MONSTERS[mon])
    end

    -- minimum skill needed for the monster to appear
    local skill = calc_min_skill()

    if skill <= 3 then add_to_list(SKILLS[3], info) end
    if skill <= 2 then add_to_list(SKILLS[2], info) end
    if skill <= 1 then add_to_list(SKILLS[1], info) end

    local props = { }

    if PARAM.pyr_angles then
      props.angles = string.format("0 %d 0", angle)
    else
      props.angle = angle
    end

    if PARAM.use_spawnflags then
      props.spawnflags = 0

      if ambush then
        props.spawnflags = props.spawnflags + QUAKE_FLAGS.AMBUSH
      end

      if (skill > 1) then props.spawnflags = props.spawnflags + QUAKE_FLAGS.NOT_EASY end
      if (skill > 2) then props.spawnflags = props.spawnflags + QUAKE_FLAGS.NOT_MEDIUM end
    else
      props.flags = DOOM_FLAGS.HARD

      if ambush then
        props.flags = props.flags + DOOM_FLAGS.AMBUSH
      end

      if (skill <= 1) then props.flags = props.flags + DOOM_FLAGS.EASY end
      if (skill <= 2) then props.flags = props.flags + DOOM_FLAGS.MEDIUM end
    end

    Trans.entity(mon, x, y, z, props)
  end


  local function OLD__place_barrel(spot)
    if spot.S:has_any_conn() or spot.S.kind ~= "walk" then
      return
    end

    local mx = (spot.x1 + spot.x2) / 2
    local my = (spot.y1 + spot.y2) / 2

    Trans.entity("barrel", mx, my, spot.z1)

    spot.S.usage = "monster"  -- allow items to exist here
  end


  local function how_many_for_spot(mon, spot)
    local ent  = GAME.ENTITIES[mon]

    -- FIXME !!!
    -- if ent.h >= (spot.z2 - spot.z1) then return 0 end

    local w, h = geom.box_size(spot.x1, spot.y1, spot.x2, spot.y2)

    w = int(w / ent.r / 2.2)
    h = int(h / ent.r / 2.2)

    return w * h
  end


  local function place_in_spot(mon, spot, count)
    local ent  = GAME.ENTITIES[mon]

    local w, h = geom.box_size(spot.x1, spot.y1, spot.x2, spot.y2)

    w = int(w / ent.r / 2.2)
    h = int(h / ent.r / 2.2)

    for mx = 1,w do for my = 1,h do
      local x = spot.x1 + ent.r * 2.2 * (mx-0.5)
      local y = spot.y1 + ent.r * 2.2 * (my-0.5)
      local z = spot.z1

      place_monster(mon, x, y, z)

      count = count - 1
      if count < 1 then return end
    end end

    -- TODO
  end


  local function try_add_monster(mon, max_num)
    local info = GAME.MONSTERS[mon]
    local ent  = GAME.ENTITIES[mon]

    -- find a spot
    for idx,spot in ipairs(R.mon_spots) do
      local fit_num = how_many_for_spot(mon, spot)
      if fit_num >= 1 then
gui.printf("fit_num = %d  max = %d\n", fit_num, max_num)
        fit_num = math.min(fit_num, max_num)
        place_in_spot(mon, spot, fit_num)

        table.remove(R.mon_spots, idx)
        return fit_num
      end
    end

    return 0  -- not possible
  end


  local function how_many_dudes(mon, count, qty)
    local info = GAME.MONSTERS[mon]

    if count <= 1 then return count end

    count = count * (qty / 100.0)

    -- adjust quantity based on monster's health
    if info.density then
      count = count * info.density
    end
 
    -- some random variation
    count = count * rand.range(MON_VARIATION_LOW, MON_VARIATION_HIGH)
    count = count + gui.random() ^ 2

    return math.max(1, int(count))
  end


  local function fill_monster_map(palette, barrel_chance)
    local pal2 = create_monster_map(palette)

    -- add at least one monster of each kind
    for pass = 1,-3 do  -- FIXME
      for mon,prob in pairs(palette) do
        if (pass == 1 and is_huge(mon)) or
           (pass == 2 and is_big(mon) and not is_huge(mon)) or
           (pass == 3 and not is_big(mon))
        then
          try_add_monster(mon, 1)
        end
      end
    end


    local qty = calc_quantity()

    local count = math.min(6, R.sw) * math.min(6 * R.sh)
    count = int(count / 5)


    local wants = {}

    for mon,_ in pairs(palette) do
      wants[mon] = how_many_dudes(mon, count, qty) - 1

      if wants[mon] < 1 then
         wants[mon] = nil
         pal2[mon]  = nil
      end
    end


    while not table.empty(pal2) and not table.empty(R.mon_spots) do
      local mon = rand.key_by_probs(pal2)

      if wants[mon] >= 1 then
        local actual = try_add_monster(mon, wants[mon])
gui.debugf("wanted %d : actual %d\n", wants[mon], actual)

        if actual == 0 or actual >= wants[mon] then
          wants[mon] = nil
          pal2[mon]  = nil
        else
          wants[mon] = wants[mon] - actual
        end
      end
    end
  end


  local function add_monsters()
    local toughness = calc_toughness()

    local palette = select_monsters(toughness)

    local barrel_chance = sel(R.outdoor, 2, 15)
    if R.natural then barrel_chance = 3 end
    if R.hallway then barrel_chance = 5 end

    if STYLE.barrels == "heaps" or rand.odds( 5) then barrel_chance = barrel_chance * 4 + 10 end
    if STYLE.barrels == "few"   or rand.odds(25) then barrel_chance = barrel_chance / 4 end

    if STYLE.barrels == "none" then barrel_chance = 0 end

    -- sometimes prevent monster replacements
    if rand.odds(40) or OB_CONFIG.strength == "crazy" then
      R.no_replacement = true
    end

    -- FIXME: add barrels even when no monsters in room

    if not table.empty(palette) then
      fill_monster_map(palette, barrel_chance)
    end
  end


  local function make_empty_stats()
    local stats = {}

    for _,SK in ipairs(SKILLS) do
      stats[SK] = {}
      for CL,_ in pairs(GAME.PLAYER_MODEL) do
        stats[SK][CL] = {}
      end
    end

    return stats
  end


  local function collect_weapons(hmodel)
    local list = {}

    for name,_ in pairs(hmodel.weapons) do
      local info = assert(GAME.WEAPONS[name])
      if info.pref then
        table.insert(list, info)
      end
    end

    if #list == 0 then
      error("No usable weapons???")
    end

    return list
  end


  local function give_monster_drops(mon_list, hmodel)
    for _,info in ipairs(mon_list) do
      if info.give then
        Player_give_stuff(hmodel, info.give)
      end
    end
  end


  local function user_adjust_result(stats)
    -- apply the user's health/ammo adjustments here

    local heal_mul = HEALTH_AMMO_ADJUSTS[OB_CONFIG.health]
    local ammo_mul = HEALTH_AMMO_ADJUSTS[OB_CONFIG.ammo]

    heal_mul = heal_mul * (PARAM.health_factor or 1)
    ammo_mul = ammo_mul * (PARAM.ammo_factor or 1)

    if OB_CONFIG.mode == "coop" then
      heal_mul = heal_mul * COOP_HEALTH_FACTOR
      ammo_mul = ammo_mul * COOP_AMMO_FACTOR
    end

    for name,qty in pairs(stats) do
      stats[name] = qty * sel(name == "health", heal_mul, ammo_mul)
    end
  end


  local function subtract_gotten_stuff(stats, hmodel)
    for name,got_qty in pairs(hmodel.stats) do
      local st_qty = stats[name] or 0
      if st_qty > 0 and got_qty > 0 then
        local min_q = math.min(st_qty, got_qty)

        hmodel.stats[name] = hmodel.stats[name] - min_q
               stats[name] =        stats[name] - min_q
      end
    end
  end


  local function sim_battle(CL, hmodel, SK, mon_list)
    local weap_list = collect_weapons(hmodel)

    local stats = R.fight_stats[SK][CL]

    gui.debugf("Fight simulator @ %s  SK:%s\n", R:tostr(), SK)
    gui.debugf("weapons = \n")
    for _,info in ipairs(weap_list) do
      gui.debugf("  %s\n", info.name)
    end

    local weap_prefs = LEVEL.weap_prefs or THEME.weap_prefs or {}

    Fight_simulator(mon_list, weap_list, weap_prefs, SK, stats)

    gui.debugf("raw result = \n%s\n", table.tostr(stats,1))

    user_adjust_result(stats)
    gui.debugf("adjusted result = \n%s\n", table.tostr(stats,1))

    give_monster_drops(mon_list, hmodel)

    subtract_gotten_stuff(stats, hmodel)

    gui.debugf("final result = \n%s\n", table.tostr(stats,1))
  end


  ---| Monsters_fill_room |---

  gui.debugf("Monsters_fill_room @ %s\n", R:tostr())

  R.monster_list = {}
  R.fight_stats  = make_empty_stats()

  R.big_item_spots = table.deep_copy(R.mon_spots)

  if OB_CONFIG.mons == "none" then
    return
  end

  if R.kind == "stairwell" then return end
  if R.kind == "smallexit" then return end

  assert(R.kind ~= "scenic")

  if R.purpose == "START" and not R.has_raising_start then
    return
  end


  add_monsters()


  -- simulate the battle!!

  for _,SK in ipairs(SKILLS) do
    local mon_list = R.monster_list[SK]
    if mon_list and #mon_list >= 1 then

      for CL,hmodel in pairs(LEVEL.hmodels[SK]) do
        sim_battle(CL, hmodel, SK, mon_list)
      end
    end
  end -- for SK
end


function Monsters_show_stats()
  local total = 0
  for _,count in pairs(LEVEL.mon_stats) do
    total = total + count
  end

  local function get_stat(mon)
    local num = LEVEL.mon_stats[mon] or 0
    local div = int(num * 99.8 / total)
    if div == 0 and num > 0 then div = 1 end
    return string.format("%02d", div)
  end

  if total == 0 then
    gui.debugf("STATS  no monsters at all\n")
  else
    gui.debugf("STATS  zsi:%s,%s,%s  crk:%s,%s,%s  mvb:%s,%s,%s  gap:%s,%s,%s\n",
               get_stat("zombie"), get_stat("shooter"), get_stat("imp"),
               get_stat("caco"), get_stat("revenant"), get_stat("knight"),
               get_stat("mancubus"), get_stat("vile"), get_stat("baron"),
               get_stat("gunner"), get_stat("arach"), get_stat("pain"))
  end
end


function Monsters_make_battles()
  
  gui.printf("\n--==| Make Battles |==--\n\n")

  Player_init()

  Monsters_init()
  Monsters_global_palette()

  Levels_invoke_hook("make_battles", LEVEL.seed)

  local cur_quest = -1

  -- Rooms have been sorted into a visitation order, so we
  -- simply visit them one-by-one and insert some monsters
  -- and simulate each battle.

  for _,R in ipairs(LEVEL.all_rooms) do
    if R.quest.weapon and (R.quest.id > cur_quest) then
      Player_give_weapon(R.quest.weapon)
      cur_quest = R.quest.id
    end

    Monsters_fill_room(R)
  end

  Monsters_show_stats()

  -- Once all monsters have been chosen and all battles
  -- (including cages and traps) have been simulated, then
  -- we can decide what pickups to add (the easy part) and
  -- _where_ to place them (the hard part).

  Monsters_do_pickups()
end

