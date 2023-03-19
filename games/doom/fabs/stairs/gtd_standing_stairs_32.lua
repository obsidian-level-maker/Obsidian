PREFABS.Stairs_standing_32_tech =
{
  file = "stairs/gtd_standing_stairs_32.wad",
  map = "MAP01",

  theme = "tech",

  prob = 40,
  prob_skew = 2,
  style = "steepness",

  where = "seeds",
  shape = "I",

  seed_w = 1,
  seed_h = 1,

  bound_z1 = 0,

  x_fit = {60,68},
  y_fit = {28,36 , 92,100},

  delta_h = 32
}

PREFABS.Stairs_standing_32_urban =
{
  template = "Stairs_standing_32_tech",
  map = "MAP02",

  theme = "urban"
}

PREFABS.Stairs_standing_32_hell =
{
  template = "Stairs_standing_32_tech",
  map = "MAP03",

  theme = "hell"
}
