--
-- vent piece : corner (L shape)
--

PREFABS.Hallway_vent_c1 =
{
  file   = "hall/vent_c.wad",
  map    = "MAP01",

  group  = "vent",
  prob   = 50,

  where  = "seeds",
  shape  = "L",

  mon_height = 64,
}

PREFABS.Hallway_vent_c_sidedoor =
{
  file   = "hall/vent_c.wad",
  map    = "MAP02",

  theme  = "!hell",

  group  = "vent",
  prob   = 25,

  where  = "seeds",
  shape  = "L",

  mon_height = 64,
}

PREFABS.Hallway_vent_c_sidedoor_gothic =
{
  file   = "hall/vent_c.wad",
  map    = "MAP02",

  theme  = "hell",

  group  = "vent",
  prob   = 25,

  where  = "seeds",
  shape  = "L",

  mon_height = 64,

  tex_DOOR3 = "WOODMET1",
  tex_DOORSTOP = "METAL",
}
