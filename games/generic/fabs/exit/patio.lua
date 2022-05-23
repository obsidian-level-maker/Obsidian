--
-- Exit patio
--

PREFABS.Exit_patio =
{
  file   = "exit/patio.wad",
  map    = "MAP01",
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, nukem=1, quake=1, strife=0 },

  prob   = 100, --100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 1,

  env    = "outdoor",
  height = 192,

  open_to_sky = true,

  x_fit  = "frame",
}

PREFABS.Exit_patio_chex3 =
{
  template = "Exit_patio",
  game = "chex3",
  forced_offsets =
  {
    [20] = { x=47, y=12 },
    [22] = { x=47, y=12 },
    [24] = { x=47, y=12 },
    [26] = { x=47, y=12 },
  }
}

PREFABS.Exit_patio_hacx =
{
  template = "Exit_patio",
  game = "hacx",
  forced_offsets =
  {
    [20] = { x=0, y=95 },
    [22] = { x=0, y=95 },
    [24] = { x=0, y=95 },
    [26] = { x=0, y=95 },
  }
}

PREFABS.Exit_patio_harmony =
{
  template = "Exit_patio",
  game = "harmony",
  forced_offsets =
  {
    [20] = { x=16, y=79 },
    [22] = { x=16, y=79 },
    [24] = { x=16, y=79 },
    [26] = { x=16, y=79 },
  }
}

PREFABS.Exit_patio_heretic =
{
  template = "Exit_patio",
  game = "heretic",
  forced_offsets =
  {
    [20] = { x=16, y=50 },
    [22] = { x=16, y=50 },
    [24] = { x=16, y=50 },
    [26] = { x=16, y=50 },
  }
}

PREFABS.Exit_patio_hexen =
{
  template = "Exit_patio",
  game = "hexen",
  forced_offsets =
  {
    [20] = { x=0, y=0 },
    [22] = { x=0, y=0 },
    [24] = { x=0, y=0 },
    [26] = { x=0, y=0 },
  }
}

PREFABS.Exit_patio_strife =
{
  template = "Exit_patio",
  game = "strife",
  forced_offsets =
  {
    [20] = { x=0, y=66 },
    [22] = { x=0, y=66 },
    [24] = { x=0, y=66 },
    [26] = { x=0, y=66 },
  }
}

