PREFABS.Window_arched_inverse_1 =
{
  file   = "window/gtd_window_arch_curved_inverted.wad",
  map    = "MAP01",

  group  = "gtd_window_arched_inverse",
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

PREFABS.Window_arched_inverse_1_tall =
{
  template = "Window_arched_inverse_1",
  map = "MAP01",
  prob = 25,

  z_fit = { 80,112 }
}

PREFABS.Window_arched_inverse_2 =
{
  template = "Window_arched_inverse_1",
  map    = "MAP02",

  seed_w = 2,
}

PREFABS.Window_arched_inverse_3 =
{
  template = "Window_arched_inverse_1",
  map    = "MAP03",

  seed_w = 3,
}
