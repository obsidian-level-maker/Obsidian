--
-- a window with thick bars
--

PREFABS.Window_barred1 =
{
  file   = "window/barred.wad",
  map    = "MAP01",
  theme  = "!tech",

  passable = true,

  group  = "barred",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  flat_FLAT23 = "CEIL5_2",

}

PREFABS.Window_barred1_tech =
{
  template   = "Window_barred1",
  map    = "MAP01",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_FLAT23 = "FLAT23",

}

PREFABS.Window_barred2 =
{
  template = "Window_barred1",
  theme = "!tech",

  map      = "MAP02",
  seed_w   = 2,

  flat_FLAT23 = "CEIL5_2",

}

PREFABS.Window_barred2_tech =
{
  template   = "Window_barred1",
  map    = "MAP02",
  theme = "tech",
  seed_w = 2,

  tex_METAL = "SHAWN2",
  flat_FLAT23 = "FLAT23",

}


PREFABS.Window_barred3 =
{
  template = "Window_barred1",
  theme    = "!tech",
  map      = "MAP03",
  seed_w   = 3,

  flat_FLAT23 = "CEIL5_2",

}

PREFABS.Window_barred3_tech =
{
  template   = "Window_barred1",
  map    = "MAP03",
  theme = "tech",
  seed_w = 3,

  tex_METAL = "SHAWN2",
  flat_FLAT23 = "FLAT23",

}
