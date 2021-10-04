--
-- Exit closet
--

PREFABS.Exit_closet1_heretic =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "heretic",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_closet1_chex3 =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "chex3",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets = 
  {
    [4] = {x=-91,y=83},
    [5] = {x=-91,y=83},
    [6] = {x=-91,y=83},
    [7] = {x=-91,y=83},
    [13] = {x=48,y=-33},
    [14] = {x=48,y=-33},
    [15] = {x=48,y=-33},
    [16] = {x=48,y=-33},
    [21] = {x=12,y=30}
  }
}

PREFABS.Exit_closet1_hacx =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "hacx",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets = 
  {
    [4] = {x=-98,y=0},
    [5] = {x=-40,y=0},
    [6] = {x=101,y=0},
    [7] = {x=87,y=0},
    [21] = {x=12,y=4}
  }
}

PREFABS.Exit_closet1_harmony =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "harmony",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets = 
  {
    [13] = { x=1,y=-56 },
    [15] = { x=0,y=-56 },
  }
}

PREFABS.Exit_closet1_strife =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "strife",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets = 
  {
    [4] = {x=12,y=36},
    [5] = {x=12,y=36},
    [6] = {x=12,y=36},
    [7] = {x=12,y=36},
    [21] = {x=12,y=36},
  }
}

PREFABS.Exit_closet1_quake =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "quake",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}


----------------------------------------------------------------------

PREFABS.Exit_closet1_secret_heretic =
{
  template = "Exit_closet1_heretic",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet1_secret_chex3 =
{
  template = "Exit_closet1_chex3",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet1_secret_hacx =
{
  template = "Exit_closet1_hacx",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet1_secret_harmony =
{
  template = "Exit_closet1_harmony",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet1_secret_strife =
{
  template = "Exit_closet1_strife",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet1_secret_quake =
{
  template = "Exit_closet1_quake",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}
