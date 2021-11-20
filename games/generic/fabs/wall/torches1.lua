--
-- Diagonal wall with some torches
--
-- NOTE: no straight wall version, as a torch might completely
--       block player movement.
--

PREFABS.Wall_torches1_diag =
{
  file   = "wall/torches1.wad",
  map    = "MAP02",
  game   = { chex3=0, doom1=0, doom2=0, hacx=1, heretic=1, strife=1 },

  prob   = 50,
  group  = "torches1",

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit  = "top",
}