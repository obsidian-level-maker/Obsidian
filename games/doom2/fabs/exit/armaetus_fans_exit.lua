PREFABS.Exit_armaetus_fans_exit =
{
  file = "exit/armaetus_fans_exit.wad",
  map = "MAP01",

  prob = 125,

  theme = "tech",

  start_fab_peer = "Start_armaetus_fans_tech",

  where  = "seeds",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 2,

  deep = 16,

  x_fit = "frame",
  y_fit = "top",

  sound = "Indoor_Fan",

  tex_SW1BLUE = "SW1METAL"
}

PREFABS.Exit_armaetus_fans_exit_urban =
{
  template = "Exit_armaetus_fans_exit",

  theme = "urban",

  start_fab_peer = "Start_armaetus_fans_urban",

  flat_CEIL4_2 = "FLAT5_1",
  tex_COMPBLUE = "STEP2",
  tex_SW1BLUE = "SW1BLUE"
}

PREFABS.Exit_armaetus_fans_exit_hell =
{
  template = "Exit_armaetus_fans_exit",

  theme = "hell",

  start_fab_peer = "Start_armaetus_fans_hell",

  flat_CEIL4_2 = "DEM1_6",
  tex_COMPBLUE = "MARBLE1",
  tex_SW1BLUE = "SW1GOTH"
}

-- MSSP: Texture randomization has been removed to keep up with peered starts/exit better
