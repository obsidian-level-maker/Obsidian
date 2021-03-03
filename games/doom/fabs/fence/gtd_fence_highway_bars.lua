PREFABS.Fence_highway_bars =
{
  file   = "fence/gtd_fence_highway_bars.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "fence_highway_bars",

  where  = "edge",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,
}


PREFABS.Fence_highway_bars_diag =
{
  file   = "fence/gtd_fence_highway_bars.wad",
  map    = "MAP02",

  prob   = 50,

  group  = "fence_highway_bars",

  where  = "diagonal",

  fence_h = 32,

  bound_z1 = 0,
}

--

PREFABS.Fence_highway_bars_warnstep =
{
  template = "Fence_highway_bars",

  group = "fence_highway_bars_warnstep",

  texture_pack = "armaetus",

  tex_STEP4 = "WARNSTEP",
}


PREFABS.Fence_highway_bars_diag_warnstep =
{
  template = "Fence_highway_bars_diag",

  group = "fence_highway_bars_warnstep",

  texture_pack = "armaetus",

  tex_STEP4 = "WARNSTEP",
}
