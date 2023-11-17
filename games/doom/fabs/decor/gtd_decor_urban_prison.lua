PREFABS.Decor_prison_support_pillar =
{
  file   = "decor/gtd_decor_urban_prison.wad",
  map    = "MAP01",

  prob   = 5000,

  group = "gtd_prison_A",

  where  = "point",
  size   = 80,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 79,80 }
}

PREFABS.Decor_prison_freestanding_cage =
{
  template = "Decor_prison_support_pillar",
  map = "MAP02",

  size = 96,

  z_fit = "top"
}
