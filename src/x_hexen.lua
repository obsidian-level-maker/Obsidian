----------------------------------------------------------------
-- GAME DEF : Hexen
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

XN_LINE_TYPES =
{
  -- FIXME: speeds (16) and delays (64) are just guesses!!

  --- general ---

  A1_scroll_left  = { kind=100, args={ 16 } },
  A1_scroll_right = { kind=101, args={ 16 } },
  A1_scroll_up    = { kind=102, args={ 16 } },
  A1_scroll_down  = { kind=103, args={ 16 } },

  -- FIXME: exit types not right
  S1_exit = { kind=75 },
  W1_exit = { kind=75 },
  S1_secret_exit = { kind=75 },
  W1_secret_exit = { kind=75 },

  WR_teleport = { kind=70 },
  MR_teleport = { kind=70 },  -- monster only

  S1_bars = { kind=21, args={ "tag", 16 } },

  --- doors ---

  PR_door       = { kind=12, args={ 0,16 } },
  PR_blaze_door = { kind=12, args={ 0,32 } },

  W1_door       = { kind=11, args={ "tag", 16 } },
  S1_door       = { kind=11, args={ "tag", 16 } },

  SR_door       = { kind=12, args={ "tag", 16, 64 } },
  SR_blaze_door = { kind=12, args={ "tag", 16, 64 } },

  P1_fire_door   = { kind=13, args={ 0, 16, 64, 4 }  },
  PR_fire_door   = { kind=13, args={ 0, 16, 64, 4 }  },
  P1_castle_door = { kind=13, args={ 0, 16, 64, 11 } },
  PR_castle_door = { kind=13, args={ 0, 16, 64, 11 } },
  P1_silver_door = { kind=13, args={ 0, 16, 64, 7 }  },
  PR_silver_door = { kind=13, args={ 0, 16, 64, 7 }  },

  --- lifts ---

  SR_lift = { kind=62, args={ "tag", 16, 64 } },
  WR_lift = { kind=62, args={ "tag", 16, 64 } },

  SR_blaze_lift = { kind=62, args={ "tag", 32, 64 } },
  WR_blaze_lift = { kind=62, args={ "tag", 32, 64 } },
}

XN_SECTOR_TYPES =
{
  -- FIXME
}


----------------------------------------------------------------

XN_COMBOS =
{
  ---- INDOOR ------------

  GOLD =
  {
    mat_pri = 6,

    wall = "FOREST01",
    void = "WINNOW02",
    pillar = "PILLAR01",

    floor = "F_089",
    ceil = "F_014",

    scenery = "brass_brazier",

    theme_probs = { CITY=20 },
  },

  ICY =
  {
    mat_pri = 1,

    wall = "ICE06",
    void = "ICE02",
    pillar = "ICE01",

    floor = "F_033",  -- F_013
    ceil  = "F_009",

    bad_liquid = "lava",

    theme_probs = { ICE=80 },
  },

  FIREY =
  {
    mat_pri = 5,

    wall = "FIRE01",
    void = "FIRE09",
    pillar = "FIRE15",

    floor = "F_012",
    ceil  = "F_032",

    good_liquid = "lava",

    theme_probs = { CITY=20 },
  },

  CAVEY =
  {
    mat_pri = 2,

    wall = "CAVE06",
    void = "CAVE03",
    
    floor = "F_040",
    ceil  = "F_040",

    scenery = "stal_pillar",

    theme_probs = { CAVE=70 },
  },

  ---- OUTDOOR ------------

  GRAY =
  {
    outdoor = true,
    mat_pri = 4,

    wall = "PRTL02",
    void = "PRTL03",

    floor = "F_019",
    ceil  = "F_019",

    scenery = "short_statue",

    theme_probs = { CITY=20 },
  },
  
  STONY =
  {
    outdoor = true,
    mat_pri = 3,

    wall = "CAVE01",
    void = "CAVE02",

    floor = "F_007",
    ceil  = "F_007",

    scenery = "lean_tree_L",

    theme_probs = { CITY=20 },
  },
}

XN_EXITS =
{
  STEEL =
  {
    mat_pri = 9,

    wall = "STEEL01",
    void = "STEEL02",

    floor = "F_022",
    ceil  = "F_044",

    switch = { switch="SW_2_UP", wall="STEEL06", h=64 },

    door = { wall="FIRE14", w=64,  h=128 },
  },

}

XN_HALLWAYS =
{
  -- FIXME !!! hallway themes
}


---- BASE MATERIALS ------------

XN_MATS =
{
  METAL =
  {
    mat_pri = 5,

    wall  = "PLAT01", void = "PLAT01",
    floor = "F_065",  ceil = "F_065",
  },

  STEP =
  {
    wall  = "S_09",
    floor = "F_014",
  },

  LIFT =
  {
    wall  = "PLAT02",
    floor = "F_065"
  },

  TRACK =
  {
    wall  = "STEEL08",
    floor = "F_008",
  },

  DOOR_FRAME =
  {
    wall  = nil,  -- this means: use plain wall
    floor = "F_009",
    ceil  = "F_009",
  },
}

---- PEDESTALS ------------

XN_PEDESTALS =
{
  PLAYER =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_062",  ceil = "F_062",  -- TODO: F_061..F_064
    h = 8,
  },

  QUEST =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_042",  ceil = "F_042",
    h = 8,
  },

  WEAPON =
  {
    wall = "T2_STEP", void = "FIRE06",
    floor = "F_091",  ceil = "F_091",
    h = 8,
  },

}

---- OVERHANGS ------------

XN_OVERHANGS =
{
  WOOD =
  {
    ceil = "F_054",
    upper = "D_WD07",
    thin = "WOOD01",
  },
}


---- MISC STUFF ------------

XN_LIQUIDS =
{
  water = { floor="X_005" },
  lava  = { floor="X_001" },
  slime = { floor="X_009" },
}

XN_SWITCHES =
{
---###  sw_rock = { wall="STEEL06", switch="SW_1_UP" },

  sw_rock =
  {
    switch =
    {
      prefab = "SWITCH_PILLAR",
      skin =
      {
        switch_w="SW_1_UP", wall="STEEL06", kind=103,
      }
    },

    door =
    {
      w=128, h=128,
      prefab = "DOOR_LOCKED",
      skin =
      {
        door_w="BRASS1", door_c="F_009",
        key_w="STEEL06",

---     step_w="STEP1",  track_w="DOORTRAK",
---     frame_f="FLAT1", frame_c="FLAT1",
      }
    },
  },
}

XN_DOORS =
{
  d_big2   = { prefab="DOOR", w=128, h=128,

               skin =
               {
                 door_w="DOOR51", door_c="F_009",
                 track_w="STEEL08",
---              lite_w="LITE5", step_w="STEP1",
---              frame_f="FLAT1", frame_c="TLITE6_6",
               }
             },

--[[ !!!!!
  d_big    = { wall="DOOR51",   w=128, h=128 },
  d_brass1 = { wall="BRASS1",   w=128, h=128 },
  d_brass2 = { wall="D_BRASS2", w=64,  h=128 },

  d_wood1  = { wall="D_WD07",   w=128, h=128 },
  d_wood2  = { wall="D_WD08",   w=64,  h=128 },
--]]

  d_wood3  = { wall="D_WD10",   w=64,  h=128 },
}

XN_KEY_DOORS =
{
  -- lockable doors -- FIXME: the rest??
  k_fire   =
  {
    w=128, h=128, kind_rep=13, kind_once=13,

    prefab = "DOOR_LOCKED", 

    skin =
    {
      door_w="D_FIRE", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
    }
  },

  k_castle =
  {
    w=128, h=128, kind_rep=13, kind_once=13,

    prefab = "DOOR_LOCKED", 

    skin =
    {
      door_w="D_CAST", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
    }
  },

  k_silver =
  {
    w=128, h=128, kind_rep=13, kind_once=13,

    prefab = "DOOR_LOCKED", 

    skin =
    {
      door_w="D_SILVER", door_c="F_009",
      track_w="STEEL08",
      frame_f="F_009",
    }
  },
}

XN_RAILS =
{
  r_1 = { wall="GATE03", w=64, h=64  },
  r_2 = { wall="GATE02", w=64, h=128 },
}

XN_IMAGES =
{
  { wall = "BRASS3", w=128, h=128, glow=true },
  { wall = "BRASS4", w=64,  h=64,  floor="F_016" }
}

XN_LIGHTS =
{
  l1 = { floor="F_081", side="FIRE07" },
  l2 = { floor="F_084", side="FIRE07" },
  l3 = { floor="X_012", side="FIRE07" },
}

XN_WALL_LIGHTS =
{
  fire = { wall="X_FIRE01", w=16 },
}

XN_PICS =
{
  cave12 = { wall = "CAVE12",   w=128, h=128 },
  forest = { wall = "FOREST03", w=128, h=128 },

  mon1 = { wall = "SPAWN10",  w=128, h=128 },
  mon3 = { wall = "SPAWN13",  w=64,  h=64  },

  glass1 = { wall = "GLASS01",  w=64,  h=128 },
  glass3 = { wall = "GLASS03",  w=64,  h=128 },
  glass5 = { wall = "GLASS05",  w=64,  h=128 },
}


---- QUEST STUFF ----------------

XN_QUESTS = --FIXME
{
  key =
  {
    k_fire = 50, k_castle = 50, k_silver = 50,

--    k_steel   = 80, k_cave    = 80,
--    k_axe     = 80, k_dungeon = 80,
--    k_waste   = 80, k_swamp   = 80,
--    k_rusty   = 80, k_gold    = 80,
  },

  switch =
  {
    sw_rock=50
  },
  
  weapon =
  {
    c_staff = 40, c_fire   = 40,
    f_axe   = 40, f_hammer = 40,
    m_cone  = 40, m_blitz  = 40,
  },
  
  item =
  {
    -- torch=10,
    wings=50,
    chaos=30,
  },

  exit = { exit=50 },

  secret_exit = { secret_exit=50 },
}

XN_ROOMS =
{
  PLAIN =
  {
  },

  HALLWAY =
  {
    room_heights = { [96]=50, [128]=50 },
    door_probs   = { out_diff=75, combo_diff=50, normal=5 },
    window_probs = { out_diff=1, combo_diff=1, normal=1 },
    space_range  = { 20, 65 },
  },
 
  SCENIC =
  {
  },

  -- TODO: check in-game level names for ideas
}

XN_THEMES =
{
  CITY =
  {
    room_probs=
    {
      PLAIN=50,
    },
  },

  CAVE =
  {
    room_probs=
    {
      PLAIN=50,
    },
  },

  ICE =
  {
    room_probs=
    {
      PLAIN=50,
    },
  },
}



------------------------------------------------------------

XN_THING_NUMS =
{
  --- special stuff ---
  player1 = 1,
  player2 = 2,
  player3 = 3,
  player4 = 4,
  dm_player = 11,
  teleport_spot = 14,
  
  --- monsters ---
  ettin    = 10030,
  afrit    = 10060,
  serpent1 = 121,
  serpent2 = 120,
  wendigo  = 8020,
  centaur1 = 107,
  centaur2 = 115,

  stalker1   = 31,
  stalker2   = 8080,
  bishop     = 114,
  reiver     = 34,
  reiver_bd  = 10011,
  wyvern     = 254,

  heresiarch   = 10080,
  fighter_boss = 10100,
  cleric_boss  = 10101, 
  mage_boss    = 10102,
  korax        = 10200,

  --- pickups ---
  k_steel   = 8030,
  k_cave    = 8031,
  k_axe     = 8032,
  k_fire    = 8033,
  k_castle  = 8034,
  k_dungeon = 8035,
  k_silver  = 8036,
  k_rusty   = 8037,
  k_waste   = 8038,
  k_swamp   = 8039,
  k_gold    = 8200,
 
  c_staff   = 10,
  c_fire    = 8009,
  c1_shaft  = 20,
  c2_cross  = 19,
  c3_arc    = 18,

  f_axe     = 8010,
  f_hammer  = 123,
  f1_hilt   = 16,
  f2_cross  = 13,
  f3_blade  = 12,

  m_cone    = 53,
  m_blitz   = 8040,
  m1_stick  = 23,
  m2_stub   = 22,
  m3_skull  = 21,

  blue_mana  = 122,
  green_mana = 124,
  dual_mana  = 8004,

  ar_mesh   = 8005,
  ar_shield = 8006,
  ar_helmet = 8007,
  ar_amulet = 8008,

  h_vial  = 81,
  h_flask = 82,
  h_urn   = 32,

  wings = 83,
  chaos = 36,
  torch = 33,

  banish    = 10040,
  boots     = 8002,
  bracer    = 8041,
  repulser  = 8000,
  flechette = 10110,
  servant   = 86, 
  porkies   = 30,
  incant    = 10120,
  defender  = 84,
  krater    = 8003,

  --- scenery ---
  candle = 119,
  blue_candle = 8066,
  brass_brazier = 8061,
  wall_torch = 54,
  wall_torch_out = 55,
  twine_torch = 116,
  twine_torch_out = 117,

  tree1 = 25,
  tree2 = 8062,
  lean_tree_R = 78,
  lean_tree_L = 79,
  gnarled_tree_R = 80,
  gnarled_tree_L = 87,
  dead_tree = 24,

  hedge = 8068,
  shrub1 = 8101,
  shrub2 = 8102,
  rock1 = 6,
  rock2 = 7,
  rock3 = 9,
  rock4 = 15,

  winged_statue = 5,
  garg_statue = 72,
  short_statue = 74,
  iron_maiden = 8067,
  vase_pillar = 103,

  bell = 8065,  -- we are saved!!
  bucket = 8103,
  banner = 77,

  stal_pillar = 48,
  big_stal_F = 49,
  big_stal_C = 52,
  medium_stal_F = 50,
  medium_stal_C = 56,
  small_stal_F = 51,
  small_stal_C = 57,

  -- FIXME: lots more...

  --- sounds ---
  snd_stone  = 1400,
  snd_heavy  = 1401,
  snd_metal1 = 1402,
  snd_creak  = 1403,
  snd_silent = 1404,
  snd_lava   = 1405,
  snd_water  = 1406,
  snd_ice    = 1407,
  snd_earth  = 1408,
  snd_metal2 = 1409,
}

XN_INITIAL_MODEL =
{
  health=100, armor=0,
  blue_mana=0, green_mana=0,
  f_gaunt=true -- FIXME: classes
}

XN_MONSTERS =
{
  -- FIXME: these stats are CRAP!
  ettin      = { prob=70, r=24,h=64, hp=170, dm= 5, fp= 1, melee=true },
  serpent1   = { prob=30, r=33,h=70, hp=90,  dm= 9, fp=10, },
  afrit      = { prob=70, r=24,h=64, hp=80,  dm=10, fp= 1, float=true, cage_fallback=2 },
  serpent2   = { prob=20, r=33,h=70, hp=90,  dm=15, fp=10, },
  wendigo    = { prob=20, r=24,h=80, hp=120, dm=25, fp=10, environ="ice" },
  centaur1   = { prob=30, r=20,h=64, hp=200, dm=10, fp=10, melee=true},
  centaur2   = { prob=15, r=20,h=64, hp=250, dm=20, fp=10, },

  stalker1   = { prob=30, r=33,h=64, hp=250, dm=60, fp=10, environ="swamp", melee=true },
  stalker2   = { prob=10, r=33,h=64, hp=250, dm=30, fp=10, environ="swamp" },
  bishop     = { prob=10, r=24,h=64, hp=130, dm=40, fp=70, float=true },
  reiver     = { prob= 5, r=24,h=64, hp=150, dm=50, fp=70, float=true },
}

XN_BOSSES =
{
  wyvern     = { prob= 5, r=20,h=64, hp=640, dm=60, fp=70, float=true },
  heresiarch = { r=40,h=120,hp=5000,dm=70, fp=70 },
  korax      = { r=66,h=120,hp=5000,dm=90, fp=70 },
}

XN_WEAPONS =
{
  -- FIXME: all these stats are CRAP!
  c_mace    = { melee=true,                rate=1.1, dm=12, freq=10, held=true, },
  c_staff   = { ammo="blue_mana",  per=1,  rate=1.1, dm= 6, freq=62, },
  c_fire    = { ammo="green_mana", per=4,  rate=1.1, dm=27, freq=62, },
  c_wraith  = { ammo="dual_mana",  per=18, rate=2.2, dm=85, freq=30, pieces={c1_shaft, c2_cross, c3_arc} },

  f_gaunt   = { melee=true,                rate=1.1, dm=20, freq=10, held=true, },
  f_axe     = { ammo="blue_mana",  per=2,  rate=1.1, dm=60, freq=62, melee=true },
  f_hammer  = { ammo="green_mana", per=3,  rate=1.1, dm=27, freq=62, },
  f_quietus = { ammo="dual_mana",  per=14, rate=2.2, dm=50, freq=30, pieces={f1_hilt, f2_cross, f3_blade} },

  m_wand    = { held=true,                 rate=1.1, dm= 8, freq=10, continues=true },
  m_cone    = { ammo="blue_mana",  per=3,  rate=1.1, dm=27, freq=62, },
  m_blitz   = { ammo="green_mana", per=5,  rate=1.1, dm=60, freq=62, },
  m_scourge = { ammo="dual_mana",  per=15, rate=2.2, dm=50, freq=30, pieces={m1_stick, m2_stub, m3_skull} },
}

XN_PICKUPS =
{
  h_vial  = { stat="health", give=10,  prob=70 },
  h_flask = { stat="health", give=25,  prob=25 },
  h_urn   = { stat="health", give=100, prob=5, max_clu=1 },

  -- FIXME: these give values are CRAP!
  ar_mesh   = { stat="armor", give=100, prob=50 },
  ar_shield = { stat="armor", give=100, prob=70 },
  ar_helmet = { stat="armor", give=100, prob=90 },
  ar_amulet = { stat="armor", give=100, prob=50 },

  blue_mana  = { stat="blue_mana",  give=10 },
  green_mana = { stat="green_mana", give=10 },
  dual_mana  = { stat="dual_mana",  give=20 },
}

XN_NICENESS =
{
  p1 = { pickup="ar_mesh",   prob=2 },
  p2 = { pickup="ar_shield", prob=2 },
  p3 = { pickup="ar_helmet", prob=2 },
  p4 = { pickup="ar_amulet", prob=2 },
}

XN_DEATHMATCH =
{
  weapons =
  {
    c_staff=40, c_fire  =40, c1_shaft=20, c2_cross=20, c3_arc  =20,
    f_axe  =40, f_hammer=40, f1_hilt =20, f2_cross=20, f3_blade=20,
    m_cone =40, m_blitz =40, m1_stick=20, m2_stub =20, m3_skull=20,
  },

  health =
  { 
    h_vial=70, h_flask=25, h_urn=5
  },

  ammo =
  { 
    blue_mana=40, green_mana=40, dual_mana=15
  },

  items =
  {
    ar_mesh=50, ar_shield=70, ar_helmet=90, ar_amulet=50,

    --FIXME: artifacts!
  },

  cluster = {}
}


------------------------------------------------------------

XN_THEME_PROBS =
{
  -- dummy entry
  { CITY=50, ICE=20, CAVE=20 },
}

XN_SKY_INFO =
{
  { color="orange", light=176 },
  { color="blue",   light=144 },
  { color="blue",   light=192, lightning=true },
  { color="red",    light=192 },
  { color="gray",   light=176, foggy=true },
}

XN_LEVELS =
{
  --- Cluster 1 ---
  {
    {
      name = "map01", -- "WINNOWING HALL"
      episode = 1,
      ep_along = 1,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 2,
    },

    {
      name = "map02", -- "SEVEN PORTALS"
      episode = 1,
      ep_along = 2,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 3,
      weapon_pieces = true,
    },

    {
      name = "map03", -- "GUARDIAN OF ICE"
      episode = 1,
      ep_along = 3,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 4,
      secret_exit = 6,
    },

    {
      name = "map04", -- "GUARDIAN OF FIRE"
      episode = 1,
      ep_along = 4,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 5,
      weapon_pieces = true,
    },

    {
      name = "map05", -- "GUARDIAN OF STEEL"
      episode = 1,
      ep_along = 5,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 13,
    },

    {
      name = "map06", -- "BRIGHT CRUCIBLE"
      episode = 1,
      ep_along = 6,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      is_secret = true,
      next_map = 4,
    },
  },

  --- Cluster 2 ---
  {
    {
      name = "map13", -- "SHADOW WOOD"
      episode = 2,
      ep_along = 1,
      ep_length = 6,
      sky_info = XN_SKY_INFO[1],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 8,
    },

    {
      name = "map08", -- "DARKMERE"
      episode = 2,
      ep_along = 2,
      ep_length = 6,
      sky_info = XN_SKY_INFO[5],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 9,
      secret_exit = 11,
      weapon_pieces = true,
    },

    {
      name = "map09", -- "CAVES OF CIRCE"
      episode = 2,
      ep_along = 3,
      ep_length = 6,
      sky_info = XN_SKY_INFO[1],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 10,
    },

    {
      name = "map10", -- "WASTELANDS"
      episode = 2,
      ep_along = 4,
      ep_length = 6,
      sky_info = XN_SKY_INFO[1],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 12,
      weapon_pieces = true,
    },

    {
      name = "map11", -- "SACRED GROVE"
      episode = 2,
      ep_along = 5,
      ep_length = 6,
      sky_info = XN_SKY_INFO[5],
      theme_probs = XN_THEME_PROBS[1],
      is_secret = true,
      next_map = 9,
    },

    {
      name = "map12", -- "HYPOSTYLE"
      episode = 2,
      ep_along = 6,
      ep_length = 6,
      sky_info = XN_SKY_INFO[1],
      theme_probs = XN_THEME_PROBS[1],
      boss_kind = "wyvern",
      next_map = 27,
    },
  },

  --- Cluster 3 ---
  {
    {
      name = "map27", -- "HERESIARCH'S SEMINARY"
      episode = 3,
      ep_along = 1,
      ep_length = 7,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 28,
      secret_exit = 33,
    },

    {
      name = "map28", -- "DRAGON CHAPEL"
      episode = 3,
      ep_along = 2,
      ep_length = 7,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 30,
      weapon_pieces = true,
    },

    {
      name = "map30", -- "GRIFFIN CHAPEL"
      episode = 3,
      ep_along = 3,
      ep_length = 7,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 31,
    },

    {
      name = "map31", -- "DEATHWIND CHAPEL"
      episode = 3,
      ep_along = 4,
      ep_length = 7,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 32,
    },

    {
      name = "map32", -- "ORCHARD OF LAMENTATIONS"
      episode = 3,
      ep_along = 5,
      ep_length = 7,
      sky_info = XN_SKY_INFO[5],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 34,
      weapon_pieces = true,
    },

    {
      name = "map33", -- "SILENT REFECTORY"
      episode = 3,
      ep_along = 6,
      ep_length = 7,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      is_secret = true,
      next_map = 28,
    },

    {
      name = "map34", -- "WOLF CHAPEL"
      episode = 3,
      ep_along = 7,
      ep_length = 7,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      boss_kind = "heresiarch",
      next_map = 21,
    },
  },

  --- Cluster 4 ---
  {
    {
      name = "map21", -- "FORSAKEN OUTPOST"
      episode = 4,
      ep_along = 1,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 22,
      weapon_pieces = true,
    },

    {
      name = "map22", -- "CASTLE OF GRIEF"
      episode = 4,
      ep_along = 2,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 23,
    },

    {
      name = "map23", -- "GIBBET"
      episode = 4,
      ep_along = 3,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 24,
    },

    {
      name = "map24", -- "EFFLUVIUM"
      episode = 4,
      ep_along = 4,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 26,
      secret_exit = 25,
      weapon_pieces = true,
    },

    {
      name = "map25", -- "DUNGEONS"
      episode = 4,
      ep_along = 5,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      is_secret = true,
      next_map = 26,
    },

    {
      name = "map26", -- "DESOLATE GARDEN"
      episode = 4,
      ep_along = 6,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      boss_kind = "heresiarch",
      next_map = 35,
    },
  },

  --- Cluster 5 ---
  {
    {
      name = "map35", -- "NECROPOLIS"
      episode = 5,
      ep_along = 1,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 36,
    },

    {
      name = "map36", -- "ZEDEK'S TOMB"
      episode = 5,
      ep_along = 2,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 37,
      secret_exit = 39,
      weapon_pieces = true,
    },

    {
      name = "map37", -- "MENELKIR'S TOMB"
      episode = 5,
      ep_along = 3,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 38,
    },

    {
      name = "map38", -- "TRADUCTUS' TOMB"
      episode = 5,
      ep_along = 4,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      next_map = 40,
      weapon_pieces = true,
    },

    {
      name = "map39", -- "VIVARIUM"
      episode = 5,
      ep_along = 5,
      ep_length = 6,
      sky_info = XN_SKY_INFO[3],
      theme_probs = XN_THEME_PROBS[1],
      is_secret = true,
      next_map = 37,
    },

    {
      name = "map40", -- "DARK CRUCIBLE"
      episode = 5,
      ep_along = 6,
      ep_length = 6,
      sky_info = XN_SKY_INFO[4],
      theme_probs = XN_THEME_PROBS[1],
      boss_kind = "korax",
      end_game = true,
    },
  },
}

------------------------------------------------------------

GAME_FACTORIES["hexen"] = function()

  return
  {
    plan_size = 9,
    cell_size = 9,
    cell_min_size = 6,

    caps = { heights=true,   sky=true, 
             fragments=true, move_frag=true, rails=true,
             closets=true,   depots=true,
             switches=true,  liquids=true,
             teleporters=true,
             
             -- Hexen unique stuff
             polyobjs=true,  three_part_weapons=true,
             hubs=true,      action_script=true,
                             prefer_stairs=true,
           },

    SKY_TEX    = "F_SKY",
    ERROR_TEX  = "ABADONE",
    ERROR_FLAT = "F_033",

    episodes   = 5,
    level_func = function(episode) return XN_LEVELS[episode] end,

    min_episodes = 2,

    monsters = XN_MONSTERS,
    bosses   = XN_BOSSES,
    weapons  = XN_WEAPONS,

    thing_nums = XN_THING_NUMS,

    quests = XN_QUESTS,
    dm = XN_DEATHMATCH,

    pickups = XN_PICKUPS,
    pickup_stats = { "health", "blue_mana", "green_mana" },
    niceness = XN_NICENESS,

    initial_model = XN_INITIAL_MODEL,

    combos    = XN_COMBOS,
    exits     = XN_EXITS,
    hallways  = XN_HALLWAYS,

    rooms     = XN_ROOMS,
    themes    = XN_THEMES,

    hangs     = XN_OVERHANGS,
    pedestals = XN_PEDESTALS,
    mats      = XN_MATS,
    rails     = XN_RAILS,

    liquids   = XN_LIQUIDS,
    switches  = XN_SWITCHES,
    doors     = XN_DOORS,
    key_doors = XN_KEY_DOORS,

    pics      = XN_PICS,
    images    = XN_IMAGES,
    lights    = XN_LIGHTS,
    wall_lights = XN_WALL_LIGHTS,

    room_heights = { [96]=5, [128]=25, [192]=70, [256]=70, [320]=12 },
    space_range  = { 20, 90 },
    
    diff_probs = { [0]=20, [16]=40, [32]=80, [64]=30, [96]=5 },
    bump_probs = { [0]=30, [16]=30, [32]=20, [64]=5 },
    
    door_probs   = { out_diff=75, combo_diff=50, normal=15 },
    window_probs = { out_diff=80, combo_diff=50, normal=30 },
  }
end

