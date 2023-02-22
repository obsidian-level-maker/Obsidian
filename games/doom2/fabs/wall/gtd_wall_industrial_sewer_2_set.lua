PREFABS.Wall_gtd_sewer_set_2_low_opening =
{
  file   = "wall/gtd_wall_industrial_sewer_2_set.wad",
  map    = "MAP01",

  port = "zdoom",

  prob   = 50,
  group  = "gtd_sewer_set_2",

  where  = "edge",

  deep   = 24,

  height = 104,

  bound_z1 = 0,
  bound_z2 = 104,

  z_fit = "top"
}

PREFABS.Wall_gtd_sewer_set_2_high_opening =
{
  template = "Wall_gtd_sewer_set_2_low_opening",

  z_fit = { 20,22 }
}

PREFABS.Wall_gtd_sewer_set_2_mid_opening =
{
  template = "Wall_gtd_sewer_set_2_low_opening",

  z_fit = { 20,22 , 98,100 }
}

PREFABS.Wall_gtd_sewer_set_2_2 =
{
  template = "Wall_gtd_sewer_set_2_low_opening",
  map = "MAP02",

  prob = 150,

  height = 96,
  bound_z2 = 96,

  deep = 16
}
