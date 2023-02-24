PREFABS.Decor_armaetus_big_computer =
{
  file   = "decor/armaetus_big_computer.wad",
  map    = "MAP01",

  prob   = 7500,
  theme  = "tech",
  env    = "!cave",

  where  = "point",
  size   = 192,
  height = 264,

  bound_z1 = 0,
  bound_z2 = 264,

  z_fit  = "top",
}

PREFABS.Decor_gtd_armae_big_computer_2 =
{
  template = "Decor_armaetus_big_computer",
  map = "MAP02",

  size = 144,
  height = 200,

  sector_12 =
  {
    [0] = 3,
    [12] = 4,
    [13] = 4,
  }
}
