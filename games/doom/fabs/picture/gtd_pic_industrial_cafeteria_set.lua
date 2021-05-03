-- reuses some fabs

PREFABS.Pic_industrial_cafeteria_vending_machines_2 =
{
  template = "Pic_inset_vending_machines",

  prob = 5,

  group = "gtd_wall_cafeteria_set"
}

PREFABS.Pic_industrial_cafeteria_w_chair =
{
  template = "Pic_inset_vending_machines",
  map = "MAP02",

  prob = 10,

  group = "gtd_wall_cafeteria_set"
}

PREFABS.Pic_industrial_cafeteria_kitchen =
{
  file = "picture/gtd_pic_urban_commercial_frontages.wad",
  map = "MAP02",

  prob = 10,

  where = "seeds",
  height = 128,

  group = "gtd_wall_cafeteria_set",

  seed_w = 3,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep =  16,
  over = -16,

  x_fit = "frame",
  y_fit = "top"
}
