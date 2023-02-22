PREFABS.Decor_armaetus_2x2_terminal =
{
  file   = "decor/armaetus_terminals.wad",
  where  = "point",
  game   = "doom2",

  prob   = 7000,
  theme  = "tech",
  env    = "building",

  size   = 288,
  height = 72,

  bound_z1 = 0,
  bound_z2 = 72,
}

PREFABS.Decor_armaetus_2x2_terminal_smaller =
{
  template = "Decor_armaetus_2x2_terminal",
  map  = "MAP02",
  game = "doom2",

  prob = 5000,

  size = 176,
}

PREFABS.Decor_armaetus_2x2_terminal_doom1_tech =
{
  template = "Decor_armaetus_2x2_terminal",
  map  = "MAP01",
  game = "doom",
  theme = "tech",

  prob = 7500,

  tex_METAL2 = "COMPSPAN",
  tex_SPACEW3 = "COMPUTE3",
}

PREFABS.Decor_armaetus_2x2_terminal_doom1_deimos =
{
  template = "Decor_armaetus_2x2_terminal",
  map  = "MAP01",
  game = "doom",
  theme = "deimos",

  prob = 8000,

  tex_METAL2 = "COMPSPAN",
  tex_SPACEW3 = "COMPUTE3",
}

PREFABS.Decor_armaetus_2x2_terminal_doom1_tech_smaller =
{
  template = "Decor_armaetus_2x2_terminal",
  map  = "MAP02",
  game = "doom",
  theme = "tech",

  prob = 5500,

  size = 176,

  tex_METAL2 = "COMPSPAN",
  tex_SPACEW3 = "COMPUTE3",
}

PREFABS.Decor_armaetus_2x2_terminal_doom1_deimos_smaller =
{
  template = "Decor_armaetus_2x2_terminal",
  map  = "MAP02",
  game = "doom",
  theme = "deimos",

  prob = 6500,

  size = 176,

  tex_METAL2 = "COMPSPAN",
  tex_SPACEW3 = "COMPUTE3",
}
