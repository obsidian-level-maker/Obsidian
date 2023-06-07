PREFABS.Pic_gtd_hospital_cross =
{
  file = "picture/gtd_pic_hospital_set.wad",
  map = "MAP01",

  prob   = 50,

  texture_pack = "armaetus",
  group = "dem_wall_hospital",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top"
}

PREFABS.Pic_gtd_hospital_light =
{
  template = "Pic_gtd_hospital_cross",
  map = "MAP02"
}
