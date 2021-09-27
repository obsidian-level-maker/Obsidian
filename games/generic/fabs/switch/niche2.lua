--
--  Niche switch
--

PREFABS.Switch_niche2 =
{
  file   = "switch/niche2.wad",
  map    = "MAP01",
  game   = "!hacx",

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

PREFABS.Switch_niche2_hacx = 
{
  template = "Switch_niche2",

  game = "hacx",
  forced_offsets = 
  {
    [19] = { x=-64, y=1 }
  }
}
