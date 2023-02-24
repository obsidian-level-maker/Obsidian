PREFABS.Wall_garrett_overturned_cross =
{
  file   = "wall/garrett_wall_overturned_cross.wad",
  map    = "MAP01",

  prob   = 50,
  skip_prob = 66,

  theme  = "hell",
  env = "building",

  where  = "edge",
  deep   = 20,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "frame",
}

-- the following are made by MSSP, based on Garrett's original

PREFABS.Wall_gtd_skin_cross =
{
  template  = "Wall_garrett_overturned_cross",

  map       = "MAP02",

  prob      = 50,
  skip_prob = 66,
}
