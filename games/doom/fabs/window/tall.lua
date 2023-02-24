--
-- a tall square window
--

PREFABS.Window_tall_1 =
{
  file   = "window/tall.wad",
  map    = "MAP01",
  theme  = "!tech",

  group  = "tall",
  prob   = 50,

  passable = true,

  rank   = 2,
  height = 176,

  where  = "edge",
  seed_w = 1,
  deep   = 16,
  over   = 16,

  bound_z1 = 0,
  bound_z2 = 176,
}

PREFABS.Window_tall_1_tech =
{
  template = "Window_tall_1",
  map      = "MAP04",
  theme    = "tech",
  tex_METAL5 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}


PREFABS.Window_tall_2 =
{
  template = "Window_tall_1",
  theme  = "!tech",
  map      = "MAP02",
  seed_w   = 2,
}

PREFABS.Window_tall_2_tech =
{
  template = "Window_tall_1",
  map      = "MAP05",
  theme    = "tech",
  seed_w   = 2,
  tex_METAL5 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}


PREFABS.Window_tall_3 =
{
  template = "Window_tall_1",
  theme  = "!tech",
  map      = "MAP03",
  seed_w   = 3,
}

PREFABS.Window_tall_3_tech =
{
  template = "Window_tall_1",
  theme  = "tech",
  map      = "MAP06",
  seed_w   = 3,
  tex_METAL5 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}


----- Fallbacks for height-limited spots -------------------


PREFABS.Window_tallish_1 =
{
  template = "Window_tall_1",
  theme  = "!tech",
  map      = "MAP11",

  rank     = 1,
  height   = 128,
}

PREFABS.Window_tallish_1_tech =
{
  template = "Window_tall_1",
  theme  = "tech",
  map      = "MAP07",

  rank     = 1,
  height   = 128,
  tex_METAL5 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}

PREFABS.Window_tallish_2 =
{
  template = "Window_tall_1",
  theme  = "!tech",
  map      = "MAP12",
  seed_w   = 2,

  rank     = 1,
  height   = 128,
}

PREFABS.Window_tallish_2_tech =
{
  template = "Window_tall_1",
  theme  = "tech",
  map      = "MAP08",
  seed_w   = 2,

  rank     = 1,
  height   = 128,
  tex_METAL5 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}

PREFABS.Window_tallish_3 =
{
  template = "Window_tall_1",
  theme  = "!tech",
  map      = "MAP13",
  seed_w   = 3,

  rank     = 1,
  height   = 128,
}

PREFABS.Window_tallish_3_tech =
{
  template = "Window_tall_1",
  theme  = "tech",
  map      = "MAP09",
  seed_w   = 3,

  rank     = 1,
  height   = 128,
  tex_METAL5 = "DOORSTOP",
  flat_CEIL5_2 = "FLAT20",
}
