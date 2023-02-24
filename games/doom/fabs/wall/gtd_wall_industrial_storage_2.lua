PREFABS.Wall_full_storage =
{
  file = "wall/gtd_wall_industrial_storage_2.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_full_storage",

  where = "edge",
  deep = 16,
  height = 96,

  seed_w= 1,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top",

  tex_CRATE1 = 
  {
    CRATE1 = 1,
    CRATE2 = 1,
    CRATE3 = 1,
    CRATELIT = 1,
    CRATINY = 1,
  }
}

PREFABS.Wall_full_storage_2 =
{
  template = "Wall_full_storage",
  map = "MAP02",

  prob = 8,
}

-- point decor --

PREFABS.Decor_full_storage_1 =
{
  file = "decor/crates1.wad",
  map = "MAP01",

  prob = 3500,
  group = "gtd_full_storage",

  height = 64,
  where = "point",
  size = 64,

  bound_z1 = 0,

  sink_mode = "never_liquids",
}

PREFABS.Decor_full_storage_1b =
{
  template = "Decor_full_storage_1",
  
  tex_CRATE1 = "CRATE2",
  flat_CRATOP2 = "CRATOP1"
}

PREFABS.Decor_full_storage_2 =
{
  template = "Decor_full_storage_1",
  map = "MAP02",

  prob = 7500,

  height = 128,

  tex_CRATELIT =
  {
    CRATELIT = 1,
    CRATE3 = 1,
  }
}

PREFABS.Decor_full_storage_3 =
{
  template = "Decor_full_storage_1",
  map = "MAP03",

  height = 64,

  size = 80,
}

PREFABS.Decor_full_storage_4 =
{
  template = "Decor_full_storage_1",
  map = "MAP04",

  prob = 7500,

  height = 128,

  size = 96,
}
