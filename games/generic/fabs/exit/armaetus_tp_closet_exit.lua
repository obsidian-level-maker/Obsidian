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
  port = "advanced"
}

PREFABS.Exit_tp_closet_chex3_nosign =
{
  template = "Exit_tp_closet",
  game = "chex3",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_hacx =
{
  template = "Exit_tp_closet",
  game = "hacx",
  port = "advanced"
}

PREFABS.Exit_tp_closet_hacx_nosign =
{
  template = "Exit_tp_closet",
  game = "hacx",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_heretic =
{
  template = "Exit_tp_closet",
  game = "heretic",
  port = "advanced"
}

PREFABS.Exit_tp_closet_heretic_nosign =
{
  template = "Exit_tp_closet",
  game = "heretic",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_tp_closet_hexen_nosign =
{
  template = "Exit_tp_closet",
  game = "heretic",
  --port = "!advanced",
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
}

PREFABS.Exit_tp_closet_secret_chex3 =
{
  template = "Exit_tp_closet_secret",
  game = "chex3",
  port = "advanced"
}

PREFABS.Exit_tp_closet_secret_chex3_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "chex3",
  port = "!advanced",
  map = "MAP04"
}

PREFABS.Exit_tp_closet_secret_hacx =
{
  template = "Exit_tp_closet_secret",
  game = "hacx",
  port = "advanced"
}

PREFABS.Exit_tp_closet_secret_hacx_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "hacx",
  port = "!advanced",
  map = "MAP04"
}

PREFABS.Exit_tp_closet_secret_heretic =
{
  template = "Exit_tp_closet_secret",
  game = "heretic",
  port = "advanced"
}

PREFABS.Exit_tp_closet_secret_heretic_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "heretic",
  port = "!advanced",
  map = "MAP04"
}

PREFABS.Exit_tp_closet_secret_hexen_nosign =
{
  template = "Exit_tp_closet_secret",
  game = "heretic",
  --port = "!advanced",
  map = "MAP04"
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
