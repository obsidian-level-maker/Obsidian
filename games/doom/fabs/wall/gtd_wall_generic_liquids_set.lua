PREFABS.Wall_gtd_generic_sunderfall =
{
  file   = "wall/gtd_wall_generic_liquids_set.wad",
  map    = "MAP01",

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

  liquid = false,

  tex__LIQUID = "NUKAGE1",
  floor__LIQUID = "NUKAGE1"
}
