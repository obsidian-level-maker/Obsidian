PREFABS.Fence_jurassic_park_straight =
{
  file = "fence/gtd_fence_tech_jurassic_park_EPIC.wad",
  map = "MAP01",

  prob = 50,
  port = "zdoom",

  rank = 2,

  texture_pack = "armaetus",

  group = "fence_jurassic_park",

  post_offset_h = 96,

  where = "edge",

  deep = 16,
  over = 16,

  fence_h  = 32,
  bound_z1 = 0
}

PREFABS.Fence_jurassic_park_diag =
{
  template = "Fence_jurassic_park_straight",
  map = "MAP02",

  where = "diagonal"
}

PREFABS.Fence_jurassic_park_straight_battery =
{
  template = "Fence_jurassic_park_straight",
  map = "MAP03",

  prob = 10
}

--

PREFABS.Fence_jurassic_park_straight_limit =
{
  file = "fence/gtd_fence_tech_jurassic_park_EPIC.wad",
  map = "MAP01",

  prob = 50,

  group = "fence_jurassic_park",

  post_offset_h = 96,

  where = "edge",

  deep = 16,
  over = 16,

  fence_h  = 32,
  bound_z1 = 0,

  tex_FENCE2 = "MIDBARS1",
  tex_MIDSPAC5 = "MIDBARS1",
  tex_WARNSTEP = "STEPTOP"
}

PREFABS.Fence_jurassic_park_diag_limit =
{
  template = "Fence_jurassic_park_straight_limit",
  map = "MAP02",

  where = "diagonal"
}

PREFABS.Fence_jurassic_park_straight_battery_limit =
{
  template = "Fence_jurassic_park_straight_limit",
  map = "MAP03",

  prob = 10
}
