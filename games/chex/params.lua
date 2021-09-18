CHEX3.PARAMETERS =
{
  rails = true,
  light_brushes = true,

  -- NOTE: no infighting at all
  infighting = false,
  --infighting = true

  jump_height = 24,

  max_name_length = 28,

  skip_monsters = { 10,35 },

  time_factor   = 1.0,
  damage_factor = 1.0,
  ammo_factor   = 0.8,
  health_factor = 0.7,
  monster_factor = 0.8
}

CHEX3.ACTIONS =
{
  -- These are used for converting generic linedef types
  
  Generic_Key_One = { id=700, rid=28 },
  Generic_Key_Two = { id=701, rid=27 },
  Generic_Key_Three = { id=702, rid=26 },

  --
  -- These keywords are used by prefabs that are remotely
  -- triggered (by a switch or walk-over line).
  --

  S1_OpenDoor = { id=103,  kind="open" },    -- opens and stays open
  W1_OpenDoor = { id=2,    kind="open" },    --
  GR_OpenDoor = { id=46,   kind="open" },    --

  W1_OpenDoorFast = { id=2, kind="open" },

  S1_RaiseStair = { id=106,  kind="stair" },  -- 16 units
  W1_RaiseStair = { id=107,  kind="stair" },  --

  S1_FloorUp    = { id=18,  kind="floor_up" }, -- up to next highest floor

  S1_LowerFloor = { id=23, kind="lower" },  -- down to lowest nb floor
  W1_LowerFloor = { id=38, kind="lower" }  --
}
