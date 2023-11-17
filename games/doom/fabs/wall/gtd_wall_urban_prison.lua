PREFABS.Wall_prison_normal =
{
  file   = "wall/gtd_wall_urban_prison.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "gtd_prison_A",
  
  where  = "edge",
  height = 96,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_prison_fake_door =
{
  template = "Wall_prison_normal",
  map = "MAP02",

  prob = 10
}

PREFABS.Wall_prison_UAC_logo =
{
  template = "Wall_prison_normal",
  map = "MAP03",

  prob = 2
}

PREFABS.Wall_prison_normal_diag =
{
  template = "Wall_prison_normal",
  map = "MAP04",

  where = "diagonal"
}
