PREFABS.Exit_tp_closet =
{
  file   = "exit/armaetus_tp_closet_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, nukem=1, quake=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_tp_closet_chex3 =
{
  template = "Exit_tp_closet",
  game = "chex3",
  engine = "advanced"
}

PREFABS.Exit_tp_closet_chex3_nosign =
{
  template = "Exit_tp_closet",
  game = "chex3",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_hacx =
{
  template = "Exit_tp_closet",
  game = "hacx",
  engine = "advanced"
}

PREFABS.Exit_tp_closet_hacx_nosign =
{
  template = "Exit_tp_closet",
  game = "hacx",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_heretic =
{
  template = "Exit_tp_closet",
  game = "heretic",
  engine = "advanced"
}

PREFABS.Exit_tp_closet_heretic_nosign =
{
  template = "Exit_tp_closet",
  game = "heretic",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_hexen_nosign =
{
  template = "Exit_tp_closet",
  game = "heretic",
  --engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_strife =
{
  template = "Exit_tp_closet",
  game = "strife",
  forced_offsets = 
  {
    [32] = { x=0, y=25 }
  }
}

PREFABS.Exit_tp_closet_secret =
{
  file   = "exit/armaetus_tp_closet_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, nukem=1, quake=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 1,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",

    -- this kind means "an exit to a secret level"
    kind = "secret_exit",

    -- replace normal exit special with "exit to secret" special
    line_706 = 707  
}

PREFABS.Exit_tp_closet_secret_chex3 =
{
  template = "Exit_tp_closet_secret",
  game = "chex3",
  engine = "advanced"
}

PREFABS.Exit_tp_closet_secret_chex3_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "chex3",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_secret_hacx =
{
  template = "Exit_tp_closet_secret",
  game = "hacx",
  engine = "advanced"
}

PREFABS.Exit_tp_closet_secret_hacx_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "hacx",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_secret_heretic =
{
  template = "Exit_tp_closet_secret",
  game = "heretic",
  engine = "advanced"
}

PREFABS.Exit_tp_closet_secret_heretic_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "heretic",
  engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_secret_hexen_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "heretic",
  --engine = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_secret_strife =
{
  template = "Exit_tp_closet_secret",
  game = "strife",
  forced_offsets = 
  {
    [32] = { x=0, y=25 }
  }
}
