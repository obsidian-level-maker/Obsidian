PREFABS.Fence_tech_cover_low =
{
  file = "fence/gtd_fence_tech_cover.wad",
  map = "MAP01",

  prob = 50,

  group = "fence_tech_cover",

  where = "edge",

  deep = 16,
  over = 16,

  fence_h = 32,
  bound_z1 = 0
}

PREFABS.Fence_tech_cover_high =
{
  template = "Fence_tech_cover_low",
  map = "MAP02",

  port = "zdoom",

  prob = 15
}

PREFABS.Fence_tech_cover_high_limit =
{
  template = "Fence_tech_cover_low",
  map = "MAP02",

  port = "!zdoom",

  prob = 15,

  line_340 = 0 
}

PREFABS.Fence_tech_cover_diag =
{
  template = "Fence_tech_cover_low",
  map = "MAP03",

  where  = "diagonal"
}
