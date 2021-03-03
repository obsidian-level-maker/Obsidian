PREFABS.Wall_tech_teklitecomp_red =
{
  file   = "wall/gtd_wall_teklitecomp_set.wad",
  map    = "MAP01",

  prob   = 50,

  group = "gtd_wall_teklitecomp_red",

  where  = "edge",
  deep   = 16,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 104,112 },
}

PREFABS.Wall_tech_teklitecomp_red_console =
{
  template = "Wall_tech_teklitecomp_red",
  map = "MAP02",

  prob = 10,

  deep = 24,

  tex_COMPSTA3 =
  {
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
  },
}

PREFABS.Wall_tech_teklitecomp_red_diag =
{
  template = "Wall_tech_teklitecomp_red",
  map = "MAP10",

  where = "diagonal",
}

-- orange

PREFABS.Wall_tech_teklitecomp_orange =
{
  template = "Wall_tech_teklitecomp_red",

  group = "gtd_wall_teklitecomp_orange",

  tex_RDWAL01 = "COLLITE2",
  tex_TEKWALL8 = "TEKWALLE",
  flat_TEK1 = "TEK7",
}

PREFABS.Wall_tech_teklitecomp_orange_console =
{
  template = "Wall_tech_teklitecomp_red",
  map = "MAP02",

  prob = 10,

  group = "gtd_wall_teklitecomp_orange",

  deep = 24,

  tex_RDWAL01 = "COLLITE2",
  tex_TEKWALL8 = "TEKWALLE",
  flat_TEK1 = "TEK7",

  tex_COMPSTA3 =
  {
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
  },
}

PREFABS.Wall_tech_teklitecomp_orange_diag =
{
  template = "Wall_tech_teklitecomp_red",
  map = "MAP10",

  where = "diagonal",

  group = "gtd_wall_teklitecomp_orange",

  tex_RDWAL01 = "COLLITE2",
  tex_TEKWALL8 = "TEKWALLE",
  flat_TEK1 = "TEK7",
}

-- blue

PREFABS.Wall_tech_teklitecomp_blue =
{
  template = "Wall_tech_teklitecomp_red",

  group = "gtd_wall_teklitecomp_blue",

  tex_RDWAL01 = "COLLITE3",
  tex_TEKWALL8 = "TEKWALLB",
  flat_TEK1 = "TEK4",
}

PREFABS.Wall_tech_teklitecomp_blue_console =
{
  template = "Wall_tech_teklitecomp_red",
  map = "MAP02",

  prob = 10,

  group = "gtd_wall_teklitecomp_blue",

  deep = 24,

  tex_RDWAL01 = "COLLITE3",
  tex_TEKWALL8 = "TEKWALLB",
  flat_TEK1 = "TEK4",

  tex_COMPSTA3 =
  {
    COMPSTA3 = 1,
    COMPSTA4 = 1,
    COMPSTA5 = 1,
    COMPSTA6 = 1,
    COMPSTA7 = 1,
    COMPSTA8 = 1,
    COMPSTA9 = 1,
    COMPSTAA = 1,
  },
}

PREFABS.Wall_tech_teklitecomp_blue_diag =
{
  template = "Wall_tech_teklitecomp_red",
  map = "MAP10",

  where = "diagonal",

  group = "gtd_wall_teklitecomp_blue",

  tex_RDWAL01 = "COLLITE3",
  tex_TEKWALL8 = "TEKWALLB",
  flat_TEK1 = "TEK4",
}
