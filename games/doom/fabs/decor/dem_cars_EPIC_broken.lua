---Gtd's car modified to be looking broken---

PREFABS.Decor_sedan_broken_EPIC =
{
  file   = "decor/dem_cars_EPIC_broken.wad",
  map    = "MAP01",

  prob   = 5500,
  theme  = "urban",

  can_be_on_roads = true,

  texture_pack = "armaetus",

  replaces = "Decor_sedan",

  env = "!building",

  where  = "point",
  height = 128,
  size   = 128,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Decor_sedan_blue_broken_EPIC =
{
  template = "Decor_sedan_broken_EPIC",

  replaces = "Decor_sedan_blue",

  flat_FLAT5_3 = "CEIL4_2",

  tex_REDWALL = "COMPBLUE",
}

PREFABS.Decor_sedan_brown_broken_EPIC =
{
  template = "Decor_sedan_broken_EPIC",

  replaces = "Decor_sedan_brown",

  flat_FLAT5_3 = "CEIL5_2",

  tex_REDWALL = "BROWN144",
}

PREFABS.Decor_minitruck_broken_EPIC =
{
  file   = "decor/dem_cars_EPIC_broken.wad",
  map    = "MAP02",

  can_be_on_roads = true,

  texture_pack = "armaetus",

  replaces = "Decor_minitruck",

  prob   = 6500,
  theme  = "urban",

  env = "!building",

  where  = "point",
  height = 128,
  size   = 128,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Decor_minitruck_beige_broken_EPIC =
{
  template = "Decor_minitruck_broken_EPIC",

  replaces = "Decor_minitruck_beige",

  flat_FLAT23 = "CRATOP2",

  tex_SHAWN1 = "STUCCO",
  tex_SHAWN2 = "STUCCO",

  tex_SPCDOOR3 = "SPCDOOR4",
}

PREFABS.Decor_hatchback_broken_EPIC =
{
  template = "Decor_sedan_broken_EPIC",

  replaces = "Decor_hatchback",

  map = "MAP03",
}

PREFABS.Decor_hatchback_blue_broken_EPIC =
{
  template = "Decor_sedan_broken_EPIC",
  map = "MAP03",

  replaces = "Decor_hatchback_blue",

  flat_FLAT5_3 = "CEIL4_2",

  tex_REDWALL = "COMPBLUE",
}

PREFABS.Decor_hatchback_brown_broken_EPIC =
{
  template = "Decor_sedan_broken_EPIC",
  map = "MAP03",

  replaces = "Decor_hatchback_brown",

  flat_FLAT5_3 = "CEIL5_2",

  tex_REDWALL = "BROWN144",
}

PREFABS.Decor_minibus_broken_EPIC =
{
  template = "Decor_minitruck_broken_EPIC",

  replaces = "Decor_minibus",

  map = "MAP04",

}

PREFABS.Decor_minibus_green_broken_EPIC =
{
  template = "Decor_minitruck_broken_EPIC",
  map = "MAP04",

  replaces = "Decor_minibus_green",

  flat_FLAT23 = "GRASS1",
  tex_SHAWN2 = "BROWNGRN",
}
