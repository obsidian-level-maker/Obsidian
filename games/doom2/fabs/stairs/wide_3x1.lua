--
-- wide stair, 3 seeds across
--

PREFABS.Stair_wide_3x1 =
{
  file   = "stairs/wide_3x1.wad",
  map    = "MAP01",

  prob   = 250,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,

  bound_z1 = 0,
  bound_z2 = 32,

  delta_h = 32,
}


PREFABS.Stair_wide_3x1_torch =
{
  file   = "stairs/wide_3x1.wad",
  map    = "MAP02",

  prob  = 150,
  theme = "urban",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,

  bound_z1 = 0,
  bound_z2 = 32,

  delta_h = 32,

  thing_46 =
  {
   red_torch = 50,
   blue_torch = 30,
   green_torch = 15,
  },

}

-- Tech vesion
PREFABS.Stair_wide_3x1_torch_tech =
{
  template   = "Stair_wide_3x1_torch",
  map    = "MAP02",
  theme  = "tech",

  tex_METAL = "SHAWN2",
  flat_CEIL5_2 = "FLAT23",

  thing_46 =
  {
    mercury_lamp = 50,
    mercury_small = 35,
    lamp = 25,
  },

  tex_STEP5 = "STEP3",

}

-- Hell vesion
PREFABS.Stair_wide_3x1_torch_hell =
{
  template   = "Stair_wide_3x1_torch",
  map    = "MAP02",
  theme  = "hell",

  thing_46 =
  {
   red_torch = 50,
   blue_torch = 50,
   green_torch = 50,
  },
}

PREFABS.Stair_wide_3x1_torch_hell_gore =
{
  template   = "Stair_wide_3x1_torch",
  map    = "MAP02",
  theme  = "hell",

  thing_46 =
  {
   skull_pole = 70,
   skull_kebab = 70,
   impaled_human = 50,
   impaled_twitch = 50,
  },
}

PREFABS.Stair_wide_3x1_torch_eye =
{
  template   = "Stair_wide_3x1_torch",
  map    = "MAP02",
  theme  = "hell",

  thing_46 = "evil_eye",

}
