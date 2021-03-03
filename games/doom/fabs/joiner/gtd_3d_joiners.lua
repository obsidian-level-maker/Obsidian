PREFABS.Joiner_gtd_3D_joiner_center =
{
  file   = "joiner/gtd_3d_joiners.wad",
  map = "MAP01",

  prob   = 150,
  style  = "steepness",

  engine   = "zdoom",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = { 24,32 , 224,232 },
  y_fit  = { 96,112 },

  delta_h  = 128,
  nearby_h = 128,
  can_flip = true,
}

PREFABS.Joiner_gtd_3D_joiner_side_lift_1 =
{
  template = "Joiner_gtd_3D_joiner_center",
  map      = "MAP02",

  prob = 75,

  x_fit = { 136,144 },
}

PREFABS.Joiner_gtd_3D_joiner_side_lift_2 =
{
  template = "Joiner_gtd_3D_joiner_center",
  map      = "MAP03",

  prob = 75,

  x_fit = { 112,120 },
}
