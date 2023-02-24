PREFABS.Hallway_metro_i =
{
  file   = "hall/metro_i.wad",
  map    = "MAP01",

  port = "zdoom",

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

  port = "zdoom",

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

  port = "any",

  prob = 4,

  can_flip = true,
}

PREFABS.Hallway_metro_i_boxy_with_door =
{
  template = "Hallway_metro_i",
  map = "MAP11",

  port = "any",

  prob = 4,

  can_flip = true,
}

PREFABS.Hallway_metro_i_boxy_train_crossing =
{
  template = "Hallway_metro_i",
  map = "MAP12",

  theme = "!hell",

  port = "any",

  prob = 2,

  can_flip = true,
}

PREFABS.Hallway_metro_i_boxy_ticketing_office =
{
  template = "Hallway_metro_i",
  map = "MAP13",

  theme = "!hell",

  port = "any",

  prob = 2,

  can_flip = true,
}
