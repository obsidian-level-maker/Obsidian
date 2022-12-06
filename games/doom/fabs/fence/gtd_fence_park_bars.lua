PREFABS.Fence_park_bars =
{
  file = "fence/gtd_fence_park_bars.wad",
  map = "MAP01",

  prob = 50,

  group = "fence_park_bars",

  where = "edge",

  deep = 16,
  over = 16,

  fence_h = 40,
  bound_z1 = 0
}

PREFABS.Fence_park_bars_diag =
{
  template = "Fence_park_bars",
  map = "MAP02",

  where = "diagonal"
}

--

PREFABS.Fence_park_bars_round =
{
  template = "Fence_park_bars",

  group = "fence_park_bars_round",

  tex_MIDWIND6 = "FENCE9"
}

PREFABS.Fence_park_bars_round_diag =
{
  template = "Fence_park_bars",
  map = "MAP02",

  group = "fence_park_bars_round",

  where = "diagonal",

  tex_MIDWIND6 = "FENCE9"
}
