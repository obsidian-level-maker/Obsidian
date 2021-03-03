--
-- hellcata piece : terminators
--

PREFABS.Hallway_hellcata_term =
{
  file   = "hall/dem_hellcata_j.wad",
  map    = "MAP01",
  theme  = "hell",

  kind   = "terminator",
  group  = "hellcata",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  y_fit = "top",
  deep   = 16,

  engine = "zdoom",

}

PREFABS.Hallway_hellcata_term2 =
{
  template = "Hallway_hellcata_term",

  map    = "MAP02",
}

PREFABS.Hallway_hellcata_term3 =
{
  template = "Hallway_hellcata_term",

  map    = "MAP03",
}

PREFABS.Hallway_hellcata_term4 =
{
  template = "Hallway_hellcata_term",

  map    = "MAP04",
}

PREFABS.Hallway_hellcata_term5 =
{
  template = "Hallway_hellcata_term",

  map    = "MAP05",
  key   = "secret",
}
