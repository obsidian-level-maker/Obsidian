PREFABS.Fence_firestorm =
{
  file   = "fence/gtd_fence_firestorm.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "fence_firestorm_red",

  where  = "edge",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,
}


PREFABS.Fence_firestorm_diag =
{
  file   = "fence/gtd_fence_firestorm.wad",
  map    = "MAP02",

  prob   = 50,

  group  = "fence_firestorm_red",

  where  = "diagonal",

  fence_h = 32,

  bound_z1 = 0,
}

PREFABS.Fence_firestorm_blue =
{
  template = "Fence_firestorm",

  group = "fence_firestorm_blue",

  flat_FLOOR1_6 = "FLAT14",
  tex_COMPRED = "COMPBLUE",
  tex_DOORRED = "DOORBLU",
}

PREFABS.Fence_firestorm_blue_diag =
{
  template = "Fence_firestorm_diag",

  group = "fence_firestorm_blue",

  flat_FLOOR1_6 = "FLAT14",
  tex_COMPRED = "COMPBLUE",
  tex_DOORRED = "DOORBLU",
}
