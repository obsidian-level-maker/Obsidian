--
-- Exit closet
--

PREFABS.Exit_closet3 =
{
  file  = "exit/closet3.wad",
  map   = "MAP01",

  prob  = 50, --20,
  theme = "!tech",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",

  sector_1  = { [0]=70, [1]=15 },

  tex_SW1HOT = { SW1HOT=50, SW1GSTON=50 },

  sector_8  = { [8]=50, [1]=15, [0]=10, [12]=5, [13]=5 }

}

PREFABS.Exit_closet3_bodies =
{
  file  = "exit/closet3.wad",

  map   = "MAP02",
  prob  = 50,
  theme = "!tech",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",

  sector_1  = { [0]=70, [1]=15 },

  tex_SW1SKULL = { SW1SKULL=50, SW2SKULL=50 },

  sector_8  = { [8]=50, [1]=15, [0]=10, [12]=5, [13]=5 }

}

