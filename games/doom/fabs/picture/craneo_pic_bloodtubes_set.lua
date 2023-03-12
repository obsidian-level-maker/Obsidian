PREFABS.Pic_craneo_testtube_industrial =
{
  file = "picture/craneo_pic_bloodtubes_set.wad",
  map = "MAP01",

  port = "zdoom",
  texture_pack = "armaetus",

  theme = "!hell",


  prob = 50,

  group = "cran_bloodtubes_set",
  where  = "seeds",
  height = 104,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",

  thing_22 =
  {
    [22] = 50,
    [21] = 50,
    [20] = 50,
    [19] = 50,
    [18] = 50,
    [41] = 50,
    [42] = 50,
  },
  thing_21 =
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

--

PREFABS.Pic_craneo_bloodtube_hell =
{
  template = "Pic_craneo_testtube_industrial",

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

  tex_EXITDOOR = "METAL",
  tex_METAL2 = "GSTONE1",
  tex_METAL3 = "GSTONE1",

  thing_9028 = 9027
}
