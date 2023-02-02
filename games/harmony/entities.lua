HARMONY.ENTITIES =
{
  --- special stuff ---
  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11 },
  teleport_spot = { id=14 },
  
  --- keys ---
  kc_green   = { id=5 },
  kc_yellow  = { id=6 },
  kc_purple  = { id=13 },

  --kn_purple  = { id=38 },
  --kn_yellow  = { id=39 },
  --kn_green   = { id=40 },

  --- powerup ---
  computer_map = { id=2026 },

  --- scenery ---

  -- TODO: SIZES and PASSIBILITY

  bridge = { id=118, r=20, h=16 },
  barrel = { id=2035, r=20, h=56 },
  flames = { id=36, r=20, h=56 },
  amira  = { id=32, r=20, h=56 },

  solid_shroom = { id=30, r=20, h=56 },
  truck_pipe   = { id=31, r=20, h=56 },
  sculpture    = { id=33, r=20, h=56 },
  tree_stump    = { id=54, r=20, h=56 },
  dead_tree    = { id=54, r=20, h=56 },
  water_drip   = { id=42, r=20, h=56 },
  dope_fish    = { id=45, r=20, h=56 },

  tall_lamp  = { id=48, r=20, h=56 },
  laser_lamp = { id=2028, r=20, h=56 },
  candle     = { id=34, r=20, h=56 },
  fire       = { id=55, r=20, h=56 },
  fire_box   = { id=57, r=20, h=56 },
  wall_torch = { id=44, r=10, h=64, light=255, pass=true, add_mode="extend" },

  flies       = { id=2007, r=20, h=56, pass=true },
  nuke_splash = { id=46, r=20, h=56 },
  ceil_sparks = { id=56, r=20, h=56 },
  brazier     = { id=63, r=20, h=56, ceil=true },
  missile     = { id=27, r=20, h=56 },

  vine_thang   = { id=28, r=20, h=56 },
  skeleton     = { id=19, r=20, h=56 },
  hang_chains  = { id=73, r=20, h=56 },
  minigun_rack = { id=74, r=20, h=88 },
  shotgun_rack = { id=75, r=20, h=64 },

  dead_amazon = { id=15, r=20, h=16, pass=true },
  dead_beast  = { id=21, r=20, h=16, pass=true },

  passable_ceiling_decor = { id=61, r=16, h=24, pass=true, ceil=true }, -- For Harmony this is effectively nothing

  light  = { id="light", r=1, h=1, pass=true },
  secret = { id="oblige_secret", r=1, h=1, pass=true },
  depot_ref = { id="oblige_depot", r=1, h=1, pass=true },
}

HARMONY.PLAYER_MODEL =
{
  harmony =
  {
    stats   = { health=0 },
    weapons = { pistol=1 },
  },
}
