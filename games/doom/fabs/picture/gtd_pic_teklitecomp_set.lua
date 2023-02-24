PREFABS.Pic_gtd_teklite_red =
{
  file = "picture/gtd_pic_teklitecomp_set.wad",
  map = "MAP01",

  prob   = 50,

  texture_pack = "armaetus",
  group = "gtd_wall_teklitecomp_red",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 100,156 },
  y_fit = "top",
  z_fit = { 68,84 },
}

-- orange
PREFABS.Pic_gtd_teklite_orange =
{
  template = "Pic_gtd_teklite_red",

  group = "gtd_wall_teklitecomp_orange",

  flat_TEK1 = "TEK7",
  tex_RDWAL01 = "COLLITE2",
  tex_TEKWALL8 = "TEKWALLE",
  tex_COMPRED = "COMPGREN",
}

-- blue
PREFABS.Pic_gtd_teklite_blue =
{
  template = "Pic_gtd_teklite_red",

  group = "gtd_wall_teklitecomp_blue",

  flat_TEK1 = "TEK6",
  tex_RDWAL01 = "COLLITE3",
  tex_TEKWALL8 = "TEKWALLB",
  tex_COMPRED = "COMPBLUE",
}
