----------------------------------------------------------------
-- GAME DEF : Quake 1
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


Q1_THINGS =
{
  -- players
  player1 = { id="info_player_start", kind="other", r=16,h=56 },
  player2 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player3 = { id="info_player_coop",  kind="other", r=16,h=56 },
  player4 = { id="info_player_coop",  kind="other", r=16,h=56 },

  dm_player = { id="info_player_deathmatch", kind="other", r=16,h=56 },

  -- enemies
  dog      = { id="monster_dog",      kind="monster", r=32, h=80, },
  grunt    = { id="monster_army",     kind="monster", r=32, h=80, },
  enforcer = { id="monster_enforcer", kind="monster", r=32, h=80, },
  fiend    = { id="monster_demon1",   kind="monster", r=32, h=80, },

  knight   = { id="monster_knight",   kind="monster", r=32, h=80, },
  knight2  = { id="monster_hell_knight", kind="monster", r=32, h=80, },
  ogre     = { id="monster_ogre",     kind="monster", r=32, h=80, },
  rotfish  = { id="monster_fish",     kind="monster", r=32, h=80, },
  scragg   = { id="monster_wizard",   kind="monster", r=32, h=80, },

  shambler = { id="monster_shambler", kind="monster", r=32, h=80, },
  spawn    = { id="monster_tarbaby",  kind="monster", r=32, h=80, },
  vore     = { id="monster_shalrath", kind="monster", r=32, h=80, },
  zombie   = { id="monster_zombie",   kind="monster", r=32, h=80, },

  -- bosses
  chthon   = { id="monster_boss",   kind="monster", r=32, h=80, },
  shub     = { id="monster_oldone", kind="monster", r=32, h=80, },

  -- pickups
  k_silver = { id="item_key1", kind="pickup", r=30, h=30, pass=true },
  k_gold   = { id="item_key2", kind="pickup", r=30, h=30, pass=true },

  ssg      = { id="weapon_supershotgun",    kind="pickup", r=30, h=30, pass=true },
  grenade  = { id="weapon_grenadelauncher", kind="pickup", r=30, h=30, pass=true },
  rocket   = { id="weapon_rocketlauncher",  kind="pickup", r=30, h=30, pass=true },
  nailgun  = { id="weapon_nailgun",         kind="pickup", r=30, h=30, pass=true },
  nailgun2 = { id="weapon_supernailgun",    kind="pickup", r=30, h=30, pass=true },
  zapper   = { id="weapon_lightning",       kind="pickup", r=30, h=30, pass=true },

  health       = { id="item_health",   kind="pickup", r=30, h=30, pass=true },
  green_armor  = { id="item_armor1",   kind="pickup", r=30, h=30, pass=true },
  yellow_armor = { id="item_armor2",   kind="pickup", r=30, h=30, pass=true },
  red_armor    = { id="item_armorInv", kind="pickup", r=30, h=30, pass=true },

  -- TODO: health and ammo quantity is controlled by 'spawnflags'

  cell_box   = { id="item_cells",   kind="pickup", r=30, h=30, pass=true },
  shell_box  = { id="item_shells",  kind="pickup", r=30, h=30, pass=true },
  nail_box   = { id="item_spikes",  kind="pickup", r=30, h=30, pass=true },
  rocket_box = { id="item_rockets", kind="pickup", r=30, h=30, pass=true },

  suit   = { id="item_artifact_envirosuit",      kind="pickup", r=30, h=30, pass=true },
  invis  = { id="item_artifact_invisibility",    kind="pickup", r=30, h=30, pass=true },
  invuln = { id="item_artifact_invulnerability", kind="pickup", r=30, h=30, pass=true },
  quad   = { id="item_artifact_super_damage",    kind="pickup", r=30, h=30, pass=true },

  -- scenery
  explode_sm = { id="misc_explobox2", kind="scenery", r=30, h=80, },
  explode_bg = { id="misc_explobox2", kind="scenery", r=30, h=40, },

  torch      = { id="light_torch_small_walltorch", kind="scenery", r=30, h=60, pass=true },

  -- ambient sounds
  snd_computer = { id="ambient_comp_hum",  kind="scenery", r=30, h=30, pass=true },
  snd_drip     = { id="ambient_drip",      kind="scenery", r=30, h=30, pass=true },
  snd_drone    = { id="ambient_drone",     kind="scenery", r=30, h=30, pass=true },
  snd_wind     = { id="ambient_suck_wind", kind="scenery", r=30, h=30, pass=true },
  snd_swamp1   = { id="ambient_swamp1",    kind="scenery", r=30, h=30, pass=true },
  snd_swamp2   = { id="ambient_swamp2",    kind="scenery", r=30, h=30, pass=true },

  -- special

}

----------------------------------------------------------------

Q1_COMBOS =
{
  BASE =
  {
    mat_pri = 5,
    wall = 12, void = 12, floor=0, ceil=0,
    decorate = 10, door_side = 23,

    theme_probs = { BUNKER=120, CELLS=25  },
  },

}

Q1_EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


Q1_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

Q1_MISC_PREFABS =
{
  elevator =
  {
    prefab = "WOLF_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=21, front=14, }
  },
}



---- QUEST STUFF ----------------

Q1_QUESTS =
{
  key = { k_silver=60, k_gold=30, },

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


Q1_ROOMS =
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

Q1_THEMES =
{
  BASE =
  {
  },
}


----------------------------------------------------------------

Q1_MONSTERS =
{
  dog     = { prob=20, hp=1,   dm=5,  fp=1.0, melee=true, },
  guard   = { prob=60, hp=25,  dm=10, fp=1.0, hitscan=true, cage_fallback=10 },
  officer = { prob=30, hp=50,  dm=20, fp=1.7, hitscan=true, },
  mutant  = { prob=10, hp=55,  dm=35, fp=1.9, hitscan=true, },
  ss_dude = { prob=60, hp=100, dm=30, fp=1.4, hitscan=true, },
}

Q1_BOSSES =
{
}

Q1_MONSTER_GIVE =
{
}

Q1_WEAPONS =
{
  knife       = { fp=0, melee=true,           rate=3.0, dm= 7, freq= 2, held=true },
  pistol      = { fp=1, ammo="bullet", per=1, rate=3.0, dm=17, freq=10, held=true },

  machine_gun = { fp=2, ammo="bullet", give=4, per=1, rate=8.0,  dm=17, freq=30, },
  gatling_gun = { fp=3, ammo="bullet", give=6, per=1, rate=16.0, dm=17, freq=90, },

  -- Note: machine_gun actually gives _6_ bullets.
  -- However: we don't model the fact that the SS_DUDE only
  -- drops a 4-bullet clip if you already have the machine gun.
  -- Therefore: this hack should maintain ammo balance.
}

Q1_PICKUPS =
{
  first_aid = { stat="health", give=25 },
  good_food = { stat="health", give=10 },
  dog_food  = { stat="health", give=4  },

  -- NOTE: no "gibs" here, they are fairly insignificant

  clip_8  =   { stat="bullet", give=8 },
}

Q1_INITIAL_MODEL =
{
  player =
  {
    health=100, armor=0, bullet=8,
    knife=true, pistol=true
  }
}


------------------------------------------------------------

Q1_EPISODE_THEMES =
{
  { BASE=7, },
  { BASE=6, },
  { BASE=6, },
  { BASE=6, },
}

Q1_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}

Q1_QUEST_LEN_PROBS =
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

    local len_probs = non_nil(Q1_QUEST_LEN_PROBS[kind])
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

    local keys = rand_index_by_probs(Q1_KEY_NUM_PROBS[SETTINGS.size]) - 1

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

  local theme_probs = Q1_EPISODE_THEMES[episode]

  local boss_kind = Q1_EPISODE_BOSSES[episode]
  if SETTINGS.length ~= "full" then
    boss_kind = Q1_EPISODE_BOSSES[rand_irange(1,6)]
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

    if Q1_SECRET_EXITS[Level.name] then
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

OB_THEMES["q1_base"] =
{
  label = "Base",
  for_games = { quake1=1 },
}


----------------------------------------------------------------

function quake1_factory()

  return
  {
    quake_format = true,

    plan_size = 7,
    cell_size = 7,
    cell_min_size = 3,

    caps = { blocky_items=true, blocky_doors=true,
             tiered_skills=true, elevator_exits=true,
             four_dirs=true, sealed_start=true,
           },

    ERROR_TEX  = Q1_NO_TILE,
    ERROR_FLAT = 99, -- dummy
    SKY_TEX    = 77, -- dummy

    episodes = 6,
    level_func = wolf3d_get_levels,

    classes  = { "bj" },

    things     = Q1_THINGS,
    monsters   = Q1_MONSTERS,
    bosses     = Q1_BOSSES,
    mon_give   = Q1_MONSTER_GIVE,
    weapons    = Q1_WEAPONS,

    pickups = Q1_PICKUPS,
    pickup_stats = { "health", "bullet" },

    initial_model = Q1_INITIAL_MODEL,

    quests  = Q1_QUESTS,

    dm = {},

    combos    = Q1_COMBOS,
    exits     = Q1_EXITS,
    hallways  = nil,

    doors     = Q1_DOORS,
    key_doors = Q1_KEY_DOORS,

    rooms     = Q1_ROOMS,
    themes    = Q1_THEMES,

    misc_fabs = Q1_MISC_PREFABS,

    toughness_factor = 0.40,

    room_heights = { [128]=50 },
    space_range  = { 50, 90 },
    door_probs = { combo_diff=90, normal=20, out_diff=1 },
    window_probs = { out_diff=0, combo_diff=0, normal=0 },
  }
end


OB_GAMES["quake1"] =
{
  label = "Quake 1",

  format = "quake1",

  game_func = quake1_factory,
}

