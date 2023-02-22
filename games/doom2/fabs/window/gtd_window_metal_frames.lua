PREFABS.Window_metal_frame_1 =
{
  file   = "window/gtd_window_metal_frames.wad",
  map    = "MAP01",

  group  = "gtd_window_metal_frames",
  prob   = 50,

  theme = "!hell",

  passable = true,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = {48,64},
}

PREFABS.Window_metal_frame_2 =
{
  template = "Window_metal_frame_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_metal_frame_3 =
{
  template = "Window_metal_frame_1",
  map      = "MAP03",

  seed_w   = 3,
}

PREFABS.Window_metal_frame_1_hell =
{
  template = "Window_metal_frame_1",
  map      = "MAP01",

  theme = "hell",

  tex_STEP4 = "METAL",
  tex_DOORSTOP = "METAL",
  flat_FLAT23 = "CEIL5_2",
}

PREFABS.Window_metal_frame_2_hell =
{
  template = "Window_metal_frame_1",
  map      = "MAP02",

  seed_w = 2,

  theme = "hell",

  tex_STEP4 = "METAL",
  tex_DOORSTOP = "METAL",
  flat_FLAT23 = "CEIL5_2",
}

PREFABS.Window_metal_frame_3_hell =
{
  template = "Window_metal_frame_1",
  map      = "MAP03",

  seed_w = 3,

  theme = "hell",

  tex_STEP4 = "METAL",
  tex_DOORSTOP = "METAL",
  flat_FLAT23 = "CEIL5_2",
}
