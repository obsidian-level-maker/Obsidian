PREFABS.Pillar_gtd_generic1 =
{
  file   = "decor/gtd_pillar_generic.wad",
  map    = "MAP01",

  prob   = 15000,

  skip_prob = 70,

  theme  = "!hell",
  env    = "building",

  where  = "point",
  size   = 112,
  height = 128,

  bound_z1 = 0,
  bound_z2 = 128,

  z_fit  = { 56,74 },

  tex_LITE5 =
  {
    LITE5 = 50,
    LITEBLU4 = 50,
    LITEBLU1 = 50,
  }
}

PREFABS.Pillar_gtd_generic1_hell =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP01",

  theme  = "hell",

  tex_LITE5 =
  {
    FIREBLU1 = 50,
    FIRELAVA = 50,
    FIREMAG1 = 50,
  }
}

PREFABS.Pillar_gtd_generic2 =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP02",

  theme  = "!hell",

  height = 192,
  bound_z2 = 192,
  z_fit = {72,122},

  tex_SILVER2 =
  {
    SILVER2 = 50,
    LITE3 = 50,
    LITEBLU4 = 50,
  }
}

PREFABS.Pillar_gtd_generic2_hell =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP02",

  theme  = "hell",

  height = 192,
  bound_z2 = 192,
  z_fit = {72,122},

  tex_SILVER2 =
  {
    FIRELAVA = 20,
    FIREMAG1 = 20,
  }
}

PREFABS.Pillar_gtd_generic3 =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP03",

  height = 96,
  bound_z2 = 96,
  z_fit = {24,74},

  theme = "any",
}

--

PREFABS.Pillar_gtd_generic1_2x =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP04",

  prob = 25000,
  skip_prob = 80,

  theme  = "!hell",

  size = 160,

  tex_LITE5 =
  {
    LITE5 = 50,
    LITEBLU4 = 50,
    LITEBLU1 = 50,
  }
}

PREFABS.Pillar_gtd_generic1_hell_2x =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP04",

  prob = 25000,
  skip_prob = 80,

  theme  = "hell",

  size = 160,

  tex_LITE5 =
  {
    FIREBLU1 = 50,
    FIRELAVA = 50,
    FIREMAG1 = 50,
  }
}

PREFABS.Pillar_gtd_generic1_4x =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP07",

  prob = 25000,
  skip_prob = 80,

  theme  = "!hell",

  size = 160,

  tex_LITE5 =
  {
    LITE5 = 50,
    LITEBLU4 = 50,
    LITEBLU1 = 50,
  }
}

PREFABS.Pillar_gtd_generic1_hell_4x =
{
  template = "Pillar_gtd_generic1",
  map      = "MAP07",

  prob = 25000,
  skip_prob = 80,

  theme  = "hell",

  size = 160,

  tex_LITE5 =
  {
    FIREBLU1 = 50,
    FIRELAVA = 50,
    FIREMAG1 = 50,
  }
}

PREFABS.Pillar_gtd_generic3_2x =
{
  map = "MAP06",
  template = "Pillar_gtd_generic1",

  prob = 25000,
  skip_prob = 80,

  theme = "any",

  size = 160,

  height = 96,
  bound_z2 = 96,
  z_fit = {24,74}
}

PREFABS.Pillar_gtd_generic3_4x =
{
  map = "MAP09",
  template = "Pillar_gtd_generic1",

  prob = 25000,
  skip_prob = 80,

  theme = "any",

  size = 160,

  height = 96,
  bound_z2 = 96,
  z_fit = {24,74}
}
