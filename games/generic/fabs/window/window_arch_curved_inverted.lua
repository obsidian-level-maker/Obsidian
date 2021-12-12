PREFABS.Window_arch_inverse_1 =
{
  file   = "window/window_arch_curved_inverted.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, strife=1 },

  group  = "window_arched_inverted",
  prob   = 50,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_arch_inverse_1_tall =
{
  template = "Window_arch_inverse_1",
  map = "MAP01",
  prob = 25,

  z_fit = { 80,112 }
}

PREFABS.Window_arch_inverse_2 =
{
  template = "Window_arch_inverse_1",
  map    = "MAP02",

  seed_w = 2,
}

PREFABS.Window_arch_inverse_3 =
{
  template = "Window_arch_inverse_1",
  map    = "MAP03",

  seed_w = 3,
}
