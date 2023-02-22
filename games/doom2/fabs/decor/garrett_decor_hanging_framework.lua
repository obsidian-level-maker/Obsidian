PREFABS.Decor_garrett_hanging_framework =
{
  file   = "decor/garrett_decor_hanging_framework.wad",
  map = "MAP01",

  prob   = 5000,
  theme  = "tech",
  env    = "building",

  where  = "point",

  height = 164,
  size   = 104,

  bound_z1 = 0,
  bound_z2 = 164,

  z_fit = {0, 2}
}

PREFABS.Decor_gtd_hanging_framework_2 =
{
  template = "Decor_garrett_hanging_framework",
  map = "MAP02",

  height = 192,
  size = 64,

  bound_z2 = 192,
}

PREFABS.Decor_gtd_hanging_framework_3 =
{
  template = "Decor_garrett_hanging_framework",
  map = "MAP03",

  height = 172,
  size = 80,

  bound_z2 = 172,

  z_fit = { 128,156 }
}
