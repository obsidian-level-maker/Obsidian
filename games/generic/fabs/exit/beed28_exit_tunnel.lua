--
-- Exit tunnel
--

PREFABS.Exit_beed28_tunnel =
{
  file  = "exit/beed28_exit_tunnel.wad",
  map   = "MAP01",
  prob  = 250,
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, strife=0 },

  where  = "seeds",
  seed_w = 1,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",

  start_fab_peer = "Start_beed28_tunnel",
}

PREFABS.Exit_beed28_tunnel_chex3 = 
{
  template = "Exit_beed28_tunnel",
  game = "chex3",
  map = "MAP02"
}

PREFABS.Exit_beed28_tunnel_hacx = 
{
  template = "Exit_beed28_tunnel",
  game = "hacx",
  forced_offsets = 
  {
    [20] = { x=0, y=95 }
  }
}

PREFABS.Exit_beed28_tunnel_harmony = 
{
  template = "Exit_beed28_tunnel",
  game = "harmony",
  forced_offsets = 
  {
    [20] = { x=16, y=79 }
  }
}

PREFABS.Exit_beed28_tunnel_heretic = 
{
  template = "Exit_beed28_tunnel",
  game = "heretic",
  forced_offsets = 
  {
    [20] = { x=16, y=50 }
  }
}

PREFABS.Exit_beed28_tunnel_strife = 
{
  template = "Exit_beed28_tunnel",
  game = "strife",
  forced_offsets = 
  {
    [20] = { x=0, y=66 }
  }
}