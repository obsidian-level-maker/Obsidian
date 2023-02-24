--
-- Joiner with remote door
--

PREFABS.Joiner_remote_door =
{
  file   = "joiner/barred2.wad",
  where  = "seeds",
  shape  = "I",
  map    = "MAP01",

  key    = "barred",

  prob   = 15,

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_OpenDoor",

  flat_FLAT23 = "SILVER3",
}

PREFABS.Joiner_remote_door_actual_door1 =
{
  template  = "Joiner_remote_door",
  map    = "MAP02",
  theme  = "tech",
  prob   = 45,
  flat_FLAT1 = { FLAT1=50, FLOOR0_1=50, FLAT19=50 },
}

PREFABS.Joiner_remote_door_actual_door2 =
{
  template  = "Joiner_remote_door",
  map    = "MAP02",
  theme  = "tech",
  prob   = 45,
  tex_BIGDOOR2 = "BIGDOOR3",
  flat_FLAT20 = "FLOOR7_2",
  flat_FLAT1 = { FLAT1=50, FLOOR0_1=50, FLAT19=50 },
}

PREFABS.Joiner_remote_door_actual_door3 =
{
  template  = "Joiner_remote_door",
  map    = "MAP02",
  theme  = "tech",
  prob   = 45,
  tex_BIGDOOR2 = "BIGDOOR4",
  flat_FLAT20 = "FLOOR0_1",
  flat_FLAT1 = { FLAT1=50, FLOOR0_1=50, FLAT19=50 },
}

PREFABS.Joiner_remote_door_actual_door_urban =
{
  template  = "Joiner_remote_door",
  map    = "MAP02",
  theme  = "urban",
  prob   = 40,
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR6=50, BIGDOOR7=50 },
  tex_GRAY5 = "WOOD1",
  flat_FLAT20 = "CEIL5_2",
  flat_FLAT1 = { FLAT5_1=50, FLAT5_2=50 },
}

PREFABS.Joiner_remote_door_actual_door_hell =
{
  template  = "Joiner_remote_door",
  map    = "MAP02",
  theme  = "hell",
  prob   = 40,
  tex_BIGDOOR2 = { BIGDOOR5=50, BIGDOOR6=50, BIGDOOR7=50 },
  tex_GRAY5 = "STONE6",
  flat_FLAT20 = "CEIL5_2",
  flat_FLAT1 = { FLAT10=50, RROCK09=50, RROCK16=50 },
}

PREFABS.Joiner_remote_sw_metal =
{
  template = "Joiner_remote_door",
  key = "sw_metal",

  x_fit = "frame",
  y_fit = "stretch",

  tex_SILVER3 = "METAL3",
  flat_FLAT23 = "CEIL5_2",
}

