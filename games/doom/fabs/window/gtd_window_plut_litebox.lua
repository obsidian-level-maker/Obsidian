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

--

PREFABS.Window_plut_litebox_1_offset_lite =
{
  template = "Window_plut_litebox_1",

  texture_pack = "armaetus",
  rank = 1,

  flat_FLOOR7_2 = "TLIT65OF"
}

PREFABS.Window_plut_litebox_2_offset_lite =
{
  template = "Window_plut_litebox_1",
  map = "MAP02",

  texture_pack = "armaetus",
  rank = 1,

  seed_w = 2,

  flat_FLOOR7_2 = "TLIT65OF"
}

PREFABS.Window_plut_litebox_3_offset_lite =
{
  template = "Window_plut_litebox_1",
  map = "MAP03",

  texture_pack = "armaetus",
  rank = 1,

  seed_w = 3,

  flat_FLOOR7_2 = "TLIT65OF"
}
