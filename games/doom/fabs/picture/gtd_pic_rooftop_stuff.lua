PREFABS.Pic_HVAC_unit =
{
  file   = "picture/gtd_pic_rooftop_stuff.wad",
  map    = "MAP01",

  prob   = 25, --35,
  theme = "!hell",

  env   = "!cave",

  where  = "seeds",
  height = 128,

  seed_w = 3,
  seed_h = 1,

  deep = 16,
  over = -16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  sound = "Machine_Ventilation",
}

PREFABS.Pic_HVAC_unit_outdoor =
{
  template = "Pic_HVAC_unit",

  prob = 150,

  env = "outdoor",

  open_to_sky = 1,
}

PREFABS.Pic_septic_tank =
{
  template = "Pic_HVAC_unit",
  map = "MAP02",

  sound = "Water_Tank",
}

PREFABS.Pic_air_filter =
{
  template = "Pic_HVAC_unit",
  map = "MAP03",

  sound = "Machine_Ventilation",
}
