-- Adapted from GTD's set

PREFABS.Wall_generic_beamed_inset =
{
  file = "wall/beamed_inset.wad",
  map = "MAP01",

  prob = 50,
  env = "building",

  group = "beamed_inset",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = {64, 70},
}

PREFABS.Wall_generic_beamed_inset_diag =
{
  template = "Wall_generic_beamed_inset",
  map = "MAP02",

  where = "diagonal",
}

PREFABS.Wall_generic_beamed_green_inset =
{
  template = "Wall_generic_beamed_inset",
  map = "MAP03",

  group = "beamed_inset_alt"
}

PREFABS.Wall_generic_beamed_green_inset_diag =
{
  template = "Wall_generic_beamed_inset",
  map = "MAP04",

  where = "diagonal",

  group = "beamed_inset_alt"
}
