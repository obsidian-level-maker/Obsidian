--
-- vent piece : locked terminators
--

PREFABS.Hallway_vent_locked_red =
{
  file   = "hall/vent_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  tex_DOOR1 = { DOOR1=50, DOOR3=50, SPCDOOR3=50, SPCDOOR4=50 }

}


PREFABS.Hallway_vent_locked_blue =
{
  template = "Hallway_vent_locked_red",

  key    = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}


PREFABS.Hallway_vent_locked_yellow =
{
  template = "Hallway_vent_locked_red",

  key    = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}


----------------------------------------------------------------


PREFABS.Hallway_vent_barred =
{
  file   = "hall/vent_k.wad",
  map    = "MAP03",
  theme  = "!tech",

  kind   = "terminator",
  group  = "vent",
  key    = "barred",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Hallway_vent_barred_tech =
{
  template   = "Hallway_vent_barred",
  map    = "MAP03",
  theme  = "tech",

  tex_SUPPORT3 = "SHAWN2",
  flat_CEIL5_1 = "FLAT20",
}

