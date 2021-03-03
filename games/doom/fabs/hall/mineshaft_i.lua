PREFABS.Hallway_mineshaft_i1 =
{
  file   = "hall/mineshaft_i.wad",
  map    = "MAP01",

  group  = "mineshaft",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_h = 1,
  seed_w = 1,

  mon_height = 96,
}

PREFABS.Hallway_mineshaft_i2 =
{
  template = "Hallway_mineshaft_i1",
  map = "MAP02",
}

PREFABS.Hallway_mineshaft_i3 =
{
  template = "Hallway_mineshaft_i1",
  map = "MAP03",
}

PREFABS.Hallway_mineshaft_irise1=
{
  template = "Hallway_mineshaft_i1",
  map = "MAP04",

  style = "steepness",

  delta_h = 32,

  can_flip = true,
}

PREFABS.Hallway_mineshaft_i_collapse =
{
  template = "Hallway_mineshaft_i1",
  map = "MAP05",

  prob = 35,

  can_flip = true,
}

PREFABS.Hallway_mineshaft_i_collapse2 =
{
  template = "Hallway_mineshaft_i1",
  map = "MAP06",

  prob = 35,

  can_flip = true,
}
