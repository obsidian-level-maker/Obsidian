--
-- sewers piece : terminators
--

PREFABS.Hallway_sewers_term =
{
  file   = "hall/dem_sewers_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "sewers",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  engine = "zdoom",
}

PREFABS.Hallway_sewers_term2 =
{
  template = "Hallway_sewers_term",

  map    = "MAP02",
}

PREFABS.Hallway_sewers_term3 =
{
  template = "Hallway_sewers_term",

  map    = "MAP03",
}

PREFABS.Hallway_sewers_term4 =
{
  template = "Hallway_sewers_term",

  map    = "MAP04",
}


PREFABS.Hallway_sewers_door_term1 =
{
  template = "Hallway_sewers_term",

  map    = "MAP05",
}

PREFABS.Hallway_sewers_door_term2 =
{
  template = "Hallway_sewers_term",

  map    = "MAP06",
}

PREFABS.Hallway_sewers_door_term3 =
{
  template = "Hallway_sewers_term",

  map    = "MAP07",
}

PREFABS.Hallway_sewers_door_term4 =
{
  template = "Hallway_sewers_term",

  map    = "MAP08",
}

PREFABS.Hallway_sewers_secret =
{
  template = "Hallway_sewers_term",

  map    = "MAP09",
  key    = "secret",
}

-- MSSP makes everything worse
PREFABS.Hallway_sewers_toilet_term =
{
  template = "Hallway_sewers_term",

  prob     = 50,

  map      = "MAP10",
}
