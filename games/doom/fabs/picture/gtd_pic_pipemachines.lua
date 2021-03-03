PREFABS.Pic_heatant_coolant_1 =
{
  file   = "picture/gtd_pic_pipemachines.wad",
  map    = "MAP01",

  prob   = 25,
  theme = "!hell",

  engine = "zdoom",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 2,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = {68,72 , 84,92 , 104,108},
  y_fit = "top",
}

PREFABS.Pic_heatant_coolant_2 =
{
  template = "Pic_heatant_coolant_1",
  map = "MAP02",

  engine = "zdoom",

  prob = 25,

  x_fit = {36,84 , 172,220},
  y_fit = "top",
}

PREFABS.Pic_wire_spools =
{
  template = "Pic_heatant_coolant_1",
  map = "MAP03",

  engine = "zdoom",

  prob = 25,

  x_fit = {32,36},
  y_fit = "top",
}
