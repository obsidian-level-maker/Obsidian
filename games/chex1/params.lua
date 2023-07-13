CHEX1.PARAMETERS =
{
  teleporters = true,
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
  monster_factor = 0.8,

  titlepic_lump   = "TITLEPIC",
  titlepic_format = "patch",

  bex_map_prefix = "HUSTR_",

  episode_length = 5
}

CHEX1.ACTIONS =
{
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
