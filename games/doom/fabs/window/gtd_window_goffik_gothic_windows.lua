PREFABS.Window_goffik_1 =
{
  file   = "window/gtd_window_goffik_gothic_windows.wad",
  map    = "MAP01",

  group  = "gtd_window_goffik",
  prob   = 50,

  where  = "edge",
  seed_w = 1,

  height = 128,
  deep   = 16,
  over   = 16,

  z_fit = { 80,88 },

  bound_z1 = 0,
  bound_z2 = 128,

  tex_EVILFAC4 =
  {
    EVILFAC4 = 1,
    EVILFAC5 = 1,
    EVILFAC6 = 1,
    EVILFAC7 = 1,
    EVILFAC8 = 1,
    EVILFAC9 = 1,
    EVILFACA = 1,
  },
}

PREFABS.Window_goffik_2 =
{
  template = "Window_goffik_1",
  map      = "MAP02",

  seed_w   = 2,
}

PREFABS.Window_goffik_3 =
{
  template = "Window_goffik_1",
  map      = "MAP03",

  seed_w   = 3,
}

-- yellow/orange variant

PREFABS.Window_goffik_1_gold =
{
  template = "Window_goffik_1",
  map = "MAP01",

  group = "gtd_window_goffik_gold",

  flat_FLOOR1_6 = "ORANFLOR",
  tex_COMPRED = "COMPYELL",
  tex_COMPTIL2 = "COMPTIL5",
  tex_RDLITE01 = "COLLITE2",
}

PREFABS.Window_goffik_2_gold =
{
  template = "Window_goffik_1",
  map = "MAP02",

  group = "gtd_window_goffik_gold",

  seed_w = 2,

  flat_FLOOR1_6 = "ORANFLOR",
  tex_COMPRED = "COMPYELL",
  tex_COMPTIL2 = "COMPTIL5",
  tex_RDLITE01 = "COLLITE2",
}

PREFABS.Window_goffik_3_gold =
{
  template = "Window_goffik_1",
  map = "MAP03",

  group = "gtd_window_goffik_gold",

  seed_w = 3,

  flat_FLOOR1_6 = "ORANFLOR",
  tex_COMPRED = "COMPYELL",
  tex_COMPTIL2 = "COMPTIL5",
  tex_RDLITE01 = "COLLITE2",
}
