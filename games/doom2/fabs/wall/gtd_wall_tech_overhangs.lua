PREFABS.Wall_tech_outdoor_overhang_girder =
{
  file   = "wall/gtd_wall_tech_overhangs.wad",
  map    = "MAP01",

  prob   = 10,
  env   = "!building",
  theme = "tech",

  where  = "edge",
  height = 128,
  long   = 128,
  deep   = 256,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "bottom",
}

PREFABS.Wall_tech_outdoor_overhang_platform =
{
  template = "Wall_tech_outdoor_overhang_girder",

  map = "MAP02",

  deep = 64,
}

PREFABS.Wall_tech_outdoor_overhang_transmitter =
{
  template = "Wall_tech_outdoor_overhang_girder",

  map = "MAP03",

  deep = 256,
}

PREFABS.Wall_tech_outdoor_overhang_fence =
{
  template = "Wall_tech_outdoor_overhang_girder",

  prob = 25,

  map = "MAP04",

  deep = 64,
}
