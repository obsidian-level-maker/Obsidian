PREFABS.Window_cage_1 =
{
  file   = "window/gtd_window_cage.wad",
  map    = "MAP01",

  group  = "gtd_window_cage_lowbars",

  theme  = "!tech",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_cage_1_tech =
{
  template   = "Window_cage_1",
  map    = "MAP01",
  theme  = "tech",

  tex_BROWN144 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}

PREFABS.Window_cage_2 =
{
  template = "Window_cage_1",
  map    = "MAP02",
  theme  = "!tech",

  group  = "gtd_window_cage_lowbars",

  seed_w = 2,
}

PREFABS.Window_cage_2_tech =
{
  template   = "Window_cage_1",
  map    = "MAP02",
  theme  = "tech",
  seed_w = 2,

  tex_BROWN144 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}

PREFABS.Window_cage_3 =
{
  template = "Window_cage_1",
  map    = "MAP03",
  theme  = "!tech",

  group  = "gtd_window_cage_lowbars",

  seed_w = 3,
}

PREFABS.Window_cage_3_tech =
{
  template   = "Window_cage_1",
  map    = "MAP03",
  theme  = "tech",
  seed_w = 3,

  tex_BROWN144 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}

PREFABS.Window_cage_1_HB =
{
  template = "Window_cage_1",
  theme  = "!tech",

  group = "gtd_window_cage_highbars",

  tex_MIDBARS3 = "MIDBARS1",
}

PREFABS.Window_cage_1_tech_HB =
{
  template   = "Window_cage_1",
  map    = "MAP01",
  theme  = "tech",
  group = "gtd_window_cage_highbars",

  tex_BROWN144 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_MIDBARS3 = "MIDSPACE",
}

PREFABS.Window_cage_2_HB =
{
  template = "Window_cage_1",
  map = "MAP02",
  theme  = "!tech",

  seed_w = 2,

  group = "gtd_window_cage_highbars",

  tex_MIDBARS3 = "MIDBARS1",
}

PREFABS.Window_cage_2_tech_HB =
{
  template   = "Window_cage_1",
  map    = "MAP02",
  theme  = "tech",
  group = "gtd_window_cage_highbars",
  seed_w = 2,

  tex_BROWN144 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_MIDBARS3 = "MIDSPACE",
}

PREFABS.Window_cage_3_HB =
{
  template = "Window_cage_1",
  map = "MAP03",
  theme  = "!tech",

  seed_w = 3,

  group = "gtd_window_cage_highbars",

  tex_MIDBARS3 = "MIDBARS1",
}

PREFABS.Window_cage_3_tech_HB =
{
  template   = "Window_cage_1",
  map    = "MAP03",
  theme  = "tech",
  group = "gtd_window_cage_highbars",
  seed_w = 3,

  tex_BROWN144 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
  tex_MIDBARS3 = "MIDSPACE",
}

PREFABS.Window_cage_1_hell =
{
  template = "Window_cage_1",

  group = "gtd_window_cage_hell",

  tex_MIDBARS3 = "MIDGRATE",
}

PREFABS.Window_cage_2_hell =
{
  template = "Window_cage_1",
  map = "MAP02",

  seed_w = 2,

  group = "gtd_window_cage_hell",

  tex_MIDBARS3 = "MIDGRATE",
}

PREFABS.Window_cage_3_hell =
{
  template = "Window_cage_1",
  map = "MAP03",

  seed_w = 3,

  group = "gtd_window_cage_hell",

  tex_MIDBARS3 = "MIDGRATE",
}
