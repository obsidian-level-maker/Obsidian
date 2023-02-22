PREFABS.Hallway_subway_basic_joiner =
{
  file   = "hall/gtd_subway_j.wad",
  map    = "MAP01",

  kind = "terminator",

  group  = "subway",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep = 16,

  seed_w = 2,
  seed_h = 1
}

PREFABS.Hallway_subway_basic_joiner_secret = -- replace with real secret
{
  template = "Hallway_subway_basic_joiner",

  key = "secret"
}
