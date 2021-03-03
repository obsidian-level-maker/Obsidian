-- disabled for now - the slope sectors don't work well with outdoor shadowing effects.

--[[PREFABS.Decor_camping_tent_bloo =
{
  file   = "decor/craneo_decor_camping_tent.wad",
  map    = "MAP01",

  engine = "zdoom",

  prob   = 4500,
  theme  = "urban",
  env    = "park",

  where  = "point",
  size   = 104,

  bound_z1 = 0,
  bound_z2 = 56,

  sink_mode = "never",
}

PREFABS.Decor_camping_tent_red =
{
  template = "Decor_camping_tent_bloo",

  tex_COMPBLUE = "REDWALL",
  flat_FLAT14 = "FLOOR1_6",
}

PREFABS.Decor_camping_tent_beige =
{
  template = "Decor_camping_tent_bloo",

  tex_COMPBLUE = "STUCCO",
  flat_FLAT14 = "FLAT5_5",
}]]
