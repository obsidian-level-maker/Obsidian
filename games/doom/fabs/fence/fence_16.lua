--
-- Plain fence
--

PREFABS.Fence_plain =
{
  file   = "fence/fence_16.wad",
  map    = "MAP01",

  prob   = 50,

  group  = "PLAIN",

  where  = "edge",

  passable = true,

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,
}


PREFABS.Fence_plain_diag =
{
  file   = "fence/fence_16.wad",
  map    = "MAP02",

  prob   = 50,

  group  = "PLAIN",

  passable = true,

  where  = "diagonal",

  fence_h = 32,

  bound_z1 = 0,
}
