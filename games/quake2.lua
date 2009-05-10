----------------------------------------------------------------
-- GAME DEF : Quake II
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

QUAKE2_THINGS =
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
  launcher = { id="weapon_rocketlauncher",  kind="pickup", r=16, h=32, pass=true },
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
  -- FIXME: varieties of insane_dude!

  -- special

  -- TODO
}


----------------------------------------------------------------

QUAKE2_PALETTE =
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

QUAKE2_COMBOS =
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

QUAKE2_EXITS =
{
}


QUAKE2_KEY_DOORS =
{
  k_silver = { door_kind="door_silver", door_side=14 },
  k_gold   = { door_kind="door_gold",   door_side=14 },
}

QUAKE2_MISC_PREFABS =
{
}



---- QUEST STUFF ----------------

QUAKE2_QUESTS =
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


QUAKE2_ROOMS =
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

QUAKE2_THEMES =
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

QUAKE2_MONSTERS =
{
  guard =
  {
    prob=20, guard_prob=3, trap_prob=3, cage_prob=3,
    health=20, damage=4, attack="missile",
  },

  guard_sg =
  {
    prob=70, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=10, attack="hitscan",
  },

  guard_mg =
  {
    prob=70, guard_prob=11, trap_prob=11, cage_prob=11,
    health=30, damage=10, attack="hitscan",
  },

  enforcer =
  {
    prob=50, guard_prob=11, trap_prob=11, cage_prob=11,
    health=100, damage=10, attack="hitscan",
  },

  flyer =
  {
    prob=90, guard_prob=11, trap_prob=11,
    health=50, damage=5, attack="missile",
    float=true,
  },

  shark =
  {
    health=50, damage=5, attack="melee",
  },

  parasite =
  {
    prob=10, guard_prob=11, trap_prob=21,
    health=175, damage=10, attack="missile",
  },

  maiden =
  {
    prob=50, guard_prob=21, trap_prob=21, cage_prob=11,
    health=175, damage=30, attack="missile",
  },

  technician =
  {
    prob=50, guard_prob=11, trap_prob=11,
    health=200, damage=8, attack="missile",
    float=true,
  },

  beserker =
  {
    prob=50, guard_prob=11, trap_prob=11, cage_prob=11,
    health=240, damage=18, attack="melee",
  },

  icarus =
  {
    prob=70, guard_prob=11, trap_prob=21,
    health=240, damage=5, attack="missile",
    float=true,
  },

  medic =
  {
    prob=30, guard_prob=11, trap_prob=11, cage_prob=11,
    health=300, damage=21, attack="missile",
  },

  mutant =
  {
    prob=30, guard_prob=11, trap_prob=11, cage_prob=11,
    health=300, damage=24, attack="melee",
  },

  brain =
  {
    prob=20, guard_prob=11, trap_prob=31,
    health=300, damage=17, attack="melee",
  },

  grenader =
  {
    prob=10, guard_prob=11, trap_prob=11, cage_prob=11,
    health=400, damage=30, attack="missile",
  },

  gladiator =
  {
    prob=10, guard_prob=11, trap_prob=11, cage_prob=11,
    health=400, damage=40, attack="missile",
  },

  tank =
  {
    prob=2,
    health=750, damage=160, attack="missile",
  },

  tank_cmdr =
  {
    health=1000, damage=160, attack="missile",
  },

  ---| BOSSES |---

  -- FIXME: damage values and attack kinds?

  Super_tank =
  {
    health=1500, damage=200,
  },

  Huge_flyer =
  {
    health=2000, damage=200,
    -- FIXME: immune to laser (??)
  },

  Jorg =
  {
    health=3000, damage=200,
  },

  Makron =
  {
    health=3000, damage=200,
  },

  -- NOTES:
  --
  -- Dropped items are not endemic to types of monsters, but can
  -- be specified for each monster entity with the "item" keyword.
  -- This could be used for lots of cool stuff (e.g. kill a boss
  -- monster to get a needed key) -- another TODO feature.
}


QUAKE2_WEAPONS =
{
  blaster =
  {
    rate=1.7, damage=10, attack="missile",
  },

  shotty =
  {
    pref=20, add_prob=10, start_prob=40,
    rate=0.6, damage=40, attack="hitscan",
    ammo="shell",  per=1,
    give={ {ammo="shell",count=10} },
  },

  ssg =
  {
    pref=70, add_prob=50, start_prob=10,
    rate=0.8, damage=88, attack="hitscan", splash={0,8},
    ammo="shell", per=2,
    give={ {ammo="shell",count=10} },
  },

  machine =
  {
    pref=20, add_prob=30, start_prob=30,
    rate=6.0, damage=8, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=50} },
  },

  chain =
  {
    pref=90, add_prob=15, start_prob=5,
    rate=14, damage=8, attack="hitscan",
    ammo="bullet", per=1,
    give={ {ammo="bullet",count=50} },
  },

  grenade =
  {
    pref=15, add_prob=25, start_prob=15,
    rate=0.7, damage=5, attack="missile", splash={60,15,3},
    ammo="grenade", per=1,
    give={ {ammo="grenade",count=5} },
  },

  launcher =
  {
    pref=30, add_prob=20, start_prob=3,
    rate=1.1, damage=90, attack="missile", splash={0,20,6,2},
    ammo="rocket", per=1,
    give={ {ammo="rocket",count=5} },
  },

  rail =
  {
    pref=50, add_prob=10,
    rate=0.6, damage=140, attack="hitscan",
    ammo="slug", per=1, splash={0,25,5},
    give={ {ammo="slug",count=10} },
  },

  hyper =
  {
    pref=60, add_prob=20,
    rate=5.0, damage=20, attack="missile",
    ammo="cell", per=1,
    give={ {ammo="cell",count=50} },
  },

  bfg =
  {
    pref=20, add_prob=15,
    rate=0.3, damage=200, attack="missile", splash={0,50,40,30,20,10,10},
    ammo="cell", per=50,
    give={ {ammo="cell",count=50} },
  },


  -- Notes:
  --
  -- The BFG can damage lots of 'in view' monsters at once.
  -- This is modelled with a splash damage table.
  --
  -- Railgun can pass through multiple enemies.  We assume
  -- the player doesn't manage to do it very often :-).
  --
  -- Grenades don't do any direct damage when they hit a
  -- monster, it's all in the splash baby.
}


QUAKE2_PICKUPS =
{
  -- HEALTH --

  heal_2 =
  {
    prob=10, cluster={ 3,9 },
    give={ {health=2} },
  },

  heal_10 =
  {
    prob=20,
    give={ {health=10} },
  },

  heal_25 =
  {
    prob=50,
    give={ {health=25} },
  },

  heal_100 =
  {
    prob=5,
    give={ {health=70} },
  },

  -- ARMOR --

  armor_2 =
  {
    prob=7, cluster={ 3,9 },
    give={ {health=1} },
  },

  armor_25 =  -- (jacket)
  {
    prob=7,
    give={ {health=8} },
  },

  armor_50 =  -- (combat)
  {
    prob=15,
    give={ {health=25} },
  },

  armor_100 =  -- (body)
  {
    prob=15,
    give={ {health=80} },
  },

  -- AMMO --

  am_bullet =
  {
    give={ {ammo="bullet",count=50} },
  },

  am_shell =
  {
    give={ {ammo="shell",count=10} },
  },

  am_grenade =
  {
    give={ {ammo="grenade",count=5} },
  },

  am_rocket =
  {
    give={ {ammo="rocket",count=5} },
  },

  am_slug = 
  {
    give={ {ammo="slug",count=10} },
  },

  am_cell =
  {
    give={ {ammo="cell",count=50} },
  },

  -- Notes:
  --
  -- Megahealth only gives 70 instead of 100, since excess
  -- health rots away over time.
  --
  -- Each kind of Armor in Quake2 has two protection values, one
  -- for normal attacks (bullets or missiles) and one for energy
  -- attacks (blaster or bfg).  Since very few monsters use an
  -- energy attack (Technician only one??) we only use the normal
  -- protection value.
}


QUAKE2_PLAYER_MODEL =
{
  quakeguy =
  {
    stats   = { health=0, bullet=0, shell=0, grenade=0, rocket=0, slug=0, cell=0 },
    weapons = { blaster=1 },
  }
}


------------------------------------------------------------

QUAKE2_EPISODE_THEMES =
{
  { BASE=7, },
  { BASE=6, },
  { BASE=6, },
  { BASE=6, },
}

QUAKE2_KEY_NUM_PROBS =
{
  small   = { 90, 50, 20 },
  regular = { 40, 90, 40 },
  large   = { 20, 50, 90 },
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

  local desc_list = Naming_generate("TECH", #GAME.all_levels, PARAM.max_level_desc)

  for index,LEV in ipairs(GAME.all_levels) do
    LEV.description = desc_list[index]
  end
end


function Quake2_setup()

  GAME.player_model = QUAKE2_PLAYER_MODEL

  GAME.dm = {}

  Game_merge_tab("things",   QUAKE2_THINGS)
  Game_merge_tab("monsters", QUAKE2_MONSTERS)
  Game_merge_tab("weapons",  QUAKE2_WEAPONS)
  Game_merge_tab("pickups",  QUAKE2_PICKUPS)

  Game_merge_tab("quests",  QUAKE2_QUESTS)

  Game_merge_tab("combos", QUAKE2_COMBOS)
  Game_merge_tab("exits",  QUAKE2_EXITS)

  Game_merge_tab("key_doors", QUAKE2_KEY_DOORS)

  Game_merge_tab("rooms",  QUAKE2_ROOMS)
  Game_merge_tab("themes", QUAKE2_THEMES)

  Game_merge_tab("misc_fabs", QUAKE2_MISC_PREFABS)

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

