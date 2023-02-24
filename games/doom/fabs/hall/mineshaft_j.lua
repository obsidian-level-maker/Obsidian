PREFABS.Hallway_mineshaft_plain =
{
  file   = "hall/mineshaft_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "mineshaft",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  seed_h = 1,
  seed_w = 1,
}

PREFABS.Hallway_mineshaft_secret =
{
  template = "Hallway_mineshaft_plain",

  map    = "MAP02",
  key    = "secret",
}
