PREFABS.Decor_craneo_testtube_industrial =
{
  file = "decor/craneo_decor_bloodtubes_set.wad",
  map = "MAP01",

  engine = "zdoom",
  theme = "!hell",

  rank = 2,
  prob = 5000,

  group = "cran_bloodtubes_set",

  height = 104,
  where = "point",
  size = 80,

  bound_z1 = 0,
  bound_z2 = 104,

  thing_22 =
  {
    [22] = 50,
    [21] = 50,
    [20] = 50,
    [19] = 50,
    [18] = 50,
    [41] = 50,
    [42] = 50,
  }
}

PREFABS.Decor_craneo_bloodtubes_hell =
{
  template = "Decor_craneo_testtube_industrial",

  rank = 1,
  theme = "hell",

  tex_TEKGREN1 = "MARBLE3",
  tex_TEKGREN2 = "SKSNAKE2",
  tex_TEKGREN4 = "SKSPINE2",
  tex_TEKGREN5 = "GSTONE1",
  tex_SHAWN2 = "STONE4",
  tex_DOORSTOP = "METAL",
  tex_PIPEWAL2 = "SKSPINE2",
  tex_008800 = "FF0000",
  tex_BROWNGRN = "MARBLE1",
  flat_FLAT23 = "SFLR6_4",

  thing_9028 = 9027
}
