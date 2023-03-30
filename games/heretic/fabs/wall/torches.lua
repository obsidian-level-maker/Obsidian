--
-- Diagonal wall with some torches
--
-- NOTE: no straight wall version, as a torch might completely
--       block player movement.
--

PREFABS.Wall_torches1_diag =
{
  file   = "wall/torches.wad",
  map    = "MAP02",

  

  prob   = 50,
  group  = "torches1",

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit  = "top",
}

