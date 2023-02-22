PREFABS.Pic_gtd_air_vent =
{
  file = "picture/gtd_pic_industrial_air_vents_set_EPIC.wad",
  map = "MAP01",

  prob = 25,

  group = "gtd_wall_air_vents",

  where  = "seeds",
  height = 96,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = "frame",
  y_fit = "top",
  z_fit = { 82,86 }
}

PREFABS.Pic_gtd_air_vent_stretchy =
{
  template = "Pic_gtd_air_vent",

  prob = 25,

  x_fit = { 72,84 }
}

PREFABS.Pic_gtd_air_vent_vertical =
{
  template = "Pic_gtd_air_vent",
  map = "MAP02",

  prob = 50,

  x_fit = { 100,156 }, 
  z_fit = { 82,86 }
}
