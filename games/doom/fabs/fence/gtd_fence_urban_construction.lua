PREFABS.Fence_urban_construction_fence =
{
  file   = "fence/gtd_fence_urban_construction.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "fence_construction",

  where  = "edge",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,
}

PREFABS.Fence_urban_construction_fence_peek_a_boo =
{
  template = "Fence_urban_construction_fence",
  map      = "MAP02",

  prob     = 10,
}

PREFABS.Fence_urban_construction_fence_ad =
{
  template = "Fence_urban_construction_fence",
  map      = "MAP03",

  prob     = 10,
}

PREFABS.Fence_urban_construction_fence_diag =
{
  file   = "fence/gtd_fence_urban_construction.wad",
  map    = "MAP04",

  prob   = 50,

  group  = "fence_construction",

  where  = "diagonal",

  fence_h = 32,

  bound_z1 = 0,
}
