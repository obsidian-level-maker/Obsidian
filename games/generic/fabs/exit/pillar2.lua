--
--  Techy exit pillar
--

PREFABS.Exit_pillar2 =
{
  file  = "exit/pillar2.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  prob  = 100,

  where = "point"
}

PREFABS.Exit_pillar2_chex3 = 
{
  template = "Exit_pillar2",
  game = "chex3",
  engine = "advanced",
}

PREFABS.Exit_pillar2_chex3_nosign = 
{
  template = "Exit_pillar2",
  game = "chex3",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_pillar2_hacx = 
{
  template = "Exit_pillar2",
  game = "hacx",
  engine = "advanced",
}

PREFABS.Exit_pillar2_hacx_nosign = 
{
  template = "Exit_pillar2",
  game = "hacx",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_pillar2_heretic = 
{
  template = "Exit_pillar2",
  game = "heretic",
  engine = "advanced",
}

PREFABS.Exit_pillar2_heretic_nosign = 
{
  template = "Exit_pillar2",
  game = "heretic",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_pillar2_strife =
{
  template = "Exit_pillar2",
  game = "strife",
  forced_offsets = 
  {
    [26] = { x=0, y=66 },
    [34] = { x=0, y=66 },
    [44] = { x=0, y=66 },
    [54] = { x=0, y=66 },
  }
}

PREFABS.Exit_pillar2_secret =
{
  file  = "exit/pillar2.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  -- this kind means "an exit to a secret level"
  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51
}

PREFABS.Exit_pillar2_secret_chex3 = 
{
  template = "Exit_pillar2_secret",
  game = "chex3",
  engine = "advanced",
}

PREFABS.Exit_pillar2_secret_chex3_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "chex3",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_pillar2_secret_hacx = 
{
  template = "Exit_pillar2_secret",
  game = "hacx",
  engine = "advanced",
}

PREFABS.Exit_pillar2_secret_hacx_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "hacx",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_pillar2_secret_heretic = 
{
  template = "Exit_pillar2_secret",
  game = "heretic",
  engine = "advanced",
}

PREFABS.Exit_pillar2_secret_heretic_nosign = 
{
  template = "Exit_pillar2_secret",
  game = "heretic",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_pillar2_secret_strife =
{
  template = "Exit_pillar2_secret",
  game = "strife",
  forced_offsets = 
  {
    [26] = { x=0, y=66 },
    [34] = { x=0, y=66 },
    [44] = { x=0, y=66 },
    [54] = { x=0, y=66 },
  }
}