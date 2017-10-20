--
-- A rather plain door
--

PREFABS.Door_plain2 =
{
  file   = "door/door1.wad"
  map    = "MAP02"

  prob   = 500
--theme  = "tech"

  where  = "edge"
  seed_w = 2

  deep   = 32
  over   = 32

  x_fit  = "frame"

  bound_z1 = 0
  bound_z2 = 128
}


PREFABS.Door_plain_diag =
{
  file   = "door/door1.wad"
  map    = "MAP03"

  prob   = 100

  where  = "diagonal"

  bound_z1 = 0
  bound_z2 = 128
}


PREFABS.Door_plain2_hell =
{
  template = "Door_plain2"

  theme  = "hell"
  rank   = 2

  flat_TLITE6_6 = "FLAT1"
}

