--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_conveyor_locked_red1 =
{
  file   = "hall/dem_conveyor_k.wad",
  map    = "MAP01",
  engine = "zdoom",

  theme  = "tech",

  kind   = "terminator",
  group  = "conveyor",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  texture_pack = "armaetus",

  sound = "Conveyor_Mech",
}

PREFABS.Hallway_conveyor_locked_blue1 =
{
  template = "Hallway_conveyor_locked_red1",

  key    = "k_blue",

  tex_DOORRED = "DOORBLU",
  line_33     = 32,
}


PREFABS.Hallway_conveyor_locked_yellow1 =
{
  template = "Hallway_conveyor_locked_red1",

  key    = "k_yellow",

  tex_DOORRED = "DOORYEL",
  line_33     = 34,
}



----------------------------------------------------------------

PREFABS.Hallway_conveyor_barred1 =
{
  file   = "hall/dem_conveyor_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "conveyor",
  key    = "barred",

  theme  = "tech",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,
  deep   = 16,

  texture_pack = "armaetus",

 thing_2035 =
  {
    barrel = 60,
    nothing = 40,
  },


  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",

  sound = "Conveyor_Mech",
}

