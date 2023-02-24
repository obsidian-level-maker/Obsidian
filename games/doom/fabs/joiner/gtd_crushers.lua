PREFABS.Joiner_tech_triple_crusher =
{
  file   = "joiner/gtd_crushers.wad",
  map    = "MAP01",

  prob   = 85,

  filter = "crushers",

  style  = "traps",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = 16,

  bound_z1 = -16,

  x_fit = "frame",
  y_fit = "frame",
}

PREFABS.Joiner_tech_3x3_crusher =
{
  template = "Joiner_tech_triple_crusher",

  map      = "MAP02",
}

PREFABS.Joiner_tech_double_mega_crusher =
{
  template = "Joiner_tech_triple_crusher",

  map      = "MAP03",
}
