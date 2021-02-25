--
-- Cavey walls
--

PREFABS.Wall_cave1 =
{
  file   = "wall/cavish.wad"
  map    = "MAP01"

  rank   = 3
  prob   = 50
  env    = "cave"

  where  = "edge"
  deep   = 24

  bound_z1 = 0
  bound_z2 = 2

  x_fit  = "stretch"
  z_fit  = "stretch"
}


PREFABS.Wall_cave2 =
{
  template = "Wall_cave1"
  map      = "MAP02"
}


PREFABS.Wall_cave3 =
{
  template = "Wall_cave1"
  map      = "MAP03"

  deep  = 16
}

