----------------------------------------------------------------
-- THEMES : Doom 2
----------------------------------------------------------------
--
--  Oblige Level Maker (C) 2006,2007 Andrew Apted
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

DM_LINE_TYPES =
{
  --- general ---

  A1_scroll_left = { kind=48 },

  S1_exit = { kind=11 },
  W1_exit = { kind=52 },

  S1_secret_exit = { kind=51  },
  W1_secret_exit = { kind=124 },
  
  WR_teleport = { kind=97  },
  MR_teleport = { kind=126 },  -- monster only

  S1_bars = { kind=23 },

  --- doors ---

  PR_door = { kind=1 },
  PR_blaze_door = { kind=117 },

  W1_door = { kind=2 },
  S1_door = { kind=103 },

  SR_door = { kind=63 },
  SR_blaze_door = { kind=114 },

  P1_blue_door   = { kind=32 },
  PR_blue_door   = { kind=26 },
  P1_yellow_door = { kind=34 },
  PR_yellow_door = { kind=27 },
  P1_red_door    = { kind=33 },
  PR_red_door    = { kind=28 },

  --- lifts ---

  SR_lift = { kind=62 },
  WR_lift = { kind=88 },

  SR_blaze_lift = { kind=123 },
  WR_blaze_lift = { kind=120 },
}

DM_SECTOR_TYPES =
{
  secret = { kind=9 },

  random_off = { kind=1 },
  blink_fast = { kind=2 },
  blink_slow = { kind=3 },

  glow    = { kind=8 },
  flicker = { kind=17 },

  damage_5  = { kind=7 },
  damage_10 = { kind=5 },
  damage_20 = { kind=16 },
}


----------------------------------------------------------------

DM_ROOM_THEMES =
{
---- INDOOR ------------

  BASE =
  {
    mat_pri = 8,

    wall = "STARTAN3",
    void = "STARTAN2",
    step = "STEP1",
    lift = "PLAT1",
    pillar = "COMPWERD",

    pic_wd = "COMPSTA2",    -- "COMP2" for Doom 1 !!
    pic_wd_h = 64,

    floor = "FLOOR4_8",
    ceil = "CEIL3_6",
    step_flat = "STEP2",

    scenery = "lamp",
    good_liquid = "blood",
  },

  BASE2 =
  {
    mat_pri = 8,

    wall = "STARG3",
    void = "STARG2",
    step = "STEP1",
    lift = "PLAT1",
    pillar = "METAL",  -- was "METAL4", not in doom 1
    pic_wd = "COMPBLUE",

    floor = "FLOOR5_1",
    ceil = "FLOOR4_5",
    step_flat = "STEP1",

    scenery = "tech_column",
  },

  MARBLE =
  {
    mat_pri = 6,

    wall = "MARBLE2",
    void = "SP_DUDE5",
    step = "STEP1",
    pillar = "GSTLION",
    pic_wd  = "SP_DUDE1",

    floor = "FLOOR7_2",
    ceil = "FLOOR7_1",

    scenery = "red_column_skl",

    bad_liquid = "nukage",
    good_liquid = "blood",
  },

  WOOD =
  {
    mat_pri = 7,

    wall = "WOOD1",
    void = "WOOD3",
    step = "STEP1",
    pillar = "WOODGARG", -- "WOODMET4" not in doom 1
    pic_wd = "MARBFACE",

    floor = "CEIL1_1",
    ceil = "FLAT5_1",
  },

  CEMENT =
  {
    mat_pri = 1,

    wall = "CEMENT6",
    void = "CEMENT4",
    step = "STEP1",
    lift = "SUPPORT3",
    pillar = "BROWNGRN",  -- "CEMENT8" not in doom 1

    floor = "FLAT9",
    ceil = "CEIL3_5",  -- "SLIME14" not in doom 1
  --  lift_flat = "FLOOR4_8",

  },

  SLAD =
  {
    mat_pri = 4,

    wall = "SLADWALL",
    void = "SLADSKUL",
    step = "STEP1",
    pillar = "SLADPOIS",
--FIXME: (not in doom1)   pic_wd = "BSTONE3",

    floor = "FLOOR0_5",
    ceil = "CEIL5_1",

    scenery = "burning_barrel",

    good_liquid = "nukage",
  },

  GRAY =
  {
    mat_pri = 3,

    wall = "GRAY7",
    void = "ICKWALL3",
    lift = "SUPPORT3",
    pillar = "CRATE1",
    pic_wd = "REDWALL",

    floor = "FLOOR0_5",
    ceil = "FLAT1",
  --  lift_flat = "FLOOR4_8",

    scenery = "green_column_hrt",
  },


  ---- OUTDOOR ------------

  STONY =
  {
    outdoor = true,
    mat_pri = 5,

    wall = "STONE",
    void = "STONE3",
    step = "STEP4",
    piller = "STONE5",

    floor = "MFLR8_1",
    ceil = "F_SKY1",

    scenery = "blue_torch",
  },

  BROWN =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "BROWN1",
    void = "BROWNPIP",
    step = "STEP5",
    lift = "SUPPORT3",
    pillar = "BROWN96",  -- was "BRONZE2" (not in doom 1)

    floor = "MFLR8_2",  -- "RROCK16" (not in doom 1)
    ceil = "F_SKY1",
  --  lift_flat = "FLOOR4_8",

    scenery = "skull_pole",

    good_liquid = "blood",
  },
}

DM_EXITS =
{
  TECH =
  {
    mat_pri = 9,

    wall = "TEKWALL1",
    void = "TEKWALL4",
    dm_switch = "SW1COMM",

    floor = "CEIL4_3",
    ceil = "TLITE6_5",

    sign = "EXITSIGN",
    sign_bottom="CEIL5_2",

    door = { tex="EXITDOOR", w=64, h=72,
             frame_top="TLITE6_5",
             Xrame_side="BROWN96" },
  },

  STONE =
  {
    mat_pri = 9,

    wall = "STONE2",
    void = "STONE",
    dm_switch = "SW1COMM",

    floor = "FLOOR7_2",  -- FLAT5_2
    ceil  = "FLAT1",

    hole_tex = "MARBLE1",  -- WOOD1
    
    front_mark = "EXITSTON", 

    door = { tex="EXITDOOR", w=64, h=72,
             frame_top="TLITE6_6",
             frame_side="LITE5" },
  },
}

DM_HALLWAYS =
{
  BROWN1 =
  {
    mat_pri = 0,

    wall = "BROWNPIP",
    void = "BROWN1",
    step = "BROWN1",
    pillar = "BROVINE2",

    floor = "FLOOR5_1",
    ceil  = "CEIL5_2",
  },

  SP_ROCK =
  {
    mat_pri = 0,

    wall = "SP_ROCK1",
    void = "SP_ROCK1",
    step = "STEP6",
    pillar = "GRAYVINE",

    floor = "MFLR8_3",
    ceil  = "FLOOR6_2",
  },

  BLUECARPET =
  {
    mat_pri = 0,

    wall = "STARTAN2",
    void = "STARTAN3",
    step = "STEP1",
    pillar = "STARGR2", -- or STARBR2

    floor = "FLAT14",
    ceil  = "TLITE6_4",

    arch_floor = "FLAT20",
    arch_ceil  = "CEIL3_2",

    well_lit = true,
  },
}

---- BASE MATERIALS ------------

DM_MATS =
{
  METAL =
  {
    mat_pri = 5,

    wall  = "METAL",
    void  = "METAL1",
    floor = "CEIL5_2",
    ceil  = "CEIL5_2",
  },

  ARCH =
  {
    wall  = "METAL",
    void  = "METAL1",
    floor = "CEIL5_2",
    ceil  = "CEIL5_2",
  },

  SHINY =
  {
    wall  = "SHAWN2",
    void  = "SHAWN1",
    floor = "FLAT23",
    ceil  = "FLAT23",
  },

  STEP =
  {
    wall  = "STEP1",
    floor = "FLAT1",
  },

  LIFT =
  {
    wall  = "SUPPORT2",
    floor = "STEP2"
  },

  CAGE =
  {
    wall  = "METAL",
    floor = "CEIL5_2",
    ceil  = "TLITE6_4",
  },

  TRACK =
  {
    wall  = "DOORTRAK",
    floor = "FLOOR6_2",
  },

  DOOR_FRAME =
  {
    wall  = "LITE5",
    floor = "FLAT1",
    ceil  = "TLITE6_6",
  },

  SW_FRAME =
  {
    wall  = "LITE5",
    floor = "TLITE6_6",
  },
}

--- PEDESTALS --------------

DM_PEDESTALS =
{
  PLAYER =
  {
    wall = "SHAWN2",  void = "SHAWN2",
    floor = "FLAT22", ceil = "FLAT22",
    h = 8,
  },

  QUEST =
  {
    wall  = "METAL", void = "METAL",
    floor = "GATE4", ceil = "GATE4",
    h = 24,
  },

  WEAPON =
  {
    wall  = "METAL",   void = "METAL",
    floor = "CEIL1_2", ceil = "CEIL1_2",
    h = 12,
  },
}

---- OVERHANGS ------------

DM_OVERHANGS =
{
  METAL =
  {
    ceil = "CEIL5_1",
    upper = "METAL",
    thin = "METAL",
  },

  MARBLE =
  {
    thin = "MARBLE1",
    upper = "MARBLE3",
    ceil = "DEM1_6",
  },

  STONE =
  {
    thin = "STONE",
    upper = "STONE",
    ceil = "FLAT5_4",
  },

  WOOD =
  {
    thin = "WOOD1",
    upper = "WOOD1",
    ceil = "FLAT5_1",
  },
}

---- CRATES ------------

DM_CRATES =
{
  CRATE1 =
  {
    wall = "CRATE1", h=64, floor = "CRATOP2"
  },
  
  CRATE2 =
  {
    wall = "CRATE2", h=64, floor = "CRATOP1"
  },
  
  CRATELIT =
  {
    wall = "CRATELIT", h=128, floor = "CRATOP1"
  },

  GRAY =
  {
    wall = "GRAY2", h=64, floor = "FLAT5_4", can_rotate=true
  },

  ICKWALL =
  {
    wall = "ICKWALL4", h=64, floor = "FLAT19",
    can_rotate=true, can_yshift=64
  },

  SHAWN =
  {
    wall = "SHAWN3", h=64, floor = "FLAT23", can_rotate=true
  },
  
  WOOD3A =
  {
    wall = "WOOD3", h=64, floor = "CEIL1_1",
    side_x_offset=64
  },

  WOOD3B =
  {
    wall = "WOOD3", h=64, floor = "CEIL1_1",
    x_offset=128, y_offset=59, side_x_offset=64
  },

  WOODSKUL =
  {
    wall = "WOOD4", h=64, floor = "CEIL1_1",
    can_rotate=true, can_yshift=59
  },
}


---- ARCH STUFF ------------

DM_LIQUIDS =
{
  { name="water",  floor="FWATER1" },
  { name="blood",  floor="BLOOD1"  }, -- no damage
  { name="nukage", floor="NUKAGE1", sec_kind=5 },  -- 10% damage
  { name="lava",   floor="LAVA1",   sec_kind=16, light=64 }, -- 20% damage
}

DM_SWITCHES =
{
  sw_blue = { wall="COMPBLUE", switch="SW1BLUE" },
  sw_hot  = { wall="SP_HOT1",  switch="SW1HOT" },
  sw_vine = { wall="SKINFACE", switch="SW1SKIN" },
  sw_skin = { wall="GRAYVINE", switch="SW1VINE" },

  sw_metl = { wall="SUPPORT3", switch="SW1GARG",  floor="CEIL5_2", bars=true },
  sw_gray = { wall="GRAY7",    switch="SW1GRAY1", floor="FLAT1",   bars=true },
--FIXME: (not in doom1)  sw_rock = { wall="ROCK3",    switch="SW1ROCK",  floor="RROCK13", bars=true },
--FIXME:  sw_wood = { wall="WOODMET1", switch="SW1WDMET", floor="FLAT5_1", bars=true, stand_h=128 },

  sw_exit = { wall="COMPSPAN", switch="SW1COMP" },
}

DM_DOORS =
{
  -- Note: most of these with h=112 are really 128 pixels
  --       tall, but work fine when truncated/

  d_uac    = { tex="BIGDOOR1", w=128, h=72  },  -- actual height is 96
  d_big1   = { tex="BIGDOOR2", w=128, h=112 },
  d_big2   = { tex="BIGDOOR3", w=128, h=112 },
  d_big3   = { tex="BIGDOOR4", w=128, h=112 },

  d_wood1  = { tex="BIGDOOR5", bottom="CEIL5_2", w=128, h=112 },
  d_wood2  = { tex="BIGDOOR6", bottom="CEIL5_2", w=128, h=112 }, -- this is the real height!
  d_wood3  = { tex="BIGDOOR7", bottom="CEIL5_2", w=128, h=112 },

  -- FIXME: doom 2 only
  --[[
  d_thin1  = { tex="SPCDOOR1", w=64, h=112 },
  d_thin2  = { tex="SPCDOOR2", w=64, h=112 },
  d_thin3  = { tex="SPCDOOR3", w=64, h=112 },
  d_weird  = { tex="SPCDOOR4", w=64, h=112 },
  --]]

  d_small1 = { tex="DOOR1",    w=64, h=72 },
  d_small2 = { tex="DOOR3",    w=64, h=72 },

}

DM_IMAGES =
{
  { wall = "CEMENT1", w=128, h=128, glow=true },
  { wall = "CEMENT2", w=64,  h=64,  floor="MFLR8_3" }
}

DM_LIGHTS =
{
  { tex="LITE3",    w=32 },
  { tex="LITE5",    w=16 },
  { tex="LITEBLU4", w=32 },
--  { tex="REDWALL",  w=32 },

  { flat="CEIL1_2",  side="METAL" },
  { flat="CEIL1_3",  side="WOOD1" },
  { flat="CEIL3_4",  side="STARTAN2" },
  { flat="FLAT2",    side="GRAY5" },
  { flat="FLAT17",   side="GRAY5" },
  { flat="FLOOR1_7", side="SP_HOT1" },

--FIXME (not in doom 1)  { flat="GRNLITE1", side="TEKGREN2" },

  { flat="TLITE6_1", side="METAL" },
  { flat="TLITE6_4", side="METAL" },
  { flat="TLITE6_5", side="METAL" },
  { flat="TLITE6_6", side="METAL" },
}

DM_PICS =
{
  { tex="LITE3",    w=128, h=16 },

  { tex="MARBFACE", w=128, h=128 },
  { tex="MARBFAC2", w=128, h=128 },
  { tex="MARBFAC3", w=128, h=128 },

  { tex="FIRELAVA", w=128, h=128 },
  { tex="FIREMAG1", w=128, h=128 },
  { tex="FIREWALL", w=128, h=112 },

  { tex="SHAWN1",   w=128, h=96  },
  { tex="SKINEDGE", w=128, h=128 },
  { tex="WOOD3",    w=128, h=64  },

--  { tex="SKSPINE2", w=128, h=128, scroll=48 },
--  { tex="SPFACE1",  w=128, h=96,  scroll=48 },

--FIXME  { tex="WOOD10",   w=128, h=128 },
--FIXME  { tex="TEKBRON1", w=128, h=128 },
}

DM_KEY_BITS =
{
  k_blue   = { wall="DOORBLU2", kind_rep=26, kind_once=32, },
  k_yellow = { wall="DOORYEL2", kind_rep=27, kind_once=34, },
  k_red    = { wall="DOORRED2", kind_rep=28, kind_once=33, },
}


---- QUEST STUFF ----------------

DM_QUESTS =
{
  key =
  {
    k_blue=50, k_red=50, k_yellow=50
  },
  switch =
  {
    sw_blue=50, sw_hot=30,
    sw_vine=10, sw_skin=40,
    sw_metl=50, sw_gray=20,
    -- FIXME: sw_rock=10,
    -- FIXME: sw_wood=30, 
  },
  weapon =
  {
    saw=10, super=40, launch=80, plasma=60, bfg=4
  },
  item =
  {
    blue_armor=40, invis=40, mega=25, backpack=25,
    berserk=20, goggle=5, invul=2, map=3
  },
  exit =
  {
    ex_tech=90, ex_stone=30
  }
}


------------------------------------------------------------

-- Monster list
-- ============
--
-- r  : radius
-- h  : height
-- hp : health-points
-- dm : damage can inflict per second (rough approx)
-- fp : firepower needed by player

DM_MONSTERS =
{
  -- FIXME: probs for CLOSET/DEPOT
  zombie    = { prob=81, r=20,h=56, hp=20,  dm=4,  fp=10, cage_fallback=14, hitscan=true, },
  shooter   = { prob=41, r=20,h=56, hp=30,  dm=10, fp=10, cage_prob= 8, hitscan=true, },

  imp       = { prob=90, r=20,h=56, hp=60,  dm=20, fp=20, cage_prob=50, },
  caco      = { prob=90, r=31,h=56, hp=400, dm=45, fp=30, cage_prob=14, float=true },
  baron     = { prob=50, r=24,h=64, hp=1000,dm=45, fp=110,cage_prob= 3, },

  -- MELEE only monsters
  demon     = { prob=80, r=30,h=56, hp=150, dm=25, fp=30, cage_prob=66,melee=true },
  spectre   = { prob=20, r=30,h=56, hp=150, dm=25, fp=30, cage_prob=40,melee=true },
  skull     = { prob=16, r=16,h=56, hp=100, dm=7,  fp=40, cage_prob= 2, melee=true, float=true },

  -- special monsters (only for boss levels)
  cyber     = { prob=1, r=40, h=110,hp=4000,dm=150, fp=150 },
  spider    = { prob=0, r=128,h=100,hp=3000,dm=200, fp=240, hitscan=true },
}

D2_MONSTERS =
{
  gunner    = { prob=17, r=20,h=56, hp=70,  dm=40, fp=40, hitscan=true, cage_prob=70, },
  wolf_ss   = { prob=0.2,r=20,h=56, hp=50,  dm=15, fp=90, hitscan=true, cage_prob=1 },

  revenant  = { prob=70, r=20,h=64, hp=300, dm=55, fp=58, cage_prob=50, },
  knight    = { prob=70, r=24,h=64, hp=500, dm=45, fp=70, cage_prob=50, },
  mancubus  = { prob=95, r=48,h=64, hp=600, dm=80, fp=92, cage_prob=88, },

  arach     = { prob=36, r=64,h=64, hp=500, dm=70, fp=92, cage_prob=95, },
  vile      = { prob=20, r=20,h=56, hp=700, dm=50, fp=120,cage_prob=12, hitscan=true },
  pain      = { prob=14, r=31,h=56, hp=400, dm=88, fp=40, float=true },
}

DM_MONSTER_GIVE =
{
  zombie   = { { ammo="bullet", give=10 } },
  shooter  = { { weapon="shotty" } },
  gunner   = { { weapon="chain" } }
}

-- Weapon list
-- ===========
--
-- per  : ammo per shot
-- rate : firing rate (shots per second)
-- dm   : damage can inflict per shot
-- freq : usage frequency (in the ideal)
-- held : already held at level start

DM_WEAPONS =
{
  fist    = { melee=true, rate=1.5, dm=10, freq=0.1, held=true },
  berserk = { melee=true, rate=1.5, dm=50, freq=10 },
  saw     = { melee=true, rate=8.7, dm=10, freq=2 },

  pistol = { ammo="bullet",         per=1, rate=1.8, dm=10 , freq=10, held=true },
  shotty = { ammo="shell",  give=8, per=1, rate=0.9, dm=70 , freq=81 },
  super  = { ammo="shell",  give=8, per=2, rate=0.6, dm=170, freq=50 },
  chain  = { ammo="bullet", give=20,per=1, rate=8.5, dm=10 , freq=91 },

  launch = { ammo="rocket", give=2, per=1, rate=1.7, dm=90,  freq=50, dangerous=true },
  plasma = { ammo="cell",   give=40,per=1, rate=11,  dm=22 , freq=80 },
  bfg    = { ammo="cell",   give=40,per=40,rate=0.8, dm=450, freq=30 },

  -- Note: Berserk is not really an extra weapon, but a powerup
  -- which makes fist do much more damage.  The effect lasts till
  -- the end of the level, so a weapon is a pretty good fit.
}

-- sometimes a certain weapon is preferred against a certain monster.
-- These values are multiplied with the weapon's "freq" field.

DM_MONSTER_WEAPON_PREFS =
{
  zombie  = { shotty=6.0 },
  shooter = { shotty=6.0 },
  imp     = { shotty=6.0 },
  demon   = { super=3.0, launch=0.3 },
  spectre = { super=3.0, launch=0.3 },

  pain    = { launch=0.1 },
  skull   = { launch=0.1 },

  cyber   = { launch=3.0, bfg=6.0 },
  spider  = { launch=3.0, bfg=9.0 },
}

-- Pickup List
-- ===========

DM_PICKUPS =
{
  bullets    = { stat="bullet", give=10, prob=10 },
  bullet_box = { stat="bullet", give=50, prob=70, clu_max=2 },
  shells     = { stat="shell",  give= 4, prob=30 },
  shell_box  = { stat="shell",  give=20, prob=70, clu_max=4 },

  rockets    = { stat="rocket", give= 1, prob=20 },
  rocket_box = { stat="rocket", give= 5, prob=70, clu_max=4 },
  cells      = { stat="cell",   give=20, prob=30 },
  cell_pack  = { stat="cell",   give=100,prob=70, clu_max=1 },

  potion   = { stat="health", give=1,  prob=30 },
  stimpack = { stat="health", give=10, prob=40 },
  medikit  = { stat="health", give=25, prob=70, clu_max=4 },
  soul     = { stat="health", give=100,prob=15, limit=200, clu_max=1 },

  -- BERSERK and MEGA are quest items

  helmet      = { stat="armor", give=   1, limit=200 },
  green_armor = { stat="armor", give= 100, limit=100, clu_max=1 },
  blue_armor  = { stat="armor", give= 200, limit=200, clu_max=1 },

  -- Note: armor is handled with special code, since
  --       BLUE ARMOR is a quest item.

  -- Note 2: the BACKPACK is a quest item
}

-- DeathMatch stuff
-- ================

DM_DEATHMATCH =
{
  weapons =
  {
    shotty=60, super=40, chain=40, launch=40,
    plasma=20, saw=10, bfg=3
  },

  health =
  { 
    potion=10, stimpack=60, medikit=20
  },

  ammo =
  { 
    bullets=5,  bullet_box=30,
    shells=60,  shell_box=5,
    rockets=10, rocket_box=20,
    cells=40,   cell_pack=1,
  },

  items =
  {
    invis=40, goggle=10, berserk=50,
    soul=5, green_armor=40, blue_armor=5,
  },

  cluster =
  {
    potion = 8, helmet = 8, stimpack = 2,
    bullets = 3, shells = 2, rocket = 4,
  },
}

DM_INITIAL_MODEL =
{
  -- Note: bullet numbers are understated (should be 50)
  -- so that the player isn't forced to empty the pistol.

  health=100, armor=0,
  bullet=20, shell=0, rocket=0, cell=0,
  fist=true, pistol=true,
}


------------------------------------------------------------

D1_THEMES =
{
}

D1_EXITS =
{
}

D1_HALLWAYS =
{
}

D1_CRATES =
{
  COMPUTER =
  {
    wall = "COMPUTE1", h=128, floor = "FLAT23",
    side_x_offset=67
  },

  PLANET1 =
  {
    wall = "PLANET1", h=128, floor = "FLAT23",
    side_x_offset=64
  },
 
  PLANET2 =
  {
    wall = "PLANET1", h=64, floor = "FLAT23",
    x_offset=128, side_y_offset=64
  },
 
  SKIN =
  {
    wall = "SKINBORD", h=64, floor = "CEIL3_3", can_rotate=true
  },
}

D1_RAILS =
{
  r_1 = { tex="BRNSMALC", w=128, h=64  },
  r_2 = { tex="MIDGRATE", w=128, h=128 },
}


------------------------------------------------------------

THEME_FACTORIES["doom_common"] = function()

  return
  {
    ERROR_TEX  = "FIREBLU1",
    ERROR_FLAT = "SFLR6_4",
    SKY_TEX    = "F_SKY1",

    monsters = DM_MONSTERS,
    weapons  = DM_WEAPONS,

    thing_nums = DM_THING_NUMS,

    mon_give       = DM_MONSTER_GIVE,
    mon_weap_prefs = DM_MONSTER_WEAPON_PREFS,
    initial_model  = DM_INITIAL_MODEL,

    pickups = DM_PICKUPS,
    pickup_stats = { "health", "bullet", "shell", "rocket", "cell" },

    quests = DM_QUESTS,
    dm = DM_DEATHMATCH,

    themes    = DM_ROOM_THEMES,
    exits     = DM_EXITS,
    hallways  = DM_HALLWAYS,

    hangs     = DM_OVERHANGS,
    pedestals = DM_PEDESTALS,
    mats      = DM_MATS,
    crates    = DM_CRATES,

    liquids   = DM_LIQUIDS,
    switches  = DM_SWITCHES,
    doors     = DM_DOORS,

    images    = DM_IMAGES,
    lights    = DM_LIGHTS,
    pics      = DM_PICS,
    key_bits  = DM_KEY_BITS,
  }
end


THEME_FACTORIES["doom1"] = function()

  local T = THEME_FACTORIES.doom_common()

  T.themes   = copy_and_merge(T.themes,   D1_THEMES)
  T.exits    = copy_and_merge(T.exits,    D1_EXITS)
  T.hallways = copy_and_merge(T.hallways, D1_HALLWAYS)
  T.crates   = copy_and_merge(T.crates,   D1_CRATES)

  T.rails = D1_RAILS

  -- remove DOOM2-only weapons and items --

  T.weapons = copy_table(T.weapons)
  T.weapons["super"] = nil

  T.quests = copy_table(T.quests)
  T.quests.weapon = copy_table(T.quests.weapon)
  T.quests.weapon["super"] = nil
  T.quests.item = copy_table(T.quests.item)
  T.quests.item["mega"] = nil

  T.dm = copy_table(T.dm)
  T.dm.weapons = copy_table(T.dm.weapons)
  T.dm.weapons["super"] = nil

  return T
end

