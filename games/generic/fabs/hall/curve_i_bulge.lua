--
-- 2-seed-wide hallway : straight piece also sometimes a spoopy monster
--

PREFABS.Hallway_curve_i_bulge =
{
  file   = "hall/curve_i_bulge.wad",
  map    = "MAP01",

  group  = "curve",
  prob   = 50,

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 2,

  thing_8132 = { [0] = 75, [8132] = 25 } -- Most of the time just nothing

}

