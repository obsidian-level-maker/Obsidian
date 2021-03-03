PREFABS.Hallway_metro_term =
{
  file   = "hall/metro_j.wad",
  map    = "MAP01",
  kind   = "terminator",

  engine = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Hallway_metro_secret =
{
  template = "Hallway_metro_term",

  map  = "MAP02",
  key  = "secret",

  sector_1  = { [0]=90, [1]=15 }
}

-- slopeless engine fallbacks

PREFABS.Hallway_metro_term_boxy =
{
  template = "Hallway_metro_term",

  engine = "any",

  map = "MAP10",

  prob = 10,
}

PREFABS.Hallway_metro_secret_boxy =
{
  template = "Hallway_metro_term",

  engine = "any",

  map = "MAP11",
  key = "secret",

  prob = 10,
}
