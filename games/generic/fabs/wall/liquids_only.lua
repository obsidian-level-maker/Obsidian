PREFABS.Wall_generic_waterfall =
{
  file   = "wall/liquids_only.wad",
  map    = "MAP01",
  game   = "!heretic",

  prob   = 15,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "bottom",

  on_liquids = "only",

  sound = "Water_Streaming",
}

PREFABS.Wall_generic_waterfall_heretic =
{
  template = "Wall_generic_waterfall",
  game = "heretic",
  forced_offsets = 
  {
    [9] = { x=-26, y=0 }
  }
}

PREFABS.Wall_ceiling_sleuce =
{
  file   = "wall/liquids_only.wad",
  map    = "MAP02",

  prob   = 15,

  where  = "edge",
  height = 128,
  deep   = 32,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  on_liquids = "only",

  sound = "Waterfall_Rush",
}

PREFABS.Wall_side_sleuce =
{
  file   = "wall/liquids_only.wad",
  map    = "MAP03",
  game   = "!heretic",

  prob   = 15,

  where  = "edge",
  height = 128,
  deep   = 48,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  on_liquids = "only",

  sound = "Water_Streaming",
}
