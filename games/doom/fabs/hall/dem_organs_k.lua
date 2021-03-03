--
-- organs piece : locked terminators
--

PREFABS.Hallway_organs_locked_red1 =
{
  file   = "hall/dem_organs_k.wad",
  map    = "MAP01",
  theme  = "hell",

  kind   = "terminator",
  group  = "organs",
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


PREFABS.Hallway_organs_locked_blue1 =
{
  template = "Hallway_organs_locked_red1",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_135     = 133,
}


PREFABS.Hallway_organs_locked_yellow1 =
{
  template = "Hallway_organs_locked_red1",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_135     = 137,
}

PREFABS.Hallway_organs_locked_red2 =
{
  file   = "hall/dem_organs_k.wad",
  map    = "MAP02",

  kind   = "terminator",
  group  = "organs",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

}


PREFABS.Hallway_organs_locked_blue2 =
{
  template = "Hallway_organs_locked_red2",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_135     = 133,
}


PREFABS.Hallway_organs_locked_yellow2 =
{
  template = "Hallway_organs_locked_red2",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_135     = 137,
}

PREFABS.Hallway_organs_locked_red3 =
{
  file   = "hall/dem_organs_k.wad",
  map    = "MAP03",

  kind   = "terminator",
  group  = "organs",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

}


PREFABS.Hallway_organs_locked_blue3 =
{
  template = "Hallway_organs_locked_red3",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_135     = 133,
}


PREFABS.Hallway_organs_locked_yellow3 =
{
  template = "Hallway_organs_locked_red3",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_135     = 137,
}

PREFABS.Hallway_organs_locked_red4 =
{
  file   = "hall/dem_organs_k.wad",
  map    = "MAP04",

  kind   = "terminator",
  group  = "organs",
  key    = "k_red",

  prob   = 50,

  where  = "seeds",
  shape  = "I",
  seed_w = 2,
  seed_h = 1,

  deep   = 16,

}


PREFABS.Hallway_organs_locked_blue4 =
{
  template = "Hallway_organs_locked_red4",

  key    = "k_blue",

  tex_DOORRED2 = "DOORBLU2",
  line_135     = 133,
}


PREFABS.Hallway_organs_locked_yellow4 =
{
  template = "Hallway_organs_locked_red4",

  key    = "k_yellow",

  tex_DOORRED2 = "DOORYEL2",
  line_135     = 137,
}


----------------------------------------------------------------


PREFABS.Hallway_organs_barred1 =
{
  file   = "hall/dem_organs_k.wad",
  map    = "MAP05",

  kind   = "terminator",
  group  = "organs",
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

PREFABS.Hallway_organs_barred2 =
{
  template   = "Hallway_organs_barred1",
  map    = "MAP06",

}

PREFABS.Hallway_organs_barred3 =
{
  template   = "Hallway_organs_barred1",
  map    = "MAP07",

}

PREFABS.Hallway_organs_barred4 =
{
  template   = "Hallway_organs_barred1",
  map    = "MAP08",

}
