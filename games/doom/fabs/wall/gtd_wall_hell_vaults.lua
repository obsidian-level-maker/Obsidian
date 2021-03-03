PREFABS.Wall_hell_vaults_plain =
{
  file = "wall/gtd_wall_hell_vaults.wad",
  map = "MAP01",

  prob = 50,
  env = "building",

  group = "gtd_wall_hell_vaults",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "bottom",
}

PREFABS.Wall_hell_vaults_windowed =
{
  template = "Wall_hell_vaults_plain",

  map = "MAP02",

  prob = 20,
}

PREFABS.Wall_hell_vaults_diag =
{
  template = "Wall_hell_vaults_plain",
  map = "MAP03",

  prob = 50,
  where = "diagonal",
}

--

PREFABS.Wall_hell_vaults_floor_tex =
{
  template = "Wall_hell_vaults_plain",
  map = "MAP10",

  group = "gtd_wall_hell_vaults_ftex",
}

PREFABS.Wall_hell_vaults_floor_tex_diag =
{
  template = "Wall_hell_vaults_plain",
  map = "MAP11",

  where = "diagonal",

  group = "gtd_wall_hell_vaults_ftex",
}
