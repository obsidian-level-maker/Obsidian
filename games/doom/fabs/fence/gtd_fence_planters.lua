PREFABS.Fence_planters =
{
  file = "fence/gtd_fence_planters.wad",
  map = "MAP01",

  prob = 50,

  group = "fence_planters",

  where = "edge",
  theme = "!hell",

  deep = 16,
  over = 16,

  fence_h = 32,
  bound_z1 = 0,

  thing_43 =
  {
    [43] = 7,
    [54] = 4,
    [0] = 5
  }
}

PREFABS.Fence_planters_diag =
{
  template = "Fence_planters",
  map = "MAP02",

  where  = "diagonal"
}

--

PREFABS.Fence_planters_hell =
{
  template = "Fence_planters",

  theme = "hell",

  flat_GRASS1 = "SFLR6_4"
}

PREFABS.Fence_planters_diag_hell =
{
  template = "Fence_planters",
  map = "MAP02",

  theme = "hell",

  where = "diagonal",

  flat_GRASS1 = "SFLR6_4"
}
