--
--  Techy exit pillar
--

PREFABS.Exit_pillar2 =
{
  file  = "exit/pillar2.wad"
  where = "point"

  theme = "tech"
  prob  = 100
}


PREFABS.Exit_pillar2_secret =
{
  template = "Exit_pillar2"

  key = "secret"
  line_11 = 51

  tex_SW1STRTN = "SW1HOT"
}


PREFABS.Exit_pillar2_urban =
{
  file  = "exit/pillar2.wad"
  where = "point"

  theme = "urban"
  prob  = 50

  tex_SW1STRTN = "SW1CMT"
  flat_CEIL5_2 = "FLAT8"
}

