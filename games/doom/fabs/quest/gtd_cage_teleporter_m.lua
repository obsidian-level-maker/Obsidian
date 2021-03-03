PREFABS.Quest_marine_teleporter_ambush_tech =
{
  file   = "quest/gtd_cage_teleporter_m.wad",
  map    = "MAP01",

  theme  = "!hell",

  prob   = 500,

  where  = "seeds",
  shape  = "U",

  deep   = 16,

  seed_w = 2,
  seed_h = 2,

  bound_z1 = 0,

  kind = "sec_quest",

  group = "marine_closet",

  mmin = 1,
  mmax = 10,

  x_fit = { 92,100 , 156,164 },
  y_fit = "top",
}

PREFABS.Quest_teleporter_ambush_hell =
{
  template = "Quest_marine_teleporter_ambush_tech",
  map      = "MAP02",

  theme    = "hell",

  x_fit    = "frame",
}
