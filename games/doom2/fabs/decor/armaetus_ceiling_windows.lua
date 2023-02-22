PREFABS.Decor_armaetus_sky_penta =
{
  file   = "decor/armaetus_ceiling_windows.wad",
  map    = "MAP01",

  prob   = 5000,
  height = 128,

  theme  = "!tech",
  env    = "building",

  where  = "point",
  size   = 128,

  bound_z1 = 0,
  bound_z2 = 144,

  z_fit = "bottom",
}

PREFABS.Decor_gtd_sky_reticule =
{
  template = "Decor_armaetus_sky_penta",
  map = "MAP02",
}

PREFABS.Decor_gtd_sky_bars =
{
  template = "Decor_armaetus_sky_penta",
  map = "MAP03",
}
