PREFABS.Window_chainlink_1 =
{
  file   = "window/gtd_window_chainlinks.wad",
  map    = "MAP01",

  group  = "gtd_window_chainlinks",

  texture_pack = "armaetus",

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_chainlink_2_even =
{
  template = "Window_chainlink_1",
  map    = "MAP02",

  seed_w = 2,
}

PREFABS.Window_chainlink_2_uneven =
{
  template = "Window_chainlink_1",
  map    = "MAP03",

  seed_w = 2,
}

PREFABS.Window_chainlink_3_machine =
{
  template = "Window_chainlink_1",
  map    = "MAP04",

  theme = "!hell",

  prob = 30,

  seed_w = 3,
}

PREFABS.Window_chainlink_3_plain =
{
  template = "Window_chainlink_1",
  map    = "MAP05",

  seed_w = 3,
}
