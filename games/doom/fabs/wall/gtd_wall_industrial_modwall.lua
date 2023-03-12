PREFABS.Wall_industrial_modwall_1 =
{
  file = "wall/gtd_wall_industrial_modwall.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_ind_modwall_1",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_industrial_modwall_1a =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP02",

  prob = 120
}

PREFABS.Wall_industrial_modwall_1_diag =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP03",

  where = "diagonal"
}

PREFABS.Wall_industrial_modwall_1_hell =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP51",

  theme = "hell",


  prob = 50,

  height = 128
}

PREFABS.Wall_industrial_modwall_1a_hell =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP52",

  theme = "hell",


  prob = 120
}

PREFABS.Wall_industrial_modwall_1a_hell_diag =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP53",

  theme = "hell",


  where = "diagonal",

  prob = 120
}

--

PREFABS.Wall_industrial_modwall_2 =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP06",

  group = "gtd_ind_modwall_2"
}

PREFABS.Wall_industrial_modwall_2a =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP07",

  group = "gtd_ind_modwall_2"
}

--

PREFABS.Wall_industrial_modwall_3 =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP11",

  group = "gtd_ind_modwall_3",

  z_fit = {48,56}
}

PREFABS.Wall_industrial_modwall_3_diag =
{
  template = "Wall_industrial_modwall_1",
  map = "MAP13",

  where = "diagonal",

  group = "gtd_ind_modwall_3",

  z_fit = {48,56}
}
