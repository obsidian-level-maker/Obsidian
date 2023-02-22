PREFABS.Pic_armaetus_double_fans =
{
  file = "picture/armaetus_pic_fans.wad",
  map = "MAP01",

  prob = 25,
  env = "building",
  theme = "!hell",

  texture_pack = "armaetus",

  where = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  bound_z1 = 0,
  bound_z2 = 128,

  deep = 16,
  over = -16,

  x_fit = "frame",
  y_fit = "top",

  sound = "Indoor_Fan",
}

PREFABS.Pic_armaetus_double_fans_hell =
{
  template = "Pic_armaetus_double_fans",

  prob = 5,
  theme = "hell",

  tex_DOORSTOP = "METAL",
}

--

PREFABS.Pic_arm_gtd_vented_fan =
{
  template = "Pic_armaetus_double_fans",
  map = "MAP02",

  prob = 15,

  env = "!cave",

  x_fit = { 148,160 },
  z_fit = { 48,56 },
}

PREFABS.Pic_arm_gtd_vented_fan_double =
{
  template = "Pic_armaetus_double_fans",
  map = "MAP03",

  prob = 15,

  env = "!cave",

  x_fit = { 104,120 },
  z_fit = "top",
}
