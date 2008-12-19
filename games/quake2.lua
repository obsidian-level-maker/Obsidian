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

Q2_PALETTE =
{
    0,  0,  0,  15, 15, 15,  31, 31, 31,  47, 47, 47,  63, 63, 63,
   75, 75, 75,  91, 91, 91, 107,107,107, 123,123,123, 139,139,139,
  155,155,155, 171,171,171, 187,187,187, 203,203,203, 219,219,219,
  235,235,235,  99, 75, 35,  91, 67, 31,  83, 63, 31,  79, 59, 27,
   71, 55, 27,  63, 47, 23,  59, 43, 23,  51, 39, 19,  47, 35, 19,
   43, 31, 19,  39, 27, 15,  35, 23, 15,  27, 19, 11,  23, 15, 11,
   19, 15,  7,  15, 11,  7,  95, 95,111,  91, 91,103,  91, 83, 95,
   87, 79, 91,  83, 75, 83,  79, 71, 75,  71, 63, 67,  63, 59, 59,
   59, 55, 55,  51, 47, 47,  47, 43, 43,  39, 39, 39,  35, 35, 35,
   27, 27, 27,  23, 23, 23,  19, 19, 19, 143,119, 83, 123, 99, 67,
  115, 91, 59, 103, 79, 47, 207,151, 75, 167,123, 59, 139,103, 47,
  111, 83, 39, 235,159, 39, 203,139, 35, 175,119, 31, 147, 99, 27,
  119, 79, 23,  91, 59, 15,  63, 39, 11,  35, 23,  7, 167, 59, 43,
  159, 47, 35, 151, 43, 27, 139, 39, 19, 127, 31, 15, 115, 23, 11,
  103, 23,  7,  87, 19,  0,  75, 15,  0,  67, 15,  0,  59, 15,  0,
   51, 11,  0,  43, 11,  0,  35, 11,  0,  27,  7,  0,  19,  7,  0,
  123, 95, 75, 115, 87, 67, 107, 83, 63, 103, 79, 59,  95, 71, 55,
   87, 67, 51,  83, 63, 47,  75, 55, 43,  67, 51, 39,  63, 47, 35,
   55, 39, 27,  47, 35, 23,  39, 27, 19,  31, 23, 15,  23, 15, 11,
   15, 11,  7, 111, 59, 23,  95, 55, 23,  83, 47, 23,  67, 43, 23,
   55, 35, 19,  39, 27, 15,  27, 19, 11,  15, 11,  7, 179, 91, 79,
  191,123,111, 203,155,147, 215,187,183, 203,215,223, 179,199,211,
  159,183,195, 135,167,183, 115,151,167,  91,135,155,  71,119,139,
   47,103,127,  23, 83,111,  19, 75,103,  15, 67, 91,  11, 63, 83,
    7, 55, 75,   7, 47, 63,   7, 39, 51,   0, 31, 43,   0, 23, 31,
    0, 15, 19,   0,  7, 11,   0,  0,  0, 139, 87, 87, 131, 79, 79,
  123, 71, 71, 115, 67, 67, 107, 59, 59,  99, 51, 51,  91, 47, 47,
   87, 43, 43,  75, 35, 35,  63, 31, 31,  51, 27, 27,  43, 19, 19,
   31, 15, 15,  19, 11, 11,  11,  7,  7,   0,  0,  0, 151,159,123,
  143,151,115, 135,139,107, 127,131, 99, 119,123, 95, 115,115, 87,
  107,107, 79,  99, 99, 71,  91, 91, 67,  79, 79, 59,  67, 67, 51,
   55, 55, 43,  47, 47, 35,  35, 35, 27,  23, 23, 19,  15, 15, 11,
  159, 75, 63, 147, 67, 55, 139, 59, 47, 127, 55, 39, 119, 47, 35,
  107, 43, 27,  99, 35, 23,  87, 31, 19,  79, 27, 15,  67, 23, 11,
   55, 19, 11,  43, 15,  7,  31, 11,  7,  23,  7,  0,  11,  0,  0,
    0,  0,  0, 119,123,207, 111,115,195, 103,107,183,  99, 99,167,
   91, 91,155,  83, 87,143,  75, 79,127,  71, 71,115,  63, 63,103,
   55, 55, 87,  47, 47, 75,  39, 39, 63,  35, 31, 47,  27, 23, 35,
   19, 15, 23,  11,  7,  7, 155,171,123, 143,159,111, 135,151, 99,
  123,139, 87, 115,131, 75, 103,119, 67,  95,111, 59,  87,103, 51,
   75, 91, 39,  63, 79, 27,  55, 67, 19,  47, 59, 11,  35, 47,  7,
   27, 35,  0,  19, 23,  0,  11, 15,  0,   0,255,  0,  35,231, 15,
   63,211, 27,  83,187, 39,  95,167, 47,  95,143, 51,  95,123, 51,
  255,255,255, 255,255,211, 255,255,167, 255,255,127, 255,255, 83,
  255,255, 39, 255,235, 31, 255,215, 23, 255,191, 15, 255,171,  7,
  255,147,  0, 239,127,  0, 227,107,  0, 211, 87,  0, 199, 71,  0,
  183, 59,  0, 171, 43,  0, 155, 31,  0, 143, 23,  0, 127, 15,  0,
  115,  7,  0,  95,  0,  0,  71,  0,  0,  47,  0,  0,  27,  0,  0,
  239,  0,  0,  55, 55,255, 255,  0,  0,   0,  0,255,  43, 43, 35,
   27, 27, 23,  19, 19, 15, 235,151,127, 195,115, 83, 159, 87, 51,
  123, 63, 27, 235,211,199, 199,171,155, 167,139,119, 135,107, 87,
  159, 91, 83                                         
}


----------------------------------------------------------------

Q2_COMBOS =
{
  TECH_BASE =
  {
    wall  = "e1u1/wslt1_1",
    floor = "e1u1/wtroof4_3",
    ceil  = "e1u1/floor3_3",
  },

  TECH_GROUND =
  {
    outdoor = true,

    wall  = "e1u1/rocks16_2",
    ceil  = "e1u1/grass1_4",
    floor = "e1u1/grass1_4",
  },
}

Q2_EXITS =
{
}


Q2_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

Q2_MISC_PREFABS =
{
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
  TECH =
  {
    building =
    {
      TECH_BASE=50,
    },

    ground =
    {
      TECH_GROUND=50,
    },

    hallway =
    {
      -- FIXME
    },

    exit =
    {
      -- FIXME
    },

    scenery =
    {
      -- FIXME
    },
  }, -- TECH
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


------------------------------------------------------------

OB_THEMES["q2_base"] =
{
  label = "Base",
  for_games = { quake2=1 },
}


----------------------------------------------------------------

function Quake2_get_levels()
  local list = {}

  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("u%dm%d", episode, map),

        ep_along = map / MAP_NUM,

        theme = "BASE",

        toughness_factor = sel(map==9, 1.2, 1 + (map-1) / 7),
      }

      table.insert(list, LEV)
    end -- for map

  end -- for episode

  return list
end

function Quake2_describe_levels()

  -- FIXME handle themes properly !!!

  local desc_list = Naming_generate("TECH", #GAME.all_levels, PARAMS.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    LEV.description = desc_list[index]
  end
end


function Quake2_setup()

  GAME.classes = { "marine" }
  GAME.dm = {}

  GAME.pickup_stats = { "health", "bullet" }
  GAME.initial_model = Q2_INITIAL_MODEL

  Game_merge_tab("things",   Q2_THINGS)
  Game_merge_tab("monsters", Q2_MONSTERS)
  Game_merge_tab("bosses",   Q2_BOSSES)
  Game_merge_tab("mon_give", Q2_MONSTER_GIVE)
  Game_merge_tab("weapons",  Q2_WEAPONS)

  Game_merge_tab("pickups", Q2_PICKUPS)
  Game_merge_tab("quests",  Q2_QUESTS)

  Game_merge_tab("combos", Q2_COMBOS)
  Game_merge_tab("exits",  Q2_EXITS)

  Game_merge_tab("key_doors", Q2_KEY_DOORS)

  Game_merge_tab("rooms",  Q2_ROOMS)
  Game_merge_tab("themes", Q2_THEMES)

  Game_merge_tab("misc_fabs", Q2_MISC_PREFABS)

end


UNFINISHED["quake2"] =
{
  label = "Quake 2",

  format = "quake2",

  setup_func = Quake2_setup,

  caps =
  {
    -- TODO

    -- dunno if needed by Quake II, but it doesn't hurt
    center_map = true,
  },

  params =
  {
    seed_size = 240,

    sky_tex  = "e1u1/sky1",
    sky_flat = "e1u1/sky1",

    -- the name buffer in Quake II is huge, but this value
    -- reflects the on-screen space (in the computer panel)
    max_level_desc = 24,

    palette_mons = 4,
  },

  hooks =
  {
    get_levels = Quake2_get_levels,
    describe_levels = Quake1_describe_levels,
  },
}

