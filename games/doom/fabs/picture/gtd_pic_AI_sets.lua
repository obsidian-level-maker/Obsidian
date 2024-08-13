PREFABS.Pic_goth_comp_yellow_stained_glass =
{
  file   = "picture/gtd_pic_AI_sets.wad",
  map    = "MAP01",

  prob   = 50,
  group = "gtd_AI_goth_comp_yellow_stained_glass",

  texture_pack = "armaetus",

  seed_w = 2,
  seed_h = 1,

  where  = "seeds",
  deep   = 16,

  height = 128,

  x_fit  = {104,108 , 148,152},
  y_fit  = "top",
  z_fit  = {53,95},

  bound_z1 = 0,
  bound_z2 = 128
}

PREFABS.Pic_goth_comp_yellow_stained_glass_3x =
{
  template = "Pic_goth_comp_yellow_stained_glass",
  map      = "MAP02",

  rank = 2,

  seed_w = 3,

  x_fit = { 84,108 , 276,300 }
}

--

PREFABS.Pic_AI_boiler_room_pipes =
{
  template = "Pic_goth_comp_yellow_stained_glass",
  map = "MAP10",

  group = "gtd_AI_boiler_room",

  x_fit  = "frame",
  y_fit  = "top",
  z_fit  = {39,41 , 79,81}
}
