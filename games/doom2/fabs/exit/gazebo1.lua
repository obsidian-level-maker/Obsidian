--
-- Exit gazebo
--

PREFABS.Exit_gazebo1 =
{
  file   = "exit/gazebo1.wad",
  map    = "MAP01",

  rank   = 2,
  prob   = 100, --100,

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  env    = "outdoor",
  height = 192,

  open_to_sky = true,

  x_fit  = "frame",
}


------- Exit-to-Secret ---------------------------


UNFINISHED.Exit_gazebo1_secret =
{
  template = "Exit_gazebo1",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,

  tex_SW1BLUE  = "SW1HOT",
  tex_COMPBLUE = "REDWALL",
}

