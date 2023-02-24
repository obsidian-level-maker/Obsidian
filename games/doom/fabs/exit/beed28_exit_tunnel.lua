--
-- Exit tunnel
--

PREFABS.Exit_beed28_tunnel =
{
  file  = "exit/beed28_exit_tunnel.wad",

  prob  = 250,
  theme = "!hell",

  where  = "seeds",
  seed_w = 1,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",

  start_fab_peer = "Start_beed28_tunnel",

  thing_45 =
  {
   mercury_lamp = 50,
   mercury_small = 50,
   lamp = 50,
  }
}

PREFABS.Exit_beed28_tunnel_hell =
{
  template = "Exit_beed28_tunnel",

  map = "MAP02",

  theme = "hell",

  start_fab_peer = "Start_beed28_tunnel_hell",

  thing_45 =
  {
   blue_torch = 50,
   green_torch = 50,
   red_torch = 50,
   candelabra = 50,
  }
}
