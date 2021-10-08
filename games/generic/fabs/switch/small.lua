--
-- Small switch
--

PREFABS.Switch_small =
{
  file   = "switch/small.wad",
  map    = "MAP01",
  game   = {heretic=1, hexen=1},

  key    = "sw_metal",
  prob   = 50,

  where  = "point",

  tag_1  = "?switch_tag",
}

PREFABS.Switch_small_chex3 =
{
  template = "Switch_small",

  game = "chex3",
  forced_offsets =
  {
    [12] = { x=4,y=67 },
    [14] = { x=4,y=67 },
    [16] = { x=4,y=67 },
    [18] = { x=4,y=67 },
  }
}

PREFABS.Switch_small_hacx =
{
  template = "Switch_small",

  game = "hacx",
  forced_offsets =
  {
    [12] = { x=-60,y=41 },
    [14] = { x=-60,y=41 },
    [16] = { x=-60,y=41 },
    [18] = { x=-60,y=41 },
  }
}

PREFABS.Switch_small_harmony =
{
  template = "Switch_small",

  game = "harmony",
  forced_offsets =
  {
    [12] = { x=4,y=72 },
    [14] = { x=4,y=72 },
    [16] = { x=4,y=72 },
    [18] = { x=4,y=72 },
  }
}

PREFABS.Switch_small_strife =
{
  template = "Switch_small",

  game = "strife",
  forced_offsets =
  {
    [12] = { x=4,y=54 },
    [14] = { x=4,y=54 },
    [16] = { x=4,y=54 },
    [18] = { x=4,y=54 },
  }
}

