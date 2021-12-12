PREFABS.Window_arch_1 =
{
  file   = "window/window_arch_curved.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, strife=1 },

  group  = "window_arched",
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

PREFABS.Window_arch_2 =
{
  template = "Window_arch_1",
  map    = "MAP02",

  group  = "window_arched",

  seed_w = 2,
}

PREFABS.Window_arch_3 =
{
  template = "Window_arch_1",
  map    = "MAP03",

  group  = "window_arched",

  seed_w = 3,
}

PREFABS.Window_arch_1_tall =
{
  template = "Window_arch_1",
  map = "MAP01",

  group = "window_arched_tall",

  z_fit = { 26,30 },
}

PREFABS.Window_arch_2_tall =
{
  template = "Window_arch_1",
  map = "MAP02",

  group = "window_arched_tall",

  seed_w = 2,

  z_fit = { 26,30 },
}

PREFABS.Window_arch_3_tall =
{
  template = "Window_arch_1",
  map = "MAP03",

  group = "window_arched_tall",

  seed_w = 3,

  z_fit = { 26,30 },
}
