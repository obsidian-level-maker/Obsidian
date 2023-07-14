PREFABS.Joiner_gtd_cave_to_cave_2_pillars =
{
  file   = "joiner/gtd_cave_to_cave.wad",
  map    = "MAP01",

  prob   = 300 * 15,

  env = "cave",
  neighbor = "cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = { 120,136 },
  y_fit = { 160,256 }
}

PREFABS.Joiner_gtd_cave_to_cave_1_pillar =
{
  template = "Joiner_gtd_cave_to_cave_2_pillars",
  map = "MAP02",

  y_fit = { 136,184 , 232,280 }
}
