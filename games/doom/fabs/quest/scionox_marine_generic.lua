PREFABS.Quest_scionox_marine_generic =
{
  file   = "quest/scionox_marine_generic.wad",
  map    = "MAP01",

  prob   = 500,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
  over   = -16,

  kind = "sec_quest",

  group = "marine_closet",

  mmin = 1,
  mmax = 10,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Quest_scionox_marine_generic_2 =
{
  template = "Quest_scionox_marine_generic",
  map      = "MAP02",

  seed_w = 2,
  seed_h = 2,
}

PREFABS.Quest_scionox_marine_generic_3 =
{
  template = "Quest_scionox_marine_generic",
  map      = "MAP03",

  seed_w = 1,
  seed_h = 2,
}
