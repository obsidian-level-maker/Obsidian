----------------------------------------------------------------
-- GAME DEF : Quake I
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
  h_knight = { id="monster_hell_knight", kind="monster", r=32, h=80, },
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
  dog      = { prob=10, hp=25,  dm=5,  melee=true },
  fish     = { prob= 0, hp=25,  dm=3,  melee=true },
  grunt    = { prob=80, hp=30,  dm=14, hitscan=true },
  enforcer = { prob=40, hp=80,  dm=18 },

  zombie   = { prob=10, hp=60,  dm=8,  melee=true },
  scrag    = { prob=60, hp=80,  dm=18 },
  spawn    = { prob=10, hp=80,  dm=10, melee=true },
  knight   = { prob=60, hp=75,  dm=9,  melee=true },

  h_knight = { prob=30, hp=250, dm=30 },
  ogre     = { prob=40, hp=200, dm=15 },
  fiend    = { prob=10, hp=300, dm=20, melee=true },
  vore     = { prob=10, hp=400, dm=25 },
  shambler = { prob=10, hp=600, dm=30, hitscan=true, immunity={ rocket=0.5, grenade=0.5 } },
}

Q1_BOSSES =
{
}

Q1_MONSTER_GIVE =
{
}

Q1_WEAPONS =
{
  axe      = { rate=2.0, dm=20, pref= 1, melee=true,           held=true },
  pistol   = { rate=2.0, dm=20, pref=10, ammo="shell",  per=1, held=true },
  ssg      = { rate=1.4, dm=45, pref=50, ammo="shell",  per=2, splash={0,3} },
  grenade  = { rate=1.5, dm= 5, pref=10, ammo="rocket", per=1, splash={60,15,3} },
  rocket   = { rate=1.2, dm=80, pref=30, ammo="rocket", per=1, splash={0,20,6,2} },
  nailgun  = { rate=5.0, dm= 8, pref=50, ammo="nail",   per=1 },
  nailgun2 = { rate=5.0, dm=18, pref=80, ammo="nail",   per=2 },
  zapper   = { rate=10,  dm=30, pref=30, ammo="cell",   per=1, splash={0,4} },

  -- Notes:
  --
  -- Grenade damage (for a direct hit) is really zero, and all
  -- of the actual damage comes from splash.
  --
  -- Rocket splash damage does not hurt the monster that was
  -- directly hit by the rocket.
  --
  -- Lightning bolt damage is done by three hitscan attacks
  -- over the same range (16 units apart).  As I read it, you
  -- can only hit two monsters if (a) the hitscan passes by
  -- the first one, or (b) the first one is killed.
}

Q1_PICKUPS =
{
  first_aid = { stat="health", give=25 },
  good_food = { stat="health", give=10 },

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



----------------------------------------------------------------

function Quake1_get_levels()
  local list = {}

  local EP_NUM  = sel(OB_CONFIG.length == "full", 4, 1)
  local MAP_NUM = sel(OB_CONFIG.length == "single", 1, 7)

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name = string.format("e%dm%d", episode, map),

        ep_along = (map - 1) / MAP_NUM,

        theme = "BASE",

        toughness_factor = sel(map==9, 1.2, 1 + (map-1) / 7),
      }

      table.insert(list, LEV)
    end -- for map

  end -- for episode

  return list
end

function Quake1_setup()

  GAME.classes = { "marine" }
  GAME.dm = {}

  GAME.pickup_stats = { "health", "bullet" }
  GAME.initial_model = Q1_INITIAL_MODEL

  Game_merge_tab("things",   Q1_THINGS)
  Game_merge_tab("monsters", Q1_MONSTERS)
  Game_merge_tab("bosses",   Q1_BOSSES)
  Game_merge_tab("mon_give", Q1_MONSTER_GIVE)
  Game_merge_tab("weapons",  Q1_WEAPONS)

  Game_merge_tab("pickups", Q1_PICKUPS)
  Game_merge_tab("quests",  Q1_QUESTS)

  Game_merge_tab("combos", Q1_COMBOS)
  Game_merge_tab("exits",  Q1_EXITS)
--  hallways  nil,

--  Game_merge_tab("doors", Q1_DOORS)
  Game_merge_tab("key_doors", Q1_KEY_DOORS)

  Game_merge_tab("rooms",  Q1_ROOMS)
  Game_merge_tab("themes", Q1_THEMES)

  Game_merge_tab("misc_fabs", Q1_MISC_PREFABS)

  GAME.toughness_factor = 0.40

  GAME.room_heights = { [128]=50 }
  GAME.space_range  = { 50, 90 }
  GAME.door_probs = { combo_diff=90, normal=20, out_diff=1 }
  GAME.window_probs = { out_diff=0, combo_diff=0, normal=0 }
end


OB_GAMES["quake1"] =
{
  label = "Quake 1",

  format = "quake1",

  setup_func = Quake1_setup,

  caps =
  {
    -- TODO
  },

  params =
  {
    seed_size = 240,

    sky_tex  = "sky4",
    sky_flat = "sky4",

    max_level_desc = 39,

    palette_mons = 4,

  },

  hooks =
  {
    get_levels = Quake1_get_levels,
  },
}


OB_THEMES["q1_base"] =
{
  ref = "BASE",
  label = "Base",

  for_games = { quake1=1 },
}

