PREFABS.Decor_road_clutter_three_cones =
{
  file = "decor/gtd_decor_road_clutter.wad",
  map = "MAP01",

  prob = 3500,
  theme = "!hell",
  env = "outdoor",

  can_be_on_roads = true,

  where = "point",
  size = 64,
  height = 94,

  bound_z1 = 0,
  bound_z2 = 94,
}

PREFABS.Decor_road_clutter_one_cone =
{
  template = "Decor_road_clutter_three_cones",
  map = "MAP02",

  size = 32,
}

PREFABS.Decor_road_clutter_boxes =
{
  file = "decor/gtd_decor_road_clutter.wad",
  map = "MAP03",

  prob = 3500,
  theme = "!hell",

  can_be_on_roads = true,

  where = "point",
  size = 80,
  height = 64,

  bound_z1 = 0,
  bound_z2 = 64,

  sink_mode = "never_liquids",

  flat_CRATOP2 = "CRATOP1",
}

PREFABS.Decor_road_clutter_boxes_alt =
{
  template = "Decor_road_clutter_boxes",

  theme = "!tech",

  flat_CRATOP1 = "FLAT5_2",
  flat_CRATOP2 = "FLAT5_2",

  tex_CRATE2 = "WOODMET1",
  tex_CRATINY = "WOOD10",
}

PREFABS.Decor_road_clutter_concrete_barrier =
{
  file = "decor/gtd_decor_road_clutter.wad",
  map = "MAP04",

  prob = 4000,
  theme = "!hell",
  env = "outdoor",

  can_be_on_roads = true,

  where = "point",
  size = 80,
  height = 32,

  bound_z1 = 0,
  bound_z2 = 32,

  sink_mode = "never",
}

PREFABS.Decor_road_clutter_concrete_barrier_striped =
{
  template = "Decor_road_clutter_concrete_barrier",
  map = "MAP05",
}

PREFABS.Decor_road_clutter_concrete_barrier_striped_double =
{
  template = "Decor_road_clutter_concrete_barrier",
  map = "MAP06",

  size = 100,
}
