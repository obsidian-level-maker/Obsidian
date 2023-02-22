--
-- Fancy walls
--

PREFABS.Wall_raised_comp =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP01",

  prob   = 15,
  env   = "building",
  theme = "tech",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTALL =
  {
    COMPTALL = 3,
    COMPWERD = 3,
    SPACEW3 = 3,
    GRAY2 = 0.5,
    SILVER2 = 1,
    COMPBLUE = 1,
    PIPEWAL1 = 1,
    TEKGREN1 = 1,
    TEKBRON2 = 1,
    TEKGREN5 = 1,
    TEKLITE = 1,
    TEKLITE2 = 1,
  },

  on_liquids = "never",
}

PREFABS.Wall_grated_thing =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP02",

  prob   = 15,
  env   = "building",
  theme = "!hell",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTALL =
  {
    COMPTALL = 4,
    METAL5 = 2,
    BLAKWAL2 = 0.5,
    BROWN1 = 1,
    BROWN96 = 1,
    BROWNGRN = 1,
    STEPLAD1 = 1,
    TEKLITE = 1,
  },
}

PREFABS.Wall_inset =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP03",

  prob   = 15,
  env   = "building",
  theme = "!hell",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_COMPTALL =
  {
    COMPTALL = 5,
    COMPWERD = 5,
    GRAY4 = 0.5,
    STEPLAD1 = 0.5,
  },
}

PREFABS.Wall_vertical_light =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP04",

  prob   = 15,
  env   = "building",
  theme = "!hell",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_LITE5 =
  {
    LITE5 = 1,
    LITEBLU1 = 1,
    MODWALL4 = 0.5,
    TEKLITE = 1,
  },
}

PREFABS.Wall_vertical_double_light =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP05",

  prob   = 15,
  env   = "building",
  theme = "!hell",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",


  tex_LITE5 =
  {
    LITE5 = 1,
    LITEBLU1 = 1,
    TEKLITE = 1,
  },
}

PREFABS.Wall_raised_computer_2 =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP06",

  prob   = 15,
  env   = "building",
  theme = "tech",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  on_liquids = "never",

  tex_LITE5 =
  {
    LITE5 = 1,
    LITEBLU4 = 0.25,
  },

  tex_COMPTALL =
  {
    COMPTALL = 1,
    COMPWERD = 1,
    TEKLITE = 1,
    TEKLITE2 = 1,
    TEKGREN1 = 1,
  },
}

PREFABS.Wall_adorned_diag =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP07",

  prob   = 50,
  theme = "tech",
  env   = "building",

  where  = "diagonal",
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "stretch",
}

PREFABS.Wall_flat_accent =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP08",

  prob   = 15,
  theme = "tech",
  env   = "building",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_METAL3 =
  {
    METAL1 = 1,
    METAL2 = 1,
    METAL3 = 1,
    METAL4 = 1,
    METAL5 = 1,
  },
  tex_METAL4 =
  {
    METAL2 = 1,
    METAL3 = 1,
    METAL4 = 1,
    METAL5 = 1,
  },
}

  PREFABS.Wall_caged_pipes =
{
  file   = "wall/gtd_wall_tech_interior_1.wad",
  map    = "MAP09",

  prob   = 15,
  theme = "tech",
  env   = "building",

  where  = "edge",
  height = 128,
  deep   = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = "frame",
  z_fit = "top",

  tex_PIPEWAL1 =
  {
    PIPEWAL1 = 1,
    PIPEWAL2 = 1,
    PIPES = 1,
    PIPEWAL2 = 1,
    LITEBLU1 = 0.25,
    SHAWN1 = 1,
    TEKLITE = 1,
  },

  tex_MIDBARS3 =
  {
    MIDBARS3 = 2,
    MIDSPACE = 1,
  },

  tex_BROWN96 =
  {
    BROWN96 = 2,
    GRAY5 = 1,
    GRAY7 = 1,
    SHAWN2 = 1,
  },
}
