--
-- Crate-like decorations
--

PREFABS.Crate_sandstone =
{
  file   = "decor/crates1.wad",
  map    = "MAP01",

  prob   = 40,
  env    = "outdoor",

  nolimit_compat = true,

  where  = "point",
  size   = 64,
}


PREFABS.Crate_saint1 =
{
  file   = "decor/crates1.wad",
  map    = "MAP02",

  prob   = 10,
  env    = "outdoor",

  nolimit_compat = true,

  where  = "point",
  size   = 64,
  height = 160,
}


PREFABS.Crate_saint1_B =
{
  template = "Crate_saint1",

  prob   = 5,
  skip_prob = 50,
  env    = "building",
}


PREFABS.Crate_demonface =
{
  file   = "decor/crates1.wad",
  map    = "MAP12",

  prob   = 200,

  where  = "point",
  size   = 128,
  height = 160,
}

