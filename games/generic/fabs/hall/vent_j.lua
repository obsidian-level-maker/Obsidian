--
-- vent piece : terminators
--

PREFABS.Hallway_vent_plain =
{
  file   = "hall/vent_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  game   = "!chex3",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16
}

PREFABS.Hallway_vent_plain_chex3 =
{
  file   = "hall/vent_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  game   = "chex3",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  forced_offsets = 
  {
    [22] = { x=-24 , y=0 },
    [23] = { x=1, y=0 },
    [26] = { x=1 , y=0 },
    [27] = { x=-24 , y=0 }
  }

}

PREFABS.Hallway_vent_secret =
{
  template = "Hallway_vent_plain",

  map    = "MAP05",
  key    = "secret",
}

PREFABS.Hallway_vent_secret_chex3 =
{
  template = "Hallway_vent_plain_chex3",

  map    = "MAP05",
  key    = "secret",
}
