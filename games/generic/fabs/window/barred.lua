--
-- a window with thick bars
--

PREFABS.Window_bars =
{
  file   = "window/barred.wad",
  map    = "MAP01",

  group  = "barred",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

}

PREFABS.Window_bars2 =
{
  template = "Window_bars",

  map      = "MAP02",
  seed_w   = 2,
}

PREFABS.Window_bars3 =
{
  template = "Window_bars",
  map      = "MAP03",
  seed_w   = 3,

}
