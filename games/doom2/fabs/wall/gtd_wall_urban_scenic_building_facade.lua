PREFABS.Wall_urban_scenic_building_facade =
{
  file   = "wall/gtd_wall_urban_scenic_building_facade.wad",
  map    = "MAP01",

  prob   = 250,
  skip_prob = 75,

  env = "outdoor",
  theme = "urban",

  scenic_mode = "only",
  
  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Wall_urban_scenic_building_facade_modwall3 =
{
  template = "Wall_urban_scenic_building_facade",

  tex_MODWALL2 = "MODWALL3"
}

PREFABS.Wall_urban_scenic_building_facade_modwall4 =
{
  template = "Wall_urban_scenic_building_facade",

  tex_MODWALL2 = "MODWALL4"
}

PREFABS.Wall_urban_scenic_building_facade_brwindow =
{
  template = "Wall_urban_scenic_building_facade",

  tex_MODWALL2 = "BRWINDOW"
}

-- the first four entries of the following are just copies
-- of the above vanilla-textured fabs but with different
-- probabilities set in order to compensate for the extra
-- texture variations

PREFABS.Wall_urban_scenic_building_facade_modwall_EPIC =
{
  file   = "wall/gtd_wall_urban_scenic_building_facade.wad",
  map    = "MAP01",

  prob   = 250,
  skip_prob = 92,

  env = "outdoor",
  theme = "urban",

  texture_pack = "armaetus",
  replaces = "Wall_urban_scenic_building_facade",

  scenic_mode = "only",
  
  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit = "top"
}

PREFABS.Wall_urban_scenic_building_facade_modwall3_EPIC = 
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "MODWALL3"
}

PREFABS.Wall_urban_scenic_building_facade_modwall4_EPIC =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "MODWALL4"
}

PREFABS.Wall_urban_scenic_building_facade_brwindow_EPIC =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "BRWINDOW"
}

PREFABS.Wall_urban_scenic_building_facade_city01 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY01"
}

PREFABS.Wall_urban_scenic_building_facade_city02 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY02"
}

PREFABS.Wall_urban_scenic_building_facade_city03 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY03"
}

PREFABS.Wall_urban_scenic_building_facade_city04 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY04"
}

PREFABS.Wall_urban_scenic_building_facade_city05 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY05"
}

PREFABS.Wall_urban_scenic_building_facade_city06 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY06"
}

PREFABS.Wall_urban_scenic_building_facade_city07 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY07"
}

PREFABS.Wall_urban_scenic_building_facade_city11 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY11"
}

PREFABS.Wall_urban_scenic_building_facade_city12 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY12"
}

PREFABS.Wall_urban_scenic_building_facade_city13 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY13"
}

PREFABS.Wall_urban_scenic_building_facade_city14 =
{
  template = "Wall_urban_scenic_building_facade_modwall_EPIC",
  texture_pack = "armaetus",

  tex_MODWALL2 = "CITY14"
}
