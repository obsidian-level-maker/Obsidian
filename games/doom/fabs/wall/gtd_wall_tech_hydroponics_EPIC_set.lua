PREFABS.Wall_tech_hydroponics =
{
  file   = "wall/gtd_wall_tech_hydroponics_EPIC_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "tech",
  env = "building",

  group = "gtd_wall_hydroponics",

  where  = "edge",
  deep   = 32,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_tech_hydroponics_posted =
{
  template = "Wall_tech_hydroponics",
  map      = "MAP02",

  prob     = 15,
}
