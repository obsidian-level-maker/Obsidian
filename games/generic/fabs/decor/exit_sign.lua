--
-- A tiny exit sign (on the floor)
--

PREFABS.Decor_exit_sign =
{
  file   = "decor/exit_sign.wad",
  map    = "MAP01",

  group  = "exit_sign",
  prob   = 80,

  where  = "point",
  sink_mode = "never",
  on_liquids = "never"

}

PREFABS.Decor_exit_sign_strife =
{
  file   = "decor/exit_sign.wad",
  map    = "MAP01",

  group  = "exit_sign",
  prob   = 80,

  where  = "point",
  sink_mode = "never",
  on_liquids = "never",

  forced_offsets = 
  {
    [6] = { x=0, y=11 }
  }

}

