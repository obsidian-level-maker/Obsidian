PREFABS.Cage_wall_terrace =
{
  file   = "cage/cage_building_side.wad",
  map   = "MAP01",

  prob  = 1500,

  env    = "outdoor",

  height = 216,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  x_fit = { 112,144 },
  y_fit = "top",
}

PREFABS.Cage_wall_terrace_tall =
{
  template = "Cage_wall_terrace",
  map = "MAP02",

  height = 264,
}
