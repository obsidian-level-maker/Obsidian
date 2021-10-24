--
-- Hanging chandelier
--

PREFABS.Decor_chandelier =
{
  file   = "decor/chandelier.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=0, doom2=0, hacx=1, harmony=1, heretic=1, hexen=1, nukem=1, quake=1, strife=1},

  prob   = 100,
  env    = "building",

  kind   = "light",
  where  = "point",

  height = 160,

  bound_z1 = -64,
  bound_z2 = 0,
}

PREFABS.Decor_chandelier_flatlight = -- For games without hanging light thingys
{
  file   = "decor/chandelier.wad",
  map    = "MAP02",
  game   = { chex3=1, doom2=1, doom1=1 },

  prob   = 100,
  env    = "building",

  kind   = "light",
  where  = "point",

  height = 160,

  bound_z1 = -64,
  bound_z2 = 0,
}

