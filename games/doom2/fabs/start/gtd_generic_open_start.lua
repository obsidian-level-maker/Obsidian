PREFABS.Start_generic_open =
{
  file  = "start/gtd_generic_open_start.wad",
  map   = "MAP01",

  theme = "!hell",

  prob  = 500, --1500,

  height = 96,

  where = "seeds",

  seed_w = 2,
  seed_h = 2,

  deep  =  16,
  over  = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Start_generic_open_hell =
{
  template = "Start_generic_open",

  map = "MAP02",

  theme = "hell",

  flat_GATE3 = { GATE1=50, GATE2=50, GATE3=70 },

}
