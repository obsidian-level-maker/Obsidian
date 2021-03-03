PREFABS.Wall_generic_beamed_inset =
{
  file = "wall/gtd_wall_generic_beamed_inset.wad",
  map = "MAP01",

  prob = 50,
  theme = "!hell",
  env = "building",

  group = "gtd_generic_beamed_inset",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = {64, 70},
}

PREFABS.Wall_generic_beamed_inset_diag =
{
  template   = "Wall_generic_beamed_inset",
  map = "MAP02",

  where = "diagonal",
}

--

PREFABS.Wall_generic_beamed_inset_hell =
{
  template = "Wall_generic_beamed_inset",

  theme = "hell",

  tex_METAL7 = "METAL2",
}

PREFABS.Wall_generic_beamed_inset_diag_hell =
{
  template = "Wall_generic_beamed_inset",
  map = "MAP02",

  theme = "hell",

  where = "diagonal",

  tex_METAL7 = "METAL2",
}
