--
--  Techy exit pillar
--

PREFABS.Exit_pillar2 =
{
  file  = "exit/pillar2.wad"

  prob  = 100
  theme = "tech"

  where = "point"
}


PREFABS.Exit_pillar2_hell =
{
  template = "Exit_pillar2"

  prob  = 100
  theme = "!tech"

  tex_SW1STRTN = "SW2GARG"
}


PREFABS.Exit_pillar2_urban =
{
  template = "Exit_pillar2"

  prob  = 500
  theme = "urban"

  tex_SW1STRTN = "SW1CMT"
  flat_CEIL5_2 = "FLAT8"
}


PREFABS.Exit_pillar2_secret =
{
  template = "Exit_pillar2"

  -- this kind means "an exit to a secret level"
  kind = "secret_exit"

  theme = "any"

  -- replace normal exit special with "exit to secret" special
  line_11 = 51

  tex_SW1STRTN = "SW1HOT"
}

