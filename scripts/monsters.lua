----------------------------------------------------------------
--  MONSTERS/HEALTH/AMMO
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2008-2009 Andrew Apted
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
(e) surprises (behind entry door, closests on back path)


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


function Player_init()
  PLAN.hmodels = {}

  for _,SK in ipairs(SKILLS) do
    local hm_set = deep_copy(GAME.initial_model)

    for CL,hmodel in pairs(hm_set) do
      hmodel.skill = SK
      hmodel.class = CL
    end -- for CL

    PLAN.hmodels[SK] = hm_set
  end -- for SK
end

function Player_give_weapon(weapon, to_CL)
  gui.debugf("Giving weapon: %s\n", weapon)

  for _,SK in ipairs(SKILLS) do
    for CL,hmodel in pairs(PLAN.hmodels[SK]) do
      if not to_CL or (to_CL == CL) then
        hmodel.weapons[weapon] = 1
      end
    end -- for CL
  end -- for SK
end

function Player_calc_firepower()
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
      local info = assert(GAME.weapons[weapon])

      local dm = info.damage * info.rate
      if info.splash then dm = dm + info.splash[1] end

      -- melee attacks are hard to use
      if info.attack == "melee" then
        dm = dm / 3.0
      end

      local pref = info.pref or 1

---   gui.debugf("  weapon:%s dm:%1.1f pref:%1.1f\n", weapon, dm, pref)

      firepower = firepower + dm * pref
      divisor   = divisor + pref
    end

    if divisor == 0 then
      error("Player_calc_firepower: no weapons???")
    end

    return firepower / divisor
  end

  ---| Player_calc_firepower |---

  local fp_total  = 0
  local class_num = 0

  local SK = SKILLS[1]

  for CL,hmodel in pairs(PLAN.hmodels[SK]) do
    fp_total = fp_total + get_firepower(hmodel)
    class_num = class_num + 1
  end -- for CL

  assert(class_num > 0)

  return fp_total / class_num
end


function Monsters_init()
  for name,info in pairs(GAME.monsters) do
    info.name  = name
    info.thing = assert(GAME.things[name])
  end

  PLAN.mon_stats = {}
end


function Monsters_do_pickups()
  -- FIXME: pickups
end


function Monsters_in_room(R)

  local MONSTER_QUANTITIES =
  {
     scarce=10, less=18, normal=25, more=32, heaps=42
  }

  local MONSTER_TOUGHNESS =
  {
    scarce=0.8, less=0.8, normal=1.0, more=1.2, heaps=1.2
  }


  local function is_big(mon)
    return GAME.things[mon].r > 34
  end

  local function is_huge(mon)
    return GAME.things[mon].r > 64
  end

  local function calc_toughness()
    -- determine a "toughness" value, where 1.0 is normal and
    -- higher values (upto ~ 4.0) produces tougher monsters.

    local toughness = MONSTER_TOUGHNESS[OB_CONFIG.mons] or
                      PLAN.mixed_mons_tough  -- "mixed" setting

    -- each level gets progressively tougher
    if LEVEL.toughness then
      toughness = toughness * LEVEL.toughness
    elseif OB_CONFIG.length ~= "single" then
      toughness = toughness * (1 + LEVEL.ep_along * 3.0)
    end

    -- within a level, each arena naturally gets tougher
    -- due to the player picking up new weapons.

    gui.debugf("Toughness = %1.3f\n", toughness)

    return toughness
  end


  local function prob_for_mon(info, fp, toughness)

    local name = info.name
    local prob = info.prob

    if LEVEL.monster_prefs then
      prob = prob * (LEVEL.monster_prefs[name] or 1)
    end

    if PLAN.theme.monster_prefs then
      prob = prob * (PLAN.theme.monster_prefs[name] or 1)
    end

    if R.room_type and R.room_type.monster_prefs then
      prob = prob * (R.room_type.theme.monster_prefs[name] or 1)
    end

    if prob == 0 then return 0 end


    local time   = info.health / fp
    local damage = info.damage * time

    gui.debugf("  %s --> damage:%1.1f (%1.1f)  time:%1.2f\n", name, damage, damage/toughness, time)

    if time >= PARAMS.mon_time_max then return 0 end

    -- adjust damage by toughness factor
    damage = damage / toughness

    if damage >= PARAMS.mon_damage_max then return 0 end

    if damage > PARAMS.mon_damage_high then
      local diff =   PARAMS.mon_damage_max - PARAMS.mon_damage_high
      prob = prob * (PARAMS.mon_damage_max - damage) / diff
    end

    if damage < PARAMS.mon_damage_low then
      prob = prob * (damage / PARAMS.mon_damage_low)
    end

    if info.invis and R.outdoor then
      prob = prob * 3
    end

    return prob
  end

  local function select_monsters(toughness)
    -- FIXME: guard monsters !!!

    local fp = Player_calc_firepower()
    gui.debugf("Firepower = %1.3f\n", fp)
    
    local list = {}
    gui.debugf("Monster list:\n")

    local fallback

    for name,info in pairs(GAME.monsters) do
      if info.prob then

        -- just in case we end up with no monsters
        if not fallback or info.prob < fallback.prob then
          fallback = info
        end

        local prob = prob_for_mon(info, fp, toughness)

        if prob > 0 then
          list[name] = prob
          gui.debugf("  %s --> prob:%1.1f\n", name, prob)
        end
      end
    end

    assert(fallback)

    if table_empty(list) then
      gui.printf("Empty monster palette @ %s : using %s\n",
                 R:tostr(), fallback.name)
      list[fallback.name] = 50
    end

    -- how many kinds??   FIXME: better calc!
    local num_kinds = 1
        if R.svolume >= 81 then num_kinds = 4
    elseif R.svolume >= 36 then num_kinds = 3
    elseif R.svolume >= 10 then num_kinds = 2
    end

    local palette = {}

    gui.debugf("Monster palette:\n")

    for i = 1,num_kinds do
      local mon = rand_key_by_probs(list)
      palette[mon] = list[mon]  --- GAME.monsters[mon].prob

      gui.debugf("  #%d %s\n", i, mon)
      PLAN.mon_stats[mon] = (PLAN.mon_stats[mon] or 0) + 1

      list[mon] = nil
      if table_empty(list) then break; end
    end

    return palette
  end

  local function monster_fits(S, mon, info)
    -- check seed kind
    -- (floating monsters can go in more places)
    if not (S.kind == "walk" or info.float) then
      return false
    end

    -- check if fits vertically
    local ceil_h = S.ceil_h or R.ceil_h or SKY_H
    local thing  = assert(GAME.things[mon])

    if thing.h >= (ceil_h - S.floor_h - 1) then
      return false
    end

    return true
  end

  local function add_mon_spot(S, x, y, mon, info)
    local SPOT =
    {
      S=S, x=x, y=y, monster=mon, info=info
    }
    table.insert(R.monster_spots, SPOT)
  end

  local function add_spot_group(S, mon, info)
    local mx, my = S:mid_point()

    if is_big(mon) then
      add_mon_spot(S, mx, my, mon, info)
    else
      add_mon_spot(S, mx-36, my-36, mon, info)
      add_mon_spot(S, mx-36, my+36, mon, info)
      add_mon_spot(S, mx+36, my-36, mon, info)
      add_mon_spot(S, mx+36, my+36, mon, info)
    end
  end

  local function try_occupy_seed(S, palette, totals)
    if S.content or S.no_monster then return end

    -- keep entryway clear [TODO: more space in big rooms]
    if S.conn == R.entry_conn then return end

    if S.diag_new_kind then return end
    if not S.floor_h then return end

    -- preliminary check on type
    if not (S.kind == "walk" or S.kind == "liquid") then return end

    local mon   = rand_key_by_probs(palette)
    local info  = GAME.monsters[mon]
    local thing = GAME.things[mon]

    if not monster_fits(S, mon, info) then
      -- ??? try the other monsters
      return
    end

    -- create spots
    add_spot_group(S, mon, info)

    totals[mon] = totals[mon] + 1
  end

  local function steal_a_seed(mon, totals)
    local victim

    for name,count in pairs(totals) do
      if name ~= mon and (count >= 2) and (not victim or count > totals[victim]) then
        victim = name
      end
    end

    if not victim then
      gui.debugf("steal_a_seed(%s): nobody to steal from!\n", mon)
      return
    end

    gui.debugf("steal_a_seed(%s): stealing from %s\n", mon, victim)

    local qty = 1
    if totals[victim] >= 10 then qty = 2 end

    for loop = 1,qty do
      local victim_S

      local old_list = R.monster_spots
      R.monster_spots = {}

      for _,spot in ipairs(old_list) do
        if victim_S and spot.S == victim_S then
          -- skip other spots in the same seed
        elseif not victim_S and spot.monster == victim and
               monster_fits(spot.S, spot.monster, spot.info)
        then
          add_spot_group(spot.S, mon, GAME.monsters[mon])
          victim_S = spot.S

          totals[mon]    = totals[mon] + 1
          totals[victim] = totals[victim] - 1
        else
          table.insert(R.monster_spots, spot)
        end
      end

      -- may not have worked (different requirements)
      gui.debugf("  loop:%d %s\n", loop, sel(victim_S, "OK", "FAILED"))
      if not victim_S then break; end
    end

    rand_shuffle(R.monster_spots)
  end

  local function create_monster_map(palette)
    R.monster_spots = {}

    -- adjust probs in palette to account for monster size,
    -- i.e. we can fit 4 imps in a seed but only one mancubus,
    -- hence imps should occur less often (per seed).

    local pal_2  = {}
    local totals = {}

    for mon,prob in pairs(palette) do
      pal_2[mon]  = prob * sel(is_big(mon), 3, 1)
      totals[mon] = 0
    end

    -- FIXME: symmetry

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]

      if S.room == R then
        try_occupy_seed(S, pal_2, totals)
      end
    end end -- for x, y

    rand_shuffle(R.monster_spots)
    
    -- make sure each monster has at least one seed
    for mon,_ in pairs(palette) do
      if totals[mon] == 0 then
        steal_a_seed(mon, totals)
      end
    end

    gui.debugf("Monster map totals:\n")
    for mon,count in pairs(totals) do
      gui.debugf("  %s = %d seeds\n", mon, count)
    end
  end

  local function how_many_dudes(mon, count, qty)
    if count <= 1 then return count end

    local vari = int((count+3) / 5)
    count = count + rand_irange(-vari, vari)

    count = int(count * qty / 100)
    return math.max(1, count)
  end

  local function place_monster(spot)
    local thing = GAME.things[spot.monster]

    -- FIXME: angle

    gui.add_entity(tostring(thing.id), spot.x, spot.y, spot.S.floor_h + 25,
    {
      angle  = spot.angle  or 0,
      ambush = spot.ambush or 1,
    })
  end

  local function fill_monster_map(qty)
    local totals  = {}
    local actuals = {}

    for _,spot in ipairs(R.monster_spots) do
      totals[spot.monster] = (totals[spot.monster] or 0) + 1
    end

    for mon,count in pairs(totals) do
      actuals[mon] = how_many_dudes(mon, count, qty)
    end

    for _,spot in ipairs(R.monster_spots) do
      if (actuals[spot.monster] or 0) >= 1 then
        actuals[spot.monster] = actuals[spot.monster] - 1
        place_monster(spot)
      end
    end
  end

  local function add_monsters()

    local toughness = calc_toughness()

    local palette = select_monsters(toughness)

    create_monster_map(palette)

    local qty = MONSTER_QUANTITIES[OB_CONFIG.mons] or
                PLAN.mixed_mons_qty  -- the "mixed" setting

    fill_monster_map(qty)
  end


  ---| Monsters_in_room |---

  gui.debugf("Monsters_in_room @ %s\n", R:tostr())

  R.monster_list = {}
  R.fight_result = {}

  if OB_CONFIG.mons == "none" then
    return
  end

  if R.purpose == "START" then
    return
  end

  if R.kind == "stairwell" or R.kind == "smallexit" or
     R.kind == "scenic"
  then
    return
  end


  add_monsters()

do return end --FIXME !!!!!!

  for _,SK in ipairs(SKILLS) do

    R.fight_result[SK] = {}

    local mon_list = collect_monsters(SK)

    for CL,hmodel in pairs(PLAN.hmodels[SK]) do

      local weap_list = collect_weapons(hmodel)
      local ammos = {}

      Fight_simulator(mon_list, weap_list, SK, ammos)

      give_monster_drops(mon_list, hmodel, ammos)
    
      R.fight_result[SK][CL] = ammos

    end -- for CL
  end -- for SK
end


function Monsters_show_stats()
  local total = 0
  for _,count in pairs(PLAN.mon_stats) do
    total = total + count
  end

  local function get_stat(mon)
    local num = PLAN.mon_stats[mon] or 0
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
  
  gui.printf("\n--==| Monsters_make_battles |==--\n\n")

  PLAN.mixed_mons_qty   = 25 + rand_skew() * 12
  PLAN.mixed_mons_tough = rand_range(0.8, 1.2)

  Player_init()

  Monsters_init()

  local cur_arena = -1

  -- Rooms have been sorted into a visitation order, so we
  -- simply visit them one-by-one and insert some monsters
  -- and simulate each battle.

  for _,R in ipairs(PLAN.all_rooms) do
    if R.arena.weapon and (R.arena.id > cur_arena) and not R.skip_weapon then
      Player_give_weapon(R.arena.weapon)
      cur_arena = R.arena.id
    end

    Monsters_in_room(R)
  end -- for R

  Monsters_show_stats()

  -- Once all monsters have been chosen and all battles
  -- (including cages and traps) have been simulated, then
  -- we can decide what pickups to add (the easy part) and
  -- _where_ to place them (the hard part).

  Monsters_do_pickups()
end

