--
-- Door #1, quite plain
--

PREFABS.Door_plain1 =
{
  file   = "door/door1.wad"
  map    = "MAP01"
  where  = "edge"

  deep   = 32
  over   = 32

  bound_z1 = 0
  bound_z2 = 128

  prob   = 100
}


PREFABS.Door_plain2 =
{
  file   = "door/door1.wad"
  map    = "MAP02"
  where  = "edge"

  seed_w = 2

  deep   = 32
  over   = 32

  x_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128

--theme  = "tech"
  prob   = 500
}


PREFABS.Door_plain_diag =
{
  file   = "door/door1.wad"
  map    = "MAP03"
  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 128

  prob   = 100
}

