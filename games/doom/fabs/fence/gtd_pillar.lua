-- pillar do a pretty good job

PREFABS.Fence_pillar =
{
  file = "fence/gtd_pillar.wad",
  map = "MAP01",

  kind = "pillar",
  where  = "point",
  theme = "!tech",

  prob = 50,
  size = 16,

  height = 2,

  bound_z1 = 0,
}

PREFABS.Fence_pillar_tech =
{
  template = "Fence_pillar",
  map = "MAP02",

  theme = "tech",
}
