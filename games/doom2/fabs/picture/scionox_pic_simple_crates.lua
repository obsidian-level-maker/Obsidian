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

-- urban variants only appear inside buildings

PREFABS.Pic_simple_crates_1_u =
{
  template = "Pic_simple_crates_1",
  map = "MAP01",

  theme = "urban",

  env = "building",
}

PREFABS.Pic_simple_crates_2_u =
{
  template = "Pic_simple_crates_1",
  map = "MAP02",

  theme = "urban",

  env = "building",

  thing_15 =
  {
    [0] = 1,
    [15] = 1,
  },
}

PREFABS.Pic_simple_crates_3_u =
{
  template = "Pic_simple_crates_1",
  map = "MAP03",

  theme = "urban",

  env = "building",
}
