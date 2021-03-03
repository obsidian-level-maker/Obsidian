--
-- basic stair, 32 units high
--

PREFABS.Stair_32 =
{
  file   = "stairs/stair_32.wad",

  map    = "MAP01",
  prob   = 90,
  prob_skew = 3,

  theme  = "!hell",

  where  = "seeds",
  shape  = "I",

  x_fit  = "stretch",

  bound_z1 = 0,
  bound_z2 = 32,

  delta_h = 32,
}

PREFABS.Stair_32_hell1 =
{
  template = "Stair_32",
  map  = "MAP02",

  theme  = "hell",
  prob   = 100,

  tex_STEP6 = "MARBGRAY",
  tex_BROWN1 = "MARBGRAY",
  flat_FLOOR7_1 = "FLOOR7_2",

}

PREFABS.Stair_32_hell2 =
{
  template = "Stair_32",
  map  = "MAP02",

  theme  = "hell",
  prob   = 100,

  tex_STEP6 = "MARBLE1",
  tex_BROWN1 = "MARBLE1",
  flat_FLOOR7_1 = "DEM1_6",

}

PREFABS.Stair_32_hell3 =
{
  template = "Stair_32",
  map  = "MAP02",

  theme  = "!tech",
  prob   = 100,

  tex_STEP6 = "METAL",
  tex_BROWN1 = "METAL",
  flat_FLOOR7_1 = "CEIL5_2",

}
