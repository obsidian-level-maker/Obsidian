PREFABS.Item_simple_crates_1_secret =
{
  file   = "item/scionox_secret_simple_crates.wad",
  map    = "MAP01",

  prob   = 10,
  theme = "tech",
  env = "!cave",

  where  = "seeds",
  key    = "secret",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Item_simple_crates_2_secret =
{
  template = "Item_simple_crates_1_secret",
  map      = "MAP02",

  seed_h = 2,
  prob   = 20,
  thing_15 =
  {
    [0] = 1,
    [15] = 1,
  },
}

PREFABS.Item_simple_crates_3_secret =
{
  template = "Item_simple_crates_1_secret",
  map      = "MAP03",
  seed_h = 2,
  prob   = 20,
}