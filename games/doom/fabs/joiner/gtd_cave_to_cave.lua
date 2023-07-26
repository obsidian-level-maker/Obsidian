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
  y_fit = { 32,128 }
}

PREFABS.Joiner_gtd_cave_to_cave_1_pillar =
{
  template = "Joiner_gtd_cave_to_cave_2_pillars",
  map = "MAP02",

  x_fit = { 72,200 },
  y_fit = { 8,56 , 80,152 }
}
