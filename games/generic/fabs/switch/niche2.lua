--
--  Niche switch
--

PREFABS.Switch_niche2 =
{
  file   = "switch/niche2.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  key    = "sw_metal",
  prob   = 50,

  where  = "seeds",
  deep   =  16,
  over   = -16,

  x_fit = "frame",
  y_fit = "top",

  tag_1 = "?switch_tag",

  -- use the occasional-blink FX (fairly rarely)
  sector_1  = { [0]=80, [1]=15, [2]=5, [3]=5, [8]=5 },
}

PREFABS.Switch_niche2_chex3 = 
{
  template = "Switch_niche2",
  game = "chex3",
  map = "MAP02"
}

PREFABS.Switch_niche2_hacx = 
{
  template = "Switch_niche2",

  game = "hacx",
  forced_offsets = 
  {
    [31] = { x=0, y=0 },
    [32] = { x=0, y=0 },
    [33] = { x=0, y=0 },
  }
}

PREFABS.Switch_niche2_harmony = 
{
  template = "Switch_niche2",

  game = "harmony",
  forced_offsets = 
  {
    [31] = { x=16, y=16 },
    [32] = { x=16, y=16 },
    [33] = { x=16, y=16 },
  }
}

PREFABS.Switch_niche2_heretic = 
{
  template = "Switch_niche2",

  game = "heretic",
  forced_offsets = 
  {
    [31] = { x=16, y=48 },
    [32] = { x=16, y=48 },
    [33] = { x=16, y=48 },
  }
}

PREFABS.Switch_niche2_hexen = 
{
  template = "Switch_niche2",

  game = "hexen",
  forced_offsets = 
  {
    [31] = { x=0, y=32 },
    [32] = { x=0, y=32 },
    [33] = { x=0, y=32 },
  }
}

PREFABS.Switch_niche2_strife = 
{
  template = "Switch_niche2",

  game = "strife",
  forced_offsets = 
  {
    [31] = { x=0, y=72 },
    [32] = { x=0, y=72 },
    [33] = { x=0, y=72 },
  }
}
