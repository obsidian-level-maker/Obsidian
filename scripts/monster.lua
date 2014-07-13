------------------------------------------------------------------------
--  MONSTERS / HEALTH / AMMO
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2008-2014 Andrew Apted
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


--[[

MONSTER SELECTION
=================

Main usages:
(a) free-range
(b) guarding something [keys]
(c) cages
(d) traps (triggered closets, teleport in)
(e) surprises (behind entry door, closets on back path)


MONSTERS:

(1) have the room palette

(2) simplify selection of room palette:
    -  use info.prob
    -  basic criterion is: harder monsters occur later
    -  want harder monsters in KEY/EXIT rooms

(3) give each mon a 'density' value:
    -  use info.density (NOT info.prob)
    -  adjust with time/along/level/purpose
    -  when all monsters have a density, normalise by dividing by total

(4) give each room a TOTAL count (adjust for along, purpose)
    -  want[mon] = total * density[mon]


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


MONSTER_QUANTITIES =
{
  scarce=5, less=10, normal=15, more=25, heaps=40, nuts=200
}

MONSTER_KIND_TAB =
{
  scarce=2, less=3, normal=4, more=4.5, heaps=6, nuts=6
}

HEALTH_AMMO_ADJUSTS =
{
  none=0, scarce=0.4, less=0.7, normal=1.0, more=1.5, heaps=2.5,
}


COOP_MON_FACTOR = 1.35
COOP_HEALTH_FACTOR = 1.3
COOP_AMMO_FACTOR   = 1.6

MONSTER_MAX_TIME = { weak=6, medium=9, tough=12 }


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

-- Hexen2 flags   [FIXME: NOT USED YET]
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
  if R.weapons and not PARAM.hexen_weapons then
    each name in R.weapons do
      Player_give_weapon(name)
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


----------------------------------------------------------------


function Monsters_init()
  table.name_up(GAME.MONSTERS)
  table.name_up(GAME.WEAPONS)
  table.name_up(GAME.PICKUPS)

  for name,info in pairs(GAME.MONSTERS) do
    if not info.id then
      error(string.format("Monster '%s' lacks an id field", name))
    end
  end

  if not EPISODE.seen_guards then
    EPISODE.seen_guards = {}
  end

  LEVEL.mon_stats = {}

  local low_q  = MONSTER_QUANTITIES.scarce
  local high_q = MONSTER_QUANTITIES.more

  local low_k  = MONSTER_KIND_TAB.scarce
  local high_k = MONSTER_KIND_TAB.heaps

  LEVEL.prog_mons_qty  = low_q + LEVEL.ep_along * (high_q - low_q)
  LEVEL.prog_mons_kind = low_k + LEVEL.ep_along * (high_k - low_k)

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

    -- calculate a level if not present
    if not info.level then
      local hp = info.health * (PARAM.level_factor or 1)
          if hp < 45  then info.level = 1
      elseif hp < 130 then info.level = 3
      elseif hp < 450 then info.level = 5
      else  info.level = 7
      end
    end
  end

  -- remove a replacement monster if the monster it replaces
  -- does not exist (e.g. stealth_gunner in DOOM 1 mode).
  for name,_ in pairs(dead_ones) do
    GAME.MONSTERS[name] = nil
  end
end


function Monsters_max_level()
  local max_level = 10 * (LEVEL.mon_along or 0.5) + 1

  LEVEL.weap_level = max_level

  if OB_CONFIG.strength == "tough" or
     OB_CONFIG.strength == "crazy"
  then
    max_level = max_level * 1.6

  elseif OB_CONFIG.strength == "weak" then
    max_level = max_level / 1.3
  end

  if max_level < 1 then max_level = 1 end

  LEVEL.max_level = max_level

  gui.printf("Monster max_level: %1.1f\n", max_level)
end


function Monsters_pick_single_for_level()
  local tab = {}

  if not EPISODE.single_mons then
    EPISODE.single_mons = {}
  end

  each name,prob in LEVEL.global_pal do
    local info = GAME.MONSTERS[name]
    tab[name] = (info.level or 5) * 10

    -- prefer monsters which have not been used before
    if EPISODE.single_mons[name] then
      tab[name] = tab[name] / 10
    end
  end

  local name = rand.key_by_probs(tab)

  -- mark it as used
  EPISODE.single_mons[name] = 1

  return name
end


function Monsters_check_theme(info)
  -- if no theme specified, usable in all themes
  if not info.theme then return true end

  -- anything goes in CRAZY mode
  if OB_CONFIG.strength == "crazy" then return true end

  -- TODO: handle tables and "!" syntax

  return info.theme == LEVEL.theme_name
end


function Monsters_global_palette()
  -- Decides which monsters we will use on this level.
  -- Easiest way is to pick some monsters NOT to use.

  LEVEL.global_pal = {}

  if not LEVEL.monster_prefs then
    LEVEL.monster_prefs = {}
  end
  
  -- skip monsters that are too strong for this map
  each name,info in GAME.MONSTERS do
    if info.prob  and info.prob > 0 and
       info.level and info.level <= LEVEL.max_level and
       Monsters_check_theme(info)
    then
      LEVEL.global_pal[name] = 1
    end
  end

  -- only one kind of monster in this level?
  if STYLE.mon_variety == "none" then
    local the_mon = Monsters_pick_single_for_level()

    LEVEL.global_pal = {}
    LEVEL.global_pal[the_mon] = 1

    LEVEL.single_mon = the_mon
  end

  gui.debugf("Monster global palette:\n%s\n", table.tostr(LEVEL.global_pal))

  gui.printf("\n")
end



function Monsters_zone_palettes()
  
  local function prob_for_guard(mon)
    local info = GAME.MONSTERS[mon]

    if (info.prob or 0) <= 0 then return 0 end

    -- ignore theme-specific monsters (SS NAZI)
    if info.theme then return 0 end

    -- too strong for an early map?
    if info.level > LEVEL.max_level + 3 then return 0 end

    -- base probability : this value is designed to take into account
    -- the settings of the monster control module
    local prob = info.prob * (info.damage or 10)
    prob = prob ^ 0.6

    -- huge monsters often won't fit in a room, so lower their chance
    if info.r > 60 then prob = prob / 3 end

    if prob < 1 then prob = 1 end

    if info.level > LEVEL.max_level + 2 then return prob * 20 end
    if info.level > LEVEL.max_level + 1 then return prob * 40 end
    if info.level > LEVEL.max_level     then return prob * 80 end

    return prob
  end


  local function decide_guard_monsters()
    local tab = {}

    if STYLE.mon_variety == "none" then
      tab[LEVEL.single_mon] = 50
      return
    end

    each mon,_ in GAME.MONSTERS do
      local prob = prob_for_guard(mon)

      if prob > 0 then
        tab[mon] = prob
      end
    end

    gui.debugf("Possible guard monsters:\n%s\n", table.tostr(tab))

    if table.empty(tab) then return end


    local list = {}
    local num_zones = #LEVEL.zones

    for i = 1, num_zones do
      local mon = rand.key_by_probs(tab)
      tab[mon] = tab[mon] / 100  -- try hard not to choose again

      local info = GAME.MONSTERS[mon]

      table.insert(list, { mon=mon, tough=info.damage + gui.random() / 10 })
    end


    if LEVEL.max_level < 10 then
      table.sort(list,
          function (A, B) return A.tough < B.tough end)
    end

    for i = 1, num_zones do
      local Z = LEVEL.zones[i]

      Z.guard_mon = list[i].mon

      if not EPISODE.seen_guards[Z.guard_mon] then
        EPISODE.seen_guards[Z.guard_mon] = 1
        Z.guard_is_new = true
      end

      gui.debugf("Guard monster for ZONE_%s --> %s\n", Z.id, Z.guard_mon)
    end
  end


  local function palettes_are_same(A, B)
    if table.size(A) != table.size(B) then
      return false
    end

    each k,v1 in A do
      local v2 = B[k]

      if not v2 or math.abs(v1 - v2) > 0.1 then
        return false
      end
    end

    return true
  end


  local function palette_toughness(pal)
    local total = 0
    local size  = table.size(pal)

    each mon,qty in pal do
      if qty <= 0 then continue end

      local info = assert(GAME.MONSTERS[mon])

---???  local toughness = info.health + info.damage * 7

      total = total + info.damage * qty
    end

    -- tie breaker
    return (total / size) * 10 + gui.random()
  end


  local function gen_quantity_set(total)
    -- the indices represent: none | less | some | more
    local quants = {}

    local skip_perc = rand.pick(PARAM.skip_monsters)

    -- skip less monsters in small early maps
    if #LEVEL.zones == 1 and LEVEL.max_level < 5 then
      skip_perc = skip_perc / 2
    end

    quants[0] = int(total * skip_perc / 100 + gui.random() * 0.7)
    total = total - quants[0]

    quants[2] = int(total * rand.range(0.3, 0.7) + gui.random())
    total = total - quants[2]

    quants[1] = int(total * rand.range(0.3, 0.7) + gui.random())
    total = total - quants[1]

    quants[3] = total
    assert(total >= 0)

    return quants
  end


  local QUANT_VALUES = { 0.0, 0.4, 1.0, 2.2 }

  local function pick_quant(quants)
    assert(quants[0] + quants[1] + quants[2] + quants[3] > 0)

    local idx

    repeat
      idx = rand.irange(0, 3)
    until quants[idx] > 0

    quants[idx] = quants[idx] - 1

    return assert(QUANT_VALUES[1 + idx])
  end


  local function generate_palette(base_pal)
    local total = table.size(base_pal)

    if total <= 1 then
      return table.copy(base_pal)
    end


    local pal = {}

    local quants = gen_quantity_set(total)

    each mon,_ in base_pal do
      local qty = pick_quant(quants)

      if qty > 0 then
        pal[mon] = qty
      end
    end

    assert(not table.empty(pal))

    return pal 
  end


  local function dump_palette(pal)
    each mon,qty in pal do
      gui.debugf("   %-12s* %1.2f\n", mon, qty)
    end

    gui.debugf("   TOUGHNESS: %d\n", palette_toughness(pal))
  end


  ---| Monsters_zone_palettes |---

  decide_guard_monsters()

  local zone_pals = {}

  for i = 1, #LEVEL.zones do
    local pal   = generate_palette(LEVEL.global_pal)
    local tough = palette_toughness(pal)

    zone_pals[i] = { pal=pal, tough=tough }
  end

  -- ensure weakest palette is first, strongest is last
  table.sort(zone_pals,
      function (A, B) return A.tough < B.tough end)

  for i = 1, #LEVEL.zones do
    local Z = LEVEL.zones[i]

    Z.mon_palette = zone_pals[i].pal

    gui.debugf("Monster palette in ZONE_%d:\n", Z.id)
    dump_palette(Z.mon_palette)
  end
end



function Player_weapon_palettes()

  local Middle  = 1.00
  local High    = 2.20
  local Highest = 4.80
  local Low     = 0.44
  local Lowest  = 0.21


  local function initial_weapons()
    -- find with weapons the player always owns
    local list = {}

    each CL,hmodel in LEVEL.hmodels do
      each name,_ in hmodel.weapons do
        list[name] = 1
      end
    end

    return list
  end


  local function add_weapons_from_zone(Z, list)
    each R in Z.rooms do
      each name in R.weapons do
        list[name] = 1
      end
    end
  end


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
    add_weapons_from_zone(Z, got_weaps)

    Z.weap_palette = gen_palette(got_weaps)

    gui.debugf("Weapon palette in ZONE_%d:\n", Z.id)
    dump_palette(Z.weap_palette)
  end
end



function Monsters_dist_between_spots(A, B, z_penalty)
  local dist_x = 0
  local dist_y = 0

      if A.x1 > B.x2 then dist_x = A.x1 - B.x2
  elseif A.x2 < B.x1 then dist_x = B.x1 - A.x2
  end

      if A.y1 > B.y2 then dist_y = A.y1 - B.y2
  elseif A.y2 < B.y1 then dist_y = B.y1 - A.y2
  end

  local dist = math.max(dist_x, dist_y)

  -- penalty for height difference [for clustering]
  if B.z1 and A.z1 != B.z1 then
    dist = dist + (z_penalty or 1000)
  end

  return dist
end



function Monsters_split_spots(list, max_size)
  -- recreate the spot list
  local new_list = {}

  each spot in list do
    local w, h = geom.box_size(spot.x1, spot.y1, spot.x2, spot.y2)

    local XN = int(w / max_size)
    local YN = int(h / max_size)

    if XN < 2 and YN < 2 then
      table.insert(new_list, spot)
      continue
    end

    for x = 1, XN do
    for y = 1, YN do
      local x1 = spot.x1 + (x - 1) * w / XN
      local x2 = spot.x1 + (x    ) * w / XN

      local y1 = spot.y1 + (y - 1) * h / YN
      local y2 = spot.y1 + (y    ) * h / YN

      local new_spot = table.copy(spot)

      new_spot.x1 = int(x1) ; new_spot.y1 = int(y1)
      new_spot.x2 = int(x2) ; new_spot.y2 = int(y2)
      new_spot.marked = nil

      table.insert(new_list, new_spot)
    end
    end
  end

  return new_list
end



function Monsters_distribute_stats()
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
    if room.quest.storage_rooms then
      each R in room.quest.storage_rooms do
        local ratio = rand.irange(3,7) / 2.0
        table.insert(list, { room=R, ratio=ratio })
      end
    end

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


  ---| Monsters_distribute_stats |---

  -- Note: we don't distribute to or from hallways

  gui.debugf("--- Monsters_distribute_stats ---\n")

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



function Monsters_collect_big_spots(R)

  local function big_spots_from_mon_spots()
    each spot in R.mon_spots do
      local w = spot.x2 - spot.x1
      local h = spot.y2 - spot.y1

      if w >= 220 and h >= 220 then
        local new_spot = table.copy(spot)

        new_spot.score = rand.range(1, 10)

        table.insert(R.big_spots, new_spot)
      end
    end
  end


  local function extract_big_item_spots()
    for i = #R.item_spots, 1, -1 do
      local spot = R.item_spots[i]

      if spot.kind == "big_item" then
        table.remove(R.item_spots, i)
        table.insert(R.big_spots, spot)

        spot.score = (spot.rank or 1) * 5 + 7 * gui.random() ^ 3
      end
    end
  end


  ---| Monsters_collect_big_spots |---

  big_spots_from_mon_spots()

  extract_big_item_spots()
end



function Monsters_do_pickups()

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

    for name,info in pairs(GAME.PICKUPS) do
      -- compatibilty crud...
      local prob = info.add_prob or info.prob

      if prob and
         (stat == "health" and info.give[1].health) or
         (info.give[1].ammo == stat)
      then
        item_tab[name] = prob

        if R.purpose == "START" and info.start_prob then
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
    if R.purpose == "START" then
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


  ---| Monsters_do_pickups |---

  gui.debugf("--- Monsters_do_pickups ---\n")

  each Z in LEVEL.zones do
    each R in Z.rooms do
      pickups_in_room(R)
    end
  end
end


function Monsters_in_room(R)

  -- places monsters in a room _or_ hallway


  local CAGE_REUSE_FACTORS = { 5, 20, 60, 200 }

  local function is_big(mon)
    return GAME.MONSTERS[mon].r > 30
  end

  local function is_huge(mon)
    return GAME.MONSTERS[mon].r > 60
  end


  local function categorize_room_size()
    -- hallways are always small : allow any monsters
    if R.kind == "hallway" then return end

    -- anything goes for the final battle
    if R.final_battle then return end

    -- occasionally break the rules
    if rand.odds(6) then return end

    -- often allow any monsters in caves
    if R.kind == "cave" and rand.odds(27) then return end

    -- value depends on total area of monster spots
    local area = 0

    each spot in R.mon_spots do
      area = area + (spot.x2 - spot.x1) * (spot.y2 - spot.y1)
    end

    -- adjust result to be relative to a single seed
    area = area / (SEED_SIZE * SEED_SIZE)

    gui.debugf("roam area = %1.2f\n", area)


    -- random adjustment
    area = area * rand.range(0.80, 1.25)

    -- caves are often large -- adjust for that
    if R.kind == "cave" then area = area / 2 - 8 end

    if area < 4 then
      R.room_size = "small"
    elseif area < 12 then
      R.room_size = "medium"
    else
      R.room_size = "large"
    end
  end


  local function room_size_factor(mon)
    local info = GAME.MONSTERS[mon]

    if not    R.room_size then return 1 end
    if not info.room_size then return 1 end

    if room_size == "any" then return 1 end

    -- a good match
    if info.room_size == R.room_size then return 1 end

    -- close but no cigar
    if info.room_size == "medium" or R.room_size == "medium" then
      return 1 / 3
    end

    -- big difference: one was "small" and the other was "large"
    return 1 / 10
  end


  local function time_to_kill_factor(mon)
    local info = GAME.MONSTERS[mon]

    local time = info.health / R.firepower

    if PARAM.time_factor then
      time = time * PARAM.time_factor
    end

    local max_time = MONSTER_MAX_TIME[OB_CONFIG.strength] or 9

    if time > max_time*2 then
      return 1 / 4
    elseif time > max_time then
      return 1 / 2
    else
      return 1
    end
  end


  local function calc_quantity()
    local qty

    if LEVEL.quantity then
      qty = LEVEL.quantity

    elseif OB_CONFIG.mons == "mixed" then
      qty = rand.pick { 8,14,25,45 }

    elseif OB_CONFIG.mons == "prog" then
      qty = LEVEL.prog_mons_qty

    else
      qty = MONSTER_QUANTITIES[OB_CONFIG.mons]
      assert(qty)

      -- tend to have more monsters in later rooms and levels
      qty = qty * (3 + R.lev_along + LEVEL.ep_along) / 5
    end

    -- less in secrets (usually much less)
    if R.kind == "SECRET_EXIT" then
      qty = qty / 1.6
    elseif R.quest.kind == "secret" then
      qty = qty / rand.pick { 2, 3, 4, 9 }
    end

    -- random adjustment
    qty = qty * rand.range(0.8, 1.2)

    -- game and theme adjustments
    qty = qty * (PARAM.monster_factor or 1)
    qty = qty * (THEME.monster_factor or 1)

    -- more monsters for Co-operative games
    if OB_CONFIG.mode == "coop" then
      qty = qty * COOP_MON_FACTOR
    end

    -- make the final battle (of map) as epic as possible
    if R.final_battle then
      qty = qty * 2.2

    -- after the big battle, give player a breather
    elseif R.cool_down then
      qty = qty * 0.7

    -- more in KEY rooms (extra boost in small rooms)
    elseif R.purpose == "KEY" or R.purpose == "SWITCH" then
      qty = qty * 1.4

      if R.svolume <= 16 then qty = qty * 1.2 end
    end

    gui.debugf("Quantity = %1.1f\n", qty)
    return qty
  end


  local function tally_spots(spot_list)
    -- This is meant to give a rough estimate, and assumes each monster
    -- fits in a 64x64 square and there is no height restrictions.
    -- We can adjust for the real monster size later.

    local count = 0

    each spot in spot_list do
      local w, h = geom.box_size(spot.x1, spot.y1, spot.x2, spot.y2)

      w = int(w / 64) ; if w < 1 then w = 1 end
      h = int(h / 64) ; if h < 1 then h = 1 end

      count = count + w * h
    end

    return count
  end


  local function calc_central_dist(mx, my)
    -- TODO: improve this

    local rx1 = SEEDS[R.sx1][R.sy1].x1
    local ry1 = SEEDS[R.sx1][R.sy1].y1
    local rx2 = SEEDS[R.sx2][R.sy2].x2
    local ry2 = SEEDS[R.sx2][R.sy2].y2

    local cent_x, cent_y = geom.box_mid(rx1, ry1, rx2, ry2)

    local dist = geom.dist(cent_x, cent_y, mx, my)

    -- normalize result to be in units of roomy sections
    return dist / (SEED_SIZE * 4)
  end


  local function mark_ambush_spots()
    if R.kind == "hallway" then return end
    if R.kind == "cave" then return end

    -- this also determines the 'central_dist' field of spots

    each spot in R.mon_spots do
      -- already processed?
      if spot.marked then continue end

      spot.marked = true

      local mx, my = geom.box_mid(spot.x1, spot.y1, spot.x2, spot.y2)
      local mz = spot.z1 + 50

      spot.central_dist = calc_central_dist(mx, my)

      -- TODO: more than one ambush focus per room
      local ambush_focus = R.ambush_focus

      if not ambush_focus then continue end

      local ax = ambush_focus.x
      local ay = ambush_focus.y
      local az = ambush_focus.z

      -- too close?
      if geom.dist(mx, my, ax, ay) < 80 then continue end

      spot.ambush_angle = geom.calc_angle(ax - mx, ay - my)

      local ang = ambush_focus.angle

      -- check TWO points separated perpedicular to the entry angle
      local pdx = math.sin(ang * math.pi / 180) * 48
      local pdy = math.cos(ang * math.pi / 180) * 48

      if gui.trace_ray(mx, my, mz, ax + pdx, ay + pdy, az, "v") and
         gui.trace_ray(mx, my, mz, ax - pdx, ay - pdy, az, "v")
      then
        spot.ambush = ambush_focus
      end
    end
  end


  local function calc_strength_factor(info)
    local factor = (info.level or 1)

    if OB_CONFIG.strength == "weak" then
      return 2 / (1 + factor)

    elseif OB_CONFIG.strength == "tough" then
      return (factor + 1) / 8

    else
      return 1
    end
  end


  local function prob_for_mon(mon, spot_kind)
    local info = GAME.MONSTERS[mon]
    local prob = info.prob

    prob = prob or 0

    if not LEVEL.global_pal[mon] then
      return 0
    end

    if info.weap_needed and not Player_has_weapon(info.weap_needed) then
      return 0
    end

    -- TODO: merge THEME.monster_prefs into LEVEL.monster_prefs
    if LEVEL.monster_prefs then
      prob = prob * (LEVEL.monster_prefs[mon] or 1)
    end
    if THEME.monster_prefs then
      prob = prob * (THEME.monster_prefs[mon] or 1)
    end
    if R.theme.monster_prefs then
      prob = prob * (R.theme.monster_prefs[mon] or 1)
    end

    if spot_kind == "cage" then
      -- cage monsters need a long distance attack
      if info.attack == "melee" then return 0 end

      -- less preference for flying monsters
      if info.float then prob = prob * 0.5 end
    end

    if R.is_outdoor then
      prob = prob * (info.outdoor_factor or 1)
    end

    if prob == 0 then return 0 end


    -- apply user's Strength setting
    prob = prob * calc_strength_factor(info)

    -- weaker monsters in secrets
    if R.quest.kind == "secret" then
      prob = prob / (info.level or 1)
    end


    -- level check (harder monsters occur in later rooms)
    assert(info.level)

    if not (R.purpose or R.final_battle) then
      local max_level = LEVEL.max_level * (0.5 + R.lev_along / 2)
      if max_level < 2 then max_level = 2 end

      if info.level > max_level then
        prob = prob / 20
      end
    end

    return prob
  end


  local function density_for_mon(mon)
    local info = GAME.MONSTERS[mon]

    local d = info.density or 1

    -- level check
    if OB_CONFIG.strength != "crazy" then
      local max_level = LEVEL.max_level * R.lev_along
      if max_level < 2 then max_level = 2 end

      if info.level > max_level then
        d = d / 4
      end
    end

    -- adjustment for single-monster levels
    if STYLE.mon_variety == "none" then
      d = (d + 1) / 2
    end

    -- zone quantities
    d = d * (R.zone.mon_palette[mon] or 1)

    -- room size check
    d = d * room_size_factor(mon) ^ 0.5

    -- would the monster take too long to kill?
    d = d * time_to_kill_factor(mon)

    -- random variation
    d = d * rand.range(0.8, 1.2)

    return d
  end


  local function number_of_kinds()
    local base_num

    if not R.cool_down then
      if STYLE.mon_variety == "heaps" or rand.odds(5) then return 9 end
      if STYLE.mon_variety != "some"  or rand.odds(1) then return 1 end
    end

    if OB_CONFIG.mons == "mixed" then
      base_num = rand.range(MONSTER_KIND_TAB.scarce, MONSTER_KIND_TAB.heaps)

    elseif OB_CONFIG.mons == "prog" then
      base_num = LEVEL.prog_mons_kind

    else
      base_num = MONSTER_KIND_TAB[OB_CONFIG.mons]
    end

    assert(base_num)

    if R.kind == "hallway" then
      return rand.index_by_probs { 20, 40, 60 }
    end

    -- adjust the base number to account for room size
    local size = math.sqrt(R.svolume)
    local num  = int(base_num * size / 7 + 0.6 + gui.random())

    if num < 1 then num = 1 end
    if num > 5 then num = 5 end

    if not R.cool_down then
      if rand.odds(30) then num = num + 1 end
      if rand.odds(3)  then num = num + 1 end
    end

    gui.debugf("number_of_kinds: %d (base: %d)\n", num, base_num)

    return num
  end


  local function crazy_palette()
    local num_kinds

    if R.kind == "hallway" then
      num_kinds = rand.index_by_probs({ 20, 40, 60 })
    else
      local size = math.sqrt(R.svolume)
      num_kinds = int(size / 1.2)
    end

    local list = {}

    each mon,info in GAME.MONSTERS do
      local prob = info.crazy_prob or info.prob or 0

      if not LEVEL.global_pal[mon] then prob = 0 end

      if info.weap_needed and not Player_has_weapon(info.weap_needed) then
        prob = 0
      end

      if prob > 0 and LEVEL.monster_prefs then
        prob = prob * (LEVEL.monster_prefs[mon] or 1)
        if info.replaces then
          prob = prob * (LEVEL.monster_prefs[info.replaces] or 1)
        end
      end

      -- weaker monsters in secrets
      if R.quest.kind == "secret" then
        prob = prob / (info.level or 1)
      end

      if prob > 0 then
        list[mon] = prob
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


  local function room_palette()
    local list = {}
    gui.debugf("Monster list:\n")

    each mon,qty in R.zone.mon_palette do
      local prob = prob_for_mon(mon, info)

      prob = prob * qty

      -- take room size into account
      prob = prob * room_size_factor(mon)

      if prob > 0 then
        list[mon] = prob
        gui.debugf("  %s --> prob:%1.1f\n", mon, prob)
      end
    end

    local num_kinds = number_of_kinds()

    local palette = {}

    gui.debugf("Monster palette: (%d kinds, %d actual)\n", num_kinds, table.size(list))

    for i = 1, num_kinds do
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


  local function quantize_angle(a)
    if PARAM.fine_angles then return a end

    local a1 = math.floor(a / 45)
    local a2 = math.ceil (a / 45)

    a = rand.sel(50, a1, a2)

    return bit.band(a, 7) * 45
  end


  local function angle_between_points(x, y, nx, ny)
    local ang = geom.calc_angle(nx - x, ny - y)

    -- randomize a bit
    ang = ang + 60 * rand.skew()

    return quantize_angle(ang)
  end


  local function monster_angle(spot, x, y, z, focus)
    -- TODO: sometimes make all monsters (or a certain type) face
    --       the same direction, or look towards the entrance, or
    --       towards the guard_spot.

    local away = false

    if spot.face_away then
      focus = spot.face_away
      away  = true
    elseif spot.face then
      focus = spot.face
    end

    if R.force_mon_angle then
      return R.force_mon_angle
    end

    if rand.odds(R.random_face_prob) and not away then
      focus = nil
    end

    -- look toward something [or away from something]
    if focus then
      local ang = angle_between_points(x, y, focus.x, focus.y)

      if away then
        ang = geom.angle_add(ang, 180)
      end

      return ang
    end

    -- fallback : purely random angle
    return rand.irange(0,7) * 45
  end


  local function calc_min_skill(all_skills)
    if all_skills then return 1 end

    local dither = Plan_alloc_id("mon_dither")

    -- skill 3 (hard) is always added
    -- skill 2 (medium) alternates between 100% and 60% chance
    -- skill 1 (easy) is always 60% chance of adding

    if rand.odds(60) then
      return 1
    elseif (dither % 2) == 0 then
      return 2
    else
      return 3
    end
  end


  local function place_monster(mon, spot, x, y, z, all_skills, is_cage)
    local info = GAME.MONSTERS[mon]

    -- handle replacements
    if LEVEL.mon_replacement[mon] and not R.no_replacement then
      mon  = rand.key_by_probs(LEVEL.mon_replacement[mon])
      info = assert(GAME.MONSTERS[mon])
    end

    table.insert(R.monster_list, info)

    -- decide deafness and where to look
    local deaf, focus

    if R.kind == "cave" or R.kind == "hallway" or info.float then
      deaf = rand.odds(65)
    elseif spot.ambush then
      deaf  = rand.odds(95)
      focus = spot.ambush
    else
      deaf = rand.odds(35)
    end

    if not focus then
      focus = R.entry_coord
    end

    local angle

    if (is_cage or R.kind == "hallway") and spot.angle then
      angle = spot.angle
    else
      angle = monster_angle(spot, x, y, z, focus)
    end

    -- minimum skill needed for the monster to appear
    local skill = calc_min_skill(all_skills)

    local props = { }

    props.angle = angle

    if PARAM.use_spawnflags then
      props.spawnflags = 0

      -- UGH, special check needed for Quake zombie
      if deaf and mon != "zombie" then
        props.spawnflags = props.spawnflags + QUAKE_FLAGS.DEAF
      end

      if (skill > 1) then props.spawnflags = props.spawnflags + QUAKE_FLAGS.NOT_EASY end
      if (skill > 2) then props.spawnflags = props.spawnflags + QUAKE_FLAGS.NOT_MEDIUM end
    else
      props.flags = DOOM_FLAGS.HARD

      if deaf then
        props.flags = props.flags + DOOM_FLAGS.DEAF
      end

      if (skill <= 1) then props.flags = props.flags + DOOM_FLAGS.EASY end
      if (skill <= 2) then props.flags = props.flags + DOOM_FLAGS.MEDIUM end
    end

    Trans.entity(mon, x, y, z, props)
  end


  local function mon_fits(mon, spot)
    local info  = GAME.MONSTERS[mon]

    if info.h >= (spot.z2 - spot.z1) then return 0 end

    local w, h = geom.box_size(spot.x1, spot.y1, spot.x2, spot.y2)

    w = int(w / info.r / 2)
    h = int(h / info.r / 2)

    return w * h
  end


  local function place_in_spot(mon, spot, all_skills)
    local info = GAME.MONSTERS[mon]

    local x, y = geom.box_mid (spot.x1, spot.y1, spot.x2, spot.y2)
    local w, h = geom.box_size(spot.x1, spot.y1, spot.x2, spot.y2)

    local z = spot.z1

    -- move monster to random place within the box
    local dx = w / 2 - info.r
    local dy = h / 2 - info.r

    if dx > 0 then
      x = x + rand.range(-dx, dx)
    end

    if dy > 0 then
      y = y + rand.range(-dy, dy)
    end

    place_monster(mon, spot, x, y, z, all_skills)
  end


  local function spot_compare(A, B)
    if A.find_score != B.find_score then
      return A.find_score > B.find_score
    end

    return A.find_cost < B.find_cost
  end


  local function grab_monster_spot(mon, near_to, reqs)
    local total = 0

    each spot in R.mon_spots do
      local fit_num = mon_fits(mon, spot)

      if fit_num <= 0 then
        spot.find_score = -1
        spot.find_cost = 9e9
        continue
      end

      total = total + 1

      -- check requirements : make a score (QUANTIZED!)
      local score = 0

      if reqs.ambush then
        if reqs.ambush < 0 and not spot.ambush then score = score + 2 end
        if reqs.ambush > 0 and     spot.ambush then score = score + 2 end
      end

      if reqs.central then
        if reqs.central < 0 and spot.central_dist and spot.central_dist < 0.3 then score = score + 1 end
        if reqs.central > 0 and spot.central_dist and spot.central_dist > 0.3 then score = score + 1 end
      end

      spot.find_score = score

      if near_to then
        spot.find_cost = Monsters_dist_between_spots(spot, near_to) / 16
      else
        spot.find_cost = 0

        if reqs.baddie_far and R.entry_coord and R.baddie_dists[mon] then
          local mx, my = geom.box_mid(spot.x1, spot.y1, spot.x2, spot.y2)
          local dist = geom.dist(R.entry_coord.x, R.entry_coord.y, mx, my)

          dist = dist / R.furthest_dist
          dist = math.abs(dist - R.baddie_dists[mon])

          spot.find_cost = dist * 1.8
        end
      end 

      -- tie breeker
      spot.find_cost = spot.find_cost + gui.random()
    end


    if total == 0 then
      return nil  -- no available spots!
    end

    -- pick the best and remove it from the list
    -- TODO: for 'near_to' mode maybe trace_ray() to check spot

    local spot = table.pick_best(R.mon_spots, spot_compare, "remove")

    if not near_to then
      R.last_spot_section = spot.section
    end

    return spot
  end


  local function try_add_mon_group(mon, count, all_skills)
    local info = GAME.MONSTERS[mon]

    local actual = 0
    local last_spot

    local reqs = {}

    -- prefer melee monsters on outside of a section
    --    and floating monsters on inside
    if info.attack == "melee" then reqs.central = 1 end
    if info.float then reqs.central = -1 end

    if rand.odds(R.sneakiness) or info.nasty then
      reqs.ambush = 1
    else
      reqs.ambush = -1  -- want a visible spot
    end

    -- sometimes pick a spot whose distance from the entry coord is
    -- depends on the relative toughness of the monster
    if rand.odds(R.baddie_far_prob) then
      reqs.baddie_far = 1
    end

    for i = 1, count do
      local spot = grab_monster_spot(mon, last_spot, reqs)

      if not spot then break; end

      place_in_spot(mon, spot, all_skills)

      last_spot = spot
      actual    = actual + 1
    end

    return actual
  end


  local function how_many_dudes(palette, want_total)
    -- the 'NONE' entry is a stabilizing element, in case we have a
    -- palette containing mostly undesirable monsters (Archviles etc).
    local densities = { NONE=1.0 }

    local total_density = densities.NONE

    each mon,_ in palette do
      densities[mon] = density_for_mon(mon)

      total_density = total_density + densities[mon]
    end

gui.debugf("densities =  total:%1.3f\n%s\n\n", total_density, table.tostr(densities,1))

    -- convert density map to monster counts
    local wants = {}

    each mon,d in densities do
      if mon != "NONE" then
        local num = want_total * d / total_density

        wants[mon] = int(num + gui.random())
      end
    end

gui.debugf("wants =\n%s\n\n", table.tostr(wants))

    return wants
  end


  local function rough_badness(mon)
    local info = GAME.MONSTERS[mon]

    return info.health + info.damage * 7
  end


  local function calc_baddie_dists(palette)
    -- analyse palette and sort monsters into an ideal distance from
    -- the entry point of the room -- baddest dudes are furthest away.
    R.baddie_dists = {}

    if not R.furthest_dist then return end
    if table.size(palette) < 2 then return end

    local baddies = {}

    each mon,_ in palette do
      local bad = rough_badness(mon)

      table.insert(baddies, { mon=mon, bad=bad })
    end

    table.sort(baddies, function(A, B) return A.bad < B.bad end)

    gui.debugf("Baddie dists:\n")

    for idx = 1, #baddies do
      local mon = baddies[idx].mon

      R.baddie_dists[mon] = idx / (#baddies + 1)

      gui.debugf("   %s : %1.3f\n", mon, R.baddie_dists[mon])
    end
  end


  local function calc_horde_size(mon, info)
    -- do not produce groups of nasties
    if info.nasty then return 1 end

    local horde = 1

    if info.health <= 500 and rand.odds(30) then horde = horde + 1 end
    if info.health <= 100 then horde = horde + rand.index_by_probs { 90, 40, 10, 3, 0.5 } end

    if R.kind == "hallway" then horde = horde + 1 end
    
    return horde
  end


  local function fill_sized_monsters(wants, palette, r_min, r_max)
    R.mon_spots = Monsters_split_spots(R.mon_spots, r_max * 2)

    if r_max < 100 then
      mark_ambush_spots()
    end

    -- collect monsters that match the size range
    local want2 = {}

    each mon,qty in wants do
      if qty > 0 then
        local r = GAME.MONSTERS[mon].r

        if (r_min < r) and (r <= r_max) then
          want2[mon] = qty
        end
      end
    end

    -- add these monsters until list is empty or no more spots

    while not table.empty(want2) and
          not table.empty(R.mon_spots)
    do
      local mon  = rand.key_by_probs(want2)
      local info = GAME.MONSTERS[mon]

      -- figure out how many to place together
      local horde = calc_horde_size(mon, info)

      horde = math.min(horde, want2[mon])

      local actual = try_add_mon_group(mon, horde)

      -- if it failed, there's no use trying again later
      if actual > 0 and actual < want2[mon] then
        want2[mon] = want2[mon] - actual
      else
        want2[mon] = nil
        wants[mon] = nil
      end
    end
  end


  local function fill_monster_map(palette, barrel_chance)
    -- compute total number of monsters wanted
    local qty = calc_quantity()

    local want_total = tally_spots(R.mon_spots)

    want_total = int(want_total * qty / 100 + gui.random())


    -- determine how many of each kind of monster we want
    local wants = how_many_dudes(palette, want_total)

    
    calc_baddie_dists(palette)


    -- process largest monsters before earlier ones, splitting the
    -- unused spots as we go....

    fill_sized_monsters(wants, palette, 64, 128)
    fill_sized_monsters(wants, palette, 32, 64)
    fill_sized_monsters(wants, palette,  0, 32)
  end


  local function decide_cage_monster(spot, room_pal, used_mons)
    -- Note: this function is used for traps too

    -- FIXME: decide cage_palette EARLIER (before laying out the room)

    local list = {}

    local used_num = table.size(used_mons)
    if used_num > 4 then used_num = 4 end

    each mon,info in GAME.MONSTERS do
      local prob = prob_for_mon(mon, spot.kind)

      if STYLE.mon_variety == "none" and not LEVEL.global_pal[mon] then continue end

      if mon_fits(mon, spot) <= 0 then continue end

      -- prefer monsters not in the room palette
      if room_pal[mon] then prob = prob / 100 end

      -- prefer previously used monsters
      if used_mons[mon] then
        prob = prob * CAGE_REUSE_FACTORS[used_num]
      end

      prob = prob * (info.cage_factor or 1)

      if prob > 0 then
        list[mon] = prob
      end
    end

    -- Ouch : cage will be empty
    if table.empty(list) then return nil end

    return rand.key_by_probs(list)
  end


  local function fill_cage_area(mon, spot)
    local info = assert(GAME.MONSTERS[mon])

    -- determine maximum number that will fit
    local w, h = geom.box_size(spot.x1,spot.y1, spot.x2,spot.y2)

    w = int(w / info.r / 2)
    h = int(h / info.r / 2)

    assert(w >= 1 and h >= 1)

    local total = w * h

    -- generate list of coordinates to use
    local list = {}

    for mx = 1,w do for my = 1,h do
      local loc =
      {
        x = spot.x1 + info.r * 2 * (mx-0.5)
        y = spot.y1 + info.r * 2 * (my-0.5)
        z = spot.z1
      }
      table.insert(list, loc)
    end end

    rand.shuffle(list)

    -- determine quantity, applying user settings
    local qty = calc_quantity() + 20

    local d = info.cage_density or 0.4
    local f = gui.random()

    local want = int(total * d * qty / 100 + f * f * 2)
    want = math.clamp(1, want, total)

    gui.debugf("monsters_in_cage: %d (of %d) qty=%1.1f\n", want, total, qty)

    for i = 1,want do
      -- ensure first monster in present in all skills
      local all_skills = (i == 1)
      local loc = list[i]

      place_monster(mon, spot, loc.x, loc.y, loc.z, all_skills, "cage")
    end
  end


  local function fill_cages(spot_list, room_pal)
    if table.empty(R.cage_spots) then return end

    local qty = calc_quantity()

    local used_mons = {}

    each spot in spot_list do
      local mon = decide_cage_monster(spot, room_pal, used_mons)

      if mon then
        fill_cage_area(mon, spot, qty)

        used_mons[mon] = 1
      end
    end
  end


  local function add_guarding_monsters()
    if not R.guard_coord then return end

    if not R.zone.guard_mon then return end

    -- convert coordinate into a fake spot  [no z coords!]
    local guard_spot =
    {
      x1 = R.guard_coord.x - 16
      y1 = R.guard_coord.y - 16
      x2 = R.guard_coord.x + 16
      y2 = R.guard_coord.y + 16
    }

    local mon  = R.zone.guard_mon
    local info = GAME.MONSTERS[mon]

    -- decide how many of them
    local count = 2

    if R.zone.guard_is_new or info.level >= 8 or
       (info.nasty and rand.odds(50))
    then
      count = 1
    end

    local reqs = {}

    for i = 1, count do
      local spot = grab_monster_spot(mon, guard_spot, reqs)

      -- TODO: have a backup monster, strongest in room palette

      if not spot then
        gui.printf("Cannot place guard monster: %s\n", mon)
        break;
      end

      -- look toward the important spot
      if rand.odds(75) then
        spot.face = R.guard_coord
      end

      local all_skills = (i == 1)

      place_in_spot(mon, spot, all_skills)
    end
  end


  local function add_monsters()
    local palette

    if OB_CONFIG.strength == "crazy" then
      palette = crazy_palette()
    else
      palette = room_palette()
    end

    local barrel_chance = sel(R.kind == "building", 15, 2)
--!!    if R.natural then barrel_chance = 3 end
--!!    if R.hallway then barrel_chance = 5 end

    if STYLE.barrels == "heaps" or rand.odds( 5) then barrel_chance = barrel_chance * 4 + 10 end
    if STYLE.barrels == "few"   or rand.odds(25) then barrel_chance = barrel_chance / 4 end

    if STYLE.barrels == "none" then barrel_chance = 0 end

    -- sometimes prevent monster replacements
    if rand.odds(40) or OB_CONFIG.strength == "crazy" then
      R.no_replacement = true
    end

    add_guarding_monsters()

    -- FIXME: add barrels even when no monsters in room

    if not table.empty(palette) then
      fill_monster_map(palette, barrel_chance)
    end

    -- this value keeps track of the number of "normal" monsters
    -- (i.e. monsters not in cages or traps).  Later we use this
    -- value to only give monster drops for accessible monsters.
    R.normal_count = #R.monster_list

    if not table.empty(palette) then
      fill_cages(R.cage_spots, palette)
    end
  end


  local function make_empty_stats()
    local stats = {}

    for CL,_ in pairs(GAME.PLAYER_MODEL) do
      stats[CL] = {}
    end

    return stats
  end


  local function collect_weapons(hmodel)
    local list = {}

    each name,_ in hmodel.weapons do
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


  local function give_monster_drops(hmodel, mon_list, count)
    for i = 1,count do
      local info = mon_list[i]

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


  local function battle_for_class(CL, hmodel)
    local mon_list = R.monster_list

    local weap_list = collect_weapons(hmodel)

    local stats = R.fight_stats[CL]

    gui.debugf("Fight Simulator @ %s  class: %s\n", R:tostr(), CL)

    gui.debugf("weapons = \n")
    each info in weap_list do
      gui.debugf("  %s\n", info.name)
    end

    Fight_Simulator(mon_list, weap_list, R.zone.weap_palette, stats)

--  gui.debugf("raw result = \n%s\n", table.tostr(stats,1))

    user_adjust_result(stats)

--  gui.debugf("adjusted result = \n%s\n", table.tostr(stats,1))

    give_monster_drops(hmodel, mon_list, R.normal_count)

    subtract_stuff_we_have(stats, hmodel)
  end


  local function sim_battle()
    assert(R.monster_list)

    if #R.monster_list >= 1 then
      each CL,hmodel in LEVEL.hmodels do
        battle_for_class(CL, hmodel)
      end
    end
  end


  local function should_add_monsters()
    if OB_CONFIG.mons == "none" then
      return false
    end

    if R.no_monsters then return false end

    assert(not R.scenic)

---???    if R.kind == "hallway" and #R.sections == 1 then
---???      return rand.odds(50)
---???    end

    return true
  end


  local function guard_spot_for_conn(C)
    local S = C:get_seed(R)

    if not S then return nil end  -- teleporter

    local mx, my = S:mid_point()

    return { x=mx, y=my }
  end


  local function find_guard_spot()
    -- Finds a KEY or EXIT to guard -- returns coordinate table (or NIL)

    -- in a pseudo-exit room, need to guard the door to real exit.
    -- we skip teleporters here, the code further down will handle it.
    if R.final_battle and R.purpose != "EXIT" then
      each C in R.conns do
        if C.kind == "teleporter" then continue end

        local nb = C:neighbor(R)

        if nb.purpose == "EXIT" then
          return guard_spot_for_conn(C)
        end
      end
    end

    if R.purpose == "KEY" or R.purpose == "EXIT" or R.final_battle then
      -- the wotsit placement code will have set this
      if R.guard_spot then
        local mx, my = R.guard_spot:mid_point()

        return { x=mx, y=my }
      end
    end

  --[[  FUTURE
    each CL in R.closets do
      if CL.closet_kind == "exit" or
         CL.closet_kind == "item"
      then
        return guard_spot_for_conn(CL.conn)
      end
    end
  --]]

    return nil  -- none
  end


  local function prepare_room()
    R.monster_list = {}
    R.fight_stats  = make_empty_stats()

    R.firepower = Player_firepower()

    categorize_room_size()

    if R.kind != "hallway" then
      R.guard_coord = find_guard_spot()
    end

    R.sneakiness = rand.sel(30, 95, 25)

    if R.kind != "hallway" and R.entry_coord then
      R.furthest_dist = R:furthest_dist_from_entry()
    end

    R.baddie_far_prob = rand.pick({ 20, 40, 60, 80 })

    if rand.odds(2) then
      R.force_mon_angle = rand.irange(0,7) * 45
    end

    R.random_face_prob = rand.sel(20, 90, 10)

    gui.debugf("Parameters:\n")
    gui.debugf("  firepower  = %1.3f\n", R.firepower)
    gui.debugf("  room_size  = %s\n", R.room_size or "UNSET")
    gui.debugf("  sneakiness = %d%%\n", R.sneakiness)
    gui.debugf("  baddie_far = %d%%\n", R.baddie_far_prob)
    gui.debugf("  rand_face  = %d%%\n", R.random_face_prob)
    gui.debugf("  same_angle = %s\n", sel(R.force_mon_angle, "TRUE", "false"))
  end


  ---| Monsters_in_room |---

  gui.debugf("Monsters_in_room @ %s\n", R:tostr())

  prepare_room()

  if should_add_monsters() then
    add_monsters()
    sim_battle()
  end
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


function Monster_make_battles()
  
  gui.printf("\n--==| Make Battles |==--\n\n")

  gui.prog_step("Mons")

  Player_init()

  Monsters_init()
  Monsters_global_palette()
  Monsters_zone_palettes()

  Player_give_map_stuff()
  Player_weapon_palettes()

  -- Rooms have been sorted into a visitation order, so we just
  -- insert some monsters into each one and simulate each battle.

  each R in LEVEL.rooms do
    Player_give_room_stuff(R)
    Monsters_collect_big_spots(R)
    Monsters_in_room(R)
  end

  Monsters_show_stats()

  -- Once all monsters have been chosen and all battles
  -- (including cages and traps) have been simulated, then
  -- we can decide what pickups to add (the easy part) and
  -- _where_ to place them (the hard part).

  Monsters_distribute_stats()
  Monsters_do_pickups()
end

