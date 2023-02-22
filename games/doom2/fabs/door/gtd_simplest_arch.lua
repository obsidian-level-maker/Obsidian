PREFABS.Arch_simplest =
{
  file = "door/gtd_simplest_arch.wad",
  map = "MAP01",

  prob = 75,

  kind = "arch",
  where = "edge",

  deep = 16,
  over = 16,

  seed_w = 1,

  x_fit = { 60,68 },
  z_fit = { 8,112 },

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Arch_simplest_columned =
{
  template = "Arch_simplest",
  map = "MAP02",

  seed_w = 2,

  x_fit = { 32,104 , 152,224 }
}

PREFABS.Arch_simplest_columned_2X =
{
  template = "Arch_simplest",
  map = "MAP03",

  seed_w = 3,

  x_fit = { 32,104 , 152,232, 280,352 }
}
