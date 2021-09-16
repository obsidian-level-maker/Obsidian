CHEX3.ENTITIES =
{

  --- entities for generic prefabs, the rid field stands for "Real ID" --
  generic_barrel = { id=11000, rid=2035, r=12, h=32 },
  generic_ceiling_light = { id=11001, rid=60, r=31, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  generic_standalone_light = { id=11002, rid=35, r=12, h=54, light=255 }, -- "torches" and such, freestanding on a floor
  generic_wall_light    = { id=11003, rid=34, r=10, h=64, light=255, pass=true, add_mode="extend" }, -- "torches" and such, attached to a wall
  generic_wide_light    = { id=11004, rid=2028, r=16, h=44, light=255 }, -- wide standalone light, braziers, etc
  generic_small_pillar  = { id=11005, rid=32, r=16, h=36 },
  k_one = { id=11006, rid=13 },
  k_two = { id=11007, rid=6 },
  k_three = { id=11008, rid=5 },
  generic_p1_start = { id=11009, rid=1, r=16, h=56 },
  generic_p2_start = { id=11010, rid=2, r=16, h=56 },
  generic_p3_start = { id=11011, rid=3, r=16, h=56 },
  generic_p4_start = { id=11012, rid=4, r=16, h=56 },
  generic_teleport_spot = { id=11013, rid=14},

  --- PLAYERS ---

  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },


  --- PICKUPS ---

  k_red    = { id=13 },
  k_yellow = { id=6 },
  k_blue   = { id=5 },

  back_pack      = { id=   8 },
  slime_suit     = { id=2025 },
  allmap         = { id=2026 },

  --- SCENERY ---

  -- tech --

  landing_light = { id=2028,r=16, h=35, light=255 },

  flag_pole  = { id=37, r=16, h=128 },

  chemical_burner = { id=41, r=16, h=25 },
  beaker     = { id=80, r=20, h=64, pass=true },
  gas_tank   = { id=36, r=16, h=40 },
  spaceship  = { id=54, r=32, h=58 },

  -- arboretum --

  cave_bat    = { id=63, r=16, h=64, ceil=true }, -- SOLID?
  hang_plant1   = { id=59, r=20, h=64, pass=true, ceil=true }, -- new id
  hang_plant2   = { id=61, r=20, h=64, pass=true, ceil=true }, -- new id
  hang_pots     = { id=62, r=20, h=64, pass=true, ceil=true },

  -- other --

  slime_fountain = { id=44, r=16, h=48 },

  -- pickups --

  kf_red    = { id=38 },
  kf_yellow = { id=39 },
  kf_blue   = { id=40 },

  goggles   = { id=2045 },

  -- scenery --

  apple_tree  = { id=9060, r=20, h=64 },
  banana_tree = { id=9058, r=20, h=64 },
  beech_tree  = { id=9059, r=20, h=64 },
  orange_tree = { id=9061, r=20, h=64 },
  pine_tree   = { id=30,   r=16, h=130 },
  torch_tree  = { id=43,   r=16, h=128 },

  flower1 = { id=78, r=20, h=25 },
  flower2 = { id=79, r=20, h=25 },

  cave_pillar = { id=73, r=16, h=128 },
  stalactite  = { id=47, r=16, h=50 },
  stalagmite  = { id=74, r=16, h=64 },
  mine_cart   = { id=53, r=16, h=30 },

  smallbush   = { id=81,   r=20, h=4, pass=true },

  dinosaur1   = { id=76, r=60, h=120 },
  dinosaur2   = { id=77, r=60, h=120 },

  statue_david  = { id=9051, r=20, h=64 },
  statue_think  = { id=9052, r=20, h=64 },
  statue_ramses = { id=9053, r=20, h=64 },
  statue_tut    = { id=9054, r=20, h=64 },
  statue_chex   = { id=9055, r=20, h=64 },
  giant_spoon   = { id=9056, r=60, h=64 },

  slimey_meteor = { id=27, r=16, h=30 },

  -- Doom barrel, named the same for compatibility
  barrel = { id=2035, r=15, h=60 },

  candle_stick   = { id=34,  r=20, h=18,  light=255 },
  street_light   = { id=35,  r=16, h=128, light=255 },
  green_torch    = { id=45,  r=16, h=68,  light=255 },
  green_torch_sm = { id=56,  r=16, h=55,  light=255 },
  red_torch      = { id=46,  r=16, h=68,  light=255 },
  red_torch_sm   = { id=57,  r=16, h=26,  light=255 },


  globe_stand    = { id=25, r=16, h=64 },
  lab_coil       = { id=42, r=16, h=90 },
  mappoint_light = { id=85, r=16, h=75 },
  model_rocket   = { id=18, r=20, h=106 },
  monitor        = { id=29, r=16, h=51 },
  wine_barrel    = { id=32, r=16, h=36 },
  radar_dish     = { id=19, r=20, h=121 },
  stool          = { id=49, r=16, h=41 },
  tech_pillar    = { id=48, r=16, h=83 },
  telephone      = { id=28, r=16, h=26, pass=true },

  captive1    = { id=70, r=16, h=65 },
  captive2    = { id=26, r=16, h=65 },
  captive3    = { id=52, r=16, h=65 },
  diner_chef  = { id=23, r=20, h=64 },
  diner_table = { id=22, r=20, h=64 },

  big_bowl    = { id=51, r=40, h=64 },
  grey_rock   = { id=31, r=16, h=36 },
  hydro_plant = { id=50, r=16, h=45 },
  slimey_urn  = { id=86, r=16, h=83 },

  ceiling_slime = { id=60, r=16, h=68, pass=true, ceil=true }
}

CHEX3.GENERIC_REQS =
{
  -- These are used for fulfilling fab pick requirements in prefab.lua
  Generic_Key_One = { kind = "k_one", rkind = "k_red" },
  Generic_Key_Two = { kind = "k_two", rkind = "k_yellow" },
  Generic_Key_Three = { kind = "k_three", rkind = "k_blue" }
}

CHEX3.PLAYER_MODEL =
{
  chexguy =
  {
    stats   = { health=0 },
    weapons = { mini_zorcher=1, spoon=1 }
  }
}
