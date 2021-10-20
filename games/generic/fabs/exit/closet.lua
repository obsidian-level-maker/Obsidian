--
-- Exit closets
--

PREFABS.Exit_closet =
{
  file   = "exit/closet.wad",
  map    = "MAP01",

  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, strife=1 },

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_closet_nosign =
{
  file   = "exit/closet.wad",
  map    = "MAP02",

  game = { chex3=0, doom1=0, doom2=0, hacx=1, harmony=0, heretic=1, strife=0 },
  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}

-- This isn't used at the moment, but future games might have both only wide doors AND an exit sign - Dasho
PREFABS.Exit_closet_wide =
{
  file   = "exit/closet.wad",
  map    = "MAP03",

  game = { chex3=0, doom1=0, doom2=0, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}

-- Chex Quest 3 only for now - Dasho
PREFABS.Exit_closet_wide_nosign =
{
  file   = "exit/closet.wad",
  map    = "MAP04",

  game = { chex3=1, doom1=0, doom2=0, hacx=0, harmony=0, heretic=0, strife=0 },

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",

  forced_offsets = -- CQ3 Specific - Dasho
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

PREFABS.Exit_closet_secret_nosign =
{
  template = "Exit_closet_nosign",

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

