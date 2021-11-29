PREFABS.Exit_armaetus_tp_closet =
{
  file   = "exit/armaetus_tp_closet_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_armaetus_tp_closet_strife =
{
  template = "Exit_armaetus_tp_closet",
  game = "strife",
  forced_offsets = 
  {
    [32] = { x=0, y=25 }
  }
}

PREFABS.Exit_armaetus_tp_closet_nosign =
{
  file   = "exit/armaetus_tp_closet_exit.wad",
  map    = "MAP02",
  game = { chex3=1, doom1=0, doom2=0, hacx=1, harmony=0, heretic=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",
}
