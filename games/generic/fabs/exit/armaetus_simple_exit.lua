PREFABS.Exit_armaetus_simple_exit =
{
  file   = "exit/armaetus_simple_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep   =  16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_armaetus_simple_exit_harmony =
{
  template = "Exit_armaetus_simple_exit",
  game = "harmony",
  forced_offsets =
  {
    [31] = { x=16, y=79 },
  }
}

PREFABS.Exit_armaetus_simple_exit_strife =
{
  template = "Exit_armaetus_simple_exit",
  game = "strife",
  forced_offsets =
  {
    [31] = { x=0, y=66 },
    [32] = { x=0, y=26 },
  }
}

PREFABS.Exit_armaetus_simple_exit_nosign =
{
  file   = "exit/armaetus_simple_exit.wad",
  map = "MAP02",
  game = { chex3=0, doom1=0, doom2=0, hacx=1, harmony=0, heretic=0, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep   =  16,

  x_fit  = "frame",
  y_fit  = "top",
  forced_offsets =
  {
    [30] = { x=0, y=96 }
  }
}

PREFABS.Exit_armaetus_simple_exit_nosign_chex3 =
{
  template = "Exit_armaetus_simple_exit_nosign",
  game = "chex3",
  forced_offsets =
  {
    [30] = { x=47, y=11 }
  }
}

PREFABS.Exit_armaetus_simple_exit_nosign_heretic =
{
  template = "Exit_armaetus_simple_exit_nosign",
  game = "heretic",
  forced_offsets =
  {
    [30] = { x=16, y=50 }
  }
}