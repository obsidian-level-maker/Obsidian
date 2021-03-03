PREFABS.Pic_gtd_tech_server_console =
{
  file   = "picture/gtd_pic_tech_server_room.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_server_room",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  y_fit = "top",
  z_fit = { 112,120 },
}

PREFABS.Pic_gtd_tech_server_big_monitor =
{
  template = "Pic_gtd_tech_server_console",
  map = "MAP02",

  texture_pack = "armaetus",

  tex_COMPCT01 =
  {
    COMPCT02 = 1,
    COMPCT03 = 1,
    COMPCT04 = 1,
    COMPCT05 = 1,
    COMPCT06 = 1,
  },

  z_fit = "top",
}

PREFABS.Pic_gtd_tech_server_CPU_banks =
{
  template = "Pic_gtd_tech_server_console",
  map = "MAP03",

  texture_pack = "armaetus",

  z_fit = "top",
}
