PREFABS.Window_gtd_construction_frames_1_1 =
{
  file   = "window/gtd_window_construction_frames.wad",
  map    = "MAP01",

  group  = "gtd_window_construction_frames",

  prob   = 50,

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64,68 },
}

PREFABS.Window_gtd_construction_frames_1_2 =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP02",
}

PREFABS.Window_gtd_construction_frames_1_3 =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP03",
}

PREFABS.Window_gtd_construction_frames_1_4 =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP04",
}

PREFABS.Window_gtd_construction_frames_2 =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP05",

  seed_w = 2,
}

PREFABS.Window_gtd_construction_frames_3 =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP06",

  seed_w = 3,
}

-- alt fits

PREFABS.Window_gtd_construction_frames_1_1_low =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP01",

  z_fit = "bottom",
}

PREFABS.Window_gtd_construction_frames_1_1_high =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP01",

  z_fit = "top",
}

PREFABS.Window_gtd_construction_frames_1_2_low =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP02",

  z_fit = "bottom",
}

PREFABS.Window_gtd_construction_frames_1_2_high =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP02",

  z_fit = "top",
}

PREFABS.Window_gtd_construction_frames_1_3_low =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP03",

  z_fit = "bottom",
}

PREFABS.Window_gtd_construction_frames_1_3_high =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP03",

  z_fit = "top",
}

-- 2x

PREFABS.Window_gtd_construction_frames_2_high =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP05",

  seed_w = 2,

  z_fit = "top",
}

PREFABS.Window_gtd_construction_frames_2_low =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP05",

  seed_w = 2,

  z_fit = "bottom",
}

-- 3x

PREFABS.Window_gtd_construction_frames_3_high =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP06",

  seed_w = 3,

  z_fit = "top",
}

PREFABS.Window_gtd_construction_frames_3_low =
{
  template   = "Window_gtd_construction_frames_1_1",
  map    = "MAP06",

  seed_w = 3,

  z_fit = "bottom",
}
