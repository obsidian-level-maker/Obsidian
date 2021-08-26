PREFABS.Start_beed28_fireblu_exit =
{
  file  = "start/beed28_fireblu_start.wad",

  prob  = 250,
  theme = "!tech",

  where  = "seeds",
  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",

  thing_46 =
  {
    blue_torch = 50,
    blue_torch_sm = 50,
    red_torch = 50,
    red_torch_sm = 50,
    green_torch = 50,
    green_torch_sm = 50,
    candelabra = 50,
  }
}

PREFABS.Start_beed28_fireblu_exit_tech =
{
  template = "Start_beed28_fireblu_exit",

  prob = 250,
  theme = "tech",

  thing_46 =
  {
    lamp = 50,
    mercury_lamp = 50,
    mercury_small = 50,
  },

  flat_MFLR8_2 = "FLAT23",
  tex_METAL = "GRAY1",
}
