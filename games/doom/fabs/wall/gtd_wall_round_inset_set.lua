PREFABS.Wall_round_inset_plain =
{
  file   = "wall/gtd_wall_round_inset_set.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "gtd_round_inset",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = {56,80},
}

PREFABS.Wall_round_inset_3_bar_lights =
{
  template = "Wall_round_inset_plain",
  prob     = 15,

  map      = "MAP02",
}

PREFABS.Wall_round_inset_3_bar_lights_diagonal =
{
  template = "Wall_round_inset_plain",
  map      = "MAP03",

  where    = "diagonal",
}
