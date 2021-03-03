PREFABS.Hallway_metro_p =
{
  file   = "hall/metro_p.wad",
  map    = "MAP01",

  engine = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "P",

  seed_w = 2,
  seed_h = 2,
}

-- slopeless engine fallback

PREFABS.Hallway_metro_p_boxy =
{
  template = "Hallway_metro_p",
  map = "MAP10",

  engine = "any",

  prob = 20,
}
