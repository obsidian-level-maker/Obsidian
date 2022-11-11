PREFABS.Hallway_metro_c =
{
  file   = "hall/metro_c.wad",
  map    = "MAP01",

  port = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  seed_w = 2,
  seed_h = 2,
}

-- slopeless port fallbacks

PREFABS.Hallway_metro_c_boxy =
{
  template = "Hallway_metro_c",

  map = "MAP10",

  port = "any",

  prob = 10,
}
