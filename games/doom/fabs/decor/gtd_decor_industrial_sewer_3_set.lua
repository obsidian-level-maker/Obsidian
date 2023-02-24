PREFABS.Decor_gtd_sewer_3_hatch =
{
  file = "decor/gtd_decor_industrial_sewer_3_set.wad",
  map = "MAP01",

  prob = 5000,
  group = "gtd_sewer_set_3",

  where = "point",
  size = 96,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 70,71 , 91,94 }
}

PREFABS.Decor_gtd_sewer_3_hatch_pouring =
{
  template = "Decor_gtd_sewer_3_hatch",
  map = "MAP02"
}

PREFABS.Decor_gtd_sewer_3_vat =
{
  template = "Decor_gtd_sewer_3_hatch",
  map = "MAP03",

  prob = 10000,
  size = 132,

  height = 64,

  bound_z2 = 64,

  z_fit = "top"
}
