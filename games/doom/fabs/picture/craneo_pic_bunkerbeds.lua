PREFABS.Pic_craneo_bunkbed_2x1 =
{
  file = "picture/craneo_pic_bunkerbeds.wad",
  map = "MAP01",

  prob = 12,
  group = "cran_bunkbeds",
  port = "zdoom",
  
  where = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Pic_craneo_bunkbed_3x1 =
{
  template = "Pic_craneo_bunkbed_2x1",
  map = "MAP02",

  seed_w = 3,
}

PREFABS.Pic_craneo_bunkbed_2x2 =
{
  template = "Pic_craneo_bunkbed_2x1",
  map = "MAP03",

  seed_w = 2,
  seed_h = 2
}
