--Based on gtd_pic_rooftop_stuff
PREFABS.Item_rooftop_secret =
{
  file   = "item/scionox_gtd_pic_rooftop_stuff_secret.wad",
  map    = "MAP02",

  prob   = 50,
  theme  = "!hell",
  env    = "!cave",
  key    = "secret",

  where  = "seeds",
  height = 128,

  seed_w = 4,
  seed_h = 2,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",

  sound = "Water_Tank",
}

PREFABS.Item_rooftop_secret_2 =
{
  template = "Item_rooftop_secret",
  map      = "MAP01",
  engine   = "zdoom",
  seed_h = 1,

  sound = "Machine_Ventilation",
}

PREFABS.Item_rooftop_secret_3 =
{
  template = "Item_rooftop_secret",
  map      = "MAP03",
  seed_w = 3,
  seed_h = 1,

  sound = "Machine_Air",
}
