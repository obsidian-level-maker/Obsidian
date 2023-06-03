PREFABS.Joiner_simplest =
{
  file   = "joiner/gtd_simplest.wad",
  map    = "MAP01",

  prob   = 1000,

  where  = "seeds",
  shape  = "I",

  seed_w = 1,
  seed_h = 1,

  deep = 16,
  over = 16,

  bound_z1 = -16,

  x_fit = { 60,68 },
  y_fit = { 72,88 },

  can_flip = true,
}

--

PREFABS.Joiner_simple_divided_2x =
{
  template = "Joiner_simplest",
  map = "MAP02",

  prob = 650,

  seed_w = 2,

  x_fit = { 24,104 , 152,232 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_3x =
{
  template = "Joiner_simplest",
  map = "MAP03",

  prob = 800,

  seed_w = 3,

  x_fit = { 24,104 , 152,232 , 280,360 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_4x =
{
  template = "Joiner_simplest",
  map = "MAP04",

  prob = 1000,

  seed_w = 4,

  x_fit = { 24,104 , 152,232 , 280,360 , 408,496 },
  y_fit = { 24,136 } 
}

--

PREFABS.Joiner_simple_divided_grate_2x =
{
  template = "Joiner_simplest",
  map = "MAP05",

  prob = 550,

  seed_w = 2,

  x_fit = { 24,104 , 152,232 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_grate_3x =
{
  template = "Joiner_simplest",
  map = "MAP06",

  prob = 700,

  seed_w = 3,

  x_fit = { 24,104 , 152,232 , 280,360 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_grate_4x =
{
  template = "Joiner_simplest",
  map = "MAP07",

  prob = 800,

  seed_w = 4,

  x_fit = { 24,104 , 152,232 , 280,360 , 408,496 },
  y_fit = { 24,136 } 
}

--

PREFABS.Joiner_simple_1lite_gtd =
{
  file   = "joiner/gtd_simplest.wad",
  map    = "MAP08",

  prob   = 550,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  bound_z1 = 0,

  y_fit = { 16,24 , 136,144 },

  can_flip = true,

  flat_TLITE6_4 =
  {
    TLITE6_5 = 5,
    TLITE6_6 = 5
  }
}

PREFABS.Joiner_simple_2lite_gtd =
{
  template = "Joiner_simple_1lite_gtd",
  map = "MAP09",

  prob = 700,

  seed_w = 2,
}

PREFABS.Joiner_simple_3lite_gtd =
{
  template = "Joiner_simple_1lite_gtd",
  map = "MAP09",

  prob = 800,

  seed_w = 3,
}
