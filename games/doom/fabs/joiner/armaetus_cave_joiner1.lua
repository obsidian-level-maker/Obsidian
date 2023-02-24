PREFABS.Joiner_armaetus_cave_to_cave_joiner =
{
  file   = "joiner/armaetus_cave_joiner1.wad",
  map    = "MAP01",

  prob   = 750,

  style = "steepness",

  env      = "cave",
  neighbor = "cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  delta_h = 64,
  nearby_h = 128,

  x_fit = "frame",
  y_fit = "frame",

  can_flip = true,
}

PREFABS.Joiner_armaetus_cave_to_cave_joiner_2x1 =
{
  template = "Joiner_armaetus_cave_to_cave_joiner",

  map      = "MAP02",

  seed_h   = 1,

  delta_h  = 32,
}

PREFABS.Joiner_armaetus_cave_to_cave_joiner_2x1_any_to_cave =
{
  template = "Joiner_armaetus_cave_to_cave_joiner",

  env = "any",
  neighbor = "cave",

  rank = 3,
  prob = 50,

  map = "MAP03",

  seed_h = 1,

  delta_h = 64,

  y_fit = {24,136},
}
