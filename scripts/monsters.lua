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
    local hm_set = deep_copy(GAME.player_model)

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
  name_it_up(GAME.monsters)
  name_it_up(GAME.weapons)
  name_it_up(GAME.pickups)

  for name,info in pairs(GAME.monsters) do
    info.thing = assert(GAME.things[name])
  end

  PLAN.mon_stats = {}

  PLAN.mixed_mons_qty   = 24 + rand_skew() * 10
  PLAN.mixed_mons_tough = rand_range(0.9, 1.1)
end

function Monsters_global_palette()
  -- Decides which monsters we will use on this level.
  -- Easiest way is to pick some monsters NOT to use.

  if not PARAMS.skip_monsters then return end

  -- if already have level prefs, don't overwrite
  if LEVEL.monster_prefs then return end

  LEVEL.monster_prefs = {}

  local list = {}
  for name,info in pairs(GAME.monsters) do
    if info.prob then
      table.insert(list, name)
    end
  end

  rand_shuffle(list)

  -- sometimes promote a particular monster
  if rand_odds(30) then
    local promote = list[#list]
    local info = GAME.monsters[promote]
    if not info.never_promote then
      gui.debugf("Promoting monster: %s\n", promote)
      LEVEL.monster_prefs[promote] = 3.3
    end
  end

---??  -- sometimes allow the whole damn lot
---??  if LEVEL.ep_along >= 0.5 and rand_odds(15) then
---??    return
---??  end

  local count = rand_irange(PARAMS.skip_monsters[1], PARAMS.skip_monsters[2])
  assert(count < #list)

  for i = 1,count do
    LEVEL.monster_prefs[list[i]] = 0
    gui.debugf("Skipping monster: %s\n", list[i])
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
      ratios[i] = rand_irange(2,5)
    end

    return ratios, arena.storage_rooms
  end

  local function get_previous_prefs(R)
    local room_list = {}
    local ratios = {}

    local PREV = R

    while PREV.entry_conn and #room_list < 3 do
      PREV = PREV.entry_conn:neighbor(PREV)

      local qty = rand_irange(3,5) / (1 + #room_list)

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
      distribute_to_list(R, 0.33, get_previous_prefs(R))
      distribute_to_list(R, 0.33, get_storage_prefs(R.arena))
    end
  end


  local function add_big_spot(R, S, score)
    local mx, my = S:mid_point()
    table.insert(R.big_spots, { S=S, x=mx, y=my, score=score })
  end

  local function add_small_spots(R, S, side, count, score)
    local mx, my = S:mid_point()
    local dist = 40

    for i = 1,count do
      if side == 4 then mx = S.x1 + S.thick[4] + i*dist end
      if side == 6 then mx = S.x2 - S.thick[6] - i*dist end
      if side == 2 then my = S.y1 + S.thick[2] + i*dist end
      if side == 8 then my = S.y2 - S.thick[8] - i*dist end

      local dir = rotate_cw90(side)

      table.insert(R.small_spots, { S=S, x=mx, y=my, dir=dir, score=score })

      -- the rows further away from the wall should only be
      -- used when absolutely necessary.
      score = score - 100
    end
  end

  local function try_add_big_spot(R, S)
    local score = gui.random()

    if S.div_lev and S.div_lev >= 2 then score = score + 10 end

    if S.sx > (R.tx1 or R.sx1) and S.sx < (R.tx2 or R.sx2) then score = score + 2.4 end
    if S.sy > (R.ty1 or R.sy1) and S.sy < (R.ty2 or R.sy2) then score = score + 2.4 end

    if not S.content then score = score + 1 end

    add_big_spot(R, S, score)
  end

  local function try_add_small_spot(R, S)
    local score = gui.random()

    if R.entry_conn then
      local e_dist
      if is_vert(R.entry_conn.dir) then
        e_dist = math.abs(R.entry_conn.dest_S.sy - S.sy)
      else
        e_dist = math.abs(R.entry_conn.dest_S.sx - S.sx)
      end

      score = score + e_dist / 2.5
    end

    local walls = {}

    for side = 2,8,2 do
      local N = S:neighbor(side)
      if not N then
        walls[side] = 1
      elseif N.room ~= S.room then
        if not S.conn then walls[side] = 2 end
      elseif N.kind == "void" then
        walls[side] = 3
      elseif N.kind == "walk" and N.floor_h > S.floor_h then
        walls[side] = 4
      end
    end -- for side

    if table_empty(walls) then return end

    if walls[4] and walls[6] then
      add_small_spots(R, S, 4, 2, score)
      add_small_spots(R, S, 6, 2, score - 0.3)

    elseif walls[2] and walls[8] then
      add_small_spots(R, S, 2, 2, score)
      add_small_spots(R, S, 8, 2, score - 0.3)

    else
      while true do
        local side = rand_irange(1,4) * 2
        if walls[side] then
          add_small_spots(R, S, side, 4, score)
          break;
        end
      end
    end
  end

  local function find_pickup_spots(R)
    -- Creates a map over the room of which seeds we can place
    -- pickup items in.  We distinguish two types: 'big' items
    -- (Mega Health or Blue Armor) and 'small' items:
    --
    -- 1. big items prefer to have a seed for itself, and
    --    somewhere near to the centre of the room.
    --
    -- 2. small items prefer to sit next to walls (or ledges)
    --    and be grouped in clusters.
    --
    -- To achieve this, our map will consist of two lists (big
    -- and small) of seeds, sorted into best --> worst order
    -- (with a healthy dose of randomness of course).

    gui.debugf("find_pickup_spots @ %s\n", R:tostr())

    R.big_spots = {}
    R.small_spots = {}

    local emerg_big
    local emerg_small

    for x = R.sx1,R.sx2 do for y = R.sy1,R.sy2 do
      local S = SEEDS[x][y][1]
      local score

      if S.room == R and S.kind == "walk" and
         (not S.content or S.content == "monster")
      then
        try_add_big_spot(R, S)
        try_add_small_spot(R, S)

        if not emerg_big then emerg_big = S end
        emerg_small = S
      end
    end end -- for x, y

    assert(emerg_big and emerg_small)

    if #R.big_spots == 0 then
      gui.debugf("No big spots found : using emergency\n")
      add_big_spot(R, emerg_big)
    end

    if #R.small_spots == 0 then
      gui.debugf("No small spots found : using emergency\n")
      add_small_spots(R, emerg_small, 2, 4, 0)
    end
  end

  local function sort_spots(R)
    table.sort(R.big_spots,   function(A,B) return A.score > B.score end)
    table.sort(R.small_spots, function(A,B) return A.score > B.score end)
  end

  local function decide_pickup(stat, qty)
    local item_tab = {}

    for name,info in pairs(GAME.pickups) do
      if info.prob and
         (stat == "health" and info.give[1].health) or
         (info.give[1].ammo == stat)
      then
        item_tab[name] = info.prob

---###    local each_qty = info.give[1].health or info.give[1].count
---###    local min_num  = (info.cluster and info.cluster[1]) or 1
---###    local max_num  = (info.cluster and info.cluster[2]) or 1
---###    if each_qty * max_num > qty then prob = prob / 20 end
      end
    end

    assert(not table_empty(item_tab))
    local name = rand_key_by_probs(item_tab)
    local info = GAME.pickups[name]

    local count = 1
    
    if info.cluster then
      local each_qty = info.give[1].health or info.give[1].count
      local min_num  = info.cluster[1]
      local max_num  = info.cluster[2]

      --- count = rand_irange(min_num, max_num)

      if min_num * each_qty >= qty then
        count = min_num
      elseif max_num * each_qty <= qty then
        count = max_num - rand_sel(20,1,0)
      else
        count = 1 + int(qty / each_qty)
      end
    end

    return GAME.pickups[name], count
  end

  local function select_pickups(R, item_list, stat, qty, hmodel)
gui.debugf("Initial = %s:%1.1f\n", stat, hmodel.stats[stat])

    -- subtract any previous gotten stuff
    qty = qty - hmodel.stats[stat]
    hmodel.stats[stat] = 0

    while qty > 0 do
      local item, count = decide_pickup(stat, qty)
      table.insert(item_list, { item=item, count=count, SK=hmodel.skill, rand=gui.random() })
      
      if stat == "health" then
        qty = qty - item.give[1].health * count
      else
        assert(item.give[1].ammo)
        qty = qty - item.give[1].count * count
      end
    end

    -- accumulate any excess quantity into the hmodel
    if qty < 0 then
gui.debugf("Excess = %s:%1.1f\n", stat, -qty)
      hmodel.stats[stat] = assert(hmodel.stats[stat]) - qty
    end
  end

  local function place_item(S, item_name, x, y, SK)
    local thing = assert(GAME.things[item_name])

    gui.add_entity(tostring(thing.id), x, y, S.floor_h + 25,
    {
      skill_hard   = sel(SK == "hard",   1, 0),
      skill_medium = sel(SK == "medium", 1, 0),
      skill_easy   = sel(SK == "easy",   1, 0),
    })
  end

  local function place_big_item(spot, item, SK)
    local x, y = spot.x, spot.y

    -- assume big spots will sometimes run out (and be reused),
    -- so don't put multiple items at exactly the same place.
    x = x + rand_irange(-32, 32)
    y = y + rand_irange(-32, 32)

    place_item(spot.S, item, x, y, SK)
  end

  local function place_small_item(spot, item, count, SK)
    local x1, y1 = spot.x, spot.y
    local x2, y2 = spot.x, spot.y

    if count == 1 then
      place_item(spot.S, item, x1,y1, SK)
      return
    end

    local away = sel(count == 2, 20, 56)

    if is_vert(spot.dir) then
      y1, y2 = y1-away, y2+away
    else
      x1, x2 = x1-away, x2+away
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

      if item.big_item then
        spot = table.remove(R.big_spots, 1)
        table.insert(R.big_spots, spot)

        assert(count == 1)
        place_big_item(spot, item.name, SK, CL)
      else
        spot = table.remove(R.small_spots, 1)
        table.insert(R.small_spots, spot)

        place_small_item(spot, item.name, count, SK, CL)
      end
    end
  end

  local function pickups_for_hmodel(R, SK, CL, hmodel)
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
    table.sort(item_list, function(A,B) return (A.count + A.rand) > (B.count + B.rand) end)

    place_item_list(R, item_list, SK, CL)
  end

  local function pickups_in_room(R)
    find_pickup_spots(R)

    for _,SK in ipairs(SKILLS) do
      for CL,hmodel in pairs(PLAN.hmodels[SK]) do
        pickups_for_hmodel(R, SK, CL, hmodel)
      end -- for CL
    end -- for SK
  end


  ---| Monsters_do_pickups |---

  for _,R in ipairs(PLAN.all_rooms) do
    if not (R.kind == "stairwell" or R.kind == "smallexit") then
      distribute_fight_stats(R)
    end
  end

  for _,R in ipairs(PLAN.all_rooms) do
    if not (R.kind == "stairwell" or R.kind == "smallexit") then
      pickups_in_room(R)
    end
  end
end


function Monsters_in_room(R)

  local MONSTER_QUANTITIES =
  {
     scarce=11, less=18, normal=25, more=33, heaps=45
  }

  local MONSTER_TOUGHNESS =
  {
    scarce=0.8, less=0.9, normal=1.0, more=1.1, heaps=1.2
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
      toughness = toughness * (1 + LEVEL.ep_along * 2.4)
    end

    -- less emphasis within a level, since each arena naturally
    -- get tougher as the player picks up new weapons.
    if R.arena.id == 1 then
      toughness = toughness * 0.8
    elseif R.arena.id >= (#PLAN.all_arenas - 1) then
      toughness = toughness * 1.5
    end

    if R.kind == "hallway" then
      toughness = toughness * 0.5
    end

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
    local info = GAME.monsters[mon]

    if count <= 1 then return count end

    count = count * (qty / 100.0)

    -- adjust quantity based on monster's health
    if info.health > PARAMS.mon_hard_health then
      count = count / math.sqrt(info.health / PARAMS.mon_hard_health)
    end

    count = math.max(1, int(count))

    -- some random variation
    if count >= 3 then
      local diff = int((count+1) / 4)
      count = count + rand_irange(-diff,diff)
    end

    return count
  end

  local function monster_angle(S)
    -- TODO: sometimes make all monsters (or a certain type) face
    --       the same direction, or look towards the entrance, or
    --       towards the guard_spot.

    if rand_odds(20) then
      return rand_irange(0,7) * 45
    end

    local delta = rand_irange(-1,1) * 45

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

  local function add_to_list(SK, spot)
    if not R.monster_list[SK] then
      R.monster_list[SK] = {}
    end

    table.insert(R.monster_list[SK], spot.info)
  end

  local function place_monster(spot, index)
    local thing = GAME.things[spot.monster]

    local angle  = monster_angle(spot.S)
    local ambush = rand_sel(92, 1, 0)

    -- minimum skill needed for the monster to appear
    local skill

    if true then
      skill = 3 ; add_to_list(SKILLS[skill], spot)
    end
    if (index % 3) > 0 then
      skill = 2 ; add_to_list(SKILLS[skill], spot)
    end
    if (index % 3) == 1 then
      skill = 1 ; add_to_list(SKILLS[skill], spot)
    end

    gui.add_entity(tostring(thing.id), spot.x, spot.y, spot.S.floor_h + 25,
    {
      angle  = spot.angle  or angle,
      ambush = spot.ambush or ambush,

      skill_hard   = 1,
      skill_medium = sel(skill >= 2, 1, 0),
      skill_easy   = sel(skill >= 1, 1, 0),
    })

    spot.S.content = "monster"
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

    for index,spot in ipairs(R.monster_spots) do
      if (actuals[spot.monster] or 0) >= 1 then
        place_monster(spot, actuals[spot.monster])
        actuals[spot.monster] = actuals[spot.monster] - 1
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


  local function make_empty_stats()
    local stats = {}

    for _,SK in ipairs(SKILLS) do
      stats[SK] = {}
      for CL,_ in pairs(GAME.player_model) do
        stats[SK][CL] = {}
      end
    end

    return stats
  end

  local function collect_weapons(hmodel)
    local list = {}

    for name,_ in pairs(hmodel.weapons) do
      local info = assert(GAME.weapons[name])
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

    local heal_mul = 0.70 * HEALTH_AMMO_ADJUSTS[OB_CONFIG.health]
    local ammo_mul = 1.00 * HEALTH_AMMO_ADJUSTS[OB_CONFIG.ammo]

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


  ---| Monsters_in_room |---

  gui.debugf("Monsters_in_room @ %s\n", R:tostr())

  R.monster_list = {}
  R.fight_stats  = make_empty_stats()

  if OB_CONFIG.mons == "none" then
    return
  end

  if R.purpose == "START" and not R.has_raising_start then
    return
  end

  if R.kind == "stairwell" or R.kind == "smallexit" then
    return
  end

  assert(R.kind ~= "scenic")


  add_monsters()


  -- simulate the battle!!

  for _,SK in ipairs(SKILLS) do
    local mon_list = R.monster_list[SK]
    if mon_list and #mon_list >= 1 then

      for CL,hmodel in pairs(PLAN.hmodels[SK]) do
        local weap_list = collect_weapons(hmodel)
        local stats = R.fight_stats[SK][CL]

        gui.debugf("Fight simulator @ %s  SK:%s\n", R:tostr(), SK)
        gui.debugf("weapons = \n")
        for _,info in ipairs(weap_list) do
          gui.debugf("  %s\n", info.name)
        end

        Fight_simulator(mon_list, weap_list, SK, stats)
        gui.debugf("raw result = \n%s\n", table_to_str(stats,1))

        user_adjust_result(stats)
        gui.debugf("adjusted result = \n%s\n", table_to_str(stats,1))

        give_monster_drops(mon_list, hmodel)

        subtract_gotten_stuff(stats, hmodel)

        gui.debugf("final result = \n%s\n", table_to_str(stats,1))
      end -- for CL

    end
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

  Player_init()

  Monsters_init()
  Monsters_global_palette()

  local cur_arena = -1

  -- Rooms have been sorted into a visitation order, so we
  -- simply visit them one-by-one and insert some monsters
  -- and simulate each battle.

  for _,R in ipairs(PLAN.all_rooms) do
    if R.arena.weapon and (R.arena.id > cur_arena) then  ---??? and not R.skip_weapon then
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

