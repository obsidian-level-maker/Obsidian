PREFABS.Wall_gtd_generic_sunderfall =
{
  file   = "wall/gtd_wall_generic_liquids_set.wad",
  map    = "MAP01",


  liquid = "there_is",

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
  file   = "wall/gtd_wall_generic_liquids_set.wad",
  map    = "MAP01",



  prob = 50,
  group = "gtd_sunderfall",

  where  = "edge",
  height = 96,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "frame",

  sound = "Water_Streaming",

  tex__LIQUID = "NUKAGE1",
  flat__LIQUID = "NUKAGE1"
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
  template = "Wall_gtd_generic_sunderfall_no_liq",
  map = "MAP03",

  group = "gtd_sunderfall_barred",

  tex__LIQUID = "NUKAGE1",
  flat__LIQUID = "NUKAGE1"
}

--

PREFABS.Wall_gtd_generic_lavafall =
{
  file   = "wall/gtd_wall_generic_liquids_set.wad",
  map    = "MAP10",


  prob = 50,
  group = "gtd_lavafall",

  where  = "edge",
  height = 96,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 26,28 },
  
  tex_FENCE2 = "MIDGRATE"
}

PREFABS.Wall_gtd_generic_lavafall_diag =
{
  template = "Wall_gtd_generic_lavafall",
  map    = "MAP11",

  where = "diagonal"
}

PREFABS.Wall_gtd_generic_lavafall_vanilla =
{
  file   = "wall/gtd_wall_generic_liquids_set.wad",
  map    = "MAP10",


  prob = 50,
  group = "gtd_lavafall",

  texture_pack = "armaetus",

  where  = "edge",
  height = 96,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = { 26,28 }
}

PREFABS.Wall_gtd_generic_lavafall_diag_vanilla =
{
  template = "Wall_gtd_generic_lavafall_vanilla",
  map    = "MAP11",

  where = "diagonal"
}
