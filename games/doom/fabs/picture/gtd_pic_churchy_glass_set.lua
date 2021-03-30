PREFABS.Pic_church_glass_triple =
{
  file = "picture/gtd_pic_churchy_glass_set.wad",
  map = "MAP01",

  prob = 100,

  group = "gtd_wall_churchy_glass",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 108,148 },
  z_fit = { 60,68 }
}

PREFABS.Pic_church_glass_single =
{
  template = "Pic_church_glass_triple",
  map = "MAP02",

  x_fit = { 72,184 }
}
