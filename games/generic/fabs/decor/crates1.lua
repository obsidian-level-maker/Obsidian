--
-- Various crates
--


-- a small crate, 64x64 in size

PREFABS.Crate_small =
{
  file   = "decor/crates1.wad",
  map    = "MAP01",
  env    = "!cave",
  theme = "!hell",

  prob   = 3500,

  where  = "point",
  size   = 64,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Crate_small_generic_hell =
{
  template   = "Crate_small",
  game = "doomish",
  theme = "hell",

  tex__CRATE = "WOODMET4",
  flat__CRATE = "FLAT5_2",
  forced_offsets =
  {
    [0] = { x=0, y=64 },
    [2] = { x=0, y=64 },
    [4] = { x=0, y=64 },
    [6] = { x=0, y=64 },
  }
}

PREFABS.Crate_small_alt =
{
  template   = "Crate_small",

  tex__CRATE = "_CRATE2",
  flat__CRATE = "_CRATE2",
}

-- a tall narrow crate

PREFABS.Crate_tall =
{
  file   = "decor/crates1.wad",
  map    = "MAP02",
  env    = "!cave",
  theme = "!hell",

  prob   = 3500,

  where  = "point",
  size   = 64,
  height = 160,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Crate_tall_alt =
{
  template = "Crate_tall",

  tex__CRATE = "_CRATE2",
  flat__CRATE = "_CRATE2",
}

-- a medium-size crate (96x96)

PREFABS.Crate_medium =
{
  file   = "decor/crates1.wad",
  map    = "MAP03",
  env    = "!cave",
  game   = "!harmony",
  theme = "!hell",

  prob   = 3500,

  where  = "point",
  size   = 96,

  bound_z1 = 0,

  sink_mode = "never",
}

-- a group of three and a half crates

PREFABS.Crate_group_medium =
{
  file   = "decor/crates1.wad",
  map    = "MAP04",
  env    = "!cave",
  theme = "!hell",

  prob   = 3500,

  where  = "point",
  size   = 128,
  height = 160,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Crate_group_medium_alt =
{
  template = "Crate_group_medium",

  tex__CRATE = "_CRATE2",
  flat__CRATE = "_CRATE2",
}

-- Loosely arranged crates

PREFABS.Crate_group_mixed =
{
  file   = "decor/crates1.wad",
  map    = "MAP05",
  env    = "!cave",
  theme = "!hell",

  prob   = 1000,

  where  = "point",
  size   = 128,
  height = 160,

  bound_z1 = 0,

  sink_mode = "never",
}

PREFABS.Crate_group_mixed_alt =
{
  template = "Crate_group_mixed",
  map = "MAP06"
}

PREFABS.Crate_medium_generic_hell =
{
  file   = "decor/crates1.wad",
  map    = "MAP07",
  env    = "!cave",
  game = "doomish",
  theme = "hell",

  prob   = 3500,

  where  = "point",
  size   = 72,

  bound_z1 = 0,

  sink_mode = "never",
}