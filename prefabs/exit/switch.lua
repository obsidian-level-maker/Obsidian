--
--  Exit switch
--

PREFABS.Exit_switch1 =
{
  file   = "exit/switch.wad"

  prob   = 200
  theme  = "!hell"

  where  = "point"
  size   = 128
}


PREFABS.Exit_switch1_secret =
{
  template = "Exit_switch1"

  -- this kind means "an exit to a secret level"
  kind  = "secret_exit"

  -- replace normal exit special with "exit to secret" special
  line_11 = 51

  tex_SW1BRNGN = "SW1HOT"
}

