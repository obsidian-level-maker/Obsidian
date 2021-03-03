PREFABS.Wall_generic_ceilwall =
{
  file   = "wall/gtd_wall_generic_ceilwall_set.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "tech",

  group  = "gtd_generic_ceilwall",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = {88, 92},
}

PREFABS.Wall_generic_ceilwall_diag =
{
  template = "Wall_generic_ceilwall",
  map    = "MAP02",

  where  = "diagonal",
}

-- urban

PREFABS.Wall_generic_ceilwall_urban =
{
  template = "Wall_generic_ceilwall",

  theme = "urban",

  tex_COMPBLUE = "LITE3",
  tex_BRNSMALC = "MIDBARS3",
}

PREFABS.Wall_generic_ceilwall_diag_urban =
{
  template = "Wall_generic_ceilwall",
  map = "MAP02",

  where = "diagonal",

  theme = "urban",

  tex_COMPBLUE = "LITE3",
  tex_BRNSMALC = "MIDBARS3",
}

-- hell

PREFABS.Wall_generic_ceilwall_hell =
{
  template = "Wall_generic_ceilwall",

  theme = "hell",

  tex_COMPBLUE = "ROCKRED1",
  tex_BRNSMALC = "MIDGRATE",
}

PREFABS.Wall_generic_ceilwall_diag_hell =
{
  template = "Wall_generic_ceilwall",
  map = "MAP02",

  where = "diagonal",

  theme = "hell",

  tex_COMPBLUE = "ROCKRED1",
  tex_BRNSMALC = "MIDGRATE",
}
