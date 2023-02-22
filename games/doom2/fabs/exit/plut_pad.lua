--
-- Plutonia exit pad
--

PREFABS.Exit_plutonia =
{
  file   = "exit/plut_pad.wad",
  map    = "MAP01",

  game   = "plutonia",
  rank   = 2,
  prob   = 50,

  where  = "point",
}


PREFABS.Exit_plutonia_secret =
{
  template = "Exit_plutonia",

  kind = "secret_exit",

  -- replace normal exit special with "exit to secret" special
  line_52 = 124,
}

