--
-- Simple start closet (with door)
--

PREFABS.Start_closet1 =
{
  file  = "start/closet1.wad",
  map   = "MAP01",

  game = { chex3=0, doom1=1, doom2=1, hacx=1, harmony=0, heretic=1, hexen=1, strife=1 },

  prob  = 80,

  where = "seeds",
  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Start_closet1_chex3 =
{
  template  = "Start_closet1",

  game = "chex3",

  forced_offsets = 
  { 
    [10] = { x=49, y=95 },
    [11] = { x=49, y=95 },
    [14] = { x=49, y=95 },
    [15] = { x=49, y=95 }  
  }

}

PREFABS.Start_closet1_harmony =
{
  template  = "Start_closet1",

  game = "harmony",

  forced_offsets = 
  { 
    [10] = { x=0, y=-56 },
    [11] = { x=0, y=-56 },
    [14] = { x=0, y=-56 },
    [15] = { x=0, y=-56 },  
  }

}


