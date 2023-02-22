--
-- Round-ish windows
--

PREFABS.Window_round1 =
{
  file   = "window/round.wad",
  map    = "MAP01",
  theme  = "!tech",

  group  = "round",

  passable = true,

  prob   = 50,

  where  = "edge",
  seed_w = 1,

  deep   = 16,
  over   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_round1_tech =
{
  template = "Window_round1",
  map    = "MAP01",
  theme =  "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT20",

}

PREFABS.Window_round2 =
{
  template = "Window_round1",

  map      = "MAP02",
  theme    = "!tech",

  seed_w   = 2,
}

PREFABS.Window_round2_tech =
{
  template = "Window_round1",
  map    = "MAP02",
  theme =  "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT20",

  seed_w   = 2,

}


PREFABS.Window_round3 =
{
  template = "Window_round1",

  map      = "MAP03",
  theme    = "!tech",

  seed_w   = 3,
}

PREFABS.Window_round3_tech =
{
  template = "Window_round1",
  map    = "MAP03",
  theme =  "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT20",

  seed_w   = 3,

}
