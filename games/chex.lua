----------------------------------------------------------------
-- GAME DEF : Chex Quest 3
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

CHEX3 = { }  -- common stuff


CHEX3.ENTITIES =
{
  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 }
  player2 = { id=2, r=16, h=56 }
  player3 = { id=3, r=16, h=56 }
  player4 = { id=4, r=16, h=56 }

  dm_player     = { id=11 }
  teleport_spot = { id=14 }


  --- PICKUPS ---

  k_red    = { id=13 }
  k_yellow = { id=6 }
  k_blue   = { id=5 }

  back_pack      = { id=   8 }
  slime_suit     = { id=2025 }
  allmap         = { id=2026 }

  --- SCENERY ---

  -- tech --

  landing_light = { id=2028,r=16, h=35, light=255 }

  flag_pole  = { id=37, r=16, h=128 }

  chemical_burner = { id=41, r=16, h=25 }
  beaker     = { id=80, r=20, h=64, pass=true }
  gas_tank   = { id=36, r=16, h=40 }
  spaceship  = { id=54, r=32, h=58 }

  -- arboretum --

  cave_bat    = { id=63, r=16, h=64, ceil=true } -- SOLID?
  hang_plant1   = { id=59, r=20, h=64, pass=true, ceil=true } -- new id
  hang_plant2   = { id=61, r=20, h=64, pass=true, ceil=true } -- new id
  hang_pots     = { id=62, r=20, h=64, pass=true, ceil=true }

  -- other --

  slime_fountain = { id=44, r=16, h=48 }


---===========>>


  -- pickups --

  kf_red    = { id=38 }
  kf_yellow = { id=39 }
  kf_blue   = { id=40 }

  goggles   = { id=2045 }

  -- scenery --

  apple_tree  = { id=9060, r=20, h=64 }
  banana_tree = { id=9058, r=20, h=64 }
  beech_tree  = { id=9059, r=20, h=64 }
  orange_tree = { id=9061, r=20, h=64 }
  pine_tree   = { id=30,   r=16, h=130 }
  torch_tree  = { id=43,   r=16, h=128 }

  flower1 = { id=78, r=20, h=25 }
  flower2 = { id=79, r=20, h=25 }

  cave_pillar = { id=73, r=16, h=128 }
  stalactite  = { id=47, r=16, h=50 }
  stalagmite  = { id=74, r=16, h=64 }
  mine_cart   = { id=53, r=16, h=30 }

  smallbush   = { id=81,   r=20, h=4, pass=true }

  dinosaur1   = { id=76, r=60, h=120 }
  dinosaur2   = { id=77, r=60, h=120 }

  statue_david  = { id=9051, r=20, h=64 }
  statue_think  = { id=9052, r=20, h=64 }
  statue_ramses = { id=9053, r=20, h=64 }
  statue_tut    = { id=9054, r=20, h=64 }
  statue_chex   = { id=9055, r=20, h=64 }
  giant_spoon   = { id=9056, r=60, h=64 }

  slimey_meteor = { id=27, r=16, h=30 }

  -- Doom barrel, named the same for compatibility
  barrel = { id=2035, r=15, h=60 }

  candle_stick   = { id=34,  r=20, h=18,  light=255 }
  street_light   = { id=35,  r=16, h=128, light=255 }
  green_torch    = { id=45,  r=16, h=68,  light=255 }
  green_torch_sm = { id=56,  r=16, h=55,  light=255 }
  red_torch      = { id=46,  r=16, h=68,  light=255 }
  red_torch_sm   = { id=57,  r=16, h=26,  light=255 }


  globe_stand    = { id=25, r=16, h=64 }
  lab_coil       = { id=42, r=16, h=90 }
  mappoint_light = { id=85, r=16, h=75 }
  model_rocket   = { id=18, r=20, h=106 }
  monitor        = { id=29, r=16, h=51 }
  wine_barrel    = { id=32, r=16, h=36 }
  radar_dish     = { id=19, r=20, h=121 }
  stool          = { id=49, r=16, h=41 }
  tech_pillar    = { id=48, r=16, h=83 }
  telephone      = { id=28, r=16, h=26, pass=true }

  captive1    = { id=70, r=16, h=65 }
  captive2    = { id=26, r=16, h=65 }
  captive3    = { id=52, r=16, h=65 }
  diner_chef  = { id=23, r=20, h=64 }
  diner_table = { id=22, r=20, h=64 }

  big_bowl    = { id=51, r=40, h=64 }
  grey_rock   = { id=31, r=16, h=36 }
  hydro_plant = { id=50, r=16, h=45 }
  slimey_urn  = { id=86, r=16, h=83 }

  ceiling_slime = { id=60, r=16, h=68, pass=true, ceil=true }
}


CHEX3.PARAMETERS =
{
  rails = true
  light_brushes = true

  -- NOTE: no infighting at all
  infighting = false
  infighting = true

  jump_height = 24

  max_name_length = 28

  skip_monsters = { 10,35 }

  time_factor   = 1.0
  damage_factor = 1.0
  ammo_factor   = 0.8
  health_factor = 0.7
  monster_factor = 0.8
}


----------------------------------------------------------------

CHEX3.MATERIALS =
{
  -- special materials --
  _ERROR = { t="COMPSPAN", f="CEIL5_1" }
  _SKY   = { t="COMPSPAN", f="F_SKY1" }


  -- general purpose --

  METAL  = { t="COMPBLUE", f="STEP1" }
  CAVE   = { t="SKSNAKE2", f="CEIL3_1" }
  VENT   = { t="ASHWALL",  f="FLOOR0_3" }
  WHITE  = { t="SW2SATYR", f="FLAT5_6" }
  DIRT   = { f="FLOOR0_1", t="TEKWALL5" }


  -- walls --

  LIFT = { t="SKSNAKE1", f="STEP1" }

  BLUE_WALL    = { t="SP_DUDE2", f="FLOOR0_2" }
  BLUE_OBSDECK = { t="SLADSKUL", f="FLOOR0_2" }
  BLUE_SLIMED  = { t="SKINMET1", f="FLOOR0_2" }

  GRAY_PIPES   = { t="STONE",    f="FLAT5_6" }
  GRAY_PANELS  = { t="STONE3",   f="FLAT5_6" }
  GRAY_LITE    = { t="LITESTON", f="FLAT5_6" }
  GRAY_STRIPE  = { t="GRAY7",    f="FLAT5_6" }

  ORANGE_TILE   = { t="STARG3",   f="FLAT2" }
  ORANGE_LAB    = { t="COMPUTE3", f="FLAT2" }
  ORANGE_SLIMED = { t="SKINMET2", f="FLAT2" }
  ORANGE_CUPBD  = { t="DOOR3",    f="FLAT2" }
  ORANGE_CABNET = { t="CEMENT4",  f="FLAT2" }
  ORANGE_LOCKER = { t="CEMENT6",  f="FLAT2" }

  ORANGE_MATH   = { t="CEMPOIS",  f="FLAT2" }
  ORANGE_BOOKS  = { t="BRNSMALL", f="FLAT2" }
  ORANGE_DIAG   = { t="BRNSMALR", f="FLAT2" }
  ORANGE_MAP    = { t="BROWN96",  f="FLAT2" }

  STEEL1      = { t="CEMENT1",  f="CEIL3_2" }
  STEEL2      = { t="CEMENT5",  f="CEIL3_2" }
  STEEL_LITE  = { t="LITE96",   f="CEIL3_2" }
  STEEL_GRATE = { t="REDWALL1", f="CEIL3_2" }

  STARPORT  = { t="CEMENT2", f="FLAT5_6" }

  TAN1      = { t="TEKWALL5", f="FLAT1" }
  TAN2      = { t="BROWN1",   f="FLAT1" }
  TAN_LITE  = { t="LITE2",    f="FLAT1" }
  TAN_GRATE = { t="BRNSMAL1", f="FLAT1" }
  TAN_VINE  = { t="BROVINE",  f="FLAT1" }

  COMPUTE_1 = { t="COMP2",    f="FLAT5_6" }
  COMPUTE_2 = { t="COMPUTE2", f="FLAT5_6" }
  COMP_BOX  = { t="COMPWERD", f="FLAT5_6" }
  COMP_SPAN = { t="COMPSPAN", f="FLAT5_6" }

  CUPBOARD = { t="BRNBIGC",  f="FLAT1" }

  CAVE_GLOW    = { t="BLODRIP2", f="CEIL3_1" }
  CAVE_LITE    = { t="SKULWAL3", f="CEIL3_1" }
  CAVE_CRACK   = { t="STARTAN2", f="CEIL3_1" }
  CAVE_SUPPORT = { t="PIPE6",    f="CEIL3_2" }

  PIC_PLANET  = { t="SKINCUT",  f="CEIL4_1" }
  PIC_DIPLOMA = { t="EXITDOOR", f="CEIL4_1" }
  PIC_PHOTO1  = { t="TEKWALL4", f="CEIL4_1" }
  PIC_PHOTO2  = { t="SLADWALL", f="CEIL4_1" }

  TELE_CHAMBER = { t="SLADRIP1", f="FLAT5_6" }

  MET_SLADS = { t="SP_DUDE4", f="STEP1" }

  STEP_ORANGE = { t="STEP1",    f="FLAT2" }
  STEP_GRAY   = { t="STEP2",    f="FLAT5_6" }
  STEP_WHITE  = { t="SW2SATYR", f="FLAT5_6" }
  STEP_CAVE   = { t="SKSNAKE2", f="CEIL3_1" }


  -- floors --

  CEIL_LITE = { f="CEIL3_5",  t="SW2SATYR" }

  VERYDARK_BLUE = { f="CEIL4_1",  t="SP_DUDE2" }
  ANOTHER_BLUE  = { f="FLOOR1_1", t="SP_DUDE2" }
  BLUE_CARPET   = { f="FLAT14",   t="SP_DUDE2" }

  CAVE_POOL = { f="FLAT19", t="SKSNAKE2" }

  TELE_GATE = { f="GATE1", t="SP_DUDE4" }

  DARK_GRAY = { f="CEIL5_1", t="TEKWALL5" }
  RED_FLOOR = { f="FLAT1",   t="SP_DUDE6" }

  -- NOTE: these two floor logos don't exist as flats in Chex 3,
  --       but they _do_ exist as single textures.
  IGC_LOGO_TL = { f="DEM1_1", t="SP_DUDE2" }
  IGC_LOGO_TR = { f="DEM1_2", t="SP_DUDE2" }
  IGC_LOGO_BL = { f="DEM1_3", t="SP_DUDE2" }
  IGC_LOGO_BR = { f="DEM1_4", t="SP_DUDE2" }

  CAFE_LOGO_TL = { f="FLAT3", t="COMPSPAN" }
  CAFE_LOGO_TR = { f="FLAT4", t="COMPSPAN" }
  CAFE_LOGO_BL = { f="FLAT8", t="COMPSPAN" }
  CAFE_LOGO_BR = { f="FLAT9", t="COMPSPAN" }


  -- doors --

  TRACK = { t="COMPSTA1", f="STEP1" }

  DOOR_GRATE = { t="BIGDOOR1", f="FLAT5_6" }
  DOOR_ALUM  = { t="DOOR1",    f="FLAT5_6" }
  DOOR_METER = { t="DOORBLU2", f="FLAT5_6" }

  DOOR_BLUE   = { t="BRNBIGR",  f="FLAT5_6" }
  DOOR_RED    = { t="BRNBIGL",  f="FLAT5_6" }
  DOOR_YELLOW = { t="BRNSMAL2", f="FLAT5_6" }

  DOOR_LAB   = { t="BIGDOOR4", f="FLAT5_6" }
  DOOR_ARBOR = { t="BIGDOOR5", f="FLAT2" }
  DOOR_HYDRO = { t="BIGDOOR6", f="FLAT2" }

  WDOOR_HANGER1 = { t="STARTAN3", f="FLAT1" }
  WDOOR_HANGER2 = { t="SKINFACE", f="FLAT1" }

  WDOOR_ARBOR = { t="SKINSCAB", f="CEIL5_1" }
  WDOOR_MINES = { t="SKINSYMB", f="FLAT5_6" }
  WDOOR_FRIDGE = { t="SKINTEK1", f="FLAT5_6" }

  LITE_RED    = { t="DOORRED", f="CEIL4_1" }
  LITE_BLUE   = { t="DOORBLU", f="CEIL4_1" }
  LITE_YELLOW = { t="DOORYEL", f="CEIL4_1" }


  -- switches --

  SW_METAL   = { t="SW2BLUE",  f="STEP1" }
  SW_CAVE    = { t="SW1BRCOM", f="CEIL3_2" }
  SW_BROWN2  = { t="SW1BRN2",  f="FLAT1" }
  SW_TAN     = { t="SW1METAL", f="FLAT1"  }

  SW_GRAY    = { t="SW1COMM",  f="FLAT5_6" }
  SW_COMPUTE = { t="SW1COMP",  f="FLAT5_6"  }
  SW_PIPEY   = { t="SW1STON1", f="FLAT5_6"  }


  -- rails --

  VINE1  = { t="MIDVINE1", rail_h=128 }
  VINE2  = { t="MIDVINE2", rail_h=128 }


  -- liquids --

  WATER  = { t="GSTFONT1", f="FWATER1", sane=1 }
  SLIME1 = { t="FIREMAG1", f="NUKAGE1", sane=1 }
  SLIME2 = { t="FIREMAG1", f="LAVA1",   sane=1 }


---===========>>


  -- Chex 1 compatibility --

  BLUE_SFALL  = { t="BLODGR1",  f="CEIL4_1" }

  CAVE_SLIMY1 = { t="PIPE4",    f="CEIL3_1" }
  CAVE_SLIMY2 = { t="MARBLE2",  f="CEIL3_1" }
  CAVE_SLIMY3 = { t="STARGR1",  f="CEIL3_1" }
  CAVE_EDGER  = { t="NUKEDGE1", f="CEIL3_1" }
  CAVE_SPLAT  = { t="NUKEPOIS", f="CEIL3_1" }

  COMPUTE_3   = { t="COMPTALL", f="FLAT5_6" }

  PIC_SLIMED  = { t="SLADPOIS", f="CEIL4_1" }
  PIC_STORAGE = { t="MARBFAC3", f="FLAT2" }

  SW_STEEL    = { t="SW2WOOD", f="CEIL3_2" }  -- Note: different size!

  HYDROPON_1 = { t="HYDROPO1", f="FLAT1" }
  HYDROPON_2 = { t="HYDROPO2", f="FLAT1" }
  HYDROPON_3 = { t="HYDROPO3", f="FLAT1" }



  CRUD_LITE = { f="STOOREST", t="COMPSPAN" }

  -- better tops on these
  CRATE1   = { t="CRATE1",   f="CRATOP2" }
  CRATE2   = { t="CRATE2",   f="CRATOP1" }
  CRATEMIX = { t="CRATELIT", f="CRATOP1" }
  CRATWIDE = { t="CRATWIDE", f="CRATOP1" }

  ---- these two textures are not present in Chex 3
  -- GRAY_FLOWER1 = { t="STONE3", f="FLAT5_6" }
  -- GRAY_FLOWER2 = { t="STONE3", f="FLAT5_6" }


  -- Chex 2 compatibility --

  HEDGE  = { t="HEDGE",  f="HEDGEF" }
  BEIGE  = { t="MUSEUM", f="BROWN" }

  GREEN_BRICK  = { t="SEWER1",   f="ENDFLAT2" }
  GREEN_BORDER = { t="SEWER2",   f="ENDFLAT2" }
  GREEN_SIGN   = { t="SEWER4",   f="ENDFLAT2" }
  GREEN_GRATE  = { t="WORMHOL3", f="ENDFLAT2" }

  MARB_GREEN  = { t="BROWN144", f="CEIL5_1" } -- no good flat!
  MARB_RED    = { t="PLUSH", f="CFLAT2" }  -- texture not present in Chex 3

  RED_CURTAIN = { t="THEAWALL", f="CFLAT2" }

  MOVIE_PRAM    = { t="MOVIE2A", f="CEIL5_1" }
  MOVIE_MOUSE   = { t="MOVIE1A", f="CEIL5_1" }
  MOVIE_CHARLES = { t="MOVIE3A", f="CEIL5_1" }

  PIC_EAT_EM = { t="CHEXAD1", f="CEIL5_1" }
  PIC_LUV_EM = { t="CHEXAD2", f="CEIL5_1" }
  PIC_HUNGRY = { t="HUNGRY",  f="FLAT1" }

  PIC_MONA    = { t="MONA",     f="CEIL5_1" }
  PIC_VENUS   = { t="VENUSHS",  f="CEIL5_1" }
  PIC_VINCENT = { t="VINCENT",  f="CEIL5_1" }
  PIC_SCREAM  = { t="MUNCH",    f="CEIL5_1" }
  PIC_NUN     = { t="SW1STRTN", f="CEIL5_1" }
  PIC_BORING  = { t="ART2",     f="CEIL5_1" }

  SIGN_ENTER    = { t="CHEXCITY", f="CEIL5_1" }  -- Note: now has windows on top
  SIGN_WELCOME1 = { t="SPDOOR",   f="CEIL5_1" }
  SIGN_WELCOME2 = { t="SPACPORT", f="CEIL5_1" }  -- Note: now has windows on top
  SIGN_GALACTIC = { t="NUKE24",   f="CEIL5_1" }

  SIGN_DINER    = { t="DINESIGN", f="CEIL5_1" }  -- Note: now has windows on top
  SIGN_MUSEUM   = { t="MUSEUM2",  f="CEIL5_1" }
  SIGN_SEWER    = { t="SEWER3",   f="ENDFLAT2" }
  SIGN_CINEMA   = { t="CINEMA",   f="CEIL5_1" }

  BLUE_POSTER1 = { t="POSTER1", f="FLOOR1_1" }
  BLUE_POSTER2 = { t="POSTER2", f="FLOOR1_1" }
  BLUE_POSTER3 = { t="POSTER3", f="FLOOR1_1" }
  BLUE_CUPBD   = { t="CARPET_A", f="FLOOR1_1" }  -- texture not present

  TAN_THEATRE1 = { t="THEATRE1", f="FLOOR1_1" }  --\
  TAN_THEATRE2 = { t="THEATRE2", f="FLOOR1_1" }  -- Note: on blue walls now
  TAN_THEATRE3 = { t="THEATRE3", f="FLOOR1_1" }  --/
  TAN_MENU     = { t="FOODMENU", f="FLAT2" }

  BENCH_CANDY   = { t="CANDY",   f="CEIL5_1" }
  BENCH_POPCORN = { t="POPCORN", f="CEIL5_1" }

  GRAY_FLOOR = { f="CJFCOMM3", t="COMPSPAN" }

  BROWN_TILE = { f="MUFLOOR2", t="COMPSPAN" }
  WHITE_TILE = { f="CEIL3_2",  t="SW2SATYR" }  -- flat not present
  GREEN_TILE = { f="SLUGBRIK", t="SEWER1" }
  RED_TILE   = { f="CJFLOD06", t="STONE3" }  -- flat not present, grrr!


  --- new Chex 1 / 2 stuff ---

  PLUSH = { t="PLUSH", f="CFLAT2" }

  CINEMA_FLASHY = { t="ROCKRED1", f="CEIL5_1" }

  CAVE_ROCKY = { t="BAZOIK", f="CEIL3_1" }

  GREEN_PIPE1 = { t="SEWER_A", f="ENDFLAT2" }
  GREEN_PIPE2 = { t="SEWER_B", f="ENDFLAT2" }

  PIC_PAINTING  = { t="ART1",  f="CEIL5_1" }

  BLUE_SLOPE_DN = { t="STONPOIS", f="FLAT5_6" }  -- NB: 256 units tall
  BLUE_SLOPE_UP = { t="SUPPORT2", f="FLAT5_6" }  -- 

  TAN_STORAGE  = { t="STORAGE",  f="FLAT1" }
  STEEL_GRATE2 = { t="WORMHOL1", f="CEIL3_2" }

  STARPORT_METER  = { t="GSTONE2", f="FLAT5_6" }

  WDOOR_HYDRO1 = { t="CJHYDRO1", f="FLAT5_6" }


  ---- TOTALLY NEW STUFF ----

  -- walls --

  CHEX_METRO = { t="PLAT2", f="FLOOR1_1" }

  PIPE_TALL = { t="PIPE2", f="FLAT2" }

  GRAY_BRICKS  = { t="BROWNHUG", f="FLAT5_6" }
  BRICK_WALL   = { t="SP_DUDE1", f="BROWN" }
  BRICK_W_ARCH = { t="ICKDOOR1", f="BROWN" }
  BRICK_W_COL  = { t="WOOD1",    f="BROWN" }

  ANIM_TRAJECT = { t="FIREBLU1", f="CEIL5_1" }
  ANIM_FLOURO  = { t="FIREWALB", f="LABFLAT" }
  ANIM_PLASMA  = { t="FIRELAV3", f="FLOOR0_3" }

  SHIP_WINDOW1 = { t="ICKWALL3", f="XX" }
  SHIP_WINDOW2 = { t="ICKWALL4", f="XX" }

  CJBLUDR0 = { t="CJBLUDR0", f="XX" }
  CJCELR01 = { t="CJCELR01", f="XX" }
  CJCLIF01 = { t="CJCLIF01", f="XX" }
  CJCLIF02 = { t="CJCLIF02", f="XX" }
  CJCRAT01 = { t="CJCRAT01", f="XX" }
  CJCRAT02 = { t="CJCRAT02", f="XX" }
  CJCRAT03 = { t="CJCRAT03", f="XX" }
  CJCRAT04 = { t="CJCRAT04", f="XX" }
  CJCRAT05 = { t="CJCRAT05", f="XX" }

  CJCOMM01 = { t="CJCOMM01", f="XX" }
  CJCOMM02 = { t="CJCOMM02", f="XX" }
  CJCOMM03 = { t="CJCOMM03", f="XX" }
  CJCOMM04 = { t="CJCOMM04", f="XX" }
  CJCOMM05 = { t="CJCOMM05", f="XX" }
  CJCOMM06 = { t="CJCOMM06", f="XX" }
  CJCOMM07 = { t="CJCOMM07", f="XX" }
  CJCOMM08 = { t="CJCOMM08", f="XX" }
  CJCOMM09 = { t="CJCOMM09", f="XX" }
  CJCOMM10 = { t="CJCOMM10", f="XX" }

  CJCOMM11 = { t="CJCOMM11", f="XX" }
  CJCOMM12 = { t="CJCOMM12", f="XX" }
  CJCOMM13 = { t="CJCOMM13", f="XX" }
  CJCOMM14 = { t="CJCOMM14", f="XX" }
  CJCOMM15 = { t="CJCOMM15", f="XX" }
  CJCOMM16 = { t="CJCOMM16", f="XX" }
  CJCOMM17 = { t="CJCOMM17", f="XX" }
  CJCOMM18 = { t="CJCOMM18", f="XX" }
  CJCOMM19 = { t="CJCOMM19", f="XX" }
  CJCOMM20 = { t="CJCOMM20", f="XX" }
  CJCOMM21 = { t="CJCOMM21", f="XX" }
  CJCOMM22 = { t="CJCOMM22", f="XX" }
  CJCOMM23 = { t="CJCOMM23", f="XX" }

  CJDOOR01 = { t="CJDOOR01", f="XX" }
  CJDOOR02 = { t="CJDOOR02", f="XX" }
  CJDOOR03 = { t="CJDOOR03", f="XX" }
  CJDOOR04 = { t="CJDOOR04", f="XX" }
  CJFLDR01 = { t="CJFLDR01", f="XX" }
  CJFLDR02 = { t="CJFLDR02", f="XX" }
  CJFLDR03 = { t="CJFLDR03", f="XX" }
  CJFLDR04 = { t="CJFLDR04", f="XX" }
  CJFLDR05 = { t="CJFLDR05", f="XX" }

  CJLODG01 = { t="CJLODG01", f="XX" }
  CJLODG02 = { t="CJLODG02", f="XX" }
  CJLODG03 = { t="CJLODG03", f="XX" }
  CJLODG04 = { t="CJLODG04", f="XX" }
  CJLODG05 = { t="CJLODG05", f="XX" }
  CJLODG06 = { t="CJLODG06", f="XX" }
  CJLODG07 = { t="CJLODG07", f="XX" }
  CJLODG08 = { t="CJLODG08", f="XX" }
  CJLODG09 = { t="CJLODG09", f="XX" }
  CJLODG10 = { t="CJLODG10", f="XX" }
  CJLODG11 = { t="CJLODG11", f="XX" }
  CJLODG12 = { t="CJLODG12", f="XX" }
  CJLODG13 = { t="CJLODG13", f="XX" }
  CJLODG14 = { t="CJLODG14", f="XX" }
  CJLODG15 = { t="CJLODG15", f="XX" }
  CJLODG16 = { t="CJLODG16", f="XX" }
  CJLODG17 = { t="CJLODG17", f="XX" }

  CJMETE01 = { t="CJMETE01", f="XX" }
  CJMINE01 = { t="CJMINE01", f="CJFMINE1" }
  CJMINE02 = { t="CJMINE02", f="CJFMINE1" }
  CJREDDR0 = { t="CJREDDR0", f="XX" }
  CJSHIP01 = { t="CJSHIP01", f="XX" }
  CJSHIP02 = { t="CJSHIP02", f="XX" }
  CJSHIP03 = { t="CJSHIP03", f="XX" }
  CJSHIP04 = { t="CJSHIP04", f="XX" }
  CJSHIP05 = { t="CJSHIP05", f="XX" }

  CJSPLAT1 = { t="CJSPLAT1", f="XX" }
  CJSW1_1  = { t="CJSW1_1",  f="XX" }
  CJSW1_2  = { t="CJSW1_2",  f="XX" }
  CJTRAI01 = { t="CJTRAI01", f="XX" }
  CJTRAI02 = { t="CJTRAI02", f="XX" }
  CJTRAI03 = { t="CJTRAI03", f="XX" }
  CJTRAI04 = { t="CJTRAI04", f="XX" }
  CJYELDR0 = { t="CJYELDR0", f="XX" }

  CJVILL01 = { t="CJVILL01", f="XX" }
  CJVILL02 = { t="CJVILL02", f="XX" }
  CJVILL03 = { t="CJVILL03", f="XX" }
  CJVILL04 = { t="CJVILL04", f="XX" }
  CJVILL05 = { t="CJVILL05", f="XX" }
  CJVILL06 = { t="CJVILL06", f="XX" }
  CJVILL07 = { t="CJVILL07", f="XX" }
  CJVILL09 = { t="CJVILL09", f="XX" }
  CJVILL10 = { t="CJVILL10", f="XX" }
  CJVILL11 = { t="CJVILL11", f="XX" }

  CJCOMM24 = { t="CJCOMM24", f="XX" }
  CJCITY01 = { t="CJCITY01", f="XX" }
  CJLOGO1  = { t="CJLOGO1",  f="XX" }
  CJLOGO2  = { t="CJLOGO2",  f="XX" }
  CJSHIPBG = { t="CJSHIPBG", f="XX" }

  -- floors --

  BOOTHF1 = { f="BOOTHF1", t="XX" }
  BOOTHF2 = { f="BOOTHF2", t="XX" }
  BOOTHF3 = { f="BOOTHF3", t="XX" }
  BOOTHF4 = { f="BOOTHF4", t="XX" }

  CJFCOMM1 = { f="CJFCOMM1", t="XX" }
  CJFCOMM2 = { f="CJFCOMM2", t="XX" }
  CJFCOMM3 = { f="CJFCOMM3", t="XX" }
  CJFCOMM4 = { f="CJFCOMM4", t="XX" }
  CJFCOMM5 = { f="CJFCOMM5", t="XX" }
  CJFCOMM6 = { f="CJFCOMM6", t="XX" }
  CJFCOMM7 = { f="CJFCOMM7", t="XX" }

  CJFCRA01 = { f="CJFCRA01", t="XX" }
  CJFCRA02 = { f="CJFCRA02", t="XX" }
  CJFCRA03 = { f="CJFCRA03", t="XX" }
  CJFFLEM1 = { f="CJFFLEM1", t="XX" }
  CJFFLEM2 = { f="CJFFLEM2", t="XX" }
  CJFFLEM3 = { f="CJFFLEM3", t="XX" }
  CJFGRAS1 = { f="CJFGRAS1", t="XX" }

  CJFLOD01 = { f="CJFLOD01", t="XX" }
  CJFLOD02 = { f="CJFLOD02", t="XX" }
  CJFLOD03 = { f="CJFLOD03", t="XX" }
  CJFLOD04 = { f="CJFLOD04", t="XX" }
  CJFLOD05 = { f="CJFLOD05", t="XX" }
  CJFLOD06 = { f="CJFLOD06", t="XX" }
  CJFLOD07 = { f="CJFLOD07", t="XX" }
  CJFLOD08 = { f="CJFLOD08", t="XX" }
  CJFMINE1 = { f="CJFMINE1", t="XX" }
  CJFSHIP1 = { f="CJFSHIP1", t="XX" }
  CJFSHIP2 = { f="CJFSHIP2", t="XX" }
  CJFSHIP3 = { f="CJFSHIP3", t="XX" }

  CJFTRA01 = { f="CJFTRA01", t="XX" }
  CJFTRA02 = { f="CJFTRA02", t="XX" }
  CJFTRA03 = { f="CJFTRA03", t="XX" }
  CJFTRA04 = { f="CJFTRA04", t="XX" }
  CJFVIL01 = { f="CJFVIL01", t="XX" }
  CJFVIL02 = { f="CJFVIL02", t="XX" }
  CJFVIL03 = { f="CJFVIL03", t="XX" }
  CJFVIL04 = { f="CJFVIL04", t="XX" }
  CJFVIL05 = { f="CJFVIL05", t="XX" }
  CJFVIL06 = { f="CJFVIL06", t="XX" }

  MARS_GROUND = { f="ENDFLAT3", t="XX" }

  SIMPLE_TILE = { f="FLAT1_1", t="XX" }
  WOOD_CRATOP = { f="FLAT5_7", t="XX" }
  YELLOWISH   = { f="FLAT5_8", t="XX" }

  FLOURO_LITE = { f="LABFLAT", t="XX" }

  STEEL32 = { f="STEEL32", t="XX" }
  STEEL64 = { f="STEEL64", t="XX" }


  -- rails --

  VILL_BARS   = { t="CJVILL08", rail_h=128, line_flags=1 }
  TI_GRATE    = { t="TI_GRATE", rail_h=64  }
  BRIDGE_RAIL = { t="LITEMET",  rail_h=128 }

  CAVE_COLUMN = { t="SKSPINE1", rail_h=128 }
  ORANGE_HOLE = { t="STARG1",   rail_h=128 }


  -- other --

  O_BOLT   = { t="SP_ROCK1", f="O_BOLT",   sane=1 }
  O_PILL   = { t="SP_ROCK2", f="O_PILL",   sane=1 }
  O_RELIEF = { t="MIDBRN1",  f="O_RELIEF", sane=1 }
  O_CARVE  = { t="NUKESLAD", f="O_CARVE",  sane=1 }
  O_NEON   = { t="TEKWALL2", f="CEIL4_1",  sane=1 }

}


CHEX3.LIQUIDS =
{
  water  = { mat="WATER", light=0.65 }

  -- these look very similar
  slime1 = { mat="SLIME1", light=0.65, special=5 }
  slime2 = { mat="SLIME2", light=0.65, special=5 }
}


----------------------------------------------------------------

CHEX3.SKINS =
{
  ----| STARTS |----

  Start_basic =
  {
    _prefab = "START_SPOT"
    _where  = "middle"

    top = "O_BOLT"
  }


  ----| EXITS |----

  Exit_pillar =
  {
    _prefab = "EXIT_PILLAR",
    _where  = "middle"

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
    _where  = "floor"
    _deltas = { 32,48,48,64,64,80 }
  }

  Stair_Down1 =
  {
    _prefab = "NICHE_STAIR_8"
    _where  = "floor"
    _deltas = { -32,-48,-64,-64,-80,-96 }
  }

  Lift_Up1 =
  {
    _prefab = "LIFT_UP"
    _where  = "floor"
    _tags   = 1
    _deltas = { 96,128,160,192 }

    lift = "LIFT"
     top = "LIFT"

    walk_kind   = 88
    switch_kind = 62
  }

  Lift_Down1 =
  {
    _prefab = "LIFT_DOWN"
    _where  = "floor"
    _tags   = 1
    _deltas = { -96,-128,-160,-192 }

    lift = "LIFT"
     top = "LIFT"

    walk_kind   = 88
    switch_kind = 62
  }


  ---| LOCKED DOORS |---

  Locked_blue =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_blue"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112
    door_h = 112
    door = "DOOR_BLUE"
    key = "LITE_BLUE"
    track = "TRACK"

    special = 32
    tag = 0
  }

  Locked_yellow =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_yellow"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "DOOR_YELLOW"
    key = "LITE_YELLOW"
    track = "TRACK"

    special = 34
    tag = 0
  }

  Locked_red =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _key    = "k_red"
    _long   = 192
    _deep   = 32

    w = 128
    h = 112

    door_h = 112
    door = "DOOR_RED"
    key = "LITE_RED"
    track = "TRACK"

    special = 33
    tag = 0
  }


  ---| SWITCHED DOORS |---

  Door_SW_alum =
  {
    _prefab = "DOOR"
    _where  = "edge"
    _switch = "sw_alum"
    _long = 192
    _deep = 32

    w = 128
    h = 112

    door = "DOOR_ALUM"
    track = "TRACK"

    door_h = 112
    special = 0
  }

  Switch_alum =
  {
    _prefab = "SMALL_SWITCH"
    _where  = "middle"
    _switch = "sw_alum"

    switch_h = 64
    switch = "SW_METAL"
    side = "LITE2"
    base = "LITE2"
    x_offset = 0
    y_offset = 50
    special = 103
  }


  ---| PICTURES |---

  Pic_Logo =
  {
    _prefab = "PICTURE"
    _where  = "edge"
    _long   = 192

    pic   = "CJLOGO1" 
    pic_w = 128
    pic_h = 128

    light = 48
  }


  ---| HALLWAY PIECES |---

  Hall_Basic_I =
  {
    _prefab = "HALL_BASIC_I"
    _shape  = "I"
  }

  Hall_Basic_C =
  {
    _prefab = "HALL_BASIC_C"
    _shape  = "C"
  }

  Hall_Basic_T =
  {
    _prefab = "HALL_BASIC_T"
    _shape  = "T"
  }

  Hall_Basic_P =
  {
    _prefab = "HALL_BASIC_P"
    _shape  = "P"
  }

  Hall_Basic_I_Stair =
  {
    _prefab = "HALL_BASIC_I_STAIR"
    _shape  = "IS"
  }

  Hall_Basic_I_Lift =
  {
    _prefab = "HALL_BASIC_I_LIFT"
    _shape  = "IL"
    _tags   = 1

    lift = "LIFT"
    top  = "LIFT"

    raise_W1 = 130
    lower_WR = 88  -- 120
    lower_SR = 62  -- 123
  }
}


----------------------------------------------------------------

CHEX3.THEME_DEFAULTS =
{
  starts = { Start_basic = 50 }

  exits = { Exit_pillar = 50 }

  stairs = { Stair_Up1 = 50, Stair_Down1 = 50,
             Lift_Up1 = 20, Lift_Down1 = 20 }

  keys = { k_red=50, k_blue=50, k_yellow=50 }

  switches = { sw_alum=50 }

  switch_fabs = { Switch_alum = 50 }

  locked_doors = { Locked_blue=50, Locked_red=50, Locked_yellow=50,
                   Door_SW_alum = 50 }

  logos = { Pic_Logo=50 }

  hallway_groups = { basic = 50 }

  mini_halls = { Hall_Basic_I = 50 }
}


CHEX3.NAME_THEMES =
{
}


CHEX3.HALLWAY_GROUPS =
{
  basic =
  {
    pieces =
    {
      Hall_Basic_I = 50
      Hall_Basic_C = 50
      Hall_Basic_T = 50
      Hall_Basic_P = 50

      Hall_Basic_I_Stair = 20
      Hall_Basic_I_Lift  = 2
    }
  }
}


CHEX3.ROOM_THEMES =
{
  Tech_generic =
  {
    walls =
    {
      BLUE_WALL = 30
      GRAY_PANELS = 10
      GRAY_PIPES = 20
      GRAY_STRIPE = 10
      ORANGE_TILE = 30
      TAN1 = 10
      TAN2 = 10
    }

    floors =
    {
      DARK_GRAY = 50
      BLUE_CARPET = 50
      ORANGE_TILE = 50
      VERYDARK_BLUE = 50
    }

    ceilings =
    {
      CEIL4_1 = 50
    }
  }

  Cave_generic =
  {
    naturals =
    { 
      CAVE = 50
      CJMINE02 = 15
    }
  }

  Outdoors_generic =
  {
    floors =
    {
      RED_FLOOR = 50
      DARK_GRAY = 50
      TAN1 = 50
    }

    naturals =
    {
      DIRT = 50
    }
  }

  -- TODO: Outdoor_space_port
}


CHEX3.LEVEL_THEMES =
{
--?? TECH, ARBORETUM and CAVE ??

  chex_tech1 =
  {
    prob = 50

    liquids = { water=50, slime1=50, slime2=50 }

    buildings = { Tech_generic=50 }
    
    caves = { Cave_generic=50 }

    outdoors = { Outdoors_generic=50 }

    -- hallways = { blah }
  }
}


------------------------------------------------------------

-- Monster list
-- ============

-- nearly all the settings below for monsters, weapons and items
-- are the same as for DOOM, except the probabilities.

CHEX3.MONSTERS =
{
  commonus =
  {
    id = 3004
    r = 20
    h = 56
    prob = 60
    health = 20
    attack = "melee"
    damage = 4
  }

  bipedicus =
  {
    id = 9
    r = 20
    h = 56
    prob = 45
    health = 30
    attack = "melee"
    damage = 10
  }

  armored_biped =
  {
    id = 3001
    r = 20
    h = 56
    prob = 35
    crazy_prob = 65
    health = 60
    attack = "missile"
    damage = 20
  }

  quadrumpus =
  {
    id = 9057
    r = 20
    h = 56
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
    id = 58  
    r = 30
    h = 56
    prob = 30
    health = 150
    attack = "melee"
    damage = 25
    weap_prefs = { zorch_propulsor=0.5 }
  }

  larva =
  {
    id = 9050
    r = 30
    h = 56
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
    id = 3006
    r = 16
    h = 56
    prob = 20
    health = 100
    attack = "melee"
    damage = 7
    density = 0.7
    float = true
  }

  stridicus =
  {
    id = 3002
    r = 30
    h = 56
    prob = 20
    health = 225
    attack = "melee"
    damage = 25
    density = 0.7
  }

  super_cyclop =
  {
    id = 3005
    r = 31
    h = 56
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
    id = 69
    r = 64
    h = 64
    health = 1000
    attack = "missile"
    damage = 45
    weap_prefs = { laz_device=3.0 }
  }

  Maximus =
  {
    id = 3003
    r = 24
    h = 64
    prob = 2
    health = 1000
    attack = "missile"
    damage = 45
    density = 0.3
    weap_prefs = { laz_device=3.0 }
  }

  Snotfolus =
  {
    id = 16
    r = 40
    h = 110
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
    id = 7
    r = 100
    h = 100
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


-- Weapon list
-- ===========

CHEX3.WEAPONS =
{
  spoon =
  {
    attack = "melee"
    rate = 1.5
    damage = 10
  }

  super_bootspork =
  {
    id = 2005
    add_prob = 2
    start_prob = 1
    pref = 3
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
    id = 2002
    add_prob = 35
    start_prob = 40
    pref = 70
    attack = "hitscan"
    rate = 8.5
    damage = 10
    ammo = "mzorch"
    per = 1
    give = { {ammo="mzorch",count=20} }
  }

  large_zorcher =
  {
    id = 2001
    add_prob = 10
    start_prob = 60
    pref = 70
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
    id = 2003
    add_prob = 25
    start_prob = 10
    rarity = 2
    pref = 50
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
    id = 2004
    add_prob = 13
    start_prob = 5
    rarity = 2
    pref = 90
    attack = "missile"
    rate = 11
    damage = 20
    ammo = "phase"
    per = 1
    give = { {ammo="phase",count=40} }
  }

  laz_device =
  {
    id = 2006
    add_prob = 30
    start_prob = 0.2
    rarity = 5
    pref = 30
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

CHEX3.PICKUPS =
{
  -- HEALTH --

  water =
  {
    id = 2014
    prob = 20
    cluster = { 4,7 }
    give = { {health=1} }
  }

  fruit =
  {
    id = 2011
    prob = 60
    cluster = { 2,5 }
    give = { {health=10} }
  }

  vegetables =
  {
    id = 2012
    prob = 100
    cluster = { 1,3 }
    give = { {health=25} }
  }

  supercharge =
  {
    id = 2013
    prob = 3
    big_item = true
    give = { {health=150} }
  }

  -- ARMOR --

  repellent =
  {
    id = 2015
    prob = 10
    armor = true
    cluster = { 4,7 }
    give = { {health=1} }
  }

  armor =
  {
    id = 2018
    prob = 5
    armor = true
    big_item = true
    give = { {health=30} }
  }

  super_armor =
  {
    id = 2019
    prob = 2
    armor = true
    big_item = true
    give = { {health=90} }
  }

  -- AMMO --

  mini_zorch =
  {
    id = 2007
    prob = 10
    cluster = { 2,5 }
    give = { {ammo="mzorch",count=10} }
  }

  mini_pack =
  {
    id = 2048
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="mzorch", count=50} }
  }

  large_zorch =
  {
    id = 2008
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="lzorch",count=4} }
  }

  large_pack =
  {
    id = 2049
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="lzorch",count=20} }
  }

  propulsor_zorch =
  {
    id = 2010
    prob = 10
    cluster = { 4,7 }
    give = { {ammo="propulsor",count=1} }
  }

  propulsor_pack =
  {
    id = 2046
    prob = 40
    cluster = { 1,3 }
    give = { {ammo="propulsor",count=5} }
  }

  phasing_zorch =
  {
    id = 2047
    prob = 20
    cluster = { 2,5 }
    give = { {ammo="phase",count=20} }
  }

  phasing_pack =
  {
    id = 17
    prob = 40
    cluster = { 1,2 }
    give = { {ammo="phase",count=100} }
  }
}


CHEX3.PLAYER_MODEL =
{
  chexguy =
  {
    stats   = { health=0 }
    weapons = { mini_zorcher=1, spoon=1 }
  }
}


------------------------------------------------------------

CHEX3.EPISODES =
{
  episode1 =
  {
    theme = "TECH"
    sky_light = 0.75
  }

-- E2M5 and E3M5 will exit when all bosses (Maximus, Flembomination 
-- and Snotfolus) are dead, so perhaps prevent an exit door or
-- switch from appearing if any of those appear in these levels?

  episode2 =
  {
    theme = "TECH"  -- FIXME will be CITY later
    sky_light = 0.75
  }

  episode3 =
  {
    theme = "TECH"
    sky_light = 0.75
  }
}


function CHEX3.get_levels()
  local  EP_NUM = (OB_CONFIG.length == "full"   ? 3 ; 1)
  local MAP_NUM = (OB_CONFIG.length == "single" ? 1 ; 5)

  if OB_CONFIG.length == "few" then MAP_NUM = 3 end

  for ep_index = 1,EP_NUM do
    local EPI =
    {
      levels = {}
    }

    table.insert(GAME.episodes, EPI)

    local ep_info = CHEX3.EPISODES["episode" .. ep_index]
    assert(ep_info)

    for map = 1,MAP_NUM do
      local ep_along = map / 6

      if OB_CONFIG.length == "single" then
        ep_along = 0.5
      elseif OB_CONFIG.length == "few" then
        ep_along = map / 4
      end

      local LEV =
      {
        episode = EPI

        name  = string.format("E%dM%d", ep_index, map)
        patch = string.format("WILV%d%d", ep_index-1, map-1)

         ep_along = ep_along
        mon_along = ep_along + (ep_index-1) / 5
      }

      table.insert( EPI.levels, LEV)
      table.insert(GAME.levels, LEV)
    end -- for map

  end -- for episode
end


function CHEX3.make_cool_gfx()
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
  gui.wad_logo_gfx("WALL63_1", "p", "BOLT",   128,128, 2)
  gui.wad_logo_gfx("WALL63_2", "p", "PILL",   128,128, 1)
  gui.wad_logo_gfx("DOOR12_1", "p", "RELIEF",  64,128, 3)
  gui.wad_logo_gfx("WALL57_1", "p", "CARVE",   64,128, 4)

  -- flats
  gui.wad_logo_gfx("O_PILL",   "f", "PILL",   64,64, 1)
  gui.wad_logo_gfx("O_BOLT",   "f", "BOLT",   64,64, 2)
  gui.wad_logo_gfx("O_RELIEF", "f", "RELIEF", 64,64, 3)
  gui.wad_logo_gfx("O_CARVE",  "f", "CARVE",  64,64, 4)
end


function CHEX3.all_done()
  CHEX3.make_cool_gfx()
end


------------------------------------------------------------


UNFINISHED["chex3"] =
{
  label = "Chex Quest 3"
  format = "doom"

  tables =
  {
    CHEX3
  }

  hooks =
  {
    setup        = CHEX3.setup
    get_levels   = CHEX3.get_levels
    all_done     = CHEX3.all_done
  }
}


------------------------------------------------------------

-- themes (TECH2 etc...): caves, spaceship (use flemkeys here)

OB_THEMES["chex_tech"] =
{
  label = "Tech"
  for_games = { chex1=1, chex2=1, chex3=1 }
  name_theme = "TECH"
  mixed_prob = 60
}

UNFINISHED["chex_arboretum"] =  -- AJA: keep as separate theme??
{
  label = "Arboretum"
  for_games = { chex1=1 }
  name_theme = "URBAN"
  mixed_prob = 30
}

UNFINISHED["chex_cave"] =  -- AJA: keep as separate theme??
{
  label = "Cave"
  for_games = { chex1=1 }
  name_theme = "GOTHIC"
  mixed_prob = 30
}

-- FIXME: chex2 themes

-- themes (CITY2 etc...): sewers, lodge, lots of trees 
-- and grassy / rocky terrain outdoors, wooden buildings

UNFINISHED["chex3_city"] =
{
  label = "City"
  for_games = { chex3=1 }
  name_theme = "URBAN"
  mixed_prob = 50
}

