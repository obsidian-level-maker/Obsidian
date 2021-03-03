PREFABS.Pic_control_room =
{
  file   = "picture/gtd_pic_tech_controlroom.wad",
  map    = "MAP01",

  prob   = 75,
  theme = "tech",

  env = "building",

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

  sector_1  = { [0]=70, [1]=20, [2]=5, [3]=5, [8]=10 },

  sound = "Computer_Station",
}

PREFABS.Pic_control_room_small_monitors =
{
  template = "Pic_control_room",

  tex_SILVER3 = "COMPSPAN",
  tex_COMPSTA1 = "SPACEW3",
  tex_COMPSTA2 = "SPACEW3",
}

PREFABS.Pic_control_room_sideways_double =
{
  template = "Pic_control_room",
  map = "MAP02",
}

PREFABS.Pic_control_room_sideways_single =
{
  template = "Pic_control_room",
  map = "MAP03",

  prob = 25,

  seed_w = 2,
}

PREFABS.Pic_control_room_infested =
{
  template = "Pic_control_room",
  map = "MAP04",

  skip_prob = 65,

  sector_1 = 1,
}
