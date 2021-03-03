PREFABS.Wall_tech_vertical_light =
{
  file   = "wall/gtd_wall_tech_vertical_light_set.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_vertical_light_1",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_tech_vertical_light_diag =
{
  file   = "wall/gtd_wall_tech_vertical_light_set.wad",
  map    = "MAP02",

  prob   = 50,
  group = "gtd_wall_vertical_light_1",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_tech_vertical_light_2 =
{
  template = "Wall_tech_vertical_light",

  group = "gtd_wall_vertical_light_2",

  tex_LITE2 = "LITE96",
}

PREFABS.Wall_tech_vertical_light_2_diag =
{
  template = "Wall_tech_vertical_light_diag",

  group = "gtd_wall_vertical_light_2",

  tex_LITE2 = "LITE96",
}

PREFABS.Wall_tech_vertical_light_3 =
{
  template = "Wall_tech_vertical_light",

  group = "gtd_wall_vertical_light_3",

  tex_LITE2 = "LITESTON",
}

PREFABS.Wall_tech_vertical_light_3_diag =
{
  template = "Wall_tech_vertical_light_diag",

  group = "gtd_wall_vertical_light_3",

  tex_LITE2 = "LITESTON",
}
