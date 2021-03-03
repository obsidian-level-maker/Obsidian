--
-- 2-seed-wide hallway : locked terminators
--

PREFABS.Hallway_conveyorh_locked_red1 =
{
  file   = "hall/dem_conveyorh_k.wad",
  map    = "MAP01",
  engine = "gzdoom",

  theme  = "hell",

  kind   = "terminator",
  group  = "conveyorh",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  texture_pack = "armaetus",
}

PREFABS.Hallway_conveyorh_locked_blue1 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP01",
  engine = "gzdoom",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_conveyorh_locked_yellow1 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP01",
  engine = "gzdoom",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Hallway_conveyorh_locked_red2 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP02",
  engine = "zdoom",
  key    = "k_red",

  engine = "zdoom",

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_79 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_15 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_81 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  }

}

PREFABS.Hallway_conveyorh_locked_blue2 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP02",
  engine = "zdoom",
  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_conveyorh_locked_yellow2 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP02",
  engine = "zdoom",
  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Hallway_conveyorh_locked_red3 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP03",
  engine = "zdoom",
  key    = "k_red",

}

PREFABS.Hallway_conveyorh_locked_blue3 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP03",
  engine = "zdoom",
  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_conveyorh_locked_yellow3 =
{
  template = "Hallway_conveyorh_locked_red1",
  map    = "MAP03",
  engine = "zdoom",
  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}



----------------------------------------------------------------

PREFABS.Hallway_conveyorh_barred1 =
{
  file   = "hall/dem_conveyorh_k.wad",
  map    = "MAP04",
  engine = "gzdoom",

  kind   = "terminator",
  group  = "conveyorh",
  key    = "barred",
  theme  = "hell",

  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,
  deep   = 16,

  texture_pack = "armaetus",

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Hallway_conveyorh_barred2 =
{
  template  = "Hallway_conveyorh_barred1",
  map    = "MAP05",
  engine = "zdoom",

  thing_20 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_10 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_79 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_15 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  },

  thing_81 =
  {
    gibs = 50,
    gibbed_player = 50,
    pool_blood_1  = 50,
    pool_brains = 50,
    dead_player = 50,
    dead_zombie = 50,
    dead_shooter = 50,
    dead_imp = 50,
  }

}

PREFABS.Hallway_conveyorh_barred3 =
{
  template  = "Hallway_conveyorh_barred1",
  map    = "MAP06",
  engine = "zdoom",

}

