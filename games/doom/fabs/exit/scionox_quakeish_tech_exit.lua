-- quake-inspired techbase exit slipgate

PREFABS.Exit_scionox_quakeish_tech_exit =
{
  file   = "exit/scionox_quakeish_tech_exit.wad",
  map    = "MAP01",

  prob   = 200,

  theme = "tech",

  where  = "seeds",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  start_fab_peer = {
    "Start_scionox_quakeish_tech_start",
    "Start_scionox_quakeish_tech_start_2",
  },

  x_fit  = "frame",
  y_fit  = "top",
}
