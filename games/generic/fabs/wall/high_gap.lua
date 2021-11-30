-- Adapted from GTD's set

PREFABS.Wall_high_gap_straight =
{
  file   = "wall/high_gap.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, strife=1 },

  prob   = 10,
  group = "high_gap",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },
}

PREFABS.Wall_high_gap_straight_chex3 =
{
  file   = "wall/high_gap.wad",
  map    = "MAP01",
  game   = "chex3",

  prob   = 10,
  group = "high_gap",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },

  forced_offsets = 
  {
    [9] = {x=0, y=3}
  }
}

PREFABS.Wall_high_gap_straight_hacx =
{
  file   = "wall/high_gap.wad",
  map    = "MAP01",
  game   = "hacx",

  prob   = 10,
  group = "high_gap",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },

  forced_offsets = 
  {
    [9] = {x=0, y=10}
  }
}

PREFABS.Wall_high_gap_straight_heretic =
{
  file   = "wall/high_gap.wad",
  map    = "MAP01",
  game   = "heretic",

  prob   = 10,
  group = "high_gap",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },

  forced_offsets = 
  {
    [9] = {x=0, y=-41}
  }
}

PREFABS.Wall_generic_gtd_straight_plain =
{
  template = "Wall_high_gap_straight",

  map      = "MAP02",

  prob = 50,
}

PREFABS.Wall_generic_gtd_straight_plain_chex3 =
{
  template = "Wall_high_gap_straight_chex3",

  map      = "MAP02",

  prob = 50,
}

PREFABS.Wall_generic_gtd_straight_plain_hacx =
{
  template = "Wall_high_gap_straight_hacx",

  map      = "MAP02",

  prob = 50,
}

PREFABS.Wall_generic_gtd_straight_plain_heretic =
{
  template = "Wall_high_gap_straight_heretic",

  map      = "MAP02",

  prob = 50,
}

PREFABS.Wall_high_gap_diagonal =
{
  file   = "wall/high_gap.wad",
  map    = "MAP03",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, strife=1 },

  prob   = 50,
  group = "high_gap",

  where  = "diagonal",

  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = { 24,72 },

  sector_1 = { [0]=90, [1]=10 },
}

PREFABS.Wall_high_gap_diagonal_chex3 = 
{
  template = "Wall_high_gap_diagonal",
  game = "chex3",
  forced_offsets = 
  {
    [9] = {x=-5, y=3}
  }
}

PREFABS.Wall_high_gap_diagonal_hacx = 
{
  template = "Wall_high_gap_diagonal",
  game = "hacx",
  forced_offsets = 
  {
    [9] = {x=0, y=10}
  }
}

PREFABS.Wall_high_gap_diagonal_heretic = 
{
  template = "Wall_high_gap_diagonal",
  game = "heretic",
  forced_offsets = 
  {
    [9] = {x=-21, y=-41}
  }
}