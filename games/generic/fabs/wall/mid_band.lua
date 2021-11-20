--
-- Wall with horizontal band
--

PREFABS.Wall_midband =
{
  file   = "wall/mid_band.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=1 },

  prob   = 50,
  group  = "mid_band",

  where  = "edge",
  deep   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 80,

  z_fit  = "top",
}

PREFABS.Wall_midband_chex3 =
{
  template = "Wall_midband",
  game = "chex3",

  forced_offsets =
  {
    [15] = { x=0, y=3 }
  }
}

PREFABS.Wall_midband_hacx =
{
  template = "Wall_midband",
  game = "hacx",

  forced_offsets =
  {
    [15] = { x=0, y=6 }
  }
}

PREFABS.Wall_midband_harmony =
{
  template = "Wall_midband",
  game = "harmony",

  forced_offsets =
  {
    [15] = { x=0, y=5 }
  }
}

PREFABS.Wall_midband_heretic =
{
  template = "Wall_midband",
  game = "heretic",

  forced_offsets =
  {
    [15] = { x=1, y=-4 }
  }
}

PREFABS.Wall_midband_diag =
{
  file   = "wall/mid_band.wad",
  map    = "MAP02",

  prob   = 50,
  group  = "mid_band",

  where  = "diagonal",
  height = 96,

  bound_z1 = 0,
  bound_z2 = 80,

  z_fit  = "top",
}

PREFABS.Wall_midband_diag_chex3 =
{
  template = "Wall_midband_diag",
  game = "chex3",

  forced_offsets =
  {
    [15] = { x=0, y=3 }
  }
}

PREFABS.Wall_midband_diag_hacx =
{
  template = "Wall_midband_diag",
  game = "hacx",

  forced_offsets =
  {
    [15] = { x=0, y=6 }
  }
}

PREFABS.Wall_midband_diag_harmony =
{
  template = "Wall_midband_diag",
  game = "harmony",

  forced_offsets =
  {
    [15] = { x=0, y=5 }
  }
}

PREFABS.Wall_midband_diag_heretic =
{
  template = "Wall_midband_diag",
  game = "heretic",

  forced_offsets =
  {
    [15] = { x=0, y=-4 }
  }
}
