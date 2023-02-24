PREFABS.Wall_hell_bloodgutters1 =
{
  file   = "wall/gtd_wall_hell_bloodgutters.wad",
  map    = "MAP01",

  prob   = 50,
  theme  = "hell",
  env = "building",

  group = "gtd_wall_hell_bloodgutters",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_hell_bloodgutters2 =
{
  template = "Wall_hell_bloodgutters1",

  map = "MAP02",
}

PREFABS.Wall_hell_bloodgutters_diag =
{
  file   = "wall/gtd_wall_hell_bloodgutters.wad",
  map    = "MAP03",

  prob   = 50,
  theme  = "hell",
  group = "gtd_wall_hell_bloodgutters",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_hell_bloodgutters3 =
{
  template = "Wall_hell_bloodgutters1",

  map = "MAP04",

  tex_SP_DUDE4 =
  {
    SP_DUDE4 = 50,
    SP_DUDE5 = 50,
  },
}

-- This utilizes the Doom1 textures not seen in Doom 2,
PREFABS.Wall_hell_bloodgutters3_EPIC =
{
  template = "Wall_hell_bloodgutters1",
  replaces = "Wall_hell_bloodgutters3",

  texture_pack = "armaetus",
  map = "MAP04",

  tex_SP_DUDE4 =
  {
    SP_DUDE4 = 50,
    SP_DUDE5 = 50,
    SPDUDE3  = 50,
    SPDUDE6  = 25,
  },
}
