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

  prob = 700,

  seed_w = 2,

  x_fit = { 24,104 , 152,232 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_3x =
{
  template = "Joiner_simplest",
  map = "MAP03",

  prob = 1100,

  seed_w = 3,

  x_fit = { 24,104 , 152,232 , 280,360 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_4x =
{
  template = "Joiner_simplest",
  map = "MAP04",

  prob = 1500,

  seed_w = 4,

  x_fit = { 24,104 , 152,232 , 280,360 , 408,496 },
  y_fit = { 24,136 } 
}

--

PREFABS.Joiner_simple_divided_grate_2x =
{
  template = "Joiner_simplest",
  map = "MAP05",

  prob = 600,

  seed_w = 2,

  x_fit = { 24,104 , 152,232 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_grate_3x =
{
  template = "Joiner_simplest",
  map = "MAP06",

  seed_w = 3,

  x_fit = { 24,104 , 152,232 , 280,360 },
  y_fit = { 24,136 } 
}

PREFABS.Joiner_simple_divided_grate_4x =
{
  template = "Joiner_simplest",
  map = "MAP07",

  prob = 1500,

  seed_w = 4,

  x_fit = { 24,104 , 152,232 , 280,360 , 408,496 },
  y_fit = { 24,136 } 
}

--

PREFABS.Joiner_simple_1lite_gtd =
{
  template = "Joiner_simplest",
  map = "MAP08",

  prob = 1250,

  seed_w = 2,

  x_fit = nil,
  y_fit = { 16,24 , 96,112 }
}

PREFABS.Joiner_simple_2lite_gtd =
{
  template = "Joiner_simplest",
  map = "MAP09",

  seed_w = 3,

  x_fit = { 40,48 , 184,200 , 336,344},
  y_fit = { 16,24 , 136,144 }
}
