PREFABS.Cage_teleporter_ambush_tech =
{
  file   = "cage/gtd_cage_teleporter_ambush.wad",
  map    = "MAP01",

  theme  = "!hell",

  prob   = 500,

  where  = "seeds",
  shape  = "U",

  deep   = 16,

  seed_w = 2,
  seed_h = 2,

  bound_z1 = 0,

  x_fit = { 92,100 , 156,164 },
  y_fit = "top",
}

PREFABS.Cage_teleporter_ambush_hell =
{
  template = "Cage_teleporter_ambush_tech",
  map      = "MAP02",

  theme    = "hell",

  x_fit    = "frame",
}
