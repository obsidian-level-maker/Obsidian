--
-- Archway with a curved arch
--

-- Limit to games with medieval/fantasy elements, as it looks a bit odd in modern/future settings
PREFABS.Arch_curved1 =
{
  file   = "door/arch_curved.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, hexen=1, nukem=0, quake=0, strife=1 },

  prob   = 50,

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

  prob   = 200,

  seed_w = 3,
}


PREFABS.Arch_curved3 =
{
  template = "Arch_curved1",
  map      = "MAP03",

  prob   = 800,

  seed_w = 4,
}

