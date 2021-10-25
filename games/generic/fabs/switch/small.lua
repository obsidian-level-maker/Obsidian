--
-- Small switch
--

PREFABS.Switch_small = -- Default offsets are for Doom 1/2
{
  file   = "switch/small.wad",
  map    = "MAP01",
  game   = { doom1=1, doom2=1 },

  key    = "sw_metal",
  prob   = 50,

  where  = "point",

  tag_1  = "?switch_tag",
}

-- Need to rework offsets due to fab change - Dasho
PREFABS.Switch_small_chex3 =
{
  template = "Switch_small",

  game = "chex3",

  forced_offsets =
  {
    [32] = { x=8,y=76 },
    [34] = { x=8,y=76 },
    [36] = { x=8,y=76 },
    [38] = { x=8,y=76 },
  }
}

PREFABS.Switch_small_hacx =
{
  template = "Switch_small",

  game = "hacx",
  forced_offsets =
  {
    [32] = { x=72,y=65 },
    [34] = { x=72,y=65 },
    [36] = { x=72,y=65 },
    [38] = { x=72,y=65 },
  }
}

PREFABS.Switch_small_harmony =
{
  template = "Switch_small",

  game = "harmony",
  forced_offsets =
  {
    [32] = { x=8,y=80 },
    [34] = { x=8,y=80 },
    [36] = { x=8,y=80 },
    [38] = { x=8,y=80 },
  }
}

PREFABS.Switch_small_heretic =
{
  template = "Switch_small",

  game = "heretic",
  forced_offsets =
  {
    [32] = { x=8,y=48 },
    [34] = { x=8,y=48 },
    [36] = { x=8,y=48 },
    [38] = { x=8,y=48 },
  }
}

PREFABS.Switch_small_strife =
{
  template = "Switch_small",

  game = "strife",
  forced_offsets =
  {
    [32] = { x=8,y=62 },
    [34] = { x=8,y=62 },
    [36] = { x=8,y=62 },
    [38] = { x=8,y=62 },
  }
}

