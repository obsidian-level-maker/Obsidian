--
-- Double lighting niche
--

PREFABS.Wall_lite_double =
{
  file   = "wall/lite_2.wad",
  map    = "MAP01",
  game   = { chex3=1, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 50,
  group  = "lite2",

  where  = "edge",
  height = 128,
  deep   = 16,

  x_fit  = "frame",
  z_fit  = "frame",

  bound_z1 = 0,
  bound_z2 = 128,

  sector_0 = { [0]=50, [1]=20 },
}

PREFABS.Wall_lite_double_hacx =
{
  template = "Wall_lite_double",
  game = "hacx",
  forced_offsets =
  {
    [6] = { x=0, y=-16 },
    [7] = { x=0, y=16 },
    [13] = { x=0, y=16 },
    [20] = { x=0, y=-16 },
    [18] = { x=0, y=-16 },
    [19] = { x=0, y=16 },
    [15] = { x=0, y=16 },
    [21] = { x=0, y=-16 },
  }
}

PREFABS.Wall_lite_double_harmony =
{
  template = "Wall_lite_double",
  game = "harmony",
  forced_offsets =
  {
    [6] = { x=4, y=1 },
    [7] = { x=4, y=1 },
    [13] = { x=4, y=1 },
    [20] = { x=4, y=1 },
    [18] = { x=4, y=1 },
    [19] = { x=4, y=1 },
    [15] = { x=4, y=1 },
    [21] = { x=4, y=1 },
  }
}

PREFABS.Wall_lite_double_heretic =
{
  template = "Wall_lite_double",
  game = "heretic",
  forced_offsets =
  {
    [6] = { x=-11, y=-132 },
    [7] = { x=1, y=28 },
    [13] = { x=118, y=156 },
    [20] = { x=-126, y=-132 },
    [18] = { x=-11, y=-132 },
    [19] = { x=1, y=28 },
    [15] = { x=118, y=156 },
    [21] = { x=-126, y=-132 },
  }
}

PREFABS.Wall_lite_double_strife =
{
  template = "Wall_lite_double",
  game = "strife",
  forced_offsets =
  {
    [6] = { x=0, y=0 },
    [7] = { x=0, y=0 },
    [13] = { x=0, y=0 },
    [20] = { x=0, y=0 },
    [18] = { x=0, y=0 },
    [19] = { x=0, y=0 },
    [15] = { x=0, y=0 },
    [21] = { x=0, y=0 },
  }
}

