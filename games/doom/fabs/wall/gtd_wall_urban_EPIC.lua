PREFABS.Wall_urban_tall_vent =
{
  file   = "wall/gtd_wall_urban_EPIC.wad",
  map    = "MAP01",

  prob   = 20,
  theme = "urban",

  env = "outdoor",

  texture_pack = "armaetus",

  where  = "edge",
  height = 128,
  deep   = 80,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_urban_fire_exit_low =
{
  template = "Wall_urban_tall_vent",
  map = "MAP02",

  need_solid_back = true,
  on_scenics = "never",

  height = 208,
  deep = 48,

  bound_z2 = 208,
}

PREFABS.Wall_urban_fire_exit_high =
{
  template = "Wall_urban_tall_vent",
  map = "MAP03",

  need_solid_back = true,
  on_scenics = "never",

  height = 336,
  deep = 48,

  bound_z2 = 336,
}
