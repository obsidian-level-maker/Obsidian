PREFABS.Start_armaetus_fans_tech =
{
  file   = "start/gtd_armaetus_fans_start.wad",
  map    = "MAP01",

  prob   = 150,

  theme = "tech",

  where  = "seeds",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",

  sound = "Indoor_Fan",

  tex_SW1BLUE = "SW1METAL"
}

PREFABS.Start_armaetus_fans_urban =
{
  template = "Start_armaetus_fans_tech",

  theme = "urban",

  flat_CEIL4_2 = "FLAT5_1",
  tex_COMPBLUE = "STEP2",
  tex_SW1BLUE = "SW1BLUE"
}

PREFABS.Start_armaetus_fans_hell =
{
  template = "Start_armaetus_fans_tech",

  theme = "hell",

  flat_CEIL4_2 = "DEM1_6",
  tex_COMPBLUE = "MARBLE1",
  tex_SW1BLUE = "SW1GOTH"
}
