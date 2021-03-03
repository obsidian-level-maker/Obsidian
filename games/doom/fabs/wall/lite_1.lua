--
-- Single lighting niche
--

PREFABS.Wall_lite1 =
{
  file   = "wall/lite_1.wad",
  map    = "MAP01",

  prob   = 50,
  group  = "lite1",

  where  = "edge",
  height = 128,
  deep   = 16,

  x_fit  = "frame",
  z_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  -- sometimes use random-off light FX
  sector_1 = { [0]=50, [1]=20 },
}

