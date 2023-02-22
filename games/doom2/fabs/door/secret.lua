--
-- Secret doors
--

PREFABS.Door_secret =
{
  file   = "door/secret.wad",
  map    = "MAP01",

  prob   = 200,

  where  = "edge",
  key    = "secret",

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  -- pick some different objects for the hint, often none
  thing_34 =
  {
    nothing = 25,
    candle = 10,
    dead_player = 10,
    gibs = 10,
    gibbed_player = 5,
    pool_brains = 5,
  }
}


PREFABS.Door_secret_diag =
{
  file   = "door/secret.wad",
  map    = "MAP02",

  prob   = 50,

  where  = "diagonal",
  key    = "secret",
}


-- wall is lit up
PREFABS.Door_secret3 =
{
  template = "Door_secret",
  map      = "MAP03",

  prob   = 50,
}


-- small gap at bottom
PREFABS.Door_secret4 =
{
  template = "Door_secret",
  map      = "MAP04",

  prob   = 100,
}


-- looks like a window
PREFABS.Door_secret5 =
{
  template = "Door_secret",
  map      = "MAP05",

  prob   = 150,
}

