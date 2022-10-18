PREFABS.Hallway_metro_p =
{
  file   = "hall/metro_p.wad",
  map    = "MAP01",

  port = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "P",

  seed_w = 2,
  seed_h = 2,
}

-- slopeless port fallback

PREFABS.Hallway_metro_p_boxy =
{
  template = "Hallway_metro_p",
  map = "MAP10",

  port = "any",

  prob = 20,
}
