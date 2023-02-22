PREFABS.Pic_simple_crates_1 =
{
  file   = "picture/scionox_pic_simple_crates.wad",
  map    = "MAP01",

  prob   = 10,
  theme = "tech",
  env = "!cave",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Pic_simple_crates_2 =
{
  template = "Pic_simple_crates_1",
  map      = "MAP02",

  thing_15 =
  {
    [0] = 1,
    [15] = 1,
  },
}

PREFABS.Pic_simple_crates_3 =
{
  template = "Pic_simple_crates_1",
  map      = "MAP03",
}