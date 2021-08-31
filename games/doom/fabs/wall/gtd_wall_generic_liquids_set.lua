PREFABS.Wall_gtd_generic_sunderfall =
{
  file   = "wall/gtd_wall_generic_liquids_set.wad",
  map    = "MAP01",

  rank = 2,
  liquids = true,

  prob = 50,
  group = "gtd_sunderfall",

  where  = "edge",
  height = 96,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "frame",

  sound = "Water_Streaming",
}

PREFABS.Wall_gtd_generic_sunderfall_no_liq =
{
  template = "Wall_gtd_generic_sunderfall",

  rank = 1,
  liquid = false,

  tex__LIQUID = "NUKAGE1",
  floor__LIQUID = "NUKAGE1"
}

--

PREFABS.Wall_gtd_generic_sunderfall_barred =
{
  template = "Wall_gtd_generic_sunderfall",
  map = "MAP03",

  group = "gtd_sunderfall_barred"
}

PREFABS.Wall_gtd_generic_sunderfall_barred_no_liq =
{
  template = "Wall_gtd_generic_sunderfall",

  group = "gtd_sunderfall_barred",

  rank = 2,

  liquid = false,

  tex__LIQUID = "NUKAGE1",
  floor__LIQUID = "NUKAGE1"
}
