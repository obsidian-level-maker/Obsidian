PREFABS.Wall_generic_waterfall =
{
  file   = "wall/liquids_only.wad",
  map    = "MAP01",

  prob   = 15,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "bottom",

  liquid = true,

  on_liquids = "only",
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

  liquid = true,

  on_liquids = "only",
}

PREFABS.Wall_side_sleuce =
{
  file   = "wall/liquids_only.wad",
  map    = "MAP03",

  prob   = 15,

  where  = "edge",
  height = 128,
  deep   = 48,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  liquid = true,

  on_liquids = "only",
}
