PREFABS.Decor_sedan =
{
  file   = "decor/gtd_cars.wad",
  map    = "MAP01",

  prob   = 6500,
  theme  = "urban",

  can_be_on_roads = true,

  env = "!building",

  where  = "point",
  height = 128,
  size   = 128,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Decor_sedan_blue =
{
  template = "Decor_sedan",

  flat_FLAT5_3 = "CEIL4_2",

  tex_REDWALL = "COMPBLUE",
}

PREFABS.Decor_sedan_brown =
{
  template = "Decor_sedan",

  flat_FLAT5_3 = "CEIL5_2",

  tex_REDWALL = "BROWN144",
}

PREFABS.Decor_minitruck =
{
  file   = "decor/gtd_cars.wad",
  map    = "MAP02",

  can_be_on_roads = true,

  prob   = 7500,
  theme  = "urban",

  env = "!building",

  where  = "point",
  height = 128,
  size   = 128,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Decor_minitruck_beige =
{
  template = "Decor_minitruck",

  flat_FLAT23 = "CRATOP2",

  tex_SHAWN1 = "STUCCO",
  tex_SHAWN2 = "STUCCO",

  tex_SPCDOOR3 = "SPCDOOR4",
}

PREFABS.Decor_hatchback =
{
  template = "Decor_sedan",
  map = "MAP03",
}

PREFABS.Decor_hatchback_blue =
{
  template = "Decor_sedan",
  map = "MAP03",

  flat_FLAT5_3 = "CEIL4_2",

  tex_REDWALL = "COMPBLUE",
}

PREFABS.Decor_hatchback_brown =
{
  template = "Decor_sedan",
  map = "MAP03",

  flat_FLAT5_3 = "CEIL5_2",

  tex_REDWALL = "BROWN144",
}

PREFABS.Decor_minibus =
{
  template = "Decor_minitruck",
  map = "MAP04",
}

PREFABS.Decor_minibus_green =
{
  template = "Decor_minitruck",
  map = "MAP04",

  flat_FLAT23 = "GRASS1",
  tex_SHAWN2 = "BROWNGRN",
}
