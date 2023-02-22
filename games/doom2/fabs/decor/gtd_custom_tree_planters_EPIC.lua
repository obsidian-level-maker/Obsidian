PREFABS.Decor_square_planter_grass =
{
  file   = "decor/gtd_custom_tree_planters_EPIC.wad",
  map    = "MAP01",

  texture_pack = "armaetus",

  outdoor_theme = "temperate",

  prob   = 5000,
  theme  = "!hell",
  env    = "outdoor",

  where  = "point",
  size   = 128,

  bound_z1 = 0,
}

PREFABS.Decor_square_planter_sand =
{
  template = "Decor_square_planter_grass",
  map      = "MAP02",

  outdoor_theme = "desert",
}

PREFABS.Decor_square_planter_snow =
{
  template = "Decor_square_planter_grass",
  map      = "MAP03",

  outdoor_theme = "snow",
}

PREFABS.Decor_round_planter_grass =
{
  template = "Decor_square_planter_grass",
  map      = "MAP04",
}

PREFABS.Decor_round_planter_grass =
{
  template = "Decor_square_planter_grass",
  map      = "MAP05",

  outdoor_theme = "desert",
}

PREFABS.Decor_round_planter_grass =
{
  template = "Decor_square_planter_grass",
  map      = "MAP06",

  outdoor_theme = "snow",
}

-------------------
-- hell variants --
-------------------

PREFABS.Decor_square_planter_grass_hell =
{
  template = "Decor_square_planter_grass",
  map      = "MAP02",

  outdoor_theme = "grass",

  theme = "hell",

  flat_FLAT19 = "FLOOR7_2",
  tex_STEP4 = "MARBGRAY",
  flat_GRASS1 = "FLOOR6_1",
}

PREFABS.Decor_square_planter_sand_hell =
{
  template = "Decor_square_planter_grass",
  map      = "MAP02",

  outdoor_theme = "desert",

  theme = "hell",

  flat_FLAT19 = "FLOOR7_2",
  tex_STEP4 = "MARBGRAY",
}

PREFABS.Decor_square_planter_snow_hell =
{
  template = "Decor_square_planter_grass",
  map      = "MAP03",

  outdoor_theme = "snow",

  theme = "hell",

  flat_FLAT19 = "FLOOR7_2",
  tex_STEP4 = "MARBGRAY",
}

PREFABS.Decor_round_planter_grass_hell =
{
  template = "Decor_square_planter_grass",
  map = "MAP04",

  theme = "hell",

  flat_FLAT19 = "FLOOR7_2",
  tex_STEP4 = "MARBGRAY",
  flat_GRASS1 = "FLOOR6_1",
}

PREFABS.Decor_round_planter_sand_hell =
{
  template = "Decor_square_planter_grass",
  map = "MAP05",

  outdoor_theme = "desert",

  theme = "hell",

  flat_FLAT19 = "FLOOR7_2",
  tex_STEP4 = "MARBGRAY",
}

PREFABS.Decor_round_planter_snow_hell =
{
  template = "Decor_square_planter_grass",
  map = "MAP06",

  outdoor_theme = "snow",

  theme = "hell",

  flat_FLAT19 = "FLOOR7_2",
  tex_STEP4 = "MARBGRAY",
}
