-- an imprecise replica of some windows found in Plutonia

PREFABS.Window_plut_litebox_1 =
{
  file   = "window/gtd_window_plut_litebox.wad",
  map    = "MAP01",

  group  = "gtd_window_plut_litebox",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_plut_litebox_2 =
{
  template = "Window_plut_litebox_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_plut_litebox_3 =
{
  template = "Window_plut_litebox_1",
  map      = "MAP03",

  seed_w   = 3,
}
