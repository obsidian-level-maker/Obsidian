PREFABS.Wall_urban_cement_frame_plain =
{
  file   = "wall/gtd_wall_urban_cement_frame_set.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_urban_cement_frame",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",
}

PREFABS.Wall_urban_cement_frame_lite =
{
  template = "Wall_urban_cement_frame_plain",
  map = "MAP02",

  prob = 30,
}

PREFABS.Wall_urban_cement_frame_doors =
{
  template = "Wall_urban_cement_frame_plain",
  map = "MAP03",

  prob = 15,
}

PREFABS.Wall_urban_cement_frame_diag =
{
  template = "Wall_urban_cement_frame_plain",
  map    = "MAP10",

  group = "gtd_wall_urban_cement_frame",

  where  = "diagonal",

  deep = nil,

  z_fit  = "top",
}
