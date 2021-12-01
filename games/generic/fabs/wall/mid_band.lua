--
-- Wall with horizontal band
--

PREFABS.Wall_mid_band =
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

PREFABS.Wall_mid_band_chex3 =
{
  template = "Wall_mid_band",
  game = "chex3",

  forced_offsets =
  {
    [15] = { x=0, y=3 }
  }
}

PREFABS.Wall_mid_band_hacx =
{
  template = "Wall_mid_band",
  game = "hacx",

  forced_offsets =
  {
    [15] = { x=0, y=6 }
  }
}

PREFABS.Wall_mid_band_harmony =
{
  template = "Wall_mid_band",
  game = "harmony",

  forced_offsets =
  {
    [15] = { x=0, y=5 }
  }
}

PREFABS.Wall_mid_band_heretic =
{
  template = "Wall_mid_band",
  game = "heretic",

  forced_offsets =
  {
    [15] = { x=1, y=-4 }
  }
}

PREFABS.Wall_mid_band_diag =
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

PREFABS.Wall_mid_band_diag_chex3 =
{
  template = "Wall_mid_band_diag",
  game = "chex3",

  forced_offsets =
  {
    [15] = { x=0, y=3 }
  }
}

PREFABS.Wall_mid_band_diag_hacx =
{
  template = "Wall_mid_band_diag",
  game = "hacx",

  forced_offsets =
  {
    [15] = { x=0, y=6 }
  }
}

PREFABS.Wall_mid_band_diag_harmony =
{
  template = "Wall_mid_band_diag",
  game = "harmony",

  forced_offsets =
  {
    [15] = { x=0, y=5 }
  }
}

PREFABS.Wall_mid_band_diag_heretic =
{
  template = "Wall_mid_band_diag",
  game = "heretic",

  forced_offsets =
  {
    [15] = { x=0, y=-4 }
  }
}
