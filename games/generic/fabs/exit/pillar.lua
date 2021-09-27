--
--  Exit pillar
--

PREFABS.Exit_pillar =
{
  file   = "exit/pillar.wad",
  map    = "MAP01",
  game   = "!hacx",
  prob   = 5,
  where  = "point",
}

PREFABS.Exit_pillar_hacx =
{
  template = "Exit_pillar",
  game = "hacx",

  forced_offsets =
  {
    [0] = { x=-64,y=7 },
    [2] = { x=-64,y=7 },
    [4] = { x=-64,y=7 },
    [6] = { x=-64,y=7 },
  }  
}

