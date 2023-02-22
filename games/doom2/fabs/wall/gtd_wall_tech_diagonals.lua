PREFABS.Wall_tech_diag_outcrop =
{
  file   = "wall/gtd_wall_tech_diagonals.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "tech",
  env   = "building",

  where  = "diagonal",
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 32,40 },
}

PREFABS.Wall_tech_diag_outcrop_outdoor =
{
  template = "Wall_tech_diag_outcrop",

  env = "outdoor",
}

PREFABS.Wall_tech_diag_triple_braced =
{
  template = "Wall_tech_diag_outcrop",
  map      = "MAP02",
}

PREFABS.Wall_tech_diag_triple_braced_outdoor =
{
  template = "Wall_tech_diag_outcrop",
  map      = "MAP02",

  env = "outdoor",
}

PREFABS.Wall_tech_diag_overhead_roof =
{
  template = "Wall_tech_diag_outcrop",
  map = "MAP03",

  env    = "outdoor",

  z_fit  = { 32,40 },
}

PREFABS.Wall_diag_generic_top_band =
{
  template = "Wall_tech_diag_outcrop",
  map = "MAP04",

  prob = 50,

  env = "any",

  tex_METAL5 =
  {
    METAL2 = 2,
    METAL3 = 1,
    METAL5 = 1,
  },
}

PREFABS.Wall_diag_generic_side_band =
{
  template = "Wall_tech_diag_outcrop",
  map = "MAP05",

  prob = 50,

  env = "any",
}
