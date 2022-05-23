--
-- Exit tunnel
--

PREFABS.Exit_beed28tunnel =
{
  file  = "exit/beed28_exit_tunnel.wad",
  map   = "MAP01",
  prob  = 250,
  game = { chex3=0, doom1=1, doom2=1, hacx=0, harmony=0, heretic=0, nukem=1, quake=1, strife=0 },

  where  = "seeds",
  seed_w = 1,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",

  start_fab_peer = "Start_beed28tunnel",
}

PREFABS.Exit_beed28tunnel_chex3 = 
{
  template = "Exit_beed28tunnel",
  game = "chex3",
  map = "MAP02",

  start_fab_peer = "Start_beed28tunnel_chex3"
}

PREFABS.Exit_beed28tunnel_hacx = 
{
  template = "Exit_beed28tunnel",
  game = "hacx",
  forced_offsets = 
  {
    [20] = { x=0, y=95 }
  },

  start_fab_peer = "Start_beed28tunnel_hacx"
}

PREFABS.Exit_beed28tunnel_harmony = 
{
  template = "Exit_beed28tunnel",
  game = "harmony",
  forced_offsets = 
  {
    [20] = { x=16, y=79 }
  },

  start_fab_peer = "Start_beed28tunnel_harmony"
}

PREFABS.Exit_beed28tunnel_heretic = 
{
  template = "Exit_beed28tunnel",
  game = "heretic",
  forced_offsets = 
  {
    [20] = { x=16, y=50 }
  },

  start_fab_peer = "Start_beed28tunnel_heretic"
}

PREFABS.Exit_beed28tunnel_hexen = 
{
  template = "Exit_beed28tunnel",
  game = "hexen",
  forced_offsets = 
  {
    [20] = { x=0, y=0 }
  },

  start_fab_peer = "Start_beed28tunnel_hexen"
}

PREFABS.Exit_beed28tunnel_strife = 
{
  template = "Exit_beed28tunnel",
  game = "strife",
  forced_offsets = 
  {
    [20] = { x=0, y=66 }
  },

  start_fab_peer = "Start_beed28tunnel_strife"
}