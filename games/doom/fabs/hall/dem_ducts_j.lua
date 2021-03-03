--
-- ducts piece : terminators
--

PREFABS.Hallway_ducts_term =
{
  file   = "hall/dem_ducts_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "ducts",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,
}

PREFABS.Hallway_ducts_term2 =
{
  template = "Hallway_ducts_term",

  map    = "MAP02",
}

PREFABS.Hallway_ducts_term3 =
{
  template = "Hallway_ducts_term",

  map    = "MAP03",
}

PREFABS.Hallway_ducts_term4 =
{
  template = "Hallway_ducts_term",

  map    = "MAP04",
}


PREFABS.Hallway_ducts_door_term1 =
{
  template = "Hallway_ducts_term",

  map    = "MAP05",
}

PREFABS.Hallway_ducts_door_term2 =
{
  template = "Hallway_ducts_term",

  map    = "MAP06",
}

PREFABS.Hallway_ducts_door_term3 =
{
  template = "Hallway_ducts_term",

  map    = "MAP07",
}

PREFABS.Hallway_ducts_door_term4 =
{
  template = "Hallway_ducts_term",

  map    = "MAP08",
}

PREFABS.Hallway_ducts_secret =
{
  template = "Hallway_ducts_term",

  map    = "MAP09",
  key    = "secret",
}
