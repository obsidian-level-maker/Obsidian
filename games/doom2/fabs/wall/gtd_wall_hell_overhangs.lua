PREFABS.Wall_hell_castle_maccicolations =
{
  file   = "wall/gtd_wall_hell_overhangs.wad",
  map    = "MAP01",

  prob   = 150,
  env   = "!building",
  theme = "hell",

  skip_prob = 83.33,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "bottom",
}

PREFABS.Wall_hell_castle_maccicolations_overhang =
{
  template = "Wall_hell_castle_maccicolations",

  map = "MAP02",

  deep = 32,
}

PREFABS.Wall_hell_castle_maccicolations_turret =
{
  template = "Wall_hell_castle_maccicolations",

  map = "MAP03",

  height = 192,

  deep = 48,

  bound_z2 = 192,
}
