PREFABS.Exit_tech_immersive_exit =
{
  file = "exit/gtd_generic_immersive_exit.wad",
  map = "MAP01",

  prob = 500,
  theme = "tech",

  where = "seeds",

  start_fab_peer = "Start_generic_immersive_start",

  seed_w = 2,
  seed_h = 2,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  sector_1 = { [0]=70, [1]=15 }
}

PREFABS.Exit_tech_immersive_exit_urban =
{
  template = "Exit_tech_immersive_exit",

  map = "MAP02",

  theme = "urban",

  start_fab_peer = "Start_generic_immersive_start_urban",
}
