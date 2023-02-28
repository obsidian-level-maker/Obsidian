PREFABS.Stairs_standing_64_tech =
{
  file = "stairs/gtd_standing_stairs_64.wad",
  map = "MAP01",

  theme = "tech",

  prob = 24,
  style = "steepness",

  where = "seeds",
  shape = "I",

  seed_w = 1,
  seed_h = 2,

  bound_z1 = 0,

  x_fit = {60,68},
  y_fit = {28,36 , 92,100 , 156,164 , 220,228},

  delta_h = 64
}

PREFABS.Stairs_standing_64_urban =
{
  template = "Stairs_standing_32_tech",
  map = "MAP02",

  theme = "urban"
}

PREFABS.Stairs_standing_64_hell =
{
  template = "Stairs_standing_32_tech",
  map = "MAP03",

  theme = "hell"
}
