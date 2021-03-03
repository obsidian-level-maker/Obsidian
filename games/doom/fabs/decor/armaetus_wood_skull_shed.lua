PREFABS.Decor_wood_skull_shed =
{
  file   = "decor/armaetus_wood_skull_shed.wad",
  map    = "MAP01",

  prob   = 4500,
  skip_prob = 35,

  where  = "point",
  theme  = "!tech",
  size   = 192,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 24,88 }
}

PREFABS.Decor_wood_skull_shed_octo =
{
  template = "Decor_wood_skull_shed",
  map = "MAP02",

  height = 192,

  bound_z2 = 192,

  z_fit = { 40,88 }
}

PREFABS.Decor_wood_skull_shed_grate =
{
  template = "Decor_wood_skull_shed",
  map = "MAP03"
}
