--
-- Framed archway
--

PREFABS.Arch_framey =
{
  file   = "door/arch_framey.wad",
  map    = "MAP01",

  prob   = 50,

  kind   = "arch",
  where  = "edge",

  seed_w = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  bound_z1 = 0,
}


PREFABS.Arch_framey2 =
{
  template = "Arch_framey",
  map      = "MAP02",

  prob   = 200,

  seed_w = 3,
}


PREFABS.Arch_framey3 =
{
  template = "Arch_framey",
  map      = "MAP03",

  prob   = 800,

  seed_w = 4,
}

