PREFABS.Wall_tech_windows_top_corner_light =
{
  file   = "wall/gtd_wall_tech_top_corner_light_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "!hell",
  env = "building",

  group = "gtd_wall_tech_top_corner_light_set",

  where  = "edge",
  deep   = 32,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "bottom",
}

PREFABS.Wall_tech_windows_top_corner_light_diag =
{
  file   = "wall/gtd_wall_tech_top_corner_light_set.wad",
  map    = "MAP02",

  prob   = 50,
  theme = "!hell",
  group = "gtd_wall_tech_top_corner_light_set",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "bottom",
}

PREFABS.Wall_tech_windows_top_corner_light_hell =
{
  template = "Wall_tech_windows_top_corner_light",
  theme = "hell",

  tex_TEKLITE2 = "SKINEDGE",
  flat_CEIL3_4 = "BLOOD1",
}

PREFABS.Wall_tech_windows_top_corner_light_diag_hell =
{
  template = "Wall_tech_windows_top_corner_light_diag",
  theme = "hell",

  tex_TEKLITE2 = "SKINEDGE",
  flat_CEIL3_4 = "BLOOD1",
}
