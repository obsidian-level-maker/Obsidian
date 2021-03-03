PREFABS.Arch_generic_urban_frontage =
{
  file   = "door/gtd_urban_generic_frontage_arch.wad",
  map    = "MAP01",

  prob   = 400,

  theme  = "urban",

  kind   = "arch",
  where  = "edge",

  seed_w = 3,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  tex_COMPBLUE =
  {
    COMPBLUE = 10,
    LITE5 = 10,
    LITEBLU4 = 10,
    REDWALL = 10,
  }
}

PREFABS.Arch_generic_urban_frontage_alt =
{
  template = "Arch_generic_urban_frontage",
  map      = "MAP02",

  prob   = 200,

  seed_w = 2,
}
