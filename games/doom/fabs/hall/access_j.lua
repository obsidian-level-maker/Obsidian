PREFABS.Hallway_access_open_joiner =
{
  file   = "hall/access_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "access",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,
}

PREFABS.Hallway_access_door_panel =
{
  template = "Hallway_access_open_joiner",
  map = "MAP20",
}

--

PREFABS.Hallway_access_door =
{
  template = "Hallway_access_open_joiner",
  map      = "MAP02",

  style    = "doors",
}

PREFABS.Hallway_access_door_switch =
{
  template = "Hallway_access_open_joiner",
  map = "MAP03",

  style = "doors",
}

PREFABS.Hallway_access_secret =
{
  template = "Hallway_access_open_joiner",
  map      = "MAP10",

  key      = "secret",
}
