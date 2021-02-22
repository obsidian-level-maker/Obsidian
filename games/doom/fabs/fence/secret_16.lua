--
-- Secret plain fence
--

PREFABS.Fence_plain_secret =
{
  file   = "fence/secret_16.wad",
  map    = "MAP05",

  where  = "edge",
  key    = "secret",

  prob   = 50,

  seed_w = 2,
  x_fit  = "frame",

  deep   = 16,
  over   = 16,

  fence_h  = 32,
  bound_z1 = 0,

  -- pick some different objects for the hint, often none
  thing_34 =
  {
    candle = 10,
    gibbed_player = 10,
    nothing = 10,
  }
}


PREFABS.Fence_plain_secret2 =
{
  template = "Fence_plain_secret",

  map    = "MAP06",

  prob   = 25,

  seed_w = 2,
  x_fit  = "frame",
}

