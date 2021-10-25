--
-- Exit closets
--

PREFABS.Exit_closet = -- Default offsets are for Doom 1/2
{
  file   = "exit/closet.wad",
  map    = "MAP01",

  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets =
  {
    [21] = { x=0, y=64 },
    [25] = { x=0, y=64 },
  }

}

PREFABS.Exit_closet_strife =
{
  file   = "exit/closet.wad",
  map    = "MAP01",

  game = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=0, strife=1 },

  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets =
  {
    [21] = { x=0, y=64 },
    [25] = { x=0, y=64 },
    [38] = { x=0, y=10 },
    [42] = { x=0, y=10 },
  }

}

PREFABS.Exit_closet_harmony =
{
  file   = "exit/closet.wad",
  map    = "MAP01",

  game = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=1, heretic=0, strife=0 },

  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets =
  {
    [21] = { x=0, y=64 },
    [25] = { x=0, y=64 },
    [44] = { x=0, y=-56 },
    [46] = { x=0, y=-56 },
  }

}

PREFABS.Exit_closet_nosign = -- Default offset is for Heretic
{
  file   = "exit/closet.wad",
  map    = "MAP02",

  game = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=1, strife=0 },
  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets =
  {
    [21] = { x=0, y=32 },
    [25] = { x=0, y=32 },
  }

}

PREFABS.Exit_closet_nosign_hacx =
{
  file   = "exit/closet.wad",
  map    = "MAP02",

  game = { chex3=0, doom1=0, doom2=0, hacx=1, harmony=0, heretic=0, strife=0 },
  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets =
  {
    [21] = { x=0, y=18 },
    [25] = { x=0, y=18 },
  }

}

-- This isn't used at the moment, but there might be a demand to make one with a wide door AND an exit sign - Dasho
PREFABS.Exit_closet_wide =
{
  file   = "exit/closet.wad",
  map    = "MAP03",

  game = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_closet_wide_nosign = -- Default offset is for Chex Quest 3
{
  file   = "exit/closet.wad",
  map    = "MAP04",

  game = { chex3=1, doom1=0, doom2=0, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets =
  {
    [22] = { x=0, y=64 },
    [26] = { x=0, y=64 },
  }

}

----------------------------------------------------------------------

PREFABS.Exit_closet_secret =
{
  template = "Exit_closet",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet_secret_strife =
{
  template = "Exit_closet_strife",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet_secret_harmony =
{
  template = "Exit_closet_harmony",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet_secret_nosign =
{
  template = "Exit_closet_nosign",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet_secret_nosign_hacx =
{
  template = "Exit_closet_nosign_hacx",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet_secret_wide =
{
  template = "Exit_closet_wide",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet_secret_wide_nosign =
{
  template = "Exit_closet_wide_nosign",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

