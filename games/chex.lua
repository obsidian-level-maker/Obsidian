----------------------------------------------------------------
-- GAME DEF : Chex Quest 1, 2 and 3
----------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2009 Enhas
--  Copyright (C) 2011 Andrew Apted
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
--
--  NOTES:
--
--  *  Chex Quest 2 is considered here as an "extension" to
--     the original Chex Quest (which reflects how it actually
--     runs, because you need both WADs to play it).
--
--  *  Chex Quest 3 is NOT considered an extension, since it
--     requires a ZDoom-based port to run.
--
--  *  Chex Quest 2 has new sprites for two of the enemies of
--     the original as well as the final boss.  However their
--     'id' numbers and in-game behavior are exactly the same,
--     hence there is no additional logic here for them.
--
----------------------------------------------------------------

CHEX  = { }  -- common stuff

CHEX1 = { }  --\
CHEX2 = { }  -- stuff specific to each game
CHEX3 = { }  --/


CHEX.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, kind="other", r=16,h=56 }
  player2 = { id=2, kind="other", r=16,h=56 }
  player3 = { id=3, kind="other", r=16,h=56 }
  player4 = { id=4, kind="other", r=16,h=56 }

  dm_player     = { id=11, kind="other", r=16,h=56 }
  teleport_spot = { id=14, kind="other", r=16,h=56 }

  --- MONSTERS ---

  commonus      = { id=3004,kind="monster", r=20,h=56 }
  bipedicus     = { id=9,   kind="monster", r=20,h=56 } -- Quadrumpus in CQ2
  armored_biped = { id=3001,kind="monster", r=20,h=56 }
  cycloptis     = { id=3002,kind="monster", r=30,h=56 } -- Larva in CQ2

  --- BOSSES ---

  Flembrane = { id=3003,kind="monster", r=44,h=100 } -- Maximus in CQ2

  --- PICKUPS ---

  k_red    = { id=13, kind="pickup", r=20,h=16, pass=true }
  k_yellow = { id=6,  kind="pickup", r=20,h=16, pass=true }
  k_blue   = { id=5,  kind="pickup", r=20,h=16, pass=true }

  large_zorcher   = { id=2001, kind="pickup", r=20,h=16, pass=true }
  rapid_zorcher   = { id=2002, kind="pickup", r=20,h=16, pass=true }
  zorch_propulsor = { id=2003, kind="pickup", r=20,h=16, pass=true }
  phasing_zorcher = { id=2004, kind="pickup", r=20,h=16, pass=true }
  super_bootspork = { id=2005, kind="pickup", r=20,h=16, pass=true }
  laz_device      = { id=2006, kind="pickup", r=20,h=16, pass=true }

  back_pack      = { id=   8, kind="pickup", r=20,h=16, pass=true }
  slime_suit     = { id=2025, kind="pickup", r=20,h=60, pass=true }
  allmap         = { id=2026, kind="pickup", r=20,h=16, pass=true }

  water       = { id=2014, kind="pickup", r=20,h=16, pass=true }
  fruit       = { id=2011, kind="pickup", r=20,h=16, pass=true }
  vegetables  = { id=2012, kind="pickup", r=20,h=16, pass=true }
  supercharge = { id=2013, kind="pickup", r=20,h=16, pass=true }

  repellent   = { id=2015, kind="pickup", r=20,h=16, pass=true }
  armor       = { id=2018, kind="pickup", r=20,h=16, pass=true }
  super_armor = { id=2019, kind="pickup", r=20,h=16, pass=true }

  mini_zorch      = { id=2007, kind="pickup", r=20,h=16, pass=true }
  mini_pack       = { id=2048, kind="pickup", r=20,h=16, pass=true }
  large_zorch     = { id=2008, kind="pickup", r=20,h=16, pass=true }
  large_pack      = { id=2049, kind="pickup", r=20,h=16, pass=true }
  propulsor_zorch = { id=2010, kind="pickup", r=20,h=16, pass=true }
  propulsor_pack  = { id=2046, kind="pickup", r=20,h=16, pass=true }
  phasing_zorch   = { id=2047, kind="pickup", r=20,h=16, pass=true }
  phasing_pack    = { id=  17, kind="pickup", r=20,h=16, pass=true }

  --- SCENERY ---

  -- tech --

  landinglight = { id=2028,kind="scenery", r=16,h=35, light=255 }
  lightcolumn  = { id=55,  kind="scenery", r=16,h=86, light=255 }

  flag_pole  = { id=37, kind="scenery", r=16,h=128 }
  gas_tank   = { id=35, kind="scenery", r=16,h=36 }
  spaceship  = { id=48, kind="scenery", r=16,h=52 }

  chemical_burner = { id=41, kind="scenery", r=16,h=25 }

  -- arboretum --

  apple_tree   = { id=47, kind="scenery", r=16,h=92,  add_mode="island" }
  orange_tree  = { id=43, kind="scenery", r=16,h=92,  add_mode="island" }
  tall_flower  = { id=28, kind="scenery", r=20,h=25,  add_mode="island" }
  tall_flower2 = { id=25, kind="scenery", r=20,h=25,  add_mode="island" }

  -- other --

  slime_fountain = { id=44, kind="scenery", r=16,h=48 }

  civilian1 = { id=45, kind="scenery", r=16,h=54 }
}


CHEX1.ENTITIES =
{
  -- scenery --

  banana_tree  = { id=54, kind="scenery", r=31,h=108, add_mode="island" }

  chemical_flask  = { id=34, kind="scenery", r=16,h=16, pass=true }
  submerged_plant = { id=31, kind="scenery", r=16,h=42 }

  column     = { id=32, kind="scenery", r=16,h=128 }
  stalactite = { id=53, kind="scenery", r=16,h=50 }
  stalagmite = { id=30, kind="scenery", r=16,h=60 }
  mine_cart  = { id=33, kind="scenery", r=16,h=30 }

  civilian2  = { id=56, kind="scenery", r=16,h=54 }
  civilian3  = { id=57, kind="scenery", r=16,h=48 }
}


CHEX2.ENTITIES =
{
  quadrumpus = { id=9,    kind="monster", r=20,h=56 }
  larva      = { id=3002, kind="monster", r=30,h=56 }
  Maximus    = { id=3003, kind="monster", r=44,h=100 }

  -- scenery --

  lamp = { id=34, kind="scenery", r=16, h=80 }

  blockade = { id=45, kind="scenery", r=24, h=50 }

  dinosaur1 = { id=54,   kind="scenery", r=64, h=80 }
  dinosaur2 = { id=57,   kind="scenery", r=64, h=80 }
  dinosaur3 = { id=2023, kind="scenery", r=64, h=80 }  -- PICKUP?

  mummy     = { id=52, kind="scenery", r=16, h=80 }  -- ONCEILING?
  pharaoh   = { id=53, kind="scenery", r=32, h=80 }  -- ONCEILING?

  statue_thinker = { id=30, kind="scenery", r=32, h=80 }
  statue_david   = { id=31, kind="scenery", r=32, h=80 }
  statue_warrior = { id=36, kind="scenery", r=32, h=80 }

  waiter      = { id=32, kind="scenery", r=32, h=80 }
  giant_spoon = { id=33, kind="scenery", r=64, h=60 }
}


CHEX3.ENTITIES =
{
  -- monsters --

  larva        = { id=9050, kind="monster", r=30,h=56 }
  quadrumpus   = { id=9057, kind="monster", r=20,h=56 }
  stridicus    = { id=3002, kind="monster", r=30,h=56 }
  flemmine     = { id=3006, kind="monster", r=16,h=56 }
  super_cyclop = { id=3005, kind="monster", r=31,h=56 }

  --- bosses ---

  Flembrane      = { id=69, kind="monster", r=64,h=64 }
  Maximus        = { id=3003, kind="monster", r=24,h=64 }
  Snotfolus      = { id=16, kind="monster", r=40,h=110 }
  Flembomination = { id=7,  kind="monster", r=100,h=100 }
}


CHEX.PARAMETERS =
{
  rails = true
  switches = true
  liquids = true
  teleporters = true
  infighting = true

  custom_flats = true

  max_name_length = 28

  skip_monsters = { 10,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.8
}


----------------------------------------------------------------

CHEX.MATERIALS =
{
  -- special materials --
  _ERROR = { t="SHAWN2", f="FLOOR0_5" }
  _SKY   = { t="SHAWN2", f="F_SKY1" }


  METAL  = { t="COMPBLUE", f="STEP1" }

  WHITE  = { t="WOOD3", f="##" }


  -- walls --

  BLUE_WALL    = { t="SP_DUDE2", f="##" }
  BLUE_OBSDECK = { t="SLADSKUL", f="##" }
  BLUE_SLIMED  = { t="SKINMET1", f="##" }

  GRAY_PIPES   = { t="STONE",  f="##" }
  GRAY_PANELS  = { t="STONE3", f="##" }
  GRAY_LITE    = { t="LITESTON", f="##" }
  GRAY_STRIPE  = { t="GRAY7",    f="##" }

  ORANGE_TILE   = { t="STARG3",  f="##" }
  ORANGE_LAB    = { t="COMPUTE3",  f="##" }
  ORANGE_SLIMED = { t="SKINMET2", f="##" }
  ORANGE_CUPBD  = { t="DOOR3", f="##" }
  ORANGE_CABNET = { t="CEMENT4", f="##" }
  ORANGE_LOCKER = { t="CEMENT6", f="##" }

  ORANGE_MATH   = { t="CEMPOIS", f="##" }
  ORANGE_BOOKS = { t="BRNSMALL", f="##" }
  ORANGE_DIAG  = { t="BRNSMALR", f="##" }
  ORANGE_MAP   = { t="BROWN96", f="##" }


  TAN1      = { t="TEKWALL5", f="##" }
  TAN2      = { t="BROWN1",   f="##" }
  TAN_LITE  = { t="LITE2",    f="##" }
  TAN_GRATE = { t="BRNSMAL1", f="##" }
  TAN_VINE  = { t="BROVINE",  f="##" }

  TAN_EXPM1 = { t="SKY2", f="##" }
  TAN_EXPM2 = { t="SKY3", f="##" }
  TAN_EXPM3 = { t="SKY4", f="##" }

  CEMENT1      = { t="CEMENT1", f="##" }
  CEMENT5      = { t="CEMENT5", f="##" }
  CEMENT_LITE  = { t="LITE96", f="##" }
  CEMENT_GRATE = { t="REDWALL1", f="##" }

  STARPORT  = { t="CEMENT2", f="##" }

  COMPUTE_1 = { t="COMP2", f="##" }
  COMPUTE_2 = { t="COMPUTE2", f="##" }
  COMP_BOX  = { t="COMPWERD", f="##" }


  CRATE1   = { t="CRATE1",   f="FLAT1" }
  CRATE2   = { t="CRATE2",   f="FLAT2" }
  CRATEMIX = { t="CRATELIT", f="FLAT2" }
  CRATWIDE = { t="CRATWIDE", f="FLAT2" }

  CUPBOARD = { t="BRNBIGC",  f="##" }


  CAVE      = { t="SKSNAKE2", f="##" }
  CAVE_GLOW = { t="BLODRIP2", f="##" }
  CAVE_LITE = { t="SKULWAL3", f="##" }

  CAVE_CRACK = { t="STARTAN2", f="##" }


  PIC_PLANET  = { t="SKINCUT",  f="CEIL4_1" }

  PIC_DIPLOMA = { t="EXITDOOR", f="##" }
  PIC_PHOTO1  = { t="TEKWALL3", f="##" }
  PIC_PHOTO2  = { t="SLADWALL", f="##" }


  TELE_CHAMBER = { t="SLADRIP1", f="##" }

  MET_SLADS = { t="SP_DUDE4", f="##" }

  STEP_ORANGE = { t="STEP1",    f="##" }
  STEP_GRAY   = { t="STEP2",    f="##" }
  STEP_WHITE  = { t="STEPTOP",  f="##" }
  STEP_CAVE   = { t="STEPLAD1", f="##" }


  -- floors --

  LIFT_2  = { f="SKSNAKE1", t="COMPBLUE" }

  VENT     = { f="FLOOR0_3", t="ASHWALL" }

CEIL4_1  = { t="STARG3", f="CEIL4_1" }
FLOOR0_5 = { t="STARG3", f="FLOOR0_5" }


  -- doors --

  DOOR_GRATE = { t="BIGDOOR1", f="##" }
  DOOR_ALUM  = { t="DOOR1",    f="##" }
  DOOR_METER = { t="DOORBLU2", f="##" }

  DOOR_BLUE   = { t="BRNBIGR",  f="##" }
  DOOR_RED    = { t="BRNBIGL",  f="##" }
  DOOR_YELLOW = { t="BRNSMAL2", f="##" }

  DOOR_LAB   = { t="BIGDOOR4", f="##" }
  DOOR_ARBOR = { t="BIGDOOR5", f="##" }
  DOOR_HYDRO = { t="BIGDOOR6", f="##" }

  WDOOR_HANGER1 = { t="STARTAN3", f="##" }  -- 512 units wide
  WDOOR_HANGER2 = { t="SKINFACE", f="##" }

  WDOOR_ARBOR = { t="SKINSCAB", f="##" }
  WDOOR_MINES = { t="SKINSYMB", f="##" }
  WDOOR_FRIDGE = { t="SKINTEK1", f="##" }

  TRACK = { t="COMPSTA1", f="STEP1" }

  LITE_RED    = { t="DOORRED", f="##" }
  LITE_BLUE   = { t="DOORBLU", f="##" }
  LITE_YELLOW = { t="DOORYEL", f="##" }


  -- switches --

  SW_METAL   = { t="SW2BLUE",  f="STEP1" }
  SW_ROCK    = { t="SW1BRCOM", f="##"  }
  SW_BROWN2  = { t="SW1BRN2",  f="##"  }

  SW_GRAY    = { t="SW1COMM",  f="##"  }
  SW_COMPUTE = { t="SW1COMP",  f="##"  }
  SW_TAN     = { t="SW1METAL", f="##"  }
  SW_PIPEY   = { t="SW1STONE", f="##"  }


  -- liquids --

  WATER  = { t="GSTFONT1", f="FWATER1", sane=1 }
  SLIME1 = { t="FIREMAG1", f="NUKAGE1", sane=1 }
  SLIME2 = { t="FIREMAG1", f="LAVA1",   sane=1 }


  -- special stuff --

  O_PILL   = { t="SP_ROCK1", f="O_PILL",   sane=1 }
  O_BOLT   = { t="SP_ROCK2", f="O_BOLT",   sane=1 }
  O_RELIEF = { t="MIDBRN1",  f="O_RELIEF", sane=1 }
  O_CARVE  = { t="NUKESLAD", f="O_CARVE",  sane=1 }
  O_NEON   = { t="TEKWALL2", f="CEIL4_1",  sane=1 }
}


CHEX1.MATERIALS =
{
  BLUE_SFALL  = { t="BLODGR1",  f="##" }

  CAVE_SLIMY1 = { t="PIPE4",   f="##" }
  CAVE_SLIMY2 = { t="MARBLE2", f="##" }
  CAVE_SLIMY3 = { t="STARGR1", f="##" }

  CAVE_EDGER  = { t="NUKEDGE1", f="##" }
  CAVE_SPLAT  = { t="NUKEPOIS", f="##" }

  COMPUTE_3   = { t="COMPTALL", f="##" }

  GRAY_FLOWER1 = { t="GRAY2",    f="##" }
  GRAY_FLOWER2 = { t="GRAYDANG", f="##" }

  PIC_SLIMED  = { t="SLADPOIS", f="##" }
  PIC_STORAGE = { t="MARBFAC3", f="##" }

  SW_CEMENT   = { t="SW1BROWN", f="##"  }
}


CHEX2.MATERIALS =
{
  -- walls --

  GREEN_BRICK  = { t="STARG1", f="##" }
  GREEN_SIGN   = { t="DOOR1", f="##" }
  GREEN_BORDER = { t="STARGR1", f="##" }
  GREEN_GRATE  = { t="STARTAN2", f="##" }

  BIG_GRATE = { t="SW1EXIT", f="##" }

  HEDGE = { t="BIGDOOR2", f="##" }

  MARB_GREEN  = { t="BROWN144", f="##" }
  MARB_RED    = { t="COMPSTA2", f="##" }
  MARB_BEIGE  = { t="EXITSIGN", f="##" }


  RED_CURTAIN = { t="SLADPOIS", f="##" }

  MOVIE_PRAM    = { t="BLODGR1", f="##" }
  MOVIE_MOUSE   = { t="BLODRIP1", f="##" }
  MOVIE_CHARLES = { t="FIREMAG1", f="##" }

  PIC_EAT_EM = { t="BRNPOIS", f="##" }
  PIC_LUV_EM = { t="BRNPOIS2", f="##" }
  PIC_HUNGRY = { t="PIPE4", f="##" }

  PIC_MONA    = { t="MARBFACE", f="##" }
  PIC_VENUS   = { t="MARBFAC3", f="##" }
  PIC_VINCENT = { t="MARBLE2", f="##" }
  PIC_SCREAM  = { t="MARBLE3", f="##" }
  PIC_NUN     = { t="MARBLOD1", f="##" }
  PIC_LAME    = { t="MIDGRATE", f="##" }

  SIGN_ENTER    = { t="LITE5", f="##" }
  SIGN_WELCOME1 = { t="COMPTALL", f="##" }
  SIGN_WELCOME2 = { t="COMPUTE1", f="##" }
  SIGN_GALACTIC = { t="NUKE24", f="##" }

  SIGN_DINER    = { t="NUKEDGE1", f="##" }
  SIGN_MUSEUM   = { t="SW2GRAY", f="##" }
  SIGN_SEWER    = { t="SW2GRAY1", f="##" }
  SIGN_CINEMA   = { t="SW2SLAD", f="##" }


  BLUE_POSTER1 = { t="GRAY2", f="##" }
  BLUE_POSTER2 = { t="GSTLION", f="##" }
  BLUE_POSTER3 = { t="GSTSATYR", f="##" }
  BLUE_CUPBD   = { t="GRAYPOIS", f="##" }

  TAN_THEATRE1 = { t="TEKWALL4", f="##" }
  TAN_THEATRE2 = { t="GSTONE1", f="##" }
  TAN_THEATRE3 = { t="GSTONE2", f="##" }
  TAN_MENU     = { t="LITE3", f="##" }

  BENCH_DRINKS  = { t="GRAYBIG", f="##" }
  BENCH_POPCORN = { t="GRAYDANG", f="##" }


  -- switches --

  SW_GREEN = { t="SW1BROWN", f="##" }


  -- liquids --

  -- Chex Quest 2 has no animated slime texture
  SLIME1 = { t="GSTVINE2", f="NUKAGE1", sane=1 }
  SLIME2 = { t="GSTVINE2", f="LAVA1",   sane=1 }
}


CHEX3.MATERIALS =
{
}


CHEX1.RAILS =
{
  VINE1 = { t="MIDVINE1" }
}


CHEX.LIQUIDS =
{
  water  = { mat="WATER", light=0.65 }

  -- these look very similar
  slime1 = { mat="SLIME1", light=0.65, special=5 }
  slime2 = { mat="SLIME2", light=0.65, special=5 }
}


----------------------------------------------------------------

CHEX.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_switch =
  {
    _prefab = "EXIT_PILLAR",

    switch = "SW_COMPUTE"
    exit = "METAL"
    exitside = "METAL"
    special = 11
    tag = 0
  }


  ----| STAIRS |----

  Stair_Up1 =
  {
    _prefab = "STAIR_6"
    _where  = "chunk"
    _stairs = { up=1 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "chunk"
    _stairs = { down=1 }
  }


  ---| LOCKED DOORS |---

  Locked_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { k_blue=1 }
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    door = "DOOR_BLUE"
    key = "LITE_BLUE"
    track = "DOORTRAK"

    special = 32
    tag = 0
  }

  Locked_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { k_yellow=1 }
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "DOOR_YELLOW"
    key = "LITE_YELLOW"
    track = "DOORTRAK"

    special = 34
    tag = 0
  }

  Locked_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _keys = { k_red=1 }
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "DOOR_RED"
    key = "LITE_RED"
    track = "DOORTRAK"

    special = 33
    tag = 0
  }


  ---| SWITCHED DOORS |---

  Door_SW_alum =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switches = { Switch_alum=50 }
    _long = 192
    _deep = 32

    w = 128
    h = 112

    door = "DOOR_ALUM"
    track = "DOORTRAK"

    door_h = 112
    special = 0
  }

  Switch_alum =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "edge"
    _long   = 192
    _deep   = 48

    switch_h = 64
    switch = "SW_METAL"
    side = "LITE2"
    base = "LITE2"
    x_offset = 0
    y_offset = 50
    special = 103
  }

}


----------------------------------------------------------------

CHEX.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_switch = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50 }

  keys = { k_red=50, k_blue=50, k_yellow=50 }

  switch_doors = { Door_SW_alum = 50 }

  lock_doors = { Locked_blue=50, Locked_red=50, Locked_yellow=50 }

  liquids = { water=50, slime1=50, slime2=50 }
}


CHEX.ROOM_THEMES =
{
  PLAIN = { }
}


CHEX1.LEVEL_THEMES =
-- TECH, ARBORETUM and CAVE?
{
  chex_tech1 =
  {
    building_walls =
    {
      BROWN=50,
    }

    building_floors =
    {
      FLOOR0_5=50,
    }

    building_ceilings =
    {
      CEIL4_1=50,
    }
    
    courtyard_floors =
    {
      BROWN2=50,
    }
  }
}


------------------------------------------------------------

-- Monster list
-- ============

-- nearly all the settings below for monsters, weapons and items
-- are the same as doom.lua, except the probs for monsters

CHEX3.MONSTERS =
{
  commonus =
  {
    prob = 60
    health = 20
    attack = "melee"
    damage = 4
  }

  bipedicus =
  {
    prob = 45
    health = 30
    attack = "melee"
    damage = 10
  }

  armored_biped =
  {
    prob = 35
    crazy_prob = 65
    health = 60
    attack = "missile"
    damage = 20
  }

  quadrumpus =
  {
    -- replaces = "armored_biped"
    -- replace_prob = 30
    prob = 35
    crazy_prob = 25
    health = 60
    attack = "missile"
    damage = 20
  }

  cycloptis =
  {
    prob = 30
    health = 150
    attack = "melee"
    damage = 25
    weap_prefs = { zorch_propulsor=0.5 }
  }

  larva =
  {
    --- replaces = "cycloptis"
    --- replace_prob = 25
    prob = 30
    crazy_prob = 25
    health = 125
    attack = "melee"
    damage = 25
    weap_prefs = { zorch_propulsor=0.5 }
  }

  flemmine =
  {
    prob = 20
    health = 100
    attack = "melee"
    damage = 7
    density = 0.7
    float = true
  }

  stridicus =
  {
    prob = 20
    health = 225
    attack = "melee"
    damage = 25
    density = 0.7
  }

  super_cyclop =
  {
    prob = 30
    health = 400
    attack = "missile"
    damage = 35
    density = 0.5
    float = true
  }

  --- BOSSES ---

  -- Flembrane is a special case (stationary wall monster, with
  -- level exit behind it), and is not used in normal levels.

  Flembrane =
  {
    health = 1000
    attack = "missile"
    damage = 45
    weap_prefs = { laz_device=3.0 }
  }

  Maximus =
  {
    prob = 2
    health = 1000
    attack = "missile"
    damage = 45
    density = 0.3
    weap_prefs = { laz_device=3.0 }
  }

  Snotfolus =
  {
    prob = 1
    crazy_prob = 10
    skip_prob = 300
    health = 4000
    damage = 135
    attack = "missile"
    density = 0.1
    weap_prefs = { lazdevice=5.0 }
  }

  Flembomination =
  {
    prob = 1
    crazy_prob = 12
    skip_prob = 200
    health = 3000
    damage = 70
    attack = "missile"
    density = 0.2
    weap_prefs = { lazdevice=5.0 }
  }
}


CHEX1.MONSTERS =
{
  commonus      = CHEX3.commonus
  bipedicus     = CHEX3.bipedicus
  cycloptis     = CHEX3.cycloptis
  armored_biped = CHEX3.armored_biped

  Flembrane     = CHEX3.Flembrane
}


CHEX2.MONSTERS =
{
  commonus      = CHEX3.commonus
  quadrumpus    = CHEX3.quadrumpus
  larva         = CHEX3.larva
  armored_biped = CHEX3.armored_biped

  Maximus       = CHEX3.Maximus
}


-- Weapon list
-- ===========

CHEX.WEAPONS =
{
  spoon =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  super_bootspork =
  {
    pref = 3
    add_prob = 2
    start_prob = 1
    attack = "melee"
    rate = 8.7
    damage = 10
  }

  mini_zorcher =
  {
    pref = 5
    attack = "hitscan"
    rate = 1.8
    damage = 10
    ammo = "mzorch"
    per = 1
  }

  rapid_zorcher =
  {
    pref = 70
    add_prob = 35
    start_prob = 40
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "mzorch"
    per = 1
    give = { {ammo="mzorch",count=20} }
  }

  large_zorcher =
  {
    pref = 70
    add_prob = 10
    start_prob = 60
    attack = "hitscan"
    rate = 0.9
    damage = 70
    splash = { 0,10 }
    ammo = "lzorch"
    per = 1
    give = { {ammo="lzorch",count=8} }
  }

  zorch_propulsor =
  {
    pref = 50
    add_prob = 25
    start_prob = 10
    rarity = 2
    attack = "missile"
    rate = 1.7
    damage = 80
    splash = { 50,20,5 }
    ammo = "propulsor"
    per = 1
    give = { {ammo="propulsor",count=2} }
  }

  phasing_zorcher =
  {
    pref = 90
    add_prob = 13
    start_prob = 5
    rarity = 2
    attack = "missile"
    rate = 11
    damage = 20
    ammo = "phase"
    per = 1
    give = { {ammo="phase",count=40} }
  }

  laz_device =
  {
    pref = 30
    add_prob = 30
    start_prob = 0.2
    rarity = 5
    attack = "missile"
    rate = 0.8
    damage = 300
    splash = {60,45,30,30,20,10}
    ammo = "phase"
    per = 40
    give = { {ammo="phase",count=40} }
  }
}


-- Pickup List
-- ===========

CHEX.PICKUPS =
{
  -- HEALTH --

  water =
  {
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  fruit =
  {
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  vegetables =
  {
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  supercharge =
  {
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  repellent =
  {
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  armor =
  {
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  super_armor =
  {
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
  }

  -- AMMO --

  mini_zorch =
  {
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="mzorch",count=10} }
  }

  mini_pack =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="mzorch", count=50} }
  }

  large_zorch =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="lzorch",count=4} }
  }

  large_pack =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="lzorch",count=20} }
  }

  propulsor_zorch =
  {
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="propulsor",count=1} }
  }

  propulsor_pack =
  {
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="propulsor",count=5} }
  }

  phasing_zorch =
  {
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="phase",count=20} }
  }

  phasing_pack =
  {
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="phase",count=100} }
  }
}


CHEX.PLAYER_MODEL =
{
  chexguy =
  {
    stats   = { health=0 }
    weapons = { mini_zorcher=1, spoon=1 }
  }
}


------------------------------------------------------------

CHEX1.EPISODES =
-- Chex Quest only has one episode of five levels
{
}


function CHEX1.setup()
 -- TODO
end


function CHEX1.get_levels()
  local EP_NUM  = 1
  local MAP_NUM = 1

  if OB_CONFIG.length == "few"     then MAP_NUM = 2 end
  if OB_CONFIG.length == "episode" then MAP_NUM = 5 end
  if OB_CONFIG.length == "full"    then MAP_NUM = 5 ; EP_NUM = 1 end

  for episode = 1,EP_NUM do
    for map = 1,MAP_NUM do

      local LEV =
      {
        name  = string.format("E%dM%d", episode, map)
        patch = string.format("WILV%d%d", episode-1, map-1)

        episode  = episode
        ep_along = map / MAP_NUM
        ep_info  = { }

        name_theme = "TECH"

      }

      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


function CHEX1.begin_level()
  -- set the description here
  if not LEVEL.description and LEVEL.name_theme then
    LEVEL.description = Naming_grab_one(LEVEL.name_theme)
  end
end


function CHEX1.make_cool_gfx()
  local GREEN =
  {
    0, 7, 127, 126, 125, 124, 123, 122, 120, 118, 116, 113
  }

  local BRONZE_2 =
  {
    0, 2, 191, 189, 187, 235, 233, 223, 221, 219, 216, 213, 210
  }

  local RED =
  {
    0, 2, 188,185,184,183,182,181, 180,179,178,177,176,175,174,173
  }

  local GOLD = { 0,47,44, 167,166,165,164,163,162,161,160, 225 }

  local SILVER = { 0,246,243,240, 205,202,200,198, 196,195,194,193,192, 4 }


  local colmaps =
  {
    BRONZE_2, GREEN, RED, GOLD, SILVER
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, colmaps[4])

  -- patches : SP_ROCK1, SP_ROCK2, MIDBRN1, NUKESLAD
  gui.wad_logo_gfx("WALL63_1", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("WALL63_2", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("DOOR12_1", "p", "RELIEF",  64,128, 3)
  gui.wad_logo_gfx("WALL57_1", "p", "CARVE",   64,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
end


function CHEX1.all_done()
  CHEX1.make_cool_gfx()
end


------------------------------------------------------------

OB_GAMES["chex1"] =
{
  label = "Chex Quest"
  format = "doom"

  tables =
  {
    CHEX, CHEX1
  }

  hooks =
  {
    setup        = CHEX1.setup
    get_levels   = CHEX1.get_levels
    begin_level  = CHEX1.begin_level
    all_done     = CHEX1.all_done
  }
}


OB_GAMES["chex2"] =
{
  label = "Chex Quest 2"
  extends = "chex1"
  format = "doom"

  tables =
  {
    CHEX, CHEX2
  }

  hooks =
  {
    setup        = CHEX1.setup
    get_levels   = CHEX1.get_levels
    begin_level  = CHEX1.begin_level
    all_done     = CHEX1.all_done
  }
}


OB_GAMES["chex3"] =
{
  label = "Chex Quest 3"
  format = "doom"

  tables =
  {
    CHEX, CHEX3
  }

  hooks =
  {
    setup        = CHEX1.setup
    get_levels   = CHEX1.get_levels
    begin_level  = CHEX1.begin_level
    all_done     = CHEX1.all_done
  }
}


------------------------------------------------------------

OB_THEMES["chex_tech"] =
{
  label = "Tech"
  for_games = { chex1=1, chex3=1 }
  name_theme = "TECH"
  mixed_prob = 60
}

UNFINISHED["chex_arboretum"] =
{
  label = "Arboretum"
  for_games = { chex1=1 }
  name_theme = "URBAN"
  mixed_prob = 30
}

UNFINISHED["chex_cave"] =
{
  label = "Cave"
  for_games = { chex1=1 }
  name_theme = "GOTHIC"
  mixed_prob = 30
}

