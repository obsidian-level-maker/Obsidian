PREFABS.Wall_cran_testtubes_industrial =
{
  file = "wall/craneo_wall_bloodtubes_set.wad",
  map = "MAP01",

  rank = 2,
  prob = 50,
  theme = "!hell",
  engine = "zdoom",
  texture_pack = "armaetus",


  group = "cran_bloodtubes_set",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top",
}

PREFABS.Wall_cran_bloodtubes_hell =
{
  template = "Wall_cran_testtubes_industrial",
  
  rank = 1,
  theme = "hell",

  tex_TEKGREN1 = "MARBLE3",
  tex_TEKGREN5 = "GSTONE1",
  tex_SHAWN2 = "STONE4",
  tex_DOORSTOP = "METAL",
  tex_PIPEWAL2 = "SKSPINE2",
  tex_008000 = "FF0000",
  flat_FLAT23 = "SFLR6_4"
}
