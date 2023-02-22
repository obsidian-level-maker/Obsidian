PREFABS.Wall_quakish_insets_1 =
{
  file   = "wall/gtd_wall_quakish_inset.wad",
  map    = "MAP01",

  prob   = 50,
  env = "building",

  group = "gtd_wall_quakish_insets",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top"
}

PREFABS.Wall_quakish_insets_diagonal =
{
  template = "Wall_quakish_insets_1",
  map    = "MAP02",

  where  = "diagonal"
}

--

PREFABS.Wall_quakish_insets_2 =
{
  template = "Wall_quakish_insets_1",
  map = "MAP03",

  port = "zdoom",

  group = "gtd_wall_quakish_insets_2"
}

PREFABS.Wall_quakish_insets_2_limit =
{
  template = "Wall_quakish_insets_1",
  map = "MAP03",

  port = "!zdoom",

  group = "gtd_wall_quakish_insets_2",

  line_344 = 0
}

PREFABS.Wall_quakish_insets_2_diag =
{
  template = "Wall_quakish_insets_1",
  map = "MAP04",

  where = "diagonal",

  port = "zdoom",

  group = "gtd_wall_quakish_insets_2"
}

PREFABS.Wall_quakish_insets_2_diag_limit =
{
  template = "Wall_quakish_insets_1",
  map = "MAP04",

  port = "!zdoom",

  where = "diagonal",

  group = "gtd_wall_quakish_insets_2",

  line_344 = 0
}
