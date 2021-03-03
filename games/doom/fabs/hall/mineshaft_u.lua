PREFABS.Hallway_mineshaft_u =
{
  file   = "hall/mineshaft_u.wad",
  map    = "MAP01",

  group  = "mineshaft",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_h = 1,
  seed_w = 1,
}

PREFABS.Hallway_mineshaft_u_cave_in =
{
  template = "Hallway_mineshaft_u",
  map = "MAP02",
}

PREFABS.Hallway_mineshaft_u_dig =
{
  template = "Hallway_mineshaft_u",
  map = "MAP03",

  prob = 25,
}
