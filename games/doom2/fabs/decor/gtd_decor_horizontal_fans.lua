PREFABS.Decor_ceiling_fan =
{
  file = "decor/gtd_decor_horizontal_fans.wad",
  map = "MAP01",

  prob = 3000,
  skip_prob = 50,
  theme  = "!hell",

  env = "building",

  where = "point",
  size = 48,
  height = 128,

  texture_pack = "armaetus",

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 108,110 }
}

PREFABS.Decor_ceiling_fan_quad =
{
  template = "Decor_ceiling_fan",
  map = "MAP02",

  prob = 7500,

  size = 112
}

--

PREFABS.Decor_ceiling_fan_hell =
{
  template = "Decor_ceiling_fan",
  map = "MAP03",

  prob = 3000,
  theme = "hell",

  sink_mode = "never"
}

PREFABS.Decor_ceiling_fan_quad_hell =
{
  template = "Decor_ceiling_fan",
  map = "MAP04",

  prob = 7500,
  theme = "hell",

  size = 112,

  sink_mode = "never"
}
