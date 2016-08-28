--
-- Secret doors
--

PREFABS.Door_secret =
{
  file   = "door/secret.wad"
  map    = "MAP01"
  where  = "edge"

  key    = "secret"

  deep   = 16
  over   = 16

  x_fit  = "frame"

  prob   = 100
}


PREFABS.Door_secret_diag =
{
  file   = "door/secret.wad"
  map    = "MAP02"
  where  = "diagonal"
  
  key    = "secret"
}


PREFABS.Door_secret2 =
{
  template = "Door_secret"

  map    = "MAP03"

  prob   = 50
}


PREFABS.Door_secret3 =
{
  template = "Door_secret"

  map    = "MAP04"

  prob   = 100
}

