--
-- Secret doors
--

-- wall is lit up
PREFABS.Door_secret3 =
{
  file   = "door/secret.wad",
  map    = "MAP03",

  prob   = 200,

  where  = "edge",
  key    = "secret",

  env    = "any",

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
}


-- small gap at bottom
PREFABS.Door_secret4 =
{
  template = "Door_secret3",
  map      = "MAP04",

  prob   = 100,

  env    = "any",
}