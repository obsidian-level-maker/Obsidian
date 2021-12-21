PREFABS.Window_crossfire_1 =
{
  file   = "window/window_crossfire.wad",
  map    = "MAP01",

  group  = "window_crossfire",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 64,104 },
}

PREFABS.Window_crossfire_2 =
{
  template = "Window_crossfire_1",
  map    = "MAP02",

  group  = "window_crossfire",

  seed_w = 2,
}

PREFABS.Window_crossfire_3 =
{
  template = "Window_crossfire_1",
  map    = "MAP03",
  --game = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, strife=1 },

  passable = true,

  group  = "window_crossfire",

  seed_w = 3,
}
