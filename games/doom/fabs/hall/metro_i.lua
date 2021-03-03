PREFABS.Hallway_metro_i =
{
  file   = "hall/metro_i.wad",
  map    = "MAP01",

  engine = "zdoom",

  group  = "metro",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  sector_1  = { [0]=90, [1]=15 }
}

PREFABS.Hallway_metro_i_rise =
{
  template = "Hallway_metro_i",
  map = "MAP02",

  engine = "zdoom",

  prob = 15,

  style = "steepness",

  delta_h = 64,

  can_flip = true,
}

-- slopeless fallbacks
PREFABS.Hallway_metro_i_boxy =
{
  template = "Hallway_metro_i",
  map = "MAP10",

  engine = "any",

  prob = 4,

  can_flip = true,
}

PREFABS.Hallway_metro_i_boxy_with_door =
{
  template = "Hallway_metro_i",
  map = "MAP11",

  engine = "any",

  prob = 4,

  can_flip = true,
}

PREFABS.Hallway_metro_i_boxy_train_crossing =
{
  template = "Hallway_metro_i",
  map = "MAP12",

  theme = "!hell",

  engine = "any",

  prob = 2,

  can_flip = true,
}

PREFABS.Hallway_metro_i_boxy_ticketing_office =
{
  template = "Hallway_metro_i",
  map = "MAP13",

  theme = "!hell",

  engine = "any",

  prob = 2,

  can_flip = true,
}
