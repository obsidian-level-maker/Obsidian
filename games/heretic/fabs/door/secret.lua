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

  -- we use a hanging object to mark secret, so must not be outdoor
  env    = "building",

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
}


PREFABS.Door_secret_diag =
{
  file   = "door/secret.wad",
  map    = "MAP02",

  prob   = 50,

  where  = "diagonal",
  key    = "secret",

  -- we use a hanging object to mark secret, so must not be outdoor
  env    = "building",
}


-- wall is lit up
PREFABS.Door_secret3 =
{
  template = "Door_secret",
  map      = "MAP03",

  prob   = 50,

  env    = "any",
}


-- small gap at bottom
PREFABS.Door_secret4 =
{
  template = "Door_secret",
  map      = "MAP04",

  prob   = 100,

  env    = "any",
}


-- looks like a window
PREFABS.Door_secret5 =
{
  template = "Door_secret",
  map      = "MAP05",

  prob   = 100,

  env    = "any",
}

