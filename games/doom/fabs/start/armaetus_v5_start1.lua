PREFABS.Start_armaetus_v5_start1 =
{
  file  = "start/armaetus_v5_start1.wad",
  map   = "MAP01",

  prob  = 500, --1500,
  theme = "tech",

  where = "seeds",

  seed_h = 2,
  seed_w = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",

  thing_55 =
  {
    lamp = 50,
    mercury_lamp = 50,
    mercury_small = 50,
  },
}

PREFABS.Start_armaetus_v5_start1_urban =
{
  template = "Start_armaetus_v5_start1",
  map = "MAP01",

  theme = "urban",

  thing_55 =
  {
    lamp = 50,
    mercury_lamp = 50,
    mercury_small = 50,
    candelabra = 50,
    burning_barrel = 50,
  },
}

PREFABS.Start_armaetus_v5_start1_hell =
{
  template = "Start_armaetus_v5_start1",
  map = "MAP01",

  theme = "hell",

  thing_55 =
  {
    blue_torch     = 50,
    blue_torch_sm  = 50,
    green_torch    = 50,
    green_torch_sm = 50,
    red_torch      = 50,
    red_torch_sm   = 50,
  },
}
