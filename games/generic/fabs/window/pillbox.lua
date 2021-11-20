-- Adapted from GTD's bunker windows

PREFABS.Window_pillbox_1 =
{
  file   = "window/pillbox.wad",
  map    = "MAP01",

  group  = "pillbox",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 96,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 96,
}

PREFABS.Window_pillbox_2 =
{
  template = "Window_pillbox_1",
  map = "MAP02",

  seed_w = 2
}

PREFABS.Window_pillbox_3 =
{
  template = "Window_pillbox_1",
  map = "MAP03",

  seed_w = 3
}

PREFABS.Window_pillbox_4 =
{
  template = "Window_pillbox_1",
  map = "MAP04",

  seed_w = 4
}
