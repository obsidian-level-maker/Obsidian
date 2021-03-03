PREFABS.Exit_armaetus_fans_exit =
{
  file   = "exit/armaetus_fans_exit.wad",
  map    = "MAP01",

  prob   = 125,

  theme = "tech",

  where  = "seeds",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 2,

  deep   = 16,

  x_fit  = "frame",
  y_fit  = "top",

  tex_SW1BLUE =
  {
    SW1BLUE=50, SW1BRN2=50, SW1BRNGN=50,
    SW1COMP=50, SW1METAL=50, SW1STON1=50,
    SW1STRTN=50, SW1SLAD=30, SW1GRAY=50,
    SW1GRAY1=50,
  },

  sound = "Indoor_Fan",
}

PREFABS.Exit_armaetus_fans_exit_urban =
{
  template   = "Exit_armaetus_fans_exit",

  theme = "urban",

  flat_CEIL4_2 = "FLAT5_1", -- Feel free to expand this

  tex_SW1BLUE =
  {
    SW1GOTH=20, SW1QUAK=20, SW1BRN2=50,
    SW1BRNGN=50, SW1METAL=50, SW1STON1=50,
    SW1LION=50, SW1GARG=50, SW1SATYR=50,
    SW1SLAD=30, SW1WOOD=50,
  }
}

PREFABS.Exit_armaetus_fans_exit_hell =
{
  template   = "Exit_armaetus_fans_exit",

  theme = "hell",

  flat_CEIL4_2 = "DEM1_6", -- Feel free to expand this

  tex_SW1BLUE =
  {
    SW1GOTH=70, SW1QUAK=70, SW1METAL=50,
    SW1STON1=50, SW1LION=50, SW1GARG=50,
    SW1SATYR=50, SW1SKIN=50, SW1SKULL=50,
    SW1WOOD=50, SW1GSTON=50, SW1HOT=30,
  }
}
