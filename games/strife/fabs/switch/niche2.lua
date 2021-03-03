--
--  Niche switch
--

PREFABS.Switch_niche2 =
{
  file   = "switch/niche2.wad",
  map    = "MAP01",

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

},

PREFABS.Switch_niche3 =
{
  file   = "switch/niche2.wad",
  map    = "MAP02",

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

},
