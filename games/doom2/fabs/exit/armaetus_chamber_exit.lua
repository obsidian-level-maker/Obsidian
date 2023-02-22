PREFABS.Exit_armaetus_chamber_exit_tech =
{
  file   = "exit/armaetus_chamber_exit.wad",
  map    = "MAP01",

  prob   = 150,

  theme = "!hell",

  start_fab_peer = "Start_armaetus_chamber_start_tech",

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top"
}

PREFABS.Exit_armaetus_chamber_exit_gothic =
{
  template = "Exit_armaetus_chamber_exit_tech",
  map = "MAP02",

  theme = "hell",

  start_fab_peer = "Start_armaetus_chamber_start_gothic"
}
