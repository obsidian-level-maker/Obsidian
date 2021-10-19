QUAKE.PARAMETERS =
{
  -- Quake engine needs all coords to lie between -4000 and +4000.
  -- (limitation of the client/server protocol).
  map_limit = 8000,

  centre_map = true,

  use_spawnflags = true,
  entity_delta_z = 24,

  -- keys are lost when you open a locked door
  lose_keys = true,

  extra_floors = true,
  deep_liquids = true,

  jump_height = 42,

  -- the name buffer in Quake can fit 39 characters, however
  -- the on-screen space for the name is much less.
  max_name_length = 20,

  skip_monsters = { 20,30 },

  episodic_monsters = true,

  monster_factor = 0.7,
  health_factor  = 1.0,
  ammo_factor    = 1.0,
  time_factor    = 1.0,

  rails = false,
  switches = true,
  light_brushes = false,

}

QUAKE.ACTIONS =
{
  --
  -- These keywords are used by prefabs that are remotely
  -- triggered (by a switch or walk-over line).
  --

  S1_OpenDoor = { id="func_door",  kind="open" },    -- opens and stays open
  W1_OpenDoor = { id="func_door",    kind="open" },    --
  GR_OpenDoor = { id="func_door",   kind="open" },    --

  W1_OpenDoorFast = { id="func_door", kind="open" },

  S1_RaiseStair = { "func_plat",  kind="stair" },  -- 16 units
  W1_RaiseStair = { "func_plat",  kind="stair" },  --

  S1_FloorUp    = { "func_plat",  kind="floor_up" }, -- up to next highest floor

  S1_LowerFloor = { "func_plat", kind="lower" },  -- down to lowest nb floor
  W1_LowerFloor = { "func_plat", kind="lower" }  --
}
