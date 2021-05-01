PREFABS.Wall_air_vents_plain =
{
  file = "wall/gtd_wall_industrial_air_vents_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_wall_air_vents",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_air_vents_plain_fan =
{
  template = "Wall_air_vents_plain",
  map = "MAP02",

  tex_METAL5 =
  {
    METAL5 = 5,
    WARNSTEP = 2,
  }
}

PREFABS.Wall_air_vents_plain_diag =
{
  template = "Wall_air_vents_plain",
  map = "MAP04",

  where = "diagonal"
}
