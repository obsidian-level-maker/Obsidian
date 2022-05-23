--
--  Secret closet for a secret exit
--

PREFABS.Exit_secret_box1 =
{
  file  = "exit/secret_box.wad",

  prob  = 100,
  game  = "heretic",

  -- the kind means "an exit to a secret level",
  -- the key  means "a closet which is hidden in the room",
  kind  = "secret_exit",
  key   = "secret",

  where  = "seeds",
  seed_w = 1,
  seed_h = 1,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Exit_secret_box1_chex3 = 
{
  template = "Exit_secret_box1",

  game = { chex3=1, doom1=1, doom2=1, nukem=1, quake=1,  }, -- First made for Chex 3, but happens to work for Doom 1/2
  forced_offsets = 
  {
    [16] = { x=0,y=-64 },
    [17] = { x=-4,y=-64 },
    [18] = { x=0,y=-64 },    
  }
}

PREFABS.Exit_secret_box1_hacx = 
{
  template = "Exit_secret_box1",

  game = "hacx",
  forced_offsets = 
  {
    [16] = { x=64,y=-63 },
    [17] = { x=64,y=-63 },
    [18] = { x=64,y=-63 },    
  }
}

PREFABS.Exit_secret_box1_harmony = 
{
  template = "Exit_secret_box1",

  game = "harmony",
  forced_offsets = 
  {
    [16] = { x=0,y=-64 },
    [17] = { x=16,y=-67 },
    [18] = { x=0,y=-64 },    
  }
}

PREFABS.Exit_secret_box1_hexen = 
{
  template = "Exit_secret_box1",

  game = "hexen",
}

PREFABS.Exit_secret_box1_strife = 
{
  template = "Exit_secret_box1",

  game = "strife",
  forced_offsets = 
  {
    [16] = { x=0,y=-86 },
    [17] = { x=0,y=-86 },
    [18] = { x=0,y=-86 },    
  }
}

