--
-- Archway with a curved arch
--

PREFABS.Arch_curved1 =
{
  file   = "door/arch_curved.wad",
  map    = "MAP01",

  prob   = 400,
  theme  = "!tech",

  kind   = "arch",
  where  = "edge",

  seed_w = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  bound_z1 = 0,
}


PREFABS.Arch_curved2 =
{
  template = "Arch_curved1",
  map      = "MAP02",

  prob   = 600,

  seed_w = 3,
}


PREFABS.Arch_curved3 =
{
  template = "Arch_curved1",
  map      = "MAP03",

  prob   = 800,

  seed_w = 4,
}
