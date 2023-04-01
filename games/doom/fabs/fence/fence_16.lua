--
-- Plain fence
--

PREFABS.Fence_plain =
{
  file = "fence/fence_16.wad",
  map = "MAP01",

  

  prob = 50,

  group = "PLAIN",

  where = "edge",

  passable = true,

  deep = 16,
  over = 16,

  fence_h = 32,
  bound_z1 = 0
}


PREFABS.Fence_plain_diag =
{
  template = "Fence_plain",
  map = "MAP02",

  where = "diagonal"
}
