PREFABS.Pic_park_generic_1 =
{
  file = "picture/gtd_pic_generic_park.wad",
  map = "MAP01",

  prob = 50,
  env = "nature",

  group = "natural_walls",

  where  = "seeds",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "stretch",
  y_fit = { 16,128 },
  z_fit = "stretch",

  thing_43 =
  {
    [43] = 50,
    [0] = 50,
  },

  thing_54 =
  {
    [54] = 50,
    [43] = 25,
    [0] = 50,
  },
}

PREFABS.Pic_park_generic_2 =
{
  template = "Pic_park_generic_1",
  map = "MAP02",
}

PREFABS.Pic_park_generic_3 =
{
  template = "Pic_park_generic_1",
  map = "MAP03",
}

PREFABS.Pick_park_generic_4 =
{
  template = "Pic_park_generic_1",
  map = "MAP04",

  z_fit = { 0,56 },
}

PREFABS.Pic_park_generic_5 =
{
  template = "Pic_park_generic_1",

  map = "MAP05",

  z_fit = { 40,120 },
}

-- liquids

PREFABS.Pic_park_generic_1_liquid =
{
  template = "Pic_park_generic_1",

  prob = 15,

  liquid = true,

  map = "MAP10",

  z_fit = { 40,120 },

  sound = "Waterfall_Rush",
}

PREFABS.Pic_park_generic_2_liquid =
{
  template = "Pic_park_generic_1",

  prob = 15,

  liquid = true,

  map = "MAP11",

  z_fit = { 40,120 },
  sound = "Waterfall_Rush",
}

PREFABS.Pic_park_generic_3_liquid =
{
  template = "Pic_park_generic_1",

  prob = 15,

  liquid = true,

  map = "MAP12",

  z_fit = { 40,120 },
}
