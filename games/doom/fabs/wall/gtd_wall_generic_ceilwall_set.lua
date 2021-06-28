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

-----------------
-- variation 2 --
-----------------

PREFABS.Wall_generic_ceilwall_2_industrial =
{
  template = "Wall_generic_ceilwall",
  map = "MAP03",

  theme = "!hell",
  height = 104,

  group = "gtd_generic_ceilwall_2",

  z_fit = "top",
  bound_z2 = 104,

  tex_TEKGREN1 = "TEKBRON2",
  tex_TEKGREN2 = "TEKBRON2"
}

PREFABS.Wall_generic_ceilwall_2_indstrial_diag =
{
  template = "Wall_generic_ceilwall",
  map = "MAP04",

  theme = "!hell",
  height = 104,

  group = "gtd_generic_ceilwall_2",

  where = "diagonal",

  z_fit = "top",
  bound_z2 = 104,

  tex_TEKGREN1 = "TEKBRON2",
  tex_TEKGREN2 = "TEKBRON2"
}

-- hell version

PREFABS.Wall_generic_ceilwall_2_gothic =
{
  template = "Wall_generic_ceilwall",
  map = "MAP03",

  rank = 1,

  theme = "hell",
  height = 104,

  group = "gtd_generic_ceilwall_2",

  z_fit = "top",
  bound_z2 = 104,

  tex_MIDBARS3 = "MIDBRONZ",
  tex_TEKGREN1 = {GSTGARG=1, GSTLION=1, GSTSATYR=1},
  tex_TEKGREN2 = {GSTGARG=1, GSTLION=1, GSTSATYR=1},
}

PREFABS.Wall_generic_ceilwall_2_gothic_diag =
{
  template = "Wall_generic_ceilwall",
  map = "MAP04",

  rank = 1,

  theme = "hell",
  height = 104,

  group = "gtd_generic_ceilwall_2",

  where = "diagonal",

  z_fit = "top",
  bound_z2 = 104,

  tex_MIDBARS3 = "MIDBRONZ",
  tex_TEKGREN1 = {GSTGARG=1, GSTLION=1, GSTSATYR=1},
  tex_TEKGREN2 = {GSTGARG=1, GSTLION=1, GSTSATYR=1},
}
