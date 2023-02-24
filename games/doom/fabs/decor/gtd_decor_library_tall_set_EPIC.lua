PREFABS.Decor_library_tall_EPIC_small =
{
  file = "decor/gtd_decor_library_tall_set_EPIC.wad",
  map = "MAP01",

  prob = 5000,
  env = "building",

  group = "gtd_library_tall",

  where = "point",
  size = 120,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Decor_library_tall_EPIC_big =
{
  template = "Decor_library_tall_EPIC_small",
  map = "MAP02",

  size = 112
}

--

PREFABS.Decor_library_tall_ceiling_EPIC_small =
{
  template = "Decor_library_tall_EPIC_small",
  map = "MAP03",

  size = 48,

  prob = 1250
}

PREFABS.Decor_library_tall_ceiling_EPIC_big =
{
  template = "Decor_library_tall_EPIC_small",
  map = "MAP04",

  size = 80,

  prob = 2500
}

--

PREFABS.Decor_library_tall_ceiling_EPIC_small_pillared =
{
  template = "Decor_library_tall_EPIC_small",
  map = "MAP05",

  size = 48,

  prob = 1250
}

PREFABS.Decor_library_tall_ceiling_EPIC_big_pillared =
{
  template = "Decor_library_tall_EPIC_small",
  map = "MAP06",

  size = 80,

  prob = 2500
}
