--
-- Exit closet
--

PREFABS.Exit_closet1 =
{
  file   = "exit/closet1.wad",
  map    = "MAP01",

  game   = "!chex3",

  prob   = 100,

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep   =  16,
  over   = -16,

  x_fit  = "frame",
  y_fit  = "top",
}

PREFABS.Exit_closet1_chex =
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
    [21] = {x=42,y=32}
  }

}


----------------------------------------------------------------------

PREFABS.Exit_closet1_secret =
{
  template = "Exit_closet1",

  game = "!chex3",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

PREFABS.Exit_closet1_secret_chex =
{
  template = "Exit_closet1",

  game = "chex3",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,

  forced_offsets = 
  {
    [21] = {x=42,y=32}
  }
  
}
