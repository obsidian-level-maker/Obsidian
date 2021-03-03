PREFABS.Stair_wide_v_curve_3x1 =
{
  file = "stairs/gtd_stair_v_curve_3x1.wad",
  map = "MAP01",

  prob = 250,

  theme = "!hell",

  where = "seeds",
  shape = "I",

  seed_w = 3,

  bound_z1 = 0,
  bound_z2 = 56,

  delta_h = 48,

  thing_2028 =
  {
    [2028] = 1,
    [86] = 1,
  },
}

PREFABS.Stair_wide_v_curve_3x1_hell =
{
  template = "Stair_wide_v_curve_3x1",

  theme = "hell",

  thing_2028 =
  {
    [35] = 1,
    [44] = 1,
    [45] = 1,
    [46] = 1,
  },
}
