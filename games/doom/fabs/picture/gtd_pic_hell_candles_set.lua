PREFABS.Pic_gtd_candles_grouped_1 =
{
  file = "picture/armaetus_candles.wad",
  map = "MAP01",

  prob = 50,
  env = "building",

  texture_pack = "armaetus",
  group = "gtd_wall_candles",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep =  16,

  x_fit = { 56,72 },
  y_fit = "top",
}

PREFABS.Pic_gtd_candles_grouped_2 =
{
  template = "Pic_gtd_candles_grouped_1",
  map = "MAP02",

  group = "gtd_wall_candles",

  seed_w = 2,

  x_fit = { 120,136 }
}

PREFABS.Pic_gtd_candles_grouped_3 =
{
  template = "Pic_gtd_candles_grouped_1",
  map = "MAP03",

  prob = 75,

  group = "gtd_wall_candles",

  height = 144,

  seed_w = 2,

  x_fit = { 80,88 , 168,176 }
}
