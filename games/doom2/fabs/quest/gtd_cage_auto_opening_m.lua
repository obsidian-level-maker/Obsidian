PREFABS.Quest_Marine_auto_open =
{
  file   = "quest/gtd_cage_auto_opening_m.wad",
  map    = "MAP01",

  prob   = 500,

  theme  = "!hell",

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = -16,

  kind = "sec_quest",

  group = "marine_closet",

  mmin = 1,
  mmax = 10,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Quest_auto_open_smaller =
{
  template = "Quest_Marine_auto_open",
  map      = "MAP02",

  theme    = "!hell",

  seed_w = 2,
  seed_h = 2,

  x_fit  = { 80,96 , 160,176 },
  y_fit  = { 48,80 },
}
