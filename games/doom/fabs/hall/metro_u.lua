PREFABS.Hallway_metro_u =
{
  file   = "hall/metro_u.wad",
  map    = "MAP01",

  engine = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "U",

  seed_w = 2,
  seed_h = 2,

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Hallway_metro_u_deadend1 =
{
  template = "Hallway_metro_u",
  map      = "MAP02",
  prob     = 50,

  group    = "metro",

  sector_1  = { [0]=90, [1]=15 }
}

-- Bloody dead end
PREFABS.Hallway_metro_u_deadend2 =
{
  template = "Hallway_metro_u",
  map      = "MAP03",

  group    = "metro",
  prob     = 50,

  sector_1  = { [0]=90, [1]=15 }
}

-- slopeless engine fallback

PREFABS.Hallway_metro_u_boxy =
{
  template = "Hallway_metro_u",
  map = "MAP10",

  engine = "any",

  prob = 20,
}
