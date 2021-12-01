--
-- Single lighting niche
--

PREFABS.Wall_lite =
{
  file   = "wall/lite_1.wad",
  map    = "MAP01",
  game   = { chex3=1, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 50,
  group  = "lite1",

  where  = "edge",
  height = 128,
  deep   = 16,

  x_fit  = "frame",
  z_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  -- sometimes use random-off light FX
  sector_1 = { [0]=50, [1]=20 },
}

PREFABS.Wall_lite_hacx = 
{
  template = "Wall_lite",
  game = "hacx",
  forced_offsets =
  {
    [6] = { x=0, y=-16 },
    [7] = { x=0, y=16 },
    [13] = { x=0, y=16 },
    [14] = { x=0, y=-16 },
  }
}

PREFABS.Wall_lite_harmony = 
{
  template = "Wall_lite",
  game = "harmony",
  forced_offsets =
  {
    [6] = { x=4, y=1 },
    [7] = { x=4, y=1 },
    [13] = { x=4, y=1 },
    [14] = { x=4, y=1 },
  }
}

PREFABS.Wall_lite_heretic = 
{
  template = "Wall_lite",
  game = "heretic",
  forced_offsets =
  {
    [6] = { x=-11, y=-132 },
    [7] = { x=1, y=28 },
    [13] = { x=118, y=156 },
    [14] = { x=-126, y=-132 },
  }
}

PREFABS.Wall_lite_strife = 
{
  template = "Wall_lite",
  game = "strife",
  forced_offsets =
  {
    [6] = { x=0, y=0 },
    [7] = { x=0, y=0 },
    [13] = { x=0, y=0 },
    [14] = { x=0, y=0 },
  }
}

