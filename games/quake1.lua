----------------------------------------------------------------
-- GAME DEF : Quake I
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006-2009 Andrew Apted
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


QUAKE1_THINGS =
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
  hell_knt = { id="monster_hell_knight", kind="monster", r=32, h=80, },
  ogre     = { id="monster_ogre",     kind="monster", r=32, h=80, },
  fish     = { id="monster_fish",     kind="monster", r=32, h=80, },
  scrag    = { id="monster_wizard",   kind="monster", r=32, h=80, },

  shambler = { id="monster_shambler", kind="monster", r=32, h=80, },
  spawn    = { id="monster_tarbaby",  kind="monster", r=32, h=80, },
  vore     = { id="monster_shalrath", kind="monster", r=32, h=80, },
  zombie   = { id="monster_zombie",   kind="monster", r=32, h=80, },

  -- bosses
  Chthon   = { id="monster_boss",   kind="monster", r=32, h=80, },
  Shub     = { id="monster_oldone", kind="monster", r=32, h=80, },

  -- pickups
  k_silver = { id="item_key1", kind="pickup", r=30, h=30, pass=true },
  k_gold   = { id="item_key2", kind="pickup", r=30, h=30, pass=true },

  ssg      = { id="weapon_supershotgun",    kind="pickup", r=30, h=30, pass=true },
  grenade  = { id="weapon_grenadelauncher", kind="pickup", r=30, h=30, pass=true },
  rocket   = { id="weapon_rocketlauncher",  kind="pickup", r=30, h=30, pass=true },
  nailgun  = { id="weapon_nailgun",         kind="pickup", r=30, h=30, pass=true },
  nailgun2 = { id="weapon_supernailgun",    kind="pickup", r=30, h=30, pass=true },
  zapper   = { id="weapon_lightning",       kind="pickup", r=30, h=30, pass=true },

  heal_25 = { id="item_health", spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  heal_10 = { id="item_health", spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  mega    = { id="item_health", spawnflags=2, kind="pickup", r=30, h=30, pass=true },

  green_armor  = { id="item_armor1",   kind="pickup", r=30, h=30, pass=true },
  yellow_armor = { id="item_armor2",   kind="pickup", r=30, h=30, pass=true },
  red_armor    = { id="item_armorInv", kind="pickup", r=30, h=30, pass=true },

  shell_20  = { id="item_shells",  spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  shell_40  = { id="item_shells",  spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  nail_25   = { id="item_spikes",  spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  nail_50   = { id="item_spikes",  spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  rocket_5  = { id="item_rockets", spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  rocket_10 = { id="item_rockets", spawnflags=1, kind="pickup", r=30, h=30, pass=true },
  cell_6    = { id="item_cells",   spawnflags=0, kind="pickup", r=30, h=30, pass=true },
  cell_12   = { id="item_cells",   spawnflags=1, kind="pickup", r=30, h=30, pass=true },

  suit   = { id="item_artifact_envirosuit",      kind="pickup", r=30, h=30, pass=true },
  invis  = { id="item_artifact_invisibility",    kind="pickup", r=30, h=30, pass=true },
  invuln = { id="item_artifact_invulnerability", kind="pickup", r=30, h=30, pass=true },
  quad   = { id="item_artifact_super_damage",    kind="pickup", r=30, h=30, pass=true },

  -- scenery
  explode_sm = { id="misc_explobox2", kind="scenery", r=30, h=80, },
  explode_bg = { id="misc_explobox2", kind="scenery", r=30, h=40, },

  crucified  = { id="monster_zombie", spawnflags=1, kind="scenery", r=32, h=64, },
  torch      = { id="light_torch_small_walltorch",  kind="scenery", r=30, h=60, pass=true },

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

QUAKE1_PALETTE =
{
    0,  0,  0,  15, 15, 15,  31, 31, 31,  47, 47, 47,  63, 63, 63,
   75, 75, 75,  91, 91, 91, 107,107,107, 123,123,123, 139,139,139,
  155,155,155, 171,171,171, 187,187,187, 203,203,203, 219,219,219,
  235,235,235,  15, 11,  7,  23, 15, 11,  31, 23, 11,  39, 27, 15,
   47, 35, 19,  55, 43, 23,  63, 47, 23,  75, 55, 27,  83, 59, 27,
   91, 67, 31,  99, 75, 31, 107, 83, 31, 115, 87, 31, 123, 95, 35,
  131,103, 35, 143,111, 35,  11, 11, 15,  19, 19, 27,  27, 27, 39,
   39, 39, 51,  47, 47, 63,  55, 55, 75,  63, 63, 87,  71, 71,103,
   79, 79,115,  91, 91,127,  99, 99,139, 107,107,151, 115,115,163,
  123,123,175, 131,131,187, 139,139,203,   0,  0,  0,   7,  7,  0,
   11, 11,  0,  19, 19,  0,  27, 27,  0,  35, 35,  0,  43, 43,  7,
   47, 47,  7,  55, 55,  7,  63, 63,  7,  71, 71,  7,  75, 75, 11,
   83, 83, 11,  91, 91, 11,  99, 99, 11, 107,107, 15,   7,  0,  0,
   15,  0,  0,  23,  0,  0,  31,  0,  0,  39,  0,  0,  47,  0,  0,
   55,  0,  0,  63,  0,  0,  71,  0,  0,  79,  0,  0,  87,  0,  0,
   95,  0,  0, 103,  0,  0, 111,  0,  0, 119,  0,  0, 127,  0,  0,
   19, 19,  0,  27, 27,  0,  35, 35,  0,  47, 43,  0,  55, 47,  0,
   67, 55,  0,  75, 59,  7,  87, 67,  7,  95, 71,  7, 107, 75, 11,
  119, 83, 15, 131, 87, 19, 139, 91, 19, 151, 95, 27, 163, 99, 31,
  175,103, 35,  35, 19,  7,  47, 23, 11,  59, 31, 15,  75, 35, 19,
   87, 43, 23,  99, 47, 31, 115, 55, 35, 127, 59, 43, 143, 67, 51,
  159, 79, 51, 175, 99, 47, 191,119, 47, 207,143, 43, 223,171, 39,
  239,203, 31, 255,243, 27,  11,  7,  0,  27, 19,  0,  43, 35, 15,
   55, 43, 19,  71, 51, 27,  83, 55, 35,  99, 63, 43, 111, 71, 51,
  127, 83, 63, 139, 95, 71, 155,107, 83, 167,123, 95, 183,135,107,
  195,147,123, 211,163,139, 227,179,151, 171,139,163, 159,127,151,
  147,115,135, 139,103,123, 127, 91,111, 119, 83, 99, 107, 75, 87,
   95, 63, 75,  87, 55, 67,  75, 47, 55,  67, 39, 47,  55, 31, 35,
   43, 23, 27,  35, 19, 19,  23, 11, 11,  15,  7,  7, 187,115,159,
  175,107,143, 163, 95,131, 151, 87,119, 139, 79,107, 127, 75, 95,
  115, 67, 83, 107, 59, 75,  95, 51, 63,  83, 43, 55,  71, 35, 43,
   59, 31, 35,  47, 23, 27,  35, 19, 19,  23, 11, 11,  15,  7,  7,
  219,195,187, 203,179,167, 191,163,155, 175,151,139, 163,135,123,
  151,123,111, 135,111, 95, 123, 99, 83, 107, 87, 71,  95, 75, 59,
   83, 63, 51,  67, 51, 39,  55, 43, 31,  39, 31, 23,  27, 19, 15,
   15, 11,  7, 111,131,123, 103,123,111,  95,115,103,  87,107, 95,
   79, 99, 87,  71, 91, 79,  63, 83, 71,  55, 75, 63,  47, 67, 55,
   43, 59, 47,  35, 51, 39,  31, 43, 31,  23, 35, 23,  15, 27, 19,
   11, 19, 11,   7, 11,  7, 255,243, 27, 239,223, 23, 219,203, 19,
  203,183, 15, 187,167, 15, 171,151, 11, 155,131,  7, 139,115,  7,
  123, 99,  7, 107, 83,  0,  91, 71,  0,  75, 55,  0,  59, 43,  0,
   43, 31,  0,  27, 15,  0,  11,  7,  0,   0,  0,255,  11, 11,239,
   19, 19,223,  27, 27,207,  35, 35,191,  43, 43,175,  47, 47,159,
   47, 47,143,  47, 47,127,  47, 47,111,  47, 47, 95,  43, 43, 79,
   35, 35, 63,  27, 27, 47,  19, 19, 31,  11, 11, 15,  43,  0,  0,
   59,  0,  0,  75,  7,  0,  95,  7,  0, 111, 15,  0, 127, 23,  7,
  147, 31,  7, 163, 39, 11, 183, 51, 15, 195, 75, 27, 207, 99, 43,
  219,127, 59, 227,151, 79, 231,171, 95, 239,191,119, 247,211,139,
  167,123, 59, 183,155, 55, 199,195, 55, 231,227, 87, 127,191,255,
  171,231,255, 215,255,255, 103,  0,  0, 139,  0,  0, 179,  0,  0,
  215,  0,  0, 255,  0,  0, 255,243,147, 255,247,199, 255,255,255,
  159, 91, 83
}


----------------------------------------------------------------

QUAKE1_COMBOS =
{
  TECH_BASE =
  {
    theme_probs = { TECH=80 },

    wall  = "tech05_2",
    floor = "metflor2_1",
    ceil  = "tlight09",
  },

  TECH_GROUND =
  {
    theme_probs = { TECH=80 },
    outdoor = true,

    wall  = "ground1_6",
    floor = "ground1_6",
    ceil  = "ground1_6",
  }
}

QUAKE1_EXITS =
{
  ELEVATOR =  -- FIXME: not needed, remove
  {
    mat_pri = 0,
    wall = 21, void = 21, floor=0, ceil=0,
  },
}


QUAKE1_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

QUAKE1_MISC_PREFABS =
{
  elevator =
  {
    prefab = "WOLF_ELEVATOR",
    add_mode = "extend",

    skin = { elevator=21, front=14, }
  },
}



---- QUEST STUFF ----------------

QUAKE1_QUESTS =
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


QUAKE1_ROOMS =
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

QUAKE1_THEMES =
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

QUAKE1_MONSTERS =
{
  dog =
  {
    prob=10, guard_prob=1, trap_prob=1,
    health=25, damage=5, attack="melee",
  },

  fish =
  {
    health=25, damage=3, attack="melee",
  },

  grunt =
  {
    prob=80, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=14, attack="hitscan",
    give={ {ammo="shell",count=5} },
  },

  enforcer =
  {
    prob=40, guard_prob=11, trap_prob=11, cage_prob=11,
    health=80, damage=18, attack="missile",
    give={ {ammo="cell",count=5} },
  },

  zombie =
  {
    prob=10, guard_prob=1, cage_prob=11,
    health=60, damage=8,  attack="melee",
  },

  scrag =
  {
    prob=60, guard_prob=11, trap_prob=11, cage_prob=11,
    health=80, damage=18, attack="missile",
  },

  spawn =
  {
    prob=10, trap_prob=11,
    health=80, damage=10, attack="melee",
  },

  knight =
  {
    prob=60, guard_prob=1, trap_prob=11, cage_prob=11,
    health=75, damage=9,  attack="melee",
  },

  hell_knt =
  {
    prob=30, guard_prob=31, trap_prob=21, cage_prob=11,
    health=250, damage=30, attack="missile",
  },

  ogre =
  {
    prob=40, guard_prob=21, trap_prob=31, cage_prob=11,
    health=200, damage=15, attack="missile",
    give={ {ammo="rocket",count=2} },
  },

  fiend =
  {
    prob=10, guard_prob=51, trap_prob=31,
    health=300, damage=20, attack="melee",
  },

  vore =
  {
    prob=10, guard_prob=31, trap_prob=31, cage_prob=11,
    health=400, damage=25, attack="missile",
  },

  shambler =
  {
    prob=10, guard_prob=31, trap_prob=21, cage_prob=11,
    health=600, damage=30, attack="hitscan",
    immunity={ rocket=0.5, grenade=0.5 },
  },
}


QUAKE1_WEAPONS =
{
  axe =
  {
    rate=2.0, damage=20, attack="melee",
  },

  pistol =
  {
    pref=10,
    rate=2.0, damage=20, attack="hitscan",
    ammo="shell", per=1,
  },

  ssg =
  {
    pref=50, add_prob=40,
    rate=1.4, damage=45, attack="hitscan", splash={0,3},
    ammo="shell", per=2,
    give={ {ammo="shell",count=5} },
  },

  grenade =
  {
    pref=10, add_prob=15,
    rate=1.5, damage= 5, attack="missile", splash={60,15,3},
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=5} },
  },

  rocket =
  {
    pref=30, add_prob=10,
    rate=1.2, damage=80, attack="missile", splash={0,20,6,2},
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=5} },
  },

  nailgun =
  {
    pref=50, add_prob=30,
    rate=5.0, damage=8, attack="missile",
    ammo="nail", per=1,
    give={ {ammo="nail",count=30} },
  },

  nailgun2 =
  {
    pref=80, add_prob=10,
    rate=5.0, damage=18, attack="missile",
    ammo="nail", per=2,
    give={ {ammo="nail",count=30} },
  },

  zapper =
  {
    pref=30, add_prob=2,
    rate=10, damage=30, attack="hitscan", splash={0,4},
    ammo="cell", per=1,
    give={ {ammo="cell",count=15} },
  },


  -- Notes:
  --
  -- Grenade damage (for a direct hit) is really zero, all of
  -- the actual damage comes from splash.
  --
  -- Rocket splash damage does not hurt the monster that was
  -- directly hit by the rocket.
  --
  -- Lightning bolt damage is done by three hitscan attacks
  -- over the same range (16 units apart).  As I read it, you
  -- can only hit two monsters if (a) the hitscan passes by
  -- the first one, or (b) the first one is killed.
}


QUAKE1_PICKUPS =
{
  -- HEALTH --

  heal_10 =
  {
    prob=20, cluster={ 1,2 },
    give={ {health=8} },   -- real amount is 5-10 units
  },

  heal_25 =
  {
    prob=50,
    give={ {health=25} },
  },

  mega =
  {
    prob=3, big_item=true,
    give={ {health=70} },  -- gives 100 but it rots aways
  },

  -- ARMOR --

  green_armor =
  {
    prob=9,
    give={ {health=30} },
  },

  yellow_armor =
  {
    prob=3,
    give={ {health=90} },
  },

  red_armor =
  {
    prob=1,
    give={ {health=160} },
  },

  -- AMMO --

  shell_20 =
  {
    give={ {ammo="shell",count=20} },
  },

  shell_40 =
  {
    give={ {ammo="shell",count=40} },
  },

  nail_25 =
  {
    give={ {ammo="nail",count=25} },
  },

  nail_50 =
  {
    give={ {ammo="nail",count=50} },
  },

  rocket_5 =
  {
    give={ {ammo="rocket",count=5} },
  },

  rocket_10 =
  {
    give={ {ammo="rocket",count=10} },
  },

  cell_6 =
  {
    give={ {ammo="cell",count=6} },
  },

  cell_12 =
  {
    give={ {ammo="cell",count=12} },
  },
}


QUAKE1_PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0, shell=0, nail=0, rocket=0, cell=0 },
    weapons = { pistol=1, axe=1 },
  }
}


------------------------------------------------------------

QUAKE1_EPISODE_THEMES =
{
  { BASE=7, },
  { BASE=6, },
  { BASE=6, },
  { BASE=6, },
}

QUAKE1_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
}



----------------------------------------------------------------

function Quake1_get_levels()
  local list = {}

  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("e%dm%d", episode, map),

        ep_along = map / MAP_NUM,

        theme = "BASE",

        toughness_factor = sel(map==9, 1.2, 1 + (map-1) / 7),
      }

      table.insert(list, LEV)
    end -- for map

  end -- for episode

  return list
end

function Quake1_describe_levels()

  -- FIXME handle themes properly !!!

  local desc_list = Naming_generate("GOTHIC", #GAME.all_levels, PARAMS.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    LEV.description = desc_list[index]
  end
end

function Quake1_setup()

  GAME.player_model = QUAKE1_PLAYER_MODEL

  GAME.dm = {}

  Game_merge_tab("things",   QUAKE1_THINGS)
  Game_merge_tab("monsters", QUAKE1_MONSTERS)
  Game_merge_tab("weapons",  QUAKE1_WEAPONS)
  Game_merge_tab("pickups",  QUAKE1_PICKUPS)

  Game_merge_tab("quests",  QUAKE1_QUESTS)

  Game_merge_tab("combos", QUAKE1_COMBOS)
  Game_merge_tab("exits",  QUAKE1_EXITS)
--  hallways  nil,

--  Game_merge_tab("doors", QUAKE1_DOORS)
  Game_merge_tab("key_doors", QUAKE1_KEY_DOORS)

  Game_merge_tab("rooms",  QUAKE1_ROOMS)
  Game_merge_tab("themes", QUAKE1_THEMES)

  Game_merge_tab("misc_fabs", QUAKE1_MISC_PREFABS)

  GAME.toughness_factor = 0.40

  GAME.room_heights = { [128]=50 }
  GAME.space_range  = { 50, 90 }
  GAME.door_probs = { combo_diff=90, normal=20, out_diff=1 }
  GAME.window_probs = { out_diff=0, combo_diff=0, normal=0 }
end


UNFINISHED["quake1"] =
{
  label = "Quake 1",

  format = "quake1",

  setup_func = Quake1_setup,

  caps =
  {
    -- TODO

    -- need to place center of map around (0,0) since the quake
    -- engine needs all coords to lie between -4000 and +4000.
    center_map = true,
  },

  params =
  {
    seed_size = 240,

    sky_tex  = "sky4",
    sky_flat = "sky4",

    -- the name buffer in Quake can fit 39 characters, however
    -- the on-screen space for the name is much less.
    max_level_desc = 20,

    palette_mons = 4,

  },

  hooks =
  {
    get_levels = Quake1_get_levels,
    describe_levels = Quake1_describe_levels,
  },
}


OB_THEMES["q1_base"] =
{
  ref = "TECH",
  label = "Base",

  for_games = { quake1=1 },
}

