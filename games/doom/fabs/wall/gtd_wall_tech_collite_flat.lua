PREFABS.Wall_tech_collite_flat_green =
{
  file   = "wall/gtd_wall_tech_collite_flat.wad",
  map    = "MAP01",

  prob   = 50,

  group = "wall_collite_flat_green",
  texture_pack = "armaetus",

  where  = "edge",
  height = 96,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_tech_collite_flat_green_tall =
{
  template = "Wall_tech_collite_flat_green",
  map = "MAP02",

  height = 128,
  rank = 1,

  bound_z2 = 128,

  z_fit = { 54,56 , 68,69 }
}

PREFABS.Wall_tech_collite_flat_green_diag =
{
  template = "Wall_tech_collite_flat_green",
  map = "MAP03",

  where = "diagonal",
}

--

PREFABS.Wall_tech_collite_flat_blue_tall =
{
  template = "Wall_tech_collite_flat_green",

  group = "wall_collite_flat_blue",

  tex_COLLITE1 = "COLLITE3",
  tex_COMPGREN = "COMPBLUE",
  tex_TEKGREN2 = "TEKGRY01",
  flat_GRENFLOR = "FLAT14"
}

PREFABS.Wall_tech_collite_flat_blue_tall =
{
  template = "Wall_tech_collite_flat_green",
  map = "MAP02",

  group = "wall_collite_flat_blue",

  height = 128,
  rank = 1,

  bound_z2 = 128,

  z_fit = { 54,56 , 68,69 },

  tex_COLLITE1 = "COLLITE3",
  tex_COMPGREN = "COMPBLUE",
  tex_TEKGREN2 = "TEKGRY01",
  flat_GRENFLOR = "FLAT14"
}

PREFABS.Wall_tech_collite_flat_blue_diag =
{
  template = "Wall_tech_collite_flat_green",
  map = "MAP03",

  group = "wall_collite_flat_blue",

  where = "diagonal",

  tex_COLLITE1 = "COLLITE3",
  tex_COMPGREN = "COMPBLUE",
  tex_TEKGREN2 = "TEKGRY01",
  flat_GRENFLOR = "FLAT14"
}
