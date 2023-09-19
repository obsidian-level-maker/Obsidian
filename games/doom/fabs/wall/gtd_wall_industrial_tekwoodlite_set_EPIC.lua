PREFABS.Wall_gtd_tekwoodlite_1a =
{
  file = "wall/gtd_wall_industrial_tekwoodlite_set_EPIC.wad",
  map = "MAP01",

  prob = 50,

  group = "gtd_tekwoodlite_1",

  where = "edge",
  deep = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Wall_gtd_tekwoodlite_1b =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP02",

  prob = 250
}

PREFABS.Wall_gtd_tekwoodlite_diag =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP03",

  where = "diagonal"
}

--

PREFABS.Wall_gtd_tekwoodlite_2a =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP04",

  group = "gtd_tekwoodlite_2"
}

PREFABS.Wall_gtd_tekwoodlite_2b =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP05",

  prob = 8,

  group = "gtd_tekwoodlite_2",
}

PREFABS.Wall_gtd_tekwoodlite_2_diag =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP06",

  group = "gtd_tekwoodlite_2",

  where = "diagonal"
}

--

PREFABS.Wall_gtd_tekwoodlite_3 =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP07",

  group = "gtd_tekwoodlite_3",

  height = 96,
  bound_z2 = 96,
  z_fit = {71,72 , 88,90}
}

PREFABS.Wall_gtd_tekwoodlite_3b =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP08",

  group = "gtd_tekwoodlite_3",

  height = 96,
  bound_z2 = 96,
  z_fit = {71,72 , 88,90}
}

PREFABS.Wall_gtd_tekwoodlite_3_diag =
{
  template = "Wall_gtd_tekwoodlite_1a",
  map = "MAP09",

  group = "gtd_tekwoodlite_3",

  where = "diagonal",

  height = 96,
  bound_z2 = 96,
  z_fit = {71,72 , 88,90}
}
