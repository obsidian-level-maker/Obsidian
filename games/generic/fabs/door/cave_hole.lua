--
-- Cavey archway with vines
--

PREFABS.Arch_viney1x1 =
{
  file   = "door/cave_hole.wad",
  map    = "MAP01",

  prob = 400,

  env      = "cave",
  neighbor = "any",

  kind   = "arch",
  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 132,
}

PREFABS.Arch_viney1x1_B =
{
  template = "Arch_viney1x1",

  env      = "any",
  neighbor = "cave",
}


PREFABS.Door_viney1 =
{
  template = "Arch_viney1x1",

  kind  = "door",
}

PREFABS.Arch_viney1 =
{
  file   = "door/cave_hole.wad",
  map    = "MAP02",

  prob = 400,

  env      = "cave",
  neighbor = "any",

  kind   = "arch",
  where  = "edge",
  seed_w = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 132,
}


PREFABS.Arch_viney1_B =
{
  template = "Arch_viney1",

  env      = "any",
  neighbor = "cave",
}


PREFABS.Door_viney1 =
{
  template = "Arch_viney1",

  kind  = "door",
}

