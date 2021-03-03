--
-- vent piece : terminators
--

PREFABS.Hallway_vent_plain =
{
  file   = "hall/vent_j.wad",
  map    = "MAP01",
  theme  = "!hell",

  kind   = "terminator",
  group  = "vent",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,
}

PREFABS.Hallway_vent_plain_hell =
{
  template   = "Hallway_vent_plain",
  map    = "MAP01",
  theme  = "hell",

  tex_MIDSPACE = "MIDBRN1",

}


PREFABS.Hallway_vent_door =
{
  template = "Hallway_vent_plain",

  map    = "MAP02",
  theme  = "!tech",

  prob   = 30,
}

PREFABS.Hallway_vent_door_tech =
{
  template = "Hallway_vent_plain",

  map    = "MAP02",
  theme  = "tech",

  prob   = 30,

  tex_METAL = "DOORSTOP",
  tex_DOOR3 = { DOOR3=50, DOOR1=50 },
  flat_CEIL5_2 = "FLAT20",

}

PREFABS.Hallway_vent_secret =
{
  template = "Hallway_vent_plain",

  map    = "MAP05",
  key    = "secret",
  theme  = "urban",
}

PREFABS.Hallway_vent_secret_tech =
{
  template = "Hallway_vent_plain",

  map    = "MAP05",
  key    = "secret",
  theme  = "tech",

  tex_SW1GARG = "TEKWALL4",
}

PREFABS.Hallway_vent_secret_hell =
{
  template = "Hallway_vent_plain",

  map    = "MAP05",
  key    = "secret",
  theme  = "hell",

  tex_SW1GARG = { SKIN2=50, SP_FACE2=50, SLOPPY1=50, FIREBLU1=50 }
}
