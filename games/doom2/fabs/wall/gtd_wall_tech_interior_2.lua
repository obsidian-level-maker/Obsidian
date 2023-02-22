--
-- Fancy walls
--

PREFABS.Wall_machine_inset =
{
  file   = "wall/gtd_wall_tech_interior_2.wad",
  map    = "MAP01",

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
    BROWNGRN = 2,
    LITE5 = 1,
    LITEBLU4 = 1,
  },

  tex_COMPTALL =
  {
    COMPTALL = 6,
    TEKWALL1 = 2,
    TEKWALL4 = 2,
    TEKLITE = 2,
    TEKLITE2 = 2,
    PIPES = 1,
    PIPEWAL1 = 1,
    PIPEWAL2 = 1,
  },

  tex_METAL4 =
  {
    METAL4 = 1,
    METAL2 = 0.5,
    METAL3 = 1,
    METAL5 = 1,
  },
}

PREFABS.Wall_liquid_tank =
{
  template = "Wall_machine_inset",
  map      = "MAP02",

  liquid   = true,

  z_fit   = "stretch",

  tex_METAL4 = "METAL4",
  tex_BROWNGRN = "BROWNGRN",
  tex_PIPE2 =
  {
    PIPE2 = 1,
    PIPES = 3,
    SHAWN2 = 1,
    TEKGREN1 = 3,
    TEKLITE = 1,
    TEKLITE2 = 1,
  },
}

PREFABS.Wall_double_light =
{
  template = "Wall_machine_inset",
  map      = "MAP03",

  tex_LITE3 =
  {
    LITE3 = 2,
    LITE5 = 1,
    LITEBLU4 = 0.5,
  },

  tex_LITEBLU1 =
  {
    LITEBLU1 = 4,
    COMPBLUE = 1,
    GRAY2 = 1,
    COMPWERD = 2,
    SILVER2 = 2,
    SPCDOOR1 = 0.5,
    SPCDOOR2 = 0.5,
    SPCDOOR3 = 1,
    SPCDOOR4 = 0.5,
  },
}

PREFABS.Wall_diag_sewer =
{
  file   = "wall/gtd_wall_tech_interior_2.wad",
  map    = "MAP04",

  prob   = 50,
  theme = "tech",
  env   = "building",

  liquid = true,

  where  = "diagonal",
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = "top",

  sound = "Water_Streaming",
}
