--
--  Secret exit pillar
--

PREFABS.Exit_pillar1_secret =
{
  file   = "exit/pillar1.wad",
  map    = "MAP01",

  kind   = "secret_exit",
  where  = "point",
  height = 144,

  prob   = 0,

  -- replace normal exit special with "exit to secret" special
  line_11 = 51,
}

