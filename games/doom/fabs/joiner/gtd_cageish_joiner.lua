PREFABS.Joiner_gtd_cageish_joiner_bunker =
{
  file   = "joiner/gtd_cageish_joiner.wad",
  map    = "MAP01",

  prob   = 300,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = { 80,96 , 160,176 },
  y_fit = "frame",
}

PREFABS.Joiner_gtd_cageish_joiner_bunker_4x4 =
{
  template = "Joiner_gtd_cageish_joiner_bunker",
  map = "MAP02",

  seed_h = 2,

  x_fit = { 32,56 , 200,224 },
  y_fit = "frame",
}

PREFABS.Joiner_gtd_cageish_joiner_2_standing =
{
  template = "Joiner_gtd_cageish_joiner_bunker",
  map = "MAP03",

  prob = 150,

  x_fit = "frame",

  can_flip = true,
}

PREFABS.Joiner_gtd_cageish_joiner_4_standing =
{
  template = "Joiner_gtd_cageish_joiner_bunker",
  map = "MAP04",

  prob = 150,

  seed_w = 3,

  x_fit = "frame",

  can_flip = true,
}

PREFABS.Joiner_gtd_cageish_joiner_lowering_pillars =
{
  template = "Joiner_gtd_cageish_joiner_bunker",
  map = "MAP05",

  seed_w = 3,
  seed_h = 2,

  x_fit = "frame",
}
