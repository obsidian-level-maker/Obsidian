--
-- Simple start closet (with door)
--

PREFABS.Start_closet1 =
{
  file  = "start/closet1.wad",
  map   = "MAP01",

  game = "!chex3",

  prob  = 80,

  where = "seeds",
  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Start_closet1_chex3 =
{
  file  = "start/closet1.wad",
  map   = "MAP01",

  game = "chex3",

  prob  = 80,

  where = "seeds",
  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  forced_offsets = 
  { 
    [10] = {x=49,y=95},
    [11] = {x=49,y=95},
    [14] = {x=49,y=95},
    [15] = {x=49,y=95}  
  }

}


