--
-- this window is just grate!
--

PREFABS.Window_grate_1 =
{
  file   = "window/grate.wad",
  map    = "MAP01",
  theme    = "!tech",
  group  = "grate",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_grate_1_midspace =
{
  template = "Window_grate_1",
  map      = "MAP01",
  theme    = "tech",
  tex_MIDBARS3 = "MIDSPACE",
}

PREFABS.Window_grate_2 =
{
  template = "Window_grate_1",
  map      = "MAP02",
  theme    = "!tech",
  seed_w   = 2,
}

PREFABS.Window_grate_2_midspace =
{
  template = "Window_grate_1",
  map      = "MAP02",
  theme    = "tech",
  tex_MIDBARS3 = "MIDSPACE",
  seed_w = 2,
}

PREFABS.Window_grate_3 =
{
  template = "Window_grate_1",
  map      = "MAP03",
  theme    = "!tech",
  seed_w   = 3,
}

PREFABS.Window_grate_3_midspace =
{
  template = "Window_grate_1",
  map      = "MAP03",
  theme    = "tech",
  tex_MIDBARS3 = "MIDSPACE",
  seed_w = 3,
}
