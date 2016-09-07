--
--  Exit pillar
--

PREFABS.Exit_pillar1 =
{
  file   = "exit/pillar1.wad"

  prob   = 2

  where  = "point"

  height = 144
}


PREFABS.Exit_pillar1_secret =
{
  template = "Exit_pillar1"

  kind = "secret_exit"

  --FIXME: hack to allow usage even under low ceilings
  height = 16

  -- replace normal exit special with "exit to secret" special
  line_11 = 51

  tex_SW1SKULL = "SW1SKIN"
  flat_CEIL5_1 = "SW1SKIN"
}

