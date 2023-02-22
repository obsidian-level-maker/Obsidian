PREFABS.Pic_gtd_DMV_counter_shuttered =
{
  file = "picture/gtd_pic_industrial_DMV_set.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_DMV_set",

  where  = "seeds",
  height = 96,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = {56,60 , 116,120},
  y_fit = "top"
}

PREFABS.Pic_gtd_DMV_counter_triple =
{
  template = "Pic_gtd_DMV_counter_shuttered",
  map = "MAP02",

  x_fit = "frame"
}

PREFABS.Pic_gtd_DMV_counter_semi_open =
{
  template = "Pic_gtd_DMV_counter_shuttered",
  map = "MAP03",

  x_fit = {52,76 , 116,140}
}
