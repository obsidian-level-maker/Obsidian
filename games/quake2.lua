----------------------------------------------------------------
-- GAME DEF : Quake II
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2008 Andrew Apted
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


Q2_THINGS =
{
  -- players
  player1 = { id="info_player_start", kind="other", r=16,h=56 },
  player2 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player3 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player4 = { id="info_player_coop",  kind="other", r=16,h=56 },

  dm_player = { id="info_player_deathmatch", kind="other", r=16,h=56 },

  -- enemies
  guard      = { id="monster_soldier_light", kind="monster", r=16, h=56, },
  guard_sg   = { id="monster_soldier", kind="monster", r=16, h=56, },
  guard_mg   = { id="monster_soldier_ss",kind="monster", r=16, h=56, },
  enforcer   = { id="monster_infantry",kind="monster", r=16, h=56, },
  beserker   = { id="monster_beserk",  kind="monster", r=16, h=56, },
  grenader   = { id="monster_gunner",  kind="monster", r=16, h=56, },

  tank       = { id="monster_tank",    kind="monster", r=16, h=56, },
  gladiator  = { id="monster_gladiator",kind="monster", r=32, h=88, },
  medic      = { id="monster_medic",   kind="monster", r=16, h=56, },
  maiden     = { id="monster_chick",   kind="monster", r=16, h=56, },
  tank_cmdr  = { id="monster_tank_commander",kind="monster", r=32, h=88, },

  flyer      = { id="monster_flyer",   kind="monster", r=16, h=56, },
  technician = { id="monster_floater", kind="monster", r=16, h=56, },
  icarus     = { id="monster_hover",   kind="monster", r=16, h=56, },
  parasite   = { id="monster_parasite",kind="monster", r=16, h=56, },
  shark      = { id="monster_flipper", kind="monster", r=16, h=56, },
  mutant     = { id="monster_mutant",  kind="monster", r=32, h=56, },
  brain      = { id="monster_brain",   kind="monster", r=16, h=56, },

  -- bosses
  Super_tank = { id="monster_supertank",kind="monster", r=64, h=112, },
  Huge_flyer = { id="monster_boss2",    kind="monster", r=56, h=80,  },
  Jorg       = { id="monster_jorg",     kind="monster", r=80, h=140, },
  Makron     = { id="monster_makron",   kind="monster", r=30, h=90,  },

  -- pickups
  k_blue  = { id="key_blue_key",  kind="pickup", r=16, h=32, pass=true },
  k_red   = { id="key_red_key",   kind="pickup", r=16, h=32, pass=true },
  k_cd    = { id="key_data_cd",   kind="pickup", r=16, h=32, pass=true },
  k_pass  = { id="key_pass",      kind="pickup", r=16, h=32, pass=true },
  k_cube  = { id="key_power_cube",kind="pickup", r=16, h=32, pass=true },
  k_pyr   = { id="key_pyramid",   kind="pickup", r=16, h=32, pass=true },

  shotty   = { id="weapon_shotgun",         kind="pickup", r=16, h=32, pass=true },
  ssg      = { id="weapon_supershotgun",    kind="pickup", r=16, h=32, pass=true },
  machine  = { id="weapon_machinegun",      kind="pickup", r=16, h=32, pass=true },
  chain    = { id="weapon_chaingun",        kind="pickup", r=16, h=32, pass=true },
  grenade  = { id="weapon_grenadelauncher", kind="pickup", r=16, h=32, pass=true },
  rocket   = { id="weapon_rocketlauncher",  kind="pickup", r=16, h=32, pass=true },
  hyper    = { id="weapon_hyperblaster",    kind="pickup", r=16, h=32, pass=true },
  rail     = { id="weapon_railgun",         kind="pickup", r=16, h=32, pass=true },
  bfg      = { id="weapon_bfg",             kind="pickup", r=16, h=32, pass=true },

  heal_2     = { id="item_health_small", kind="pickup", r=16, h=32, pass=true },
  heal_10    = { id="item_health",       kind="pickup", r=16, h=32, pass=true },
  heal_25    = { id="item_health_large", kind="pickup", r=16, h=32, pass=true },
  heal_100   = { id="item_health_mega",  kind="pickup", r=16, h=32, pass=true },
  adrenaline = { id="item_adrenaline",   kind="pickup", r=16, h=32, pass=true },

  armor_2    = { id="item_armor_shard",  kind="pickup", r=16, h=32, pass=true },
  armor_25   = { id="item_armor_jacket", kind="pickup", r=16, h=32, pass=true },
  armor_50   = { id="item_armor_combat", kind="pickup", r=16, h=32, pass=true },
  armor_100  = { id="item_armor_body",   kind="pickup", r=16, h=32, pass=true },

  am_bullet  = { id="ammo_bullets", kind="pickup", r=16, h=32, pass=true },
  am_cell    = { id="ammo_cells",   kind="pickup", r=16, h=32, pass=true },
  am_shell   = { id="ammo_shells",  kind="pickup", r=16, h=32, pass=true },
  am_grenade = { id="ammo_grenades",kind="pickup", r=16, h=32, pass=true },
  am_slug    = { id="ammo_slugs",   kind="pickup", r=16, h=32, pass=true },
  am_rocket  = { id="ammo_rockets", kind="pickup", r=16, h=32, pass=true },

  bandolier  = { id="item_bandolier", kind="pickup", r=16, h=32, pass=true },
  breather   = { id="item_breather",  kind="pickup", r=16, h=32, pass=true },
  enviro     = { id="item_enviro",    kind="pickup", r=16, h=32, pass=true },
  invuln     = { id="item_invulnerability", kind="pickup", r=16, h=32, pass=true },
  quad       = { id="item_quad",      kind="pickup", r=16, h=32, pass=true },

  -- scenery
  barrel      = { id="misc_explobox", kind="scenery", r=20, h=40, pass=true },
  dead_dude   = { id="misc_deadsoldier", kind="scenery", r=20, h=60, pass=true },
  insane_dude = { id="misc_insane",  kind="scenery", r=20, h=60, pass=true },

  -- special

  -- TODO
}

----------------------------------------------------------------

Q2_COMBOS =
{
  BASE =
  {
    mat_pri = 5,
    wall = 12, void = 12, floor=0, ceil=0,
    decorate = 10, door_side = 23,

    theme_probs = { BUNKER=120, CELLS=25  },
  },

}

Q2_EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


Q2_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

Q2_MISC_PREFABS =
{
  elevator =
  {
    prefab = "WOLF_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=21, front=14, }
  },
}



---- QUEST STUFF ----------------

Q2_QUESTS =
{
  key = { k_red=60, k_blue=30, },

  switch = { },

  weapon = { machine_gun=50, gatling_gun=20, },

  item =
  {
    crown = 50, chest = 50, cross = 50, chalice = 50,
    one_up = 2,
  },

  exit =
  {
    elevator=50
  }
}


Q2_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    scenery = { ceil_light=90 },

    space_range = { 10, 50 },
  },

  STORAGE =
  {
    scenery = { barrel=50, green_barrel=80, }
  },

  TREASURE =
  {
    pickups = { cross=90, chalice=90, chest=20, crown=5 },
    pickup_rate = 90,
  },

  SUPPLIES =
  {
    scenery = { barrel=70, bed=40, },

    pickups = { first_aid=50, good_food=90, clip_8=70 },
    pickup_rate = 66,
  },

  QUARTERS =
  {
    scenery = { table_chairs=70, bed=70, chandelier=70,
                bare_table=20, puddle=20,
                floor_lamp=10, urn=10, plant=10
              },
  },

  BATHROOM =
  {
    scenery = { sink=50, puddle=90, water_well=30, empty_well=30 },
  },

  KITCHEN =
  {
    scenery = { kitchen_stuff=50, stove=50, pots=50,
                puddle=20, bare_table=20, table_chairs=5,
                sink=10, barrel=10, green_barrel=5, plant=2
              },

    pickups = { good_food=15, dog_food=5 },
    pickup_rate = 20,
  },

  TORTURE =
  {
    scenery = { hanging_cage=80, skeleton_in_cage=80,
                skeleton_relax=30, skeleton_flat=40,
                hanged_man=60, spears=10, bare_table=10,
                gibs_1=10, gibs_2=10,
                junk_1=10, junk_2=10,junk_3=10
              },
  },
}

Q2_THEMES =
{
  BASE =
  {
  },
}


----------------------------------------------------------------

Q2_MONSTERS =
{
  guard      = { prob=20, hp= 20, dm=4 },
  guard_sg   = { prob=70, hp= 30, dm=10, hitscan=true },
  guard_mg   = { prob=70, hp= 30, dm=10, hitscan=true },
  enforcer   = { prob=50, hp=100, dm=10, hitscan=true },

  flyer      = { prob=90, hp= 50, dm=5 },
  shark      = { prob= 0, hp= 50, dm=5, melee=true },
  parasite   = { prob=10, hp=175, dm=10 },

  maiden     = { prob=50, hp=175, dm=30 },
  technician = { prob=50, hp=200, dm=8 },
  beserker   = { prob=50, hp=240, dm=18, melee=true },
  icarus     = { prob=70, hp=240, dm=5 },

  medic      = { prob=30, hp=300, dm=21 },
  mutant     = { prob=30, hp=300, dm=24, melee=true },
  brain      = { prob=20, hp=300, dm=17, melee=true },
  grenader   = { prob=10, hp=400, dm=30 },
  gladiator  = { prob=10, hp=400, dm=40 },

  tank       = { prob= 3, hp=750, dm=160 },
  tank_cmdr  = { prob= 2, hp=1000,dm=160 },
}

Q2_BOSSES =
{
}

Q2_MONSTER_GIVE =
{
}

Q2_WEAPONS =
{
  pistol   = { rate=1.7, dm=10, pref= 1 },
  shotty   = { rate=0.6, dm=40, pref=20, ammo="shell",  per=1  },
  ssg      = { rate=0.8, dm=88, pref=70, ammo="shell",  per=2, splash={0,8} },
  machine  = { rate=6.0, dm=8,  pref=20, ammo="bullet", per=1  },
  chain    = { rate=14,  dm=8,  pref=90, ammo="bullet", per=1  },
  grenade  = { rate=0.7, dm=5,  pref=15, ammo="grenade",per=1, splash={60,15,3}  },
  rocket   = { rate=1.1, dm=90, pref=30, ammo="rocket", per=1, splash={0,20,6,2} },
  hyper    = { rate=5.0, dm=20, pref=60, ammo="slug",   per=1  },
  rail     = { rate=0.6, dm=140,pref=50, ammo="cell",   per=1, splash={0,25,5} },
  bfg      = { rate=0.3, dm=200,pref=20, ammo="cell",   per=50, splash={0,50,40,30,20,10,10} },

  -- Notes:
  --
  -- The BFG can damage lots of 'in view' monsters at once.
  -- This is modelled with a splash damage table.
  --
  -- Railgun can pass through multiple enemies.  We assume
  -- the player doesn't manage to do it very often.
  --
  -- Grenades don't do any direct damage when they hit a
  -- monster, it's all in the splash baby.
}

Q2_PICKUPS =
{
  first_aid = { stat="health", give=25 },
  good_food = { stat="health", give=10 },
  dog_food  = { stat="health", give=4  },

  -- NOTE: no "gibs" here, they are fairly insignificant

  clip_8  =   { stat="bullet", give=8 },
}

Q2_INITIAL_MODEL =
{
  player =
  {
    health=100, armor=0, bullet=8,
    knife=true, pistol=true
  }
}


------------------------------------------------------------

Q2_EPISODE_THEMES =
{
  { BASE=7, },
  { BASE=6, },
  { BASE=6, },
  { BASE=6, },
}

Q2_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}

Q2_QUEST_LEN_PROBS =
{
  ----------  2   3   4   5   6   7   8   9  10  11  12  -------

  key    = {  0,  0,  2, 10, 20, 50, 75, 40, 20, 10, 5, 1 },
  exit   = {  0,  0,  2, 10, 20, 50, 75, 40, 20, 10, 5, 1 },

  boss   = {  0,  0,  2, 10, 30, 50, 30, 10, 2 },

  weapon = {  0, 90, 50, 12, 4, 2 },
  item   = { 30, 70, 70, 10 },  -- treasure
}

function wolfy_decide_quests(level_list, is_spear)

  local function add_quest(L, kind, item, secret_prob)
    secret_prob = 0 --FIXME !!!!

    local len_probs = non_nil(Q2_QUEST_LEN_PROBS[kind])
    local Quest =
    {
      kind = kind,
      item = item,
      want_len = 1 + rand_index_by_probs(len_probs),
    }
    if item == "secret" or (secret_prob and rand_odds(secret_prob)) then
      Quest.is_secret = true
      -- need at least one room in-between (for push-wall)
      if Quest.want_len < 3 then Quest.want_len = 3 end
    end
    table.insert(L.quests, Quest)
    return Quest
  end

  local gatling_maps =
  {
    [rand_irange(2,3)] = true,
    [rand_irange(4,6)] = true,
    [rand_irange(7,9)] = true,
  }

  for zzz,Level in ipairs(level_list) do

    -- weapons and keys

    if rand_odds(90 - 40 * ((Level.ep_along-1) % 3)) then
      add_quest(Level, "weapon", "machine_gun", 35)
    end

    if gatling_maps[Level.ep_along] then
      add_quest(Level, "weapon", "gatling_gun", 50)
    end

    local keys = rand_index_by_probs(Q2_KEY_NUM_PROBS[SETTINGS.size]) - 1

    if keys >= 1 then
      add_quest(Level, "key", "k_silver")
    end

    -- treasure

    local ITEM_PROBS = { small=33, regular=45, large=66 }

    for i = 1,sel(is_spear,4,6) do
      if rand_odds(ITEM_PROBS[SETTINGS.size]) then
        add_quest(Level, "item", "treasure", 50)
      end
    end

    if is_spear and rand_odds(60) then
      add_quest(Level, "item", "clip_25", 50)
    end

    -- bosses and exits

    if Level.boss_kind then
      local Q = add_quest(Level, "boss", Level.boss_kind)
      Q.give_key = "k_gold"

    elseif keys == 2 then
      add_quest(Level, "key", "k_gold")
    end

    if Level.secret_exit then
--FIXME  add_quest(Level, "exit", "secret")
    end

    add_quest(Level, "exit", "normal")
  end
end

function wolf3d_get_levels(episode)

  local level_list = {}

  local theme_probs = Q2_EPISODE_THEMES[episode]

  local boss_kind = Q2_EPISODE_BOSSES[episode]
  if SETTINGS.length ~= "full" then
    boss_kind = Q2_EPISODE_BOSSES[rand_irange(1,6)]
  end

  local secret_kind = "pacman"

  for map = 1,10 do
    local Level =
    {
      name = string.format("E%dL%d", episode, map),

      episode   = episode,
      ep_along  = map,
      ep_length = 10,

      theme_probs = theme_probs,
      sky_info = { color="blue", light=192 }, -- dummy

      boss_kind   = (map == 9)  and boss_kind,
      secret_kind = (map == 10) and secret_kind,

      quests = {},

      toughness_factor = sel(map==10, 1.1, 1 + (map-1) / 5),
    }

    if Q2_SECRET_EXITS[Level.name] then
      Level.secret_exit = true
    end

    table.insert(level_list, Level)
  end


  local function dump_levels()
    for idx,L in ipairs(level_list) do
      gui.printf("Wolf3d episode [%d] map [%d] : %s\n", episode, idx, L.name)
      show_quests(L.quests)
    end
  end

  wolfy_decide_quests(level_list)

--  dump_levels()

  return level_list
end


------------------------------------------------------------

OB_THEMES["q2_base"] =
{
  label = "Base",
  for_games = { quake2=1 },
}


----------------------------------------------------------------

function quake2_factory()

  return
  {
    quake_format = true,

    plan_size = 7,
    cell_size = 7,
    cell_min_size = 3,

    ERROR_TEX  = Q2_NO_TILE,
    ERROR_FLAT = 99, -- dummy
    SKY_TEX    = 77, -- dummy

    episodes = 6,
    level_func = wolf3d_get_levels,

    classes  = { "bj" },

    things     = Q2_THINGS,
    monsters   = Q2_MONSTERS,
    bosses     = Q2_BOSSES,
    mon_give   = Q2_MONSTER_GIVE,
    weapons    = Q2_WEAPONS,

    pickups = Q2_PICKUPS,
    pickup_stats = { "health", "bullet" },

    initial_model = Q2_INITIAL_MODEL,

    quests  = Q2_QUESTS,

    dm = {},

    combos    = Q2_COMBOS,
    exits     = Q2_EXITS,
    hallways  = nil,

    doors     = Q2_DOORS,
    key_doors = Q2_KEY_DOORS,

    rooms     = Q2_ROOMS,
    themes    = Q2_THEMES,

    misc_fabs = Q2_MISC_PREFABS,

    toughness_factor = 0.40,

    room_heights = { [128]=50 },
    space_range  = { 50, 90 },
    door_probs = { combo_diff=90, normal=20, out_diff=1 },
    window_probs = { out_diff=0, combo_diff=0, normal=0 },
  }
end


UNFINISHED["quake2"] =
{
  label = "Quake 2",

  format = "quake2",

  game_func = quake2_factory,

  caps =
  {
    -- TODO
  },
}

