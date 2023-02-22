PREFABS.Start_generic_immersive_start =
{
  file = "start/gtd_generic_immersive_start.wad",
  map = "MAP01",

  prob = 500, --1500,
  theme = "tech",

  where = "seeds",

  seed_h = 2,
  seed_w = 2,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",
}

PREFABS.Start_generic_immersive_start_urban =
{
  template = "Start_generic_immersive_start",

  map = "MAP02",

  theme = "urban",
}
