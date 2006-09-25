----------------------------------------------------------------
-- MONSTERS/HEALTH/AMMO
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


-- Monster list
-- ============
--
-- r : radius
-- h : height
-- t : toughness (health)
-- dm : damage can inflict per second (rough approx)
-- fp : firepower needed by player

MONSTER_DEFS =
{
  zombie    = { kind=3004, prob=81, r=20,h=56, t=20,  dm=4,  fp=10, cage_prob=10, hitscan=true, humanoid=true },
  shooter   = { kind=9,    prob=41, r=20,h=56, t=30,  dm=10, fp=10, cage_prob= 5, hitscan=true, humanoid=true },
  gunner    = { kind=65,   prob=17, r=20,h=56, t=70,  dm=40, fp=40, cage_prob=70, hitscan=true, humanoid=true },

  imp       = { kind=3001, prob=90, r=20,h=56, t=60,  dm=20, fp=20, cage_prob=90, },
  caco      = { kind=3005, prob=90, r=31,h=56, t=400, dm=45, fp=30, cage_prob=14, float=true },
  revenant  = { kind=66,   prob=70, r=20,h=64, t=300, dm=55, fp=48, cage_prob=50, },
  knight    = { kind=69,   prob=70, r=24,h=64, t=500, dm=45, fp=60, cage_prob=50, },
  baron     = { kind=3003, prob=50, r=24,h=64, t=1000,dm=45, fp=110,cage_prob= 2, },

  mancubus  = { kind=67,   prob=70, r=48,h=64, t=600, dm=80, fp=110,cage_prob=70, },
  arach     = { kind=68,   prob=26, r=64,h=64, t=500, dm=70, fp=90, cage_prob=90, },
  pain      = { kind=71,   prob= 8, r=31,h=56, t=400, dm=88, fp=40, cage_prob= 0, float=true },
  vile      = { kind=64,   prob=10, r=20,h=56, t=700, dm=20, fp=120,cage_prob=17, hitscan=true },

  -- MELEE only monsters
  demon     = { kind=3002, prob=80, r=30,h=56, t=150, dm=25, fp=30, melee=true },
  spectre   = { kind=58,   prob=15, r=30,h=56, t=150, dm=25, fp=30, melee=true },
  skull     = { kind=3006, prob=20, r=16,h=56, t=100, dm=7,  fp=40, melee=true, float=true },
}

-- these monsters only created in special circumstances
SPECIAL_MONSTERS =
{
  cyber     = { kind=16, r=40,  h=110,t=4000,dm=150, fp=150 },
  spider    = { kind=7,  r=128, h=100,t=3000,dm=200, fp=240, hitscan=true }
}

MONSTER_GIVE =
{
  zombie   = { { ammo="bullet", give=10 } },
  shooter  = { { weapon="shotty" } },
  gunner   = { { weapon="chain" } }
}


------------------------------------------------------------

-- Weapon list
-- ===========
--
-- per  : ammo per shot
-- rate : firing rate (shots per second)
-- dm   : damage can inflict per shot
-- freq : usage frequency (in the ideal)

WEAPON_DEFS =
{
  pistol = {            ammo="bullet",         per=1, rate=1.8, dm=10 , freq=10 },
  shotty = { kind=2001, ammo="shell",  give=8, per=1, rate=0.9, dm=70 , freq=81 },
  super  = { kind=  82, ammo="shell",  give=8, per=2, rate=0.6, dm=200, freq=50 },
  chain  = { kind=2002, ammo="bullet", give=20,per=1, rate=8.5, dm=10 , freq=91 },

  launch = { kind=2003, ammo="rocket", give=2, per=1, rate=1.7, dm=90,  freq=50, dangerous=true },
  plasma = { kind=2004, ammo="cell",   give=40,per=1, rate=11,  dm=22 , freq=80 },
  bfg    = { kind=2006, ammo="cell",   give=40,per=40,rate=0.8, dm=450, freq=30 },

  -- MELEE weapons
  fist   = {            melee=true, rate=1.5, dm=10, freq=1 },
  saw    = { kind=2005, melee=true, rate=8.7, dm=10, freq=3 }
}

-- sometimes a certain weapon is preferred against a certain monster.
-- These values are multiplied with the weapon's "freq" field.

MONSTER_WEAPON_PREFS =
{
  zombie  = { shotty=5.0 },
  shooter = { shotty=5.0 },
  imp     = { shotty=5.0 },
  demon   = { super=3.0 },
  spectre = { super=3.0 },

  pain    = { launch=0.1 },
  skull   = { launch=0.1 },

  cyber   = { launch=3.0, bfg=6.0 },
  spider  = { bfg=9.0 },
}


AMMO_LIMITS =  -- double these for backpack
{
  bullet = 200, 
  shell  = 50,
  rocket = 50,
  cell   = 300
}

BULLET_THINGS =
{
  bullets    = { kind=2007, ammo="bullet", give=10, prob=10 },
  bullet_box = { kind=2048, ammo="bullet", give=50 },
}

SHELL_THINGS =
{
  shells     = { kind=2008, ammo="shell",  give= 4, prob=20 },
  shell_box  = { kind=2049, ammo="shell",  give=20 },
}

ROCKET_THINGS =
{
  rockets    = { kind=2010, ammo="rocket", give= 1, prob=10 },
  rocket_box = { kind=2046, ammo="rocket", give= 5 },
}

CELL_THINGS =
{
  cells      = { kind=2047, ammo="cell",   give=20, prob=20 },
  cell_pack  = { kind=  17, ammo="cell",   give=100 },
}

HEALTH_THINGS =
{
  potion   = { kind=2014, give=1,  prob=20 },
  stimpack = { kind=2011, give=10, prob=30 },
  medikit  = { kind=2012, give=25, prob=50 },
  soul     = { kind=2013, give=100, limit=200, prob=10 }

  -- BERSERK and MEGA are quest items
}

ARMOR_THINGS =
{
  helmet      = { kind=2015, give=   1, limit=200 },
  green_armor = { kind=2018, give= 100, limit=100 },
  blue_armor  = { kind=2019, give= 200, limit=200 }

  -- BLUE ARMOR is a quest item
}

PICKUP_MAP =
{
  health = HEALTH_THINGS,

  bullet = BULLET_THINGS,
  shell  = SHELL_THINGS,
  rocket = ROCKET_THINGS,
  cell   = CELL_THINGS,

  -- Note: armor is handled with special code, since
  --       BLUE ARMOR is a quest item.
  --
  -- Note 2: the BACKPACK is a quest item
}


CLUSTER_THINGS =
{
  potion = 8,
  helmet = 8,
  stimpack = 2,

  bullets = 3,
  shells  = 2,
  rocket  = 4,
}

THING_NUMS =  -- FIXME duplicated in above tables
{
  k_red    = 38,
  k_blue   = 40,
  k_yellow = 39,

  shotty = 2001,
  super  =   82,
  chain  = 2002,
  launch = 2003,
  plasma = 2004,
  saw    = 2005,
  bfg    = 2006,

  invis  = 2024,
  goggle = 2045,
  berserk= 2023,
  mega   =   83,
  invul  = 2022,
  backpack =  8,

  potion   = 2014,
  stimpack = 2011,
  medikit  = 2012,
  soul     = 2013,

  helmet      = 2015,
  green_armor = 2018,
  blue_armor  = 2019,
  armor  = 2019,     --- FIXME!!

  bullets    = 2007,
  bullet_box = 2048,
  shells     = 2008,
  shell_box  = 2049,
  rockets    = 2010,
  rocket_box = 2046,
  cells      = 2047,
  cell_pack  =   17,
}


------------------------------------------------------------

TOUGH_FACTOR = { easy=0.75, medium=1.00, hard=1.33 }
ACCURACIES   = { easy=0.65, medium=0.75, hard=0.85 }

HITSCAN_RATIOS = { 1.0, 0.8, 0.6, 0.4, 0.2, 0.1 }
MISSILE_RATIOS = { 1.0, 0.4, 0.1, 0.03 }
MELEE_RATIOS   = { 1.0 }

HITSCAN_DODGES = { easy=0.11, medium=0.22, hard=0.33 }
MISSILE_DODGES = { easy=0.71, medium=0.81, hard=0.91 }
MELEE_DODGES   = { easy=0.85, medium=0.95, hard=0.99 }

AMMO_DISTRIB   = { 30, 75, 50, 20, 2 }
HEALTH_DISTRIB = { 10, 70, 80, 40, 5 }


------------------------------------------------------------


zprint = do_nothing
zdump_table = do_nothing


function compute_pow_factors()

  local function pow_factor(info)
    return 2 + 2 * info.t ^ 0.5 * (info.dm / 50) ^ 0.8
  end

  for name,info in pairs(MONSTER_DEFS) do
    info.pow = pow_factor(info)
  end

  for name,info in pairs(SPECIAL_MONSTERS) do
    info.pow = pow_factor(info)
  end
end

compute_pow_factors()


function add_thing(p, c, bx, by, kind, blocking, angle, options)

--[[
if c.x==3 and c.y==3 then
print("add_thing",kind,bx,by,angle)
if options then dump_table(options, "options")
else print ("btw dude, no options")
end
end]]

  local B = p.blocks[c.blk_x+bx][c.blk_y+by]
  assert(B)
  assert(kind)

  if not B.things then B.things = {} end

  local THING =
  {
    kind=kind,
    angle=angle,
    options=options
  }

--[[
io.stderr:write("INSERTING ",kind," INTO BLOCK ", c.blk_x+bx, ",", c.blk_y+by, "\n")
--]]
  table.insert(B.things, THING)
  table.insert(p.all_things, THING)

  if blocking then
--- DOESNT TAKE SKILLS INTO ACCOUNT: assert(not B.has_blocker)
    B.has_blocker = true
  end

  return THING
end


function add_cage_spot(p,c, spot)
  if not c.cage_spots then
    c.cage_spots = {}
  end

  table.insert(c.cage_spots, spot)
end
  
function add_cage_area(p,c, x,y,w,h)  -- UNUSED
  if not c.cage_spots then
    c.cage_spots = {}
  end

  if h > 2 then
    add_cage_area(p,c, x, y, w, int(h/2))
    add_cage_area(p,c, x, y+int(h/2), w, h-int(h/2))
  elseif w > 2 then
    add_cage_area(p,c, x, y, int(w/2), h)
    add_cage_area(p,c, x+int(w/2), y, w-int(w/2), h)
  else
    assert(w > 0 and h > 0)

    if (w==2) and (h==2) then
      table.insert(c.cage_spots, {x=x, y=y, double=true })
    else
      for ay = 1,h do for ax = 1,w do
        table.insert(c.cage_spots, {x=x+ax-1, y=y+ay-1})
      end end
    end
  end
end


function hm_give_health(HM, value, limit)
  if HM.health < limit then
    HM.health = math.min(HM.health + value, limit)
  end
end

function hm_give_armor(HM, value, limit)
  if HM.armor < limit then
    HM.armor = math.min(HM.armor + value, limit)
  end
end

function hm_give_weapon(HM, weapon, ammo_mul)

  HM[weapon] = true

  local info = WEAPON_DEFS[weapon]
  assert(info)

  if info.ammo then
    HM[info.ammo] = HM[info.ammo] + info.give * (ammo_mul or 1)
  end
end

function hm_give_item(HM, item)

  if item == "backpack" then
    HM.backpack = true
    HM.bullet = HM.bullet + 10
    HM.shell  = HM.shell  + 4 
    HM.rocket = HM.rocket + 1 
    HM.cell   = HM.cell   + 20

  elseif item == "armor" then
    hm_give_armor(HM, 200, 200)

  elseif item == "mega" then
    hm_give_armor (HM, 200, 200)
    hm_give_health(HM, 200, 200)

  elseif item == "berserk" then
    HM.berserk = true
    hm_give_health(HM, 100, 100)

  elseif item == "invis" or item == "invul" then

    HM[item] = (HM[item] or 0) + 6
  end
end


function initial_models()

  -- Note: bullet numbers are understated (should be 50)
  -- so that the player isn't forced to empty the pistol.
  local MODELS =
  {
    easy = 
    {
      skill="easy",
      health=100, armor=0,
      bullet=20, shell=0, rocket=0, cell=0,
      fist=true, pistol=true,
      toughness=0
    },

    medium = 
    {
      skill="medium",
      health=100, armor=0,
      bullet=20, shell=0, rocket=0, cell=0,
      fist=true, pistol=true,
      toughness=0
    },
    
    hard = 
    {
      skill="hard",
      health=100, armor=0,
      bullet=20, shell=0, rocket=0, cell=0,
      fist=true, pistol=true,
      toughness=0
    }
  }

  return MODELS
end


function random_turn(angle)
  local r = math.random() * 100
  local step = sel(rand_odds(22), 90, 45)

  if r < 33 then
    -- no change
  elseif r < 66 then
    angle = angle - step
  else
    angle = angle + step
  end

  if angle <  0   then angle = angle + 360 end
  if angle >= 360 then angle = angle - 360 end

  return angle
end


function fire_power(wp_info)
  return wp_info.rate * wp_info.dm
end


----------------------------------------------------------------

-- Simulate the battle for skill SK (2|3|4).
-- Updates the given player HModel.
--
function simulate_battle(HM, mon_set, quest)
 
  local shoot_accuracy = ACCURACIES[HM.skill]

  local active_mon = {}

  local cur_weap = "pistol"
  local remain_shots = 0


  local function dump_active_mon()
    zprint("  Monsters {")
    for zzz,AC in ipairs(active_mon) do
      zprint("    ", AC.name, AC.tough)
    end
    zprint("  }")
  end

  local function give_monster_stuff(AC)
    if AC.caged then return end

    local stuff = MONSTER_GIVE[AC.name]
    if not stuff then return end

    for zzz,item in ipairs(stuff) do
      if item.weapon then
        hm_give_weapon(HM, item.weapon, 0.5) -- dropped
      elseif item.ammo then
        HM[item.ammo] = HM[item.ammo] + item.give
      else
        error("UKNOWN ITEM GIVEN BY " .. AC.name)
      end
    end
  end

  local function remove_dead_mon()
    for i = #active_mon,1,-1 do
      if active_mon[i].tough <= 0 then
        give_monster_stuff(active_mon[i])
        table.remove(active_mon, i)
      end
    end
  end

  local function active_toughness()
    local T = 0
    for zzz,AC in ipairs(active_mon) do
      T = T + AC.tough
    end
    return T
  end

  local function hurt_mon(idx, damage)
    local AC = active_mon[idx]
    if AC and AC.tough > 0 then
      AC.tough = AC.tough - damage
    end
  end

  local function hurt_player(damage)
    -- ignore damage when Invulerable
    if HM.invul then return end

    if HM.armor > 0 then
      local saved = damage * 0.4  -- approximation
      if saved < HM.armor then
        HM.armor = HM.armor - saved
      else
        saved = HM.armor
        HM.armor = 0
      end
      damage = damage - saved
    end
    HM.health = HM.health - damage
  end


  local function player_shoot()

    local function select_weapon()
      
      -- firstly, select best weapon which has real ammo
      --[[ DISABLED -- provides better ammo 
      local wp

      for name,info in pairs(WEAPON_DEFS) do
        if HM[name] and info.ammo and HM[info.ammo] > 0 then

          if not wp or firepower(wp) < firepower(name) then
            wp = name
          end
        end
      end
      if wp then return wp end
      --]]

      -- aha, ammo all gone, virtual reality mode.
      -- use current weapon for a small time, then switch

      if remain_shots > 0 then return cur_weap end

      local first_mon = active_mon[1].name
      assert(first_mon)

      -- preferred weapon based on monster
      local MW_prefs = MONSTER_WEAPON_PREFS[first_mon]
      
      local names = {}
      local probs = {}
      
      for name,info in pairs(WEAPON_DEFS) do
        if HM[name] then
          local freq = info.freq
          freq = freq * (MW_prefs and MW_prefs[name] or 1.0)

          table.insert(names, name)
          table.insert(probs, freq)
        end
      end

      assert(#names >= 1)
      assert(#names == #probs)

      local idx = rand_index_by_probs(probs)

      local wp = names[idx]
      local info = WEAPON_DEFS[wp]
      assert(info)

      remain_shots = 1 + math.random() + math.random()
      remain_shots = int(remain_shots * info.rate)

      if remain_shots < 1 then remain_shots = 1 end

      return wp
    end

    local function blast_monsters(num, damage)
      for i = 1,num do
        hurt_mon(i, damage * (num - i + 1) / num)
      end
    end

    local function shoot_weapon(name, info)

zprint("PLAYER SHOOT: ", name, remain_shots, "ammo",
info.ammo and HM[info.ammo] or "-")

      hurt_mon(1, info.dm * shoot_accuracy)

zprint(active_mon, #active_mon, active_mon[1])
      -- shotguns can kill multiple monsters
      if (name == "shotty" or name == "super") and
          active_mon[1].tough <= 0 and active_mon[2] then
        hurt_mon(2, info.dm * shoot_accuracy / 2.0)
      end

      if name == "bfg"    then blast_monsters(9, 50) end
      if name == "launch" then blast_monsters(3, 64) end

      if info.ammo then
        HM[info.ammo] = HM[info.ammo] - info.per
      end

      remain_shots = remain_shots - 1
    end

    ------ player_shoot ------
    --
    -- 1. select weapon
    -- 2. apply damage to monster #1
    -- 2a. if shotgun killed #1, hit monster #2
    -- 2b. for BFG, spray monsters #1..#9
    -- 2c. rocket damage: partial for #1..#3
    -- 3. update ammo
    -- 4. return time taken

    cur_weap = select_weapon()

    local info = WEAPON_DEFS[cur_weap]
    assert(info)

    shoot_weapon(cur_weap, info)

    return 1 / info.rate
  end


  local function monster_shoot(time)

    local function mon_hurts_mon(m1, m2)
      if m1 == m2 then
        return MONSTER_DEFS[m1].hitscan and (m1 ~= "vile")
      end

      if (m1 == "knight" and m2 == "baron") or
         (m1 == "baron"  and m2 == "knight") then
        return false
      end

      return true
    end

    local function distance_ratio(idx, AC)
      -- vile fire is not blocked
      if AC.name == "vile" then return 1 end

      if AC.info.hitscan then return HITSCAN_RATIOS[idx] or 0 end
      if AC.info.melee   then return MELEE_RATIOS[idx] or 0 end
      return MISSILE_RATIOS[idx] or 0
    end

    local function dodge_ratio(AC)
      if AC.info.hitscan then return HITSCAN_DODGES[HM.skill] end
      if AC.info.melee   then return MELEE_DODGES[HM.skill] end
      return MISSILE_DODGES[HM.skill]
    end

    -------- monster_shoot ---------
    -- 
    -- 1. monster #1 does full damage to player
    -- 1a.  (all other melee monsters do ZERO dm)
    -- 2. monster #2..#N does partial damage:
    -- 2a. assuming other monsters get in way
    -- 2b. 2 -> 1/2, 3->1/3, 4->1/5, 5->1/8  factorial
    -- 2c. in-fighting (damage previous mon)
    -- 3. player dodging:
    -- 3a. hitscan: dodged 20%
    -- 3b. missile: dodged 50%
    -- 3c. melee: dodged 80%

    for idx,AC in ipairs(active_mon) do
      if AC.tough > 0 then
        local ratio = distance_ratio(idx, AC)
        local dodge = 1.0 - dodge_ratio(AC)

        if HM.invis then dodge = dodge / 2 end

        local mon_walk = 0.5 -- monster walking/pain time

        hurt_player(AC.info.dm * time * ratio * dodge * mon_walk)

        -- simulate infighting
        local infight_prob = 0.75
        if idx >= 2 and mon_hurts_mon(AC.name, active_mon[idx-1].name) then
          hurt_mon(idx-1, AC.info.dm * time * mon_walk * infight_prob)
        end
      end 
    end
  end

  local function update_powerups(HM)

    if HM.invis then
      HM.invis = HM.invis - 1
      if HM.invis <= 0 then
        HM.invis = nil
        zprint("LOST POWERUP:", "invis")
      end
    end

    if HM.invul then
      HM.invul = HM.invul - 1
      if HM.invul <= 0 then
        HM.invul = nil
        zprint("LOST POWERUP:", "invul")
      end
    end
  end

  local function handle_quest()
    if quest then
      if quest.kind == "weapon" then
        hm_give_weapon(HM, quest.item)
        zprint("PICKED UP QUEST WEAPON", quest.item)
      
      elseif quest.kind == "item" then
        hm_give_item(HM, quest.item)
        zprint("PICKED UP QUEST ITEM", quest.item)
      end
    end
  end

  ---=== simulate_battle ===---

  update_powerups(HM)  -- tick 1 of 2

  -- create list of monsters
  assert(mon_set)

  for zzz,th in ipairs(mon_set) do
    for num = 1,th.horde do
      table.insert(active_mon,
        { name=th.name, info=th.info, tough=th.info.t, caged=th.caged })
    end
  end

  if #active_mon == 0 then
    update_powerups(HM)  -- tick 2 of 2
    handle_quest(do_quest)

    return
  end

  -- put toughest monster first, weakest last.
  table.sort(active_mon, function(A,B) return A.tough > B.tough end)

  local do_quest = true

  local total_time = 0
  local round_time

  local total_tough = active_toughness()

  repeat

zprint("\n  ----------------------\n")
zprint("  Time ", total_time)
dump_active_mon(active_mon)
zdump_table(HM, "HModel")

    round_time = player_shoot()

    monster_shoot(round_time)

    remove_dead_mon()

    -- get quest item at the half-way point
    if do_quest and active_toughness() < total_tough/2 then
      update_powerups(HM) -- tick 2 of 2
      handle_quest()

      do_quest = nil
    end

    total_time = total_time + round_time

  until #active_mon == 0

  assert(not do_quest)

zprint("BATTLE OVER.")
zdump_table(HM, "HModel")
zprint("\n\n\n")
end


----------------------------------------------------------------


function distribute_pickups(p, c, HM)

  local R -- table[SKILL] -> required num

  local SK = HM.skill
  assert(SK)

  local function add_pickup(c, name, info, cluster)
    if not c.pickup_set then
      c.pickup_set = { easy={}, medium={}, hard={} }
    end
    table.insert(c.pickup_set[SK], { name=name, info=info, cluster=cluster })
  end


  local function be_nice_to_player()

    -- let poor ol' player have a shotgun near start

    if c.along == #c.quest.path then return end

    if not HM.shotty and rand_odds(66) then
      add_pickup(c, "shotty", WEAPON_DEFS.shotty, 1)
      hm_give_weapon(HM, "shotty")
    end

    if not HM.chain and c.quest.level >= 3 and rand_odds(11) then
      add_pickup(c, "chain", WEAPON_DEFS.chain, 1)
      hm_give_weapon(HM, "chain")
    end

    if HM.armor <= 0 and rand_odds(2) then
      add_pickup(c, "green_armor", ARMOR_THINGS.green_armor, 1)
      hm_give_armor(HM, 100, 100)
    end
  end


  local function compute_want(stat)
    return sel(stat == "health", 75, 0)
  end

  local function decide_pickup(stat, things, R)

    local infos = {}
    local probs = {}
    local names = {}

    for name,info in pairs(things) do
      if info.give <= R * 3 then
        local prob = info.prob or 50
        if info.give > R then
          prob = prob / 3
        end
        table.insert(names, name)
        table.insert(infos, info)
        table.insert(probs, prob)
      end
    end
    
    if #infos == 0 then return nil, nil end  -- SHIT!

    local idx = rand_index_by_probs(probs)
    local th_info = infos[idx]

    local cluster = int(math.random(10,40) / th_info.give)

    if cluster < 1 then cluster = 1 end
    if cluster > 9 then cluster = 9 end  -- FIXME
  
    local max_cluster = 1 + int(R / th_info.give)

    if cluster > max_cluster then cluster = max_cluster end

--[[ if stat ~= "health" then
print("PICKUP ", names[idx], cluster, c.x, c.y)
end ]]
    return th_info, cluster
  end

  local function get_distrib_targets(c)
    local distrib = copy_table(AMMO_DISTRIB)
    local targets = {}

    for n = 1,5 do
      local idx = c.along + n - 3
      if (1 <= idx) and (idx <= #c.quest.path) then
        targets[n] = c.quest.path[idx]
      else
        distrib[n] = 0
      end
    end

    return distrib, targets
  end


  ---=== distribute_pickups ===---

  local distrib, targets = get_distrib_targets(c)

  be_nice_to_player()

  for stat,things in pairs(PICKUP_MAP) do

    local want = compute_want(stat, HM)

    -- create pickups until target reached
    while HM[stat] < want do

      local r_max = want - HM[stat]

      local info, cluster = decide_pickup(stat, things, r_max)

      if not info then break end

      local tc = targets[rand_index_by_probs(distrib)]

      add_pickup(tc, stat, info, cluster)

      HM[stat] = HM[stat] + cluster * info.give
    end
  end
end


function place_battle_stuff(p, c)

  local SK

  local function copy_shuffle_spots(list)
    local copies = {}
    for zzz, spot in ipairs(list) do
      table.insert(copies, copy_table(spot))
    end
    rand_shuffle(copies)
    return copies
  end

  local function dump_spots(list)
    print("{")
    for zzz, sp in ipairs(list) do
      print(string.format("  (%d,%d) %s",
        sp.x, sp.y, sel(sp.double, "DOUBLE", "-")))
    end
    print("}")
  end
  
  local function spot_dist(s1, s2)
    local dx = math.abs(s1.x - s2.x)
    local dy = math.abs(s1.y - s2.y)
    return math.max(dx, dy)
  end
  
  local function alloc_spot(spots, want_big, near_to)

    if #spots == 0 then return nil, nil end

    if near_to and not want_big then
      local best = 0
      local best_d = 999

      -- our search is not exhaustive (too expensive!)
      for i = 1,math.min(#spots,BW) do
        if not spots[i].double then
          local d = spot_dist(spots[i], near_to)
          if d < best_d then best, best_d = i, d end
        end
      end

      if best > 0 then
        return table.remove(spots, best)
      end
    end
    
    for i = 1,#spots do
      if (not spots[i].double) == (not want_big) then
        return table.remove(spots, i)
      end
    end

    local spot = table.remove(spots, 1)

    -- split the double into four singles
    if spot.double then
      assert(not want_big)

      spot.double = nil

      table.insert(spots, { x=spot.x+1, y=spot.y+0 })
      table.insert(spots, { x=spot.x+0, y=spot.y+1 })
      table.insert(spots, { x=spot.x+1, y=spot.y+1 })

      -- intermingle the new singles
      rand_shuffle(spots)
    end

    return spot
  end

  local function place_pickup(spots, dat)

    local spot = alloc_spot(spots, dat.cluster >= 5)

    if not spot then
      io.stderr:write("UNABLE TO PLACE: ", dat.name, "\n")
      -- FIXME: put in next cell
      return
    end

    local options = { [SK]=true }
    
    assert(dat.cluster <= 9)
    for i = 1,dat.cluster do
      
      local dx = (int(i / 3) - 1) * 20 -- TEMP JUNK
      local dy = (int(i % 3) - 1) * 20

      local th = add_thing(p, c, spot.x, spot.y, dat.info.kind, false, 0, options)
      th.dx, th.dy = dx, dy

      if spot.dx then th.dx = (th.dx or 0) + spot.dx end
      if spot.dy then th.dy = (th.dy or 0) + spot.dy end
    end
  end

  local function place_pickup_list(pickups)

    local spots = copy_shuffle_spots(c.free_spots)

    -- perform two passes, place big clusters first
    for pass = 1,2 do
      for zzz,dat in ipairs(pickups) do
        if (pass==1) == (dat.cluster >= 5) then
          place_pickup(spots, dat)

          -- re-use spots if we run out
          if #spots == 0 then 
            spots = copy_shuffle_spots(c.free_spots)
          end
        end
      end
    end
  end

  local function place_monster(spots, dat)
    assert(dat.info)

    if dat.caged then return end

    local angle = math.random(0,7) * 45

    local is_big = (dat.info.r >= 32)
    local spot = alloc_spot(spots, is_big)

    for i = 1,dat.horde do

      if not spot or (is_big and not spot.double) then
        io.stderr:write("UNABLE TO PLACE: ", dat.name, "\n")
        -- FIXME: put in next cell
        return
      end

      local options = { [SK]=true }

      if rand_odds(sel(c.along == #c.quest.path, 88, 44)) then
        options.ambush = true
      end

      local th = add_thing(p, c, spot.x, spot.y, dat.info.kind, true, angle, options)
      th.mon_name = dat.name

      if is_big then
        -- Note: cannot handle monsters with radius >= 64 
        th.dx = 32; th.dy = 32
      end

      if spot.dx then th.dx = (th.dx or 0) + spot.dx end
      if spot.dy then th.dy = (th.dy or 0) + spot.dy end

      angle = random_turn(angle)

      spot = alloc_spot(spots, is_big, spot)
    end
  end

  local function place_monster_list(mons)

    local spots = copy_shuffle_spots(c.free_spots)

    -- perform two passes, place big monsters first
    for pass = 1,2 do
      for zzz, dat in ipairs(mons) do
        local info = MONSTER_DEFS[dat.name]
        if (pass==1) == (info.r >= 32) then
          place_monster(spots, dat)
        end
      end
    end
  end

  --- place_battle_stuff ---

  for zzz,skill in ipairs(SKILLS) do

    SK = skill

    if c.pickup_set then
      place_pickup_list(c.pickup_set[SK])
    end

    if c.mon_set then
      place_monster_list(c.mon_set[SK])
    end
  end
end

function place_quest_stuff(p, Q)

  for zzz,c in ipairs(Q.path) do
    if c.mon_set or c.pickup_set then
      place_battle_stuff(p, c)
      c.mon_set = nil
      c.pickup_set = nil
    end
  end
end


----------------------------------------------------------------


function battle_in_cell(p, c)

  local T, U, SK

  local function T_average()
    return (T.easy + T.medium + T.hard) / 3.0
  end

  local function T_max()
    return math.max(T.easy, T.medium, T.hard)
  end

  local function best_weapon(skill)
    -- get firepower of best held weapon
    local best_name = "fist"
    local best_info = WEAPON_DEFS[best_name]

    for name,info in pairs(WEAPON_DEFS) do
      if p.models[skill][name] and not info.melee then
        if fire_power(info) > fire_power(best_info) then
          best_name, best_info = name, info
        end
      end
    end

    return best_info, best_name
  end

  local function free_spot(bx, by)
    local B = p.blocks[c.blk_x+bx][c.blk_y+by]

    return (B and not B.solid and (not B.fragments or B.can_thing) and
            not B.has_blocker and not B.is_cage and not B.near_player)
  end

  local function free_double_spot(bx, by)
    local f_min =  99999
    local f_max = -99999

    for dx = 0,1 do for dy = 0,1 do
      if not free_spot(bx+dx, by+dy) then return false end

      local B = p.blocks[c.blk_x+bx+dx][c.blk_y+by+dy]
      if B.fragments then
        B = B.fragments[1][1]
        assert(B)
      end

      f_min = math.min(f_min, B.f_h)
      f_max = math.max(f_max, B.f_h)
    end end

    return f_max <= (f_min + 10)
  end

  local function find_free_spots()
    local list = {}
    local total = 0
    for bx = 1,BW,2 do for by = 1,BH,2 do
      if bx < BW and by < BH and free_double_spot(bx, by) then
        table.insert(list, { x=bx, y=by, double=true})
        total = total + 4
      else
        for dx = 0,1 do for dy = 0,1 do
          if bx+dx <= BW and by+dy <= BH and free_spot(bx+dx, by+dy) then
            table.insert(list, { x=bx+dx, y=by+dy })
            total = total + 1
          end
        end end
      end
    end end

    return list, total
  end

---###  local function how_much_space()
---###    local count = 0
---###    for bx = 1,BW do
---###      for by = 1,BH do
---###        if free_spot(bx, by) then
---###          count = count + 1
---###        end
---###      end
---###    end
---###    return count / (BW * BH / 2)
---###  end


  local function decide_monster(firepower)

    local names = { "none" }
    local probs = { 30     }

    for name,info in pairs(MONSTER_DEFS) do
      if (info.pow < T*2) and (info.fp < firepower*2) then

        local prob = info.prob
        if info.pow > T then
          prob = prob / 4
        end
        if (info.fp > firepower) then
          prob = prob / 4
        end

        table.insert(names, name)
        table.insert(probs, prob)
      end
    end

    if #probs == 1 then return nil, nil end

    local idx = rand_index_by_probs(probs)
    local name = names[idx]

    if name == "none" then return name, 0 end

    local info = MONSTER_DEFS[name]
    assert(info)

    local horde = 1
    local max_horde = 1 + int(T / info.pow)

    if info.t <= 500 and rand_odds(30) then horde = horde + 1 end
    if info.t <= 100 then horde = horde + rand_index_by_probs { 90, 40, 10, 3, 0.5 } end

    if horde > max_horde then horde = max_horde end

    return name, horde
  end

  local function create_monsters()

    local fp = fire_power(best_weapon(SK))

    -- create monsters until T is exhausted
    for loop = 1,99 do
      local name, horde = decide_monster(fp)

      if not name then break end

      if name == "none" then
        T = T-20; U = U+20
      else
        local info = MONSTER_DEFS[name]
        table.insert(c.mon_set[SK], { name=name, horde=horde, info=info })
        T = T - horde * info.pow
      end
    end
  end

  local function decide_cage_monster(firepower, horde, allow_big)

    local names = {}
    local probs = {}

    for name,info in pairs(MONSTER_DEFS) do
      if (info.dm < 10) or 
         ((info.pow * horde < T*2) and (info.fp < firepower*2))
      then
        local prob = info.cage_prob or 0

        if info.r >= 25 and not allow_big then prob = 0 end

        if prob > 0 then
          table.insert(names, name)
          table.insert(probs, prob)
        end
      end
    end

    assert(#probs > 0)

    local idx = rand_index_by_probs(probs)
    local info = MONSTER_DEFS[names[idx]]
    assert(info)

    local horde = 1
    if allow_big and (info.r < 25) then
      horde = 3 -- FIXME: better decision
    end

    return names[idx], horde
  end

  local function fill_cages()
    
    if not c.cage_spots then return end

    local orig_T = T

    local fp = fire_power(best_weapon(SK))
    
    local sml_name, sml_horde = decide_cage_monster(fp, #c.cage_spots)
    local big_name, big_horde = decide_cage_monster(fp, #c.cage_spots, true)

    for zzz,spot in ipairs(c.cage_spots) do

      local m_name  = sel(spot.double, big_name, sml_name)
      local m_horde = sel(spot.double, big_horde,sml_horde)

      if spot.different then
        m_name, m_horde = decide_cage_monster(fp, sel(spot.double,2,1), spot.double)
      end

      local m_info = MONSTER_DEFS[m_name]
      assert(m_info)

      for i = 1,m_horde do
        local angle = math.random(0,7) * 45
        local options = { [SK]=true }

        local dx = int((i-1)%2) * 64
        local dy = int((i-1)/2) * 64

        local th = add_thing(p, c, spot.x, spot.y, m_info.kind, true, angle, options)
        th.mon_name = m_name

        if m_info.r >= 32 then  -- big monster
          dx, dy = dx+32, dy+32
        end

        if spot.dx then dx = dx + spot.dx end
        if spot.dy then dy = dy + spot.dy end

        th.dx = dx
        th.dy = dy

        -- allow monster to take part in battle simulation
        table.insert(c.mon_set[SK], { name=m_name, horde=1, info=m_info, caged=true })

        -- caged monsters affect the total toughness
        T = T - m_info.pow
      end
    end

    -- don't use up all the toughness, allow non-caged monsters
    T = math.max(T, orig_T / 3)
  end

  ---=== battle_in_cell ===---

zprint("BATTLE IN", c.x, c.y)

  local spots, free_space = find_free_spots()

  c.free_spots = spots

  if free_space < 2 then return end
  free_space = free_space * 1.5 / (BW * BH)

  c.mon_set = { easy={}, medium={}, hard={} }

  for zzz,skill in ipairs(SKILLS) do
  
    SK = skill

    T = c.toughness * (free_space ^ 0.7) * TOUGH_FACTOR[SK]
    T = T + p.models[SK].toughness
    U = 0

    fill_cages()

    create_monsters(space)

    -- left over toughness gets compounded (but never decreased)
    p.models[SK].toughness = math.max(0, T + U)

    local quest = (c.along == #c.quest.path) and c.quest

zprint("SIMULATE in CELL", c.x, c.y, SK)

    simulate_battle(p.models[SK], c.mon_set[SK], quest)

    distribute_pickups(p, c, p.models[SK])
  end
end


function battle_in_quest(p, Q)
  for zzz,c in ipairs(Q.path) do
    if c.toughness then
      battle_in_cell(p, c)
      c.toughness = nil
    end
  end
end

function battle_through_level(p)

  -- step 1: decide monsters, simulate battles, decide health/ammo

  for zzz,Q in ipairs(p.quests) do
    battle_in_quest(p, Q)
    for yyy,R in ipairs(Q.children) do
      battle_in_quest(p, R)
    end
  end

  -- step 2: place monsters and health/ammo into level

  for zzz,Q in ipairs(p.quests) do
    place_quest_stuff(p, Q)
    for yyy,R in ipairs(Q.children) do
      place_quest_stuff(p, R)
    end
  end
end

