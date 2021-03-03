PREFABS.Exit_armaetus_superlift_up =
{
  file   = "exit/armaetus_closet_superlift.wad",
  map    = "MAP01",

  prob   = 200,

  theme  = "!hell",

  where  = "seeds",
  seed_w = 1,
  seed_h = 2,

  deep = 16,

  height = 96,

  bound_z1 = -1024,
  bound_z2 = 136,

  x_fit  = "frame",
  y_fit  = "bottom",
}

PREFABS.Exit_armaetus_superlift_down =
{
  template = "Exit_armaetus_superlift_up",

  map = "MAP02",

  bound_z1 = 0,
  bound_z2 = 1032+8,
}
