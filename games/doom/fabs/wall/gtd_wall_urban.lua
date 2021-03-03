-- fake door

PREFABS.Wall_fake_door =
{
  file   = "wall/gtd_wall_urban.wad",
  map    = "MAP01",

  prob   = 20,
  theme = "urban",

  on_liquids = "never",

  on_scenics = "never",

  need_solid_back = true,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_DOOR3 =
  {
    DOOR1 = 50,
    DOOR3 = 50,
  },
}

PREFABS.Wall_fake_door_tech =
{
  template = "Wall_fake_door",

  theme = "tech",

  prob  = 2,
}

-- braceless fake door

PREFABS.Wall_fake_door_braceless =
{
  template = "Wall_fake_door",
  map      = "MAP06",

  prob     = 40,
}

PREFABS.Wall_fake_door_tech_braceless =
{
  template = "Wall_fake_door",
  map      = "MAP06",

  theme    = "tech",

  prob     = 3,
}

--

PREFABS.Wall_modern_piping =
{
  file   = "wall/gtd_wall_urban.wad",
  map    = "MAP02",

  prob   = 50,
  env   = "building",
  theme = "urban",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_METAL5 =
  {
    METAL5 = 1,
    METAL3 = 1,
    METAL4 = 1,
    TEKLITE = 1,
    LITE3 = 0.5,
    LITE5 = 0.5,
    LITEBLU1 = 0.5,
    LITEBLU4 = 1,
    TEKGREN4 = 1,
    TEKWALL1 = 0.5,
    TEKWALL4 = 0.5,
    TEKWALL6 = 0.5,
  },
}

-- shutters

PREFABS.Wall_modern_shutter =
{
  file   = "wall/gtd_wall_urban.wad",
  map    = "MAP03",

  prob   = 20,
  theme = "urban",

  on_liquids = "never",

  on_scenics = "never",

  need_solid_back = true,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_STEP4 =
  {
    STEP4 = 50,
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP5 = 50,
  },
}

PREFABS.Wall_modern_shutter_EPIC =
{
  file   = "wall/gtd_wall_urban.wad",
  map    = "MAP03",

  prob   = 20,
  theme = "urban",

  texture_pack = "armaetus",
  replaces = "Wall_modern_shutter",

  on_liquids = "never",

  on_scenics = "never",

  need_solid_back = true,

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_STEP4 =
  {
    STEP4 = 50,
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP5 = 50,
    URBAN6 = 150,
    URBAN8 = 150,
  },
}

PREFABS.Wall_modern_shutter_braceless =
{
  template = "Wall_modern_shutter",
  map      = "MAP07",

  prob     = 40,
}

PREFABS.Wall_modern_shutter_EPIC_braceless =
{
  template = "Wall_modern_shutter_EPIC",
  map      = "MAP07",

  prob     = 40,
}

PREFABS.Wall_fake_warehouse_window =
{
  file   = "wall/gtd_wall_urban.wad",
  map    = "MAP04",

  prob   = 50,
  theme = "urban",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "bottom",

  tex_LITE5 =
  {
    LITE5 = 50,
    LITE3 = 10,
    LITEBLU4 = 10,
    LITEBLU1 = 10,
    TEKBRON2 = 6,
    TEKGREN5 = 8,
    TEKLITE2 = 6,
  },
}

PREFABS.Wall_double_dark_windows =
{
  file   = "wall/gtd_wall_urban.wad",
  map    = "MAP05",

  prob   = 50,
  theme = "urban",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "bottom",

  tex_MODWALL4 =
  {
    MODWALL4 = 50,
    MODWALL3 = 50,
    BLAKWAL1 = 50,
    BLAKWAL2 = 50,
  },
}

PREFABS.Wall_wide_dark_windows =
{
  template = "Wall_double_dark_windows",
  map = "MAP08",

  z_fit = "top",

  tex_MODWALL4 = "MODWALL4",
  tex_MODWALL3 =
  {
    MODWALL3 = 50,
    MODWALL4 = 25,
    STEP1 = 3,
    STEP2 = 3,
    STEP3 = 3,
    STEP4 = 3,
    STEP5 = 3,
  },
}

PREFABS.Wall_wide_dark_windows_with_door =
{
  template = "Wall_double_dark_windows",
  map = "MAP09",

  prob = 40,

  on_liquids = "never",

  on_scenics = "never",

  z_fit = "top",

  need_solid_back = true,

  tex_MODWALL4 = "MODWALL4",
  tex_MODWALL3 =
  {
    MODWALL3 = 50,
    STEP1 = 50,
    STEP2 = 50,
    STEP3 = 50,
    STEP4 = 50,
    STEP5 = 50,
    STEPLAD1 = 50,
    SPCDOOR1 = 25,
    SPCDOOR2 = 25,
  },
}

PREFABS.Wall_holo_marquee =
{
  template = "Wall_double_dark_windows",
  map = "MAP10",

  engine = "zdoom",

  texture_pack = "armaetus",

  prob = 10,

  on_scenics = "never",

  deep = 48,

  z_fit = "top",

  tex_COMPBLUE =
  {
    COMPBLUE = 50,
    COMPGREN = 50,
    COMPRED = 50,
  },
}
