--
-- Diagonal wall with standing lights
--
-- NOTE: no straight wall version, as a torch might completely
--       block player movement.
--

PREFABS.Wall_torches2_diag =
{
  file   = "wall/torches2.wad",
  map    = "MAP02",
  game   = { chex3=1, doom1=1, doom2=1, hacx=0, heretic=0, strife=0 },

  prob   = 50,
  group  = "torches2",

  where  = "diagonal",

  bound_z1 = 0,
  bound_z2 = 64,

  z_fit  = "top",

  solid_ents = false
}
