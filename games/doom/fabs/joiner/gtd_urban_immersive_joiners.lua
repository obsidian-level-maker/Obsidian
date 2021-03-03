PREFABS.Joiner_public_toilet_room =
{
  file   = "joiner/gtd_urban_immersive_joiners.wad",
  map    = "MAP01",

  engine = "!zdoom",

  prob   = 650,

  theme  = "urban",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",

  can_flip = true,
}

PREFABS.Joiner_gtd_stairwell_up =
{
  template = "Joiner_public_toilet_room",
  map = "MAP02",

  style = "steepness",

  engine = "any",

  prob = 850,

  delta_h = 128,

  seed_w = 3,

  tex_BROWNGRN =
  {
    BIGBRIK1 = 25,
    BIGBRIK2 = 25,
    BROWNGRN = 50,
    BRICK7 = 50,
    BRICK12 = 50,
    BRONZE1 = 50,
    STUCCO1 = 50,
  },
}

PREFABS.Joiner_gtd_stairwell_flat =
{
  template = "Joiner_public_toilet_room",
  map = "MAP03",

  engine = "any",

  prob = 1000,

  seed_w = 3,

  tex_BROWNGRN =
  {
    BIGBRIK1 = 25,
    BIGBRIK2 = 25,
    BROWNGRN = 50,
    BRICK7 = 50,
    BRICK12 = 50,
    BRONZE1 = 50,
    STUCCO1 = 50,
  },
}
