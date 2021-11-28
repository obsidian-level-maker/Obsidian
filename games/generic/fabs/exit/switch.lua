--
--  Exit switch
--

PREFABS.Exit_switch1 =
{
  file   = "exit/switch.wad",
  map = "MAP01",
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 200,

  where  = "point",
  size   = 80,
}

PREFABS.Exit_switch1_chex3 =
{
  template = "Exit_switch1",
  game = "chex3",
  forced_offsets = 
  {
    [2] = { x=47, y=12 },
    [6] = { x=47, y=12 },
  }
}

PREFABS.Exit_switch1_hacx =
{
  template = "Exit_switch1",
  game = "hacx",
  forced_offsets = 
  {
    [2] = { x=0, y=95 },
    [6] = { x=0, y=95 },
  }
}

PREFABS.Exit_switch1_harmony =
{
  template = "Exit_switch1",
  game = "harmony",
  forced_offsets = 
  {
    [2] = { x=16, y=79 },
    [6] = { x=16, y=79 },
  }
}

PREFABS.Exit_switch1_heretic =
{
  template = "Exit_switch1",
  game = "heretic",
  forced_offsets = 
  {
    [2] = { x=16, y=50 },
    [6] = { x=16, y=50 },
  }
}

PREFABS.Exit_switch1_strife =
{
  template = "Exit_switch1",
  game = "strife",
  forced_offsets = 
  {
    [2] = { x=0, y=66 },
    [6] = { x=0, y=66 },
  }
}

