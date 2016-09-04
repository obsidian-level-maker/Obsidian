--
-- Diagonal wall with some torches
--
-- NOTE: no straight wall version, as a torch might completely
--       block player movement.
--

GROUPS.wall_torches1 =
{
  env = "building"
}


PREFABS.Wall_torches1_diag =
{
  file   = "wall/torches.wad"
  map    = "MAP02"
  where  = "diagonal"

  group  = "torches1"

  bound_z1 = 0
  bound_z2 = 64

  z_fit  = "top"

  prob   = 50
}


PREFABS.Wall_torches2_diag =
{
  template = "Wall_torches1_diag"

  group  = "torches2"

  thing_45 = "red_torch"
}

