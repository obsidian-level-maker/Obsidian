PREFABS.Window_low_gap_closed_1 =
{
  file   = "window/gtd_windows_low_gap_closed.wad",
  map    = "MAP01",

  group  = "gtd_window_low_gap_closed",
  prob   = 50,
  theme = "!hell",
  rank = 1,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = "frame"
}

PREFABS.Window_low_gap_closed_2 =
{
  template = "Window_low_gap_closed_1",
  map      = "MAP02",

  seed_w   = 2
}

PREFABS.Window_low_gap_closed_3 =
{
  template = "Window_low_gap_closed_1",

  map      = "MAP03",
  seed_w   = 3
}

PREFABS.Window_low_gap_closed_4 =
{
  template = "Window_low_gap_closed_1",

  map      = "MAP04",
  seed_w   = 4
}

--

PREFABS.Window_low_gap_closed_1_hell =
{
  template = "Window_low_gap_closed_1",
  map = "MAP01",

  theme = "hell",
  rank = 2,

  flat_FLAT1 = "CEIL5_2",
  flat_FLAT3 = "FLAT10",
  tex_STEP4 = "STEP3",
  tex_SHAWN2 = "METAL",
  tex_DOORSTOP = "BRONZE3"
}

PREFABS.Window_low_gap_closed_2_hell =
{
  template = "Window_low_gap_closed_1",
  map = "MAP02",

  theme = "hell",
  rank = 2,
  seed_w = 2,

  flat_FLAT1 = "CEIL5_2",
  flat_FLAT3 = "FLAT10",
  tex_STEP4 = "STEP3",
  tex_SHAWN2 = "METAL",
  tex_DOORSTOP = "BRONZE3"
}

PREFABS.Window_low_gap_closed_3_hell =
{
  template = "Window_low_gap_closed_1",
  map = "MAP03",

  theme = "hell",
  rank = 2,
  seed_w = 3,

  flat_FLAT1 = "CEIL5_2",
  flat_FLAT3 = "FLAT10",
  tex_STEP4 = "STEP3",
  tex_SHAWN2 = "METAL",
  tex_DOORSTOP = "BRONZE3"
}

PREFABS.Window_low_gap_closed_4_hell =
{
  template = "Window_low_gap_closed_1",
  map = "MAP04",

  theme = "hell",
  rank = 2,
  seed_w = 4,

  flat_FLAT1 = "CEIL5_2",
  flat_FLAT3 = "FLAT10",
  tex_STEP4 = "STEP3",
  tex_SHAWN2 = "METAL",
  tex_DOORSTOP = "BRONZE3"
}
