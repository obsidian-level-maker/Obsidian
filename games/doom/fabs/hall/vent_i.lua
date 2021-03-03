--
-- vent piece : straight
--

PREFABS.Hallway_vent_i1 =
{
  file   = "hall/vent_i.wad",
  map    = "MAP01",

  group  = "vent",
  prob   = 50,

  where  = "seeds",
  shape  = "I",
}

PREFABS.Hallway_vent_i_rise =
{
  template = "Hallway_vent_i1",
  map = "MAP02",

  prob = 15,

  style = "steepness",

  delta_h = 64,

  can_flip = true,
}

PREFABS.Hallway_vent_i_EPIC =
{
  template = "Hallway_vent_i1",
  map = "MAP03",

  prob = 15,

  theme = "!hell",

  texture_pack = "armaetus",

  sound = "Indoor_Fan",
}

PREFABS.Hallway_vent_i_lights =
{
  template = "Hallway_vent_i1",
  map = "MAP03",

  prob = 20,

  flat_FAN1 =
  {
    CEIL1_2 = 50,
  },

  tex_WARNSTEP =
  {
    STEP3 = 50,
  },

  sound = "Indoor_Fan",
}

-- i-piece with single side door

PREFABS.Hallway_vent_i_side_door_tech =
{
  template = "Hallway_vent_i1",
  map = "MAP04",

  prob = 17,

  theme = "!hell",

  can_flip = true,
}

PREFABS.Hallway_vent_i_side_door_gothic =
{
  template = "Hallway_vent_i1",
  map = "MAP04",

  prob = 17,

  theme = "hell",

  tex_DOOR3 = "WOODMET1",
  tex_DOORSTOP = "METAL",

  can_flip = true,
}

PREFABS.Hallway_vent_i_side_window =
{
  template = "Hallway_vent_i1",
  map = "MAP05",

  prob = 17,

  can_flip = true,
}

PREFABS.Hallway_vent_i_side_lights_tech =
{
  template = "Hallway_vent_i1",
  map = "MAP06",

  prob = 17,

  theme = "!hell",

  can_flip = true,
}

PREFABS.Hallway_vent_i_side_lights_gothic =
{
  template = "Hallway_vent_i1",
  map = "MAP06",

  prob = 17,

  theme = "hell",

  tex_LITE3 = "ROCKRED1",

  can_flip = true,
}
