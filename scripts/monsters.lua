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

[Palette probably needs to handle "families", e.g. Baron
and Hellknight, Mummy and Leader]

Trap and Surprise monsters can use any monster (actually
better when different from palette and different from
previous traps/surprises).

Cages and Guarding monsters should have a smaller and
longer-term palette, changing about 4 times less often
than the free-range palette.  MORE PRECISELY: palette
evolves about same rate IN TERMS OF # MONSTERS ADDED.

Evolving a palette: replace some monsters with different
ones.  Especially replace weaker with stronger (we assume
the player will have better weapons).  Probably replace
only 1 monster each time over the course of an EPISODE
(faster and/or more palettes when making SINGLE maps).

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


function Monsters_do_pickups()
  -- FIXME: pickups
end


function Monsters_in_room(R)

  local MONSTER_QUANTITIES =
  {
     scarce=10, less=20, normal=30, more=45, heaps=60
  }

  local function select_monsters()
    -- FIXME: guard monsters !!!

    local fp = Player_calc_firepower()

    gui.debugf("Firepower = %1.3f\n", fp)
    
    local list = {}
    gui.debugf("Monster list:\n")

    for name,info in pairs(GAME.monsters) do
      if info.prob then
        local time   = info.health / fp
        local damage = info.damage * time
        local prob   = info.prob

---     gui.debugf("  %s --> %1.2f seconds  @ %1.1f damage\n", name, info.health / fp, damage)

        if time <= PARAMS.mon_time_max and damage <= PARAMS.mon_damage_max then
          if time < PARAMS.mon_time_low then
            prob = prob * time / PARAMS.mon_time_low
          end
          if damage > PARAMS.mon_damage_high then
            local diff =   PARAMS.mon_damage_max - PARAMS.mon_damage_high
            prob = prob * (PARAMS.mon_damage_max - damage) / diff
          end

          list[name] = prob
          gui.debugf("  %s --> prob:%1.1f\n", name, prob)
        end
      end
    end

    assert(not table_empty(list))

    -- how many kinds??   FIXME: better calc!
    local num_kinds
        if R.svolume >= 81 then num_kinds = 4
    elseif R.svolume >= 36 then num_kinds = 3
    elseif R.svolume >= 10 then num_kinds = 2
    else num_kinds = 1
    end

    local palette = {}

    gui.debugf("Monster palette:\n")

    for i = 1,num_kinds do
      local mon = rand_key_by_probs(list)
      palette[mon] = list[mon]  --- GAME.monsters[mon].prob

      gui.debugf("  #%d %s\n", i, mon)

      list[mon] = nil
      if table_empty(list) then break; end
    end

    return palette
  end

  local function try_add_mon_seed(mon)
    local info = assert(GAME.monsters[mon])

    -- FIXME: IMPROVE THIS SHITE !!!

    -- FIXME: check vertical room!

    -- FIXME: symmetry

    for pass = 1,2 do
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R and not S.content and
         not (S.conn == R.entry_conn) and S.floor_h and
         (S.kind == "walk" or (info.float and S.kind == "liquid")) and
         (pass == 2 or rand_odds(25))
      then
        S.content = "monster"
        S.monster = mon
        return true
      end
    end end -- for x, y
    end -- for pass

    return false
  end

  local function create_monster_map(palette)
    -- assign at least one seed to each monster
    for mon,_ in pairs(palette) do
      try_add_mon_seed(mon)
    end

    repeat
      local mon = rand_key_by_probs(palette)
      
      if not try_add_mon_seed(mon) then
        palette[mon] = nil
      end
    until table_empty(palette)
  end

  local function do_add_mon(chance, S, x, y, mon, info, thing)
    if not rand_odds(chance) then
      return
    end

    -- FIXME: angle

    gui.add_entity(x, y, S.floor_h + 25,
    {
      name = tostring(thing.id),
      flag_ambush = 1,
      angle = 0,
    })
  end

  local function fill_monster_map(qty)
    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      if S.room == R and S.content == "monster" then
        local info  = assert(GAME.monsters[S.monster])
        local thing = assert(GAME.things[S.monster])

        assert(thing.r <= 72)  -- i.e. not a "big" monster

        local mx, my = S:mid_point()
        
        if thing.r >= 35 then
          do_add_mon(qty, S, mx, my, S.monster, info, thing)
        else
          do_add_mon(qty, S, mx-36, my-36, S.monster, info, thing)
          do_add_mon(qty, S, mx-36, my+36, S.monster, info, thing)
          do_add_mon(qty, S, mx+36, my-36, S.monster, info, thing)
          do_add_mon(qty, S, mx+36, my+36, S.monster, info, thing)
        end
      end
    end end -- for x, y
  end

  local function add_monsters()

    local palette = select_monsters()

    create_monster_map(palette)

    local qty = MONSTER_QUANTITIES[OB_CONFIG.mons]

    -- handled "mixed" setting
    if not qty then
      qty = PLAN.mixed_mons_qty
    end

    fill_monster_map(qty)
  end


  ---| Monsters_in_room |---

  gui.debugf("Monsters_in_room @ %s\n", R:tostr())

  R.fight_result = {}

  if OB_CONFIG.mons == "none" then
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


function Monsters_make_battles()
  
  gui.printf("\n--==| Monsters_make_battles |==--\n\n")

  PLAN.mixed_mons_qty = 30 + rand_skew() * 20

  Player_init()

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

  -- Once all monsters have been chosen and all battles
  -- (including cages and traps) have been simulated, then
  -- we can decide what pickups to add (the easy part) and
  -- _where_ to place them (the hard part).

  Monsters_do_pickups()
end

