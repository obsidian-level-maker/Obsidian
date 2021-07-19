--
-- Disgusting eww pls
--

PREFABS.Joiner_infestation_caveout =
{
  file   = "joiner/gtd_infestation_simple.wad",
  map    = "MAP01",

  prob   = 150,

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit = "frame",

  solid_ents = false,

  tex_MIDVINE2 =
  {
    MIDVINE2 = 1,
    ZZWOLF10 = 10 -- invisibility tex
  },
}

PREFABS.Joiner_natural_caveout =
{
  template = "Joiner_infestation_caveout",

  prob = 200,
  theme = "!hell",

  flat_BLOOD1 = "GRASS1",
  flat_SFLR6_4 = "GRASS1",
  flat_SFLR6_1 = "FLOOR6_2",

  tex_SKSNAKE1 = "SP_ROCK1",
  tex_SKINEDGE = "SP_ROCK1",
  tex_SKSNAKE2 = "SP_ROCK1",
  tex_SKSPINE1 = "SP_ROCK1",

  thing_59 = 0,
  thing_63 = 0,
  thing_77 = 0,
  thing_78 = 0,

  tex_MIDVINE2 =
  {
    MIDVINE2 = 1,
    ZZWOLF10 = 10 -- invisibility tex
  },
}
