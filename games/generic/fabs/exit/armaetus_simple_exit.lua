PREFABS.Exit_simple_exit =
{
  file   = "exit/armaetus_simple_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, hexen=0, nukem=1, quake=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 1,

  deep   =  16,

  x_fit  = "frame",
  y_fit  = "top",
  forced_offsets =
  {
    [31] = { x=0, y=16 }
  }
}

PREFABS.Exit_simple_exit_chex3 = 
{
  template = "Exit_simple_exit",
  game = "chex3",
  engine = "advanced",
  forced_offsets =
  {
    [31] = { x=47, y=11 }
  }
}

PREFABS.Exit_simple_exit_chex3_nosign = 
{
  template = "Exit_simple_exit",
  game = "chex3",
  engine = "!advanced",
  map = "MAP02",
  forced_offsets =
  {
    [30] = { x=47, y=11 }
  }
}

PREFABS.Exit_simple_exit_hacx = 
{
  template = "Exit_simple_exit",
  game = "hacx",
  engine = "advanced",
  forced_offsets =
  {
    [31] = { x=0, y=96 }
  }
}

PREFABS.Exit_simple_exit_hacx_nosign = 
{
  template = "Exit_simple_exit",
  game = "hacx",
  engine = "!advanced",
  map = "MAP02",
  forced_offsets =
  {
    [30] = { x=0, y=96 }
  }
}

PREFABS.Exit_simple_exit_harmony =
{
  template = "Exit_simple_exit",
  game = "harmony",
  forced_offsets =
  {
    [31] = { x=16, y=79 },
  }
}

PREFABS.Exit_simple_exit_heretic = 
{
  template = "Exit_simple_exit",
  game = "heretic",
  engine = "advanced",
  forced_offsets =
  {
    [31] = { x=16, y=50 }
  }
}

PREFABS.Exit_simple_exit_heretic_nosign = 
{
  template = "Exit_simple_exit",
  game = "heretic",
  engine = "!advanced",
  map = "MAP02",
  forced_offsets =
  {
    [30] = { x=16, y=50 }
  }
}

PREFABS.Exit_simple_exit_hexen_nosign = 
{
  template = "Exit_simple_exit",
  game = "hexen",
  --engine = "!advanced",
  map = "MAP02",
  forced_offsets =
  {
    [30] = { x=0, y=96 }
  }
}

PREFABS.Exit_simple_exit_strife =
{
  template = "Exit_simple_exit",
  game = "strife",
  forced_offsets =
  {
    [31] = { x=0, y=66 },
    [32] = { x=0, y=26 },
  }
}

PREFABS.Exit_simple_exit_secret =
{
  file   = "exit/armaetus_simple_exit.wad",
  map    = "MAP03",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, hexen=0, nukem=1, quake=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 1,

  deep   =  16,

  x_fit  = "frame",
  y_fit  = "top",

    -- this kind means "an exit to a secret level"
  kind = "secret_exit",
}

PREFABS.Exit_simple_exit_secret_chex3 = 
{
  template = "Exit_simple_exit_secret",
  game = "chex3",
  engine = "advanced",
  forced_offsets =
  {
    [31] = { x=47, y=11 }
  }
}

PREFABS.Exit_simple_exit_secret_chex3_nosign = 
{
  template = "Exit_simple_exit_secret",
  game = "chex3",
  engine = "!advanced",
  map = "MAP04",
  forced_offsets =
  {
    [30] = { x=47, y=11 }
  }
}

PREFABS.Exit_simple_exit_secret_hacx = 
{
  template = "Exit_simple_exit_secret",
  game = "hacx",
  engine = "advanced",
  forced_offsets =
  {
    [31] = { x=0, y=96 }
  }
}

PREFABS.Exit_simple_exit_secret_hacx_nosign = 
{
  template = "Exit_simple_exit_secret",
  game = "hacx",
  engine = "!advanced",
  map = "MAP04",
  forced_offsets =
  {
    [30] = { x=0, y=96 }
  }
}

PREFABS.Exit_simple_exit_secret_harmony =
{
  template = "Exit_simple_exit_secret",
  game = "harmony",
  forced_offsets =
  {
    [31] = { x=16, y=79 },
  }
}

PREFABS.Exit_simple_exit_secret_heretic = 
{
  template = "Exit_simple_exit_secret",
  game = "heretic",
  engine = "advanced",
  forced_offsets =
  {
    [31] = { x=16, y=50 }
  }
}

PREFABS.Exit_simple_exit_secret_heretic_nosign = 
{
  template = "Exit_simple_exit_secret",
  game = "heretic",
  engine = "!advanced",
  map = "MAP04",
  forced_offsets =
  {
    [30] = { x=16, y=50 }
  }
}

PREFABS.Exit_simple_exit_secret_hexen_nosign = 
{
  template = "Exit_simple_exit_secret",
  game = "heretic",
  --engine = "!advanced",
  map = "MAP04",
  forced_offsets =
  {
    [30] = { x=0, y=96 }
  }
}

PREFABS.Exit_simple_exit_secret_strife =
{
  template = "Exit_simple_exit_secret",
  game = "strife",
  forced_offsets =
  {
    [31] = { x=0, y=66 },
    [32] = { x=0, y=26 },
  }
}