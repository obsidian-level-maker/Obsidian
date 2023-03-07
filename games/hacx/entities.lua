HACX.ENTITIES =
{
 --- special stuff ---
  player1 = { id=1, r=16, h=56 },
  player2 = { id=2, r=16, h=56 },
  player3 = { id=3, r=16, h=56 },
  player4 = { id=4, r=16, h=56 },

  dm_player     = { id=11, r=16, h=56 },
  teleport_spot = { id=14, r=16, h=56 },

  --- keys ---
  --k_password = { id=5 }, -- "Blue" key
  --k_ckey     = { id=6 }, -- "Yellow" key
  --k_keycard  = { id=13 }, -- "Red" key

  kz_red     = { id=38 },
  kz_yellow  = { id=39 },
  kz_blue    = { id=40 },

  -- TODO: POWERUPS

  --- scenery ---
  chair      = { id=35, r=24, h=40 },
  ceiling_light = { id=44, r=31, h=60, light=255, pass=true, ceil=true, add_mode="island" },
  wall_torch = { id=56, r=10, h=64, light=255, pass=true, add_mode="extend" },
  barrel = { id=2035, r=12, h=32 },
  rock = { id=79, r=10, h=32, pass=true},
  standing_lamp = { id=57, r=38, h=51, pass=true, light=255},
  small_pillar  = { id=48, r=16, h=36 },
  passable_ceiling_decor = { id=74, r=16, h=24, pass=true, ceil=true },

  light  = { id="light", r=1, h=1, pass=true },
  secret = { id="oblige_secret", r=1, h=1, pass=true },
  depot_ref = { id="oblige_depot", r=1, h=1, pass=true },

  -- TODO: all other scenery!!
}

HACX.PLAYER_MODEL =
{
  danny =
  {
    stats   = { health=0 },
    weapons = { pistol=1, boot=1 }
  }
}
