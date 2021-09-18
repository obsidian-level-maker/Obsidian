--
-- Hanging chandelier
--

PREFABS.Decor_chandelier =
{
  file   = "decor/chandelier.wad",
  map    = "MAP01",
  game   = "!chex3",

  prob   = 100,
  env    = "building",

  kind   = "light",
  where  = "point",

  height = 160,

  bound_z1 = -64,
  bound_z2 = 0,
}

PREFABS.Decor_chandelier_chex = -- Chex Quest 3 seems to be the only game so far without a hanging light thing, so use a flat "light" instead
{
  file   = "decor/chandelier.wad",
  map    = "MAP02",
  game   = "chex3",

  prob   = 100,
  env    = "building",

  kind   = "light",
  where  = "point",

  height = 160,

  bound_z1 = -64,
  bound_z2 = 0,
}

