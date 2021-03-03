PREFABS.Wall_generic_glow_wall =
{
  file = "wall/gtd_wall_generic_glow_wall_set.wad",
  map = "MAP01",

  liquid = true,

  prob = 50,

  rank = 3,

  group = "gtd_generic_glow_wall",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 60,68 },
}

PREFABS.Wall_generic_glow_wall_diag =
{
  template = "Wall_generic_glow_wall",
  map = "MAP02",

  where = "diagonal",
}

--

PREFABS.Wall_generic_glow_wall_tech_no_liq =
{
  file = "wall/gtd_wall_generic_glow_wall_set.wad",
  map = "MAP01",

  prob = 50,

  rank = 1,

  group = "gtd_generic_glow_wall",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 60,68 },

  flat__LIQUID = "CEIL4_2",
}

PREFABS.Wall_generic_glow_wall_tech_no_liq_diag =
{
  template = "Wall_generic_glow_wall_tech_no_liq",
  map    = "MAP02",

  rank = 1,

  theme = "!hell",
  where  = "diagonal",

  flat__LIQUID = "CEIL4_2",
}

--

PREFABS.Wall_generic_glow_wall_hell_no_liq =
{
  template = "Wall_generic_glow_wall_tech_no_liq",

  rank = 2,

  theme = "hell",

  flat__LIQUID = "RROCK01",
}

PREFABS.Wall_generic_glow_wall_hell_no_liq_diag =
{
  template = "Wall_generic_glow_wall_tech_no_liq",
  map    = "MAP02",

  rank = 2,

  theme = "hell",
  where  = "diagonal",

  flat__LIQUID = "RROCK01",
}
