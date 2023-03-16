PREFABS.Wall_generic_tek_grate_tech =
{
  file = "wall/gtd_wall_generic_tek_grates.wad",
  map = "MAP01",

  prob = 50,
  theme = "!hell",

  group = "gtd_generic_tek_grate",

  where = "edge",
  height = 128,
  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",
}

PREFABS.Wall_generic_tek_grate_tech_diagonal =
{
  template = "Wall_generic_tek_grate_tech",
  map    = "MAP02",

  where  = "diagonal",
}

--

PREFABS.Wall_generic_tek_grate_hell =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP01",

  theme = "hell",

  tex_METAL7 = "WOODMET1",
  tex_TEKWALL4 = "FIREMAG1",
  tex_MIDBARS3 = "MIDGRATE",
}

PREFABS.Wall_generic_tek_grate_hell_diagonal =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP02",

  theme = "hell",

  where = "diagonal",

  tex_METAL7 = "WOODMET1",
  tex_TEKWALL4 = "FIREMAG1",
  tex_MIDBARS3 = "MIDGRATE",
}

--

PREFABS.Wall_generic_tek_grate_bottom_slope_tech =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP03",

  port = "zdoom",

  rank = 2,
  group = "gtd_generic_tek_grate_bottom_slope",

  deep = 32
}

PREFABS.Wall_generic_tek_grate_bottom_slope_hell =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP03",

  port = "zdoom",
  theme = "hell",

  rank = 2,
  deep = 32,

  group = "gtd_generic_tek_grate_bottom_slope",

  tex_TEKWALL4 = "SP_FACE2",
  tex_MIDBARS3 = "MIDGRATE"
}

--

PREFABS.Wall_generic_tek_grate_bottom_slope_tech_limit =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP03",

  port = "!zdoom",

  rank = 1,
  group = "gtd_generic_tek_grate_bottom_slope",

  deep = 32,

  line_341 = 0
}

PREFABS.Wall_generic_tek_grate_bottom_slope_hell_limit =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP03",

  port = "!zdoom",

  rank = 1,
  group = "gtd_generic_tek_grate_bottom_slope",

  deep = 32,

  line_341 = 0
}

--

PREFABS.Wall_generic_tek_grate_xit_machine =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP05",

  theme = "any",

  group = "gtd_generic_tek_grate_xit_machine",

  height = 96,
  deep = 16,

  bound_z2 = 96
}

PREFABS.Wall_generic_tek_grate_xit_machine_diag =
{
  template = "Wall_generic_tek_grate_tech",
  map = "MAP06",

  theme = "any",
  where = "diagonal",
  group = "gtd_generic_tek_grate_xit_machine",

  height = 96,
  deep = 16,

  bound_z2 = 96
}
