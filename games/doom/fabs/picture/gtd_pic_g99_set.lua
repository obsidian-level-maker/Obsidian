PREFABS.Pic_gtd_g99_1 =
{
  file   = "picture/gtd_pic_g99_set.wad",
  map    = "MAP01",

  prob  = 50,
  theme = "hell",

  group = "gtd_g99",

  texture_pack = "armaetus",

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  height = 128,
  deep   = 16,

  x_fit = { 32,64 , 192,224 },
  y_fit = "top",
  z_fit = { 40,88 },
}

PREFABS.Pic_gtd_g99_candles =
{
  template = "Pic_gtd_g99_1",
  map = "MAP02",

  x_fit = { 116,140 },
  z_fit = { 80,88 },
}
