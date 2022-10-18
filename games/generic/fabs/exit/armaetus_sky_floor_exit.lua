PREFABS.Exit_sky_floor_exit =
{
  file   = "exit/armaetus_sky_floor_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, nukem=1, quake=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_sky_floor_exit_strife =
{
  template = "Exit_sky_floor_exit",
  game = "strife",
  forced_offsets = 
  {
    [32] = { x=0, y=25 }
  }
}

PREFABS.Exit_sky_floor_exit_chex3 = 
{
  template = "Exit_sky_floor_exit",
  game = "chex3",
  port = "advanced"
}

PREFABS.Exit_sky_floor_exit_chex3_nosign = 
{
  template = "Exit_sky_floor_exit",
  game = "chex3",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_hacx = 
{
  template = "Exit_sky_floor_exit",
  game = "hacx",
  port = "advanced"
}

PREFABS.Exit_sky_floor_exit_hacx_nosign = 
{
  template = "Exit_sky_floor_exit",
  game = "hacx",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_heretic = 
{
  template = "Exit_sky_floor_exit",
  game = "heretic",
  port = "advanced"
}

PREFABS.Exit_sky_floor_exit_heretic_nosign = 
{
  template = "Exit_sky_floor_exit",
  game = "heretic",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_hexen_nosign = 
{
  template = "Exit_sky_floor_exit",
  game = "hexen",
  --port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_secret =
{
  file   = "exit/armaetus_sky_floor_exit.wad",
  map    = "MAP01",
  game   = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=1, heretic=0, nukem=1, quake=1, strife=0 },

  prob   = 300,

  where  = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",

    -- this kind means "an exit to a secret level"
    kind = "secret_exit",

    -- replace normal exit special with "exit to secret" special
    line_706 = 707
}

PREFABS.Exit_sky_floor_exit_secret_strife =
{
  template = "Exit_sky_floor_exit_secret",
  game = "strife",
  forced_offsets = 
  {
    [32] = { x=0, y=25 }
  }
}

PREFABS.Exit_sky_floor_exit_secret_chex3 = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "chex3",
  port = "advanced"
}

PREFABS.Exit_sky_floor_exit_secret_chex3_nosign = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "chex3",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_secret_hacx = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "hacx",
  port = "advanced"
}

PREFABS.Exit_sky_floor_exit_secret_hacx_nosign = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "hacx",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_secret_heretic = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "heretic",
  port = "advanced"
}

PREFABS.Exit_sky_floor_exit_secret_heretic_nosign = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "heretic",
  port = "!advanced",
  map = "MAP02"
}

PREFABS.Exit_sky_floor_exit_secret_hexen_nosign = 
{
  template = "Exit_sky_floor_exit_secret",
  game = "hexen",
  --port = "!advanced",
  map = "MAP02"
}
