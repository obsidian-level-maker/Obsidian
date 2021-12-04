--
-- Small switch
--

PREFABS.Switch_small = -- Default offsets are for Doom 1/2
{
  file   = "switch/small.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  key    = "sw_metal",
  prob   = 50,

  where  = "point",

  tag_1  = "?switch_tag",
}

PREFABS.Switch_small_chex3 =
{
  template = "Switch_small",
  game = "chex3",
  map = "MAP02"
}

PREFABS.Switch_small_hacx =
{
  template = "Switch_small",

  game = "hacx",
  forced_offsets =
  {
    [32] = { x=64,y=0 },
    [34] = { x=64,y=0 },
    [36] = { x=64,y=0 },
    [38] = { x=64,y=0 },
  }
}

PREFABS.Switch_small_harmony =
{
  template = "Switch_small",

  game = "harmony",
  forced_offsets =
  {
    [32] = { x=16,y=16 },
    [34] = { x=16,y=16 },
    [36] = { x=16,y=16 },
    [38] = { x=16,y=16 },
  }
}

PREFABS.Switch_small_heretic =
{
  template = "Switch_small",

  game = "heretic",
  forced_offsets =
  {
    [32] = { x=16,y=48 },
    [34] = { x=16,y=48 },
    [36] = { x=16,y=48 },
    [38] = { x=16,y=48 },
  }
}

PREFABS.Switch_small_hexen =
{
  template = "Switch_small",

  game = "hexen",
  forced_offsets =
  {
    [32] = { x=0,y=0 },
    [34] = { x=0,y=0 },
    [36] = { x=0,y=0 },
    [38] = { x=0,y=0 },
  }
}

PREFABS.Switch_small_strife =
{
  template = "Switch_small",

  game = "strife",
  forced_offsets =
  {
    [32] = { x=0,y=72 },
    [34] = { x=0,y=72 },
    [36] = { x=0,y=72 },
    [38] = { x=0,y=72 },
  }
}