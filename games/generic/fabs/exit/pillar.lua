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
  file   = "exit/pillar.wad",
  map    = "MAP01",
  game   = "hacx",
  prob   = 5,
  where  = "point",

  forced_offsets =
  {
    [0] = { x=-64,y=7 },
    [2] = { x=-64,y=7 },
    [4] = { x=-64,y=7 },
    [6] = { x=-64,y=7 },
  }  
}

PREFABS.Exit_pillar_secret =
{
  template = "Exit_pillar",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_pillar_secret_hacx =
{
  template = "Exit_pillar_hacx",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

