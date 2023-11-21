--
-- vent piece : locked terminators
--

PREFABS.Hallway_vent_locked_yellow =
{
  file   = "hall/vent_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "vent",
  key    = "kz_yellow",

  

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  deep   = 16,

}


PREFABS.Hallway_vent_locked_red =
{
  template = "Hallway_vent_locked_yellow",

  key    = "kz_red",

  line_34 = 33,
  tex_HW511 = "HW510",
}


PREFABS.Hallway_vent_locked_blue =
{
  template = "Hallway_vent_locked_yellow",

  key    = "kz_blue",

  line_34 = 32,
  tex_HW511 = "HW512",
}


----------------------------------------------------------------


PREFABS.Hallway_vent_barred =
{
  file   = "hall/vent_k.wad",
  map    = "MAP03",

  

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

