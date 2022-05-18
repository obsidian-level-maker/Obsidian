--
-- vent piece : terminators
--

PREFABS.Hallway_vent_plain =
{
  file   = "hall/vent_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  game   = { chex3=0, doom1=1, doom2=1, hacx=1, harmony=0, heretic=1, hexen=1, strife=1 },

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,
  forced_offsets = 
  {
    [22] = { x=-13 , y=4 },
    [23] = { x=6, y=4 },
    [26] = { x=6 , y=4 },
    [27] = { x=-13 , y=4 }
  }
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

PREFABS.Hallway_vent_plain_harmony =
{
  file   = "hall/vent_j.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  game   = "harmony",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  forced_offsets = 
  {
    [22] = { x=-27 , y=36 },
    [23] = { x=3, y=5 },
    [26] = { x=3, y=5 },
    [27] = { x=-27 , y=36 }
  }
}

PREFABS.Hallway_vent_secret =
{
  file   = "hall/vent_j.wad",
  map    = "MAP05",
  key    = "secret",

  kind   = "terminator",
  group  = "vent",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,
}

