--
-- modification of tall square windows adopted to become...
-- SUPERTALL, just like Superman, except just with tallness!
-- kinda lame eh? But wait till you see it...
--

PREFABS.Window_supertall_1 =
{
  file   = "window/supertall.wad",
  map    = "MAP01",

  group  = "supertall",
  prob   = 50,

  passable = true,

  rank   = 2,
  height = 128,

  where  = "edge",
  seed_w = 1,
  deep   = 16,
  over   = 16,

  z_fit = { 32,48 },

  bound_z1 = 0,
  bound_z2 = 128,
}

PREFABS.Window_supertall_2 =
{
  template = "Window_supertall_1",
  map = "MAP02",

  seed_w = 2,
}

PREFABS.Window_supertall_3 =
{
  template = "Window_supertall_1",
  map = "MAP03",

  seed_w = 3,
}
