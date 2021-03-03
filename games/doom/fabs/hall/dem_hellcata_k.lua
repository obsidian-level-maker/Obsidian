--
-- hellcata piece : locked terminators
--

PREFABS.Hallway_hellcata_locked_red1 =
{
  file   = "hall/dem_hellcata_k.wad",
  map    = "MAP05",
  theme  = "hell",

  kind   = "terminator",
  group  = "hellcata",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  y_fit = "top",
  deep   = 16,

  engine = "zdoom",

}


PREFABS.Hallway_hellcata_locked_blue1 =
{
  template = "Hallway_hellcata_locked_red1",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_hellcata_locked_yellow1 =
{
  template = "Hallway_hellcata_locked_red1",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Hallway_hellcata_locked_red2 =
{
  file   = "hall/dem_hellcata_k.wad",
  map    = "MAP06",

  kind   = "terminator",
  group  = "hellcata",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

}


PREFABS.Hallway_hellcata_locked_blue2 =
{
  template = "Hallway_hellcata_locked_red2",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_hellcata_locked_yellow2 =
{
  template = "Hallway_hellcata_locked_red2",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Hallway_hellcata_locked_red3 =
{
  file   = "hall/dem_hellcata_k.wad",
  map    = "MAP07",

  kind   = "terminator",
  group  = "hellcata",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

}


PREFABS.Hallway_hellcata_locked_blue3 =
{
  template = "Hallway_hellcata_locked_red3",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_hellcata_locked_yellow3 =
{
  template = "Hallway_hellcata_locked_red3",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}

PREFABS.Hallway_hellcata_locked_red4 =
{
  file   = "hall/dem_hellcata_k.wad",
  map    = "MAP08",

  kind   = "terminator",
  group  = "hellcata",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

}


PREFABS.Hallway_hellcata_locked_blue4 =
{
  template = "Hallway_hellcata_locked_red4",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_33     = 32,
}


PREFABS.Hallway_hellcata_locked_yellow4 =
{
  template = "Hallway_hellcata_locked_red4",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_33     = 34,
}


----------------------------------------------------------------


PREFABS.Hallway_hellcata_barred1 =
{
  file   = "hall/dem_hellcata_k.wad",
  map    = "MAP01",

  kind   = "terminator",
  group  = "hellcata",
  key    = "barred",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

  tag_1  = "?door_tag",
  door_action = "S1_LowerFloor",
}

PREFABS.Hallway_hellcata_barred2 =
{
  template   = "Hallway_hellcata_barred1",
  map    = "MAP02",

}

PREFABS.Hallway_hellcata_barred3 =
{
  template   = "Hallway_hellcata_barred1",
  map    = "MAP03",

}

PREFABS.Hallway_hellcata_barred4 =
{
  template   = "Hallway_hellcata_barred1",
  map    = "MAP04",

}
